//
//  AuthorizationManager.h
//  MiniApp
//
//  Created by 王立 on 2017/4/1.
//  Copyright © 2017年 王立. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, AuthorizationType) {
    AuthorizationTypePhoto = 1,
    AuthorizationTypeCamera = 2,
    AuthorizationTypeLocation = 4,
    AuthorizationTypeMicrophone = 8,
};

@interface AuthorizationManager : NSObject

+(instancetype)sharedAuthorizationManager;

+(void)checkAuthorization:(AuthorizationType)authorizationType passblock:(dispatch_block_t)passblock;

@end
