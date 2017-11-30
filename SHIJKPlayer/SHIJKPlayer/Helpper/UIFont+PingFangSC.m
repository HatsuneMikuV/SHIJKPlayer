//
//  UIFont+PingFangSC.m
//  GuluGulu
//
//  Created by angle on 2017/8/28.
//  Copyright © 2017年 morningtec. All rights reserved.
//

#import "UIFont+PingFangSC.h"

@implementation UIFont (PingFangSC)

+ (UIFont *)pingFangSCFontOfSize:(CGFloat)fontSize {
    if ([UIDevice currentDevice].systemVersion.floatValue > 9.0) {
        return [UIFont fontWithName:@".PingFangSC-Regular" size:fontSize];
    }
    return [UIFont systemFontOfSize:fontSize];
}

+ (UIFont *)boldPingFangSCFontOfSize:(CGFloat)fontSize {
    if ([UIDevice currentDevice].systemVersion.floatValue > 9.0) {
        return [UIFont fontWithName:@".PingFangSC-Medium" size:fontSize];
    }
    return [UIFont boldSystemFontOfSize:fontSize];
}

+ (UIFont *)semiboldPingFangSCFontOfSize:(CGFloat)fontSize {
    if ([UIDevice currentDevice].systemVersion.floatValue > 9.0) {
        return [UIFont fontWithName:@".PingFangSC-Semibold" size:fontSize];
    }
    return [UIFont boldSystemFontOfSize:fontSize];
}


@end
