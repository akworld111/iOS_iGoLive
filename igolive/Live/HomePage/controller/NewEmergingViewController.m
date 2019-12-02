//
//  NewEmergingViewController.m
//  igolive
//
//  Created by 高翔 on 16/9/16.
//  Copyright © 2016年 iGoLive LLC. All rights reserved.
//

#import "NewEmergingViewController.h"
#import "NewEmergingCell.h"
#import "SearchViewController.h"

@interface NewEmergingViewController () <UITableViewDelegate, UITableViewDataSource> {
    NSArray<NSString *> *_newEmergingTitle;
    NSArray<UIColor *> *_newEmergingBgColor;
    
    NSArray<ChannelModel *> *arrChannels;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation NewEmergingViewController

- (void)viewDidLoad {
    [super viewDidLoad];

//    [self getChannelsList];
    
    [self initTableView];
    [self refreshTableViewTimer:nil];
    
    [self initNav];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self getChannelsList];
}
- (void)initTableView {
    [self.tableView registerNib:[UINib nibWithNibName:@"NewEmergingCell" bundle:nil] forCellReuseIdentifier:kNewEmergingCellID];
    
    UIView *header = [[UIView alloc] init];
    header.frame = CGRectMake(0, 0, _window_width, _window_width/3.8);
    UIImageView *image = [[UIImageView alloc] init];
    image.image = [UIImage imageNamed:@"emerging_header"];
    image.frame = header.frame;
    [header addSubview:image];
    self.tableView.tableHeaderView = header;
}

- (void)initNav {
    UIImageView *image = ({
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.image = [UIImage imageNamed:@"title_logo"];
        CGFloat imagew = imageView.image.size.width/2;
        imageView.frame = CGRectMake((_window_width - imagew)/2, 28, imagew, imageView.image.size.height/2);
        imageView;
    });
    
    [self.navigationController.view addSubview:image];
    
// note_09.30.16: show search feature for sandbox only
#if run_sandbox_mode 
    //Search Button
    UIBarButtonItem *searchItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"search"] style:UIBarButtonItemStylePlain target:self action:@selector(onSearchButtonClick:)];
    
    self.navigationItem.rightBarButtonItem = searchItem;
#endif
}
- (void)refreshTableViewTimer:(NSTimer*)timer
{
    [self getChannelsList];
    
    [NSTimer scheduledTimerWithTimeInterval:channel_list_refresh_sec
                                     target:self
                                   selector:@selector(refreshTableViewTimer:)
                                   userInfo:nil // NSTimer.userInfo in selector fired
                                    repeats:NO];
}
- (void)getChannelsList
{
//    [MBProgressHUD showMessage:@"H Loading..."];
    [HttpController getChannelsListWithCallback:^(CommonReturn *cr) {
//        [MBProgressHUD hideHUD];
        
        if (cr.state == 1) {
            if (cr.ret == 0) {
                NSDictionary *dataDict = [ObjectTypeValidator nsdictionaryFromObject:cr.data];
                if (dataDict)
                {
                    id objArr = [dataDict objectForKey:kRespDataArr];
                    NSArray *dataArr = [ObjectTypeValidator nsarrayFromObject:objArr];
                    if (dataArr)
                    {
                        [self refreshChannelsArray:dataArr];
                    }
                    
                }
                //XLM_alert(@"cr.data: %@\n\n", dataDict.description);
            } else {
                [MBProgressHUD showError:@"Channel List failure!"];
            }
        } else {
            [MBProgressHUD showError:@"Channel List! Please check your internet!"];
        }
    }];
}
- (void)refreshChannelsArray:(NSArray*)arr
{
    if (!arr || arr.count < 1)
    {
        XLM_error(@"arr param is nil; returning w/o refreshing arrChannels");
        return;
    }
    
    arrChannels = nil;
    NSMutableArray<ChannelModel *> *mArr = [NSMutableArray arrayWithCapacity:arr.count];
    
    for (id obj in arr)
    {
        NSDictionary *dictChan = [ObjectTypeValidator nsdictionaryFromObject:obj];
        if (dictChan)
        {
            ChannelModel *chmodel = [[ChannelModel alloc] initWithDictionary:dictChan];
            [mArr addObject:chmodel];
        }
    }
    
    arrChannels = [NSArray arrayWithArray:mArr];
    [self.tableView reloadData];
}
- (BOOL)channelHasNewStreams:(ChannelModel*)channel
{
    for (ChannelModel *oldchan in arrChannels)
    {
        if (oldchan.nChId.intValue == channel.nChId.intValue
            && oldchan.streamCount.intValue != oldchan.streamCount.intValue)
        {
            return YES;
        }
    }
    
    return NO;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)onSearchButtonClick:(id)sender {
    SearchViewController *searchViewController = [[SearchViewController alloc] init];
    
    CATransition* transition = [CATransition animation];
    transition.duration = .45;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionFade;
    [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];

    [self presentViewController:searchViewController animated:YES completion:nil];
}

#pragma mark - tableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (arrChannels)
    {
        return arrChannels.count;
    }
    
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger indexnum = indexPath.item;
    ChannelModel *chmodel = [ObjectTypeValidator channelmodelFromObj:arrChannels[indexnum]];
    if (!chmodel || chmodel.streamCount.intValue < 1)
    {
        return 40;
    }
    
    return 195;
    
    /*
         150 = 0.82 * x // 150 comes from xib cell setting
         150/0.82 = ~183.0  // setting 195 above for a little exra padding
     */
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{    
    NSInteger indexnum = indexPath.item;
    ChannelModel *chmodel = [ObjectTypeValidator channelmodelFromObj:arrChannels[indexnum]];
    
    NewEmergingCell *cell = [tableView dequeueReusableCellWithIdentifier:kNewEmergingCellID forIndexPath:indexPath];
    
    if (!cell) {
        cell = [[NewEmergingCell alloc] initWithParentChannel:chmodel]; // validates parentChannel param
    }
    
    // only make request for initial channel streams if parent channel has not been set,
    //  or the channel's streams array is nil or empty
    if(![cell parentChannelSet] || [ObjectTypeValidator nsarrayIsNilOrEmpty:chmodel.arrStreams])
    {
        [cell setParentChannelInitStreamRequest:chmodel]; // validates parentChannel param
        [cell reloadDataWithType:reload];
    }
    else
    {
        [cell setParentChannelCellUpdate:chmodel]; // validates parentChannel param
    }
    
    [cell setCellViewProperties]; // sets background gradient color
    [cell setParentViewController:self]; // support for presenting LookLiveStreamViewController
    
    return cell;
}

@end
