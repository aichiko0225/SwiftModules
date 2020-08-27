//
//  NibLayoutTool.h
//  ZNZRCP
//
//  Created by 王立 on 2019/6/11.
//  Copyright © 2019 com.ssi. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NibLayoutTool : NSObject

+ (instancetype)sharedTool;

//是否开启全局修改xib加载的约束,包括文字大小
@property (nonatomic, assign) BOOL shouldChangeLayout;


@end

NS_ASSUME_NONNULL_END
