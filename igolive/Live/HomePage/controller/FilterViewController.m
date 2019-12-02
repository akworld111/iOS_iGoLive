//
//  FilterViewController.m
//  igolive
//
//  Created by greenhouse on 8/24/16.
//  Copyright © 2016 iGoLive LLC. All rights reserved.
//

#import "FilterViewController.h"
#import "ViewModifierHelpers.h"

@interface FilterViewController ()

@end

@implementation FilterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    /* note_08.27.16: trying to compensate the view size for the navigation controller's
     navigationBar height */
//    CGFloat barHeight = [ViewModifierHelpers getNavigatoinBarHeaderFrame:self.navigationController.navigationBar].size.height;
//    CGRect parentBounds = self.parentViewController.view.bounds;
//    parentBounds.origin.y = barHeight;
//    [self.view setFrame:parentBounds];
//    self.view setBounds:CGRectMake(0.0f, barHeight, self.parentViewController.view.bounds, <#CGFloat height#>)
//    [self.view removeConstraint:[self.view.topAnchor constraintEqualToAnchor:self.lblBuildNum.topAnchor constant:70.0f]];
//    
//    CGFloat barHeight = [ViewModifierHelpers getNavigatoinBarHeaderFrame:self.navigationController.navigationBar].size.height;
//    
//    CGRect lblFrame = self.lblBuildNum.frame;
//    lblFrame.origin.y = barHeight + 100.0f;
//    
//    self.lblBuildNum.frame = lblFrame;
    self.lblBuildNum.text = [MiscUtilities getApplicationBuildNumber];
    self.lblBuildNum.text = [NSString stringWithFormat:@"%@ <-- y = 70.0", self.lblBuildNum.text];
    
    /* note_08.27.16: trying to compensate the view size for the navigation controller's
     navigationBar height */
//    [self.view setNeedsLayout];
//    [self.view setNeedsDisplay];
//    [self.lblBuildNum setNeedsLayout];
//    [self.lblBuildNum setNeedsDisplay];
    
    /* note_08.24.16: trying to compensate the view size for the navigation controller's
        navigationBar height */
    //[ViewModifierHelpers setBorderWidth:5.0f color:[UIColor blackColor].CGColor forView:self.view];
    //CGFloat navBarHeight = self.pare.navigationController.navigationBar.frame.size.height;
    //CGRect frameWithNavBar = self.view.frame;
    //CGRect boundsWithNavBar = self.view.bounds;
    //
    //frameWithNavBar.origin.y = navBarHeight;
    //boundsWithNavBar.origin.y = navBarHeight;
    //
    //[self.view setFrame:frameWithNavBar];
    //[self.view setBounds:boundsWithNavBar];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onBackClick:(UIButton *)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
