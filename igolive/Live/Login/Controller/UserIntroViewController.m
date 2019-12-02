//
//  UserIntroViewController.m
//  iphoneLive
//
//  Created by 王文贺 on 16/8/14.
//  Copyright © 2016年 cat. All rights reserved.
//

#import "UserIntroViewController.h"
#import "RecommendedFollowingViewController.h"

@interface UserIntroViewController ()

@property (strong, nonatomic) IBOutlet UILabel *fiveLabel;
@property (strong, nonatomic) IBOutlet UILabel *tenLabel;
@property (strong, nonatomic) IBOutlet UILabel *fifteenLabel;
@property (strong, nonatomic) IBOutlet UILabel *twentyLabel;
@property (strong, nonatomic) IBOutlet UILabel *twentyFiveLabel;
@property (strong, nonatomic) IBOutlet UILabel *thirtyLabel;

@end

@implementation UserIntroViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    [ViewModifierHelpers addGradientColorFadedSubLayerToView:self.headerView hexColorStart:col_view_bg_drk_purple hexColorEnd:col_view_bg_lt_purple];
//    [ViewModifierHelpers addGradientColorFadedSubLayerToView:self.gotItBtn hexColorStart:col_recommend_head_drk_oj hexColorEnd:col_recommend_head_lt_oj];
//    self.gotItBtn.layer.masksToBounds = YES;
//    self.gotItBtn.layer.cornerRadius = 25;
    self.fiveLabel.layer.borderWidth = 3;
    self.fiveLabel.layer.borderColor = COLOR(114, 209, 75, 1.0).CGColor;
    self.tenLabel.layer.borderWidth = 3;
    self.tenLabel.layer.borderColor = COLOR(114, 209, 75, 1.0).CGColor;
    self.fifteenLabel.layer.borderWidth = 3;
    self.fifteenLabel.layer.borderColor = COLOR(114, 209, 75, 1.0).CGColor;
    self.twentyLabel.layer.borderWidth = 3;
    self.twentyLabel.layer.borderColor = COLOR(114, 209, 75, 1.0).CGColor;
    self.twentyFiveLabel.layer.borderWidth = 3;
    self.twentyFiveLabel.layer.borderColor = COLOR(114, 209, 75, 1.0).CGColor;
    self.thirtyLabel.layer.borderWidth = 3;
    self.thirtyLabel.layer.borderColor = COLOR(114, 209, 75, 1.0).CGColor;

}
- (IBAction)gotItButtonClick:(id)sender {
    

    
    if (_first==1) {
        RecommendedFollowingViewController *recommendedFollowingViewController = [[RecommendedFollowingViewController alloc]init];
        recommendedFollowingViewController.first = _first;
        [self.navigationController pushViewController:recommendedFollowingViewController animated:YES];
    } else {
        [appDelegate showTabBarController];
    }
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.navigationController.navigationBarHidden =  YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
