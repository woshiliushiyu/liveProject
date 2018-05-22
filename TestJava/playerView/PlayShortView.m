
//
//  PlayShortView.m
//  TestJava
//
//  Created by 流诗语 on 2018/5/4.
//  Copyright © 2018年 刘世玉. All rights reserved.
//

#import "PlayShortView.h"

@implementation PlayShortView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        self.backgroundColor = [UIColor blackColor];
    }
    return self;
}

@end
