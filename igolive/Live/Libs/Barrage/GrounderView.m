//
//  GrounderView.m
//  GrounderDemo
//
//  Created by 贾楠 on 16/3/8.
//  Copyright © 2016年 贾楠. All rights reserved.
//
#import "GrounderView.h"
#import <SDWebImage/SDImageCache.h>
#import <SDWebImage/UIButton+WebCache.h>
@interface GrounderView()<UIGestureRecognizerDelegate>
{
    UIImageView *bgImage;
    UIImageView *ellipseImage;
    UIImageView *sexImage;
    UILabel *levelLab;
    UILabel *nameLab;
    UILabel *textLab;
    
    float viewWidth;
    UITapGestureRecognizer* singleTap;


}
@end
@implementation GrounderView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.cornerRadius = 30/2;
//        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        self.backgroundColor = [UIColor clearColor];
        
        bgImage = [[UIImageView alloc] init];
        [self addSubview:bgImage];
        bgImage.image = [UIImage imageNamed:@"img_boost_post_bg"];
        ellipseImage = [[UIImageView alloc] init];
        [self addSubview:ellipseImage];
        sexImage = [[UIImageView alloc] init];
        [self addSubview:sexImage];
        levelLab = [[UILabel alloc] init];
        levelLab.textColor = [UIColor whiteColor];
        [self addSubview:levelLab];
        nameLab = [[UILabel alloc] init];
        nameLab.textColor = [UIColor whiteColor];
        [self addSubview:nameLab];
        textLab = [[UILabel alloc] init];
        textLab.textColor = [UIColor whiteColor];
        [self addSubview:textLab];

//        titleBgView = [[UIView alloc] init];
//        titleBgView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
//        [self addSubview:titleBgView];
//        
//        
//        titleLabel = [[UILabel alloc] init];
//        titleLabel.textColor = [UIColor whiteColor];
//        titleLabel.font = [UIFont boldSystemFontOfSize:12];
//        [self addSubview:titleLabel];
        
//        nameLabel = [[UILabel alloc] init];
//        nameLabel.textColor = [UIColor colorWithRed:200.0/255.0 green:200.0/255.0 blue:200.0/255.0 alpha:1];
//        nameLabel.font = [UIFont systemFontOfSize:10];
//        [self addSubview:nameLabel];
     
//        headImage = [[UIButton alloc] init];
//        headImage.clipsToBounds = YES;
//        headImage.frame = CGRectMake(0, 0, 30, 30);
//        headImage.layer.cornerRadius = 30/2;
//        headImage.layer.borderWidth = 0.5;
//        headImage.layer.borderColor = [UIColor whiteColor].CGColor;
//        [self addSubview:headImage];
//        
//        singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
//        singleTap.delegate = self;
//        singleTap.numberOfTapsRequired =1;
//        singleTap.numberOfTouchesRequired = 1;
//        singleTap.cancelsTouchesInView = NO;
//        [self addGestureRecognizer:singleTap];


    }
    return self;
}


-(void)drawRect:(CGRect)rect{

}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer

{

    return YES;
    
}

-(void)handleSingleTap:(UITapGestureRecognizer *)sender

{
    NSLog(@"111111");
}

- (void)setContent:(NSDictionary *)model{
    NSLog(@"%@",model);
    bgImage.frame = CGRectMake(0, -9, 200, 32);
    ellipseImage.image = [UIImage imageNamed:[Common getEllipseImageNameWithLevle:model[@"ct"][@"level"]]];
    ellipseImage.frame = CGRectMake(7, 0, 26, 12.5);
    
    /* eg_09.30.16 crash fix */
    // this field when coming from android sending boost, comes over has a number value not a string
    id obj = [model valueForKey:@"sex"];
    NSString *sex = [ObjectTypeValidator nsstringFromObject:obj];
    if (!sex)
    {
        NSNumber *nSex = [ObjectTypeValidator SAFEnsnumberIntFromObject:obj];
        sex = nSex.stringValue;
    }
    sexImage.image = [UIImage imageNamed:[Common getGenderImageNameWithType:sex]];
    /* _eg */
    
    /* legacy */
    //sexImage.image = [UIImage imageNamed:[Common getGenderImageNameWithType:model[@"sex"]]];
    /* _legacy */
    sexImage.frame = CGRectMake(ellipseImage.frame.origin.x + 5, 3.5, 6, 7);
    
    levelLab.text = model[@"ct"][@"level"];
    levelLab.font = [UIFont systemFontOfSize:7];
    levelLab.frame = CGRectMake(sexImage.frame.origin.x + sexImage.frame.size.width + 3.5, 3, 7.5, 6);
    
    /* legacy */
    //nameLab.text = model[@"ct"][@"nickname"];
    //nameLab.text = [NSString stringWithFormat:@"%@:",nameLab.text];
    /* _legacy */
    
    
    /* eg dirty fix */
    if (!model[@"ct"][@"nicename"])
    {
        nameLab.text = @"";
    }
    else
    {
        nameLab.text = model[@"ct"][@"nicename"];
        nameLab.text = [NSString stringWithFormat:@"%@:",nameLab.text];
    }
    /* eg */
    
    
    nameLab.font = [UIFont systemFontOfSize:14];
    nameLab.frame = CGRectMake(ellipseImage.frame.origin.x + ellipseImage.frame.size.width+2, 2, [GrounderView calculateMsgWidth:nameLab.text andWithLabelFont:nameLab.font andWithHeight:10], 10);
    
    
    /* legacy */
    //textLab.text = model[@"ct"][@"content"];
    /* _legacy */
    
    /* eg dirty fix */
    if (!model[@"ct"][@"content"])
    {
        textLab.text = @"BARRAGE!!";
    }
    else
    {
        textLab.text = model[@"ct"][@"content"];
    }
    /* eg */
    
    textLab.font = [UIFont systemFontOfSize:14];
    textLab.frame = CGRectMake(nameLab.frame.origin.x + nameLab.frame.size.width, 2, [GrounderView calculateMsgWidth:textLab.text andWithLabelFont:textLab.font andWithHeight:10], 10);
    
//        nameLabel.text = [model valueForKey:@"name"];
//        nameLabel.frame = CGRectMake(35, 2, [GrounderView calculateMsgWidth:nameLabel.text andWithLabelFont:[UIFont systemFontOfSize:10] andWithHeight:10], 10);
    
//        [headImage setImageWithURL:[NSURL URLWithString:@""]];
    
//        titleLabel.text = [model valueForKey:@"title"];
//        titleLabel.frame = CGRectMake(35, 12, [GrounderView calculateMsgWidth:titleLabel.text andWithLabelFont:[UIFont systemFontOfSize:12] andWithHeight:18]+20, 18);
//    
//        titleBgView.frame = CGRectMake(5, 12, [GrounderView calculateMsgWidth:titleLabel.text andWithLabelFont:[UIFont systemFontOfSize:12] andWithHeight:18]+55, 18);        titleBgView.layer.cornerRadius = 9;
//        viewWidth = titleLabel.frame.size.width + 55;
//        if (nameLabel.frame.size.width > titleLabel.frame.size.width) {
//            viewWidth = nameLabel.frame.size.width + 55;
//        }
    
//        UIImage *headerImg = [UIImage imageNamed:[model valueForKey:@"icon"]];
    
//        [headImage sd_setImageWithURL:[NSURL URLWithString:[model valueForKey:@"icon"]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"zhenyouli.jpg"]];
//
//    [headImage addTarget:self action:@selector(clickIcon) forControlEvents:UIControlEventTouchUpInside];
    
        self.frame = CGRectMake(kScreenWidth + 20, self.selfYposition, viewWidth, 30);
    
}

-(void)clickIcon
{
    NSLog(@"icon click");
}


- (void)grounderAnimation:(id)model{
    float second = 0.0;
    if (nameLab.text.length+textLab.text.length < 30){
        second = 10.0f;
    }else{
        second = nameLab.text.length+textLab.text.length/2.5;
    }
    
    self.userInteractionEnabled = YES;
    [UIView animateWithDuration:second delay:0 options:(UIViewAnimationOptionAllowUserInteraction) animations:^{        self.frame = CGRectMake( - viewWidth - 20, self.frame.origin.y, viewWidth, 30);
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];
        self.isShow = NO;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"nextView" object:nil];
    }];

    
//    [UIView animateWithDuration:second animations:^{
//        self.frame = CGRectMake( - viewWidth - 20, self.frame.origin.y, viewWidth, 30);
//    }completion:^(BOOL finished) {
//        
//        [self removeFromSuperview];
//        self.isShow = NO;
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"nextView" object:nil];
//    }];
 
 
}

+ (CGFloat)calculateMsgWidth:(NSString *)msg andWithLabelFont:(UIFont*)font andWithHeight:(NSInteger)height {
    if ([msg isEqualToString:@""]) {
        return 0;
    }
    CGFloat messageLableWidth = [msg boundingRectWithSize:CGSizeMake(MAXFLOAT, height)
                                                  options:NSStringDrawingUsesLineFragmentOrigin
                                               attributes:@{NSFontAttributeName:font}
                                                  context:nil].size.width;
    return messageLableWidth + 1;
}

@end
