//
//  LookLiveStreamViewController.h
//  iphoneLive
//
//  Created by 高翔 on 16/8/5.
//  Copyright © 2016年 cat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GiftSlideView.h"

@interface LookLiveStreamViewController : UIViewController <SlideViewDelegate, MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate, UIAlertViewDelegate>


@property(nonatomic,strong)NewLiveModel *liveModel;


@property (weak, nonatomic) IBOutlet UIImageView *ivGiftAnimation;
@property (weak, nonatomic) IBOutlet UIView *vBackground;


@end



