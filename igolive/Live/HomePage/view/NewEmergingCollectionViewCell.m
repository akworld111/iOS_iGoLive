//
//  NewEmergingCollectionViewCell.m
//  igolive
//
//  Created by 高翔 on 16/9/16.
//  Copyright © 2016年 iGoLive LLC. All rights reserved.
//

#import "NewEmergingCollectionViewCell.h"
@interface NewEmergingCollectionViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *number;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *describeLab;

@end
@implementation NewEmergingCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.backgroundColor = [UIColor blackColor];
}

- (void)updataWithModel:(NewEmergingCollectionCellModel *)model {
    NSString *URLString = [model.avatar stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:URLString]];
    self.nameLab.text = model.name;
    self.number.text = [NSString stringWithFormat:@"%ld",(long)model.views];
    self.describeLab.text = model.bio;
    
    // note: if the below is placed in awakeFromNib,
    //  the drop shadow has a different (bigger) effect
    [ViewModifierHelpers setCornerRadius:11.0f forView:self];
    [ViewModifierHelpers setDefaultDropShadowForChannelStreamCell:self];
}



@end



