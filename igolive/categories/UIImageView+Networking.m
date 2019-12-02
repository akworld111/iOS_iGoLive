//
//  UIImageView+Networking.m
//  greenhouse
//
//  Created by greenhouse on 7/9/15.
//  Copyright (c) 2015 eric greenhouse. All rights reserved.
//

#import "UIImageView+Networking.h"

@implementation UIImageView (Networking)

- (void)setImageAsyncWithUrlString:(NSString*)urlString
                       placeholder:(UIImage*)placeholder
                         alternate:(UIImage*)alternate
                     //cacheLocation:(id <WZCellCacheProtocol>)cacheLocation
                     cacheLocation:(id)cacheLocation
                   completionBlock:(void (^)(BOOL succeeded, UIImage *image))completionBlock
{
    if (!urlString || !placeholder || !alternate)
    {
        XLM_warning(@"invalid parameters; attempting to set alternate, otherwise UIImageView.image will not be set!");
        self.image = alternate ? alternate : [UIImage imageNamed:f_imgNoPhoto];
        
        if (completionBlock){
            completionBlock(NO, alternate);
        }
        return;
    }
    
    // first set placeholder image to this ImageView
    self.image = placeholder;
    
    // make async call in background to get the image from the url
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        BOOL success = YES;
        // retreive image
        UIImage *img = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:urlString]]];
        if (!img)
        {
            // if can't retreive, fall back to alternate image
            img = alternate;
            success = NO;
            
            XLM_error(@"failed to get img at url: %@; alternate img has been set", urlString);
        }
        
        // example with cache location
        //[cacheLocation setCellImagesWithArray:@[img]];
        
        // perform completion block back on the main thread (update ui stuff)
        dispatch_async(dispatch_get_main_queue(), ^{
            // set returned/alternate image to this ImageView
            self.image = img;
            
            // execute completion block
            if (completionBlock){
                completionBlock(success, img);
            }
        });
    });
}



@end




