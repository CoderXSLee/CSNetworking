#import <UIKit/UIKit.h>

@interface CSTip : NSObject

+ (void)showHint:(NSString *)hint;
+ (void)showHint:(NSString *)hint yOffset:(float)yOffset;

@end
