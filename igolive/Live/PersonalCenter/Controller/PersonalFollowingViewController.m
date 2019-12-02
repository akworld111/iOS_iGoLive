//
//  PersonalFollowingViewController.m
//  iphoneLive
//
//  Created by 王文贺 on 16/8/15.
//  Copyright © 2016年 cat. All rights reserved.
//

#import "PersonalFollowingViewController.h"
#import "FollowersCell.h"

@interface PersonalFollowingViewController ()<UITableViewDelegate, UITableViewDataSource,FollowersDelegate>
@property (weak, nonatomic) IBOutlet UITableView *personalFollowingTableView;
@property (strong, nonatomic) NSMutableArray *dataArray;
@property (strong, nonatomic) NSString * offSet;
@property (assign, nonatomic) NSInteger currentPage;

@end

@implementation PersonalFollowingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _dataArray = [NSMutableArray array];
    self.currentPage = 1;
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _window_width, 14)];
    self.personalFollowingTableView.tableHeaderView =view;
    self.personalFollowingTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [self loadNewData];
    }];
    [self.personalFollowingTableView.mj_header beginRefreshing];
    self.personalFollowingTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self loadMoreData];
    }];
  
}

#pragma mark - loadData
- (void)loadNewData
{
    self.currentPage = 1;
    [self.personalFollowingTableView.mj_footer resetNoMoreData];
    [self loadFollowingsWithoffset:@"0"];
}

- (void)loadMoreData
{
    self.currentPage++;
    [self loadFollowingsWithoffset:_offSet];
}
- (void)reloadDataOfTableView:(NSInteger)totalCount
{
    [self.personalFollowingTableView reloadData];
    if (self.personalFollowingTableView.mj_footer) {
        if (self.dataArray.count < totalCount)
            [self.personalFollowingTableView.mj_footer endRefreshing];
        else
            [self.personalFollowingTableView.mj_footer endRefreshingWithNoMoreData];
    }

    [self.personalFollowingTableView.mj_header endRefreshing];
}
- (void)loadFollowingsWithoffset:(NSString*)offset{
    if (_type==2) {
        self.navigationItem.title = @"Block List";
        [HttpService getBlackListResult:^(CommonReturn *commonReturn) {
            if (commonReturn.state == 1) {
                if (self.currentPage==1) {
                    [_dataArray removeAllObjects];
                }
                NSArray *tempArray = (NSArray*)commonReturn.data[@"blacklist"];
                if (tempArray.count>0) {
                    for (int i= 0; i<tempArray.count; i++) {
                        PopupModel *popModel = [[PopupModel alloc]initWithDictionary:tempArray[i]];
                        [_dataArray addObject:popModel];
                    }
                }
                _offSet = commonReturn.data[@"offset"];

            } else {
                [MBProgressHUD showError:commonReturn.msg];
            }
            [self reloadDataOfTableView:[commonReturn.data[@"total"] intValue]];

        }];
        
    }else{
        self.navigationItem.title = @"Your are Following . . .";
        [HttpService getFollowingsWithUcuid:[Config getOwnID] withoffSet:offset result:^(CommonReturn *commonReturn) {
            if (commonReturn.state == 1) {
                if (self.currentPage==1) {
                    [_dataArray removeAllObjects];
                }
                NSArray *tempArray = (NSArray*)commonReturn.data[@"attentions"];
                if (tempArray.count>0) {
                    for (int i= 0; i<tempArray.count; i++) {
                        PopupModel *popModel = [[PopupModel alloc]initWithDictionary:tempArray[i]];
                        [_dataArray addObject:popModel];
                    }
                }
                _offSet = commonReturn.data[@"offset"];

            } else {
                [MBProgressHUD showError:commonReturn.msg];
            }
            [self reloadDataOfTableView:[commonReturn.data[@"total"] intValue]];

        }];
    }
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    cell.delegate  = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    PopupModel *popModel = _dataArray[indexPath.row];
    cell.followingBtn.tag = indexPath.row+1;
    if(_type!=2){
        [cell.followingBtn setBackgroundImage:[UIImage imageNamed:@"blocked"] forState:UIControlStateNormal];
        [cell.followingBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [cell.followingBtn setTitle:@"Unblock" forState:UIControlStateNormal];
    } else {
        cell.followingBtn.selected = popModel.isattention==0?YES:NO;
    }
    [cell.headImage sd_setImageWithURL:[NSURL URLWithString:popModel.avatar] placeholderImage:[UIImage imageNamed:@"HeadDefault"]];
    cell.nickName.text = popModel.userNickname;
    cell.levelLabel.text = popModel.level;
    cell.gender.image = [UIImage imageNamed:[Common getGenderImageNameWithType:popModel.gender]];
    cell.backImage.image = [UIImage imageNamed:[Common getEllipseImageNameWithLevle:popModel.level]];
       return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 64;
}

- (void)choseFollowersButton:(UIButton *)sender {
    PopupModel *popModel = _dataArray[sender.tag-1];
    [self setFollowWithShowId:popModel.idField withButton:sender];
}
- (void)setFollowWithShowId:(NSString*)showid withButton:(UIButton*)sender {
    [MBProgressHUD showMessage:@"Please wait..."];
    if (_type==2) {
        [HttpService setBlockListWithBlockId:showid result:^(CommonReturn *commonReturn) {
            [MBProgressHUD hideHUD];
            if(commonReturn.state == 1){
                [_dataArray removeObjectAtIndex:sender.tag-1];
            }else{
                [MBProgressHUD showError:commonReturn.msg];
            }
            [self.personalFollowingTableView reloadData];
        }];
    } else {
        [HttpService setFollowWithShowid:showid result:^(CommonReturn *commonReturn) {
            [MBProgressHUD hideHUD];
            if(commonReturn.state == 1){
                [_dataArray removeObjectAtIndex:sender.tag-1];
            }else{
                [MBProgressHUD showError:commonReturn.msg];
            }
            [self.personalFollowingTableView reloadData];
        }];
    }
}
@end




