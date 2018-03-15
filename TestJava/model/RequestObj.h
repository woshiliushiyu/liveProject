//
//  RequestObj.h
//  TestJava
//
//  Created by 流诗语 on 2017/8/18.
//  Copyright © 2017年 刘世玉. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveObjC/ReactiveObjC.h>
#import <AFNetworking/AFNetworking.h>
#import "StatueModel.h"
#import "LayoutModel.h"
// .h
#define singleton_interface(class) + (instancetype)shared##class;

// .m
#define singleton_implementation(class) \
static class *_instance; \
\
+ (id)allocWithZone:(struct _NSZone *)zone \
{ \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
_instance = [super allocWithZone:zone]; \
}); \
\
return _instance; \
} \
\
+ (instancetype)shared##class \
{ \
if (_instance == nil) { \
_instance = [[class alloc] init]; \
} \
\
return _instance; \
}

@interface RequestObj : NSObject
singleton_interface(RequestObj);

-(RACSignal *)requestLocalJson;

-(RACSignal *)requestFormJson:(NSString *)url;

-(RACSignal * )requestFormAgin;

@end
