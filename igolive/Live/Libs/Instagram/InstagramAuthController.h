//
//  InstagramAuthController.h
//  
//  Created by joeyshen 8/9/16
//  Copyright (c) 2016 igo.live.  All rights reserved.
//


#import <UIKit/UIKit.h>

#import "InstagramAuthDelegate.h"
#import "InstagramDefines.h"

@protocol FrameChangeDelegate
-(void) frameChanged:(CGRect)frame;
@end

@interface InstagramAuthController : UIViewController <FrameChangeDelegate, InstagramAuthDelegate>

@property(nonatomic, copy) BMBlockVoid completionBlock;
@property(nonatomic, weak) id<InstagramAuthDelegate> authDelegate;

@end
