
//
//  UIView+ViewController.m
//  TestJava
//
//  Created by 流诗语 on 2018/4/18.
//  Copyright © 2018年 刘世玉. All rights reserved.
//

#import "UIView+ViewController.h"

@implementation UIView (ViewController)
- (UIViewController *)jk_viewController
{
    UIResponder *responder = self.nextResponder;
    do {
        if ([responder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)responder;
        }
        responder = responder.nextResponder;
    } while (responder);
    return nil;
}
@end
