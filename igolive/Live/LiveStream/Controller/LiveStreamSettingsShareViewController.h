//
//  LiveStreamSettingsShareViewController.h
//  iphoneLive
//
//  Created by 高翔 on 16/8/10.
//  Copyright © 2016年 cat. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LiveStreamSettingsShareViewController : UIViewController <MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate>
@property (strong, nonatomic) NSString *liveTitle;
@property (strong, nonatomic) NSString *tags;
@property (strong, nonatomic) NSString *channelID;
@property (strong, nonatomic) NSString *longitude;
@property (strong, nonatomic) NSString *latitude;

@property (weak, nonatomic) IBOutlet UIView *vButtons;

@end
