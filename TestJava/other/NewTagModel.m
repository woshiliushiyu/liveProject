
//
//  NewTagModel.m
//  TestJava
//
//  Created by 流诗语 on 2018/4/15.
//  Copyright © 2018年 刘世玉. All rights reserved.
//

#import "NewTagModel.h"

@implementation NewTagModel
- (instancetype)initWithUid:(NSString *)uid Title:(NSString *)title
{
    self = [super init];
    if (self) {
        self.uid = uid;
        self.title = title;
    }
    return self;
}
@end
