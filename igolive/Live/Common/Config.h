

#import <Foundation/Foundation.h>
#import "LiveUser.h"

@interface Config : NSObject

+ (void)saveProfile:(LiveUser *)user;
+ (void)updateProfile:(LiveUser *)user;
+ (void)clearProfile;
+ (void)savePersonInfoModel:(PersonalInfoModel *)model;
+ (PersonalInfoModel *)getpersonInfoModel;

+ (LiveUser *)myProfile;
+ (NSString *)getOwnID;
+ (NSString *)getOwnNicename;
+ (NSString *)getOwnToken;
+ (NSString *)getOwnSignature;
+ (NSString *)getOwnAyatar;
+ (NSString *)timeConvert;

@end
