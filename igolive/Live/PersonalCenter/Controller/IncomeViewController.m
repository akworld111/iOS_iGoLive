//
//  IncomeViewController.m
//  iphoneLive
//
//  Created by 王文贺 on 16/8/15.
//  Copyright © 2016年 cat. All rights reserved.
//

#import "IncomeViewController.h"


@implementation IncomeViewController
{
    IBOutlet UIScrollView *scrollView;
    IBOutlet UILabel *starNumber;
    IBOutlet UILabel *moneyLabel;
    IBOutlet UILabel *hollywoodStars;
    IncomeModel *incomeModel;
    __weak IBOutlet UIButton *convertBtn;
    __weak IBOutlet UIView *headerView;
    __weak IBOutlet UIButton *cashOutBtn;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [HttpService getWithdrawWithResult:^(CommonReturn *commonReturn) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (commonReturn.state == 1) {
            
            incomeModel = [[IncomeModel alloc]initWithDictionary:commonReturn.data];
            starNumber.text = [Common countNumAndChangeformat: incomeModel.starsTotal];
            moneyLabel.text = [Common countNumAndChangeformat:[NSString stringWithFormat:@"$%ld",(long)incomeModel.canwithdraw]];
            hollywoodStars.text = [Common countNumAndChangeformat:incomeModel.stars];
            
        } else {
            
            [MBProgressHUD showError:commonReturn.msg];
        }
        
    } ];
    [ViewModifierHelpers addGradientColorFadedSubLayerToView:headerView hexColorStart:col_view_bg_drk_purple hexColorEnd:col_view_bg_lt_purple];
    [ViewModifierHelpers addGradientColorFadedSubLayerToView:convertBtn hexColorStart:col_recommend_head_drk_oj hexColorEnd:col_recommend_head_lt_oj];
    [ViewModifierHelpers addGradientColorFadedSubLayerToView:cashOutBtn hexColorStart:col_recommend_head_drk_oj hexColorEnd:col_recommend_head_lt_oj];
    convertBtn.layer.masksToBounds = YES;
    convertBtn.layer.cornerRadius = 25;
    cashOutBtn.layer.masksToBounds = YES;
    cashOutBtn.layer.cornerRadius = 25;

}

- (IBAction)convertToCoins:(id)sender {
    
}

- (IBAction)cashOut:(id)sender {
    
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:YES];
    [scrollView setContentSize:CGSizeMake(0, scrollView.contentSize.height)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (IBAction)pressBackBtn:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


@end
