//
//  TopFansViewController.m
//  iphoneLive
//
//  Created by 王文贺 on 16/8/11.
//  Copyright © 2016年 cat. All rights reserved.
//

#import "TopFansViewController.h"
#import "TopFansCell.h"
#import "HttpService.h"
#import "Config.h"

#import "UIImageView+Networking.h"

@interface TopFansViewController ()<UITableViewDelegate, UITableViewDataSource, TopFansDelegate>
@property (weak, nonatomic) IBOutlet UITableView *topFanTableView;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (strong, nonatomic) NSMutableArray *topFansList;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIImageView *topHeadImgView;
@property (weak, nonatomic) IBOutlet UILabel *topNickNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *topContributeLabel;
@property (weak, nonatomic) IBOutlet UILabel *topNameLabel;
@property (weak, nonatomic) IBOutlet UIButton   *followBtn;
@property (weak, nonatomic) IBOutlet UIImageView *levelColorImg;
@property (weak, nonatomic) IBOutlet UILabel *levelLabel;
@property (weak, nonatomic) IBOutlet UIImageView *genderImg;

@end

@implementation TopFansViewController {
    NewLiveModel *liveModel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.topHeadImgView.layer.masksToBounds = YES;
    self.topHeadImgView.layer.cornerRadius = 39;
    [ViewModifierHelpers addGradientColorFadedSubLayerToView:self.topView hexColorStart:col_view_bg_drk_purple hexColorEnd:col_view_bg_lt_purple];
    [self.followBtn setTitle:@"Follow" forState:UIControlStateNormal];
    [self.followBtn setTitle:@"Following" forState:UIControlStateSelected];
    
    
    self.topNameLabel.text = liveModel.userNickname;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self loadGetCoinRecord];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

////////////////////////////////////////////
#pragma mark - pub - accessors / mutators
////////////////////////////////////////////
- (void)setCurrLiveModel:(NewLiveModel*)model
{
    liveModel = model;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.topFansList.count > 0) {
        return self.topFansList.count - 1;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *reusableCell = @"reusableCell";
    TopFansCell *cell = [tableView dequeueReusableCellWithIdentifier:reusableCell];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"TopFansCell" owner:nil options:nil] firstObject];
    }
    if (indexPath.row == 0) {
        cell.rankImageView.image = [UIImage imageNamed:@"2nd_place"];
        cell.rankLabel.hidden = YES;
    }
    if (indexPath.row == 1) {
        cell.rankImageView.image = [UIImage imageNamed:@"3rd_place"];
        cell.rankLabel.hidden = YES;
    }
    if (indexPath.row > 1) {
        cell.rankImageView.hidden = YES;
        cell.rankLabel.text = [NSString stringWithFormat:@"%li",2 + indexPath.row];
    }
    cell.delegate = self;
    cell.followButton.tag = indexPath.row + 200;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    CoinRecordModel *model = [[CoinRecordModel alloc] initWithDictionary:self.topFansList[indexPath.row + 1]];
    [cell loadData:model];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 75;
}

- (IBAction)pressBackButton:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)loadGetCoinRecord {
    [MBProgressHUD showMessage:@"Please wait..."];
    [HttpService getCoinRecordWithShowid:[Config getpersonInfoModel].idField  result:^(CommonReturn *commonReturn) {
        [MBProgressHUD hideHUD];
        if (commonReturn.state == 1) {
            self.topFansList = commonReturn.data[@"list"];
            dispatch_async(dispatch_get_main_queue(), ^{
                if (self.topFansList.count > 0) {
                    [self loadTopViewData];
                }
                [self.topFanTableView reloadData];
            });
        }

    }];
}

- (void)loadTopViewData {
    CoinRecordModel *model = [[CoinRecordModel alloc] initWithDictionary:self.topFansList[0]];
    
//    topNameLabel
    XLM_info(@"self.topFansList[0] model: %@", [model toDictionary].description);
    
    self.topNickNameLabel.text = model.userNickname;
    self.topContributeLabel.text = model.total;
    if (model.isattention == 0) {
        self.followBtn.selected = NO;
    }else {
        self.followBtn.selected = YES;
    }
    self.levelColorImg.image = [UIImage imageNamed:[Common getEllipseImageNameWithLevle:model.level]];
    self.levelLabel.text = model.level;
    self.genderImg.image = [UIImage imageNamed:[Common getGenderImageNameWithType:model.gender]];

    /* legacy */
    //[self.topHeadImgView sd_setImageWithURL:[NSURL URLWithString:model.avatar] placeholderImage:nil];
    /* _legacy */
    
    NSString *strImgUrl = model.avatar;
    [self.topHeadImgView setImageAsyncWithUrlString:strImgUrl
                                       placeholder:[UIImage imageNamed:f_imgNoPhoto]
                                         alternate:[UIImage imageNamed:f_imgNoPhoto]
                                     cacheLocation:nil
                                   completionBlock:^(BOOL succeeded, UIImage *image) {
                                       if (!succeeded) {
                                           XLM_warning(warn_get_img_url);
                                       }
                                   }];
}

- (IBAction)pressHeaderViewFollowBtn:(UIButton *)sender {
 
    if (self.topFansList.count != 0) {
        CoinRecordModel *model = [[CoinRecordModel alloc] initWithDictionary:self.topFansList[0]];
        [MBProgressHUD showMessage:@"waiting..."];
        [HttpService setFollowWithShowid:model.uid result:^(CommonReturn *commonReturn) {
            if (commonReturn.state == 1) {
                if (sender.selected) {
                    sender.selected = NO;
                }else{
                    sender.selected = YES;
                }
                [MBProgressHUD hideHUD];
            }else {
                [MBProgressHUD hideHUD];
                [MBProgressHUD showError:commonReturn.msg];
            }
            
        }];
    }
}

#pragma mark - TopFansDelegate
- (void)choseButton:(UIButton *)sender {
    if (self.topFansList.count != 0) {
        CoinRecordModel *model = [[CoinRecordModel alloc] initWithDictionary:self.topFansList[sender.tag - 200]];
        [MBProgressHUD showMessage:@"waiting..."];
        [HttpService setFollowWithShowid:model.uid result:^(CommonReturn *commonReturn) {
            if (commonReturn.state == 1) {
                if (sender.selected) {
                    sender.selected = NO;
                }else{
                    sender.selected = YES;
                }
                [MBProgressHUD hideHUD];
            }else {
                [MBProgressHUD hideHUD];
                [MBProgressHUD showError:commonReturn.msg];
            }
            
        }];
        
    }
}

@end
