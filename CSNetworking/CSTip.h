#import "MBProgressHUD.h"

typedef NS_ENUM(NSInteger, LCProgressHUDStatus) {
    CSProgressHUDStatusSuccess,
    CSProgressHUDStatusError,
    CSProgressHUDStatusInfo,
    CSProgressHUDStatusWaitting
};

@interface CSTip : MBProgressHUD

@property (nonatomic, assign, getter=isShowNow) BOOL showNow;

+ (instancetype)sharedHUD;

+ (void)hide;
+ (void)showHint:(NSString *)hint;
+ (void)showHint:(NSString *)hint yOffset:(float)yOffset;

+ (void)showInfoMsg:(NSString *)text;
+ (void)showFailure:(NSString *)text;
+ (void)showSuccess:(NSString *)text;
+ (void)showLoading:(NSString *)text;

+ (void)showStatus:(LCProgressHUDStatus)status text:(NSString *)text;

@end
