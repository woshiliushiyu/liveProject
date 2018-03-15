//
//  DKNetworkConfig.m
//  TestJava
//
//  Created by 流诗语 on 2017/8/21.
//  Copyright © 2017年 刘世玉. All rights reserved.
//

#import "DKNetworkConfig.h"
#import "DKNetworking.h"
#import "TeamModel.h"
#import <ReactiveObjC/ReactiveObjC.h>

@implementation DKNetworkConfig
+ (void) load
{
//    [DKNetworking setupResponseSignalWithFlattenMapBlock:^RACStream *(RACTuple *tuple) {
//        DKNetworkResponse *response = tuple.second; // 框架默认返回的response
//        TeamModel *myResponse = [TeamModel mj_objectWithKeyValues:response.rawData]; // 项目需要的response
//        myResponse.rawData = response.rawData;
//        myResponse.error = response.error;
//        return [RACSignal return:RACTuplePack(tuple.first, myResponse)];
//    }];
}
@end
