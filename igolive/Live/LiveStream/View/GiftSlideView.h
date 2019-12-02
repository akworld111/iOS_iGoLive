//
//  GiftSlideView.h
//  igolive
//
//  Created by greenhouse on 9/10/16.
//  Copyright © 2016 iGoLive LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SlideViewDelegate <NSObject>

- (void)slideViewSold:(BOOL)sold withTag:(int)tag;
- (void)enableParentScrollView:(BOOL)enable;

@end
@interface GiftSlideView : UIView

@property (nonatomic, retain) id<SlideViewDelegate> delegate;
@property (nonatomic) int slideViewTag;

- (void)delegateSlideViewSold:(BOOL)slideSold withTag:(int)giftTag animated:(BOOL)animate;

@end
