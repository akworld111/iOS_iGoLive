//
//  FollowingViewController.m
//  iphoneLive
//
//  Created by 王文贺 on 16/8/6.
//  Copyright © 2016年 cat. All rights reserved.
//

#import "FollowingViewController.h"
#import "HomeViewController.h"
#import "OnStageCell.h"
#import <MJRefresh.h>
#import "HttpService.h"
#import "CommonReturn.h"
#import "LookLiveStreamViewController.h"

@interface FollowingViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *followingList;
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, weak) IBOutlet UIView *emptyView;

@property (weak, nonatomic) IBOutlet UIImageView *igoImageView;


@end

static NSString *const onStageCellIdentifier = @"OnStageCell";

@implementation FollowingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    

    
    [_tableView registerNib:[UINib nibWithNibName:@"OnStageCell" bundle:nil] forCellReuseIdentifier:onStageCellIdentifier];
    _tableView.backgroundView = _emptyView;
    _igoImageView.hidden = YES;
    [ViewModifierHelpers addGradientColorFadedSubLayerToView:self.seeLiveBtn hexColorStart:col_btnDone_drk_green hexColorEnd:col_btnDone_lt_green];
    _seeLiveBtn.layer.cornerRadius = 25;
    _seeLiveBtn.layer.masksToBounds = YES;
    self.followingList = [NSMutableArray array];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self loadRefreshComponent];
}

#pragma mark - Init refresh Component, get data from interface
- (void)loadRefreshComponent{
    __weak __typeof(self) weakSelf = self;
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf loadNewData];
    }];
    
    self.tableView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    
    // 马上进入刷新状态
    [_tableView.mj_header beginRefreshing];
}

- (void)loadNewData{
    _emptyView.hidden = YES;
    
    __weak UITableView *weakTableView = self.tableView;
    
    [HttpService getAttentionLiveWithResult:^(CommonReturn *commonReturn) {
        if (commonReturn.state == 1) {
            NSMutableArray *array = [NSMutableArray array];
            for (NSDictionary *dic in commonReturn.data[@"attentionlive"]) {
                [array addObject:[[AttentionLiveModel alloc] initWithDictionary:dic]];
            }
            self.followingList = array;
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!_followingList || [_followingList count] <= 0) {
                _tableView.backgroundView = _emptyView;
                _tableView.backgroundView.hidden = NO;
            }
            
            [weakTableView reloadData];
            [weakTableView.mj_header endRefreshing];
        });
    }];
}

- (void)loadMoreData{
    
}

#pragma mark - Button Action
//Go on stage page
- (IBAction)goFollowButton:(id)sender{
    
    if (appDelegate.mainTabBarController.viewControllers[0])
    {
        [appDelegate.mainTabBarController setSelectedIndex:0];
    }

}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_followingList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    OnStageCell *cell = [tableView dequeueReusableCellWithIdentifier:onStageCellIdentifier forIndexPath:indexPath];
    [cell loadData:_followingList[indexPath.row]];
    
    [cell.contentView setNeedsLayout];
    [cell.contentView layoutIfNeeded];
    
    return cell;
}

#pragma mark - Table view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    if (iPhone5) {
//        return 320.0f;
//    }
    
    return 375.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    LookLiveStreamViewController *vc = [[LookLiveStreamViewController alloc] init];
    vc.liveModel = _followingList[indexPath.row];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:nil];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}



@end
