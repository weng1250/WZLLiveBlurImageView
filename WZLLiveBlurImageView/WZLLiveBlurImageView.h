//
//  WZLLiveBlurImageView.h
//  WZLLiveBlurImageView
//
//  Created by zilin_weng on 15/3/23.
//  Copyright (c) 2015年 Weng-Zilin. All rights reserved.
//

#import <UIKit/UIKit.h>

//default initial blur level
#define kImageBlurLevelDefault          0.9f

//switch to direct method or undirect one, defined in my blog:
//http://i.cnblogs.com/EditPosts.aspx?postid=4362100
#define kDirectMethod                   0

@interface WZLLiveBlurImageView : UIImageView

/**
 *  set blur level
 *
 *  @param level blur level
 */
- (void)setBlurLevel:(CGFloat)level;

@end
