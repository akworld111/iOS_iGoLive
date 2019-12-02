//
//  LiveStreamSettingsViewController.m
//  iphoneLive
//
//  Created by 高翔 on 16/8/10.
//  Copyright © 2016年 cat. All rights reserved.
//

#import "LiveStreamSettingsViewController.h"
#import "LiveStreamSettingsShareViewController.h"
//#import "CoreLocation.frameWork"
#import <CoreLocation/CoreLocation.h>

//#if run_release_mode
//
//#import "LiveStreamViewController.h"
//
//#endif

@interface LiveStreamSettingsViewController () <CLLocationManagerDelegate, UITextFieldDelegate> {
    BOOL _isShare;
    UILabel *_channelLabel;
    UILabel *_tagLabel;
    UIView *_channelView;
    UIView *_tagView;
    NSMutableArray <LiveChannelsModel *> *_channelsArray;
    NSMutableArray <UIButton *> *_selectTagsArray;
    XHFriendlyLoadingView *_loadingView;
    UIButton *_selectChannelBtn;
    
    CLLocationManager *_locationManager;
    NSString *_longitude;
    NSString *_latitude;
}
@property (weak, nonatomic) IBOutlet UITextField *titleField;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;
@property (weak, nonatomic) IBOutlet UIScrollView *tagScrollView;
@property (weak, nonatomic) IBOutlet UISwitch *locationSwitch;

@end

@implementation LiveStreamSettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleField.delegate = self;
    [self initAllUi];
    [self initRecognizer];
    [self initLocationManager];
    _selectTagsArray = [NSMutableArray array];
}

- (void)initLocationManager {
    // example
    // 实例化一个位置管理器
    _locationManager = [[CLLocationManager alloc] init];
    
    _locationManager.delegate = self;
    
    // 设置定位精度
    // kCLLocationAccuracyNearestTenMeters:精度10米
    // kCLLocationAccuracyHundredMeters:精度100 米
    // kCLLocationAccuracyKilometer:精度1000 米
    // kCLLocationAccuracyThreeKilometers:精度3000米
    // kCLLocationAccuracyBest:设备使用电池供电时候最高的精度
    // kCLLocationAccuracyBestForNavigation:导航情况下最高精度，一般要有外接电源时才能使用
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    // distanceFilter是距离过滤器，为了减少对定位装置的轮询次数，位置的改变不会每次都去通知委托，而是在移动了足够的距离时才通知委托程序
    // 它的单位是米，这里设置为至少移动1000再通知委托处理更新;
    _locationManager.distanceFilter = kCLDistanceFilterNone; // 如果设为kCLDistanceFilterNone，则每秒更新一次;
    [_locationManager requestAlwaysAuthorization];//添加这句
    [self startLocation];
}

#pragma mark - Actions
- (void)startLocation {
    // 判断的手机的定位功能是否开启
    // 开启定位:设置 > 隐私 > 位置 > 定位服务
    if ([CLLocationManager locationServicesEnabled]) {
        // 启动位置更新
        // 开启位置更新需要与服务器进行轮询所以会比较耗电，在不需要时用stopUpdatingLocation方法关闭;
        [_locationManager startUpdatingLocation];
    } else {
        NSLog(@"请开启定位功能！");
    }
}

#pragma mark - CLLocationManagerDelegate
// 地理位置发生改变时触发
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    // 获取经纬度
    NSLog(@"纬度:%f",newLocation.coordinate.latitude);
    NSLog(@"经度:%f",newLocation.coordinate.longitude);
    
    _longitude = [NSString stringWithFormat:@"%f",newLocation.coordinate.longitude];
    _latitude = [NSString stringWithFormat:@"%f",newLocation.coordinate.latitude];
    
    // 停止位置更新
    [manager stopUpdatingLocation];
}

// 定位失误时触发
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"error:%@",error);
}


- (void)initAllUi {
    [ViewModifierHelpers addGradientColorFadedSubLayerToView:self.view hexColorStart:col_view_bg_lt_purple hexColorEnd:col_view_bg_drk_purple];
    self.nextBtn.backgroundColor = UIColorFromHexAlpha(col_btn_green, 1.0f);
    //[ViewModifierHelpers addGradientColorFadedSubLayerToView:self.nextBtn hexColorStart:col_btnDone_drk_green hexColorEnd:col_btnDone_lt_green];
    
    [ViewModifierHelpers setTextField:self.titleField phColor:[UIColor lightGrayColor] textColor:[UIColor whiteColor]];
}

- (void)initRecognizer {
    UITapGestureRecognizer *TapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selfViewClick)];
    TapGesture.numberOfTapsRequired = 1;
    TapGesture.numberOfTouchesRequired = 1;
    [self.view addGestureRecognizer:TapGesture];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    [self clearAllTagBtn];
}

- (void)clearAllTagBtn {
    for (UIView *view in self.tagScrollView.subviews) {
        [view removeFromSuperview];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    _loadingView = [[XHFriendlyLoadingView alloc] initWithFrame:self.tagScrollView.frame];
    _loadingView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_loadingView];

    [self getTagsFromNet];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getTagsFromNet {
    [_loadingView showFriendlyLoadingViewWithText:@"Loading..." loadingAnimated:YES];
    __weak typeof(self) weakSelf = self;
    _loadingView.reloadButtonClickedCompleted = ^(UIButton *sender){
        [weakSelf getTagsFromNet];
    };
    
    [HttpService getChannelsWithResult:^(CommonReturn *commonReturn) {
        if (commonReturn.state == 1) {
            _channelsArray = [NSMutableArray array];
            for (NSDictionary *dict in commonReturn.data[@"dataArr"]) {
                if ([dict[@"is_special"] intValue] != 1) {
                    [_channelsArray addObject:[[LiveChannelsModel alloc] initWithDictionary:dict]];
                }
            }
            [self updataChannelView];
            if (_loadingView) {
                [_loadingView hideLoadingView];
            }
        } else {
            if (_loadingView) {
                [_loadingView showReloadViewWithText:@"Click to reload"];
            }
        }
    }];
//    [HttpService getTagsWithResult:^(CommonReturn *commonReturn) {
//        if (commonReturn.state == 1) {
//            NSMutableArray *muatbleArray = [NSMutableArray array];
//            for (NSDictionary *dict in commonReturn.data) {
//                [muatbleArray addObject:[[TagsModel alloc] initWithDictionary:dict]];
//            }
//            _tagsArray = [muatbleArray copy];
//            [self updataTagsScrollView];
//            if (_loadingView) {
//                [_loadingView hideLoadingView];
//            }
//        } else {
//            if (_loadingView) {
//                [_loadingView showReloadViewWithText:@"Click to reload"];
//            }
//        }
//    }];
}

- (void)updataChannelView {
    _channelLabel = [[UILabel alloc] init];
    _channelLabel.text = @"Select a Channel!";
    _channelLabel.textColor = [UIColor whiteColor];
    _channelLabel.frame = CGRectMake(5, 0, 200, 40);
    [self.tagScrollView addSubview:_channelLabel];
    _channelView = [[UIView alloc] init];
    CGFloat tagScrollW = self.tagScrollView.frame.size.width - 6;
    CGFloat tagW = tagScrollW/3 - 10;
    CGFloat tagH = 34;
    CGFloat spacingW = (tagScrollW - tagW*3)/2;
    CGFloat padding = 10;
    CGFloat spacingH = 11;
    CGFloat HCount = 0;
    CGFloat WCount = 0;
    CGFloat surplusW = tagScrollW;
    for (int index = 0; index <_channelsArray.count; index++) {
        CGFloat tagX = tagScrollW - surplusW + (WCount!=0)*spacingW;
        CGFloat tagY = HCount * (tagH+spacingH);
        UIButton *tagBtn = [[UIButton alloc] init];
        [tagBtn setTitle:_channelsArray[index].channelName forState:UIControlStateNormal];
        tagBtn.layer.cornerRadius = tagH/2;
        [tagBtn sizeToFit];
        if (tagBtn.frame.size.width+padding>tagW) {
            tagBtn.frame = CGRectMake(tagX, tagY, tagBtn.frame.size.width+padding, tagH);
            if (tagBtn.frame.size.width >= tagScrollW) {
                tagBtn.frame = CGRectMake(tagX, tagY, tagScrollW, tagH);
            }
        } else {
            tagBtn.frame = CGRectMake(tagX, tagY, tagW, tagH);
        }
        
        surplusW = tagScrollW - tagBtn.frame.size.width - tagBtn.frame.origin.x;
        
        if (_channelsArray.count > index+1) {
            UIButton *nextBtn = [[UIButton alloc] init];
            [nextBtn setTitle:_channelsArray[index+1].channelName forState:UIControlStateNormal];
            [nextBtn sizeToFit];
            nextBtn.frame = CGRectMake(0, 0, nextBtn.frame.size.width+padding, tagH);
            if (nextBtn.frame.size.width < tagW) {
                nextBtn.frame = CGRectMake(tagX, tagY, tagW, tagH);
            }
            BOOL lastProbably = NO;
            if (WCount == 1) {
                lastProbably = surplusW >= nextBtn.frame.size.width;
            }
            
            if (surplusW > nextBtn.frame.size.width+(spacingW*(WCount+1)) || lastProbably) {
                WCount++;
            } else {
                HCount++;
                WCount = 0;
                surplusW = tagScrollW;
            }
        }
        tagBtn.tag = index;
        tagBtn.layer.borderWidth = 1;
        tagBtn.layer.borderColor = [self colorWithHexString:_channelsArray[index].color].CGColor;

        [_channelView addSubview:tagBtn];
        [tagBtn addTarget:self action:@selector(channelBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    HCount++;
    _channelView.frame = CGRectMake(0, _channelLabel.frame.size.height, tagScrollW, HCount * (tagH + spacingH));
    [self.tagScrollView addSubview:_channelView];
    _tagLabel = [[UILabel alloc] init];
    _tagLabel.text = @"Select Tags";
    _tagLabel.textColor = [UIColor whiteColor];
    _tagLabel.frame = CGRectMake(5, _channelView.frame.origin.y + _channelView.frame.size.height, 200, 40);
    [self.tagScrollView addSubview:_tagLabel];
    CGFloat tagScrollViewNeedH = _channelLabel.frame.size.height + _channelView.frame.size.height + _tagLabel.frame.size.height;
    [self.tagScrollView setContentSize:CGSizeMake(tagScrollW, tagScrollViewNeedH)];
    
}

- (void)updataTagView {
    NSArray<Tag *> *tags = _channelsArray[_selectChannelBtn.tag].tags;
    if (!_tagView) {
        _tagView = [[UIView alloc] init];
        [self.tagScrollView addSubview:_tagView];
    } else {
        for (UIView *view in _tagView.subviews) {
            [view removeFromSuperview];
        }
    }
    CGFloat tagScrollW = self.tagScrollView.frame.size.width - 6;
    CGFloat tagW = tagScrollW/3 - 10;
    CGFloat tagH = 34;
    CGFloat spacingW = (tagScrollW - tagW*3)/2;
    CGFloat padding = 10;
    CGFloat spacingH = 11;
    CGFloat HCount = 0;
    CGFloat WCount = 0;
    CGFloat surplusW = tagScrollW;
    for (int index = 0; index < tags.count; index++) {
        CGFloat tagX = tagScrollW - surplusW + (WCount!=0)*spacingW;
        CGFloat tagY = HCount * (tagH+spacingH);
        UIButton *tagBtn = [[UIButton alloc] init];
        [tagBtn setTitle:tags[index].tag forState:UIControlStateNormal];
        tagBtn.layer.cornerRadius = tagH/2;
        [tagBtn sizeToFit];
        if (tagBtn.frame.size.width+padding>tagW) {
            tagBtn.frame = CGRectMake(tagX, tagY, tagBtn.frame.size.width+padding, tagH);
            if (tagBtn.frame.size.width >= tagScrollW) {
                tagBtn.frame = CGRectMake(tagX, tagY, tagScrollW, tagH);
            }
        } else {
            tagBtn.frame = CGRectMake(tagX, tagY, tagW, tagH);
        }
        
        surplusW = tagScrollW - tagBtn.frame.size.width - tagBtn.frame.origin.x;
        
        if (tags.count > index+1) {
            UIButton *nextBtn = [[UIButton alloc] init];
            [nextBtn setTitle:tags[index+1].tag forState:UIControlStateNormal];
            [nextBtn sizeToFit];
            nextBtn.frame = CGRectMake(0, 0, nextBtn.frame.size.width+padding, tagH);
            if (nextBtn.frame.size.width < tagW) {
                nextBtn.frame = CGRectMake(tagX, tagY, tagW, tagH);
            }
            BOOL lastProbably = NO;
            if (WCount == 1) {
                lastProbably = surplusW >= nextBtn.frame.size.width;
            }
            
            if (surplusW > nextBtn.frame.size.width+(spacingW*(WCount+1)) || lastProbably) {
                WCount++;
            } else {
                HCount++;
                WCount = 0;
                surplusW = tagScrollW;
            }
        }
        tagBtn.tag = index;
        tagBtn.layer.borderWidth = 1;
        tagBtn.layer.borderColor = [self colorWithHexString:_channelsArray[_selectChannelBtn.tag].color].CGColor;
        
        [_tagView addSubview:tagBtn];
        [tagBtn addTarget:self action:@selector(tagBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    HCount++;
    _tagView.frame = CGRectMake(0, _tagLabel.frame.origin.y + _tagLabel.frame.size.height, tagScrollW, HCount * (tagH + spacingH));
    CGFloat tagScrollViewNeedH = _tagView.frame.origin.y + _tagView.frame.size.height;
    [self.tagScrollView setContentSize:CGSizeMake(tagScrollW, tagScrollViewNeedH)];
    
}

- (void)setTagBtnActionTargets {
    for (id obj in self.tagScrollView.subviews)
    {
        if ([obj isKindOfClass:[UIButton class]])
        {
            UIButton *tagBtn = (UIButton*)obj;
            [tagBtn addTarget:self action:@selector(channelBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [self.tagScrollView bringSubviewToFront:tagBtn];
        }
    }
}

- (void)setChannelButtonSelectedState:(UIButton *)btn {
    _selectChannelBtn.selected = NO;
    [_selectChannelBtn setBackgroundColor:col_clearColor];
    _selectChannelBtn = btn;
    _selectChannelBtn.selected = !_selectChannelBtn.selected;
    [btn setBackgroundColor:[self colorWithHexString:_channelsArray[btn.tag].color]];
}

#pragma mark - Click
- (void)channelBtnClick:(UIButton *)sender {
    [self.view endEditing:YES];
    [_selectTagsArray removeAllObjects];
    [self setChannelButtonSelectedState:sender];
    [self updataTagView];
}

- (void)tagBtnClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        [sender setBackgroundColor:[self colorWithHexString:_channelsArray[_selectChannelBtn.tag].color]];
        [_selectTagsArray addObject:sender];
    } else {
        [sender setBackgroundColor:[UIColor clearColor]];
        [_selectTagsArray removeObject:sender];
    }
}

- (IBAction)closeBtnClick:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)nextBtnClick:(id)sender {
//    if (self.titleField.text != nil&&![self.titleField.text isEqualToString:@""]) {
//        if (!_selectTagsArray.count) {
//            UIStoryboard *sb = [UIStoryboard storyboardWithName:@"LiveStream" bundle:[NSBundle mainBundle]];
//            LiveStreamSettingsShareViewController *shareVC = [sb instantiateViewControllerWithIdentifier:@"LiveStreamSettingsShareViewController"];
//            [self.navigationController pushViewController:shareVC animated:YES];
//        }else{
//            [MBProgressHUD showError:@"Please select at least one label"];
//        }
//    }else{
//        [MBProgressHUD showError:@"Please enter a title"];
//    }
    
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"LiveStream" bundle:[NSBundle mainBundle]];
    NSMutableString *tags = [NSMutableString string];
    
//#if run_release_mode
//    LiveStreamViewController *vc = [sb instantiateViewControllerWithIdentifier:@"LiveStreamViewController"];
//    vc.liveTitle = self.titleField.text;
//    
//    for (int index = 0; index<_selectTagsArray.count; index++) {
//        [tags appendString:_tagsArray[_selectTagsArray[index].tag].idField];
//        if (index < _selectTagsArray.count - 1) {
//            [tags appendString:@"|"];
//        }
//    }
//    vc.tags = tags;
//    [self.navigationController pushViewController:vc animated:YES];
//    
//    return;
//#endif
    
    LiveStreamSettingsShareViewController *shareVC = [sb instantiateViewControllerWithIdentifier:@"LiveStreamSettingsShareViewController"];
    shareVC.liveTitle = self.titleField.text;

    for (int index = 0; index<_selectTagsArray.count; index++) {
        [tags appendString:_channelsArray[_selectTagsArray[index].tag].idField];
        if (index < _selectTagsArray.count - 1) {
            [tags appendString:@"|"];
        }
    }
    shareVC.tags        = tags;
    shareVC.channelID   = _channelsArray[_selectChannelBtn.tag].idField;
    if (self.locationSwitch.on) {
        shareVC.longitude   = _longitude;
        shareVC.latitude    = _latitude;
    }
    [self.navigationController pushViewController:shareVC animated:YES];
}

- (void)selfViewClick {
    [self.view endEditing:YES];
}

- (UIColor *)colorWithHexString: (NSString *)stringToConvert {
    //例子，stringToConvert #ffffff
    NSString *cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];// 字符串处理
    
    // 如果非十六进制，返回白色
    if ([cString length] < 6) {
        return [UIColor whiteColor];
    }
    
    // 去掉头
    if ([cString hasPrefix:@"#"]) {
        cString = [cString substringFromIndex:1];
    }
    
    // 去头非十六进制，返回白色
    if ([cString length] != 6) {
        return [UIColor whiteColor];
    }
    // 分别取RGB的值
    NSRange range;
    range.location      = 0;
    range.length        = 2;
    NSString *rString   = [cString substringWithRange:range];
    range.location      = 2;
    NSString *gString   = [cString substringWithRange:range];
    range.location      = 4;
    NSString *bString   = [cString substringWithRange:range];
    unsigned int r, g, b;
    
    // NSScanner把扫描出的制定的字符串转换成Int类型
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    // 转换为UIColor
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
    
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField endEditing:YES];
    return YES;
}
@end
