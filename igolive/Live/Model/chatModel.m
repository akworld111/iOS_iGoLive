

#import "ChatModel.h"

@implementation ChatModel


-(instancetype)initWithDic:(NSDictionary *)dic{
    
    
    self = [super init];
    
    if (self) {

        
        self.titleColor  = [dic valueForKey:@"titleColor"];
        
        self.userName = [dic valueForKey:@"userName"];
        
        self.contentChat = [dic valueForKey:@"contentChat"];
        
        self.levelI = [dic valueForKey:@"levelI"];
        
        self.userID = [dic valueForKey:@"id"];
        
        self.icon = [dic valueForKey:@"avatar"];

        self.city = [dic valueForKey:@"city"];
        self.signature = [dic valueForKey:@"signature"];
        
        /* legacy */
        //self.sex = [dic valueForKey:@"sex"];
        /* _legacy */
        
        /* eg_09.30.16 crash fix */
        // this field when coming from android sending chat text, comes over has a number value not a string
        id obj = [dic valueForKey:@"sex"];
        self.sex = [ObjectTypeValidator nsstringFromObject:obj];
        if (!self.sex)
        {
            NSNumber *nSex = [ObjectTypeValidator SAFEnsnumberIntFromObject:obj];
            self.sex = nSex.stringValue;
        }
        /* _eg */
    }
    
    return self;
    
}

-(void)setChatFrame:(ChatModel *)upChat{

      UIFont *font1 = [UIFont systemFontOfSize:15];
    
      NSString *string = [_userName stringByAppendingPathComponent:_contentChat];
    
    CGSize size = [string boundingRectWithSize:CGSizeMake(_window_width*0.62, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font1} context:nil].size;
    
    _nameR  = CGRectMake(32,0,size.width+30,size.height);
    _NAMER = CGRectMake(10, 0, size.width, size.height);
    _rowHH = MAX(0, CGRectGetMaxY(_nameR));
    _levelR = CGRectMake(0,3,30,15);

  
}

+(instancetype)modelWithDic:(NSDictionary *)dic{
    ChatModel *model = [[ChatModel alloc]initWithDic:dic];
    return model;
}


@end
