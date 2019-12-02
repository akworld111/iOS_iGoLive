//
//  LevelViewController.m
//  iphoneLive
//
//  Created by 王文贺 on 16/8/16.
//  Copyright © 2016年 cat. All rights reserved.
//

#import "LevelViewController.h"

@interface LevelViewController ()
//@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *levelLabel;
@property (weak, nonatomic) IBOutlet UILabel *experienceLabel;
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (strong, nonatomic) LevelModel *model;
@property (strong, nonatomic) NSMutableArray *levelArray;
@property float levelRate;
@property (weak, nonatomic) IBOutlet UIView *progressView;
@property (weak, nonatomic) IBOutlet UIImageView *progressImgView;

@end

@implementation LevelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its
    [self.scrollView setContentSize:CGSizeMake(0, 0)];
    [self loadLevelData];
    [ViewModifierHelpers addGradientColorFadedSubLayerToView:self.headerView hexColorStart:col_view_bg_drk_purple hexColorEnd:col_view_bg_lt_purple];
    self.progressView.layer.cornerRadius = 5;
    self.progressView.layer.masksToBounds = YES;
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
}

- (void)loadLevelRate {
    [UIView animateWithDuration:0.5 animations:^{
        self.progressView.frame = CGRectMake(self.progressView.frame.origin.x, self.progressView.frame.origin.y, self.progressImgView.frame.size.width * self.levelRate, self.progressView.frame.size.height);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadLevelData{
    [HttpService getLevelWithResult:^(CommonReturn *commonReturn) {
        if (commonReturn.state == 1) {
            self.model = [[LevelModel alloc] initWithDictionary:commonReturn.data];
            self.levelLabel.text = [NSString stringWithFormat:@"Lv. %@",self.model.levelid];
            self.experienceLabel.text = [NSString stringWithFormat:@"Total EXP:%@",self.model.experience];
            self.levelRate = (float)self.model.levelRate/100;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self loadLevelRate];
            });
        }
    }];
}

- (IBAction)pressBackBtn:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end