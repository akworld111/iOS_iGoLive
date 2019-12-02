#import <UIKit/UIKit.h>
#import "Ct.h"

@interface SendGiftModel : NSObject

@property (nonatomic, strong) NSString * method;
@property (nonatomic, strong) NSString * action;
@property (nonatomic, strong) NSString * city;
@property (nonatomic, strong) Ct * ct;
@property (nonatomic, strong) NSString * equipment;
@property (nonatomic, strong) NSString * evensend;
@property (nonatomic, strong) NSString * level;
@property (nonatomic, strong) NSString * msgtype;
@property (nonatomic, strong) NSString * roomnum;
@property (nonatomic, strong) NSString * sex;
@property (nonatomic, strong) NSString * timestamp;
@property (nonatomic, strong) NSString * tougood;
@property (nonatomic, strong) NSString * touid;
@property (nonatomic, strong) NSString * touname;
@property (nonatomic, strong) NSString * ugood;
@property (nonatomic, strong) NSString * uhead;
@property (nonatomic, strong) NSString * uid;
@property (nonatomic, strong) NSString * uname;
@property (nonatomic, strong) NSString * usign;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

-(NSDictionary *)toDictionary;
@end