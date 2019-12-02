//
//  SearchBottomCell.h
//  iphoneLive
//
//  Created by 王文贺 on 16/8/25.
//  Copyright © 2016年 cat. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchBottomCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

- (void)updataScrollViewWithNumber:(int)number;
@end
