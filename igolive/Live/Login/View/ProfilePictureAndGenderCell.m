//
//  ProfilePictureAndGenderCell.m
//  iphoneLive
//
//  Created by sdd on 16/8/16.
//  Copyright © 2016年 cat. All rights reserved.
//

#import "ProfilePictureAndGenderCell.h"

@implementation ProfilePictureAndGenderCell
{
    UIButton *tempBtn;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    LiveUser *user = [Config myProfile];
    NSString *strgen = user.gender;
    if ([strgen isEqualToString:@"1"]) {
        tempBtn = _maleButton;
    }else if ([strgen isEqualToString:@"0"]){
        tempBtn = _femaleButton;
    }else{
        tempBtn = _secretButton;
    }
    
    tempBtn.selected = YES;
    [tempBtn setImage:[UIImage imageNamed:@"dot"] forState:UIControlStateSelected];
    [tempBtn setImage:[UIImage imageNamed:@"dotSelected"] forState:UIControlStateNormal];
    
}

- (IBAction)chooseGneder:(UIButton *)sender {
    
    if (sender!= tempBtn) {
        tempBtn.selected = NO;
        sender.selected = YES;
        
        tempBtn = sender;
    }else{
        tempBtn.selected = YES;
    }
    [tempBtn setImage:[UIImage imageNamed:@"dot"] forState:UIControlStateSelected];
    [tempBtn setImage:[UIImage imageNamed:@"dotSelected"] forState:UIControlStateNormal];

    if (self.delegate && [self.delegate respondsToSelector:@selector(chooseGenderButton:)]) {
        [self.delegate chooseGenderButton:sender];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
