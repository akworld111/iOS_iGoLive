//
//  InstagramAuthDelegate.h
//
//  Created by joeyshen 8/9/16
//  Copyright (c) 2016 igo.live.  All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol InstagramAuthDelegate <NSObject>

-(void) didAuthWithToken:(NSString*)token;

@end
