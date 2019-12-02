//
//  InstagramAuthenticatorView.h
//
//  Created by joeyshen 8/9/16
//  Copyright (c) 2016 igo.live.  All rights reserved.
//

#import <Foundation/Foundation.h>

#import "InstagramAuthController.h"

@interface InstagramAuthenticatorView : UIWebView <UIWebViewDelegate>

@property(nonatomic, weak) id<InstagramAuthDelegate> authDelegate;

@end
