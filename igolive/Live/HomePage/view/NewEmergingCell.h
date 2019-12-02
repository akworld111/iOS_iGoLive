//
//  NewEmergingCell.h
//  igolive
//
//  Created by 高翔 on 16/9/16.
//  Copyright © 2016年 iGoLive LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

#define reload 1
#define loadMore 2

@interface NewEmergingCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UILabel *lblStreamCount;
@property (weak, nonatomic) IBOutlet UIView *vBgColor;


- (id)initWithParentChannel:(ChannelModel*)parent;
- (void)setParentChannelCellUpdate:(ChannelModel*)channel;
- (void)setParentChannelInitStreamRequest:(ChannelModel*)channel;
- (BOOL)parentChannelSet;

- (void)reloadDataWithType:(int)type;

- (void)setCellViewProperties;
- (void)setParentViewController:(UIViewController*)vc;




@end

