//
//  ViewController.m
//
//  Created by joeyshen 8/9/16
//  Copyright (c) 2016 igo.live.  All rights reserved.
//

#import "InstagramViewController.h"

#import "InstagramAuthController.h"

@interface InstagramViewController ()

@end

@implementation InstagramViewController

- (void)viewDidLoad
{
    if([INSTAGRAM_CLIENT_ID isEqualToString:@"YOUR CLIENT ID"])
    {
        NSString *errorMsg = @"You must specify your Instagram API credentials in InstagramDefines.h.";
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:errorMsg
                                                            delegate:nil cancelButtonTitle:@"OK"
                                                            otherButtonTitles:nil];
        [alertView show];
        return;
    } else
    {
        [self performSelector:@selector(checkInstagramAuth) withObject:nil afterDelay:2];
    }
    
    self.view.backgroundColor = [UIColor blackColor];
    [super viewDidLoad];
}


//This is our authentication delegate. When the user logs in, and
// Instagram sends us our auth token, we receive that here.
-(void) didAuthWithToken:(NSString*)token
{
    if(!token)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:@"Failed to request token."
                                                            delegate:nil
                                                            cancelButtonTitle:@"OK"
                                                            otherButtonTitles:nil];
        [alertView show];
        return;
    }
    
    /*
    //As a test, we'll request a list of popular Instagram photos.
    NSString *instagramBase = @"https://api.instagram.com/v1";
    NSString *popularURLString = [NSString stringWithFormat:@"%@/media/popular?access_token=%@", instagramBase, token];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:popularURLString]];
    
    NSOperationQueue *theQ = [NSOperationQueue new];
    [NSURLConnection sendAsynchronousRequest:request queue:theQ
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               
                               NSError *err;
                               id val = [NSJSONSerialization JSONObjectWithData:data options:0 error:&err];
                               
                               if(!err && !error && val && [NSJSONSerialization isValidJSONObject:val])
                               {
                                   NSArray *data = [val objectForKey:@"data"];
                                   
                                   dispatch_sync(dispatch_get_main_queue(), ^{
                                       
                                       if(!data)
                                       {
                                           UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                                               message:@"Failed to request perform request."
                                                                                               delegate:nil
                                                                                               cancelButtonTitle:@"OK"
                                                                                               otherButtonTitles:nil];
                                           [alertView show];
                                       } else
                                       {
      
                                               UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Success"
                                                                                                   message:@"Successfully retrieved popular photos!"
                                                                                                   delegate:nil
                                                                                                   cancelButtonTitle:@"OK"
                                                                                                   otherButtonTitles:nil];
                                               [alertView show];
                                          
                                       }
                                    });
                               }
                           }];
     */
    [appDelegate showTabBarController];
}

-(void) checkInstagramAuth
{
    InstagramAuthController *instagramAuthController = [InstagramAuthController new];
    instagramAuthController.authDelegate = self;
    
    instagramAuthController.modalPresentationStyle = UIModalPresentationFormSheet;
    instagramAuthController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    
    [self presentViewController:instagramAuthController animated:YES completion:^{ } ];
    
    __weak InstagramAuthController *weakAuthController = instagramAuthController;
    
    instagramAuthController.completionBlock = ^(void) {
        [weakAuthController dismissViewControllerAnimated:YES completion:nil];
    };
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
