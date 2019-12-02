//
//  InterestView.m
//  igolive
//
//  Created by 宋丹丹 on 16/8/29.
//  Copyright © 2016年 iGoLive LLC. All rights reserved.
//

#import "InterestView.h"

@implementation InterestView{
    NSArray * _interestArray;
    NSMutableArray *likeArray;
    NSArray *_selectIneterestArray;
}

-(id)initWithFrame:(CGRect)frame withArray:(NSArray*)interestArray withSelectInterestArray:(NSArray*)selectInterestArray
{
    self = [super initWithFrame:frame];
    if (self) {
        _interestArray = interestArray;
        likeArray = [NSMutableArray array];
        _selectIneterestArray = [NSArray arrayWithArray:selectInterestArray];
        [self createButton];

    }
    return self;
}

-(void)createButton {
    int totalColumns=3;
    CGFloat buttonW;
    if(SCREEN_WIDTH==320){
       buttonW =80;
    }else{
         buttonW=100;
    }
    CGFloat buttonH=32;
    CGFloat marginX=(self.frame.size.width-totalColumns*buttonW)/(totalColumns+1);
    CGFloat marginY=5;
 
    
    for (int i=0; i<_interestArray.count; i++) {
        
        InterestModel *model  = _interestArray[i];
        int row=i/totalColumns;
        int col=i%totalColumns;
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(marginX+col*(marginX+buttonW), 30+row*(marginY+buttonH), buttonW, buttonH)];
        button.backgroundColor = COLOR(202, 202, 202, 1.0);
        button.tag = i +1;
        button.font = [UIFont systemFontOfSize:15];
        [button setTitle:model.name forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:0];
        button.layer.cornerRadius  = 16;
        button.layer.masksToBounds = YES;
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];

        for (InterestModel *selectModel in _selectIneterestArray) {
            if ([model.idField intValue] == [selectModel.idField intValue]) {
                button.selected = YES;
                button.backgroundColor = COLOR(114, 209, 75, 1.0);
            }
        }
        [self addSubview:button];
    }
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10+marginX, 5, 100, 20)];
    label.text = @"Interests";
    label.backgroundColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:15];
    label.textColor = COLOR(160, 160, 160, 1);
    [self addSubview:label];
}

-(void)buttonClick:(UIButton*)sender {
    sender.selected = !sender.selected;
    InterestModel *model  = _interestArray[sender.tag-1];

    if (sender.selected) {
        [likeArray addObject:[NSString stringWithFormat:@"%@",model.idField]];
        sender.backgroundColor = COLOR(114, 209, 75, 1.0);
    }else{
        [likeArray removeObject:[NSString stringWithFormat:@"%@",model.idField]];
        sender.backgroundColor = COLOR(202, 202, 202, 1.0);

    }
    if ([self.delegate respondsToSelector:@selector(sendArray:)]) {
        [self.delegate sendArray:likeArray];
    }
}

@end
