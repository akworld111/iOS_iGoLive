#import <UIKit/UIKit.h>

@interface Ct : NSObject

@property (nonatomic, strong) NSString * action;
@property (nonatomic, assign) NSInteger addtime;
@property (nonatomic, strong) NSString * avatar;
@property (nonatomic, assign) NSInteger giftcount;
@property (nonatomic, strong) NSString * gifticon;
@property (nonatomic, assign) NSInteger giftid;
@property (nonatomic, strong) NSString * giftname;
@property (nonatomic, strong) NSString * gifttoken;
@property (nonatomic, strong) NSString * level;
@property (nonatomic, strong) NSString * nicename;
@property (nonatomic, assign) NSInteger showid;
@property (nonatomic, assign) NSInteger totalcoin;
@property (nonatomic, assign) NSInteger touid;
@property (nonatomic, strong) NSString * type;
@property (nonatomic, assign) NSInteger uid;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

-(NSDictionary *)toDictionary;
@end