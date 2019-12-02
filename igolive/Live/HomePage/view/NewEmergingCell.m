//
//  NewEmergingCell.m
//  igolive
//
//  Created by 高翔 on 16/9/16.
//  Copyright © 2016年 iGoLive LLC. All rights reserved.
//

#import "NewEmergingCell.h"
#import "NewEmergingCollectionViewCell.h"
#import "UIScrollView+SVPullToRefresh.h"

#import "LookLiveStreamViewController.h"

@interface NewEmergingCell () <UICollectionViewDelegate, UICollectionViewDataSource> {
    NSNumber *nChanId;
    
    UITableView *parentTableView;
    ChannelModel *parentChannel;
    NSIndexPath *thisIndexPath;
    
    UIViewController *parentViewController;
}
@end

@implementation NewEmergingCell

- (id)initWithParentChannel:(ChannelModel*)parent
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kNewEmergingCellID];
    if (self)
    {
        [self setParentChannel:parent];
    }
    
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.collectionView registerNib:[UINib nibWithNibName:kSquareCellReuseID bundle:nil] forCellWithReuseIdentifier:kSquareCellReuseID];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self setupPullToRefresh];
}
- (void)setParentChannel:(ChannelModel*)channel
{
    if (!channel)
    {
        XLM_error(@"channel is nil; returning without setting parentChannel or nChanId");
        return;
    }
    
    parentChannel = channel;
    nChanId = [NSNumber numberWithInt:parentChannel.nChId.intValue];
}
- (void)reloadDataWithType:(int)type {
    @synchronized(self){
        if (!nChanId || nChanId.intValue < 0)
        {
            XLM_error(@"nChanId is nil or less than 0; returning without making server request for any channel streams");
            return;
        }
        
        [HttpService getChannelForId:nChanId offset:parentChannel.arrStreamsOffset withResult:^(CommonReturn *commonReturn) {
            
            // kill pull to refresh animations
            if (type == reload) {
                [[self.collectionView pullToRefreshViewAtPosition:SVPullToRefreshPositionLeft] stopAnimating];
            } else {
                [[self.collectionView pullToRefreshViewAtPosition:SVPullToRefreshPositionRight] stopAnimating];
            }
            
            
            if (commonReturn.state == 1) {
                if (type == reload) {
                    parentChannel.arrStreams = [NSMutableArray array];
                }
                
                for (NSDictionary *dict in commonReturn.data) {
                    NewEmergingCollectionCellModel *model = [[NewEmergingCollectionCellModel alloc] initWithDictionary:dict];
                    [parentChannel.arrStreams addObject:model];
                    parentChannel.arrStreamsOffset++;
                }
                
                [self.collectionView reloadData];
            }
        }];
    }
}

- (void)setupPullToRefresh {
    __weak NewEmergingCell *weakSelf = self;
    
    [self.collectionView addPullToRefreshWithActionHandler:^{
        [weakSelf insertRowAtLeft];
    } position:SVPullToRefreshPositionLeft];
    
    [self.collectionView addPullToRefreshWithActionHandler:^{
        [weakSelf insertRowAtRight];
    } position:SVPullToRefreshPositionRight];
    
    for(SVPullToRefreshView *refreshView in self.collectionView.pullToRefreshViews) {
        refreshView.titleLabel.font = [UIFont boldSystemFontOfSize:13];
        refreshView.titleLabel.numberOfLines = 0;
    }
}
- (void)insertRowAtLeft {
    parentChannel.arrStreamsOffset = 0;
    [self reloadDataWithType:reload];
}

- (void)insertRowAtRight {
    [self reloadDataWithType:loadMore];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}


////////////////////////////////////////////
#pragma mark - collectionView
////////////////////////////////////////////
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return parentChannel.arrStreams.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NewEmergingCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kSquareCellReuseID forIndexPath:indexPath];
    if (!cell) {
        cell = [[NewEmergingCollectionViewCell alloc] init];
    }
    [cell updataWithModel:parentChannel.arrStreams[indexPath.row]];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    LookLiveStreamViewController *vc = [[LookLiveStreamViewController alloc] init];
    vc.liveModel = parentChannel.arrStreams[indexPath.row].liveModel;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    [parentViewController presentViewController:nav animated:YES completion:nil];
}
////////////////////////////////////////////
#pragma mark - pub - accessors / mutators
////////////////////////////////////////////
- (void)setCellViewProperties
{
    if (!parentChannel)
    {
        XLM_error(@"parentChannel is nil; failed to set background color");
        return;
    }
    
    self.titleLab.text = [NSString stringWithString:parentChannel.strChannelName];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.collectionView.backgroundColor = [UIColor clearColor]; // setting clear color in xib, defaults to black : /    
    

#if use_chan_list_grad_D2U // fade bottom to top (black to color)
    [ViewModifierHelpers addGradientColorDownUpFadedSubLayerToView:self.vBgColor hexColorStart:0x000000 hexColorEnd:parentChannel.channelColorInt];
#elif use_chan_list_grad_R2L // fade right to left (color to black)
    [ViewModifierHelpers addGradientColorRightLeftFadedSubLayerToView:self.vBgColor hexColorStart:parentChannel.channelColorInt hexColorEnd:0x000000];
#else
    [self.vBgColor setBackgroundColor:parentChannel.channelColor];
#endif
    
    
    // note_09.30.16: show stream count for stage_mode and sandbox_mode
    self.lblStreamCount.hidden = YES;
#ifdef show_chan_stream_cnt
    self.lblStreamCount.hidden = NO;
    
    // set stream count label
    int streamCnt = parentChannel.streamCount.intValue;
    if (streamCnt > 1 || streamCnt < 1) {
        self.lblStreamCount.text = [NSString stringWithFormat:@"<debug: %i streams>", streamCnt];
    }
    else {
        self.lblStreamCount.text = [NSString stringWithFormat:@"<debug: %i stream>", streamCnt];
    }
#endif
    
    
    /*
         required to refresh cell from previous parentChannel set to this re-usable cell
            NOTE: this causes the collection view to reset to the beginning (scrolled far left)
         
             WHAT'S THE SOLUTION TO THIS?
     */
    [self.collectionView reloadData];
    
//    [self setNeedsLayout];
//    [self setNeedsDisplay];
//    [self layoutIfNeeded];
}
- (BOOL)parentChannelSet
{
    return parentChannel;
}
- (void)setParentChannelCellUpdate:(ChannelModel*)channel
{
    [self setParentChannel:channel];
}
- (void)setParentChannelInitStreamRequest:(ChannelModel*)channel
{
    [self setParentChannel:channel];
}
- (void)setParentViewController:(UIViewController*)vc
{
    parentViewController = vc;
}


@end



