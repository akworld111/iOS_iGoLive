//
//  LivestreamSummaryViewController.h
//  iphoneLive
//
//  Created by 高翔 on 16/8/12.
//  Copyright © 2016年 cat. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LivestreamSummaryViewController : UIViewController
@property (strong, nonatomic) NSString *liveTitle;
@property (weak, nonatomic) IBOutlet UIView *vStreamStats;
@property (weak, nonatomic) IBOutlet UIView *vGoldEclipse;
@property (weak, nonatomic) IBOutlet UILabel *lblStreamTitle;
@property (weak, nonatomic) IBOutlet UIImageView *ivTopFan1Avatar;
@property (weak, nonatomic) IBOutlet UIImageView *ivTopFan2Avatar;
@property (weak, nonatomic) IBOutlet UIImageView *ivTopFan3Avatar;

@property (weak, nonatomic) IBOutlet UILabel *lblTopFan1;
@property (weak, nonatomic) IBOutlet UILabel *lblTopFan2;
@property (weak, nonatomic) IBOutlet UILabel *lblTopFan3;
@property (weak, nonatomic) IBOutlet UILabel *lblTopFan1Level;
@property (weak, nonatomic) IBOutlet UILabel *lblTopFan2Level;
@property (weak, nonatomic) IBOutlet UILabel *lblTopFan3Level;
@property (weak, nonatomic) IBOutlet UIButton *topFanFollowBtn1;
@property (weak, nonatomic) IBOutlet UIButton *topFanFollowBtn2;
@property (weak, nonatomic) IBOutlet UIButton *topFanFollowBtn3;

@property (weak, nonatomic) IBOutlet UILabel *lblUserLevel;
@property (weak, nonatomic) IBOutlet UILabel *lblUserHeartCoint;
@property (weak, nonatomic) IBOutlet UILabel *lblUserStarCount;
@property (weak, nonatomic) IBOutlet UILabel *lblUserStreamViewsCount;

@property (weak, nonatomic) IBOutlet UIButton *btnFollowFan1;
@property (weak, nonatomic) IBOutlet UIButton *btnFollowFan2;
@property (weak, nonatomic) IBOutlet UIButton *btnFollowFan3;



@end
