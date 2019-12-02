//
//  GiftItem.m
//  iphoneLive
//
//  Created by 高翔 on 16/8/7.
//  Copyright © 2016年 cat. All rights reserved.
//

#import "GiftItem.h"
//#import "GiftSlideView.h"

@implementation GiftItem

- (instancetype)init {
    self = [super init];
    if (self)
    {
        [[NSBundle mainBundle] loadNibNamed:@"GiftItem" owner:self options:nil];
    }
    return self;
}
- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self.btnSendGift addTarget:self action:@selector(onSendGiftClick:) forControlEvents:UIControlEventTouchUpInside];
}
- (IBAction)onSendGiftClick:(id)sender {
    
    [self.vGiftSlide delegateSlideViewSold:YES withTag:self.vGiftSlide.slideViewTag animated:YES];
}

@end
