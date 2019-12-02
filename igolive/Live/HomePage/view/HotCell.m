//
//  HotCell.m
//  iphoneLive
//
//  Created by christlee on 16/8/13.
//  Copyright © 2016年 cat. All rights reserved.
//

#import "HotCell.h"

@implementation HotCell

- (void)awakeFromNib {
    [super awakeFromNib];

    _watchButton = [[UIButton alloc] initWithFrame:CGRectMake(_window_width-50, 16, 50, 18)];
    [self addSubview:_watchButton];
    _watchButton.backgroundColor = [UIColor colorWithRed:208.0f/255.0f green:2/255.0f blue:27/255.0f alpha:1.0];
    [_watchButton setImage:[UIImage imageNamed:@"eye"] forState:UIControlStateNormal];
    [_watchButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _watchButton.titleLabel.font = [UIFont systemFontOfSize:11];
    _watchButton.layer.cornerRadius = 9;
    _watchButton.layer.masksToBounds = YES;
 
//    _watchButton = (UIButton *)[Common roundCornersOnView:_watchButton onTopLeft:YES topRight:YES bottomLeft:YES bottomRight:YES radius:8];
}
- (void)loadData:(NewLiveModel *)model
{
    self.titleLabel.text = model.title ? : str_no_title;
    self.tagLabel.text = [self getTagsStringFromArray:model.tags];
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

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"HotCell" owner:self options: nil];
        self = [arrayOfViews objectAtIndex:0];
    }
    
    return self;
}

- (void)applyLayoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes {
    static CGFloat featuredHeight = 375;
    static CGFloat standardHeight = 130;
    
    CGFloat delta = 1 - (featuredHeight - CGRectGetHeight(self.frame)) / (featuredHeight - standardHeight);
    
    CGFloat minAlpha = 0.0;
    CGFloat maxAlpha = 0.75;
    
    CGFloat alpha = maxAlpha - (delta * (maxAlpha - minAlpha));
    _overlayView.alpha = alpha;
    
    CGFloat scale = MAX(delta, 0.8);
    _titleLabel.transform = CGAffineTransformMakeScale(scale, scale);
    
    _tagLabel.alpha = delta;
    
    
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
