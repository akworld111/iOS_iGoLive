//
//  EmergingViewController.m
//  iphoneLive
//
//  Created by christlee on 16/8/9.
//  Copyright © 2016年 cat. All rights reserved.
//

#import "EmergingViewController.h"
#import "EmergingCell.h"
#import "LookLiveStreamViewController.h"

@interface EmergingViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, weak) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *liveList;

@end

static NSString *const emergingCellIdentifier = @"EmergingCell";

@implementation EmergingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
  

    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake((SCREEN_WIDTH-4)/3, (SCREEN_WIDTH-4)/3);
//    layout.sectionInset = UIEdgeInsetsMake(4, 2, 2, 2);
    layout.minimumInteritemSpacing = 2;
    layout.minimumLineSpacing = 2;

    _collectionView.collectionViewLayout = layout;
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    
    UINib *nib = [UINib nibWithNibName:@"EmergingCell" bundle:nil];
    [_collectionView registerNib:nib forCellWithReuseIdentifier:emergingCellIdentifier];
    
    
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
    
    [HttpService getNewListWithResult:^(CommonReturn *commonReturn) {
        if (commonReturn.state == 1) {
            NSMutableArray *mutableArray = [NSMutableArray array];
            for (NSDictionary *dict in commonReturn.data) {
                [mutableArray addObject:[[NewLiveModel alloc] initWithDictionary:dict]];
            }
            self.liveList = mutableArray;
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
    return [_liveList count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    EmergingCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:emergingCellIdentifier forIndexPath:indexPath];
    cell.backgroundColor = COLOR(70, 70, 70, 1.0);
    
    NewLiveModel *model = _liveList[indexPath.row];
    [cell.headImgView sd_setImageWithURL:[NSURL URLWithString:model.avatar] placeholderImage:nil];
    cell.levelLabel.text = model.level;
    cell.genderImgView.image = [UIImage imageNamed:[Common getGenderImageNameWithType:model.gender]];
    cell.levelColorImgView.image = [UIImage imageNamed:[Common getEllipseImageNameWithLevle:model.level]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    LookLiveStreamViewController *vc = [[LookLiveStreamViewController alloc] init];
    vc.liveModel = _liveList[indexPath.row];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:nil];
}

@end
