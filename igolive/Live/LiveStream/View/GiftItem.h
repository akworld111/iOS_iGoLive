//
//  GiftItem.h
//  iphoneLive
//
//  Created by 高翔 on 16/8/7.
//  Copyright © 2016年 cat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GiftSlideView.h"

@interface GiftItem : NSObject

@property (strong, nonatomic) IBOutlet UIView *view;
//@property (strong, nonatomic) IBOutlet GiftSlideView *view;
@property (weak, nonatomic) IBOutlet UIImageView *ivGiftIcon;
@property (weak, nonatomic) IBOutlet UIView *vPrice;
@property (weak, nonatomic) IBOutlet UILabel *lblGiftPrice;
@property (weak, nonatomic) IBOutlet UIButton *btnSendGift;


@property (weak, nonatomic) IBOutlet GiftSlideView *vGiftSlide;
@property (weak, nonatomic) IBOutlet UIImageView *ivGiftIconSlide;
@property (weak, nonatomic) IBOutlet UILabel *lblGiftPriceSlide;


- (IBAction)onSendGiftClick:(id)sender;

@end
