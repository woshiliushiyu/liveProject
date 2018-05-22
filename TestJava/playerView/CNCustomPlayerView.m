

//
//  CNCustomPlayerView.m
//  TestJava
//
//  Created by 流诗语 on 2018/5/8.
//  Copyright © 2018年 刘世玉. All rights reserved.
//

#import "CNCustomPlayerView.h"
#import "GKPhoto.h"

#define GKScreenW [UIScreen mainScreen].bounds.size.width
#define GKScreenH [UIScreen mainScreen].bounds.size.height

@interface CNCustomPlayerView()
@property (nonatomic, strong, readwrite) UIImageView *imageView;

@property (nonatomic, strong, readwrite) AVPlayerItem *playerItem;

@property (nonatomic, strong, readwrite) AVPlayer *player;

@property (nonatomic, strong, readwrite) AVPlayerLayer *playerLayer;

@property (nonatomic, strong, readwrite) GKLoadingView *loadingView;

@property (nonatomic, strong, readwrite) GKPhoto * photo;

@end
@implementation CNCustomPlayerView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor clearColor];
        
        [self addSubview:self.imageView];
    }
    return self;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView               = [UIImageView new];
        _imageView.frame         = CGRectMake(0, 0, GKScreenW, GKScreenH);
        _imageView.clipsToBounds = YES;
    }
    return _imageView;
}

- (GKLoadingView *)loadingView {
    if (!_loadingView) {
        _loadingView = [GKLoadingView loadingViewWithFrame:self.bounds style:GKLoadingStyleIndeterminate];
        _loadingView.lineWidth   = 3;
        _loadingView.radius      = 12;
        _loadingView.bgColor     = [UIColor blackColor];
        _loadingView.strokeColor = [UIColor whiteColor];
    }
    return _loadingView;
}

- (void)setupPhoto:(GKPhoto *)photo {
    
    _photo = photo;
    
    [self loadImageWithPhoto:photo];
}

#pragma mark - 加载图片
- (void)loadImageWithPhoto:(GKPhoto *)photo {
    // 取消以前的加载
    
    if (photo) {
        
        //        // 已经加载成功，无需再加载
        //        if (photo.image) {
        //            [self.loadingView stopLoading];
        //
        //            self.imageView.image = photo.image;
        //
        //            [self adjustFrame];
        //
        //            return;
        //        }
        
        // 显示原来的图片
        self.imageView.image          = photo.placeholderImage;
        self.imageView.contentMode    = UIViewContentModeScaleAspectFit;
        // 进度条
        [self addSubview:self.loadingView];
        
        if (!photo.failed) {
            [self.loadingView startLoading];
        }
        
        self.playerItem = [AVPlayerItem playerItemWithURL:photo.url];
        self.player = [AVPlayer playerWithPlayerItem:self.playerItem];
        self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
        self.playerLayer.frame = CGRectMake(0, 0, GKScreenW, GKScreenH);
        [self.imageView.layer addSublayer:self.playerLayer];
        [self.playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.imageView.image = [UIImage imageNamed:@"black.png"];
        });
        
        [self adjustFrame];
        
    }else {
        self.imageView.image = nil;
        
        [self adjustFrame];
    }
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:
(NSDictionary<NSString *,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"status"]) {
        //取出status的新值
        AVPlayerItemStatus status = [change[NSKeyValueChangeNewKey]intValue];
        switch (status) {
            case AVPlayerItemStatusFailed:
                NSLog(@"item 有误");
                break;
            case AVPlayerItemStatusReadyToPlay:
                NSLog(@"准好播放了");
                break;
            case AVPlayerItemStatusUnknown:
                NSLog(@"视频资源出现未知错误");
                break;
            default:
                break;
        }
    }
    //移除监听（观察者）
    [object removeObserver:self forKeyPath:@"status"];
}
- (void)resetFrame {
    self.imageView.frame  = self.bounds;
    self.loadingView.frame = self.bounds;
    
    [self adjustFrame];
}

#pragma mark - 调整frame
- (void)adjustFrame {
    CGRect frame = CGRectMake(0, 0, GKScreenW, GKScreenH);//self.frame;
    
    if (self.imageView.image) {
        CGSize imageSize = self.imageView.image.size;
        CGRect imageF = (CGRect){{0, 0}, imageSize};
        
        // 图片的宽度 = 屏幕的宽度
        CGFloat ratio = frame.size.width / imageF.size.width;
        imageF.size.width  = frame.size.width;
        imageF.size.height = ratio * imageF.size.height;
        
        // 图片的高度 > 屏幕的高度
        if (imageF.size.height > frame.size.height) {
            CGFloat scale = imageF.size.width / imageF.size.height;
            imageF.size.height = frame.size.height;
            imageF.size.width  = imageF.size.height * scale;
        }
        
        // 设置图片的frame
        self.imageView.frame = imageF;
        
        if (imageF.size.height <= self.bounds.size.height) {
            self.imageView.center = CGPointMake(self.bounds.size.width * 0.5, self.bounds.size.height * 0.5);
        }else {
            self.imageView.center = CGPointMake(self.bounds.size.width * 0.5, imageF.size.height * 0.5);
        }
        
    }else {
        frame.origin     = CGPointZero;
        CGFloat width  = frame.size.width;
        CGFloat height = width * 2.0 / 3.0;
        _imageView.bounds = CGRectMake(0, 0, width, height);
        _imageView.center = CGPointMake(frame.size.width * 0.5, frame.size.height * 0.5);
    }
}

- (void)dealloc {
    NSLog(@"注销");
}



@end
