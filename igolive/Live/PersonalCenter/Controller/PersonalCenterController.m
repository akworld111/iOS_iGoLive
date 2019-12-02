//
//  PersonalCenterController.m
//  iphoneLive
//
//  Created by 王文贺 on 16/8/9.
//  Copyright © 2016年 cat. All rights reserved.
//

#import "PersonalCenterController.h"
#import "PersonalCeterCell.h"
#import "HttpService.h"
#import "SettingsViewController.h"
#import "CoinsViewController.h"
#import "TopFansViewController.h"
#import "FollowersViewController.h"
#import "PersonalFollowingViewController.h"
#import "IncomeViewController.h"
#import "LevelViewController.h"
#import "RecordedViewController.h"
#import "ProfileSetupViewController.h"

#import "UIImageView+Networking.h"

//#if run_release_mode
//
//#import "TermsViewController.h"
//#import "PrivacyViewController.h"
//
//#endif

@interface PersonalCenterController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UITableView *personalTableView;
@property (strong, nonatomic) NSArray *arrayImage;
@property (strong, nonatomic) NSArray *arrayContentName;
@property (strong, nonatomic) NSMutableArray *arrayContent;
@property (strong, nonatomic) PersonalInfoModel *model;
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *praiseCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;
@property (weak, nonatomic) IBOutlet UILabel *informationLabel;
@property (weak, nonatomic) IBOutlet UILabel *levelLabel;
@property (weak, nonatomic) IBOutlet UIImageView *sexImageView;
@property (weak, nonatomic) IBOutlet UILabel *inComeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *levelColorImgView;

@end

@implementation PersonalCenterController


- (void)viewDidLoad {
    
    [super viewDidLoad];

    self.arrayContent = [NSMutableArray array];
    self.arrayImage = @[@"Top_fans", @"level", @"star", @"Coin", @"Followers", @"Following", @"Recording_small", @"Settings"];
    self.arrayContentName = @[@"Top Fans", @"Level", @"Income", @"Coins", @"Followers", @"Following", @"Recorded Livestreams", @"Settings"];
    self.headImageView.layer.cornerRadius = 36;
    self.headImageView.layer.masksToBounds = YES;
    [ViewModifierHelpers addGradientColorFadedSubLayerToView:self.headerView hexColorStart:col_view_bg_drk_purple hexColorEnd:col_view_bg_lt_purple];
    
    
//#if run_release_mode
//    self.arrayContentName = nil;
//    self.arrayContentName = @[@"Coins", @"Terms & Conditions", @"Privacy", @"Log Out"];
//    _praiseCountLabel.hidden = YES;
//    _inComeLabel.hidden = YES;
//    _cityLabel.hidden = YES;
//    _informationLabel.hidden = YES;
//    self.btnEditProfile.hidden = YES;
//#endif
    
    self.lblBuildNumber.hidden = YES;
#ifdef show_build_num
    self.lblBuildNumber.hidden = NO;
    self.lblBuildNumber.text = [MiscUtilities getApplicationBuildNumber];
#endif
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [self initWithUserHome];
}


- (void)initWithUserHome{
    
//    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [HttpService getInfoWithUcuid:[Config getOwnID] result:^(CommonReturn *commonReturn) {
        if (commonReturn.state == 1) {
            if (commonReturn.data) {
                NSDictionary *dic = commonReturn.data;
                if (dic.count > 0) {
                    PersonalInfoModel* model = [[PersonalInfoModel alloc] initWithDictionary:dic];
                    self.model = model;
                    [Config savePersonInfoModel:model];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self loadTopViewData];
                        [self.personalTableView reloadData];
                    });
                }
            }
        }else {
            [MBProgressHUD showError:commonReturn.msg];
        }

    }];

}

- (void)loadTopViewData{
    
    self.praiseCountLabel.text = [NSString stringWithFormat:@"%ld",(long)self.model.likes];
    self.inComeLabel.text = self.model.stars;
    self.cityLabel.text = self.model.city;
    self.nickNameLabel.text = self.model.userNickname;
    self.levelLabel.text = self.model.level;

    [self.sexImageView sd_setImageWithURL:[NSURL URLWithString:[Common getGenderImageNameWithType:self.model.gender]] placeholderImage:[UIImage imageNamed:@"male_gender"]];
    self.informationLabel.text = self.model.signature;
    self.levelColorImgView.image = [UIImage imageNamed:[Common getEllipseImageNameWithLevle:self.model.level]];
    
    /* legacy */
    //[self.headImageView sd_setImageWithURL:[NSURL URLWithString:self.model.avatar] placeholderImage:[UIImage imageNamed:@"HeadDefault"]];
    /* _legacy */
    
    NSString *strImgUrl = self.model.avatar;
    [self.headImageView setImageAsyncWithUrlString:strImgUrl
                                       placeholder:[UIImage imageNamed:f_imgNoPhoto]
                                         alternate:[UIImage imageNamed:f_imgNoPhoto]
                                     cacheLocation:nil
                                   completionBlock:^(BOOL succeeded, UIImage *image) {
                                       if (!succeeded) {
                                           XLM_warning(warn_get_img_url);
                                       }
                                   }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
//#if run_release_mode
//    return 4;
//#endif
    
    return 8;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"PersonalCeterCell";
    PersonalCeterCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        NSArray* views = [[NSBundle mainBundle] loadNibNamed:@"PersonalCeterCell" owner:nil options:nil];
        cell = [views objectAtIndex:0];
    }
    
    cell.contentLabel.text = self.arrayContentName[indexPath.row];
    
    if (indexPath.row == 0 && self.model != nil) {
        cell.rightLabel.hidden = YES;
        
        if (self.model.coinrecord3.count > 0) {
            [cell.imageFansHead sd_setImageWithURL:[NSURL URLWithString:self.model.coinrecord3[0][@"avatar"]]];
            
            cell.imageFansHead.hidden = NO;
        }
    }else{
        cell.imageFansHead.hidden = YES;
        
    }
    
//#if !run_release_mode
    cell.image.image = [UIImage imageNamed:self.arrayImage[indexPath.row]];
    if (indexPath.row == 1 && self.model != nil) {
        cell.rightLabel.text = [NSString stringWithFormat:@"Lv. %@",self.model.level];
    }
    if (indexPath.row == 2 && self.model != nil) {
        cell.rightLabel.text = self.model.stars;
    }
    if (indexPath.row == 3 && self.model != nil) {
        cell.rightLabel.text = self.model.coin;
    }
    if (indexPath.row == 4 && self.model != nil) {
        cell.rightLabel.text = [NSString stringWithFormat:@"%li",(long)self.model.fansnum];
    }
    if (indexPath.row == 5 && self.model != nil) {
        cell.rightLabel.text = [NSString stringWithFormat:@"%li",(long)self.model.attentionnum];
    }
    if (indexPath.row == 6 && self.model != nil) {
        
    }
    if (indexPath.row != 4) {
        cell.followerImage.hidden = YES;
    }
    if (indexPath.row == 7) {
        cell.rightLabel.hidden = YES;
    }
//#endif
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 52;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
//#if run_release_mode
//    if (indexPath.row == 0) {//Coins
//        CoinsViewController *coinsViewController = [[CoinsViewController alloc] init];
//        //coinsViewController.coin = _model.coin;
//        coinsViewController.hidesBottomBarWhenPushed = YES;
//        
//        [self.navigationController pushViewController:coinsViewController animated:YES];
//    }else if (indexPath.row == 1) {
//        TermsViewController *termsViewController = [[TermsViewController alloc] init];
//        termsViewController.hidesBottomBarWhenPushed = YES;
//        
//        [self.navigationController pushViewController:termsViewController animated:YES];
//    } else if (indexPath.row == 2) {
//        PrivacyViewController *privacyViewController = [[PrivacyViewController alloc] init];
//        privacyViewController.hidesBottomBarWhenPushed = YES;
//        
//        [self.navigationController pushViewController:privacyViewController animated:YES];
//    } else if (indexPath.row == 3) {//Settings
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"Are you sure you want to log out?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
//        [alertView show];
//    }
//    
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    
//    return;
//#endif
    
    
    if (indexPath.row == 0) {
        TopFansViewController *topFansController = [[TopFansViewController alloc] init];
        topFansController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:topFansController animated:YES];
    }
    if (indexPath.row == 1) {
        LevelViewController *levelController = [[LevelViewController alloc] init];
        levelController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:levelController animated:YES];
    }
    if (indexPath.row == 2) {
        IncomeViewController *incomeController = [[IncomeViewController alloc] init];
        incomeController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:incomeController animated:YES];
    }
    if (indexPath.row == 3) {//Coins
        CoinsViewController *coinsViewController = [[CoinsViewController alloc] init];
        coinsViewController.hidesBottomBarWhenPushed = YES;
        
        [self.navigationController pushViewController:coinsViewController animated:YES];
    }
    if (indexPath.row == 4) {
        FollowersViewController *followersController = [[FollowersViewController alloc] init];
        followersController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:followersController animated:YES];
    }
    if (indexPath.row == 5) {
        PersonalFollowingViewController *personalFollowingController = [[PersonalFollowingViewController alloc] init];
        personalFollowingController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:personalFollowingController animated:YES];
    }
    if (indexPath.row == 6) {
        RecordedViewController *recordedController = [[RecordedViewController alloc] init];
        recordedController.hidesBottomBarWhenPushed = YES;
        recordedController.personalInfoModel = self.model;
        [self.navigationController pushViewController:recordedController animated:YES];
    }
    if (indexPath.row == 7) {//Settings
        SettingsViewController *settingController =[[SettingsViewController alloc] init];
        settingController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:settingController animated:YES];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        [Config clearProfile];
        
        UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"NewLogin" bundle:[NSBundle mainBundle]];
        UINavigationController *loginNavController = (UINavigationController*)[storyboard instantiateViewControllerWithIdentifier:@"NewLogin"];
        appDelegate.window.rootViewController = loginNavController;
    }
}
- (IBAction)changeInfoBtn:(UIButton *)sender {
    ProfileSetupViewController *profileSetupViewController = [[ProfileSetupViewController alloc] init];
    profileSetupViewController.hidesBottomBarWhenPushed = YES;
    profileSetupViewController.type = 1;
    profileSetupViewController.userModel = self.model;
    
    // 'NO' hides all fields except nick name and birthday
    //  default image will be set on server side
    [profileSetupViewController setEditMode:YES];
    
    [self.navigationController pushViewController:profileSetupViewController animated:YES];

}

@end
