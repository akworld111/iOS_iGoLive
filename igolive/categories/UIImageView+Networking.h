//
//  UIImageView+Networking.h
//  greenhouse
//
//  Created by greenhouse on 7/9/15.
//  Copyright (c) 2015 eric greenhouse. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (Networking)

- (void)setImageAsyncWithUrlString:(NSString*)urlString
                       placeholder:(UIImage*)placeholder
                         alternate:(UIImage*)alternate
                     //cacheLocation:(id <WZCellCacheProtocol>)cacheLocation
                     cacheLocation:(id)cacheLocation
                   completionBlock:(void (^)(BOOL succeeded, UIImage *image))completionBlock;


@end


