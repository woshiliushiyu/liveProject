//
//  ExtensionConfig.m
//  TestJava
//
//  Created by 流诗语 on 2017/8/21.
//  Copyright © 2017年 刘世玉. All rights reserved.
//

#import "ExtensionConfig.h"
#import "MJExtension.h"
#import "TeamModel.h"
#import <ReactiveObjC/ReactiveObjC.h>
@implementation ExtensionConfig
+ (void) load
{
    [NSObject mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{@"ID":@"id"};
    }];
    
}
@end
