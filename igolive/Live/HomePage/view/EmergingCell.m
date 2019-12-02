//
//  EmergingCell.m
//  iphoneLive
//
//  Created by christlee on 16/8/11.
//  Copyright © 2016年 cat. All rights reserved.
//

#import "EmergingCell.h"

@implementation EmergingCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"EmergingCell" owner:self options: nil];
        self = [arrayOfViews objectAtIndex:0];
    }
    
    return self;
}

@end
