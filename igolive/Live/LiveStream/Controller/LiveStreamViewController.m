//
//  LiveStreamViewController.m
//  iphoneLive
//
//  Created by 高翔 on 16/8/10.
//  Copyright © 2016年 cat. All rights reserved.
//

#import "LiveStreamViewController.h"
#import <GPUImage/GPUImage.h>
#import <libksygpulive/libksygpulive.h>
#import <libksygpulive/libksygpuimage.h>
#import "ServerURL.h"
#import "LivestreamSummaryViewController.h"
#import "TopFansViewController.h"
#import "ReportView.h"
#import "ProfileUserViewController.h"
#import "GiftExhibition.h"

#import "IGUtils.h"
#import "Chatcell.h"
#import "GrounderSuperView.h"

#import "NetworkRequestHelpers.h"

@interface LiveStreamViewController () <UIAlertViewDelegate,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate> {
    BOOL _firstLoad;
    KSYBgmPlayer *_bgPlay;
    KSYGPUStreamer *_streamer;
    KSYGPUCamera * _capDev;
    GPUImageFilter     *_filter;
    GPUImageCropFilter *_cropfilter;
    GPUImageView   *_preview;
    
    AudienceModel *_audienceModel;
    
    ReportView *_reportView;
    NSMutableArray<RedisModel *> *_redisArray;
    
    //openingAnimation
    UILabel *label1;
    UILabel *label2;
    UILabel *label3;
    UIView  *backView;
    
    GiftExhibition *_giftExhibition;
    
    BOOL _keyboardIsShow;
    
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
@property (weak, nonatomic) IBOutlet UIView *preSuperView;

@property (weak, nonatomic) IBOutlet UIView *interfaceView;
@property (weak, nonatomic) IBOutlet UIView *authorInformationView;
@property (weak, nonatomic) IBOutlet UIImageView *anchorHead;
@property (weak, nonatomic) IBOutlet UILabel *onlineLabel;
@property (weak, nonatomic) IBOutlet UILabel *anchorNameLab;
@property (weak, nonatomic) IBOutlet UILabel *anchorLevelLab;
@property (weak, nonatomic) IBOutlet UILabel *anchorVotes;
@property (weak, nonatomic) IBOutlet UIView *votesView;
@property (weak, nonatomic) IBOutlet UIImageView *anchorGenderimage;
@property (weak, nonatomic) IBOutlet UIImageView *anchorEllipseImage;
@property (weak, nonatomic) IBOutlet UILabel *likesLab;
@property (weak, nonatomic) IBOutlet UIScrollView *audienceScrollView;
@property (weak, nonatomic) IBOutlet UIButton *boostBtn;
@property (weak, nonatomic) IBOutlet UITextField *speakField;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *interfaceViewBottom;
@property (weak, nonatomic) IBOutlet UIView *giftExhibitionBackground;

@property (weak, nonatomic) IBOutlet UIView *reportBackgroundView;
@property (weak, nonatomic) IBOutlet UIView *shareView;

@property (weak, nonatomic) IBOutlet UITableView *tableView; // bottom table view ( i think for chat )


//copy
@property(nonatomic,strong)NSMutableArray *listArray;
@property(nonatomic,strong)NSMutableArray *chatModels;//模型数组
@property(nonatomic,copy)NSString *content;//聊天内容
@property(nonatomic,copy)NSString *tanChuangID;//弹窗用户的id
@property(nonatomic,strong)NSMutableArray *allArray;

@end

@implementation LiveStreamViewController

- (void)viewDidLoad {
    _firstLoad = YES;
    [super viewDidLoad];
    
    self.sendBtn.backgroundColor = UIColorFromHexAlpha(col_btn_green, 1.0f);
    [ViewModifierHelpers setTextField:self.speakField phColor:[UIColor lightGrayColor] textColor:[UIColor whiteColor]];
    
    [self initArray];
    [self openingAnimation];
    [self initRecognizer];
    
    NSURL* url = [[NSURL alloc] initWithString:nodejs];
    
    /* note_09.15.16: legacy swift 2.2 support */
    //_chatSocket = [[SocketIOClient alloc] initWithSocketURL:url options:@{@"log": @NO,@"forcePolling":@YES,@"reconnects":@YES,@"reconnectWait":@1}];
    
    /* note_09.15.16: update for swift 2.3 support */
    _chatSocket = [[SocketIOClient alloc] initWithSocketURL:url config:@{@"log": @NO,@"forcePolling":@YES,@"reconnects":@YES,@"reconnectWait":@1}];
    
    [_chatSocket connect];
    
    [self getNodeJSInfo];
    self.speakField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 11, self.speakField.frame.size.height)];
    self.speakField.leftViewMode = UITextFieldViewModeAlways;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    

}

- (void)initArray {
    _redisArray = [NSMutableArray array];
    self.listArray = [NSMutableArray array];
    self.chatModels = [NSMutableArray array];
    self.allArray = [NSMutableArray array];
    msgList = [NSMutableArray array];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (_firstLoad) {
        [self initLiveStream];
        [self initRoom];
        [self setStreamerCfg];
        [self addNotification];
    }
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    if (_firstLoad) {
        _firstLoad = NO;
        [self initAllView];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (heartbeatTime){
        [heartbeatTime invalidate];
    }
    
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
}

#pragma mark - Recognizer
- (void)initRecognizer {
    UITapGestureRecognizer *TapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(interfaceViewClick:)];
    [self.view addGestureRecognizer:TapGesture];
    UITapGestureRecognizer *votesTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(votesViewClick)];
    [self.votesView addGestureRecognizer:votesTapGesture];
    UITapGestureRecognizer *anchorHeadTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(anchorHeadTapGestureClick:)];
    [self.anchorHead addGestureRecognizer:anchorHeadTapGesture];
}

#pragma mark - Notification
- (void)addNotification {
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onStreamStateChange:)
                                                 name:KSYStreamStateDidChangeNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onNetStateEvent:)
                                                 name:KSYNetStateEventNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
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
    self.interfaceViewBottom.constant = -43;
    [UIView animateWithDuration:0.3 animations:^{
        [self.interfaceView layoutIfNeeded];
    }];
}


- (void)removeNotification {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:KSYStreamStateDidChangeNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:KSYNetStateEventNotification
                                                  object:nil];
}

- (void)onNetStateEvent:(NSNotification *)notification {
    KSYNetStateCode netEvent = _streamer.streamerBase.netStateCode;

    if ( netEvent == KSYNetStateCode_SEND_PACKET_SLOW ) {
        XLM_alert(@"KSYNetStateCode == '%lu'\nbad network\n\n\n", (unsigned long)netEvent);
    }else if ( netEvent == KSYNetStateCode_EST_BW_RAISE ) {
        XLM_alert(@"KSYNetStateCode == '%lu'\nbitrate raising\n\n\n", (unsigned long)netEvent);
    }else if ( netEvent == KSYNetStateCode_EST_BW_DROP ) {
        XLM_alert(@"KSYNetStateCode == '%lu'\nbitrate dropping\n\n\n", (unsigned long)netEvent);
    }else if ( netEvent == KSYNetStateCode_KSYAUTHFAILED ) {
        XLM_alert(@"KSYNetStateCode == '%lu'\nSDK auth failed, SDK will stop stream in a few minius\n\n\n", (unsigned long)netEvent);
    }else if ( netEvent == KSYNetStateCode_IN_AUDIO_DISCONTINUOUS ) {
        XLM_alert(@"KSYNetStateCode == '%lu'\nKSYNetStateCode_IN_AUDIO_DISCONTINUOUS\n\n\n", (unsigned long)netEvent);
    }
}

- (void)onStreamStateChange:(NSNotification *)notification {
    KSYStreamState state = _streamer.streamerBase.streamState;

    if (state == KSYStreamStateIdle) {
        XLM_alert(@"KSYStreamState == '%lu'\nKSYStreamStateIdle\n\n\n", (unsigned long)state);
        [self onPreview];
        [self onStream];
    }else if (state == KSYStreamStateConnected){
        XLM_alert(@"KSYStreamState == '%lu'\nKSYStreamStateConnected\n\n\n", (unsigned long)state);
        if (state == KSYStreamErrorCode_KSYAUTHFAILED ) {
            XLM_info(@"KSYStreamState == '%lu'\nKSYStreamStateConnected & KSYStreamErrorCode_KSYAUTHFAILED\n\n\n", (unsigned long)state);
            NSLog(@"KSYStreamState == '%lu'\nAuth failed, stream would stop in 5~8 minute", (unsigned long)state);
        }
    }else if (state == KSYStreamStateConnecting) {
        XLM_alert(@"KSYStreamState == '%lu'\nKSYStreamStateConnecting\n\n\n", (unsigned long)state);
        if (state == KSYStreamErrorCode_KSYAUTHFAILED ) {
            XLM_info(@"KSYStreamState == '%lu'\nKSYStreamStateConnecting & KSYStreamErrorCode_KSYAUTHFAILED\n\n\n", (unsigned long)state);
            NSLog(@"KSYStreamState == '%lu'\nAuth failed, stream would stop in 5~8 minute", (unsigned long)state);
        }
    }else if (state == KSYStreamStateDisconnecting) {
        XLM_alert(@"KSYStreamState == '%lu'\nKSYStreamStateDisconnecting\n\n\n", (unsigned long)state);
        [self onStreamError];
    }else if (state == KSYStreamStateError) {
        XLM_alert(@"KSYStreamState == '%lu'\nKSYStreamStateError\n\n\n", (unsigned long)state);
        [self onStreamError];
        return;
    }
}

- (void)onStreamError {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_streamer.streamerBase stopStream];
        [_streamer.streamerBase startStream:[ServerURL getPushUrl]];
    });
}

#pragma mark - UI
- (void)initAllView {
    _barrageView = [[GrounderSuperView alloc] initWithFrame:CGRectMake(0, 116, _window_width, 140)];
    _barrageView.userInteractionEnabled = NO;
    [self.view addSubview:_barrageView];
    
    _reportView = [ReportView reportView];
    _reportView.frame = CGRectMake((_window_width - 253)/2, (_window_height - 350)/2, 253, 350);
    __weak typeof(self) weakSelf = self;
    _reportView.closeBtnClickBlock = ^{
        weakSelf.reportBackgroundView.hidden = YES;
    };
    _reportView.profileBtnClickBlock = ^{
        ProfileUserViewController *vc = [[ProfileUserViewController alloc] init];
        vc.popupModel = _reportView.popupModel;
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
    
    _giftExhibition = [[GiftExhibition alloc] init];
    _giftExhibition.frame = CGRectMake(0, 0, 200, 88);
    [self.giftExhibitionBackground addSubview:_giftExhibition];
}

/*  
    eg: please do not simply copy and paste functions from one class to another
        please be sure to consider the integration and use cases of each class
        this entire function was copied to or from '[LookLiveStreamViewController updataView]'
 
         don't be a 'copy & paster' ; /   <-- don't be that guy!
 */
- (void)updataView {
    [self.anchorHead sd_setImageWithURL:[NSURL URLWithString:_audienceModel.avatar]];
    self.anchorGenderimage.image = [UIImage imageNamed:[Common getGenderImageNameWithType:_audienceModel.gender]];
    self.anchorEllipseImage.image = [UIImage imageNamed:[Common getEllipseImageNameWithLevle:_audienceModel.level]];
    self.anchorNameLab.text = _audienceModel.userNicename;
    self.anchorLevelLab.text = _audienceModel.level;
}

- (void)updateAudienceScrollView {
    for (UIView *view in self.audienceScrollView.subviews) {
        [view removeFromSuperview];
    }
    
    CGFloat imageW = 32;
    CGFloat spacing = 6;
    CGFloat audienceScrollViewH = self.audienceScrollView.frame.size.height;
    for (int index = 0; index < _redisArray.count; index++) {
        RedisModel *model = _redisArray[index];
        UIImageView *image = [[UIImageView alloc] init];
        image.frame = CGRectMake(index*(imageW + spacing), (audienceScrollViewH - imageW)/2, imageW, imageW);
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
                rankingImage.frame = CGRectMake(index*(imageW + spacing) + 25, (audienceScrollViewH - imageW)/2 +20, 11, 15);
                [self.audienceScrollView addSubview:rankingImage];
            }
                break;
            case 1:{
                UIImageView *rankingImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"2nd"]];
                rankingImage.frame = CGRectMake(index*(imageW + spacing) + 25, (audienceScrollViewH - imageW)/2 +20, 11, 15);
                [self.audienceScrollView addSubview:rankingImage];
            }
                break;
            case 2:{
                UIImageView *rankingImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"3rd"]];
                rankingImage.frame = CGRectMake(index*(imageW + spacing) + 25, (audienceScrollViewH - imageW)/2 +20, 11, 15);
                [self.audienceScrollView addSubview:rankingImage];
            }
                break;
            default:
                break;
        }
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(audienceClick:)];
        [image addGestureRecognizer:tapGesture];
    }
    [self.audienceScrollView setContentSize:CGSizeMake(_redisArray.count*(imageW + spacing), audienceScrollViewH)];
}

#pragma mark - liveStream
- (void)initRoom {
    [HttpService createRoomWithTitle:self.liveTitle province:@"" city:@"" longitude:self.longitude latitude:self.latitude channel:self.channelID  tags:self.tags result:^(CommonReturn *commonReturn) {
        if (commonReturn.state == 1) {
            [self getRedislist];
        }else{
            [MBProgressHUD showError:@"Net Error"];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
    [HttpService getInfoWithUcuid:[Config getOwnID] result:^(CommonReturn *commonReturn) {
        if (commonReturn.state == 1) {
            PersonalInfoModel *personalInfoModel = [[PersonalInfoModel alloc] initWithDictionary:commonReturn.data];
            self.likesLab.text = [NSString stringWithFormat:@"%ld",personalInfoModel.likes];
            _likeNum = personalInfoModel.likes;
        }
    }];
     
}

- (void)initLiveStream {
    _preview = [[GPUImageView alloc] init];
    [_preview setFillMode:kGPUImageFillModePreserveAspectRatioAndFill];
    _preview.frame = CGRectMake(0, 0, _window_width, _window_height);
    [self.preSuperView addSubview:_preview];
    _streamer = [[KSYGPUStreamer alloc] initWithDefaultCfg];
    [_streamer.streamerBase startStream:[ServerURL getPushUrl]];
}


- (void)onPreview {
    if ( ! _capDev.isRunning ) {
        [self setStreamerCfg];
        [_capDev startCameraCapture];
    }
}

- (void)onStream {
    
    if (NO == _capDev.isRunning) {
        return;
    }
    if (_streamer.streamerBase.streamState != KSYStreamStateConnected) {
        [_streamer.streamerBase startStream:[ServerURL getPushUrl]];
        [_bgPlay setBgmVolume:1];
    }
    else {
        [_streamer.streamerBase stopStream];
    }
    return;
}

- (void)setStreamerCfg {
    UIInterfaceOrientation orien = [[UIApplication sharedApplication] statusBarOrientation];
    CGRect rect ;
    double srcWdt = 480.0;
    double srcHgt = 640.0;
    double dstWdt = 320.0;
    double dstHgt = 640.0;
    double x = (srcWdt-dstWdt)/2/srcWdt;
    double y = (srcHgt-dstHgt)/2/srcHgt;
    double wdt = dstWdt/srcWdt;
    double hgt = dstHgt/srcHgt;
    if (orien == UIInterfaceOrientationPortrait ||
        orien == UIInterfaceOrientationPortraitUpsideDown) {
        rect = CGRectMake(x, y, wdt, hgt);
    }
    else {
        rect = CGRectMake(y, x, hgt, wdt);
    }
    
    // capture settings
    NSString *preset = @"";
    preset = AVCaptureSessionPreset640x480;
    _cropfilter = [[GPUImageCropFilter alloc] initWithCropRegion:rect];
    _streamer = [[KSYGPUStreamer alloc] initWithDefaultCfg];
    
    _streamer.streamerBase.shouldEnableKSYStatModule = NO;
    _streamer.streamerBase.logBlock = ^(NSString *string){
        NSLog(@"logBlock: %@", string);
    };
    _capDev = [[KSYGPUCamera alloc] initWithSessionPreset:preset
                                           cameraPosition:AVCaptureDevicePositionFront];
    if (_capDev == nil) {
        return;
    }
    _capDev.outputImageOrientation = orien;
    _filter = [[KSYGPUBeautifyFilter alloc] init];
    _capDev.bStreamVideo = NO;
    _capDev.bStreamAudio = YES;
    [_capDev setAudioEncTarget:_streamer];
    _capDev.horizontallyMirrorFrontFacingCamera = NO;
    _capDev.horizontallyMirrorRearFacingCamera  = NO;
    
    /* legacy */
    //_capDev.frameRate = 15;
    /* _legacy */
    
    _capDev.frameRate = fps_livestream_KSYGPUCamera;
    
    [_capDev addAudioInputsAndOutputs];
    
    _streamer.streamerBase.videoCodec = KSYVideoCodec_X264;
    _streamer.streamerBase.videoFPS   = _capDev.frameRate;
    
    /* legacy */
    //_streamer.streamerBase.audiokBPS  = 48;   // k bit ps
    /* _legacy */
    
    /* teo_10.03.16 */
    _streamer.streamerBase.audiokBPS  = 32;   // k bit ps
    /* _jason_10.03.16 */
    
    _streamer.streamerBase.enAutoApplyEstimateBW = YES;
    
    _streamer.streamerBase.videoMaxBitrate   = bitrate_max; // k bit ps
    _streamer.streamerBase.videoMinBitrate   = bitrate_min;  // k bit ps

    [_capDev addTarget:_filter];
    [_filter addTarget:_cropfilter];
    [_cropfilter addTarget:_preview];
    [_cropfilter addTarget:_streamer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        [MBProgressHUD showMessage:@"Loading..."];
        [HttpService stopRoomWithResult:^(CommonReturn *commonReturn) {
            [MBProgressHUD hideHUD];
            if (commonReturn.state == 1) {
                [_chatSocket disconnect];
                isReConSocket = NO;
                [_streamer.streamerBase stopStream];
                XLM_info(@"stop stream success");
                UIStoryboard *sb = [UIStoryboard storyboardWithName:@"LiveStream" bundle:[NSBundle mainBundle]];
                LivestreamSummaryViewController *vc = [sb instantiateViewControllerWithIdentifier:@"LivestreamSummaryViewController"];
                vc.liveTitle = [NSString stringWithString:self.liveTitle];
                [self removeNotification];
                [self.navigationController pushViewController:vc animated:NO];
            }else{
                [MBProgressHUD showError:@"Net Error"];
            }
        }];
        
    }
}

#pragma mark - Click
- (IBAction)closeBtnClick:(UIButton *)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"End live?" message:@"" delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"Yes", nil];
    [alert show];
}

- (IBAction)cameraFlipBtnClick:(UIButton *)sender {
//    [UIView transitionWithView:self.view
//                      duration:1.0
//                       options:UIViewAnimationOptionAllowAnimatedContent | UIViewAnimationOptionTransitionFlipFromLeft
//                    animations:^ {
////                        [_capDev rotateCamera];
//                    }completion:^(BOOL finished) {
//                        [_capDev rotateCamera];
//                    }];
    
//    [CATransaction begin];
//    [CATransaction setCompletionBlock:^{
//
//    }];
//    
//    [_capDev rotateCamera];
//    [CATransaction commit];
    [_capDev rotateCamera];
}

- (IBAction)shareBtnClick:(UIButton *)sender {
    [self.view endEditing:YES];
    self.interfaceView.hidden = YES;
    self.shareView.hidden = NO;
}

- (IBAction)messageBtnClick:(UIButton *)sender {
    [self.speakField becomeFirstResponder];
}

- (IBAction)boostBtnClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        self.speakField.placeholder = @"Boost this post for 10 coins";
    } else {
        self.speakField.placeholder = @"Say Something...";
    }
    
    [ViewModifierHelpers setTextField:self.speakField phColor:[UIColor lightGrayColor] textColor:[UIColor whiteColor]];
}

- (IBAction)sendBtnClick:(UIButton *)sender {
    NSLog(@"%s",__func__);
    [self pushMessage:self.speakField];
}

- (void)interfaceViewClick:(UITapGestureRecognizer *)sender {
    [self.view endEditing:YES];
    if (!self.shareView.hidden) {
        CGPoint point = [sender locationInView:self.view];
        if (CGRectContainsPoint(self.shareView.frame, point)) {
            return;
        }
        self.shareView.hidden = YES;
        self.interfaceView.hidden = NO;
    }
}

- (void)votesViewClick {
    TopFansViewController *vc = [[TopFansViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)audienceClick:(UITapGestureRecognizer *)Recognizer {
    NSLog(@"Recognizer.view.tag = %ld",Recognizer.view.tag);
    self.reportBackgroundView.hidden = NO;
//    _reportView.showid = [Config getOwnID];
    _reportView.showid = _redisArray[Recognizer.view.tag - 200].idField;
    _reportView.targetuid = _redisArray[Recognizer.view.tag - 200].idField;
    [_reportView updateView];
}

- (void)anchorHeadTapGestureClick:(UITapGestureRecognizer *)Recognizer {
    self.reportBackgroundView.hidden = NO;
    _reportView.showid = [Config getOwnID];
    _reportView.targetuid = _reportView.showid;
    [_reportView updateView];
}

#pragma mark - Share
- (IBAction)copyLinkBtnClick:(UIButton *)sender {
    XL_enter();
    [MiscUtilities copyToPastboard:str_appstore_link];
    NSString *title = [NSString stringWithFormat:@"iGoLive Stream Link:\n%@", str_appstore_link];
    [AlertViewHelpers presentAlertWithTitle:title message:@"coppied to clipboard" delegate:nil];
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
                        error:(NSError *)error
{
    XL_enter();
    [controller dismissViewControllerAnimated:YES completion:nil];
}
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller
                 didFinishWithResult:(MessageComposeResult)result {
    XL_enter();
    [controller dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Net
- (void)getRedislist {
    [HttpService getRedislistWithShowid:[Config getOwnID] result:^(CommonReturn *commonReturn) {
        if (commonReturn.state == 1) {
            self.onlineLabel.text = commonReturn.data[@"nums"];
            self.anchorVotes.text = commonReturn.data[@"votestotal"];
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

#pragma mark - Animation
- (void)openingAnimation {
    //倒计时动画 ('countdown animation')
    backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _window_width, _window_height)];
    backView.backgroundColor = [UIColor clearColor];
    label1 = [[UILabel alloc]initWithFrame:CGRectMake(_window_width/2 -100, _window_height/2-200, 100, 100)];
    label1.backgroundColor = [UIColor clearColor];
    label1.textColor = [UIColor whiteColor];
    label1.font = [UIFont systemFontOfSize:90];
    label1.text = @"3";
    label1.textAlignment = NSTextAlignmentCenter;
    label1.center = backView.center;
    
    label2 = [[UILabel alloc]initWithFrame:CGRectMake(_window_width/2 -100, _window_height/2-200, 100, 100)];
    
    label2.backgroundColor = [UIColor clearColor];
    label2.textColor = [UIColor whiteColor];
    label2.font = [UIFont systemFontOfSize:90];
    label2.text = @"2";
    label2.textAlignment = NSTextAlignmentCenter;
    label2.center = backView.center;
    
    label3 = [[UILabel alloc]initWithFrame:CGRectMake(_window_width/2 -100, _window_height/2-200, 100, 100)];
    label3.backgroundColor = [UIColor clearColor];
    label3.textColor = [UIColor whiteColor];
    label3.font = [UIFont systemFontOfSize:90];
    label3.text = @"1";
    label3.textAlignment = NSTextAlignmentCenter;
    label3.center = backView.center;
    
    
    label1.hidden = YES;
    label2.hidden = YES;
    label3.hidden = YES;
    
    
    
    [backView addSubview:label3];
    [backView addSubview:label1];
    [backView addSubview:label2];
    [self.view addSubview:backView];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        label1.hidden = NO;
        [self donghua:label1];
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.7 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        label1.hidden = YES;
        label2.hidden = NO;
        [self donghua:label2];
    });
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        label2.hidden = YES;
        label3.hidden = NO;
        [self donghua:label3];
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        label3.hidden = YES;
        [backView removeFromSuperview];
//        [self onStream:nil];
        
//        keyBTN.userInteractionEnabled  = YES;
    });
    

}

-(void)donghua:(UILabel *)label{
    
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = 0.8;
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(4.0, 4.0, 4.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(3.0, 3.0, 3.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(2.0, 2.0, 2.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 0.1)]];
    animation.values = values;
    animation.removedOnCompletion = NO;//是不是移除动画的效果
    animation.fillMode = kCAFillModeForwards;//保持最新状态
    [label.layer addAnimation:animation forKey:nil];
    
}

- (void)heartAnimateWithLevel:(NSString *)level {
    NSString *imageName = [Common getHeartImageNameWithLevle:level];
    
    CGFloat imageW = 23;
    CGFloat imageH = 22;
    UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
    CGRect startRect = self.btnCameraFlip.frame;
    
    /* legacy */
    //startRect.origin.y = _window_height - 260 - imageH;
    
    /* eg */
    CGFloat heartY = self.btnCameraFlip.frame.origin.y;
    CGFloat heartHeight = self.btnCameraFlip.frame.size.height;
    startRect.origin.y = heartY - heartHeight;
    /* _eg */
    
    startRect.origin.x += (self.btnCameraFlip.frame.size.width - imageW)/2;
    startRect.size.width = imageW;
    startRect.size.height = imageH;
    image.frame = startRect;
    
    /* legacy */
    //[self.interfaceView addSubview:image];
    
    /* eg */
    [self.view addSubview:image];
    /* _eg */
    
    image.alpha = 0;
    
    [UIView animateWithDuration:0.3 animations:^{
        image.alpha = 1;
    } completion:^(BOOL finished) {
        
        /* legacy */
        //CGFloat randomX = arc4random_uniform(_window_width*0.25) + _window_width*0.7;
        
        /* eg */
        CGFloat vwidth = self.view.frame.size.width;
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
                             image.frame = CGRectMake(randomX,200,imageW*1.3,imageH*1.3);
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
- (void)doCancelShowNetworkError
{
    [MBProgressHUD showError:@"Network Error (no data)\n please try again"];
    [self docancle];
}
- (void)docancle {
    [self closeBtnClick:nil];
}

#pragma mark - socket.io
-(void)addNodeListen {
    connState = NO;

    NSArray *cur = @[@{@"username":[Common clearNil:[Config getOwnNicename]],
                       @"uid":[Config getOwnID],
                       @"token":[Config getOwnToken],
                       @"roomnum":[Config getOwnID]
                       }];
    [_chatSocket on:@"connect" callback:^(NSArray* data, SocketAckEmitter* ack) {
        XLM_enter(@"socket '%@'", @"connect");
        connState = YES;
        if(isReConSocket) {
            [HttpService setNodejsInfoWithShowid:[Config getOwnID] result:^(CommonReturn *commonReturn) {
                [_chatSocket emit:kSockConn withItems:cur];
            }];
            return;
        } else {
            [_chatSocket emit:kSockConn withItems:cur];
        }
    }];

    [_chatSocket on:kSockDisconnect callback:^(NSArray* data, SocketAckEmitter* ack) {
        XLM_enter(@"socket '%@'", kSockDisconnect);
    }];
    
    [_chatSocket on:kSockConn callback:^(NSArray* data, SocketAckEmitter* ack) {
        XLM_enter(@"socket '%@'", kSockConn);
        XLM_info(@"进入房间 ('Enter Room')%@",data);
        
        if(!isReConSocket) {
            userCount = 0;
            [self getRedislist];//获取观众列表 ('get at list of the audience')
            if(!heartbeatTime) {
                heartbeatTime = [NSTimer scheduledTimerWithTimeInterval:heartbeat_timer_sec target:self selector:@selector(sendHeartbeat) userInfo:nil repeats:YES];
                heartbeatTime.tolerance = (heartbeat_timer_sec * 0.10);
            }
        }
    }];
    
    [_chatSocket on:kSockReconnect callback:^(NSArray *data, SocketAckEmitter *ack) {
        XLM_enter(@"socket '%@'",kSockReconnect);
        [_chatSocket connect];
        isReConSocket = YES;
    }];
    
    
    //连接出错了 ('wrong connection')
    [_chatSocket on:kSockError callback:^(NSArray * data, SocketAckEmitter * ack) {
        XLM_enter(@"socket '%@'",kSockError);
        isReConSocket = YES;
    }];
    
    [_chatSocket on:kSockBroadcastListen callback:^(NSArray* data, SocketAckEmitter* ack) {
        XLM_enter(@"socket '%@'",kSockBroadcastListen);
        
        NSString *strdata = [NetworkRequestHelpers getJSONDescriptionFromArrayPayload:data];
        XLM_info(@"received node data array (raw):\n %@", [data description]);
        XLM_info(@"received node data array (pretty):\n %@", strdata);
        
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
        
        /* legacy */
        //NSArray* JsonDataArray = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
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
                    //   ct = [ct stringByAppendingPathComponent:@"❤"];//♡❤
                    //   ct = [ct stringByReplacingOccurrencesOfString:@"/" withString:@""];
                    NSString *city = [msgdict valueForKey:@"city"];
                    NSString* uname = [msgdict valueForKey:@"uname"];
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
                    _likeNum++;
                    self.likesLab.text = [Common likeStringWithNum:_likeNum];
                    [self heartAnimateWithLevel:levell];
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
                //用户离开 ('the user leaves')
                if ([action isEqual:@"1"]) {
                    
                    XLM_info(@"用户离开 ('the user leaves')，%@",msgdict);
                    
                    userCount -= 1;
                    
                    self.self.onlineLabel.text = [NSString stringWithFormat:@"%lld",userCount];
                    
                    NSString *ID = [[msgdict valueForKey:@"ct"] valueForKey:@"uid"];
                    
                    [self.listArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                        for (NSDictionary *dic in self.listArray) {
                            if ([[dic valueForKey:@"id"] isEqualToString:ID]) {
                                [self.listArray removeObject:dic];
                                //                                [listCollectionview reloadData];
                                return;
                    }}}];
                }
                
                //用户进入 ('user access')
                if ([action isEqual:@"0"]) {
                    userCount += 1;
                    self.onlineLabel.text = [NSString stringWithFormat:@"%lld",userCount];
                    
                    [self.listArray addObject:[msgdict valueForKey:@"ct"]];
                    
                    [IGUtils quickSort1:self.listArray];
                    RedisModel *model = [[RedisModel alloc] initWithDictionary:msgdict[@"ct"]];
                    [_redisArray addObject:model];
                    [self updateAudienceScrollView];
                    /* legecy commented */
                    //[listCollectionview reloadData];
            }}
            
            if ([msgtype isEqual:@"1"]) {
                NSString *action = [msgdict valueForKey:@"action"];
                if ([action isEqual:@"18"]) {
                    NSLog(@"finished");
                    [self onStopVideo];
            }}
        } else if ([method isEqual:@"light"]) {
            NSString *msgtype = [msgdict valueForKey:@"msgtype"];
            if([msgtype isEqual:@"0"]) {
                
                NSString *action = [msgdict valueForKey:@"action"];
                //点亮
                if ([action isEqualToString:@"2"]) {
                    firstStar = 1;
                    [self starok2];
            }}
            [self jumpLast];
            
        } else if ([method isEqual:@"SystemNot" ] || [method isEqualToString:@"ShutUpUser"]){
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
            [self.tableView reloadData]; // bottom table view ( i think for chat )
            
            titleColor = @"0";
        } else if ([method isEqual:@"SendGift"]) {
            SendGiftModel *model = [[SendGiftModel alloc] initWithDictionary:(NSDictionary *)msgdict];
            [_giftExhibition showGiftWithSendGiftModel:model];
            
            NSString *strgiftid = [msgdict valueForKey:@"giftid"];
            [IGOHelpers runGiftAnimationForGiftID:strgiftid withImageView:self.ivGiftAnimation];
            
            NSDictionary *ct = [msgdict valueForKey:@"ct"];
            NSString *ctt = [NSString stringWithFormat:@" Sent a %@",[ct valueForKey:@"giftname"]];
            NSString *city = [msgdict valueForKey:@"city"];
            NSString* uname = [msgdict valueForKey:@"uname"];
            NSString *levell = [msgdict valueForKey:@"level"];
            NSString *ID = [msgdict valueForKey:@"uid"];
            NSString *signature = [msgdict valueForKey:@"usign"];
            NSString *avatar = [msgdict valueForKey:@"uhead"];
            NSString *sex = [msgdict valueForKey:@"sex"];
            
            NSDictionary *chat6 = [NSDictionary dictionaryWithObjectsAndKeys:uname,@"userName",ctt,@"contentChat",levell,@"levelI",ID,@"id",titleColor,@"titleColor",city,@"city",avatar,@"avatar",sex,@"sex",signature,@"signature",nil];
            [msgList addObject:chat6];
            
            int oldNum = [self.anchorVotes.text intValue];
            int newNUm = oldNum + (int)model.ct.totalcoin;
            self.anchorVotes.text = [NSString stringWithFormat:@"%d",newNUm];
            
            [self.tableView reloadData];
            [self jumpLast];
            
        } else if ([method isEqualToString:@"SendBarrage"]) {
            
            [IGOHelpers vibratePhone];
            
//            NSString *text = [NSString stringWithFormat:@"%@",[[msgdict valueForKey:@"ct"] valueForKey:@"content"]];
//            NSString *name = [[msgdict valueForKey:@"ct"] valueForKey:@"nicename"];
//            
//            NSString *icon = [[msgdict valueForKey:@"ct"] valueForKey:@"avatar"];
            
//            NSDictionary *userinfo = [[NSDictionary alloc] initWithObjectsAndKeys:text,@"title",name,@"name",icon,@"icon",nil];
            NSData *tempData = [data[0] dataUsingEncoding:NSUTF8StringEncoding];
            
            NSDictionary *tempDict = [NSJSONSerialization JSONObjectWithData:tempData options:0 error:nil];
            [_barrageView setModel:tempDict[@"msg"][0]];
        } else if ([method isEqualToString:@"StartEndLive"]) {
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

-(void)sendHeartbeat
{
    //    NSLog(@"i am a live");
    [_chatSocket emit:@"heartbeat" withItems:@[@"i am a live"]];
    
}

- (void)jumpLast
{
    
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

- (void)onStopVideo{
//    if (_player) {
//        NSLog(@"player download flow size: %f MB", _player.readSize);
//        NSLog(@"buffer monitor  result: \n   empty count: %d, lasting: %f seconds",
//              (int)_player.bufferEmptyCount,
//              _player.bufferEmptyDuration);
//        
//        [_player stop];
//        
//        [_player.view removeFromSuperview];
//        
//        _player = nil;
//        
//    }
}

//收到点亮消息显示❤️
-(void)starok2{
    
    //    [self staredMove];
    
}


// 以下是 tableview的方法
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger row = indexPath.row;
    ChatModel *model = _chatModels[row];
    return model.rowHH;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSUInteger count = self.chatModels.count;
    return count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSInteger row = indexPath.row;
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    static NSString *SimpleTableIdentifier = @"tableviewchat";
    Chatcell *cell = [tableView dequeueReusableCellWithIdentifier: SimpleTableIdentifier];
    if(cell == nil)
    {
        cell = [[Chatcell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SimpleTableIdentifier];
    }
    
    
    //    chatcell *cell = [chatcell cellWithtableView:tableView];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    cell.model = self.chatModels[row];
    cell.backgroundColor = [UIColor clearColor];
    cell.clickBlock = ^(NSString *uid) {
        self.reportBackgroundView.hidden = NO;
        _reportView.showid = [Config getOwnID];
        _reportView.targetuid = uid;
        [_reportView updateView];
    };
    
    return cell;
    
}

-(NSMutableArray *)chatModels{
    
    NSMutableArray *array = [NSMutableArray array];
    for (NSDictionary *dic in msgList) {
        
        ChatModel *model = [ChatModel modelWithDic:dic];
        
        [model setChatFrame:[_chatModels lastObject]];
        
        [array addObject:model];
    }
    _chatModels = array;
    
    return _chatModels;
}

- (BOOL)textFieldShouldReturn:( UITextField *)textField{
    [self pushMessage:nil];
    return NO ;
}

-(void)pushMessage:(UITextField *)sender{
    if (![self socketIsConnected]) {
        [MBProgressHUD showError:@"Chat server connection failed"];
        return;
    }
    self.content = self.speakField.text;
    self.speakField.text = @"";
    if (self.content.length <=0) {
        return;
    } else if ([self.content isEqualToString: @""]) {
        return;
    } else if ([self.content isEqualToString:@" "]) {
        return;
    }else if (self.boostBtn.selected) {
        [self sendBarrage];
    } else {
        
        [self.view endEditing:NO];
        
        titleColor = @"0";
        
        //判断  是否被禁言
        [HttpService isShutUpWithUid:[Config getOwnID] showid:[Config getOwnID] result:^(CommonReturn *commonReturn) {
            if (commonReturn.state == 1) {
                if ([commonReturn.data intValue] == 1) {
                    NSLog(@"被禁言");
                    [MBProgressHUD showError:@"你已被禁言"];
                }else{
                    NSString *dateStr = [self GetNowDate];
//                    if (huifuOK == 1) {
//                        
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
//                    }
                    
                    
                    LiveUser *user = [Config myProfile];
                    NSLog(@"user = %@",user);
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
                                                        //                                                            @"city":[nodejsInfo valueForKey:@"city"],
                                                        @"city":@"city",
                                                        @"touname": @"",
                                                        @"ugood": [Config getOwnID],
                                                        @"uid": [Config getOwnID],
                                                        @"uname": [Config getOwnNicename],
                                                        @"equipment": @"app",
                                                        @"roomnum": [Config getOwnID],
                                                        @"usign":_audienceModel.signature,
                                                        @"uhead":_audienceModel.avatar,
                                                        @"level":_audienceModel.level,
                                                        @"sex":user.gender
                                                        }
                                                    ],
                                            @"retcode": @"000000",
                                            @"retmsg": @"OK"
                                            }
                                        ];    [_chatSocket emit:@"broadcast" withItems:msgData];
                }
            }
        }];
    }
}

- (void)sendBarrage {
    
    [self.view endEditing:NO];
    /*******发送弹幕开始 **********/
    [HttpService sendBarrageWithTouid:[Config getOwnID] content:self.content result:^(CommonReturn *commonReturn) {
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
//            self.coinLab.text = [NSString stringWithFormat:@"Refill : %lld",newCoin];
            
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
                                                @"roomnum": [Config getOwnID],
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
    //        AFHTTPRequestOperationManager *Manager = [[AFHTTPRequestOperationManager alloc] init];
    //        NSString *url = [purl stringByAppendingFormat:@"?service=Room.SendBarrage&uid=%@&token=%@&touid=%@&content=%@",[Config getOwnID],[Config getOwnToken],self.liveModel.idField,sendContent];
    //        [Manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation,id responseObject) {
    //            NSNumber *number = [responseObject valueForKey:@"ret"] ;
    //            if([number isEqualToNumber:[NSNumber numberWithInt:200]])
    //            {
    //                NSArray *data = [responseObject valueForKey:@"data"];
    //                NSNumber *code = [data valueForKey:@"code"];
    //                if([code isEqualToNumber:[NSNumber numberWithInt:0]])
    //                {
    //
    //
    //                    NSArray *info = [[data valueForKey:@"info"] valueForKey:@"barragetoken"];
    //                    NSString *dateStr = [self GetNowDate];
    //
    //                    _audienceModel.level = [[data valueForKey:@"info"] valueForKey:@"level"];
    //
    //                    //刷新本地钻石
    //                    LiveUser *liveUser = [Config myProfile];
    //                    long long oldCoin = [liveUser.coin longLongValue];
    //                    long long newCoin = oldCoin - 1;
    //                    if(newCoin <0)
    //                    {
    //                        newCoin = 0;
    //                    }
    //                    liveUser.coin = [NSString stringWithFormat:@"%lld",newCoin];
    //                    [Config updateProfile:liveUser];
    //                    self.coinLab.text = [NSString stringWithFormat:@"Refill : %lld",newCoin];
    //
    //                    NSArray *msgData =@[
    //                                        @{
    //                                            @"msg": @[
    //                                                    @{
    //                                                        @"_method_": @"SendBarrage",
    //                                                        @"action": @"0",
    //                                                        @"ct":info ,
    //                                                        @"msgtype": @"1",
    //                                                        @"timestamp": dateStr,
    //                                                        @"tougood": @"",
    //                                                        @"touid": @"0",
    //                                                        @"touname": @"",
    //                                                        @"ugood": [Config getOwnID],
    //                                                        @"uid": [Config getOwnID],
    //                                                        @"uname": [Config getOwnNicename],
    //                                                        @"equipment": @"app",
    //                                                        @"roomnum": self.liveModel.idField,
    //                                                        @"level":_audienceModel.level,
    //                                                        @"usign":_audienceModel.signature,
    //                                                        @"uhead":_audienceModel.avatar,
    //                                                        @"sex":liveUser.sex
    //                                                        }
    //                                                    ],
    //                                            @"retcode": @"000000",
    //                                            @"retmsg": @"OK"
    //                                            }
    //                                        ];
    //                    [ChatSocket emit:@"broadcast" withItems:msgData];
    //
    //                }
    //
    //                else
    //
    //                {
    //                    [MBProgressHUD showError:[data valueForKey:@"msg"]];
    //                }
    //            }
    //            else
    //            {
    //                NSLog(@"error to get info 01,url:%@""",url);
    //
    //                [MBProgressHUD showError:[NSString stringWithFormat:@"%@",[[responseObject valueForKey:@"data"] valueForKey:@"msg"]]];
    //            }
    //        }
    //             failure:^(AFHTTPRequestOperation *operation,NSError *error)
    //         {
    //             
    //         }];
    
    
    /*********************发送礼物结束 ************************/
    
    
    
}

- (NSString *)GetNowDate
{
    NSDate* date = [NSDate date];
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"HH:mm"];
    NSString* dateStr = [dateFormat stringFromDate:date];
    return dateStr;
}

-(void)getNodeJSInfo
{
    [HttpService setNodejsInfoWithShowid:[Config getOwnID] result:^(CommonReturn *commonReturn) {
        if (commonReturn.state == 1) {
            _audienceModel = [[AudienceModel alloc]initWithDictionary:commonReturn.data];
            [self updataView];
            [self addNodeListen];
        }else{
            XLM_error(@"failed to get room information; failed to [self updateView]; failed to [self addNodeListen]");
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
