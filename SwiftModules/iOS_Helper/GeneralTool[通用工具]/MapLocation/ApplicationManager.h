//
//  ApplicationManager.h
//  MiniApp
//
//  Created by 王立 on 2017/4/2.
//  Copyright © 2017年 王立. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ApplicationManager.h"

@interface ApplicationManager : NSObject


+(instancetype)sharedApplicationManager;
/**获取app名字*/
+(NSString *)displayName;
/**禁止手机休眠*/
+(void)forbidMobileSleep;
/**打开手电筒*/
+(void)flashlight:(BOOL)forOpen;
/**动画切换window的根控制器*/
+(void)exchangeAppRootVC:(UIViewController *)newVC WithAnimation:(UIViewAnimationOptions)animationType;
/**进入app设置界面*/
+(void)gotoAppSet;
/**打电话*/
+(void)callPhone:(NSString *)phoneNum;
/**打开一个网页*/
+(void)openSafariWithStr:(NSString *)str;
/**获取设备型号*/
+(NSString *)getDeviceInfo;
/**删除NSUserDefaults所有记录*/
+(void)removeAllUserDefaults;
/**获取当前控制器*/
+ (UIViewController *)currentVC;

@end
