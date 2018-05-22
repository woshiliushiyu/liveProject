
//
//  CNCustomPlayerBrowser.m
//  TestJava
//
//  Created by 流诗语 on 2018/5/8.
//  Copyright © 2018年 刘世玉. All rights reserved.
//

#import "CNCustomPlayerBrowser.h"

#define kPhotoViewPadding 10

@interface CNCustomPlayerBrowser ()
{
    UILabel  * _countLabel;
    CGPoint  _startLocation;
    BOOL     _isStatusBarShowing;
}

@property (nonatomic, strong, readwrite) UIView *contentView;

@property (nonatomic, strong, readwrite) GKPhoto *video;

@property (nonatomic, assign, readwrite) NSInteger currentIndex;

@property (nonatomic, strong) UIScrollView *videoScrollView;

@property (nonatomic, strong) NSMutableArray *visiblePhotoViews;
@property (nonatomic, strong) NSMutableSet *reusablePhotoViews;

@property (nonatomic, strong) UIViewController *fromVC;

@property (nonatomic, assign) BOOL isShow;

@property (nonatomic, strong) NSArray *coverViews;

/** 记录上一次的设备方向 */
@property (nonatomic, assign) UIDeviceOrientation originalOrientation;

/** 正在发生屏幕旋转 */
@property (nonatomic, assign) BOOL isRotation;

/** 状态栏正在发生变化 */
@property (nonatomic, assign) BOOL isStatusBarChanged;

@property (nonatomic, assign) BOOL isPortraitToUp;

@property (nonatomic, strong) UIPanGestureRecognizer *panGesture;
@end

@implementation CNCustomPlayerBrowser

- (CNCustomPlayerView *)currentPhotoView {
    return [self photoViewForIndex:self.currentIndex];
}

+ (instancetype)photoBrowserWithPhotos:(GKPhoto *)photo currentIndex:(NSInteger)currentIndex {
    return [[self alloc] initWithPhotos:photo currentIndex:currentIndex];
}

- (instancetype)initWithPhotos:(GKPhoto *)photo currentIndex:(NSInteger)currentIndex {
    if (self = [super init]) {
        
        self.video       = photo;
        self.currentIndex = currentIndex;
        
        self.isStatusBarShow  = NO;
        self.isHideSourceView = YES;
        
        _visiblePhotoViews  = [NSMutableArray new];
        _reusablePhotoViews = [NSMutableSet new];
        
        self.modalPresentationStyle = UIModalPresentationCustom;
        self.modalTransitionStyle   = UIModalTransitionStyleCoverVertical;
    }
    return self;
}
- (instancetype)init {
    NSAssert(NO, @"Use initWithPhotos:currentIndex: instead.");
    return nil;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // 设置UI
    [self setupUI];
    
    // 手势和监听
    [self addGestureAndObserver];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    CNCustomPlayerView *videoView  = [self currentPhotoView];
    
    if (self.video.image) {
        [videoView setupPhoto:self.video];
    }else {
        videoView.imageView.image = self.video.placeholderImage;
        [videoView adjustFrame];
    }
    
    [self browserZoomShow];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    if (!self.isStatusBarChanged) {
        [self layoutSubviews];
    }
}
#pragma mark - 布局
- (void)setupUI {
    
    [self.navigationController setNavigationBarHidden:YES];
    
    self.view.backgroundColor   = [UIColor blackColor];
    
    self.contentView = [[UIView alloc] initWithFrame:self.view.bounds];
    self.contentView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.contentView];
    
    [self.contentView addSubview:self.videoScrollView];
    
    [self setupPhotoViews];
}
- (void)addGestureAndObserver {
    
    [self addGestureRecognizer];
    
    [self addDeviceOrientationObserver];
}

#pragma mark - Private Methods

- (void)addGestureRecognizer {
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    singleTap.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:singleTap];
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    [self.view addGestureRecognizer:longPress];
    
    // 拖拽手势
    [self addPanGesture:YES];
}

- (void)addPanGesture:(BOOL)isFirst {
    
    if (isFirst) {
        [self.view addGestureRecognizer:self.panGesture];
    }else {
        UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
        
        if (UIDeviceOrientationIsPortrait(orientation) || self.isPortraitToUp) {
            [self.view addGestureRecognizer:self.panGesture];
        }
    }
}

- (void)removePanGesture {
    if ([self.view.gestureRecognizers containsObject:self.panGesture]) {
        [self.view removeGestureRecognizer:self.panGesture];
    }
}
#pragma mark - Public Methods
- (void)showFromVC:(UIViewController *)vc {
    
    self.fromVC = vc;
    
    self.modalPresentationCapturesStatusBarAppearance = YES;
    [vc presentViewController:self animated:NO completion:nil];
}

- (void)dismissAnimated:(BOOL)animated {
    if (animated) {
        [UIView animateWithDuration:0.25f animations:^{
            self.video.sourceImageView.alpha = 1.0;
        }];
    }else {
        self.video.sourceImageView.alpha = 1.0;
    }
    
    [self dismissViewControllerAnimated:NO completion:nil];
}

// 设置图片视图
- (void)setupPhotoViews {
    
    CNCustomPlayerView *videoView = [[CNCustomPlayerView alloc] initWithFrame:self.videoScrollView.bounds];
    
    videoView.zoomEnded     = ^(NSInteger scale) {
        if (scale == 1.0f) {
            [self addPanGesture:NO];
        }else {
            [self removePanGesture];
        }
    };
    CGRect frame            = self.videoScrollView.bounds;
    
    CGFloat photoScrollW    = frame.size.width;
    CGFloat photoScrollH    = frame.size.height;
    // 调整当前显示的photoView的frame
    CGFloat w = photoScrollW - kPhotoViewPadding * 2;
    CGFloat h = photoScrollH;
    CGFloat x = kPhotoViewPadding;
    CGFloat y = 0;
    
    videoView.frame = CGRectMake(x, y, w, h);
    videoView.tag   = 0;
    [self.videoScrollView addSubview:videoView];
    [_visiblePhotoViews addObject:videoView];
    
    [videoView resetFrame];
    
    if (videoView.photo == nil && self.isShow) {
        [videoView setupPhoto:self.video];
    }
}
#pragma mark - 界面显示隐藏相关
#pragma mark - Gesture Handle
- (void)handleSingleTap:(UITapGestureRecognizer *)tap {
    
    CNCustomPlayerView *videoView = [self currentPhotoView];
    videoView.isLayoutSubViews = YES;
    
    if ([self.delegate respondsToSelector:@selector(photoBrowser:singleTapWithIndex:)]) {
        [self.delegate photoBrowser:self singleTapWithIndex:self.currentIndex];
    }
    
    if (self.isSingleTapDisabled) return;
    
    // 显示状态栏
    self.isStatusBarShow = YES;
    
    // 防止返回时跳动
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self recoverAnimation];
    });
}
- (void)recoverAnimation {
    
    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
    CGRect screenBounds = [UIScreen mainScreen].bounds;
    
    [UIView animateWithDuration:0.25f animations:^{
        // 旋转view
        self.contentView.transform = CGAffineTransformIdentity;
        
        // 设置frame
        if (UIDeviceOrientationIsLandscape(orientation)) self.contentView.bounds = CGRectMake(0, 0, MIN(screenBounds.size.width, screenBounds.size.height), MAX(screenBounds.size.width, screenBounds.size.height));
        
        self.contentView.center = [UIApplication sharedApplication].keyWindow.center;
        
        [self layoutSubviews];
        
        [self.view setNeedsLayout];
        [self.view layoutIfNeeded];
        
    }completion:^(BOOL finished) {
        [self showDismissAnimation];
    }];
}

- (void)handleLongPress:(UILongPressGestureRecognizer *)longPress {
    switch (longPress.state) {
        case UIGestureRecognizerStateBegan:{
            if ([self.delegate respondsToSelector:@selector(photoBrowser:longPressWithIndex:)]) {
                [self.delegate photoBrowser:self longPressWithIndex:self.currentIndex];
            }
        }
            break;
        case UIGestureRecognizerStateEnded:
            
            break;
            
        default:
            break;
    }
}

- (void)handlePanGesture:(UIPanGestureRecognizer *)panGesture {
    
    [self handlePanZoomScale:panGesture];
}

- (void)handlePanZoomScale:(UIPanGestureRecognizer *)panGesture {
    CGPoint point       = [panGesture translationInView:self.view];
    CGPoint location    = [panGesture locationInView:self.view];
    CGPoint velocity    = [panGesture velocityInView:self.view];
    
    CNCustomPlayerView *videoView = [self photoViewForIndex:self.currentIndex];
    
    switch (panGesture.state) {
        case UIGestureRecognizerStateBegan:
            _startLocation = location;
            [self handlePanBegin];
            break;
        case UIGestureRecognizerStateChanged: {
            double percent = 1 - fabs(point.y) / self.contentView.frame.size.height;
            percent  = MAX(percent, 0);
            double s = MAX(percent, 0.5);
            CGAffineTransform translation = CGAffineTransformMakeTranslation(point.x / s, point.y / s);
            CGAffineTransform scale = CGAffineTransformMakeScale(s, s);
            videoView.imageView.transform = CGAffineTransformConcat(translation, scale);
            self.view.backgroundColor = [UIColor colorWithWhite:0 alpha:percent];
        }
            break;
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:{
            if (fabs(point.y) > 200 || fabs(velocity.y) > 500) {
                [self showDismissAnimation];
            }else {
                [self showCancelAnimation];
            }
        }
            break;
        default:
            break;
    }
}

- (void)handlePanBegin {
    
    if (self.isHideSourceView) {
        self.video.sourceImageView.alpha = 0;
    }
    
    _isStatusBarShowing = self.isStatusBarShow;
    
    // 显示状态栏
    self.isStatusBarShow = YES;
    
    if ([self.delegate respondsToSelector:@selector(photoBrowser:panBeginWithIndex:)]) {
        [self.delegate photoBrowser:self panBeginWithIndex:self.currentIndex];
    }
}


- (void)showDismissAnimation {
    
    CNCustomPlayerView *videoView = [self photoViewForIndex:self.currentIndex];
    
    CGRect sourceRect = self.video.sourceFrame;
    
    if (CGRectEqualToRect(sourceRect, CGRectZero)) {
        if (self.video.sourceImageView == nil) {
            [UIView animateWithDuration:0.25f animations:^{
                self.view.alpha = 0;
            }completion:^(BOOL finished) {
                [self dismissAnimated:NO];
            }];
            return;
        }
        
        if (self.isHideSourceView) {
            self.video.sourceImageView.alpha = 0;
        }
        
        float systemVersion = [UIDevice currentDevice].systemVersion.floatValue;
        if (systemVersion >= 8.0 && systemVersion < 9.0) {
            sourceRect = [self.video.sourceImageView.superview convertRect:self.video.sourceImageView.frame toCoordinateSpace:videoView];
        }else {
            sourceRect = [self.video.sourceImageView.superview convertRect:self.video.sourceImageView.frame toView:videoView];
        }
    }else {
        if (self.isHideSourceView && self.video.sourceImageView) {
            self.video.sourceImageView.alpha = 0;
        }
    }
    
    [UIView animateWithDuration:0.25f animations:^{
        videoView.imageView.frame = sourceRect;
        self.view.backgroundColor = [UIColor clearColor];
    }completion:^(BOOL finished) {
        [self dismissAnimated:NO];
        
        [self panEndedWillDisappear:YES];
    }];
}

- (void)showCancelAnimation {
    CNCustomPlayerView *videoView = [self photoViewForIndex:self.currentIndex];
    self.video.sourceImageView.alpha = 1.0;
    
    [UIView animateWithDuration:0.25f animations:^{
        videoView.imageView.transform = CGAffineTransformIdentity;
        self.view.backgroundColor = [UIColor blackColor];
    }completion:^(BOOL finished) {
        
        if (!_isStatusBarShowing) {
            // 隐藏状态栏
            self.isStatusBarShow = NO;
        }
        
        [self panEndedWillDisappear:NO];
    }];
}

- (void)panEndedWillDisappear:(BOOL)disappear {
    if ([self.delegate respondsToSelector:@selector(photoBrowser:panEndedWithIndex:willDisappear:)]) {
        [self.delegate photoBrowser:self panEndedWithIndex:self.currentIndex willDisappear:disappear];
    }
}

#pragma mark - 屏幕旋转相关
- (void)addDeviceOrientationObserver {
    
    // 默认设备方向：竖屏
    self.originalOrientation = UIDeviceOrientationPortrait;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceOrientationDidChange) name:UIDeviceOrientationDidChangeNotification object:nil];
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
}

- (void)delDeviceOrientationObserver {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
    [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
}

- (void)deviceOrientationDidChange {
    
    if (self.isFullScreenDisabled) return;
    
    self.isRotation = YES;
    
    // 恢复当前视图的缩放
    self.video.isZooming = NO;
    self.video.zoomRect  = CGRectZero;
    
    // 旋转之后当前的设备方向
    UIDeviceOrientation currentOrientation = [UIDevice currentDevice].orientation;
    
    self.isPortraitToUp = NO;
    
    if (UIDeviceOrientationIsPortrait(self.originalOrientation)) {
        if (currentOrientation == UIDeviceOrientationFaceUp) {
            self.isPortraitToUp = YES;
        }
    }
    
    CGRect screenBounds = [UIScreen mainScreen].bounds;
    
    // 旋转之后是横屏
    if (UIDeviceOrientationIsLandscape(currentOrientation)) {
        // 横屏移除pan手势
        [self removePanGesture];
        
        NSTimeInterval duration = UIDeviceOrientationIsLandscape(self.originalOrientation) ? 2 * 0.25f : 0.25f;
        
        [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            
            float rotation = currentOrientation == UIDeviceOrientationLandscapeRight ? 1.5 : 0.5;
            
            // 旋转contentView
            self.contentView.transform = CGAffineTransformMakeRotation(M_PI * rotation);
            
            // 设置frame
            self.contentView.bounds = CGRectMake(0, 0, MAX(screenBounds.size.width, screenBounds.size.height), MIN(screenBounds.size.width, screenBounds.size.height));
            
            self.contentView.center = [UIApplication sharedApplication].keyWindow.center;
            
            [self layoutSubviews];
            
            [self.view setNeedsLayout];
            [self.view layoutIfNeeded];
            
        } completion:^(BOOL finished) {
            // 记录设备方向
            self.originalOrientation = currentOrientation;
            self.isRotation = NO;
        }];
    }else if (currentOrientation == UIDeviceOrientationPortrait) {
        // 竖屏时添加pan手势
        [self addPanGesture:NO];
        
        NSTimeInterval duration = 0.25f;
        
        [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            
            // 旋转view
            self.contentView.transform = currentOrientation == UIDeviceOrientationPortrait ? CGAffineTransformIdentity : CGAffineTransformMakeRotation(M_PI);
            
            // 设置frame
            self.contentView.bounds = CGRectMake(0, 0, MIN(screenBounds.size.width, screenBounds.size.height), MAX(screenBounds.size.width, screenBounds.size.height));
            self.contentView.center = [UIApplication sharedApplication].keyWindow.center;
            
            [self layoutSubviews];
            
            [self.view setNeedsLayout];
            [self.view layoutIfNeeded];
            
        } completion:^(BOOL finished) {
            // 记录设备方向
            self.originalOrientation = currentOrientation;
            self.isRotation = NO;
        }];
    }else {
        self.isRotation = NO;
    }
}
#pragma mark - BrowserShow
- (void)browserZoomShow {
    
    CNCustomPlayerView *videoView  = [self currentPhotoView];
    
    CGRect endRect    = videoView.imageView.frame;
    CGRect sourceRect = self.video.sourceFrame;
    
    if (CGRectEqualToRect(sourceRect, CGRectZero)) {
        float systemVersion = [UIDevice currentDevice].systemVersion.floatValue;
        if (systemVersion >= 8.0 && systemVersion < 9.0) {
            sourceRect = [self.video.sourceImageView.superview convertRect:self.video.sourceImageView.frame toCoordinateSpace:videoView];
        }else {
            sourceRect = [self.video.sourceImageView.superview convertRect:self.video.sourceImageView.frame toView:videoView];
        }
    }
    
    videoView.imageView.frame = sourceRect;
    
    [UIView animateWithDuration:0.25f animations:^{
        videoView.imageView.frame = endRect;
        self.view.backgroundColor = [UIColor blackColor];
    }completion:^(BOOL finished) {
        self.isShow = YES;
        [videoView setupPhoto:self.video];
        
        [self deviceOrientationDidChange];
    }];
}

- (void)layoutSubviews {
    
    CGRect frame = self.contentView.bounds;
    
    frame.origin.x   -= kPhotoViewPadding;
    frame.size.width += kPhotoViewPadding * 2;
    
    CGFloat photoScrollW = frame.size.width;
    CGFloat photoScrollH = frame.size.height;
    
    self.videoScrollView.frame  = frame;
    self.videoScrollView.center = CGPointMake(photoScrollW * 0.5 - kPhotoViewPadding, photoScrollH * 0.5);
    
    self.videoScrollView.contentOffset = CGPointMake(self.currentIndex * photoScrollW, 0);
    
    self.videoScrollView.contentSize = CGSizeMake(photoScrollW, 0);
    
    // 调整所有显示的photoView的frame
    CGFloat w = photoScrollW - kPhotoViewPadding * 2;
    CGFloat h = photoScrollH;
    CGFloat x = 0;
    CGFloat y = 0;
    
    for (CNCustomPlayerView *videoView in _visiblePhotoViews) {
        x = kPhotoViewPadding + videoView.tag * (kPhotoViewPadding * 2 + w);
        
        videoView.frame = CGRectMake(x, y, w, h);
        
        [videoView resetFrame];
    }
    
    if ([self.delegate respondsToSelector:@selector(photoBrowser:willLayoutSubViews:)]) {
        [self.delegate photoBrowser:self willLayoutSubViews:self.currentIndex];
    }
}

- (void)dealloc {
    NSLog(@"browser dealloc");
    
    [self delDeviceOrientationObserver];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 懒加载
- (UIScrollView *)videoScrollView {
    if (!_videoScrollView) {
        CGRect frame = self.view.bounds;
        frame.origin.x   -= kPhotoViewPadding;
        frame.size.width += (2 * kPhotoViewPadding);
        _videoScrollView = [[UIScrollView alloc] initWithFrame:frame];
        _videoScrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _videoScrollView.pagingEnabled  = YES;
        _videoScrollView.showsVerticalScrollIndicator   = NO;
        _videoScrollView.showsHorizontalScrollIndicator = NO;
        _videoScrollView.backgroundColor                = [UIColor clearColor];
        
        if (@available(iOS 11.0, *)) {
            _videoScrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return _videoScrollView;
}

- (UIPanGestureRecognizer *)panGesture {
    if (!_panGesture) {
        _panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
    }
    return _panGesture;
}
- (CNCustomPlayerView *)photoViewForIndex:(NSInteger)index {
    for (CNCustomPlayerView *videoView in _visiblePhotoViews) {
        if (videoView.tag == index) {
            return videoView;
        }
    }
    return nil;
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

#pragma mark - 状态栏
- (BOOL)prefersStatusBarHidden {
    return !self.isStatusBarShow;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return self.fromVC.preferredStatusBarStyle;
}
@end
