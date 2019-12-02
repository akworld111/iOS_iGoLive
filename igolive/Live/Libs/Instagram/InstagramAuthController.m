//
//  InstagramAuthController.m
//
//  Created by joeyshen 8/9/16
//  Copyright (c) 2016 igo.live.  All rights reserved.
//

#import "InstagramAuthController.h"

#import "InstagramAuthenticatorView.h"

#import "SizerView.h"

@interface InstagramAuthController ()

@end

@implementation InstagramAuthController

@synthesize completionBlock;
@synthesize authDelegate;

- (id)init
{
    self = [super init];
    if (self)
    {
        //We use a special view that will tell us what the proper frame size is so we can
        //make sure the login view is centered in the modal view controller.
        self.view = [[SizerView alloc] initWithFrame:CGRectZero frameChangeDelegate:self];
        self.authDelegate = nil;
    }
    return self;
}

-(void) dealloc
{
}

-(void) didAuthWithToken:(NSString*)token
{
    [self.authDelegate didAuthWithToken:token];
    self.completionBlock();
}

-(void) frameChanged:(CGRect)frame
{
    InstagramAuthenticatorView *gha = [[InstagramAuthenticatorView alloc] initWithFrame:frame];
    gha.authDelegate = self;
    [self.view addSubview:gha];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}


@end
