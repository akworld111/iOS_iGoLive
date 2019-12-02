
#import "chatcell.h"
#import "chatModel.h"
#import "UIImageView+WebCache.h"
@implementation Chatcell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.ellipseImage = [[UIImageView alloc]init];
        
        self.nameL = [[UILabel alloc]init];
        self.nameL.backgroundColor = [UIColor clearColor];
        self.nameL.lineBreakMode = NSLineBreakByCharWrapping;
        self.nameL.textAlignment = NSTextAlignmentLeft;
        self.nameL.textColor = wl_whiteColor;
        self.nameL.layer.masksToBounds = YES;
        // self.nameL.font = [UIFont fontWithName:@"STHeiti SC" size:12];
        self.nameL.font = [UIFont systemFontOfSize:15];
        self.nameL.numberOfLines = 0;
        self.nameL.shadowColor = [UIColor blackColor];
        self.nameL.shadowOffset = CGSizeMake(0,0.5);
        self.nameL.adjustsFontSizeToFitWidth = YES;
        self.nameL.userInteractionEnabled = YES;
        
        self.sexImage = [[UIImageView alloc] init];
        self.levelLab = [[UILabel alloc] init];
        self.levelLab.backgroundColor = [UIColor clearColor];
        self.levelLab.textColor = [UIColor whiteColor];
        self.levelLab.font = [UIFont systemFontOfSize:9];
        self.levelLab.textAlignment = NSTextAlignmentRight;
        
        //self.nameL.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:self.ellipseImage];
        [self.contentView addSubview:self.nameL];
        
        self.button = [UIButton buttonWithType:UIButtonTypeCustom];
        
        self.button.frame = CGRectMake(32, 10,130,40);
        [self.button addTarget:self action:@selector(upmessage) forControlEvents:UIControlEventTouchUpInside];
        
        [self.contentView addSubview:self.button];
        
    }
    return self;
}
- (void)upmessage {
    if (self.clickBlock) {
        self.clickBlock(self.model.userID);
    }
    // note_09.27.16: causes crash, not null check / validation (commented out above)
//    NSDictionary *dic = [NSDictionary dictionaryWithObjects:@[_model.icon,_model.userID,_model.userName,_model.signature,_model.city,_model.sex,_model.levelI] forKeys:@[@"icon",@"id",@"name",@"signature",@"city",@"sex",@"level"]];
//    
//    [[NSNotificationCenter defaultCenter]postNotificationName:@"upmessage" object:nil userInfo:dic];
    
}

- (void)huifu {
    
    
    if([self.nameL.text rangeOfString:@"@"].location !=NSNotFound)//_roaldSearchText
    {
        NSMutableAttributedString *noteStr = [[NSMutableAttributedString alloc] initWithString:self.nameL.text];
        NSRange redRange = NSMakeRange(0, [[noteStr string] rangeOfString:@":"].location);
        [noteStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:200/255.0 green:108/255.0 blue:0 alpha:1] range:redRange];
        
        [self.nameL setAttributedText:noteStr];
        
        
    }
    
}

-(void)setModel:(ChatModel *)model{
    
    _model = model;
    
    [self setData];
    
    //0712 重新布置了聊天cell
    
    //入场消息 开播警告
    if ([_model.titleColor isEqualToString:@"firstlogin"]) {
        
        [self setfirstFrame];
        
        self.nameL.textColor = [UIColor colorWithRed:58/255.0 green:114/255.0 blue:129/255.0 alpha:1.0];
    }
    else
    {
        [self setData];
        [self setFrame];
        self.nameL.textColor = [UIColor whiteColor];
        
        NSMutableAttributedString *noteStr = [[NSMutableAttributedString alloc] initWithString:self.nameL.text];
        NSRange redRange = NSMakeRange(0, [[noteStr string] rangeOfString:@":"].location);
        
        [noteStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:200/255.0 green:108/255.0 blue:0 alpha:1] range:redRange];
        
        //礼物
        if ([_model.titleColor isEqualToString:@"2"]) {
            self.nameL.textColor = [UIColor colorWithRed:221/255.0 green:160/255.0 blue:221/255.0 alpha:1];
        }
        
        //点亮
        else if ([_model.titleColor isEqualToString:@"light0"]) {
            // 添加表情
            NSTextAttachment *attch = [[NSTextAttachment alloc] init];
            // 表情图片
            attch.image = [UIImage imageNamed:@"plane_heart_cyan.png"];
            // 设置图片大小
            attch.bounds = CGRectMake(0, 0, 10, 10);
            NSAttributedString *string = [NSAttributedString attributedStringWithAttachment:attch];
            [noteStr appendAttributedString:string];
        } else if ([_model.titleColor isEqualToString:@"light1"]) {
            // 添加表情
            NSTextAttachment *attch = [[NSTextAttachment alloc] init];
            // 表情图片
            attch.image = [UIImage imageNamed:@"plane_heart_pink.png"];
            // 设置图片大小
            attch.bounds = CGRectMake(0, 0, 10, 10);
            NSAttributedString *string = [NSAttributedString attributedStringWithAttachment:attch];
            [noteStr appendAttributedString:string];
        } else if ([_model.titleColor isEqualToString:@"light2"]) {
            // 添加表情
            NSTextAttachment *attch = [[NSTextAttachment alloc] init];
            // 表情图片
            attch.image = [UIImage imageNamed:@"plane_heart_red.png"];
            // 设置图片大小
            attch.bounds = CGRectMake(0, 0, 10, 10);
            NSAttributedString *string = [NSAttributedString attributedStringWithAttachment:attch];
            [noteStr appendAttributedString:string];
        } else if ([_model.titleColor isEqualToString:@"light3"]) {
            // 添加表情
            NSTextAttachment *attch = [[NSTextAttachment alloc] init];
            // 表情图片
            attch.image = [UIImage imageNamed:@"plane_heart_yellow.png"];
            // 设置图片大小
            attch.bounds = CGRectMake(0, 0, 10, 10);
            NSAttributedString *string = [NSAttributedString attributedStringWithAttachment:attch];
            [noteStr appendAttributedString:string];
        }
        self.nameL.attributedText = noteStr;
        self.levelLab.text = _model.levelI.description;
        [self.levelLab sizeToFit];
        self.levelLab.frame = CGRectMake(25 - self.levelLab.frame.size.width, 5, self.levelLab.frame.size.width, self.levelLab.frame.size.height);
        [self.contentView addSubview:self.levelLab];
        
        /* 
            eg_09.30.16: crash at this point [Common getGenderImageNameWithType:]
             fixed by type checking ChatModel.sex on initialization (in chatModel.m)
         */
        self.sexImage.image = [UIImage imageNamed:[Common getGenderImageNameWithType:_model.sex]];
        self.sexImage.frame = CGRectMake(5, 7, 6, 7);
        [self.contentView addSubview:self.sexImage];
    }
    [self huifu];
}

-(void)setData{
    
    
//    _imageV.image = [UIImage imageNamed:[NSString stringWithFormat:@"rank_%@.png",_model.levelI]];
    self.ellipseImage.image = [UIImage imageNamed:[Common getEllipseImageNameWithLevle:_model.levelI]];
    _nameL.text = [NSString stringWithFormat:@"%@:%@",_model.userName,_model.contentChat];
    
}
//开播警告语坐标设置
-(void)setfirstFrame{
    self.ellipseImage.frame = CGRectMake(0, 0, 0, 0);
    _nameL.frame = _model.NAMER;
    
}

-(void)setFrame{
    
    self.ellipseImage.frame = _model.levelR;
    _nameL.frame = _model.nameR;
    
}

+ (Chatcell *)cellWithtableView:(UITableView *)tableView{
    Chatcell *cell = [tableView dequeueReusableCellWithIdentifier:@"ccc"];
    //if (!cell) {
    cell = [[Chatcell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ccc"];
    // }
    return cell;
    
}

- (void)labelTouchUpInside:(UITapGestureRecognizer *)recognizer {
    NSLog(@"%s",__func__);
}

@end
