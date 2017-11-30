//
//  SHIJKPlayer.h
//  SHIJKPlayer
//
//  Created by angle on 2017/11/29.
//  Copyright © 2017年 angle. All rights reserved.
//

#import <UIKit/UIKit.h>


@class SHIJKPlayerView;

@protocol SHIJKPlayerViewDelegate <NSObject>
//手动切换横竖屏
- (void)fullScreen:(SHIJKPlayerView *)SHIJKPlayerView fullScreen:(BOOL)isFull;
//自动切换
- (void)fullScreen:(SHIJKPlayerView *)SHIJKPlayerView notificationFullScreen:(BOOL)isFull;
//视频不能播放时回调控制器
- (void)noVideoUrlBackController;

@end


@interface SHIJKPlayerView : UIView

/**
 视频占位图url
 */
@property (nonatomic, copy) NSString *imageUrl;

/**
 视频标题
 */
@property (nonatomic, copy) NSString *title;

/**
 视频播放地址
 */
@property (nonatomic, copy) NSString *playUrl;

/**
 重置播放地址
 重新播放
 */
- (void)reSetPlayUrl:(NSString *)playUrl;


/**
 播放事件代理
 */
@property (nonatomic, weak) id<SHIJKPlayerViewDelegate>delegate;

/**
 初始化播放器
 */
+ (SHIJKPlayerView *)SHIJKPlayerViewwWithFrame:(CGRect)frame playUrl:(NSString *)playUrl;

@end
