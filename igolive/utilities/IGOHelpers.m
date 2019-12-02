//
//  IGOHelpers.m
//  igolive
//
//  Created by greenhouse on 9/9/16.
//  Copyright © 2016 iGoLive LLC. All rights reserved.
//

#import "IGOHelpers.h"
#import <AudioToolbox/AudioServices.h>
#import "UIImage+animatedGIF.h"

@implementation IGOHelpers

////////////////////////////////////////////////////////////////
#pragma mark - priv - animation helpers
////////////////////////////////////////////////////////////////
+ (void)runGiftAnimationForGiftID:(NSString*)strid withImageView:(UIImageView*)iv
{
    NSURL *urlGif = nil;
    int giftid = strid.intValue;
    double offsetGifDur = 0.5;
    switch (giftid)
    {
        case 36: // Jet
            urlGif = [[NSBundle mainBundle] URLForResource:f_imgGifJet withExtension:@"gif"];
            offsetGifDur = 1.5; // for Plane_Good
            break;
        case 14: // SportsCar (09.23.16: removed from 'sandbox.igo.live/manager')
            urlGif = [[NSBundle mainBundle] URLForResource:f_imgGifCar withExtension:@"gif"];
            break;
        //case 35: // Treasure
        //    urlGif = [[NSBundle mainBundle] URLForResource:f_imgGifBleh withExtension:@"gif"];
        //    break;
        case 43: // Yacht
            urlGif = [[NSBundle mainBundle] URLForResource:f_imgGifYacht withExtension:@"gif"];
            break;
        case 25: // RedCar
            urlGif = [[NSBundle mainBundle] URLForResource:f_imgGifCarRed withExtension:@"gif"];
            //offsetGifDur = 1.4;
            break;
        default:
            XLM_warning(@"default case hit; returning with no animation run");
            return;
    }
    
    if (!urlGif)
    {
        XLM_error(@"failed to set urlGift with .gif image file path; returning with no animation run");
        return;
    }
    
    UIImage *imgGif = [UIImage animatedImageWithAnimatedGIFData:[NSData dataWithContentsOfURL:urlGif]];
    [iv setImage:imgGif];
    
    
//    [NSTimer timerWithTimeInterval:imgGif.duration + offsetGifDur
//                                     target:self
//                                   selector:@selector(killGiftAnimation:)
//                                   userInfo:iv // iv = NSTimer.userInfo in selector fired
//                                    repeats:NO];
    // note: no repeating timers invalidate themselves when fired
    [NSTimer scheduledTimerWithTimeInterval:imgGif.duration + offsetGifDur
                                     target:self
                                   selector:@selector(killGiftAnimation:)
                                   userInfo:iv // iv = NSTimer.userInfo in selector fired 
                                    repeats:NO];
    /* note_09.09.16:
         NSTimer docs says the selector set above (and below) should be in format:
            - (void)timerFireMethod:(NSTimer *)timer
          however, changing this function signature but maintaining (NSTimer*) as
           the parameter, still works just fine
     */
}
+ (void)killGiftAnimation:(NSTimer*)timer
{
    UIImageView *iv = [ObjectTypeValidator uiimageviewFromObject:timer.userInfo];
    if (!iv)
    {
        XLM_error(@"UIImageView parsed from timer.userInfo came out nil; returning and failing to kill animation... i guess :/");
        return;
    }
    
    XLM_info(@"animation finished!");
    [iv setImage:nil];
    
}

+ (void)vibratePhone
{
    XLM_alert(@"!PERFORMING PHONE VIBRATE!");
    AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}
+ (NSString*)getCoinStringShort:(NSString*)coin
{
    if ([ObjectTypeValidator nsstringIsNilOrEmpty:coin])
    {
        XLM_error(@"coin param is nil or empty; returning '?'");
        return @"?";
    }
    
    NSInteger amnt = coin.integerValue;

    long bill = amnt / 1000000000;
    if (bill >= 1)
    {
        return [NSString stringWithFormat:@"%lib", bill];
    }

    long mill = amnt / 1000000;
    if (mill > 0)
    {
        return [NSString stringWithFormat:@"%lim", mill];
    }

    long thous = amnt / 1000;
    if (thous > 0)
    {
        return [NSString stringWithFormat:@"%lik", thous];
    }
    
    XLM_alert(@"amnt modded everything 0; returing coin: %@", coin);
    return coin;
}

@end
