//
//  RecommendedFollowingViewController.m
//  iphoneLive
//
//  Created by sdd on 16/8/16.
//  Copyright © 2016年 cat. All rights reserved.
//

#import "RecommendedFollowingViewController.h"
#import "FollowersCell.h"
#import "ProfileSetupViewController.h"

@interface RecommendedFollowingViewController ()<UITableViewDelegate,UITableViewDataSource,FollowersDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIButton *followAllButton;
@property (strong, nonatomic) IBOutlet UIButton *skipButton;
@property (strong, nonatomic) NSMutableArray *dataArray;
@property (strong, nonatomic) IBOutlet UIView *headView;

@end

@implementation RecommendedFollowingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _dataArray = [NSMutableArray array];
    [self getRecommend];
    [ViewModifierHelpers addGradientColorFadedSubLayerToView:self.headView hexColorStart:col_recommend_head_drk_oj hexColorEnd:col_recommend_head_lt_oj];
    
    self.followAllButton.backgroundColor = UIColorFromHexAlpha(col_btn_purple, 1.0f);
    //[ViewModifierHelpers addGradientColorFadedSubLayerToView:self.followAllButton hexColorStart:col_view_bg_lt_purple hexColorEnd:col_view_bg_drk_purple];
}

- (void)getRecommend {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [HttpService getRecommandList:^(CommonReturn *commonReturn) {

        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSArray *tempArray = commonReturn.data;
        for (int i=0; i<tempArray.count; i++) {
            NewLiveModel * newLiveModel = [[NewLiveModel alloc]initWithDictionary:tempArray[i]];
            [_dataArray addObject:newLiveModel];
        }
        [self.tableView reloadData];
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    self.navigationController.navigationBarHidden = YES;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FollowersCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FollowersCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"FollowersCell" owner:nil options:nil] firstObject];
    }
    cell.delegate = self;
    cell.backgroundColor = [UIColor whiteColor];
    cell.followingBtn.tag = indexPath.row+1;
    NewLiveModel * newLiveModel = _dataArray[indexPath.row];
    [cell.headImage sd_setImageWithURL:[NSURL URLWithString:newLiveModel.avatar] placeholderImage:[UIImage imageNamed:@"HeadDefault"]];
    cell.nickName.text = newLiveModel.userNickname;
    cell.levelLabel.text = newLiveModel.level;
    cell.gender.image = [UIImage imageNamed:[Common getGenderImageNameWithType:newLiveModel.gender]];
    cell.backImage.image = [UIImage imageNamed:[Common getEllipseImageNameWithLevle:newLiveModel.level]];
    if (newLiveModel.isattention==NO) {
        cell.followingBtn.selected = YES;
    }else{
        cell.followingBtn.selected = NO;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 64;
}

- (void)choseFollowersButton:(UIButton *)sender {
    
    NewLiveModel *model = _dataArray[sender.tag-1];
    [self setFollowWithShowId:model.idField withButton:sender];
}

- (void)setFollowWithShowId:(NSString*)showid withButton:(UIButton*)sender {
    [MBProgressHUD showMessage:@"Please wait..."];
    [HttpService setFollowWithShowid:showid result:^(CommonReturn *commonReturn) {
        [MBProgressHUD hideHUD];
        
        NewLiveModel *model = _dataArray[sender.tag-1];

        if(commonReturn.state == 1){
            if (sender.selected) {
                sender.selected = NO;
                model.isattention = YES;
            }else{
                sender.selected = YES;
                model.isattention = NO;
            }
            [_dataArray replaceObjectAtIndex:sender.tag-1 withObject:model];

        }else{
            [MBProgressHUD showError:commonReturn.msg];
        }
        
    }];
}

- (IBAction)followAll:(UIButton *)sender {
    NSMutableArray *showIdArray = [NSMutableArray array];
    if (_dataArray.count<=0) {
        [appDelegate showTabBarController];
        return;
    }
    for (int i=0; i<_dataArray.count; i++) {
        NewLiveModel *model = _dataArray[i];
        model.isattention = YES;
        [_dataArray replaceObjectAtIndex:i withObject:model];
        [showIdArray addObject:model.idField];
        
    }
    [self.tableView reloadData];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [HttpService setFollwAllWithShowIdArray:showIdArray result:^(CommonReturn *commonReturn) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (commonReturn.state==1) {
            [appDelegate showTabBarController];

        } else {
            [MBProgressHUD showError:commonReturn.msg];
        }
    }];
   
}

- (IBAction)skip:(id)sender {
   
    [appDelegate showTabBarController];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
