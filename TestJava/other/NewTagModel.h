//
//  NewTagModel.h
//  TestJava
//
//  Created by 流诗语 on 2018/4/15.
//  Copyright © 2018年 刘世玉. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewTagModel : NSObject
@property (copy, nonatomic) NSString * uid;
@property (copy, nonatomic) NSString * title;
- (instancetype)initWithUid:(NSString *)uid Title:(NSString *)title;
@end
