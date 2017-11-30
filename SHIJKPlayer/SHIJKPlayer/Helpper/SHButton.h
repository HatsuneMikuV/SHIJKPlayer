//
//  SHButton.h
//  SHIJKPlayer
//
//  Created by angle on 2017/11/29.
//  Copyright © 2017年 angle. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol SHButtonDelegate <NSObject>

/**
 * 开始触摸
 */
- (void)touchesBeganWithPoint:(CGPoint)point;

/**
 * 结束触摸
 */
- (void)touchesEndWithPoint:(CGPoint)point;

/**
 * 取消触摸
 */
- (void)touchesCancelledWithPoint:(CGPoint)point;

/**
 * 移动手指
 */
- (void)touchesMoveWithPoint:(CGPoint)point;

/**
 * 点击
 */
- (void)touchesTapCountOne;

/**
 * 双击
 */
- (void)touchesTapCountTwo;

@end

@interface SHButton : UIButton <UIGestureRecognizerDelegate>
/**
 * 传递点击事件的代理
 */
@property (weak, nonatomic) id <SHButtonDelegate> touchDelegate;

@end



