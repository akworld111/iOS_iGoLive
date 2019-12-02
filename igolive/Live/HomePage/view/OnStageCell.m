//
//  OnStageCell.m
//  iphoneLive
//
//  Created by 王文贺 on 16/8/7.
//  Copyright © 2016年 cat. All rights reserved.
//

#import "OnStageCell.h"
#import "Common.h"

@implementation OnStageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _watchButton = [[UIButton alloc] initWithFrame:CGRectMake(_window_width-50, 16, 50, 18)];
    [self.avatarImgView addSubview:_watchButton];
    _watchButton.backgroundColor = [UIColor colorWithRed:208.0f/255.0f green:2/255.0f blue:27/255.0f alpha:1.0];
    [_watchButton setImage:[UIImage imageNamed:@"eye"] forState:UIControlStateNormal];
    [_watchButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _watchButton.titleLabel.font = [UIFont systemFontOfSize:11];
    _watchButton.layer.cornerRadius = 9;
    _watchButton.layer.masksToBounds = YES;
//    _watchButton = (UIButton *)[Common roundCornersOnView:_watchButton onTopLeft:YES topRight:YES bottomLeft:YES bottomRight:YES radius:8];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)loadData:(AttentionLiveModel *)model {
    _nameLabel.text = model.userNickname;
    _levelLabel.text = model.level;
    [_avatarImgView sd_setImageWithURL:[NSURL URLWithString:model.avatar] placeholderImage:nil];
    
    _levelColorImgView.image = [UIImage imageNamed:[Common getEllipseImageNameWithLevle:model.level]];
    _genderImgView.image = [UIImage imageNamed:[Common getGenderImageNameWithType:model.gender]];
    [_watchButton setTitle:model.nums forState:UIControlStateNormal];
    
    self.titleLabel.text = model.title ? : str_no_title;
    self.massgeLabel.text = [self getTagsStringFromArray:model.tags];
}
- (NSString*)getTagsStringFromArray:(NSArray*)arr
{
    if ([ObjectTypeValidator nsarrayIsNilOrEmpty:arr])
    {
        XLM_warning(@"tags array is nil or empty; returning %@", str_no_tags);
        return str_no_tags;
    }
    
    NSMutableString *strtags = [NSMutableString stringWithString:@""];
    for (id obj in arr)
    {
        NSString *tag = [ObjectTypeValidator nsstringFromObject:obj];
        if (!tag)
        {
            XLM_error(@"obj in tags array not of type nsstring; continuing");
            continue;
        }
        
        [strtags appendFormat:@"%@ #%@", strtags, tag];
    }
    
    if ([ObjectTypeValidator nsstringIsNilOrEmpty:strtags])
    {
        return str_no_tags;
    }

    return [NSString stringWithString:strtags];
}
- (void)layoutSubviews {
    NSString *content = _watchButton.titleLabel.text;
    UIFont *font = _watchButton.titleLabel.font;
    CGSize size = CGSizeMake(MAXFLOAT, 30.0f);
    CGSize buttonSize = [content boundingRectWithSize:size
                                              options:NSStringDrawingTruncatesLastVisibleLine  | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                           attributes:@{ NSFontAttributeName:font}
                                              context:nil].size;
    _watchButton.frame  = CGRectMake(_window_width - (buttonSize.width + 22 + 8), _watchButton.frame.origin.y, buttonSize.width + 22, _watchButton.frame.size.height);
    _watchButton.imageEdgeInsets = UIEdgeInsetsMake(0, 1, 0, 0);
    _watchButton.titleEdgeInsets = UIEdgeInsetsMake(0, 3, 0, 0);
    
}

@end
