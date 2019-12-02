

#import <UIKit/UIKit.h>

typedef void (^ClickBlock)(NSString *uid);

@interface Chatcell : UITableViewCell

@property(nonatomic,strong)ChatModel *model;

@property(nonatomic,strong)UIImageView *ellipseImage;

@property(nonatomic,strong)UIImageView *sexImage;

@property(nonatomic,strong)UILabel *levelLab;

@property(nonatomic,strong)UILabel *nameL;

@property(nonatomic,strong)UILabel *contentL;

@property(nonatomic,strong)UIButton *button;

+(Chatcell *)cellWithtableView:(UITableView *)tableView;

@property (copy, nonatomic) ClickBlock clickBlock;

@end
