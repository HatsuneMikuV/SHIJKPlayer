//
//  SHButton.m
//  SHIJKPlayer
//
//  Created by angle on 2017/11/29.
//  Copyright © 2017年 angle. All rights reserved.
//

#import "SHButton.h"

@implementation SHButton

- (instancetype)init {
    if (self = [super init]) {
        
        //双击
        UITapGestureRecognizer *gestureS = [[UITapGestureRecognizer alloc] init];
        gestureS.numberOfTouchesRequired = 1;
        gestureS.numberOfTapsRequired = 2;
        [gestureS addTarget:self action:@selector(tapGestS)];
        [self addGestureRecognizer:gestureS];
        //点击
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] init];
        gesture.numberOfTouchesRequired = 1;
        gesture.numberOfTapsRequired = 1;
        [gesture addTarget:self action:@selector(tapGest)];
        [self addGestureRecognizer:gesture];
        
        [gesture requireGestureRecognizerToFail:gestureS];
        
    }
    return self;
}
//点击
- (void)tapGest {
    if ([self.touchDelegate respondsToSelector:@selector(touchesTapCountOne)]) {
        [self.touchDelegate touchesTapCountOne];
    }
}
//双击
- (void)tapGestS {
    if ([self.touchDelegate respondsToSelector:@selector(touchesTapCountTwo)]) {
        [self.touchDelegate touchesTapCountTwo];
    }
}
//触摸开始
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    //获取触摸开始的坐标
    UITouch *touch = [touches anyObject];
    CGPoint currentP = [touch locationInView:self];
    [self.touchDelegate touchesBeganWithPoint:currentP];
}

//触摸结束
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    UITouch *touch = [touches anyObject];
    CGPoint currentP = [touch locationInView:self];
    [self.touchDelegate touchesEndWithPoint:currentP];
}
- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesCancelled:touches withEvent:event];
    UITouch *touch = [touches anyObject];
    CGPoint currentP = [touch locationInView:self];
    [self.touchDelegate touchesCancelledWithPoint:currentP];
}
//移动
- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event {
    [super touchesMoved:touches withEvent:event];
    UITouch *touch = [touches anyObject];
    CGPoint currentP = [touch locationInView:self];
    [self.touchDelegate touchesMoveWithPoint:currentP];
}

@end
