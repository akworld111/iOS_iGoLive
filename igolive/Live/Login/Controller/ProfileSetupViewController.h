//
//  ProfileSetupViewController.h
//
//  Created by AK on 17/2/3.
//  Copyright © 2017 igo.live All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfileSetupViewController : UIViewController

@property (nonatomic, assign)int first ;
@property (nonatomic, assign)int type;
@property (nonatomic, strong) PersonalInfoModel * userModel;
@property (weak, nonatomic) IBOutlet UIButton *btnNextRelease;

// hides all fields except nick name & birthday
//  default image will be set on server side
- (void)setEditMode:(BOOL)edit;

@end
