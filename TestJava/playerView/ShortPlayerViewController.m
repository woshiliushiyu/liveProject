
//
//  ShortPlayerViewController.m
//  TestJava
//
//  Created by 流诗语 on 2018/5/7.
//  Copyright © 2018年 刘世玉. All rights reserved.
//

#import "ShortPlayerViewController.h"

@interface ShortPlayerViewController ()

@end

@implementation ShortPlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    
}

#pragma mark - 屏幕旋转
- (BOOL)shouldAutorotate {
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
