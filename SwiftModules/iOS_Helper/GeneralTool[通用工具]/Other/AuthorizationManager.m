//
//  AuthorizationManager.m
//  MiniApp
//
//  Created by 王立 on 2017/4/1.
//  Copyright © 2017年 王立. All rights reserved.
//

#import "AuthorizationManager.h"
#import <Photos/Photos.h>
#import <AVFoundation/AVFoundation.h>
#import <MapKit/MapKit.h>
@implementation AuthorizationManager

+(instancetype)sharedAuthorizationManager
{
    static AuthorizationManager *t = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        t = [[AuthorizationManager alloc] init];
    });
    return t;
}


+(void)checkAuthorization:(AuthorizationType)authorizationType passblock:(dispatch_block_t)passblock;
{
    if (authorizationType == 1){
        
        if ([self authorizationForPhoto]) {
            if (passblock) {
                passblock();
            }
        }else{
            [self alertAuthorizationFor:authorizationType];
        }
    }else if (authorizationType == 2) {
        
        if([self authorizationForCamera]){
            if (passblock) {
                passblock();
            }
        }else{
            [self alertAuthorizationFor:authorizationType];
        }
    }else if(authorizationType == 3){
        if ([self authorizationForPhoto]&&[self authorizationForCamera]) {
            if (passblock) {
                passblock();
            }
        }else{
            [self alertAuthorizationFor:authorizationType];
        }
    }else if (authorizationType == 4){
        if ([self authorizationForLocation]) {
            if (passblock) {
                passblock();
            }
        }else{
            [self alertAuthorizationFor:authorizationType];
        }
    }else if (authorizationType == 8){
        if ([self authorizationForMicrophone]) {
            if (passblock) {
                passblock();
            }
        }else{
            [self alertAuthorizationFor:authorizationType];
        }
    }else if (authorizationType == 10){
        if ([self authorizationForMicrophone]&&[self authorizationForCamera]) {
            if (passblock) {
                passblock();
            }
        }else{
            [self alertAuthorizationFor:authorizationType];
        }
    }
}
#pragma mark - 相册权限
+(BOOL)authorizationForPhoto
{
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (status == PHAuthorizationStatusDenied || status == PHAuthorizationStatusRestricted || status == PHAuthorizationStatusNotDetermined) {
        return NO;
    }
    return YES;
}

#pragma mark - 相机权限
+(BOOL)authorizationForCamera
{
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied){
        return NO;
    }
    return YES;
}

#pragma mark - 定位权限
+(BOOL)authorizationForLocation
{
    CLAuthorizationStatus authStatus = [CLLocationManager authorizationStatus];
    if (authStatus==kCLAuthorizationStatusDenied || authStatus==kCLAuthorizationStatusRestricted || authStatus==kCLAuthorizationStatusNotDetermined) {
        return NO;
    }
    return YES;
}

#pragma mark - 麦克风权限
+ (BOOL)authorizationForMicrophone{
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
    if (authStatus==AVAuthorizationStatusNotDetermined || authStatus==AVAuthorizationStatusRestricted || authStatus==AVAuthorizationStatusDenied){
        return NO;
    }else if (authStatus==AVAuthorizationStatusAuthorized){
        return YES;
    }
    return YES;
}


+(void)alertAuthorizationFor:(AuthorizationType)authorizationType
{
    NSString *tips;
    NSString *title;
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_Name = [infoDictionary objectForKey:@"CFBundleDisplayName"];
    if(authorizationType == 1)
    {
        title = @"访问照片权限被禁用";
        tips = [NSString stringWithFormat:@"请在iPhone的“设置”中允许\"%@\"访问你的手机照片",app_Name];
    }
    else if (authorizationType == 2)
    {
        title = @"访问相机权限被禁用";
        tips = [NSString stringWithFormat:@"请在iPhone的“设置”中允许\"%@\"访问你的手机相机",app_Name];
    }
    else if (authorizationType == 3)
    {
        title = @"访问相机或相册权限被禁用";
        tips = [NSString stringWithFormat:@"请在iPhone的“设置”中允许\"%@\"访问你的手机相机及相册",app_Name];
    }
    else if (authorizationType == 4)
    {
        title = @"定位权限被禁用";
        tips = [NSString stringWithFormat:@"请在iPhone的“设置”中允许\"%@\"使用定位功能",app_Name];
    }
    else if (authorizationType == 8)
    {
        title = @"麦克风权限被禁用";
        tips = [NSString stringWithFormat:@"请在iPhone的“设置”中允许\"%@\"使用麦克风",app_Name];
    }
    else if (authorizationType == 10)
    {
        title = @"麦克风或相机权限被禁用";
        tips = [NSString stringWithFormat:@"请在iPhone的“设置”中允许\"%@\"使用麦克风及相机",app_Name];
    }
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:title message:tips preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"去设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self openUrl:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
    [alertVC addAction:action2];
    [alertVC addAction:action];
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertVC animated:YES completion:nil];
}

+(void)openUrl:(NSURL *)URL
{
    UIApplication *application = [UIApplication sharedApplication];
    if ([application respondsToSelector:@selector(openURL:options:completionHandler:)]) {
        [application openURL:URL options:@{}
           completionHandler:nil];
    } else {
        [application openURL:URL];
    }
}

@end

