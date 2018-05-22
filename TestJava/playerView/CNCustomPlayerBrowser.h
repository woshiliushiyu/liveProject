//
//  CNCustomPlayerBrowser.h
//  TestJava
//
//  Created by 流诗语 on 2018/5/8.
//  Copyright © 2018年 刘世玉. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GKPhoto.h"
#import "CNCustomPlayerView.h"

@class CNCustomPlayerBrowser;

@protocol CNCustomPlayerBrowserDelegate<NSObject>

@optional

// 单击事件
- (void)photoBrowser:(CNCustomPlayerBrowser *)browser singleTapWithIndex:(NSInteger)index;

// 长按事件
- (void)photoBrowser:(CNCustomPlayerBrowser *)browser longPressWithIndex:(NSInteger)index;

// 上下滑动消失
// 开始滑动时
- (void)photoBrowser:(CNCustomPlayerBrowser *)browser panBeginWithIndex:(NSInteger)index;

// 结束滑动时 disappear：是否消失
- (void)photoBrowser:(CNCustomPlayerBrowser *)browser panEndedWithIndex:(NSInteger)index willDisappear:(BOOL)disappear;

- (void)photoBrowser:(CNCustomPlayerBrowser *)browser willLayoutSubViews:(NSInteger)index;

@end

@interface CNCustomPlayerBrowser : UIViewController

@property (nonatomic, strong, readonly) UIView *contentView;

@property (nonatomic, strong, readonly) GKPhoto *video;

@property (nonatomic, assign, readonly) NSInteger currentIndex;

@property (nonatomic, weak) id<CNCustomPlayerBrowserDelegate> delegate;

/** 是否禁止全屏，默认是NO */
@property (nonatomic, assign) BOOL isFullScreenDisabled;

/** 是否禁用默认单击事件 */
@property (nonatomic, assign) BOOL isSingleTapDisabled;

/** 是否显示状态栏，默认NO：不显示状态栏 */
@property (nonatomic, assign) BOOL isStatusBarShow;

/** 滑动消失时是否隐藏原来的视图：默认YES */
@property (nonatomic, assign) BOOL isHideSourceView;


/**
 创建视频播放器

 @param photo 视频播放数据源
 @param currentIndex 当前点击的位置
 @return 返回
 */
+ (instancetype)photoBrowserWithPhotos:(GKPhoto *)photo currentIndex:(NSInteger)currentIndex;

- (instancetype)initWithPhotos:(GKPhoto *)photo currentIndex:(NSInteger)currentIndex;

/**
 显示图片浏览器
 
 @param vc 控制器
 */
- (void)showFromVC:(UIViewController *)vc;
@end
