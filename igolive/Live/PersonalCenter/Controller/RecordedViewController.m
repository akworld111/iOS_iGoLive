//
//  RecordedViewController.m
//  iphoneLive
//
//  Created by 王文贺 on 16/8/16.
//  Copyright © 2016年 cat. All rights reserved.
//

#import "RecordedViewController.h"
#import "RecordedCell.h"
#import "Config.h"

@interface RecordedViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *recordedTableView;

@property (nonatomic, strong) NSMutableArray *recordedList;

@end

@implementation RecordedViewController
static NSString * const cellIdentifier = @"RecordedCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"Recorded Livetreams";
    self.recordedTableView.backgroundColor = [UIColor whiteColor];
    [self loadRefresh];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadRefresh {
    self.recordedTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadLiveRecordedData];
    }];
    [self.recordedTableView.mj_header beginRefreshing];
}

- (void)loadLiveRecordedData {
    [HttpService getLiveRecordWithAnchorId:self.personalInfoModel.idField result:^(CommonReturn *commonReturn) {
        if (commonReturn.state == 1) {
            self.recordedList = commonReturn.data[@"list"];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.recordedTableView reloadData];
                [self.recordedTableView.mj_header endRefreshing];
            });
        }else{
            [self.recordedTableView.mj_header endRefreshing];
            [MBProgressHUD showError:commonReturn.msg];
        }

    }];
    
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.recordedList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RecordedCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"RecordedCell" owner:nil options:nil] firstObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    RecordedListModel *model = [[RecordedListModel alloc] initWithDictionary:self.recordedList[indexPath.row]];
    cell.titleLabel.text = model.title;
    cell.nickNameLabel.text = self.personalInfoModel.userNickname;
    [cell.headImgView sd_setImageWithURL:[NSURL URLWithString:self.personalInfoModel.avatar] ];
    cell.levelColorImgView.image = [UIImage imageNamed:[Common getEllipseImageNameWithLevle:self.personalInfoModel.level]];
    cell.genderImgView.image = [UIImage imageNamed:[Common getGenderImageNameWithType:self.personalInfoModel.level]];
    cell.levelLabel.text = self.personalInfoModel.level;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (iPhone5) {
        return 320;
    }
    return 375;
}

@end