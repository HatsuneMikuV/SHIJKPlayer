//
//  SHLabel.h
//  SHIJKPlayer
//
//  Created by angle on 2017/11/29.
//  Copyright © 2017年 angle. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SHLabel : UIView

- (void)setVideoRateTime:(NSString *)topStr withDownTitle:(CGFloat)downSec;

+ (SHLabel *)labelHubView;

@end
