//
//  FollowersViewController.m
//  iphoneLive
//
//  Created by 王文贺 on 16/8/14.
//  Copyright © 2016年 cat. All rights reserved.
//

#import "FollowersViewController.h"
#import "FollowersCell.h"

@interface FollowersViewController ()<UITableViewDelegate, UITableViewDataSource, FollowersDelegate>
@property (weak, nonatomic) IBOutlet UITableView *fowllowerTableView;
@property (strong, nonatomic)NSMutableArray *dataArray;
@property (strong, nonatomic)  UILabel *totalNum;
@property (strong, nonatomic) NSString* offset;
@property (assign, nonatomic) NSInteger currentPage;

@end

@implementation FollowersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _window_width, 14)];
    self.fowllowerTableView.tableHeaderView =view;
    _dataArray = [NSMutableArray array];
    self.title = @"Your Followers . . .";
    [self createTotalNum];
    self.fowllowerTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadNewData];
    }];
    [self.fowllowerTableView.mj_header beginRefreshing];
    self.fowllowerTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self loadMoreData];
    }];
}
#pragma mark - loadData
- (void)loadNewData
{
    self.currentPage = 1;
    [self.fowllowerTableView.mj_footer resetNoMoreData];
    [self loadGetFollowersWithoffset:@"0"];
}

- (void)loadMoreData
{
    self.currentPage++;
    [self loadGetFollowersWithoffset:_offset];
}

- (void)reloadDataOfTableView:(NSInteger)totalCount
{
    [self.fowllowerTableView reloadData];
    if (self.fowllowerTableView.mj_footer) {
        if (self.dataArray.count < totalCount)
            [self.fowllowerTableView.mj_footer endRefreshing];
        else
            [self.fowllowerTableView.mj_footer endRefreshingWithNoMoreData];
    }
    [self.fowllowerTableView.mj_header endRefreshing];
}

- (void)loadGetFollowersWithoffset:(NSString*)offset {
    
    [HttpService getFollowersWithoffset:offset ucuid:[Config getOwnID] result:^(CommonReturn *commonReturn) {
        if (commonReturn.state == 1) {
            if (self.currentPage==1) {
                [_dataArray removeAllObjects];
            }
            NSArray *tempArray = commonReturn.data[@"fans"];
            for (int i=0; i<tempArray.count; i++) {
                FollowModel *model = [[FollowModel  alloc]initWithDictionary:tempArray[i]];
                [_dataArray addObject:model];
            }
            _offset = commonReturn.data[@"offset"];
            _totalNum.text =  [Common countNumAndChangeformat:[NSString stringWithFormat:@"%@",commonReturn.data[@"total"]]];
        } else {
            [MBProgressHUD showError:commonReturn.msg];
        }
        [self reloadDataOfTableView:[commonReturn.data[@"total"] intValue]];

    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _totalNum.hidden = NO;
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    _totalNum.hidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)createTotalNum
{
    _totalNum = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-70, 16, 50, 16)];
    _totalNum.backgroundColor = COLOR(248, 178, 64, 1.0);
    _totalNum.textColor = [UIColor whiteColor];
    _totalNum.layer.masksToBounds = YES;
    _totalNum.layer.cornerRadius = 8;
    _totalNum.font = [UIFont systemFontOfSize:14];
    _totalNum.textAlignment = NSTextAlignmentCenter;
    [self.navigationController.navigationBar addSubview:_totalNum];
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
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    FollowModel *model = _dataArray[indexPath.row];
    cell.followingBtn.tag = indexPath.row+1;
    [cell.headImage sd_setImageWithURL:[NSURL URLWithString:model.avatar] placeholderImage:[UIImage imageNamed:@"HeadDefault"]];
    cell.nickName.text = model.userNickname;
    cell.levelLabel.text = model.level;
    cell.gender.image = [UIImage imageNamed:[Common getGenderImageNameWithType:model.gender]];
    cell.backImage.image = [UIImage imageNamed:[Common getEllipseImageNameWithLevle:model.level]];
    if (model.isattention == 0) {
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
    FollowModel *model = _dataArray[sender.tag-1];
    [self setFollowWithShowId:model.idField withButton:sender];
}

- (void)setFollowWithShowId:(NSString*)showid withButton:(UIButton*)sender {
    
    [MBProgressHUD showMessage:@"Please wait..."];
    [HttpService setFollowWithShowid:showid result:^(CommonReturn *commonReturn) {
        [MBProgressHUD hideHUD];
        FollowModel *model = _dataArray[sender.tag-1];
        if(commonReturn.state == 1){
            if (sender.selected) {
                sender.selected = NO;
                model.isattention = 1;
            }else{
                sender.selected = YES;
                model.isattention = 0;
            }
            [_dataArray replaceObjectAtIndex:sender.tag-1 withObject:model];
        }else{
            [MBProgressHUD showError:commonReturn.msg];
        }

    }];
}

@end
