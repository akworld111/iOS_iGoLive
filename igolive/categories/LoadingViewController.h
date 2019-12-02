//
//  LoadingViewController.h
//  wizrtesteric
//
//  Created by Eric Greenhouse on 5/12/15.
//  Copyright (c) 2015 wizr llc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoadingViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *aiLoading;
@property (weak, nonatomic) IBOutlet UIView *vLoadingShadow;
@property (weak, nonatomic) IBOutlet UIView *vLoadingImgOverlay;
@property (weak, nonatomic) IBOutlet UIImageView *ivAnimation;
@property (weak, nonatomic) IBOutlet UIImageView *ivLoadingImg;

@property (weak, nonatomic) IBOutlet UIButton *btnCloseLoadingView;


- (id)init;
- (IBAction)onBtnCloseClick:(id)sender;

@end



