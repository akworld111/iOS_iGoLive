//
//  LookLiveStreamViewController.m
//  iphoneLive
//
//  Created by 高翔 on 16/8/5.
//  Copyright © 2016年 cat. All rights reserved.
//

#import "LookLiveStreamViewController.h"
#import <libksygpulive/libksygpulive.h>
#import "AudienceModel.h"
#import <SDWebImage/UIButton+WebCache.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "ReportView.h"
#import "GiftsModel.h"
#import "GiftItem.h"
#import "TopFansViewController.h"
#import "ProfileUserViewController.h"
#import "LivestreamSummaryViewController.h"
#import "CoinsViewController.h"
#import "GiftExhibition.h"

#import "IGUtils.h"
#import "chatModel.h"
#import "chatcell.h"
#import "GrounderSuperView.h"

#import "UIImageView+Networking.h"
#import "UIImage+animatedGIF.h"
#import "NetworkRequestHelpers.h"
#import "UIViewController+LoadingView.h"

@interface LookLiveStreamViewController () < UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate > {
    BOOL _firstLoad;
    NSTimer *_entertimer;//进场动画计时器
    UIImageView *_imageVV;//进场动画imageview;
    UIView *_animationView;
    UIScrollView *_backScrollView;//上下滑屏切换
    
    NSTimer *_longPressTimer;
    
    NSMutableArray<GiftsModel *> *_giftsArray;
    NSMutableArray <GiftItem*> *arrGiftItems;
    
    BOOL _keyboardIsShow;
    ReportView *_reportView;
    NSMutableArray<RedisModel *> *_redisArray;
    AudienceModel *_audienceModel;
    
    GiftExhibition *_giftExhibition;
    
    //socket
    SocketIOClient *_chatSocket;
    __block BOOL connState;//nodejs连接状态
    BOOL isReConSocket;
    long long userCount;//用户数量
    NSTimer *heartbeatTime;
    NSString *titleColor;//判断 回复颜色
    NSMutableArray *msgList;
    int huifuOK;//判断回复
    int firstStar;// 第一次点亮
    GrounderSuperView *_barrageView;
    
    long _likeNum;
    
}

@property (weak, nonatomic) IBOutlet UIView *videoView;

@property (weak, nonatomic) IBOutlet UIView *interfaceView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *interfaceViewBottom;

@property (weak, nonatomic) IBOutlet UIView *authorInformationView;
@property (weak, nonatomic) IBOutlet UIImageView *anchorHead;
@property (weak, nonatomic) IBOutlet UILabel *anchorNameLab;
@property (weak, nonatomic) IBOutlet UILabel *onlineLabel;
@property (weak, nonatomic) IBOutlet UILabel *anchorLevelLab;
@property (weak, nonatomic) IBOutlet UILabel *anchorVotes;
@property (weak, nonatomic) IBOutlet UIImageView *anchorEllipseImage;
@property (weak, nonatomic) IBOutlet UIView *votesView;
@property (weak, nonatomic) IBOutlet UIImageView *anchorGenderimage;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *boostBtn;
@property (weak, nonatomic) IBOutlet UITextField *speakTextField;

@property (weak, nonatomic) IBOutlet UILabel *likesLab;
@property (weak, nonatomic) IBOutlet UIButton *heartBtn;
@property (weak, nonatomic) IBOutlet UIButton *giftBtn;
@property (weak, nonatomic) IBOutlet UIButton *followBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *followHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *giftBtnToFollowBtnSpace;

@property (weak, nonatomic) IBOutlet UIButton *shareBtn;
@property (weak, nonatomic) IBOutlet UIButton *sendBtn;

@property (weak, nonatomic) IBOutlet UIView *giftExhibitionBackground;
@property (weak, nonatomic) IBOutlet UIView *defaultView;
@property (weak, nonatomic) IBOutlet UIView *giftKeyboardView;
@property (weak, nonatomic) IBOutlet UIScrollView *giftKeyboardScrollView;

@property (weak, nonatomic) IBOutlet UIView *coinView;

@property (weak, nonatomic) IBOutlet UIView *shareView;

@property (weak, nonatomic) IBOutlet UIScrollView *audienceScrollView;
@property (weak, nonatomic) IBOutlet UIView *reportBackgroundView;

@property (weak, nonatomic) IBOutlet UILabel *coinLab;



//play
@property (strong, nonatomic) KSYMoviePlayerController *player;
@property (strong, nonatomic) NSURL *playUrl;


//copy
@property(nonatomic,strong)NSMutableArray *listArray;
@property(nonatomic,strong)NSMutableArray *chatModels;//模型数组
@property(nonatomic,copy)NSString *content;//聊天内容
@property(nonatomic,copy)NSString *tanChuangID;//弹窗用户的id
@property(nonatomic,strong)NSMutableArray *allArray;

@end

@implementation LookLiveStreamViewController {
    BOOL custAnim;
    NSTimer *loadStateTimer;
    BOOL isCloseDisconnect;
    BOOL mpPlaybackFinished;
}


////////////////////////////////////////////////////////////////
#pragma mark - priv - initializing
////////////////////////////////////////////////////////////////
- (void)viewDidLoad {
    _firstLoad = YES;
    custAnim = NO;
    isCloseDisconnect = NO;
    mpPlaybackFinished = NO;
    
    [super viewDidLoad];
    
    [self presentStreamLoadingViewWithCustomAnimation:custAnim];
    
    self.sendBtn.backgroundColor = UIColorFromHexAlpha(col_btn_green, 1.0f);
    [ViewModifierHelpers setTextField:self.speakTextField phColor:[UIColor lightGrayColor] textColor:[UIColor whiteColor]];
    
    [self initArray];
    [self initRecognizer];
    
    [self updateAudienceScrollView];
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    
    
    NSURL* url = [[NSURL alloc] initWithString:nodejs];
    
    /* note_09.15.16: legacy swift 2.2 support */
    //_chatSocket = [[SocketIOClient alloc] initWithSocketURL:url options:@{@"log": @NO,@"forcePolling":@YES,@"reconnects":@YES,@"reconnectWait":@1}];
    
    /* note_09.15.16: update for swift 2.3 support */
    _chatSocket = [[SocketIOClient alloc] initWithSocketURL:url config:@{@"log": @NO,@"forcePolling":@YES,@"reconnects":@YES,@"reconnectWait":@1}];
    
    [_chatSocket connect];
    
    [self getNodeJSInfo];
    [self getLikesFromNet];
    [self getRedislist];
    [self getGifts];
}

- (void)initArray {
    self.listArray = [NSMutableArray array];
    self.chatModels = [NSMutableArray array];
    self.allArray = [NSMutableArray array];
    msgList = [NSMutableArray array];
    _redisArray = [NSMutableArray array];
    _giftsArray = [NSMutableArray array];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    [self KSVidioPlay];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (heartbeatTime && heartbeatTime.isValid){
        [heartbeatTime invalidate];
        heartbeatTime = nil;
    }
    
    [self invalidateLoadStateTimer];

    [self updateFollingBtn];
    if (_firstLoad) {
        _firstLoad = NO;
        [self addNotification];
        [self initAllView];
    }
}

- (void)dismissViewControllerAnimated:(BOOL)flag completion:(void (^)(void))completion {
    [super dismissViewControllerAnimated:flag completion:completion];
    [_chatSocket disconnect];
}

- (void)viewWillDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

////////////////////////////////////////////////////////////////
#pragma mark - priv - observer / notification support
////////////////////////////////////////////////////////////////
- (void)setupObservers {
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(handlePlayerNotify:)
                                                name:(MPMediaPlaybackIsPreparedToPlayDidChangeNotification)
                                              object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(handlePlayerNotify:)
                                                name:(MPMoviePlayerPlaybackStateDidChangeNotification)
                                              object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(handlePlayerNotify:)
                                                name:(MPMoviePlayerPlaybackDidFinishNotification)
                                              object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(handlePlayerNotify:)
                                                name:(MPMoviePlayerLoadStateDidChangeNotification)
                                              object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(handlePlayerNotify:)
                                                name:(MPMovieNaturalSizeAvailableNotification)
                                              object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(closeBtnClick:)
                                                name:NOTIFY_LOADING_CLOSE
                                              object:nil];
}

- (void)releaseObservers {
    [[NSNotificationCenter defaultCenter]removeObserver:self
                                                   name:MPMediaPlaybackIsPreparedToPlayDidChangeNotification
                                                 object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self
                                                   name:MPMoviePlayerPlaybackStateDidChangeNotification
                                                 object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self
                                                   name:MPMoviePlayerPlaybackDidFinishNotification
                                                 object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self
                                                   name:MPMoviePlayerLoadStateDidChangeNotification
                                                 object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self
                                                   name:MPMovieNaturalSizeAvailableNotification
                                                 object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self
                                                   name:NOTIFY_LOADING_CLOSE
                                                 object:nil];
}

#pragma mark Recognizer
- (void)initRecognizer {
    UITapGestureRecognizer *anchorHeadTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(anchorHeadClick)];
    [self.anchorHead addGestureRecognizer:anchorHeadTapGesture];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(interfaceViewClick:)];
    [self.interfaceView addGestureRecognizer:tapGesture];
    
    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGesture:)];
    longPressGesture.minimumPressDuration = 0.5;
    [self.view addGestureRecognizer:longPressGesture];
    
    UITapGestureRecognizer *reportBackgroundViewTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(reportBackgroundViewTapGestureClick:)];
    [self.reportBackgroundView addGestureRecognizer:reportBackgroundViewTapGesture];
    
    UITapGestureRecognizer *votesTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(votesViewClick)];
    [self.votesView addGestureRecognizer:votesTapGesture];
    
    UITapGestureRecognizer *coinViewTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(coinViewClick)];
    [self.coinView addGestureRecognizer:coinViewTapGesture];
}
              
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Notification
- (void)addNotification {
    //增加监听，当键盘出现或改变时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    //增加监听，当键退出时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)keyboardWillShow:(NSNotification *)aNotification {
    _keyboardIsShow = YES;
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    int height = keyboardRect.size.height;
    self.interfaceViewBottom.constant = height;
    self.authorInformationView.hidden = YES;
    self.audienceScrollView.hidden = YES;
    [UIView animateWithDuration:0.3 animations:^{
        [self.interfaceView layoutIfNeeded];
    }];
}

- (void)keyboardWillHide:(NSNotification *)aNotification {
    self.authorInformationView.hidden = NO;
    self.audienceScrollView.hidden = NO;
    _keyboardIsShow = NO;
    self.interfaceViewBottom.constant = 0;
    [UIView animateWithDuration:0.3 animations:^{
        [self.interfaceView layoutIfNeeded];
    }];
}

////////////////////////////////////////////////////////////////
#pragma mark - priv - view updating support
////////////////////////////////////////////////////////////////
- (void)initAllView {
    self.speakTextField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 11, self.speakTextField.frame.size.height)];
    self.speakTextField.leftViewMode = UITextFieldViewModeAlways;
    
    _barrageView = [[GrounderSuperView alloc] initWithFrame:CGRectMake(0, 116, _window_width, 140)];
    _barrageView.userInteractionEnabled = NO;
    [self.view addSubview:_barrageView];
    
    _reportView = [ReportView reportView];
    _reportView.frame = CGRectMake((_window_width - 253)/2, (_window_height - 350)/2, 253, 350);
    //                                                                                254, 333
    __weak typeof(self) weakSelf = self;
    _reportView.closeBtnClickBlock = ^{
        weakSelf.reportBackgroundView.hidden = YES;
    };
    _reportView.profileBtnClickBlock = ^{
        ProfileUserViewController *vc = [[ProfileUserViewController alloc] init];
        vc.uid = _reportView.targetuid;
        vc.popupModel = _reportView.popupModel;
        [weakSelf.navigationController pushViewController:vc animated:YES];
    };
    _reportView.followSuccess = ^{
        [weakSelf updateFollingBtn];
    };
    _reportView.firstFanClickBlock = ^(NSString *uid){
        ProfileUserViewController *vc = [[ProfileUserViewController alloc] init];
        vc.uid = uid;
        [weakSelf.navigationController pushViewController:vc animated:YES];
    };
    _reportView.secondFanClickBlock = ^(NSString *uid){
        ProfileUserViewController *vc = [[ProfileUserViewController alloc] init];
        vc.uid = uid;
        [weakSelf.navigationController pushViewController:vc animated:YES];
    };
    _reportView.thirdFanClickBlock = ^(NSString *uid){
        ProfileUserViewController *vc = [[ProfileUserViewController alloc] init];
        vc.uid = uid;
        [weakSelf.navigationController pushViewController:vc animated:YES];
    };
    
    //__weak typeof(ReportView) *weakReportView = _reportView;
    __weak ReportView *weakReportView = _reportView;
    _reportView.reportBtnClickBlock = ^{
        [AlertViewHelpers presentAlertWithTextFieldPlaceholder:@"report description"
                                                         title:@"Report this user?"
                                                       message:@"Please describe why you are reporting this user"
                                                      parentVc:weakSelf
                                                helperDelegate:weakReportView];
    };
    [self.reportBackgroundView addSubview:_reportView];
    
    self.anchorHead.layer.cornerRadius = self.anchorHead.frame.size.width/2;
    self.anchorHead.layer.masksToBounds = YES;
    LiveUser *model = [Config myProfile];
    self.coinLab.text = [Config myProfile].coin;
    _giftExhibition = [[GiftExhibition alloc] init];
    _giftExhibition.frame = CGRectMake(0, 0, 200, 88);
    [self.giftExhibitionBackground addSubview:_giftExhibition];
}

- (void)updateView {
    self.anchorGenderimage.image = [UIImage imageNamed:[Common getGenderImageNameWithType:self.liveModel.gender]];
    self.anchorEllipseImage.image = [UIImage imageNamed:[Common getEllipseImageNameWithLevle:self.liveModel.level]];
    self.anchorNameLab.text = self.liveModel.userNickname;
    self.anchorLevelLab.text = self.liveModel.level;
    self.coinLab.text = _audienceModel.coin;
//    self.likesLab.text = _audienceModel.likes;
//    _likeNum = [_audienceModel.likes longLongValue];
    
    /* legacy */
    //[self.anchorHead sd_setImageWithURL:[NSURL URLWithString:self.liveModel.avatar]];
    
    /* eg */
    NSString *strImgUrl = self.liveModel.avatar;
    [self.anchorHead setImageAsyncWithUrlString:strImgUrl
                                    placeholder:[UIImage imageNamed:f_imgNoPhoto]
                                      alternate:[UIImage imageNamed:f_imgNoPhoto]
                                  cacheLocation:nil
                                completionBlock:^(BOOL succeeded, UIImage *image) {
                                    if (!succeeded) {
                                        XLM_warning(warn_get_img_url);
                                    }
                                }];
}

- (void)updateFollingBtn {
    [HttpService getIsFollowingWithTouid:self.liveModel.idField result:^(CommonReturn *commonReturn) {
        if (commonReturn.state == 1) {
            NSLog(@"%@",commonReturn.data);
            if ([commonReturn.data intValue] == 1) {
                self.followHeight.constant = 0;
                self.giftBtnToFollowBtnSpace.constant = 0;
            } else {
                self.followHeight.constant = 41;
                self.giftBtnToFollowBtnSpace.constant = 10;
            }
        }
    }];
}

- (void)updateAudienceScrollView {
    for (UIView *view in self.audienceScrollView.subviews) {
        [view removeFromSuperview];
    }
    
    CGFloat imageW = 32;
    CGFloat spacing = 6;
    CGFloat audienceScrollViewHeight = self.audienceScrollView.frame.size.height;
    for (int index = 0; index < _redisArray.count; index++) {
        RedisModel *model = _redisArray[index];
        UIImageView *image = [[UIImageView alloc] init];
        image.frame = CGRectMake(index*(imageW + spacing), (audienceScrollViewHeight - imageW)/2, imageW, imageW);
        [image sd_setImageWithURL:[NSURL URLWithString:model.avatar] placeholderImage:[UIImage imageNamed:@"HeadDefault"]];
        image.layer.masksToBounds = YES;
        image.layer.cornerRadius = imageW/2;
        image.userInteractionEnabled = YES;
        image.tag = 200 + index;
        [image setContentMode:UIViewContentModeScaleAspectFill];
        [self.audienceScrollView addSubview:image];
        
        switch (index) {
            case 0:{
                    UIImageView *rankingImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"1st"]];
                    rankingImage.frame = CGRectMake(index*(imageW + spacing) + 25, (audienceScrollViewHeight - imageW)/2 +20, 11, 15);
                [self.audienceScrollView addSubview:rankingImage];
                }
                break;
            case 1:{
                UIImageView *rankingImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"2nd"]];
                rankingImage.frame = CGRectMake(index*(imageW + spacing) + 25, (audienceScrollViewHeight - imageW)/2 +20, 11, 15);
                [self.audienceScrollView addSubview:rankingImage];
            }
                break;
            case 2:{
                UIImageView *rankingImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"3rd"]];
                rankingImage.frame = CGRectMake(index*(imageW + spacing) + 25, (audienceScrollViewHeight - imageW)/2 +20, 11, 15);
                [self.audienceScrollView addSubview:rankingImage];
            }
                break;
            default:
                break;
        }
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(audienceClick:)];
        [image addGestureRecognizer:tapGesture];
    }
    [self.audienceScrollView setContentSize:CGSizeMake(_redisArray.count*(imageW + spacing), audienceScrollViewHeight)];
}

- (void)updateGiftKeyboardView {
    for (UIView *view in self.giftKeyboardScrollView.subviews) {
        if (view.tag != 1024) {
            [view removeFromSuperview];
        }
    }
    if ([ObjectTypeValidator nsarrayIsNilOrEmpty:_giftsArray])
    {
        XLM_error(@"failed to update gift bottom keyboard view; _giftsArray is nil or empty");
        return;
    }
    
    
    // create scroll view for gift icon listing
    int pageCount = (int)_giftsArray.count / 8 ;
    pageCount += _giftsArray.count % 8 > 0;
    int nowPage = 0;
    for (int index = 0; index < _giftsArray.count; index++) {
        nowPage = index / 8;
        CGFloat buttonX = _window_width/4 * (index%4) + (nowPage * _window_width);
        int buttonY = index/4 - nowPage * 2;
        
        // initialize GiftItem and manually set the view frame
        GiftItem *giftItem = [[GiftItem alloc] init];
        giftItem.view.frame = CGRectMake(buttonX, buttonY*96, _window_width/4, 96);
        
        // set delegate for 'slideSold' invocation
        [giftItem.vGiftSlide setDelegate:self];
        
        // set view properties for this gift item object
        [self setPropertiesForGiftItem:giftItem withGiftArrayIndex:index];
        
        // add this giftItem object and it's views to the keyboard scroll view
        [self.giftKeyboardScrollView addSubview:giftItem.view];
    }
    
    // set interactive properties for the keyboard scroll view
    [self setPropertiesForGiftItemScrollview:self.giftKeyboardScrollView withPageCount:pageCount];
    
    self.defaultView.hidden = YES;
    self.giftKeyboardView.hidden = NO;
}

- (void)setPropertiesForGiftItemScrollview:(UIScrollView*)scrollview withPageCount:(int)pageCount {
    // allow subviews (giftItem views) to be touched and draggedout side of its bounds
    scrollview.clipsToBounds = NO; // can be set in xib ('Clip Subviews')
    
    // remove subviews touchesBegan delay (= NO)
    scrollview.delaysContentTouches = YES; // can be set in xib ('Delays Content Touches')
    
    // invokes subviews' touchesCancelled, if the user drags the finger enough to initiate a scroll
    scrollview.canCancelContentTouches = YES; // can be set in xib ('Cancellable Content Touches')
        
    [scrollview setContentSize:CGSizeMake(pageCount * _window_width, self.giftKeyboardScrollView.frame.size.height)];
}

- (void)setPropertiesForGiftItem:(GiftItem*)giftItem withGiftArrayIndex:(int)index {
    // set gift static view properies
    NSString *urlstr = _giftsArray[index].gifticon;
    [giftItem.ivGiftIcon sd_setImageWithURL:[NSURL URLWithString:urlstr]];
    giftItem.lblGiftPrice.text = _giftsArray[index].needcoin;
    
    giftItem.btnSendGift.tag = index;
    giftItem.vGiftSlide.slideViewTag = index;
    [giftItem.btnSendGift addTarget:self action:@selector(giftItemClick:) forControlEvents:UIControlEventTouchUpInside];
    
    // set gift slide view common properties (note: this is bad, making 2 network requests)
    [giftItem.ivGiftIconSlide sd_setImageWithURL:[NSURL URLWithString:urlstr]];
    giftItem.lblGiftPriceSlide.text = giftItem.lblGiftPrice.text;
    
    
    [giftItem.vGiftSlide setFrame:giftItem.view.bounds];
    
    if (arrGiftItems)
    {
        [arrGiftItems addObject:giftItem];
    }
    else
    {
        arrGiftItems = [NSMutableArray arrayWithObject:giftItem];
    }
    
}

////////////////////////////////////////////////////
#pragma mark - priv - <SlideViewDelegate> handlers
////////////////////////////////////////////////////
- (void)slideViewSold:(BOOL)sold withTag:(int)tag {
    if (sold)
    {
        [self giftSoldWithTag:tag];
    }
}

- (void)enableParentScrollView:(BOOL)enable {
    [self.giftKeyboardScrollView setScrollEnabled:enable];
}

- (void)giftSoldWithTag:(int)tag {
    [IGOHelpers vibratePhone];
    
    GiftsModel *thisgift = _giftsArray[tag];
    NSString *strgiftid = thisgift.idField;
    [HttpService sendGiftWithTouid:self.liveModel.idField giftid:strgiftid giftcount:@"1" result:^(CommonReturn *commonReturn) {
        if (commonReturn.state == 1) {
            //刷新本地钻石
            LiveUser *liveUser = [Config myProfile];
            long long oldCoin = [liveUser.coin longLongValue];
            long long newCoin = oldCoin - [_giftsArray[tag].needcoin intValue];
            if(newCoin <0)
            {
                newCoin = 0;
            }
            liveUser.coin = [NSString stringWithFormat:@"%lld",newCoin];
            [Config updateProfile:liveUser];
            self.coinLab.text = [NSString stringWithFormat:@"Refill : %lld",newCoin];
            
            NSArray *info = commonReturn.data[@"gifttoken"];
            NSString *dateStr = [self GetNowDate];
            GiftsModel *thisgift = _giftsArray[tag];
            NSString *evensend;
            if ([thisgift.type isEqualToString:@"1"]) {
                evensend = @"y";
            } else {
                evensend = @"n";
            }
            NSArray *msgData =@[
                                @{
                                    @"msg": @[
                                            @{
                                                @"_method_": @"SendGift",
                                                @"action": @"0",
                                                @"ct":info ,
                                                @"msgtype": @"1",
                                                @"timestamp": dateStr,
                                                @"tougood": @"",
                                                @"touid": @"0",
                                                @"touname": @"",
                                                @"ugood": [Config getOwnID],
                                                @"uid": [Config getOwnID],
                                                @"uname": [Config getOwnNicename],
                                                @"equipment": @"app",
                                                @"roomnum": self.liveModel.idField,
                                                @"level":_audienceModel.level,
                                                @"city":_audienceModel.city?:@"",
                                                @"evensend":evensend,
                                                @"usign":_audienceModel.signature,
                                                @"uhead":_audienceModel.avatar,
                                                @"sex":_audienceModel.gender,
                                                @"giftid":strgiftid
                                                }
                                            ],
                                    @"retcode": @"000000",
                                    @"retmsg": @"OK"
                                    }
                                ];
            
//            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
                [IGOHelpers runGiftAnimationForGiftID:strgiftid withImageView:self.ivGiftAnimation];
//            });
            
            [_chatSocket emit:@"broadcast" withItems:msgData];
        } else {
            [MBProgressHUD showError:commonReturn.msg];
        }
    }];
}

////////////////////////////////////////////////////////////////
#pragma mark - priv - xib binding & click handlers
////////////////////////////////////////////////////////////////
- (IBAction)giftBtnClick:(UIButton *)sender {
    [self.view endEditing:YES];
    [self updateGiftKeyboardView];
}

- (void)giftItemClick:(UIButton *)sender {
    
    XL_enter();
    XLM_alert(@"sender.tag: %li", (long)sender.tag);
    
    if ([ObjectTypeValidator nsarrayIsNilOrEmpty:_giftsArray] || _giftsArray.count <= sender.tag)
    {
        XLM_error(@"_giftsArray is nil/empty or size '%li' <= sender.tag '%li' value; returning without sending gift network request", (unsigned long)_giftsArray.count, (long)sender.tag);
        return;
    }
    
    for (GiftItem *item in arrGiftItems)
    {
        if (item.btnSendGift.tag == sender.tag)
        {
            [item.vGiftSlide delegateSlideViewSold:YES withTag:item.vGiftSlide.slideViewTag animated:YES];
            return;
        }
    }

    XLM_error(@"failed to find GiftItem with button tag that matches sender.tag; returning without selling gift ");
}

- (IBAction)closeBtnClick:(UIButton *)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Leave this stream?" message:@"" delegate:self cancelButtonTitle:@"YES" otherButtonTitles:@"NO", nil];
    [alert show];
}

- (IBAction)boostBtnClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        self.speakTextField.placeholder = @"Boost this post for 10 coins";
    } else {
        self.speakTextField.placeholder = @"Say Something...";
    }
    
    [ViewModifierHelpers setTextField:self.speakTextField phColor:[UIColor lightGrayColor] textColor:[UIColor whiteColor]];
}

- (IBAction)sendBtnClick:(UIButton *)sender {
    NSLog(@"%s",__func__);
    [self pushMessage:self.speakTextField];
}

- (IBAction)heartBtnClick:(UIButton *)sender {
    [self heartAnimateWithLevel:[Config myProfile].level];
    [self socketSendLight];
    /* attempting debug hearts issue */
    //[HttpService setLightWithShowid:_audienceModel.idField result:^(CommonReturn *commonReturn) {
    [HttpService setLightWithShowid:self.liveModel.idField result:^(CommonReturn *commonReturn) {
        if (commonReturn.state == 1) {
            XLM_info(@"%@",commonReturn.data);
            //[self sendHeartbeat]; /* attempting debug hearts issue */
        } else {
            XLM_error(@"%@",commonReturn.msg);
        }
    }];
    
}

- (void)socketSendLight {
    LiveUser *liveUser = [Config myProfile];
    firstStar = 1;
    NSArray *msgData =@[
                        @{
                            @"msg": @[
                                    @{
                                        @"_method_": @"SendMsg",
                                        @"action": @"0",
//                                        @"ct": @"我点亮了",
                                        @"msgtype": @"2",
                                        @"timestamp": [self GetNowDate],
                                        @"tougood": @"",
                                        @"touid": @"0",
                                        @"touname": @"",
                                        @"ugood": [Config getOwnID],
                                        @"uid": [Config getOwnID],
                                        @"uname": [Config getOwnNicename],
                                        @"equipment": @"app",
                                        @"roomnum": self.liveModel.idField,
                                        @"usign":_audienceModel.signature,
                                        @"uhead":_audienceModel.avatar,
                                        @"level":_audienceModel.level,
                                        @"city":_audienceModel.city?:@"",
                                        @"heart":_audienceModel.level,
                                        @"sex":liveUser.gender
                                        }
                                    ],
                            @"retcode": @"000000",
                            @"retmsg": @"OK"
                            }
                        ];
    [_chatSocket emit:@"broadcast" withItems:msgData];

}

- (IBAction)followBtnClick:(UIButton *)sender {
    [MBProgressHUD showMessage:@"Loading..."];
    [HttpService setFollowWithShowid:self.liveModel.idField result:^(CommonReturn *commonReturn) {
        [MBProgressHUD hideHUD];
        if (commonReturn.state == 1) {
            [MBProgressHUD showSuccess:@"Success"];
            [self updateFollingBtn];
        } else {
            [MBProgressHUD showError:commonReturn.msg];
        }
    }];
}

- (IBAction)shareBtnClick:(UIButton *)sender {
    [self.view endEditing:YES];
    self.defaultView.hidden = YES;
    self.shareView.hidden = NO;
}

- (void)anchorHeadClick {
    self.reportBackgroundView.hidden = NO;
    _reportView.showid = self.liveModel.idField;
    _reportView.targetuid = self.liveModel.idField;
    [_reportView updateView];
}

- (void)reportBackgroundViewTapGestureClick:(UITapGestureRecognizer *)sender {
    CGPoint point = [sender locationInView:self.reportBackgroundView];
    if (CGRectContainsPoint(_reportView.frame, point)) {
        return;
    }else{
        self.reportBackgroundView.hidden = YES;
    }
}

- (void)audienceClick:(UITapGestureRecognizer *)Recognizer {
    NSLog(@"Recognizer.view.tag = %ld",Recognizer.view.tag);
    self.reportBackgroundView.hidden = NO;
    _reportView.showid = _redisArray[Recognizer.view.tag - 200].idField;
    _reportView.targetuid = _redisArray[Recognizer.view.tag - 200].idField;
    [_reportView updateView];
}

- (void)votesViewClick {
    TopFansViewController *vc = [[TopFansViewController alloc] init];
    [vc setCurrLiveModel:self.liveModel];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)coinViewClick {
    CoinsViewController *vc = [[CoinsViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark share view
- (IBAction)copyLinkBtnClick:(UIButton *)sender {
    XL_enter();
    [MiscUtilities copyToPastboard:str_appstore_link];
    NSString *title = [NSString stringWithFormat:@"iGoLive Stream Link:\n%@", str_appstore_link];
    [AlertViewHelpers presentAlertWithTitle:title message:@"copied to clipboard" delegate:nil];
}

- (IBAction)instagramBtnClick:(UIButton *)sender {
    NSLog(@"%s",__func__);
}

- (IBAction)messengerBtnClick:(UIButton *)sender {
    XL_enter();
    UIImage *img = [UIImage imageNamed:f_imgIgoliveIcon];
    [MiscUtilities shareToFacebookWithImage:img text:str_share_sms_body url:str_appstore_link vcDelegate:self];
}

- (IBAction)whatsAppBtnClick:(UIButton *)sender {
    NSLog(@"%s",__func__);
}

- (IBAction)twitterBtnClick:(UIButton *)sender {
    XL_enter();
    UIImage *img = [UIImage imageNamed:f_imgIgoliveIcon];
    [MiscUtilities shareToTwitterWithImage:img text:str_share_sms_body url:str_appstore_link vcDelegate:self];
}

- (IBAction)facebookBtnClick:(UIButton *)sender {
    XL_enter();
    UIImage *img = [UIImage imageNamed:f_imgIgoliveIcon];
    [MiscUtilities shareToFacebookWithImage:img text:str_share_sms_body url:str_appstore_link vcDelegate:self];
}

- (IBAction)emailBtnClick:(UIButton *)sender {
    XL_enter();
    NSString *body = [NSString stringWithFormat:@"%@ %@",str_share_email_subject ,str_appstore_link];
    [MiscUtilities sendEmailSubject:body toEmail:@"" body:str_share_sms_body vcDelegate:self];
}

- (IBAction)textMessageBtnClick:(UIButton *)sender {
    XL_enter();
    NSString *msg = [NSString stringWithFormat:@"%@ %@",str_share_sms_body ,str_appstore_link];
    [MiscUtilities sendTextMessage:msg phone:@"" vcDelegate:self];
}

- (void)mailComposeController:(MFMailComposeViewController *)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError *)error {
    XL_enter();
    [controller dismissViewControllerAnimated:YES completion:nil];
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller
                 didFinishWithResult:(MessageComposeResult)result {
    XL_enter();
    [controller dismissViewControllerAnimated:YES completion:nil];
}

////////////////////////////////////////////////////////////////
#pragma mark - priv - gesture recognizer selectors
////////////////////////////////////////////////////////////////
- (void)interfaceViewClick:(UITapGestureRecognizer *)sender {
    if (_keyboardIsShow) {
        [self.view endEditing:YES];
        return;
    }
    if (!self.giftKeyboardView.hidden) {
        CGPoint point = [sender locationInView:self.view];
        if (CGRectContainsPoint(self.giftKeyboardView.frame, point)) {
            return;
        }
        self.giftKeyboardView.hidden = YES;
        self.defaultView.hidden = NO;
        return;
    }
    if (!self.shareView.hidden) {
        CGPoint point = [sender locationInView:self.view];
        if (CGRectContainsPoint(self.shareView.frame, point)) {
            return;
        }
        self.shareView.hidden = YES;
        self.defaultView.hidden = NO;
        return;
    }
    [self heartBtnClick:self.heartBtn];
}

- (void)longPressGesture:(id)sender {
    if (!self.giftKeyboardView.hidden) {
        return;
    }
    UILongPressGestureRecognizer *longPress = sender;
    if (longPress.state == UIGestureRecognizerStateBegan) {
        if (_longPressTimer == nil) {
            _longPressTimer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(longPressTimerAction) userInfo:nil repeats:YES];
        }else{
            [_longPressTimer setFireDate:[NSDate date]];
        }
    }else if (longPress.state == UIGestureRecognizerStateEnded) {
        [_longPressTimer setFireDate:[NSDate distantFuture]];
    }
}

- (void)longPressTimerAction {
    [self heartBtnClick:self.heartBtn];
}

////////////////////////////////////////////////////////////////
#pragma mark - priv - animation helpers
////////////////////////////////////////////////////////////////
- (void)heartAnimateWithLevel:(NSString *)level {
    NSString *imageName = [Common getHeartImageNameWithLevle:level];
    
    CGFloat imageW = 23;
    CGFloat imageH = 22;
    UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
    CGRect startRect = self.heartBtn.frame;
    
    /* legacy */
    //startRect.origin.y = _window_height - 260 - imageH;
    
    /* eg */
    CGFloat heartY = self.heartBtn.frame.origin.y;
    CGFloat heartHeight = self.heartBtn.frame.size.height;
    startRect.origin.y = heartY - heartHeight;
    /* _eg */
    
    startRect.origin.x += (self.heartBtn.frame.size.width - imageW)/2;
    startRect.size.width = imageW;
    startRect.size.height = imageH;
    image.frame = startRect;
    
    /* legacy */
    //[self.interfaceView addSubview:image];
    
    /* eg */
    [self.defaultView addSubview:image];
    /* _eg */
    
    image.alpha = 0;
    
    [UIView animateWithDuration:0.3 animations:^{
        image.alpha = 1;
    } completion:^(BOOL finished) {
        
        /* legacy */
        //CGFloat randomX = arc4random_uniform(_window_width*0.25) + _window_width*0.7;
        
        /* eg */
        CGFloat vwidth = self.defaultView.frame.size.width;
        CGFloat randomX = arc4random_uniform(vwidth*0.50) + vwidth*0.50;
        /* _eg */
        
        NSTimeInterval timeMoveToTop = 4.0f;
        NSTimeInterval fadeAwayTime = 2.0f;
        
#if use_new_hearts
        timeMoveToTop = 2.8f;
        fadeAwayTime = 4.0f;
#endif
        
        [UIView animateWithDuration:timeMoveToTop
                         animations:^{
                            /* legacy */
                            //image.frame = CGRectMake(randomX,_window_height/3,imageW*1.3,imageH*1.3);
                            
                            /* eg */    // note: y-cord = 0 refers to self.defaultView
                            image.frame = CGRectMake(randomX,0.0f,imageW*1.3,imageH*1.3);
                            /* _eg */
                        }];
        
        [UIView animateWithDuration:fadeAwayTime
                              delay:2.0
                            options:UIViewAnimationOptionLayoutSubviews animations:^{
                                image.alpha = 0;
                            } completion:^(BOOL finished) {
                                [image removeFromSuperview];
                            }];
    }];
}

////////////////////////////////////////////////////////////////
#pragma mark - priv - media player helpers
////////////////////////////////////////////////////////////////
- (void)KSVidioPlay {
    NSString *urlStr = [playRtmpUrl stringByAppendingFormat:@"/broadcast/%@",self.liveModel.idField];
    self.playUrl = [NSURL URLWithString:urlStr];
    [self setupObservers];
    [self onPlayVideo];
}

- (void)onPlayVideo {
    if (self.player) {
        [self.player play];
        return;
    }
    self.player =    [[KSYMoviePlayerController alloc] initWithContentURL: self.playUrl];
    
    self.player.view.backgroundColor = [UIColor clearColor];
    [self.player.view setFrame:CGRectMake(0, 0, _window_width, _window_height)];  // player's frame must match parent's
    [self.videoView addSubview:self.player.view];
    
    _player.shouldAutoplay = YES;
    _player.shouldEnableKSYStatModule = YES;
    _player.bufferTimeMax = buffer_time_max;
    
    _player.scalingMode = MPMovieScalingModeAspectFill;
    
    [_player prepareToPlay];
}

- (void)handlePlayerNotify:(NSNotification*)notify {
    if (!_player) {
        return;
    }
    if (MPMediaPlaybackIsPreparedToPlayDidChangeNotification ==  notify.name) {
        // stat.text = [NSString stringWithFormat:@"player prepared"];
        // using autoPlay to start live stream
        //        [_player play];
        // serverIp = [_player serverAddress];
        NSLog(@"player prepared");
        //移除开场加载动画
        [_entertimer invalidate];
        _entertimer = nil;
        _animationView.hidden = YES;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [_imageVV removeFromSuperview];
            _backScrollView.userInteractionEnabled = YES;
            _backScrollView.contentSize = CGSizeMake(_window_width*2,0);
            
        });
    }
    if (MPMoviePlayerPlaybackStateDidChangeNotification ==  notify.name) {
        NSLog(@"player playback state: %ld", (long)_player.playbackState);
        
        NSInteger currPlayState = _player.playbackState;
        [self toggleLoadingViewForPlaybackState:currPlayState];
    }
    
    if (MPMoviePlayerLoadStateDidChangeNotification ==  notify.name) {
        NSLog(@"player load state: %ld", (long)_player.loadState);
        if (MPMovieLoadStateStalled & _player.loadState) {
            //stat.text = [NSString stringWithFormat:@"player start caching"];
            NSLog(@"player start caching");
            
            [self validateLoadStateTimer];
        }
        
        if (_player.bufferEmptyCount && (MPMovieLoadStatePlayable & _player.loadState
                                         || MPMovieLoadStatePlaythroughOK & _player.loadState))
        {
            NSLog(@"player finish caching");
        
            [self invalidateLoadStateTimer];
            [self dismissStreamLoadingView];
        }
    }
    if (MPMoviePlayerPlaybackDidFinishNotification ==  notify.name) {
        NSLog(@"player finish state: %ld", (long)_player.playbackState);
        NSLog(@"player download flow size: %f MB", _player.readSize);
        NSLog(@"buffer monitor  result: \n   empty count: %d, lasting: %f seconds",
              (int)_player.bufferEmptyCount,
              _player.bufferEmptyDuration);
        
        //        [self lastView];
        
        [self presentClosingAlert];
    }
    if (MPMovieNaturalSizeAvailableNotification ==  notify.name) {
        NSLog(@"video size %.0f-%.0f", _player.naturalSize.width, _player.naturalSize.height);
    }
}
- (void)presentClosingAlert
{
    if (!mpPlaybackFinished)
    {
        mpPlaybackFinished = YES;
        [AlertViewHelpers presentAlertWithTitle:@"Your anchor has stopped streaming" message:@"" delegate:self];
    }
}
////////////////////////////////////////////////////////////////
#pragma mark - priv - loading state view control
////////////////////////////////////////////////////////////////
- (void)validateLoadStateTimer
{
    if (!loadStateTimer)
    {
        loadStateTimer = [NSTimer scheduledTimerWithTimeInterval:loadstate_delay_sec target:self selector:@selector(showLoadState) userInfo:nil repeats:YES];
        loadStateTimer.tolerance = (loadstate_delay_sec * 0.10f); // recommended tollarance by apple
    }
}
- (void)invalidateLoadStateTimer
{
    if (loadStateTimer && loadStateTimer.isValid){
        [loadStateTimer invalidate];
        loadStateTimer = nil;
    }
}
- (void)showLoadState
{
    [self presentStreamLoadingViewWhileBlurringBgView:self.videoView];
}
- (void)toggleLoadingViewForPlaybackState:(NSInteger)state
{
    switch (state)
    {
        case MPMoviePlaybackStateStopped:
            XLM_alert(@"playbackState: %li 'MPMoviePlaybackStateStopped'\n\n", state);
//            [self presentStreamLoadingViewWithCustomAnimation:custAnim];
            [self showLoadState];
            break;
        case MPMoviePlaybackStatePlaying:
            XLM_alert(@"playbackState: %li 'MPMoviePlaybackStatePlaying'\n\n", state);
            [self dismissStreamLoadingView];
            break;
        case MPMoviePlaybackStatePaused:
            XLM_alert(@"playbackState: %li 'MPMoviePlaybackStatePaused'\n\n", state);
//            [self presentStreamLoadingViewWithCustomAnimation:custAnim];
            [self showLoadState];
            break;
        case MPMoviePlaybackStateInterrupted:
            XLM_alert(@"playbackState: %li 'MPMoviePlaybackStateInterrupted'\n\n", state);
//            [self presentStreamLoadingViewWithCustomAnimation:custAnim];
            [self showLoadState];
            break;
        default:
            XLM_warning(@"default case hit for playbackState: %li; presenenting loading view controller\n\n", state);
//            [self presentStreamLoadingViewWithCustomAnimation:custAnim];
            [self showLoadState];
            break;
    }
}
////////////////////////////////////////////////////////////////
#pragma mark - priv - UIAlertViewDelegate
////////////////////////////////////////////////////////////////
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        isCloseDisconnect = YES;
        [_chatSocket disconnect];
        isReConSocket = NO;
        [_player stop];
        [self dismissStreamLoadingView];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}
//直播结束跳到此页面
- (void)lastView {
    
    UIImageView *lastView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, _window_width, _window_height)];
    lastView.userInteractionEnabled = YES;
    lastView.image = [UIImage imageNamed:@"create_room_bg.png"];
    UILabel *labell= [[UILabel alloc]initWithFrame:CGRectMake(0,_window_height*0.3, _window_width, 60)];
    labell.textColor = backColor;
    labell.text = @"Finished";
    labell.textAlignment = NSTextAlignmentCenter;
    labell.font = [UIFont systemFontOfSize:30];
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(_window_width*0.2, _window_height *0.7, _window_width*0.6, 40);
    [button setTitle:@"返回首页" forState:UIControlStateNormal];
    [button setTitleColor:backColor forState:UIControlStateNormal];
    
    button.layer.masksToBounds = YES;
    button.layer.cornerRadius = 20;
    
    button.layer.borderColor = backColor.CGColor;
    button.layer.borderWidth = 2;
    button.backgroundColor = [UIColor clearColor];
    [button addTarget:self action:@selector(docancle) forControlEvents:UIControlEventTouchUpInside];
    
    
    [lastView addSubview:button];
    [lastView addSubview:labell];
    
    
    [self.view addSubview:lastView];
    
}

////////////////////////////////////////////////////////////////
#pragma mark - priv - network request support
////////////////////////////////////////////////////////////////
- (void)getRedislist {
    [HttpService getRedislistWithShowid:self.liveModel.idField result:^(CommonReturn *commonReturn) {
        if (commonReturn.state == 1) {
            self.onlineLabel.text = commonReturn.data[@"nums"];
            NSString *anchorVotes = commonReturn.data[@"votestotal"];
            if ([anchorVotes class] != [NSNull class]) {
                self.anchorVotes.text = anchorVotes;
            }
            for (NSString *str in commonReturn.data[@"list"]) {
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:[str dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
                RedisModel *model = [[RedisModel alloc] initWithDictionary:dic];
                BOOL isHave = NO;
                for (RedisModel *arrModel in _redisArray) {
                    if ([arrModel.idField isEqualToString:model.idField]) {
                        isHave = YES;
                    }
                }
                if (!isHave) {
                    [_redisArray addObject:model];
                }
            }
            [self updateAudienceScrollView];
        }
    }];
}

- (void)getGifts {
    [HttpService getGiftsWithResult:^(CommonReturn *commonReturn) {
        if (commonReturn.state == 1) {
            for (NSDictionary *dict in commonReturn.data) {
                //XLM_info(@"dict in commonReturn.data: %@", [dict description]);
                [_giftsArray addObject:[[GiftsModel alloc] initWithDictionary:dict]];
            }
        }
    }];
}

- (void)doCancelShowNetworkError {
    [MBProgressHUD showError:@"Network Error (no data)\n please try again"];
    [self docancle];
}

- (void)docancle {
    [MBProgressHUD showError:@"End"];
    LivestreamSummaryViewController *vc = [[LivestreamSummaryViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark socket.io
- (void)addNodeListen {
    connState = NO;

    NSArray *cur = @[@{@"username":[Common clearNil:[Config getOwnNicename]],
                       @"uid":[Config getOwnID],
                       @"token":[Config getOwnToken],
                       @"roomnum":self.liveModel.idField
                       }];
    [_chatSocket on:@"connect" callback:^(NSArray* data, SocketAckEmitter* ack) {
        XLM_enter(@"socket '%@'", @"connect");
        connState = YES;
        if(isReConSocket) {
            [HttpService setNodejsInfoWithShowid:self.liveModel.idField result:^(CommonReturn *commonReturn) {
                [_chatSocket emit:@"conn" withItems:cur];
            }];
            return;
        } else {
            [_chatSocket emit:@"conn" withItems:cur];
        }
    }];
    
    [_chatSocket on:@"disconnect" callback:^(NSArray* data, SocketAckEmitter* ack) {
        XLM_enter(@"socket '%@'\n attempting to re-'[_chatSocket connect]'\n\n\n\n", kSockDisconnect);
        if (_chatSocket && !isCloseDisconnect)
        {
            isReConSocket = YES;
            [_chatSocket connect];
        }
        else
        {
            XLM_alert(@"_chatSocket is nil or isCloseDisconnect == YES; returning w/o calling [_chatSocket conenct]");
        }
        
        return;
    }];
    
    [_chatSocket on:@"conn" callback:^(NSArray* data, SocketAckEmitter* ack) {
        XLM_enter(@"socket '%@'", kSockConn);
        XLM_info(@"进入房间 ('Enter Room')%@",data);
        
        if(!isReConSocket) {
            userCount = 0;
            [self getRedislist];//获取观众列表
            if(!heartbeatTime) {
                heartbeatTime = [NSTimer scheduledTimerWithTimeInterval:heartbeat_timer_sec target:self selector:@selector(sendHeartbeat) userInfo:nil repeats:YES];
                heartbeatTime.tolerance = (heartbeat_timer_sec * 0.10);
    }}}];
    
    [_chatSocket on:@"reconnect" callback:^(NSArray *data, SocketAckEmitter *ack) {
        XLM_enter(@"socket '%@'",kSockReconnect);
        [_chatSocket connect];
        isReConSocket = YES;
        
    }];
    
    //连接出错了 ('wrong connection')
    [_chatSocket on:@"error" callback:^(NSArray * data, SocketAckEmitter * ack) {
        XLM_enter(@"socket '%@'",kSockError);
        isReConSocket = YES;
    }];
    
    [_chatSocket on:@"broadcastingListen" callback:^(NSArray* data, SocketAckEmitter* ack) {
        XLM_enter(@"socket '%@' fired",kSockBroadcastListen);
        
#if log_chat_sock_node_data
        NSString *strdata = [NetworkRequestHelpers getJSONDescriptionFromArrayPayload:data];
        XLM_info(@"received node data (raw):\n %@", [data description]);
        XLM_info(@"received node data:\n %@", strdata);
#endif
        
        if ([ObjectTypeValidator nsarrayIsNilOrEmpty:data])
        {
            XLM_error(@"data array from socket came back nil or empty; canceling stream");
            
            [self doCancelShowNetworkError];
            return;
        }
        
        /* legacy but still in use (moved from below) */
        if([data[0] isEqualToString:@"stopplay"]) {
            XLM_info(@"房间被管理员已关闭 ('The room was closed by admin')");
            
            //[MBProgressHUD showError:@"房间被管理员已关闭"];
            [MBProgressHUD showError:@"The room was closed by admin"];
            [self docancle];
            return;
        }
        
        NSString *strDataArr0 = [ObjectTypeValidator nsstringFromObject:data[0]];
        if (!strDataArr0)
        {
            XLM_error(@"data[0] from socket failed string validation; canceling stream");
            [self doCancelShowNetworkError];
            return;
        }
        
        NSData *dataDataArr0 = [strDataArr0 dataUsingEncoding:NSUTF8StringEncoding];
        /* _legacy */
        
        /* eg */
        id jsonObj = [NSJSONSerialization JSONObjectWithData:dataDataArr0 options:NSJSONReadingMutableContainers error:nil];
        NSDictionary *dictJson = [ObjectTypeValidator nsdictionaryFromObject:jsonObj];
        if (!dictJson)
        {
            XLM_alert(@"dictJson from socket array failed to parse to dictionary; canceling stream");
            [self doCancelShowNetworkError];
            return;
        }
        
        NSArray *msgarr = [ObjectTypeValidator nsarrayFromObject:[dictJson valueForKey:@"msg"]];
        if (!msgarr)
        {
            XLM_alert(@"msgarr from socket array[0]->dict{msg:[]} failed to parse to array; canceling stream");
            [self doCancelShowNetworkError];
            return;
        }
        
        NSDictionary *msgdict = [ObjectTypeValidator nsdictionaryFromObject:msgarr[0]];
        if (!msgdict)
        {
            XLM_alert(@"msgdict from socket msgarr[0] failed to parse to dictionary; canceling stream");
            [self doCancelShowNetworkError];
            return;
        }
        
        NSString *method = [ObjectTypeValidator nsstringFromObject:[msgdict objectForKey:@"_method_"]];
        /* _eg */
        
        /* legacy (includes replacing msg var below with msgdict above) */
        //NSString *string = data[0];
        //NSData *jsonData = [string dataUsingEncoding:NSUTF8StringEncoding];
        //NSArray* JsonDataArray = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
        //
        //if([data[0] isEqualToString:@"stopplay"]) {
        //    //[MBProgressHUD showError:@"房间被管理员已关闭"];
        //    [MBProgressHUD showError:@"The room was administrator has turned off"];
        //    [self docancle];
        //}
        //
        //NSString *msg = [[JsonDataArray valueForKey:@"msg"] objectAtIndex:0];
        //NSString *method = [msg valueForKey:@"_method_"];
        /* _legacy */
        
        if ([method isEqual:@"requestFans"]) {
            
            NSString *msgtype = [msgdict valueForKey:@"msgtype"];
            if([msgtype isEqual:@"0"]){
                NSString *action = [msgdict valueForKey:@"action"];
                
                
                if ([action isEqual:@"3"]) {
                    NSArray *ct = [msgdict valueForKey:@"ct"];
                    NSArray *data = [ct valueForKey:@"data"];
                    if ([[data valueForKey:@"code"]isEqualToNumber:@0]) {
                        NSArray *info = [data valueForKey:@"info"];
                        NSArray *list = [info valueForKey:@"list"];
                        for (int i =0; i<list.count; i++) {
                            [self.listArray addObject:[list objectAtIndex:i]];
                        }
                        userCount = [[info valueForKey:@"nums"]  longLongValue];
                        self.onlineLabel.text = [NSString stringWithFormat:@"%lld",userCount];
                        [IGUtils quickSort1:self.listArray];
        }}}}
        
        if ([method isEqual:@"SendMsg"]) {
            NSString *msgtype = [msgdict valueForKey:@"msgtype"];
            if([msgtype isEqual:@"2"]) {
                NSString* ct;
                NSDictionary *heartDic = [[NSArray arrayWithObject:msgdict] firstObject];
                NSArray *sub_heart = [heartDic allKeys];
                
                if ([sub_heart containsObject:@"heart"]) {
                    NSString *lightColor = [heartDic valueForKey:@"heart"];
                    NSString *light = @"light";
                    titleColor = [light stringByAppendingFormat:@"%@",lightColor];
                    ct = [NSString stringWithFormat:@"%@", [msgdict valueForKey:@"ct"]];
                    NSString *city = [msgdict valueForKey:@"city"];
                    NSString *uname = [msgdict valueForKey:@"uname"];
                    NSString *levell = [msgdict valueForKey:@"level"];
                    
                    /* legacy */
                    //NSString *ID = [msgdict valueForKey:@"uid"];
                    /* _legacy */
                    
                    /* eg_10.04.16 crash fix */
                    // this field comes over has a number value not a string sometimes
                    id obj = [msgdict valueForKey:@"uid"];
                    NSString *ID = [ObjectTypeValidator nsstringFromObject:obj];
                    if (!ID)
                    {
                        NSNumber *nID = [ObjectTypeValidator SAFEnsnumberIntFromObject:obj];
                        ID = nID.stringValue;
                    }
                    /* _eg */
                    
                    NSString *signature = [msgdict valueForKey:@"usign"];
                    NSString *avatar = [msgdict valueForKey:@"uhead"];
                    NSString *sex = [msgdict valueForKey:@"sex"];
                    
                    
                    NSDictionary *chat = [NSDictionary dictionaryWithObjectsAndKeys:uname,@"userName",ct,@"contentChat",levell,@"levelI",ID,@"id",titleColor,@"titleColor",city,@"city",avatar,@"avatar",sex,@"sex",signature,@"signature",nil];
                    if (![ID isEqualToString:[Config getOwnID]]) {
                        [self heartAnimateWithLevel:levell];
                    }
                    
                    _likeNum++;
                    self.likesLab.text = [Common likeStringWithNum:_likeNum];
                } else {
                    ct = [NSString stringWithFormat:@"%@", [msgdict valueForKey:@"ct"]];
                    
                    
                    NSString *city = [msgdict valueForKey:@"city"];
                    NSString* uname = [msgdict valueForKey:@"uname"];
                    NSString *levell = [msgdict valueForKey:@"level"];
                    NSString *ID = [msgdict valueForKey:@"uid"];
                    NSString *signature = [msgdict valueForKey:@"usign"];
                    NSString *avatar = [msgdict valueForKey:@"uhead"];
                    NSString *sex = [msgdict valueForKey:@"sex"];
                    
                    
                    NSDictionary *chat = [NSDictionary dictionaryWithObjectsAndKeys:uname,@"userName",ct,@"contentChat",levell,@"levelI",ID,@"id",titleColor,@"titleColor",city,@"city",avatar,@"avatar",sex,@"sex",signature,@"signature",nil];
                    
                    
                    [msgList addObject:chat];
                    [self.tableView reloadData];
                    titleColor = @"0";
                    huifuOK = 0;
                    
                    [self jumpLast];
            }}
            
            if([msgtype isEqual:@"0"]) {
                
                NSString *action = [msgdict valueForKey:@"action"];
                if ([action isEqual:@"1"]) {
                    userCount -= 1;
                    self.self.onlineLabel.text = [NSString stringWithFormat:@"%lld",userCount];
                    NSString *ID = [[msgdict valueForKey:@"ct"] valueForKey:@"uid"];
                    [self.listArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                        for (NSDictionary *dic in self.listArray) {
                            if ([[dic valueForKey:@"id"] isEqualToString:ID]) {
                                [self.listArray removeObject:dic];
                                return;
                    }}}];
                }
            
                if ([action isEqual:@"0"]) {
                    userCount += 1;
                    self.onlineLabel.text = [NSString stringWithFormat:@"%lld",userCount];
                    [self.listArray addObject:[msgdict valueForKey:@"ct"]];
                    [IGUtils quickSort1:self.listArray];
                    
                    RedisModel *model = [[RedisModel alloc] initWithDictionary:msgdict[@"ct"]];
                    [_redisArray addObject:model];
                    [self updateAudienceScrollView];
            }}
            
            if ([msgtype isEqual:@"1"]) {
                NSString *action = [msgdict valueForKey:@"action"];
                if ([action isEqual:@"18"]) {
                    NSLog(@"finished");
                    [self onStopVideo];
                    [self lastView];
            }}
            
        } else if ([method isEqual:@"light"]) {
            NSString *msgtype = [msgdict valueForKey:@"msgtype"];
            if([msgtype isEqual:@"0"]){
                
                NSString *action = [msgdict valueForKey:@"action"];
                //点亮
                if ([action isEqualToString:@"2"]) {
                    firstStar = 1;
                }
            }
            [self jumpLast];
        } else if ([method isEqual:@"SystemNot" ] || [method isEqualToString:@"ShutUpUser"]) {
            //   NSString *msgtype = [msg valueForKey:@"msgtype"];
            
            titleColor = @"firstlogin";
            NSString *ct = [msgdict valueForKey:@"ct"];
            NSString *uname = @"System Information";
            NSString *levell = @" ";
            NSString *ID = @"";
            NSString *icon = @"";
            NSString *city = @"";
            
            NSString *signature = @" ";
            NSString *sex = @" ";

            NSDictionary *chat = [NSDictionary dictionaryWithObjectsAndKeys:uname,@"userName",ct,@"contentChat",levell,@"levelI",ID,@"id",titleColor,@"titleColor",city,@"city",icon,@"avatar",sex,@"sex",signature,@"signature",nil];
            [msgList addObject:chat];
            [self.tableView reloadData];
            
            titleColor = @"0";
        } else if ([method isEqual:@"SendGift"]) {
            SendGiftModel *model = [[SendGiftModel alloc] initWithDictionary:(NSDictionary *)msgdict];
            [_giftExhibition showGiftWithSendGiftModel:model];
            
            NSDictionary *ct = [msgdict valueForKey:@"ct"];
            NSString *ctt = [NSString stringWithFormat:@"Sent a %@",[ct valueForKey:@"giftname"]];
            NSString *city = [msgdict valueForKey:@"city"];
            NSString *uname = [msgdict valueForKey:@"uname"];
            NSString *levell = [msgdict valueForKey:@"level"];
            NSString *ID = [msgdict valueForKey:@"uid"];
            NSString *signature = [msgdict valueForKey:@"usign"];
            NSString *avatar = [msgdict valueForKey:@"uhead"];
            NSString *sex = [msgdict valueForKey:@"sex"];
            
            NSDictionary *chat6 = [NSDictionary dictionaryWithObjectsAndKeys:uname,@"userName",ctt,@"contentChat",levell,@"levelI",ID,@"id",titleColor,@"titleColor",city,@"city",avatar,@"avatar",sex,@"sex",signature,@"signature",nil];
            [msgList addObject:chat6];
            
            [self.tableView reloadData];
            int oldNum = [self.anchorVotes.text intValue];
            int newNUm = oldNum + (int)model.ct.totalcoin;
            self.anchorVotes.text = [NSString stringWithFormat:@"%d",newNUm];
            [self jumpLast];
        } else if([method isEqualToString:@"SendBarrage"]) {
            NSData *tempData = [data[0] dataUsingEncoding:NSUTF8StringEncoding];
            
            NSDictionary *tempDict = [NSJSONSerialization JSONObjectWithData:tempData options:0 error:nil];
            
            [_barrageView setModel:tempDict[@"msg"][0]];
            
            //NSLog(@"弹幕接受成功%@",msgdict);
            XLM_info(@"(弹幕接受成功('barrage accepted success')%@",msgdict);
            
        } else if([method isEqualToString:@"StartEndLive"]) {
        } else if([method isEqualToString:@"disconnect"]) {
            NSString *ID = [NSString stringWithFormat:@"%d",[msgdict[@"ct"][@"id"] intValue]];
            RedisModel *deleteModel;
            for (RedisModel *model in _redisArray) {
                if ([ID isEqualToString:model.idField]) {
                    deleteModel = model;
                }
            }
            if (deleteModel) {
                [_redisArray removeObject:deleteModel];
                [self updateAudienceScrollView];
            }
        }
    }];
}

- (void)sendHeartbeat {
    [_chatSocket emit:@"heartbeat" withItems:@[@"i am a live"]];
}

- (void)jumpLast {
    
    NSUInteger sectionCount = [self.tableView numberOfSections];
    if (sectionCount) {
        
        NSUInteger rowCount = [self.tableView numberOfRowsInSection:0];
        if (rowCount) {
            
            NSUInteger ii[2] = {0, rowCount - 1};
            NSIndexPath* indexPath = [NSIndexPath indexPathWithIndexes:ii length:2];
            [self.tableView scrollToRowAtIndexPath:indexPath
                                  atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        }
    }
    
}

- (void)onStopVideo {
    if (_player) {
        NSLog(@"player download flow size: %f MB", _player.readSize);
        NSLog(@"buffer monitor  result: \n   empty count: %d, lasting: %f seconds",
              (int)_player.bufferEmptyCount,
              _player.bufferEmptyDuration);
        
        [_player stop];
        
        [_player.view removeFromSuperview];
        
        _player = nil;
        
    }
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    ChatModel *model = _chatModels[indexPath.row];
    return model.rowHH;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.chatModels.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    static NSString *SimpleTableIdentifier = @"tableviewchat";
    Chatcell *cell = [tableView dequeueReusableCellWithIdentifier: SimpleTableIdentifier];
    if(cell == nil)
    {
        cell = [[Chatcell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SimpleTableIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.model = self.chatModels[indexPath.row];
    cell.backgroundColor = [UIColor clearColor];
    cell.clickBlock = ^(NSString *uid) {
        self.reportBackgroundView.hidden = NO;
        _reportView.showid = uid;
        _reportView.targetuid = uid;
        [_reportView updateView];
    };
    
    return cell;
    
}

- (NSMutableArray *)chatModels {
    
    NSMutableArray *array = [NSMutableArray array];
    for (NSDictionary *dic in msgList) {
        
        ChatModel *model = [ChatModel modelWithDic:dic];
        
        [model setChatFrame:[_chatModels lastObject]];
        
        [array addObject:model];
    }
    _chatModels = array;
    
    
    
    return _chatModels;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self pushMessage:nil];
    return NO ;
}

- (void)pushMessage:(UITextField *)sender {
    if (![self socketIsConnected]) {
        [MBProgressHUD showError:@"Chat server connection failed"];
        return;
    }
    self.content = self.speakTextField.text;
    self.speakTextField.text = @"";
    if (self.content.length <=0) {
        return;
    } else if ([self.content isEqualToString:@""]) {
        return;
    } else if ([self.content isEqualToString:@" "]) {
        return;
    } else if (self.boostBtn.selected) {
        [self sendBarrage];
    } else {
        [self.view endEditing:NO];
        
        titleColor = @"0";
        
        //判断  是否被禁言
        // check if it has been muted or not
        [HttpService isShutUpWithUid:[Config getOwnID] showid:self.liveModel.idField result:^(CommonReturn *commonReturn) {
            if (commonReturn.state == 1) {
                if ([commonReturn.data intValue] == 1) {
                    //NSLog(@"被禁言");
                    NSLog(@"been muted");
                    //[MBProgressHUD showError:@"你已被禁言"];
                    [MBProgressHUD showError:@"you have been muted"];
                }else{
                    NSString *dateStr = [self GetNowDate];
                    XLM_info(@"dateStr: %@", dateStr);
                    
//                    if (huifuOK == 1) {
//                        NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
//                        [formatter setAMSymbol:@"上午"];
//                        [formatter setPMSymbol:@"下午"];
//                        [formatter setDateFormat:@"HH:mm:ss MMM"];
//                        NSString *time=[formatter stringFromDate:[NSDate date]];
//                        
//                        EMTextMessageBody *body = [[EMTextMessageBody alloc] initWithText:self.content];
//                        
//                        //生成Message
//                        EMMessage *message = [[EMMessage alloc] initWithConversationID:self.tanChuangID from:[Config getOwnID] to:self.tanChuangID body:body ext:nil];
//                        
//                        message.chatType = EMChatTypeChat;// 设置为单聊消息
//                        message.direction = EMMessageDirectionSend;//方向
//                        
//                        //发送消息
//                        [[EMClient sharedClient].chatManager asyncSendMessage:message progress:nil completion:^(EMMessage *aMessage, EMError *aError) {
//                            message.chatType = EMChatTypeChat;
//                            
//                            if (!aError) {
//                                LiveUser *user = [Config myProfile];
//                                NSDictionary *dic = [NSDictionary dictionaryWithObjects:@[user.avatar,self.content,@"0",time] forKeys:@[@"avatar",@"text",@"type",@"time"]];
//                                [self.allArray addObject:dic];
//                                [self.tableView reloadData];
//                                NSLog(@"发送成功");
//                            }
//                        }];
//                        
//                    }
                    
                    
                    LiveUser *user = [Config myProfile];
                  
#warning BUG: this is just a temp work around. more extensive coding design required
                /*
                    note_8.29.16
                     - - crash fix with sending message while watching a live stream
                     - - this is just a temp work around. more extensive coding design to include object validation checks will need to be integrated to ensure this crash is fully secured against (in all parts of the app)
                 */
                    if (!_audienceModel.avatar)
                        _audienceModel.avatar = @"";
                    
                    XLM_info(@"%@",_audienceModel.avatar);
                    XLM_info(@"user = %@",user);
                    NSArray *msgData =@[
                                        @{
                                            @"msg": @[
                                                    @{
                                                        @"_method_": @"SendMsg",
                                                        @"action": @"0",
                                                        @"ct": self.content,
                                                        @"msgtype": @"2",
                                                        @"timestamp": dateStr,
                                                        @"tougood": @"",
                                                        @"touid": @"0",
                                                        @"city":@"city",
                                                        @"touname": @"",
                                                        @"ugood": [Config getOwnID],
                                                        @"uid": [Config getOwnID],
                                                        @"uname": [Config getOwnNicename],
                                                        @"equipment": @"app",
                                                        @"roomnum": self.liveModel.idField,
                                                        @"usign":_audienceModel.signature,
                                                        @"uhead":_audienceModel.avatar,
                                                        @"level":_audienceModel.level,
                                                        @"sex":_audienceModel.gender
                                                        }
                                                    ],
                                            @"retcode": @"000000",
                                            @"retmsg": @"OK"
                                            }
                                        ];
                    [_chatSocket emit:@"broadcast" withItems:msgData];
                }
            }
        }];
    }
}

- (void)sendBarrage {
    [self.view endEditing:YES];
    [HttpService sendBarrageWithTouid:self.liveModel.idField content:self.content result:^(CommonReturn *commonReturn) {
        if (commonReturn.state == 1) {
            NSArray *data = commonReturn.data;
            NSArray *info = [data valueForKey:@"barragetoken"];
            NSString *dateStr = [self GetNowDate];
            
            _audienceModel.level = [data valueForKey:@"level"];
            
            //刷新本地钻石
            LiveUser *liveUser = [Config myProfile];
            long long oldCoin = [liveUser.coin longLongValue];
            long long newCoin = oldCoin - 1;
            if(newCoin <0)
            {
                newCoin = 0;
            }
            liveUser.coin = [NSString stringWithFormat:@"%lld",newCoin];
            [Config updateProfile:liveUser];
            self.coinLab.text = [NSString stringWithFormat:@"Refill : %lld",newCoin];
            
            NSArray *msgData =@[
                                @{
                                    @"msg": @[
                                            @{
                                                @"_method_": @"SendBarrage",
                                                @"action": @"0",
                                                @"ct":info ,
                                                @"msgtype": @"1",
                                                @"timestamp": dateStr,
                                                @"tougood": @"",
                                                @"touid": @"0",
                                                @"touname": @"",
                                                @"ugood": [Config getOwnID],
                                                @"uid": [Config getOwnID],
                                                @"uname": [Config getOwnNicename],
                                                @"equipment": @"app",
                                                @"roomnum": self.liveModel.idField,
                                                @"level":_audienceModel.level,
                                                @"usign":_audienceModel.signature,
                                                @"uhead":_audienceModel.avatar,
                                                @"sex":liveUser.gender
                                                }
                                            ],
                                    @"retcode": @"000000",
                                    @"retmsg": @"OK"
                                    }
                                ];
            [_chatSocket emit:@"broadcast" withItems:msgData];
            
        } else {
            [MBProgressHUD showError:commonReturn.msg];
        }
    }];
}

- (NSString *)GetNowDate {
    NSDate* date = [NSDate date];
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"HH:mm"];
    NSString* dateStr = [dateFormat stringFromDate:date];
    return dateStr;
}
- (void)getLikesFromNet {
    [HttpService getInfoWithUcuid:self.liveModel.idField result:^(CommonReturn *commonReturn) {
        if (commonReturn.state == 1) {
            PopupModel *model = [[PopupModel alloc] initWithDictionary:commonReturn.data];
            self.likesLab.text = [NSString stringWithFormat:@"%ld", (long)model.likes];
            _likeNum = model.likes;
        }
    }];
}

- (void)getNodeJSInfo {
    [HttpService setNodejsInfoWithShowid:self.liveModel.idField result:^(CommonReturn *commonReturn) {
        if (commonReturn.state == 1) {
            _audienceModel = [[AudienceModel alloc] initWithDictionary:commonReturn.data];
            [self updateView];
            [self addNodeListen];
        } else {
            NSLog(@"获取房间信息错误 01,");
        }
    }];
}

- (BOOL)socketIsConnected {
    if (_chatSocket.status == SocketIOClientStatusConnected) {
        return YES;
    }
    return NO;
}

@end
