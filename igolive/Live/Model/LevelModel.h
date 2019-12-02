#import <UIKit/UIKit.h>

@interface LevelModel : NSObject

@property (nonatomic, strong) NSString * experience;
@property (nonatomic, assign) NSInteger levelRate;
@property (nonatomic, strong) NSString * levelid;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

-(NSDictionary *)toDictionary;
@end