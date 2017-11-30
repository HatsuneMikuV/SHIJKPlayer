//
//  SHLabel.m
//  SHIJKPlayer
//
//  Created by angle on 2017/11/29.
//  Copyright © 2017年 angle. All rights reserved.
//

#import "SHLabel.h"



@interface SHLabel ()

@property (nonatomic, strong) UILabel *titleL;
@property (nonatomic, strong) UILabel *subTitleL;

@end

@implementation SHLabel

+ (SHLabel *)labelHubView {
    return [[self alloc] initWithFrame:CGRectMake(0, 0, 160, 90)];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.85];
        self.clipsToBounds = YES;
        self.layer.cornerRadius = 5.0;
        
        [self addSubview:self.titleL];
        [self addSubview:self.subTitleL];
        
    }
    return self;
}
#pragma mark -
#pragma mark   ==============title赋值==============
- (void)setVideoRateTime:(NSString *)topStr withDownTitle:(CGFloat)downSec {
    self.titleL.text = [NSString stringWithFormat:@"%@",topStr];
    
    if (downSec < 0) {
        self.subTitleL.text = [NSString stringWithFormat:@"%.f秒",downSec];
    }else {
        self.subTitleL.text = [NSString stringWithFormat:@"+%.f秒",downSec];
    }
    
}
#pragma mark -
#pragma mark   ==============layoutSubviews==============
- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.titleL mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.and.top.equalTo(self).offset(20);
        make.right.equalTo(self.mas_right).offset(-20);
    }];
    
    [self.subTitleL mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(20);
        make.right.and.bottom.equalTo(self).offset(-20);
    }];
    
}
#pragma mark -
#pragma mark   ==============控件初始化==============
- (UILabel *)titleL {
    if (!_titleL) {
        _titleL = [[UILabel alloc] init];
        _titleL.text = @"00:00/00:00";
        _titleL.textAlignment = NSTextAlignmentCenter;
        _titleL.font = [UIFont systemFontOfSize:14];
        _titleL.textColor = [UIColor whiteColor];
    }
    return _titleL;
}
- (UILabel *)subTitleL {
    if (!_subTitleL) {
        _subTitleL = [[UILabel alloc] init];
        _subTitleL.text = @"+0秒";
        _subTitleL.textAlignment = NSTextAlignmentCenter;
        _subTitleL.font = [UIFont systemFontOfSize:14];
        _subTitleL.textColor = [UIColor whiteColor];
    }
    return _subTitleL;
}
@end

