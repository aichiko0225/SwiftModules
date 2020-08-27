//
//  ApplicationManager.m
//  MiniApp
//
//  Created by 王立 on 2017/4/2.
//  Copyright © 2017年 王立. All rights reserved.
//

#import "ApplicationManager.h"
#import <sys/utsname.h>
#import <AVFoundation/AVFoundation.h>
@implementation ApplicationManager

+(instancetype)sharedApplicationManager
{
    static ApplicationManager *a = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        a = [[ApplicationManager alloc] init];
    });
    return a;
}

#pragma mark - app名字
+(NSString *)displayName
{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_Name = [infoDictionary objectForKey:@"CFBundleDisplayName"];
    return app_Name;
}
#pragma mark - 禁止休眠
+(void)forbidMobileSleep
{
    [UIApplication sharedApplication].idleTimerDisabled = YES;
}
#pragma mark - 打开手电筒
+(void)flashlight:(BOOL)forOpen{
    Class captureDeviceClass = NSClassFromString(@"AVCaptureDevice");
    if (captureDeviceClass != nil) {
        AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        if ([device hasTorch]) { // 判断是否有闪光灯
            // 请求独占访问硬件设备
            [device lockForConfiguration:nil];
            if (forOpen) {
                [device setTorchMode:AVCaptureTorchModeOn]; // 手电筒开
            }else{
                [device setTorchMode:AVCaptureTorchModeOff]; // 手电筒关
            }
            // 请求解除独占访问硬件设备
            [device unlockForConfiguration];
        }
    }
}
#pragma mark - 动画切换根视图
+(void)exchangeAppRootVC:(UIViewController *)newVC WithAnimation:(UIViewAnimationOptions)animationType
{
    // options是动画选项
    [UIView transitionWithView:[UIApplication sharedApplication].keyWindow duration:0.5f options:animationType animations:^{
        BOOL oldState = [UIView areAnimationsEnabled];
        [UIView setAnimationsEnabled:NO];
        [UIApplication sharedApplication].keyWindow.rootViewController = newVC;
        [UIView setAnimationsEnabled:oldState];
    } completion:^(BOOL finished) {
        
    }];
}

+(void)openUrl:(NSURL *)URL
{
    UIApplication *application = [UIApplication sharedApplication];
    if ([application respondsToSelector:@selector(openURL:options:completionHandler:)]) {
        
        //[application openURL:URL] ;
        if (@available(iOS 10.0, *)) {
            [application openURL:URL options:@{} completionHandler:nil];
        } else {
            [application openURL:URL];
        }
    } else {
        [application openURL:URL];
    }
}

#pragma mark - 去手机设置界面
+(void)gotoAppSet
{
    if (UIApplicationOpenSettingsURLString != NULL) {
      //  UIApplication *application = [UIApplication sharedApplication];
        NSURL *URL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        [self openUrl:URL];
    }
}
#pragma mark - 打电话
+(void)callPhone:(NSString *)phoneNum
{
    NSString *phoneStr = [@"tel://" stringByAppendingString:phoneNum];
    NSURL *url = [NSURL URLWithString:phoneStr];
    if (url) {

        [self openUrl:url];
    }
}

+(void)openSafariWithStr:(NSString *)str
{
    if (![str containsString:@"http"]) {
        return;
    }
    NSURL *url = [NSURL URLWithString:str];
    if (url) {
        [self openUrl:url];
    }
}

#pragma mark - 获取手机型号
+(NSString *)getDeviceInfo {
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *platform = [NSString stringWithCString:systemInfo.machine encoding:NSASCIIStringEncoding];
    if ([platform isEqualToString:@"iPhone1,1"]) return @"iPhone 2G";
    if ([platform isEqualToString:@"iPhone1,2"]) return @"iPhone 3G";
    if ([platform isEqualToString:@"iPhone2,1"]) return @"iPhone 3GS";
    if ([platform isEqualToString:@"iPhone3,1"]) return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone3,2"]) return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone3,3"]) return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone4,1"]) return @"iPhone 4S";
    if ([platform isEqualToString:@"iPhone5,1"]) return @"iPhone 5";
    if ([platform isEqualToString:@"iPhone5,2"]) return @"iPhone 5";
    if ([platform isEqualToString:@"iPhone5,3"]) return @"iPhone 5c";
    if ([platform isEqualToString:@"iPhone5,4"]) return @"iPhone 5c";
    if ([platform isEqualToString:@"iPhone6,1"]) return @"iPhone 5s";
    if ([platform isEqualToString:@"iPhone6,2"]) return @"iPhone 5s";
    if ([platform isEqualToString:@"iPhone7,1"]) return @"iPhone 6 Plus";
    if ([platform isEqualToString:@"iPhone7,2"]) return @"iPhone 6";
    if ([platform isEqualToString:@"iPhone8,1"]) return @"iPhone 6s";
    if ([platform isEqualToString:@"iPhone8,2"]) return @"iPhone 6s Plus";
    // 日行两款手机型号均为日本独占，可能使用索尼FeliCa支付方案而不是苹果支付
    if ([platform isEqualToString:@"iPhone9,1"])    return @"国行、日版、港行iPhone 7";
    if ([platform isEqualToString:@"iPhone9,2"])    return @"港行、国行iPhone 7 Plus";
    if ([platform isEqualToString:@"iPhone9,3"])    return @"美版、台版iPhone 7";
    if ([platform isEqualToString:@"iPhone9,4"])    return @"美版、台版iPhone 7 Plus";
    if ([platform isEqualToString:@"iPhone8,4"]) return @"iPhone SE";
    if ([platform isEqualToString:@"iPod1,1"]) return @"iPod Touch 1G";
    if ([platform isEqualToString:@"iPod2,1"]) return @"iPod Touch 2G";
    if ([platform isEqualToString:@"iPod3,1"]) return @"iPod Touch 3G";
    if ([platform isEqualToString:@"iPod4,1"]) return @"iPod Touch 4G";
    if ([platform isEqualToString:@"iPod5,1"]) return @"iPod Touch 5G";
    if ([platform isEqualToString:@"iPad1,1"]) return @"iPad 1G";
    if ([platform isEqualToString:@"iPad2,1"]) return @"iPad 2";
    if ([platform isEqualToString:@"iPad2,2"]) return @"iPad 2";
    if ([platform isEqualToString:@"iPad2,3"]) return @"iPad 2";
    if ([platform isEqualToString:@"iPad2,4"]) return @"iPad 2";
    if ([platform isEqualToString:@"iPad2,5"]) return @"iPad Mini 1G";
    if ([platform isEqualToString:@"iPad2,6"]) return @"iPad Mini 1G";
    if ([platform isEqualToString:@"iPad2,7"]) return @"iPad Mini 1G";
    if ([platform isEqualToString:@"iPad3,1"]) return @"iPad 3";
    if ([platform isEqualToString:@"iPad3,2"]) return @"iPad 3";
    if ([platform isEqualToString:@"iPad3,3"]) return @"iPad 3";
    if ([platform isEqualToString:@"iPad3,4"]) return @"iPad 4";
    if ([platform isEqualToString:@"iPad3,5"]) return @"iPad 4";
    if ([platform isEqualToString:@"iPad3,6"]) return @"iPad 4";
    if ([platform isEqualToString:@"iPad4,1"]) return @"iPad Air";
    if ([platform isEqualToString:@"iPad4,2"]) return @"iPad Air";
    if ([platform isEqualToString:@"iPad4,3"]) return @"iPad Air";
    if ([platform isEqualToString:@"iPad4,4"]) return @"iPad Mini 2G";
    if ([platform isEqualToString:@"iPad4,5"]) return @"iPad Mini 2G";
    if ([platform isEqualToString:@"iPad4,6"]) return @"iPad Mini 2G";
    if ([platform isEqualToString:@"i386"]) return @"iPhone Simulator";
    if ([platform isEqualToString:@"x86_64"]) return @"iPhone Simulator";
    return platform;
}

#pragma mark - 删除NSUserDefaults所有记录
+(void)removeAllUserDefaults
{
    NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
    [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];
}

#pragma mark - 获取当前控制器
+ (UIViewController *)currentVC{
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal){
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows){
            if (tmpWin.windowLevel == UIWindowLevelNormal){
                window = tmpWin;
                break;
            }
        }
    }
    UIViewController *result = window.rootViewController;
    while (result.presentedViewController) {
        result = result.presentedViewController;
    }
    if ([result isKindOfClass:[UITabBarController class]]) {
        result = [(UITabBarController *)result selectedViewController];
    }
    if ([result isKindOfClass:[UINavigationController class]]) {
        result = [(UINavigationController *)result topViewController];
    }
    return result;
}
@end
