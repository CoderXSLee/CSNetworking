#import "CSTip.h"

// 背景视图的宽度/高度
#define BGVIEW_WIDTH 100.0f
// 文字大小
#define TEXT_SIZE    14.0f

@implementation CSTip

+ (instancetype)sharedHUD {
    static id hud;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        hud = [[self alloc] initWithWindow:[UIApplication sharedApplication].keyWindow];
    });
    return hud;
}

+ (void)showStatus:(LCProgressHUDStatus)status text:(NSString *)text {
    CSTip *hud = [CSTip sharedHUD];
    [hud show:YES];
    [hud setShowNow:YES];
    [hud setLabelText:text];
    [hud setRemoveFromSuperViewOnHide:YES];
    [hud setLabelFont:[UIFont boldSystemFontOfSize:TEXT_SIZE]];
    [hud setMinSize:CGSizeMake(BGVIEW_WIDTH, BGVIEW_WIDTH)];
    [[UIApplication sharedApplication].keyWindow addSubview:hud];
    
    NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"LCProgressHUD" ofType:@"bundle"];
    
    switch (status) {
            
        case CSProgressHUDStatusSuccess: {
            
            NSString *sucPath = [bundlePath stringByAppendingPathComponent:@"hud_success@2x.png"];
            UIImage *sucImage = [UIImage imageWithContentsOfFile:sucPath];
            
            hud.mode = MBProgressHUDModeCustomView;
            UIImageView *sucView = [[UIImageView alloc] initWithImage:sucImage];
            hud.customView = sucView;
            [hud hide:YES afterDelay:2.0f];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [hud setShowNow:NO];
            });
        }
            break;
            
        case CSProgressHUDStatusError: {
            
            NSString *errPath = [bundlePath stringByAppendingPathComponent:@"hud_error@2x.png"];
            UIImage *errImage = [UIImage imageWithContentsOfFile:errPath];
            
            hud.mode = MBProgressHUDModeCustomView;
            UIImageView *errView = [[UIImageView alloc] initWithImage:errImage];
            hud.customView = errView;
            [hud hide:YES afterDelay:2.0f];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [hud setShowNow:NO];
            });
        }
            break;
            
        case CSProgressHUDStatusWaitting: {
            
            hud.mode = MBProgressHUDModeIndeterminate;
        }
            break;
            
        case CSProgressHUDStatusInfo: {
            
            NSString *infoPath = [bundlePath stringByAppendingPathComponent:@"hud_info@2x.png"];
            UIImage *infoImage = [UIImage imageWithContentsOfFile:infoPath];
            
            hud.mode = MBProgressHUDModeCustomView;
            UIImageView *infoView = [[UIImageView alloc] initWithImage:infoImage];
            hud.customView = infoView;
            [hud hide:YES afterDelay:2.0f];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [hud setShowNow:NO];
            });
        }
            break;
            
        default:
            break;
    }
}

+ (void)showHint:(NSString *)hint {
    CSTip *hud = [CSTip sharedHUD];
    [hud show:YES];
    [hud setShowNow:YES];
    [hud setLabelText:hint];
    [hud setMinSize:CGSizeZero];
    [hud setMode:MBProgressHUDModeText];
    [hud setRemoveFromSuperViewOnHide:YES];
    [hud setLabelFont:[UIFont boldSystemFontOfSize:TEXT_SIZE]];
    [[UIApplication sharedApplication].keyWindow addSubview:hud];
    //    [hud hide:YES afterDelay:2.0f];
    
    [NSTimer scheduledTimerWithTimeInterval:2.0f target:self selector:@selector(hide) userInfo:nil repeats:NO];
}

+ (void)showHint:(NSString *)hint yOffset:(float)yOffset {
    CSTip *hud = [CSTip sharedHUD];
    [hud show:YES];
    [hud setShowNow:YES];
    hud.yOffset = 100;
    hud.yOffset += yOffset;
    [hud setLabelText:hint];
    [hud setMinSize:CGSizeZero];
    [hud setMode:MBProgressHUDModeText];
    [hud setRemoveFromSuperViewOnHide:YES];
    [hud setLabelFont:[UIFont boldSystemFontOfSize:TEXT_SIZE]];
    [[UIApplication sharedApplication].keyWindow addSubview:hud];
    //    [hud hide:YES afterDelay:2.0f];
    
    [NSTimer scheduledTimerWithTimeInterval:2.0f target:self selector:@selector(hide) userInfo:nil repeats:NO];
}


+ (void)showInfoMsg:(NSString *)text {
    [self showStatus:CSProgressHUDStatusInfo text:text];
}

+ (void)showFailure:(NSString *)text {
    [self showStatus:CSProgressHUDStatusError text:text];
}

+ (void)showSuccess:(NSString *)text {
    [self showStatus:CSProgressHUDStatusSuccess text:text];
}

+ (void)showLoading:(NSString *)text {
    [self showStatus:CSProgressHUDStatusWaitting text:text];
}

+ (void)hide {
    [[CSTip sharedHUD] setShowNow:NO];
    [[CSTip sharedHUD] hide:YES];
}

@end
