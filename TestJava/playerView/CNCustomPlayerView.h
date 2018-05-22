//
//  CNCustomPlayerView.h
//  TestJava
//
//  Created by 流诗语 on 2018/5/8.
//  Copyright © 2018年 刘世玉. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GKPhoto.h"
#import "GKLoadingView.h"

@interface CNCustomPlayerView : UIView

@property (nonatomic, strong, readonly) UIImageView *imageView;

@property (nonatomic, strong, readonly) GKLoadingView *loadingView;

@property (nonatomic, strong, readonly) GKPhoto *photo;

@property (nonatomic, copy) void(^zoomEnded)(NSInteger scale);

/** 是否重新布局 */
@property (nonatomic, assign) BOOL isLayoutSubViews;

// 设置数据
- (void)setupPhoto:(GKPhoto *)photo;

- (void)adjustFrame;

// 重新布局
- (void)resetFrame;
@end
