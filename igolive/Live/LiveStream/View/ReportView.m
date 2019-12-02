//
//  ReportView.m
//  hollyWood
//
//  Created by 王文贺 on 16/8/6.
//  Copyright © 2016年 王文贺. All rights reserved.
//

#import "ReportView.h"

@interface ReportView () {
    BOOL unFirstLoad ;
}

typedef enum {
    AnchorToManager,
    AnchorToViewer,
    ManagerToAnchor,
    ManagerToManager,
    ManagerToViewer,
    ViewerToAnchor,
    ViewerToManager,
    ViewerToViewer
} ENUM_WatchType;

typedef enum {
    Anchor = 50,
    Manager  = 40,
    Viewer = 30
} ENUM_Authority;

typedef enum {
    OnlyProfileBtn = 0,
    ProfileAndFollow,
    ProfileAndFollowAndBlock,
    ProfileAndFollowAndUnBlock,
    AllAndManager,
    AllAndUnManager
} ENUM_ReportType;

@property (weak, nonatomic) IBOutlet UILabel *likesLab;
@property (weak, nonatomic) IBOutlet UILabel *starsLab;
@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UIImageView *genderImage;
@property (weak, nonatomic) IBOutlet UIImageView *ellipseImage;
@property (weak, nonatomic) IBOutlet UILabel *levelLab;
@property (weak, nonatomic) IBOutlet UILabel *cityLab;
@property (weak, nonatomic) IBOutlet UILabel *signatureLab;

@property (weak, nonatomic) IBOutlet UILabel *followingLab;
@property (weak, nonatomic) IBOutlet UILabel *livestreamsLab;
@property (weak, nonatomic) IBOutlet UILabel *followersLab;

@property (weak, nonatomic) IBOutlet UIImageView *firstTopImage;
@property (weak, nonatomic) IBOutlet UIImageView *secondTopImage;
@property (weak, nonatomic) IBOutlet UIImageView *thirdTopImage;

@property (weak, nonatomic) IBOutlet UILabel *noOneYetLab;

@property (weak, nonatomic) IBOutlet UIButton *profileBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *profileBtnLeading;
@property (weak, nonatomic) IBOutlet UIButton *followBtn;
@property (weak, nonatomic) IBOutlet UIButton *blockBtn;
@property (weak, nonatomic) IBOutlet UIButton *managerBtn;

@property (weak, nonatomic) IBOutlet UIButton *btnReport;
@property (weak, nonatomic) IBOutlet UIButton *btnClose;

@property (assign, nonatomic) ENUM_Authority myAuthority;
@property (assign, nonatomic) ENUM_Authority targetAuthority;
@property (assign, nonatomic) ENUM_WatchType watchType;
@property (assign, nonatomic) ENUM_ReportType reportType;

@end

@implementation ReportView {
    BOOL spinnerIsShown;
}

////////////////////////////////////////////////
#pragma mark - pub
////////////////////////////////////////////////
+ (instancetype)reportView {
    NSBundle *bundle = [NSBundle mainBundle];
    NSArray *objs = [bundle loadNibNamed:@"ReportView" owner:nil options:nil];
    return [objs lastObject];
}
- (void)awakeFromNib
{
    [super awakeFromNib];

    /* TODO: gradient color fade isn't working correctly */
    //[self.profileBtn setBackgroundColor:col_white];
    //[self.followBtn setBackgroundColor:col_white];
    //[self.blockBtn setBackgroundColor:col_white];
    //[self.managerBtn setBackgroundColor:col_white];
    
    [ViewModifierHelpers addGradientColorFadedSubLayerToView:self.profileBtn hexColorStart:col_btn_reportview_purp_lte hexColorEnd:col_btn_purple];
    [ViewModifierHelpers addGradientColorFadedSubLayerToView:self.followBtn hexColorStart:col_btn_reportview_purp_lte hexColorEnd:col_btn_purple];
    [ViewModifierHelpers addGradientColorFadedSubLayerToView:self.blockBtn hexColorStart:col_btn_reportview_purp_lte hexColorEnd:col_btn_reportview_purp_drk];
    [ViewModifierHelpers addGradientColorFadedSubLayerToView:self.managerBtn hexColorStart:col_btn_reportview_purp_lte hexColorEnd:col_btn_reportview_purp_drk];
}
- (void)updateView {
    spinnerIsShown = NO;
    if (!unFirstLoad) {
        unFirstLoad = YES;
        [self topFansImageAddTarget];
    }
    
    [self updateAuthority];
    [self getPopModelFromNetAndUpdateView];
}

////////////////////////////////////////////////
#pragma mark - priv
////////////////////////////////////////////////
- (void)showHUD {
    if (!spinnerIsShown)
    {
        [MBProgressHUD showHUDAddedTo:self animated:YES];
        spinnerIsShown = YES;
    }
}

- (void)showHUDMessage:(NSString*)msg {
    if (!spinnerIsShown)
    {
        [MBProgressHUD showMessage:msg];
        spinnerIsShown = YES;
    }
}

- (void)killHUD {
    if (spinnerIsShown)
    {
        [MBProgressHUD hideHUDForView:self animated:YES];
        spinnerIsShown = NO;
    }
}

- (void)killHUDMessage {
    if (spinnerIsShown)
    {
        [MBProgressHUD hideHUD];
        spinnerIsShown = NO;
    }
}

- (void)setReportView:(ReportView *)reportView {
    _reportView = reportView;
}

+ (instancetype)viewWithReportView:(ReportView *)reportView {
    ReportView *view = [self reportView];
    view.reportView = reportView;
    return reportView;
}

- (void)updateWatchTypeAndReportType {
    switch (self.myAuthority) {
        case Anchor:
            switch (self.targetAuthority) {
                case Manager:
                    self.watchType = AnchorToManager;
                    self.reportType = AllAndUnManager;
                    break;
                case Viewer:
                    self.watchType = AnchorToViewer;
                    self.reportType = AllAndManager;
                    break;
                default:
                    break;
            }
            break;
        case Manager:
            switch (self.targetAuthority) {
                case Anchor:
                    self.watchType = ManagerToAnchor;
                    self.reportType = ProfileAndFollow;
                    break;
                case Manager:
                    self.watchType = ManagerToManager;
                    self.reportType = ProfileAndFollow;
                    break;
                case Viewer:
                    self.watchType = ManagerToViewer;
                    self.reportType = ProfileAndFollowAndBlock;
                    break;
                default:
                    break;
            }
            break;
        case Viewer:
            switch (self.targetAuthority) {
                case Anchor:
                    self.watchType = ViewerToAnchor;
                    //self.reportType = ProfileAndFollow;
                    self.reportType = ProfileAndFollowAndBlock;
                    break;
                case Manager:
                    self.watchType = ViewerToManager;
                    self.reportType = ProfileAndFollow;
                    break;
                case Viewer:
                    self.watchType = ViewerToViewer;
                    //self.reportType = ProfileAndFollow;
                    self.reportType = ProfileAndFollowAndBlock;
                    break;
                default:
                    break;
            }
            break;
        default:
            break;
    }
    [self updateAuthorityView];
}

- (void)updateAuthorityView {
    self.profileBtn.hidden = NO;
    switch (self.reportType) {
        case OnlyProfileBtn:
            self.followBtn.hidden = YES;
            self.blockBtn.hidden = YES;
            self.managerBtn.hidden = YES;
            break;
        case ProfileAndFollow:
            self.followBtn.hidden = NO;
            self.blockBtn.hidden = YES;
            self.managerBtn.hidden = YES;
            break;
        case ProfileAndFollowAndBlock:
            self.followBtn.hidden = NO;
            self.blockBtn.hidden = NO;
            self.managerBtn.hidden = YES;
            break;
        case ProfileAndFollowAndUnBlock:
            self.followBtn.hidden = NO;
            self.blockBtn.hidden = NO;
            self.managerBtn.hidden = YES;
            break;
        case AllAndManager:
            self.followBtn.hidden = NO;
            self.blockBtn.hidden = NO;
            self.managerBtn.hidden = NO;
            break;
        case AllAndUnManager:
            self.followBtn.hidden = NO;
            self.blockBtn.hidden = NO;
            self.managerBtn.hidden = NO;
            break;
        default:
            break;
    }
    if (self.reportType == OnlyProfileBtn) {
        self.profileBtnLeading.constant = 71;
    } else {
        self.profileBtnLeading.constant = 12;
    }
    
    if (self.reportType != OnlyProfileBtn) {
        if (self.popupModel.isattention == 1) {
            [self.followBtn setTitle:@"UnFollow" forState:UIControlStateNormal];
        } else {
            [self.followBtn setTitle:@"Follow" forState:UIControlStateNormal];
        }
    }
    
    if (self.blockBtn.hidden == NO) {
        //[self getIsShutUpAndUpdateBlockBtn]; // legacy
        [self getIsBlocked];
    }
}

- (void)updateAuthority {
    if ([[Config getOwnID] isEqualToString:self.targetuid]) {
        self.reportType = OnlyProfileBtn;
        [self updateAuthorityView];
    } else {
        [self showHUD];
        [HttpService getIsAdminWithUid:[Config getOwnID] showid:self.showid result:^(CommonReturn *commonReturn) {
            if (commonReturn.state == 1) {
                self.myAuthority = [commonReturn.data intValue];
                [HttpService getIsAdminWithUid:self.targetuid showid:self.showid result:^(CommonReturn *commonReturn) {
                    [self killHUD];
                    self.targetAuthority = [commonReturn.data intValue];
                    [self updateWatchTypeAndReportType];
                }];
            }
        }];
    }
}

- (void)updateViewFromPopupModel {
    self.likesLab.text = [NSString stringWithFormat:@"%ld",(long)self.popupModel.likes];
    self.starsLab.text = self.popupModel.stars;
    [self.headImage sd_setImageWithURL:[NSURL URLWithString:self.popupModel.avatar]];
    self.nameLab.text = self.popupModel.userNickname;
    self.cityLab.text = [NSString stringWithFormat:@"%@ %@",self.popupModel.city,self.popupModel.province];
    self.signatureLab.text = self.popupModel.signature;
    self.followingLab.text = [NSString stringWithFormat:@"%ld",(long)self.popupModel.attentionnum];
    self.livestreamsLab.text = [NSString stringWithFormat:@"%ld",(long)self.popupModel.liverecordnum];
    self.followersLab.text = [NSString stringWithFormat:@"%ld",(long)self.popupModel.fansnum];
    self.genderImage.image = [UIImage imageNamed:[Common getGenderImageNameWithType:self.popupModel.gender]];
    self.levelLab.text = self.popupModel.level;
    self.ellipseImage.image = [UIImage imageNamed:[Common getEllipseImageNameWithLevle:self.popupModel.level]];
    
    [self setUserBlockedState:_popupModel.isblack];
    
    if (self.popupModel.coinrecord3.count == 0) {
        self.firstTopImage.hidden   = YES;
        self.secondTopImage.hidden  = YES;
        self.thirdTopImage.hidden   = YES;
        self.noOneYetLab.hidden     = NO;
    } else if (self.popupModel.coinrecord3.count == 1) {
        self.firstTopImage.hidden   = NO;
        [self.firstTopImage sd_setImageWithURL:[NSURL URLWithString:self.popupModel.coinrecord3[0][@"avatar"]] placeholderImage:[UIImage imageNamed:@"HeadDefault"]];
        self.secondTopImage.hidden  = YES;
        self.thirdTopImage.hidden   = YES;
        self.noOneYetLab.hidden     = YES;
    } else if (self.popupModel.coinrecord3.count == 2) {
        self.firstTopImage.hidden   = NO;
        [self.firstTopImage sd_setImageWithURL:[NSURL URLWithString:self.popupModel.coinrecord3[0][@"avatar"]] placeholderImage:[UIImage imageNamed:@"HeadDefault"]];
        self.secondTopImage.hidden  = NO;
        [self.secondTopImage sd_setImageWithURL:[NSURL URLWithString:self.popupModel.coinrecord3[1][@"avatar"]] placeholderImage:[UIImage imageNamed:@"head_light"]];
        self.thirdTopImage.hidden   = YES;
        self.noOneYetLab.hidden     = YES;
    } else if (self.popupModel.coinrecord3.count == 3) {
        self.firstTopImage.hidden   = NO;
        [self.firstTopImage sd_setImageWithURL:[NSURL URLWithString:self.popupModel.coinrecord3[0][@"avatar"]] placeholderImage:[UIImage imageNamed:@"HeadDefault"]];
        self.secondTopImage.hidden  = NO;
        [self.secondTopImage sd_setImageWithURL:[NSURL URLWithString:self.popupModel.coinrecord3[1][@"avatar"]] placeholderImage:[UIImage imageNamed:@"head_light"]];
        self.thirdTopImage.hidden   = NO;
        [self.thirdTopImage sd_setImageWithURL:[NSURL URLWithString:self.popupModel.coinrecord3[2][@"avatar"]] placeholderImage:[UIImage imageNamed:@"head_dark"]];
        self.noOneYetLab.hidden     = YES;
    }
}

- (void)setUserBlockedState:(BOOL)blocked {
    if (blocked) {
        [self.blockBtn setTitle:@"UnBlock" forState:UIControlStateNormal];
    } else {
        [self.blockBtn setTitle:@"Block" forState:UIControlStateNormal];
    }
}

////////////////////////////////////////////////
#pragma mark - priv - Net
////////////////////////////////////////////////
- (void)getIsBlocked {
    [self showHUD];
    [HttpController getIsBlockedUserTargetId:self.targetuid callback:^(CommonReturn *cr) {
        [self killHUD];
        if (cr.state == 1) {
            NSDictionary *dDict = [ObjectTypeValidator nsdictionaryFromObject:cr.data];
            NSNumber *isBlocked = [ObjectTypeValidator SAFEnsnumberBoolFromObject:dDict[@"IsBlocked"]];
            _popupModel.isblack = isBlocked.boolValue;
            
            [self updateViewFromPopupModel];
        } else {
            [MBProgressHUD showError:cr.msg];
        }
    }];
}

- (void)updateUserBlockedStatus {
    [self showHUDMessage:@"Please wait..."];
    
    if (_popupModel.isblack) {
        [HttpController setUnblockedUserTargetId:self.targetuid callback:^(CommonReturn *cr) {
            [self killHUDMessage];
            
            /* debug logging */
            NSString *msg = [ObjectTypeValidator nsstringFromObject:cr.msg];
            XLM_warning(@"msg: %@", msg);
            /* _debug logging */
            
            if (cr.state == 1) {
                if (cr.ret == 0) {
                    _popupModel.isblack = NO;
                    [self updateViewFromPopupModel];
                    [MBProgressHUD showSuccess:@"Un-Blocked!"];
                } else {
                    [MBProgressHUD showError:@"Something went wrong, please try again"];
                }
            } else {
                [MBProgressHUD showError:cr.msg];
            }
        }];
    } else {
        [HttpController setBlockedUserTargetId:self.targetuid callback:^(CommonReturn *cr) {
            [self killHUDMessage];
            
            /* debug logging */
            NSString *msg = [ObjectTypeValidator nsstringFromObject:cr.msg];
            XLM_warning(@"msg: %@", msg);
            /* _debug logging */
            
            if (cr.state == 1) {
                // successful api return
                if (cr.ret == 0) {
                    _popupModel.isblack = YES;
                    [self updateViewFromPopupModel];
                    [MBProgressHUD showSuccess:@"Blocked!"];
                } else {
                    [MBProgressHUD showError:@"Something went wrong, please try again"];
                }
            } else {
                [MBProgressHUD showError:cr.msg];
            }
        }];
    }
}

- (void)getIsFollowingAndUpdateFollowingBtnWithShowSuccess:(BOOL)ShowSuccess {
    [MBProgressHUD showHUDAddedTo:self animated:YES];
    [HttpService getIsFollowingWithTouid:self.targetuid result:^(CommonReturn *commonReturn) {
        [MBProgressHUD hideHUDForView:self animated:YES];
        if (commonReturn.state == 1) {
            if (ShowSuccess) {
                [MBProgressHUD showSuccess:@"Success"];
            }
            if ([commonReturn.data intValue] == 1) {
                [self.followBtn setTitle:@"UnFollow" forState:UIControlStateNormal];
            } else {
                [self.followBtn setTitle:@"Follow" forState:UIControlStateNormal];
            }
        } else {
            [MBProgressHUD showError:commonReturn.msg];
        }
    }];
}

- (void)getIsShutUpAndUpdateBlockBtn {
    [self showHUD];
    [HttpService getIsShutUpWithUid:self.targetuid showid:self.showid result:^(CommonReturn *commonReturn) {
            [self killHUD];
            if (commonReturn.state == 1) {
                if ([commonReturn.data intValue] == 1) {
                    
                    if (self.blockBtn != nil) {
                        [self.blockBtn setTitle:@"UnBlock" forState:UIControlStateNormal];
                    } else {
                        // present pop error
                    }
                    
                } else {
                    [self.blockBtn setTitle:@"Block" forState:UIControlStateNormal];
                }
            } else {
                [MBProgressHUD showError:commonReturn.msg];
            }
    }];
}

- (void)getPopModelFromNetAndUpdateView {
    [self showHUD];
    [HttpService getInfoWithUcuid:self.showid result:^(CommonReturn *commonReturn) {
        [self killHUD];
        if (commonReturn.state == 1) {
            self.popupModel = [[PopupModel alloc] initWithDictionary:commonReturn.data];
            [self updateViewFromPopupModel];
        } else {
            [MBProgressHUD showError:commonReturn.msg];
        }
    }];
    
}

////////////////////////////////////////////////
#pragma mark - priv - xib binding
////////////////////////////////////////////////
- (IBAction)profileBtnClick:(UIButton *)sender {
    if (self.profileBtnClickBlock) {
        self.profileBtnClickBlock();
    }
}

- (IBAction)followBtnClick:(UIButton *)sender {
    [MBProgressHUD showHUDAddedTo:self animated:YES];
    
    [HttpService setFollowWithShowid:self.targetuid result:^(CommonReturn *commonReturn) {
        [MBProgressHUD hideHUDForView:self animated:YES];
        if (commonReturn.state == 1) {
            [self getIsFollowingAndUpdateFollowingBtnWithShowSuccess:YES];

            // note: self.followSuccess lambda function is null
            //  unless you click the anchor's report view
            if (self.followSuccess) {
                self.followSuccess();
            }
        } else {
            [MBProgressHUD showError:commonReturn.msg];
        }
    }];
}

- (IBAction)blockBtnClick:(UIButton *)sender {
    XL_enter();
    [self updateUserBlockedStatus];
}

- (IBAction)managerBtnClick:(UIButton *)sender {
}

- (IBAction)closeBtnClick:(UIButton *)sender {
    if (self.closeBtnClickBlock) {
        self.closeBtnClickBlock();
    }
}

- (IBAction)onBtnReportClick:(id)sender {
    if (self.reportBtnClickBlock) {
        self.reportBtnClickBlock();
    }
}

- (void)firstFanClick {
    if (self.firstFanClickBlock) {
        NSString *uid = self.popupModel.coinrecord3[0][@"uid"];
        self.firstFanClickBlock(uid);
    }
}

- (void)secondFanClick {
    if (self.firstFanClickBlock) {
        NSString *uid = self.popupModel.coinrecord3[1][@"uid"];
        self.firstFanClickBlock(uid);
    }
}

- (void)thirdFanClick {
    if (self.firstFanClickBlock) {
        NSString *uid = self.popupModel.coinrecord3[2][@"uid"];
        self.firstFanClickBlock(uid);
    }
}

//////////////////////////////////////////////////////
#pragma mark - priv - AlertViewHelpersDelegate
//////////////////////////////////////////////////////
- (void)alertCancelClicked {
    XL_enter();
}

- (void)alertSubmitClickedWithText:(NSString *)text {
    XL_enter();
    [MBProgressHUD showMessage:@"Please wait..."];
    [HttpService reportUserWithTargId:self.targetuid
                          description:text
                               result:^(CommonReturn *commonReturn) {
                                   [MBProgressHUD hideHUD];
                                   
                                   /**
                                    *  state from server side. 0=NO 1=OK
                                    *  message from server side
                                    */
                                   if(commonReturn.state == 1) {
                                       [MBProgressHUD showSuccess:commonReturn.msg];
                                       //[MBProgressHUD showSuccess:commonReturn.data[@"msg"]];
                                   } else {
                                       [MBProgressHUD showError:commonReturn.msg];
                                   }
                               }];
}

- (void)topFansImageAddTarget {
    UITapGestureRecognizer *firstTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(firstFanClick)];
    [self.firstTopImage addGestureRecognizer:firstTapGesture];
    UITapGestureRecognizer *secondTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(secondFanClick)];
    [self.secondTopImage addGestureRecognizer:secondTapGesture];
    UITapGestureRecognizer *thirdTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(thirdFanClick)];
    [self.thirdTopImage addGestureRecognizer:thirdTapGesture];
    
}
@end



