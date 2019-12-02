//
//  SizerView.m
//
//  Created by joeyshen 8/9/16
//  Copyright (c) 2016 igo.live.  All rights reserved.
//

#import "SizerView.h"

@interface SizerView()
@property(nonatomic, weak) id<FrameChangeDelegate> delegate;
@end

@implementation SizerView

@synthesize delegate;

- (id)initWithFrame:(CGRect)frame frameChangeDelegate:(id<FrameChangeDelegate>)_delegate
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.delegate = _delegate;
    }
    return self;
}

-(void) layoutSubviews
{
    [self.delegate frameChanged:self.frame];
}

@end
