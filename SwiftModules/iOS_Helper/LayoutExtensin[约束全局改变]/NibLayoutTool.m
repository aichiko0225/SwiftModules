//
//  NibLayoutTool.m
//  ZNZRCP
//
//  Created by 王立 on 2019/6/11.
//  Copyright © 2019 com.ssi. All rights reserved.
//

#import "NibLayoutTool.h"

@implementation NibLayoutTool

+ (instancetype)sharedTool{
    static NibLayoutTool* tool;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        tool = [[NibLayoutTool alloc] init];
        tool.shouldChangeLayout = true;
    });
    return tool;
}



@end
