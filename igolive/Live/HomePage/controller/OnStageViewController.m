//
//  OnStageViewController.m
//  iphoneLive
//
//  Created by 王文贺 on 16/8/7.
//  Copyright © 2016年 cat. All rights reserved.
//

#import "OnStageViewController.h"
#import "HotCell.h"
#import "SFFocusViewLayout.h"
#import "LookLiveStreamViewController.h"

@interface OnStageViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, weak) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *stageList;

@end

static NSString *const hotCellIdentifier = @"HotCell";

@implementation OnStageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    

    
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.decelerationRate = UIScrollViewDecelerationRateFast;

    UINib *nib = [UINib nibWithNibName:@"HotCell" bundle:nil];
    [_collectionView registerNib:nib forCellWithReuseIdentifier:hotCellIdentifier];
    
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
- (void)loadRefreshComponent {
    __weak __typeof(self) weakSelf = self;
    
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf loadNewData];
    }];
    
    [self.collectionView.mj_header beginRefreshing];
}

- (void)loadNewData {
    __weak UICollectionView *weakCollectionView = self.collectionView;
    
    [HttpService getSearchAreaListWithResult:^(CommonReturn *commonReturn) {
        if (commonReturn.state == 1) {
            NSMutableArray *mutableArray = [NSMutableArray array];
            for (NSDictionary *dict in commonReturn.data) {
                [mutableArray addObject:[[NewLiveModel alloc] initWithDictionary:dict]];
            }
            self.stageList = mutableArray;
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakCollectionView reloadData];
            [weakCollectionView.mj_header endRefreshing];
        });
    }];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    //    self.collectionView.mj_footer.hidden = self.colors.count == 0;
    return [_stageList count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HotCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:hotCellIdentifier forIndexPath:indexPath];
    cell.backgroundColor = COLOR(70, 70, 70, 1.0);
    
    [cell loadData:_stageList[indexPath.row]];

    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    HotCell *hotCell =  (HotCell *)cell;
    
    NewLiveModel *model = _stageList[indexPath.row];
    [hotCell.headImgView sd_setImageWithURL:[NSURL URLWithString:model.avatar] placeholderImage:nil];
    hotCell.nameLabel.text = model.userNickname;
    hotCell.levelLabel.text = model.level;
    hotCell.genderImgView.image = [UIImage imageNamed:[Common getGenderImageNameWithType:model.gender]];
    hotCell.levelColorImgView.image = [UIImage imageNamed:[Common getEllipseImageNameWithLevle:model.level]];
//    hotCell.titleLabel.text = model.title;
    [hotCell.watchButton setTitle:model.nums forState:UIControlStateNormal];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    SFFocusViewLayout *layout = (SFFocusViewLayout *)collectionView.collectionViewLayout;
    
    CGFloat offset = layout.dragOffset * (CGFloat)indexPath.item;
    if (collectionView.contentOffset.y != offset) {
        [collectionView setContentOffset:CGPointMake(0, offset) animated:YES];
    } else {
        LookLiveStreamViewController *vc = [[LookLiveStreamViewController alloc] init];
        vc.liveModel = _stageList[indexPath.row];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
        [self presentViewController:nav animated:YES completion:nil];
    }
    
//    [self presentViewController:vc animated:YES completion:nil];
}

@end
