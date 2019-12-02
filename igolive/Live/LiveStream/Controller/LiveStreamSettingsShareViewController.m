//
//  LiveStreamSettingsShareViewController.m
//  iphoneLive
//
//  Created by 高翔 on 16/8/10.
//  Copyright © 2016年 cat. All rights reserved.
//

#import "LiveStreamSettingsShareViewController.h"
#import "LiveStreamViewController.h"
@interface LiveStreamSettingsShareViewController ()
@property (weak, nonatomic) IBOutlet UIButton *goliveBtn;

@end

@implementation LiveStreamSettingsShareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initAllView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initAllView {
    [ViewModifierHelpers addGradientColorFadedSubLayerToView:self.view hexColorStart:col_view_bg_lt_purple hexColorEnd:col_view_bg_drk_purple];
    self.goliveBtn.backgroundColor = UIColorFromHexAlpha(col_btn_green, 1.0f);
    //[ViewModifierHelpers addGradientColorFadedSubLayerToView:self.goliveBtn hexColorStart:col_btnDone_drk_green hexColorEnd:col_btnDone_lt_green];
}

#pragma mark - Click
- (IBAction)closeBtnClick:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)goLiveBtnClick:(UIButton *)sender {
    [MiscUtilities checkCameraServiceEnabled];
    [MiscUtilities checkMicrophoneServiceEnabled];
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"LiveStream" bundle:[NSBundle mainBundle]];
    LiveStreamViewController *vc = [sb instantiateViewControllerWithIdentifier:@"LiveStreamViewController"];
    vc.liveTitle    = self.liveTitle;
    vc.tags         = self.tags;
    vc.channelID    = self.channelID;
    vc.longitude    = self.longitude;
    vc.latitude     = self.latitude;
    [self.navigationController pushViewController:vc animated:NO];
}

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
@end
