//
//  LivestreamSummaryViewController.m
//  iphoneLive
//
//  Created by 高翔 on 16/8/12.
//  Copyright © 2016年 cat. All rights reserved.
//

#import "LivestreamSummaryViewController.h"
#import "UIImageView+WebCache.h"
#import "UIImageView+Networking.h"

@interface LivestreamSummaryViewController ()

@property (nonatomic, weak) IBOutlet UILabel *nickNameLabel;
@property (nonatomic, weak) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UIButton *doneBtn;

@property (weak, nonatomic) IBOutlet UIView *topOneView;
@property (weak, nonatomic) IBOutlet UIView *topTwoView;
@property (weak, nonatomic) IBOutlet UIView *topThreeView;

@end

@implementation LivestreamSummaryViewController {
    PersonalInfoModel *perInfoModel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTopFansView];
    
    [self setInitialViewProperties];
    [self setInitialGradientFades];
    [self initAllFollowBtn];
        
    // set stream title
    self.lblStreamTitle.text = self.liveTitle ? : str_no_title;
    

}
- (void)viewWillAppear:(BOOL)animated
{
//    [self setTopFansView];
}
- (void)setTopFansView
{
    [MBProgressHUD showMessage:@"Please wait..."];
    [HttpService getInfoWithUcuid:[Config getOwnID] result:^(CommonReturn *commonReturn) {
        [MBProgressHUD hideHUD];
        if (commonReturn.state == 1) {
            if (commonReturn.data) {
                NSDictionary *dic = commonReturn.data;
                if (dic.count > 0) {
                    
                    perInfoModel = nil;
                    perInfoModel = [[PersonalInfoModel alloc] initWithDictionary:dic];
                    [Config savePersonInfoModel:perInfoModel];
                    
                    // set streamer static info
                    NSString *urlstr = perInfoModel.avatar;
                    [_headImageView sd_setImageWithURL:[NSURL URLWithString:urlstr]];
                    _nickNameLabel.text = perInfoModel.userNickname;
                    
                    // set new top fans avatar image
                    [self setImgAvatarTopFanNum:1];
                    [self setImgAvatarTopFanNum:2];
                    [self setImgAvatarTopFanNum:3];

                    // set streamer and top fans new stats as placeholders
                    [self updateStreamerAndFanStatsWithModel:perInfoModel];
                    
                    // note_09.08.16: where do we get this stream data from?
                    //self.lblUserHeartCoint.text = ?
                    //self.lblUserStreamViewsCount.text = ?
                }
                
                if (perInfoModel.coinrecord3.count == 0) {
                    self.topOneView.hidden = YES;
                    self.topTwoView.hidden = YES;
                    self.topThreeView.hidden = YES;
                } else if (perInfoModel.coinrecord3.count == 1) {
                    self.topOneView.hidden = NO;
                    self.topTwoView.hidden = YES;
                    self.topThreeView.hidden = YES;
                } else if (perInfoModel.coinrecord3.count == 2) {
                    self.topOneView.hidden = NO;
                    self.topTwoView.hidden = NO;
                    self.topThreeView.hidden = YES;
                } else if (perInfoModel.coinrecord3.count == 3) {
                    self.topOneView.hidden = NO;
                    self.topTwoView.hidden = NO;
                    self.topThreeView.hidden = NO;
                }
                
            }
        }else {
            [MBProgressHUD showError:commonReturn.msg];
        }
        
    }];
}
- (void)setImgAvatarTopFanNum:(int)num
{
    UIImageView *ivFan;
    NSString *urlFan;
    switch (num)
    {
        case 1:
            urlFan = perInfoModel.coinRecordFan1.avatar;
            ivFan = self.ivTopFan1Avatar;
            break;
        case 2:
            urlFan = perInfoModel.coinRecordFan2.avatar;
            ivFan = self.ivTopFan2Avatar;
            break;
        case 3:
            urlFan = perInfoModel.coinRecordFan3.avatar;
            ivFan = self.ivTopFan3Avatar;
            break;
        default:
            XLM_error(@"default case hit; failed to set avatar image for top fan num: %i; returning", num);
            return;
    }
    
    if (!urlFan)
    {
        XLM_error(@"urlFan is nil for fan num: %i; rerturning", num);
        return;
    }
    if (!ivFan)
    {
        XLM_error(@"ivFan is nil for fan num: %i; rerturning", num);
        return;
    }
    
    [ivFan setImageAsyncWithUrlString:urlFan
                          placeholder:[UIImage imageNamed:f_imgNoPhoto]
                            alternate:[UIImage imageNamed:f_imgNoPhoto]
                        cacheLocation:nil
                      completionBlock:^(BOOL succeeded, UIImage *image) {
                          if (!succeeded) {
                              XLM_warning(warn_get_img_url);
                          }
                      }];
}
- (void)updateStreamerAndFanStatsWithModel:(PersonalInfoModel*)model
{
    // set streamer's stats
    self.lblUserLevel.text = [ObjectTypeValidator SAFEnsstringFromObject:model.level];
    self.lblUserStarCount.text = [ObjectTypeValidator SAFEnsstringFromObject:model.stars];

    self.lblTopFan1.text = str_no_name;
    self.lblTopFan2.text = str_no_name;
    self.lblTopFan3.text = str_no_name;
    
    self.lblTopFan1Level.text = @"";
    self.lblTopFan2Level.text = @"";
    self.lblTopFan3Level.text = @"";
    
    NSMutableArray *mArrModels = [NSMutableArray arrayWithCapacity:3];
    
    // set top fans nick names and levels and add to array for button state if available
    if (model.coinRecordFan1)
    {
        self.lblTopFan1.text = [ObjectTypeValidator SAFEnsstringFromObject:model.coinRecordFan1.userNickname];
        self.lblTopFan1Level.text = [ObjectTypeValidator SAFEnsstringFromObject:model.coinRecordFan1.level];
        [mArrModels addObject:model.coinRecordFan1];
    }
    
    if (model.coinRecordFan2)
    {
        self.lblTopFan2.text = [ObjectTypeValidator SAFEnsstringFromObject:model.coinRecordFan2.userNickname];
        self.lblTopFan2Level.text = [ObjectTypeValidator SAFEnsstringFromObject:model.coinRecordFan2.level];
        [mArrModels addObject:model.coinRecordFan2];
    }
    
    if (model.coinRecordFan3)
    {
        self.lblTopFan3.text = [ObjectTypeValidator SAFEnsstringFromObject:model.coinRecordFan3.userNickname];
        self.lblTopFan3Level.text = [ObjectTypeValidator SAFEnsstringFromObject:model.coinRecordFan3.level];
        [mArrModels addObject:model.coinRecordFan3];
    }
    
    // set top fan button states (un-hide buttons of fans that are available)
    self.btnFollowFan1.hidden = YES;
    self.btnFollowFan2.hidden = YES;
    self.btnFollowFan3.hidden = YES;
    
    int btnIndex = 0;
    NSArray *arrbtns = @[self.btnFollowFan1, self.btnFollowFan2, self.btnFollowFan3];
    for (CoinRecordModel *model in mArrModels)
    {
        UIButton *btnFollow = (UIButton*)arrbtns[btnIndex];
        [btnFollow setSelected:model.isattention];
        btnFollow.hidden = NO;
        btnIndex++;
    }
}
- (void)setInitialViewProperties {
    [ViewModifierHelpers setCornerRadius:corn_rad_avatar forView:_headImageView];
    [ViewModifierHelpers setCornerRadius:corn_rad_avatar_small forView:self.ivTopFan1Avatar];
    [ViewModifierHelpers setCornerRadius:corn_rad_avatar_small forView:self.ivTopFan2Avatar];
    [ViewModifierHelpers setCornerRadius:corn_rad_avatar_small forView:self.ivTopFan3Avatar];
}
- (void)setInitialGradientFades
{
    [ViewModifierHelpers addGradientColorFadedSubLayerToView:self.view hexColorStart:col_view_bg_lt_purple hexColorEnd:col_view_bg_drk_purple];
    
    self.doneBtn.backgroundColor = UIColorFromHexAlpha(col_btn_green, 1.0f);
    //[ViewModifierHelpers addGradientColorFadedSubLayerToView:self.doneBtn hexColorStart:col_btnDone_drk_green hexColorEnd:col_btnDone_lt_green];
}

- (void)initAllFollowBtn {
    [self initFollowBtnWithBtn:self.btnFollowFan1];
    [self initFollowBtnWithBtn:self.btnFollowFan2];
    [self initFollowBtnWithBtn:self.btnFollowFan3];
}

- (void)initFollowBtnWithBtn:(UIButton *)btn {
    [btn setBackgroundImage:[UIImage imageNamed:@"follow"] forState:UIControlStateNormal];
    [btn setBackgroundImage:[MiscUtilities uiimagefromUIColor:[UIColor clearColor]] forState:UIControlStateSelected];

    [btn setTitle:@"Follow" forState:UIControlStateNormal];
    [btn setTitle:@"UnFollow" forState:UIControlStateSelected];
    [btn setTitleColor:[UIColor colorWithRed:114/255.0 green:209/255.0 blue:75/255.0 alpha:1] forState:UIControlStateSelected];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)doneBtnClick:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)followBtnClick:(UIButton *)sender {

    CoinRecordModel *coinrecModel;
    if (sender.tag == 100) {
        coinrecModel = perInfoModel.coinRecordFan1;
    } else if (sender.tag == 200) {
        coinrecModel = perInfoModel.coinRecordFan2;
    } else {
        coinrecModel = perInfoModel.coinRecordFan3;
    }
    
    [self setFollowWithShowId:coinrecModel.uid withButton:sender];
}

- (void)setFollowWithShowId:(NSString*)showid withButton:(UIButton*)sender {
    [MBProgressHUD showMessage:@"Please wait..."];
    [HttpService setFollowWithShowid:showid result:^(CommonReturn *commonReturn) {
        [MBProgressHUD hideHUD];
        
        if (commonReturn.state == 1) {
            [self updateFollowBtn:sender];
        } else {
            [MBProgressHUD showError:commonReturn.msg];
        }
    }];
}

- (void)updateFollowBtn:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        sender.layer.borderWidth = 1.5;
        sender.layer.borderColor = [UIColor colorWithRed:114/255.0 green:209/255.0 blue:75/255.0 alpha:1].CGColor;
    } else {
        sender.layer.borderWidth = 0;
    }
}
@end
