//
//  ProfileUserViewController.m
//  iphoneLive
//
//  Created by 高翔 on 16/8/16.
//  Copyright © 2016年 cat. All rights reserved.
//

#define headViewH self.headView.frame.size.height
#define NavigationBarH 64

#import "ProfileUserViewController.h"
#import "ProfileUserCell.h"

@interface ProfileUserViewController () <UITableViewDelegate,UITableViewDataSource> {
    NSMutableArray<RecordedListModel *> *_recordedArr;
    CGFloat _translateTableViewTop;
}

@property (weak, nonatomic) IBOutlet UIView *headView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headViewTop;
@property (weak, nonatomic) IBOutlet UILabel *likesLab;
@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property (weak, nonatomic) IBOutlet UILabel *votesLab;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UIImageView *genderImage;
@property (weak, nonatomic) IBOutlet UILabel *levelLab;
@property (weak, nonatomic) IBOutlet UILabel *cityLab;
@property (weak, nonatomic) IBOutlet UILabel *autographLab;
@property (weak, nonatomic) IBOutlet UILabel *followingLab;
@property (weak, nonatomic) IBOutlet UILabel *livestreamsLab;
@property (weak, nonatomic) IBOutlet UILabel *followersLab;
@property (weak, nonatomic) IBOutlet UIImageView *topFirstImage;
@property (weak, nonatomic) IBOutlet UIImageView *topSecondImage;
@property (weak, nonatomic) IBOutlet UIImageView *topThirdImage;
@property (weak, nonatomic) IBOutlet UIButton *followBtn;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewTop;

@end

static NSString *const ProfileUserCellIdentifier = @"ProfileUserCell";

@implementation ProfileUserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _recordedArr = [NSMutableArray array];
    self.tableView.tableFooterView = [[UIView alloc] init];
    [self getDataFromNet];
    self.tableView.layer.masksToBounds = NO;
    if (self.popupModel) {
        [self updateViewFromPopupModel];
    } else {
        [HttpService getInfoWithUcuid:self.uid result:^(CommonReturn *commonReturn) {
            if (commonReturn.state == 1) {
                self.popupModel = [[PopupModel alloc] initWithDictionary:commonReturn.data];
                [self updateViewFromPopupModel];
            }
        }];
    }
    
    self.headView.backgroundColor = UIColorFromHexAlpha(col_btn_purple, 1.0f);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    _translateTableViewTop = self.tableViewTop.constant;
}

- (void)updateViewFromPopupModel {
    self.likesLab.text = [NSString stringWithFormat:@"%ld",(long)self.popupModel.likes];
    self.votesLab.text = self.popupModel.stars;
    [self.headImage sd_setImageWithURL:[NSURL URLWithString:self.popupModel.avatar]];
    self.nameLab.text = self.popupModel.userNickname;
    self.cityLab.text = [NSString stringWithFormat:@"%@ %@",self.popupModel.city,self.popupModel.province];
    self.autographLab.text = self.popupModel.signature;
    self.followingLab.text = [NSString stringWithFormat:@"%ld",(long)self.popupModel.attentionnum];
    self.livestreamsLab.text = [NSString stringWithFormat:@"%ld",(long)self.popupModel.liverecordnum];
    self.followersLab.text = [NSString stringWithFormat:@"%ld",(long)self.popupModel.fansnum];
    self.genderImage.image = [UIImage imageNamed:[Common getGenderImageNameWithType:self.popupModel.gender]];
    self.levelLab.text = self.popupModel.level;
    [self upDateFollowBtn];
}

#pragma mark - TableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _recordedArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ProfileUserCell *cell = [tableView dequeueReusableCellWithIdentifier:ProfileUserCellIdentifier];
    if (!cell) {
        NSArray *views = [[NSBundle mainBundle] loadNibNamed:ProfileUserCellIdentifier owner:nil options:nil];
        cell = [views objectAtIndex:0];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return _window_width;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (_recordedArr.count == 0) {
        return;
    }
    CGFloat deviation = scrollView.contentOffset.y +20;
    NSLog(@"%f",deviation);
    if (deviation <= 0) {
        self.headViewTop.constant = 0;
        return;
    }
    CGFloat headNeedTop = -deviation/2;
    if (headNeedTop <= -headViewH +NavigationBarH) {
        headNeedTop = -headViewH +NavigationBarH;
        [self.navigationController setNavigationBarHidden:NO];
    } else {
        [self.navigationController setNavigationBarHidden:YES];
    }
    self.headViewTop.constant = headNeedTop;
    
    CGFloat tableNeedTop = _translateTableViewTop - deviation;
    if (tableNeedTop < NavigationBarH) {
        tableNeedTop = NavigationBarH;
    } else if (tableNeedTop > _translateTableViewTop) {
        tableNeedTop = _translateTableViewTop;
    }
    self.tableViewTop.constant = tableNeedTop;
}

#pragma mark - Click
- (IBAction)backBtnClick:(UIButton *)sender {
    NSArray *viewcontrollers=self.navigationController.viewControllers;
    if (viewcontrollers.count > 1) {
        //push
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        //present
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }
}

- (IBAction)followBtnClick:(UIButton *)sender {
    [self setFollowAndUpdateFollowBtn];
}

#pragma mark - Net
- (void)getDataFromNet {
    NSString *uid = @"";
    if (self.popupModel.idField) {
        uid = self.popupModel.idField;
    } else {
        uid = self.uid;
    }
    [HttpService getLiveRecordWithAnchorId:uid result:^(CommonReturn *commonReturn) {
        if (commonReturn.state == 1) {
            [_recordedArr removeAllObjects];
            NSArray *tempArr = commonReturn.data[@"list"];
            for (NSDictionary *dict in tempArr) {
                RecordedListModel *model = [[RecordedListModel alloc] initWithDictionary:dict];
                [_recordedArr addObject:model];
            }
            [self.tableView reloadData];
        }
    }];
}

- (void)setFollowAndUpdateFollowBtn {
    [MBProgressHUD showError:@"Loading..."];
    [HttpService setFollowWithShowid:self.uid result:^(CommonReturn *commonReturn) {
        [MBProgressHUD hideHUD];
        if (commonReturn.state == 1) {
            [MBProgressHUD showSuccess:@"Success"];
            self.popupModel.isattention = !self.popupModel.isattention;
            [self upDateFollowBtn];
        } else {
            [MBProgressHUD showError:commonReturn.msg];
        }
    }];
}

- (void)upDateFollowBtn {
    self.followBtn.backgroundColor = UIColorFromHexAlpha(col_btn_green, 1.0f);

    if ([self.popupModel.idField isEqualToString:[Config getOwnID]]) {
        self.followBtn.hidden = YES;
    } else {
        if (self.popupModel.isattention == 1) {
            [self.followBtn setTitle:@"UnFollow" forState:UIControlStateNormal];
        } else {
            [self.followBtn setTitle:@"Follow" forState:UIControlStateNormal];
        }
    }
}
@end
