//
//  GiftSlideView.m
//  igolive
//
//  Created by greenhouse on 9/10/16.
//  Copyright © 2016 iGoLive LLC. All rights reserved.
//

#import "GiftSlideView.h"
//#import "GiftItem.h"

#define slide_view_corn_rad 10.0f
#define expand_gift_pixel_radius 5.0f



#define off_screen_top_y -500.0f

//#define alpha_gift_start 0.4f
#define alpha_gift_start 1.0f
#define alpha_gift_hide 0.05f
//#define alpha_gift_fade_scale 0.03f
#define alpha_gift_fade_scale 0.00f

#define dur_gift_expand_on_touch 0.1f
#define dur_gift_slide_to_origin 0.6f
#define gift_view_height_ratio_thresh 0.2f

@implementation GiftSlideView {
    CGPoint startTouchLoc;
    CGPoint prevTouchLoc;
    
    CGRect origGiftViewFrame;
    CGRect sellGiftViewFrame;
    CATransform3D origGiftViewTransform3D;
    
    CGFloat sendGiftYthresh;
    
    int tag;
    
    UIView *parentView;
    GiftItem *giftItem;
}
- (void)awakeFromNib
{
    parentView = self.superview;
    [self setInitSlideViewProperties];
    [self setInitialFrameConstants];
}
- (void)setInitSlideViewProperties
{
    // set hide alpha value and back ground color clear
    self.alpha = alpha_gift_start;
    self.backgroundColor = [UIColor clearColor];
    [ViewModifierHelpers setCornerRadius:slide_view_corn_rad forView:self];
}
- (void)setInitialFrameConstants
{
    // set original gift slide view frame and transform3D
    origGiftViewFrame = parentView.frame;
    origGiftViewTransform3D = self.layer.transform;;
    
    // set sell gift slide view frame
    CGRect frame = origGiftViewFrame;
    frame.origin.y = off_screen_top_y;
    sellGiftViewFrame = frame;
    
    // set y coordinate marker for creating 'send gift y coord threshold'
    CGFloat viewOriginY = origGiftViewFrame.origin.y;
    
    CGFloat viewSizeHalfHeight = origGiftViewFrame.size.height * gift_view_height_ratio_thresh;
    CGFloat markerYthresh = viewOriginY - viewSizeHalfHeight;
    
    // create 'send gift y coord threshold'
    //  (giftkeyboardview.frame.origin.y  <=>  center marker.y)
    sendGiftYthresh = markerYthresh;
    
    XLM_info(@"origGiftViewFrame: [(%f, %f); (%f x %f)]", origGiftViewFrame.origin.x, origGiftViewFrame.origin.y, origGiftViewFrame.size.width, origGiftViewFrame.size.width);
}
- (void)moveSlideViewByDeltaX:(CGFloat)dX deltaY:(CGFloat)dY
{
    // set new gift location transform
    CATransform3D giftTransform3D = CATransform3DTranslate(self.layer.transform, dX, dY, 0.0f);
    
    
        /* TILT gift integration */

        //CGFloat tilt_rate_direction = card_tilt_rate;  set tilte rate
        //if (frameCenterY < currTouchLoc.y)      if touching on bottom half of card view
        //tilt_rate_direction *= -1;           set title direction
        //
        //giftTransform3D = CATransform3DRotate(cardTransform3D, ((currTouchLoc.x - startTouchLoc.x) * tilt_rate_direction) * M_PI, 0.0f, 0.0f, 1.0f);
    
    [self.layer setTransform:giftTransform3D];
}
- (void)moveSlideViewByDeltaX:(CGFloat)dX
{
    CGFloat dY = 0; // note: maintain current location for setting transform below
    
    // set new gift location transform
    CATransform3D giftTransform3D = CATransform3DTranslate(self.layer.transform, dX, dY, 0.0f);
    
    [self.layer setTransform:giftTransform3D];
}
- (void)moveSlideViewByDeltaY:(CGFloat)dY
{
    CGFloat dX = 0; // note: maintain current location for setting transform below
    
    // set new gift location transform
    CATransform3D giftTransform3D = CATransform3DTranslate(self.layer.transform, dX, dY, 0.0f);
    
    [self.layer setTransform:giftTransform3D];
}
- (void)resetGiftSlideViewFrame
{
    CGRect frame = self.frame;
    CGFloat frameCenterY = [ViewModifierHelpers getFrameCenterY:frame];
    BOOL slideSold = frameCenterY <= sendGiftYthresh;

    [self delegateSlideViewSold:slideSold withTag:self.slideViewTag animated:YES];
}
- (void)delegateSlideViewSold:(BOOL)slideSold withTag:(int)giftTag animated:(BOOL)animate
{
    [self.delegate slideViewSold:slideSold withTag:giftTag];
    
    if (!animate)
    {
        return;
    }
    [UIView animateWithDuration:dur_gift_slide_to_origin
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^(void) {
                         [self setSlideFrameSold:slideSold];
                     }completion:^(BOOL finished) {
                         // set original gift frame after whichever animation finishes
                         self.alpha = alpha_gift_start;
                         self.layer.frame = origGiftViewFrame;
                         
                         // set back ground color clear
                         self.backgroundColor = [UIColor clearColor];
                     }];
}
- (void)setSlideFrameSold:(BOOL)slideSold
{
    if (slideSold)
    {
        // set sell gift slide view frame
        self.frame = sellGiftViewFrame;
        self.alpha = alpha_gift_hide;
    }
    else
    {
        // set original gift slide view frame
        self.alpha = alpha_gift_start;
        self.layer.frame = origGiftViewFrame;
    }
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.delegate enableParentScrollView:NO];
    
    // set start touch location
    startTouchLoc = [[touches anyObject] locationInView:parentView];
    prevTouchLoc = startTouchLoc;
    
#if log_touch_drag_gift
    NSLog(@"BEGAN _ startLoc: (%f, %f)", startTouchLoc.x, startTouchLoc.y);
#endif
    
    // set gift view back to original gift icon size and alpha level
    self.layer.frame = origGiftViewFrame;
    self.alpha = alpha_gift_start;
    self.backgroundColor = col_clearColor;
    
    // configure expanded gift icon size
        //CGRect dragFrame = origGiftViewFrame;
        //dragFrame.origin.x = dragFrame.origin.x - expand_gift_pixel_radius;
        //dragFrame.origin.y = dragFrame.origin.y - expand_gift_pixel_radius;
        //dragFrame.size.height = dragFrame.size.height + (expand_gift_pixel_radius * 2);
        //dragFrame.size.width = dragFrame.size.width + (expand_gift_pixel_radius * 2);
    
        //dragFrame.size.height = dragFrame.size.height * 2;
        //dragFrame.size.width = dragFrame.size.width * 2;
        //dragFrame.origin.y = dragFrame.origin.y - 10.0f;
    

    
    // animating setting expanded gift icon size
        //[UIView animateWithDuration:dur_gift_expand_on_touch
        //                      delay:0
        //                    options:UIViewAnimationOptionCurveEaseInOut
        //                 animations:^
        //                 {
        //                      [self setFrame:dragFrame];
        //                      [self.currCardViewController expandFramesToDragSize];
        //                 }
        //                 completion:^(BOOL finished) { }];
}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    // set current touch location
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint currTouchLoc = [touch locationInView:parentView];
    
#if log_touch_drag_gift
    NSLog(@"MOVED _ prevLoc: (%f,%f) -> currLoc: (%f,%f)", prevTouchLoc.x, prevTouchLoc.y, currTouchLoc.x, currTouchLoc.y);
#endif
    
    // if touch move up screen
    if (currTouchLoc.y <= prevTouchLoc.y)
    {
        self.alpha = self.alpha + alpha_gift_fade_scale;
    }
    
    // if touch move down screen
    if (currTouchLoc.y > prevTouchLoc.y)
    {
        self.alpha = self.alpha - alpha_gift_fade_scale;
    }
    
    // get delta (x, y) from prev touch location to current touch location
    CGFloat dX = currTouchLoc.x - prevTouchLoc.x;
    CGFloat dY = currTouchLoc.y - prevTouchLoc.y;
    
    [self moveSlideViewByDeltaX:dX deltaY:dY];
    
    prevTouchLoc = currTouchLoc;
}
-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    // set current touch location
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint currTouchLoc = [touch locationInView:parentView];
    
#if log_touch_drag_gift
    NSLog(@"CANCELED _ endLoc: (%f, %f)", currTouchLoc.x, currTouchLoc.y);
#endif
    
    [self resetGiftSlideViewFrame];
    
    [self.delegate enableParentScrollView:YES];
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    // set current touch location
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint currTouchLoc = [touch locationInView:parentView];
    
#if log_touch_drag_gift
    NSLog(@"ENDED _ endLoc: (%f, %f)", currTouchLoc.x, currTouchLoc.y);
#endif
    
    // animate sliding gift up and fade away
    //  or set gift back to original position
    [self resetGiftSlideViewFrame];
    
    [self.delegate enableParentScrollView:YES];
}


@end
