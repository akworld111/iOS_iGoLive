#import <UIKit/UIKit.h>

@interface CoinRecordModel : NSObject

@property (nonatomic, strong) NSString * avatar;
@property (nonatomic, strong) NSString * gender;
@property (nonatomic, assign) NSInteger isattention;
@property (nonatomic, strong) NSString * level;
@property (nonatomic, strong) NSString * total;
@property (nonatomic, strong) NSString * uid;
@property (nonatomic, strong) NSString * userNickname;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

-(NSDictionary *)toDictionary;
@end