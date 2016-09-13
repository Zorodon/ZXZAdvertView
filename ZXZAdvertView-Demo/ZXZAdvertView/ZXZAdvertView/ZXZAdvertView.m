//
//  ZXZAdvertView.m
//  BeiLu
//
//  Created by YKJ2 on 16/6/22.
//  Copyright © 2016年 YKJ1. All rights reserved.
//

#import "ZXZAdvertView.h"
#import "ZXZPageControl.h"
#import "UIImageView+WebCache.h"

@interface ZXZAdvertView()<UIScrollViewDelegate>
@property (strong, nonatomic) UIScrollView *adScrollView;
@property (strong, nonatomic) ZXZPageControl *pageControl;
@property (strong, nonatomic) UIImageView *leftImageView;
@property (strong, nonatomic) UIImageView *centerImageView;
@property (strong, nonatomic) UIImageView *rightImageView;
@property (strong, nonatomic) UIActivityIndicatorView *activityIndicator;

@property (strong, nonatomic) NSTimer *timer;
@property (strong, nonatomic) NSArray *imagesArr;
@property (assign, nonatomic) NSInteger currentImageIndex;
@property (assign, nonatomic) NSInteger imagesCount;
@property (assign, nonatomic) CGFloat viewWidth;
@property (assign, nonatomic) CGFloat viewHeight;

@end
@implementation ZXZAdvertView
//初始化界面
- (instancetype)initWithFrame:(CGRect )rect images:(NSArray *)images {
    self = [super initWithFrame:rect];
    if (self) {
        self.imagesArr = [NSArray arrayWithArray:images];
        self.imagesCount = images.count;
        self.viewHeight = self.bounds.size.height;
        self.viewWidth = self.bounds.size.width;
      
        if (self.imagesCount > 1){
            [self addSubview:self.adScrollView];
            [self addImageViews:images];
            [self addSubview:self.pageControl];
            [self addAdTimer];
            [self addSubview:self.activityIndicator];
        }else if(self.imagesCount == 1){
            [self addImageViews:images];
            [self addSubview:self.activityIndicator];
        }
    }
    return self;
}

- (UIScrollView *)adScrollView {
    if (!_adScrollView) {
        _adScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.viewWidth, self.viewHeight)];
        _adScrollView.bounces = YES;
        _adScrollView.pagingEnabled = YES;
        _adScrollView.delegate = self;
        _adScrollView.showsHorizontalScrollIndicator = NO;
        _adScrollView.showsVerticalScrollIndicator = NO;
        _adScrollView.contentSize = CGSizeMake(3*_viewWidth, _viewHeight);
        [_adScrollView setContentOffset:CGPointMake(_viewWidth, 0)];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
        [_adScrollView addGestureRecognizer:tap];
        
    }
    return _adScrollView;
}

- (UIPageControl *)pageControl {
    if (!_pageControl) {
        _pageControl = [[ZXZPageControl alloc] initWithFrame:CGRectMake(_viewWidth/2,_viewHeight-25, 0, 10)];
        [_pageControl setCurrentPageIndicatorTintColor:[UIColor whiteColor]];
        [_pageControl setPageIndicatorTintColor:[UIColor lightGrayColor]];
        _pageControl.numberOfPages = _imagesCount;
        _pageControl.currentPage = 0;
    }
    return _pageControl;
}

- (UIActivityIndicatorView *)activityIndicator {
    if (!_activityIndicator) {
        self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        self.activityIndicator.center = CGPointMake(self.viewWidth/2, self.viewHeight/2);
        self.activityIndicator.hidden = YES;
    }
    return _activityIndicator;
}
//left-center-right循环滚动,切换图片内容
- (void)addImageViews:(NSArray *)images {
    if (self.imagesCount > 1){
        self.leftImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.viewWidth, self.viewHeight)];
        self.leftImageView.contentMode=UIViewContentModeScaleAspectFit;
        if (![self isHttpImage:[images lastObject]]) {
            self.leftImageView.image = [UIImage imageNamed:[images lastObject]];
        }else{
            [self.leftImageView sd_setImageWithURL:[NSURL URLWithString:[images lastObject]] placeholderImage:nil options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                self.activityIndicator.hidden = NO;
                [self.activityIndicator startAnimating];
            } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                self.activityIndicator.hidden = YES;
                if (error) {
                    self.leftImageView.image = [UIImage imageNamed:@"photofail"];
                }
                
            }];
        }
        [self.adScrollView addSubview:self.leftImageView];
        
        self.centerImageView=[[UIImageView alloc]initWithFrame:CGRectMake(self.viewWidth, 0, self.viewWidth, self.viewHeight)];
        self.centerImageView.contentMode=UIViewContentModeScaleAspectFit;
        if (![self isHttpImage:images[0]]) {
            self.centerImageView.image = [UIImage imageNamed:images[0]];
        }else{
            [self.centerImageView sd_setImageWithURL:[NSURL URLWithString:images[0]] placeholderImage:nil options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                self.activityIndicator.hidden = NO;
                [self.activityIndicator startAnimating];
            } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                self.activityIndicator.hidden = YES;
                if (error) {
                    self.centerImageView.image = [UIImage imageNamed:@"photofail"];
                }
            }];
        }
        [self.adScrollView addSubview:self.centerImageView];
        
        self.rightImageView=[[UIImageView alloc]initWithFrame:CGRectMake(2*self.viewWidth, 0, self.viewWidth, self.viewHeight)];
        self.rightImageView.contentMode=UIViewContentModeScaleAspectFit;
        if (![self isHttpImage:images[1]]) {
                self.rightImageView.image = [UIImage imageNamed:images[1]];
        }else{
            [self.rightImageView sd_setImageWithURL:[NSURL URLWithString:images[1]] placeholderImage:nil options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                self.activityIndicator.hidden = NO;
                [self.activityIndicator startAnimating];
            } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                self.activityIndicator.hidden = YES;
                if (error) {
                    self.rightImageView.image = [UIImage imageNamed:@"photofail"];
                }
            }];
        }
        [self.adScrollView addSubview:self.rightImageView];
        
    }else {
        
        self.centerImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.viewWidth, self.viewHeight)];
        self.centerImageView.contentMode=UIViewContentModeScaleAspectFit;
        if (![self isHttpImage:images[0]]) {
            self.centerImageView.image = [UIImage imageNamed:images[0]];
        }else{
            [self.centerImageView sd_setImageWithURL:[NSURL URLWithString:images[0]] placeholderImage:nil options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                self.activityIndicator.hidden = NO;
                [self.activityIndicator startAnimating];
            } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                self.activityIndicator.hidden = YES;
                if (error) {
                    self.centerImageView.image = [UIImage imageNamed:@"photofail"];
                }
            }];
        }
        [self addSubview:self.centerImageView];
    }
}
//添加定时器，循环播放
- (void)addAdTimer {
    if (self.timer == nil) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(runTimePage) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop]addTimer:self.timer forMode:NSRunLoopCommonModes];
    }
}

- (void)removeAdTimer {
    [self.timer invalidate];
    self.timer =nil;
}

- (void)runTimePage {
    self.currentImageIndex = (self.currentImageIndex+1)%self.imagesCount;
    if (![self isHttpImage:self.imagesArr[self.currentImageIndex]]) {
        self.centerImageView.image = [UIImage imageNamed:self.imagesArr[self.currentImageIndex]];
    }else{
        [self.centerImageView sd_setImageWithURL:[NSURL URLWithString:self.imagesArr[self.currentImageIndex]] placeholderImage:nil options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            self.activityIndicator.hidden = NO;
            [self.activityIndicator startAnimating];
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            self.activityIndicator.hidden = YES;
            if (error) {
                self.centerImageView.image = [UIImage imageNamed:@"photofail"];
            }
        }];
    }
    
    NSInteger leftImageIndex,rightImageIndex;
    leftImageIndex=(self.currentImageIndex+self.imagesCount-1)%self.imagesCount;
    rightImageIndex=(self.currentImageIndex+1)%self.imagesCount;
    
    if (![self isHttpImage:self.imagesArr[leftImageIndex]]) {
        self.leftImageView.image=[UIImage imageNamed:self.imagesArr[leftImageIndex]];
    }else{
        [self.leftImageView sd_setImageWithURL:[NSURL URLWithString:self.imagesArr[leftImageIndex]] placeholderImage:nil options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            self.activityIndicator.hidden = NO;
            [self.activityIndicator startAnimating];
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            self.activityIndicator.hidden = YES;
            if (error) {
                self.leftImageView.image = [UIImage imageNamed:@"photofail"];
            }
        }];
    }

    if (![self isHttpImage:self.imagesArr[rightImageIndex]]) {
        self.rightImageView.image=[UIImage imageNamed:self.imagesArr[rightImageIndex]];
    }else{
        [self.rightImageView sd_setImageWithURL:[NSURL URLWithString:self.imagesArr[rightImageIndex]] placeholderImage:nil options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            self.activityIndicator.hidden = NO;
            [self.activityIndicator startAnimating];
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            self.activityIndicator.hidden = YES;
            if (error) {
                self.rightImageView.image = [UIImage imageNamed:@"photofail"];
            }
        }];
    }
    
    [self.adScrollView setContentOffset:CGPointMake(self.viewWidth, 0)];
    self.pageControl.currentPage = self.currentImageIndex;
}

#pragma mark - UIScrollViewDelegate
//滚动时切换图片，关掉定时器
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGPoint offset = scrollView.contentOffset;
    if (offset.x>self.viewWidth) {
        self.currentImageIndex = (self.currentImageIndex+1)%self.imagesCount;
    }else if(offset.x<self.viewWidth){
        self.currentImageIndex = (self.currentImageIndex+self.imagesCount-1)%self.imagesCount;
    }

    if (![self isHttpImage:self.imagesArr[self.currentImageIndex]]) {
        self.centerImageView.image = [UIImage imageNamed:self.imagesArr[self.currentImageIndex]];
    }else{
        [self.centerImageView sd_setImageWithURL:[NSURL URLWithString:self.imagesArr[self.currentImageIndex]] placeholderImage:nil options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            self.activityIndicator.hidden = NO;
            [self.activityIndicator startAnimating];
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            self.activityIndicator.hidden = YES;
            if (error) {
                self.centerImageView.image = [UIImage imageNamed:@"photofail"];
            }
        }];
    }
    
    //重新设置左右图片
    NSInteger leftImageIndex,rightImageIndex;
    leftImageIndex=(self.currentImageIndex+self.imagesCount-1)%self.imagesCount;
    rightImageIndex=(self.currentImageIndex+1)%self.imagesCount;
    
    if (![self isHttpImage:self.imagesArr[leftImageIndex]]) {
        self.leftImageView.image=[UIImage imageNamed:self.imagesArr[leftImageIndex]];
    }else{
        [self.leftImageView sd_setImageWithURL:[NSURL URLWithString:self.imagesArr[leftImageIndex]] placeholderImage:nil options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            self.activityIndicator.hidden = NO;
            [self.activityIndicator startAnimating];
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            self.activityIndicator.hidden = YES;
            if (error) {
                self.leftImageView.image = [UIImage imageNamed:@"photofail"];
            }
        }];
    }

    if (![self isHttpImage:self.imagesArr[rightImageIndex]]) {
        self.rightImageView.image=[UIImage imageNamed:self.imagesArr[rightImageIndex]];
    }else{
        [self.rightImageView sd_setImageWithURL:[NSURL URLWithString:self.imagesArr[rightImageIndex]] placeholderImage:nil options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            self.activityIndicator.hidden = NO;
            [self.activityIndicator startAnimating];
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            self.activityIndicator.hidden = YES;
            if (error) {
                self.rightImageView.image = [UIImage imageNamed:@"photofail"];
            }
        }];
    }
    
    [self.adScrollView setContentOffset:CGPointMake(self.viewWidth, 0)];
    self.pageControl.currentPage = self.currentImageIndex;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self removeAdTimer];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self addAdTimer];
}
//判断是不是网络图片
- (BOOL)isHttpImage:(NSString *)string{
    if ([[string lowercaseString] hasPrefix:@"http://"]||[[string lowercaseString] hasPrefix:@"https://"]) {
        return YES;
    }else{
        return NO;
    }
}
//点击事件
- (void)tapAction {
    if (self.clickBlock) {
        self.clickBlock(self.currentImageIndex);
    }
}

@end
