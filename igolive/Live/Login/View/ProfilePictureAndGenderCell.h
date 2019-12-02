//
//  ProfilePictureAndGenderCell.h
//  iphoneLive
//
//  Created by sdd on 16/8/16.
//  Copyright © 2016年 cat. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ProfilePictureAndGenderCellDelegate <NSObject>

-(void)chooseGenderButton:(UIButton*)sender;

@end

@interface ProfilePictureAndGenderCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;

@property (strong, nonatomic) IBOutlet UIImageView *headImageView;

@property (strong, nonatomic) IBOutlet UIView *genderView;

@property (strong, nonatomic) IBOutlet UIButton *maleButton;

@property (strong, nonatomic) IBOutlet UIButton *femaleButton;

@property (strong, nonatomic) IBOutlet UIButton *secretButton;

@property (weak, nonatomic) id <ProfilePictureAndGenderCellDelegate>delegate;

@end
