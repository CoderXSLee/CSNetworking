#import "CSTip.h"
#import "MBProgressHUD.h"

#define UIColorFromSameRGBA(r,a) [UIColor colorWithRed:(r)/255.0f green:(r)/255.0f blue:(r)/255.0f alpha:(a)]

@implementation CSTip

+ (void)showHint:(NSString *)hint
{
    //显示提示信息
    UIWindow *window = [[[UIApplication sharedApplication] windows] lastObject];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:window animated:YES];
    hud.userInteractionEnabled = NO;
    // Configure for text only and offset down
    hud.color = UIColorFromSameRGBA(0, 0.7);
    hud.mode = MBProgressHUDModeText;
    hud.labelText = hint;
    hud.labelFont=[UIFont systemFontOfSize:14];
    hud.margin = 10.f;
    hud.yOffset = 100;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:1.8];
}

+ (void)showHint:(NSString *)hint yOffset:(float)yOffset {
    //显示提示信息
    UIView *view = [[[UIApplication sharedApplication] windows] lastObject];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.userInteractionEnabled = NO;
    // Configure for text only and offset down
    hud.color = UIColorFromSameRGBA(0, 0.7);
    hud.mode = MBProgressHUDModeText;
    hud.labelText = hint;
    hud.labelFont=[UIFont systemFontOfSize:14];
    hud.margin = 10.f;
    hud.yOffset = 100;
    hud.yOffset += yOffset;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:1.8];
}

@end
