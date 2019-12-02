//
//  LoadingViewController.m
//  wizrtesteric
//
//  Created by Eric Greenhouse on 5/12/15.
//  Copyright (c) 2015 wizr llc. All rights reserved.
//

#import "LoadingViewController.h"
#import "xlogger.h"
@interface LoadingViewController ()

@end

@implementation LoadingViewController

- (id)init
{
    self = [super init];
    if (self)
    {

    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.view bringSubviewToFront:self.aiLoading];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)onBtnCloseClick:(id)sender {
    [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFY_LOADING_CLOSE object:nil userInfo:nil];
}


@end
