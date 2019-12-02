#import <UIKit/UIKit.h>

@interface NewEmergingCollectionCellModel : NSObject

@property (nonatomic, retain) NewLiveModel *liveModel;
@property (nonatomic, strong) NSString * avatar;
@property (nonatomic, strong) NSString * bio;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, assign) NSInteger uid;
@property (nonatomic, assign) NSInteger views;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

-(NSDictionary *)toDictionary;
@end
