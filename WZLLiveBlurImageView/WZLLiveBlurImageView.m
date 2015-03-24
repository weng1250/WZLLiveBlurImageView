//
//  WZLLiveBlurImageView.m
//  WZLLiveBlurImageView
//
//  Created by zilin_weng on 15/3/23.
//  Copyright (c) 2015年 Weng-Zilin. All rights reserved.
//

#import "WZLLiveBlurImageView.h"
#import "UIImage+Blur.h"

@interface WZLLiveBlurImageView ()

@property (nonatomic, strong) UIImage *originImage;
@property (nonatomic, strong) UIImageView *realBlurImageView;

@end

@implementation WZLLiveBlurImageView

/**
 *  set blur level
 *
 *  @param level blur level
 */
- (void)setBlurLevel:(CGFloat)level
{
    if (!self.image || !self.realBlurImageView) {
        NSLog(@"image is empty!");
        return;
    }
    level = (level > 1 ? 1 : (level < 0 ? 0 : level));
    NSLog(@"level:%@", @(level));
#if !kDirectMethod
    self.realBlurImageView.alpha = level;
#else
    @autoreleasepool {
        if (_originImage) {
            __weak typeof(WZLLiveBlurImageView*) weakSelf = self;
            __block UIImage *blurImage = nil;
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                blurImage = [weakSelf.originImage applyBlurWithRadius:level];
                //get back to main thread to update UI
                dispatch_async(dispatch_get_main_queue(), ^{
                    weakSelf.image = blurImage;
                });
            });
        }
    }
#endif
}

#pragma mark - private apis

- (void)setImage:(UIImage *)image
{
    [super setImage:image];
    if (_originImage == nil && image) {
        _originImage = image;
    }
#if !kDirectMethod
    if (!self.realBlurImageView) {
        UIImage *blurImage = [image applyBlurWithRadius:kImageBlurLevelDefault];
        self.realBlurImageView = [[UIImageView alloc] initWithImage:blurImage];
        self.realBlurImageView.backgroundColor = [UIColor clearColor];
        self.realBlurImageView.frame = self.bounds;
        self.realBlurImageView.alpha = 0;
        [self addSubview:self.realBlurImageView];
    }
#endif
}

//update realBlurImageView`s frame
- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    if (self.realBlurImageView) {
        self.realBlurImageView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
    }
}

@end
