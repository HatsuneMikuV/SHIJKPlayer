//
//  SHIJKPlayer.m
//  SHIJKPlayer
//
//  Created by angle on 2017/11/29.
//  Copyright © 2017年 angle. All rights reserved.
//

#import "SHIJKPlayerView.h"

#import "SHVideoInfoModel.h"

#import "SHButton.h"
#import "SHLabel.h"

typedef NS_ENUM(NSUInteger, Direction) {
    DirectionLeftOrRight,
    DirectionUpOrDown,
    DirectionNone
};

@interface SHIJKPlayerView ()<SHButtonDelegate,UITableViewDelegate,UITableViewDataSource>
{
    BOOL _isMediaSliderBeingDragged;
}

@property(atomic, retain) id<IJKMediaPlayback> player;

#pragma mark -
#pragma mark   ==============UI==============
@property (nonatomic, strong) UIImageView *backImageView;
@property (nonatomic, strong) UIImageView *backImageColor;

@property (nonatomic, strong) SHButton *tapBtn;

@property (nonatomic, strong) UIButton *playBtn;

@property (nonatomic, strong) UIImageView *functionBackV;
@property (nonatomic, strong) UIButton *leftPlayBtn;
@property (nonatomic, strong) UILabel *leftTimeL;
@property (nonatomic, strong) UIProgressView *cacheProgressView;
@property (nonatomic, strong) UISlider *progressSlider;
@property (nonatomic, strong) UILabel *rightTimeL;
@property (nonatomic, strong) UIButton *fullBtn;

@property (nonatomic, strong) UIImageView *navView;
@property (nonatomic, strong) UIButton *backBtn;
@property (nonatomic, strong) UILabel *titleL;
@property (nonatomic, strong) UIButton *clarityBtn;
@property (nonatomic, strong) UILabel *logoL;

@property (nonatomic, strong) UIButton *lockBtn;

#pragma mark -
#pragma mark   ==============清晰度==============
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UILabel *noticeL;

#pragma mark -
#pragma mark   ==============滑动处理==============
@property (nonatomic, assign) CGPoint startPoint;
@property (assign, nonatomic) CGFloat startVB;
@property (strong, nonatomic) MPVolumeView *volumeView;//控制音量的view
@property (strong, nonatomic) UISlider *volumeViewSlider;//控制音量
@property (assign, nonatomic) Direction direction;
@property (assign, nonatomic) CGFloat startVideoRate;
@property (assign, nonatomic) CGFloat currentRate;//当期视频播放的进度
@property (nonatomic, strong) SHLabel *hubTimeL;

@property (nonatomic, copy) dispatch_block_t task;

@property (nonatomic, strong) NSMutableArray *dataArr;


@end


@implementation SHIJKPlayerView

#pragma mark -
#pragma mark   ==============销毁==============
- (void)dealloc {
    [self stopVideo];
}
#pragma mark -
#pragma mark   ==============初始化==============
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initSubviews];
        [self initLayout];
        [self initConfig];
    }
    return self;
}
- (void)initSubviews {
    
    self.autoresizesSubviews = YES;
    //----
    [self addSubview:self.backImageView];
    [self addSubview:self.backImageColor];
    [self addSubview:self.tapBtn];
    [self addSubview:self.playBtn];
    [self addSubview:self.lockBtn];
    //功能操作
    [self addSubview:self.functionBackV];
    [self addSubview:self.leftPlayBtn];
    [self addSubview:self.leftTimeL];
    [self addSubview:self.cacheProgressView];
    [self addSubview:self.progressSlider];
    [self addSubview:self.rightTimeL];
    [self addSubview:self.fullBtn];
    //清晰度提示
    [self addSubview:self.noticeL];
    //横屏导航栏
    [self addSubview:self.navView];
    [self addSubview:self.backBtn];
    [self addSubview:self.titleL];
    [self addSubview:self.clarityBtn];
    [self addSubview:self.logoL];
    //清晰度选择
    [self addSubview:self.tableView];
    //视频进度显示
    [self addSubview:self.hubTimeL];
}
- (void)initLayout {
    [self.backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    [self.backImageColor mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    [self.tapBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    [self.playBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    [self.lockBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.left.equalTo(self.mas_left).offset(10);
    }];
    [self.functionBackV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.and.bottom.equalTo(self);
        make.height.mas_equalTo(60);
    }];
    [self.leftPlayBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(16);
        make.bottom.equalTo(self.mas_bottom).offset(-10);
    }];
    [self.leftTimeL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.leftPlayBtn.mas_centerY);
        make.left.equalTo(self.leftPlayBtn.mas_right).offset(10);
    }];
    [self.cacheProgressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.leftTimeL.mas_right).offset(10);
        make.right.equalTo(self.rightTimeL.mas_left).offset(-10);
        make.centerY.equalTo(self.leftPlayBtn.mas_centerY);
        make.height.mas_equalTo(2);
    }];
    [self.progressSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.cacheProgressView.mas_left);
        make.right.equalTo(self.cacheProgressView.mas_right);
        make.centerY.equalTo(self.cacheProgressView.mas_centerY).offset(-1);
    }];
    [self.rightTimeL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.fullBtn.mas_left).offset(-10);
        make.centerY.equalTo(self.leftPlayBtn.mas_centerY);
    }];
    [self.fullBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-16);
        make.centerY.equalTo(self.leftPlayBtn.mas_centerY);
    }];
    [self.noticeL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.leftPlayBtn.mas_top).offset(-10);
        make.left.equalTo(self.mas_left).offset(16);
    }];
    [self.navView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.top.and.right.equalTo(self);
        make.height.mas_equalTo(60);
    }];
    [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.navView.mas_centerY).offset(-8);
        make.left.equalTo(self.mas_left);
        make.size.mas_equalTo(CGSizeMake(44, 44));
    }];
    [self.titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.backBtn.mas_centerY);
        make.left.equalTo(self.backBtn.mas_right);
        make.right.equalTo(self.clarityBtn.mas_left).offset(-10);
    }];
    [self.clarityBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.logoL.mas_left).offset(-10);
        make.centerY.equalTo(self.backBtn.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(50, 20));
    }];
    [self.logoL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-10);
        make.centerY.equalTo(self.backBtn.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(96, 18));
    }];
    [self.hubTimeL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.and.centerY.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(150, 85));
    }];
    
    self.volumeView.frame = CGRectMake(0, 0, self.width, self.height);
    
    [self hideNavView:YES];
}
- (void)initConfig {
    
    self.playUrl = nil;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeRotate:) name:UIApplicationDidChangeStatusBarFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationCenterShutDown) name:@"IJKPlayer" object:nil];
}
+ (SHIJKPlayerView *)SHIJKPlayerViewwWithFrame:(CGRect)frame playUrl:(NSString *)playUrl {
    return [[self alloc] initWithFrame:frame playUrl:playUrl];
}
- (instancetype)initWithFrame:(CGRect)frame playUrl:playUrl {
    if (self = [self initWithFrame:frame]) {

    }
    return self;
}
#pragma mark -
#pragma mark   ==============隐藏处理==============
//功能点击--隐藏和显示
- (void)funcationTapShow {
    if (self.task) {
        dispatch_block_cancel(self.task);
        self.task = nil;
    }
    __weak __typeof(&*self)weakSelf = self;
    [self hideFuncation:NO];
    [self hideNavView:NO];
    self.task = dispatch_block_create(DISPATCH_BLOCK_BARRIER, ^{
        [weakSelf hideFuncation:YES];
        [weakSelf hideNavView:YES];
    });
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), self.task);
}
//触摸--隐藏和显示
- (void)subViewsHide {
    if (!self.tableView.hidden) {
        [UIView animateWithDuration:0.25f animations:^{
            self.tableView.frame = CGRectMake(self.clarityBtn.centerX - 50, 52, 100, 0);
        } completion:^(BOOL finished) {
            self.tableView.hidden = YES;
        }];
    }
    if (self.task) {
        dispatch_block_cancel(self.task);
        self.task = nil;
    }
    __weak __typeof(&*self)weakSelf = self;
    if (self.lockBtn.selected) {
        if (self.lockBtn.hidden) {
            self.lockBtn.hidden = NO;
            self.task = dispatch_block_create(DISPATCH_BLOCK_BARRIER, ^{
                weakSelf.lockBtn.hidden = YES;
            });
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), self.task);
        }else {
            self.lockBtn.hidden = YES;
        }
    }else {
        if (self.leftPlayBtn.hidden) {
            [self hideFuncation:NO];
            [self hideNavView:NO];
            self.task = dispatch_block_create(DISPATCH_BLOCK_BARRIER, ^{
                [weakSelf hideFuncation:YES];
                [weakSelf hideNavView:YES];
            });
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), self.task);
        }else {
            [self hideFuncation:YES];
            [self hideNavView:YES];
        }
    }
}
//立即隐藏or显示功能键
- (void)hideFuncation:(BOOL)hide {
    if (hide) {
        self.navView.hidden = YES;
        self.leftPlayBtn.hidden = YES;
        self.leftTimeL.hidden = YES;
        self.cacheProgressView.hidden = YES;
        self.progressSlider.hidden = YES;
        self.rightTimeL.hidden = YES;
        self.fullBtn.hidden = YES;
        self.functionBackV.hidden = YES;
    }else {
        self.navView.hidden = NO;
        self.leftPlayBtn.hidden = NO;
        self.leftTimeL.hidden = NO;
        self.cacheProgressView.hidden = NO;
        self.progressSlider.hidden = NO;
        self.rightTimeL.hidden = NO;
        self.fullBtn.hidden = NO;
        self.functionBackV.hidden = NO;
    }
}
//立即隐藏or显示伪导航栏
- (void)hideNavView:(BOOL)hide {
    if (hide) {
        self.backBtn.hidden = YES;
        self.titleL.hidden = YES;
        self.clarityBtn.hidden = YES;
        self.logoL.hidden = YES;
        self.lockBtn.hidden = YES;
        if (!self.tableView.hidden) {
            self.tableView.hidden = YES;
            self.tableView.frame = CGRectMake(self.clarityBtn.centerX - 50, 52, 100, 0);
        }
    }else {
        if (self.fullBtn.selected && !self.lockBtn.selected) {
            self.backBtn.hidden = NO;
            self.titleL.hidden = NO;
            self.clarityBtn.hidden = NO;
            self.logoL.hidden = NO;
            self.lockBtn.hidden = NO;
        }
    }
}
#pragma mark -
#pragma mark   ==============stopVideo==============
- (void)stopVideo {
    if (self.player) {
        [self.player stop];
        self.player = nil;
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
#pragma mark -
#pragma mark   ==============pause==============
- (void)pause {
    if (self.player && [self.player isPlaying]) {
        [self.player pause];
        self.leftPlayBtn.selected = NO;
    }
}
#pragma mark -
#pragma mark   =============播放==============
- (void)playClick:(UIButton *)btn {
    [self funcationTapShow];
    if (btn.selected && self.player) {
        self.playBtn.hidden = YES;
        [self.player isPreparedToPlay];
        return;
    }
    if (self.playUrl){
        [self playClick:self.playBtn];
    }else {
//        [self initYKVideo];
    }
}
#pragma mark -
#pragma mark   ==============暂停or播放==============
- (void)leftPlayClick:(UIButton *)btn {
    [self funcationTapShow];
    if (self.player) {
        if (btn.selected) {
            [self.player pause];
        }else {
            [self.player play];
        }
        btn.selected = !btn.selected;
    }
}
#pragma mark -
#pragma mark   ==============全屏切换==============
- (void)fullClick:(UIButton *)btn {
    [self funcationTapShow];
    if (self.player) {
//        if (btn.selected) {
//            if (self.changeInterfaceOrientationBlock) {
//                self.fullBtn.selected = NO;
//                [self.cloudPlayer setFullscreen:NO];
//                [self hideNavView:YES];
//                self.changeInterfaceOrientationBlock(NO);
//            }
//        }else {
//            if (self.changeInterfaceOrientationBlock) {
//                self.fullBtn.selected = YES;
//                [self.cloudPlayer setFullscreen:YES];
//                [self hideNavView:NO];
//                self.changeInterfaceOrientationBlock(YES);
//            }
//        }
    }
}
#pragma mark -
#pragma mark   ==============返回操作==============
- (void)backClick:(UIButton *)btn {
    [self funcationTapShow];
    if (self.player && self.fullBtn.selected) {
        [self fullClick:self.fullBtn];
    }
}
#pragma mark -
#pragma mark   ==============清晰度切换==============
- (void)clarityClick:(UIButton *)btn {
    [self funcationTapShow];
    if (self.tableView.hidden) {
        if (self.tableView.tag == 1000) {
            [UIView animateWithDuration:0.25f animations:^{
                self.tableView.frame = CGRectMake(self.clarityBtn.centerX - 50, 52, 100, self.tableView.contentSize.height);
            } completion:^(BOOL finished) {
                [self.tableView reloadData];
                self.tableView.hidden = NO;
                self.tableView.tag = 1001;
            }];
        }else{
            [self.tableView reloadData];
            self.tableView.hidden = NO;
            [UIView animateWithDuration:0.25f animations:^{
                self.tableView.frame = CGRectMake(self.clarityBtn.centerX - 50, 52, 100, self.tableView.contentSize.height);
            }];
        }
    }else {
        [UIView animateWithDuration:0.25f animations:^{
            self.tableView.frame = CGRectMake(self.clarityBtn.centerX - 50, 52, 100, 0);
        } completion:^(BOOL finished) {
            self.tableView.hidden = YES;
        }];
    }
}
#pragma mark -
#pragma mark   ==============锁屏==============
- (void)lockClick:(UIButton *)btn {
    if (btn.selected) {
        btn.selected = NO;
        [self funcationTapShow];
    }else {
        [self subViewsHide];
        btn.hidden = NO;
        if (self.task) {
            dispatch_block_cancel(self.task);
            self.task = nil;
        }
        self.task = dispatch_block_create(DISPATCH_BLOCK_BARRIER, ^{
            btn.hidden = YES;
        });
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), self.task);
        btn.selected = YES;
    }
}
#pragma mark -
#pragma mark   ==============清晰度切换==============
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellT" forIndexPath:indexPath];
    cell.textLabel.text = self.dataArr[indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:16];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    if (self.indexPath == indexPath) {
//        cell.textLabel.textColor = [UIColor colorWithHexString:@"#60cd4c"];
//    }else {
//        cell.textLabel.textColor = [UIColor colorWithHexString:@"#999999"];
//    }
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    cell.textLabel.textColor = [UIColor colorWithHexString:@"#60cd4c"];
    
    [self definitionClick:self.clarityBtn];
    
    NSString *json = @"1";
    NSString *definition = self.dataArr[indexPath.row];
    
    if ([definition isEqualToString:@"高清"]){
        json = @"2";
    }else if ([definition isEqualToString:@"超清"]){
        json = @"3";
    }else if ([definition isEqualToString:@"1080P"]){
        json = @"4";
    }
    
//    if ([self.definition isEqualToString:json]) {
//        return;
//    }
//    self.definition = json;
    
    [[NSUserDefaults standardUserDefaults] setObject:json forKey:@"definition"];
    
//    self.currentTime = self.player.currentPlaybackTime;
//    self.isFirst = YES;
    [self startStopData:NO];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(refreshMediaControl) object:nil];
    [self removeMovieNotificationObservers];
    [self.player shutdown];
    [self.player.view removeFromSuperview];
    self.player = nil;
    self.playBtn.tag = 30;
}
- (void)definitionClick:(UIButton *)btn {
    btn.selected = !btn.selected;
    if (btn.selected) {
        [self startStopData:NO];
        
        if (self.tableView.tag == 1000) {
            [UIView animateWithDuration:0.2f animations:^{
                self.tableView.frame = CGRectMake(self.width - 107, 52, 100, self.tableView.contentSize.height);
            } completion:^(BOOL finished) {
                self.tableView.hidden = NO;
                self.tableView.tag = 1001;
            }];
        }else{
            self.tableView.hidden = NO;
            [UIView animateWithDuration:0.2f animations:^{
                self.tableView.frame = CGRectMake(self.width - 107, 52, 100, self.tableView.contentSize.height);
            }];
        }
    }else {
        [self startStopData:YES];
        [UIView animateWithDuration:0.2f animations:^{
            self.tableView.frame = CGRectMake(self.width - 107, 52, 100, 0);
        } completion:^(BOOL finished) {
            self.tableView.hidden = YES;
        }];
    }
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (self.clarityBtn.selected) {
        self.clarityBtn.selected = NO;
        [self startStopData:YES];
        self.tableView.hidden = YES;
        self.tableView.frame = CGRectMake(self.width - 107, 52, 100, 0);
    }
}
#pragma mark - 自定义Button的代理***********************************************************
#pragma mark - 开始触摸
/*************************************************************************/
- (void)touchesBeganWithPoint:(CGPoint)point {
    if (!self.playUrl) return;
    if (self.clarityBtn.selected) return;
    //记录首次触摸坐标
    self.startPoint = point;
    //检测用户是触摸屏幕的左边还是右边，以此判断用户是要调节音量还是亮度，左边是亮度，右边是音量
    if (self.startPoint.x <= self.tapBtn.frame.size.width / 2.0) {
        //亮度
        self.startVB = [UIScreen mainScreen].brightness;
    } else {
        //音/量
        self.startVB = self.volumeViewSlider.value;
    }
    //方向置为无
    self.direction = DirectionNone;
    //记录当前视频播放的进度
    self.startVideoRate = self.player.currentPlaybackTime / self.player.duration;
}

#pragma mark - 结束触摸
- (void)touchesEndWithPoint:(CGPoint)point {
    if (!self.playUrl) return;
    if (self.clarityBtn.selected) return;
    self.hubTimeL.hidden = YES;
    if (self.direction == DirectionLeftOrRight) {
        _isMediaSliderBeingDragged = NO;
        self.player.currentPlaybackTime = self.player.duration * self.currentRate;
        if (!self.lockBtn.selected) {
            [self startStopData:NO];
            [self startStopData:YES];
        }
    }
}
#pragma mark - 取消触摸
- (void)touchesCancelledWithPoint:(CGPoint)point {
    if (!self.playUrl) return;
    if (self.clarityBtn.selected) return;
    _isMediaSliderBeingDragged = NO;
    self.hubTimeL.hidden = YES;
}
#pragma mark - 拖动
- (void)touchesMoveWithPoint:(CGPoint)point {
    if (!self.playUrl) return;
    if (self.clarityBtn.selected) return;
    //得出手指在Button上移动的距离
    CGPoint panPoint = CGPointMake(point.x - self.startPoint.x, point.y - self.startPoint.y);
    //分析出用户滑动的方向
    if (self.direction == DirectionNone) {
        if (panPoint.x >= 30 || panPoint.x <= -30) {
            //进度
            self.direction = DirectionLeftOrRight;
        } else if (panPoint.y >= 30 || panPoint.y <= -30) {
            //音量和亮度
            self.direction = DirectionUpOrDown;
        }
    }
    
    if (self.direction == DirectionNone) {
        return;
    } else if (self.direction == DirectionUpOrDown) {
        //音量和亮度
        if (self.startPoint.x <= self.tapBtn.frame.size.width / 2.0) {
            //调节亮度
            if (panPoint.y < 0) {
                //增加亮度
                [[UIScreen mainScreen] setBrightness:self.startVB + (-panPoint.y / 30.0 / 10)];
            } else {
                //减少亮度
                [[UIScreen mainScreen] setBrightness:self.startVB - (panPoint.y / 30.0 / 10)];
            }
            
        } else {
            //音量
            if (panPoint.y < 0) {
                //增大音量
                [self.volumeViewSlider setValue:self.startVB + (-panPoint.y / 30.0 / 10) animated:YES];
                if (self.startVB + (-panPoint.y / 30 / 10) - self.volumeViewSlider.value >= 0.1) {
                    [self.volumeViewSlider setValue:0.1 animated:NO];
                    [self.volumeViewSlider setValue:self.startVB + (-panPoint.y / 30.0 / 10) animated:YES];
                }
                
            } else {
                //减少音量
                [self.volumeViewSlider setValue:self.startVB - (panPoint.y / 30.0 / 10) animated:YES];
            }
        }
    } else if (self.direction == DirectionLeftOrRight ) {
        self.hubTimeL.hidden = NO;
        _isMediaSliderBeingDragged = YES;
        //进度
        CGFloat rate = self.startVideoRate + (panPoint.x / 1500.0);
        if (rate > 1) {
            rate = 1;
        } else if (rate < 0) {
            rate = 0;
        }
        self.currentRate = rate;
        
        self.progressSlider.value = self.player.duration * self.currentRate;
        [self didSliderValueChanged:self.progressSlider];
        if (self.currentRate >= 0 && self.currentRate <= 1) {
            [self.hubTimeL setVideoRateTime:[NSString stringWithFormat:@"%@/%@",self.leftTimeL.text,self.rightTimeL.text] withDownTitle:self.player.duration * (self.currentRate - self.startVideoRate)];
        }
    }
}
#pragma mark - 点击手势
//单击
- (void)touchesTapCountOne {
    if (self.clarityBtn.selected) return;
    if (self.playUrl) {
        if (self.lockBtn.selected) {
            [self startStopData:NO];
            [self startStopData:YES];
        }else {
            [self startStopData:NO];
            [self startStopData:YES];
        }
    }else {
        self.playBtn.hidden = YES;
    }
}
//双击
- (void)touchesTapCountTwo {
    if (self.clarityBtn.selected) return;
    if (self.playUrl) {
        [self startStopData:NO];
        if (self.player.playbackState == IJKMPMoviePlaybackStatePlaying) {
            [self.player pause];
        }else if (self.player.playbackState == IJKMPMoviePlaybackStatePaused) {
            [self.player play];
        }
        [self startStopData:YES];
    }else {
        self.playBtn.hidden = YES;
    }
}
#pragma mark -
#pragma mark   ==============定时器（开/关）==============
- (void)startStopData:(BOOL)isStart {
//    if (isStart) {
//        self.count = 0;
//        //获得队列
//        dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
//        //创建一个定时器
//        self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
//        //设置开始时间
//        dispatch_time_t start = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC));
//        //设置时间间隔
//        uint64_t interval = (uint64_t)(1.0* NSEC_PER_SEC);
//        //设置定时器
//        dispatch_source_set_timer(self.timer, start, interval, 0);
//        //设置回调
//        dispatch_source_set_event_handler(self.timer, ^{
//            //在这里执行事件
//            self.count += 1.0;
//            if (self.count == 5.0) {
//                self.count = 0;
//                dispatch_async(dispatch_get_main_queue(), ^(){
//                    // 这里的代码会在主线程执行
//                    if ([self.player isPlaying]) {
//                        [self hiddenSubviews:YES];
//                        [self hiddenLockBtn:YES];
//                    }
//                });
//                [self startStopData:NO];
//            }
//        });
//        //由于定时器默认是暂停的所以我们启动一下
//        //启动定时器
//        dispatch_resume(self.timer);
//    }else {
//        if (self.timer) {
//            dispatch_cancel(self.timer);
//            self.timer = nil;
//            self.count = 0;
//        }
//    }
}
#pragma mark -
#pragma mark   ==============更换播放内容==============
//- (void)setVideoId:(NSString *)videoID {
//
//    if (self.videoID) {
//        if ([videoID isEqualToString:self.videoID]) {
//            if (!self.player) {
//                self.playBtn.hidden = YES;
//                [self getPlayUrl];
//            }else {
//                if (![self.player isPlaying]) {
//                    [self.player play];
//                }
//            }
//        }else{
//            [self startStopData:NO];
//            [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(refreshMediaControl) object:nil];
//            [self removeMovieNotificationObservers];
//            [self.player shutdown];
//            [self.player.view removeFromSuperview];
//            self.player = nil;
//            [self hiddenSubviews:YES];
//            self.videoID = videoID;
//            [self getPlayUrl];
//            self.playBtn.tag = 30;
//        }
//    }else {
//        self.videoID = videoID;
//        self.playBtn.hidden = YES;
//        [self getPlayUrl];
//    }
//}
#pragma mark -
#pragma mark   ==============清晰度解析数据==============
//- (void)relodataM_tableView:(GLVideoInfoModel *)infoModel {
//
//    NSMutableArray *array = @[@"",@"",@"",@""].mutableCopy;
//
//    for (NSString *key in infoModel.definitionUrls) {
//        if ([key isEqualToString:@"4"]) {
//            [array replaceObjectAtIndex:3 withObject:@"1080P"];
//        }else if ([key isEqualToString:@"3"]){
//            [array replaceObjectAtIndex:2 withObject:@"超清"];
//        }else if ([key isEqualToString:@"2"]){
//            [array replaceObjectAtIndex:1 withObject:@"高清"];
//        }else if ([key isEqualToString:@"1"]){
//            [array replaceObjectAtIndex:0 withObject:@"流畅"];
//        }
//    }
//
//
//    if (![infoModel.definitionUrls.allKeys containsObject:self.definition]) {
//        self.definition = @"1";
//    }
//
//    for (NSInteger index = 0; index < array.count; index++) {
//        NSString *keyStr = array[index];
//        if ([keyStr isEqualToString:@""]) {
//            [array removeObject:keyStr];
//        }
//    }
//
//
//
//    if (array.count > 1) {
//        self.dataArr = array;
//
//        self.definitionV.hidden = NO;
//        self.definitionL.hidden = NO;
//        self.definitionBtn.hidden = NO;
//
//        self.definitionL.text = array[[self.definition integerValue] - 1];
//
//
//        self.indexPath = [NSIndexPath indexPathForRow:[self.definition integerValue] - 1 inSection:0];
//
//        [self.tableView reloadData];
//
//        [self addSubview:self.tableView];
//
//        [self layoutIfNeeded];
//        [self setNeedsLayout];
//    }
//}
#pragma mark -
#pragma mark   ==============启动播放器==============
- (void)addPlayerView:(NSURL *)videoUrl {
    
#ifdef DEBUG
    [IJKFFMoviePlayerController setLogReport:YES];
    [IJKFFMoviePlayerController setLogLevel:k_IJK_LOG_SILENT];
#else
    [IJKFFMoviePlayerController setLogReport:NO];
    [IJKFFMoviePlayerController setLogLevel:k_IJK_LOG_SILENT];
#endif
    
    [IJKFFMoviePlayerController checkIfFFmpegVersionMatch:NO];
    
    IJKFFOptions *options = [IJKFFOptions optionsByDefault];
    [options setOptionIntValue:1 forKey:@"videotoolbox" ofCategory:kIJKFFOptionCategoryPlayer];
    [options setOptionIntValue:IJK_AVDISCARD_DEFAULT forKey:@"skip_frame" ofCategory:kIJKFFOptionCategoryCodec];
    [options setOptionIntValue:IJK_AVDISCARD_DEFAULT forKey:@"skip_loop_filter" ofCategory:kIJKFFOptionCategoryCodec];
    [options setFormatOptionIntValue:1 forKey:@"auto_convert"];
    
    self.player = [[IJKFFMoviePlayerController alloc] initWithContentURL:videoUrl withOptions:options];
    self.player.view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    self.player.view.frame = self.bounds;
    self.player.scalingMode = IJKMPMovieScalingModeAspectFill;
    self.player.shouldAutoplay = YES;
    
    
    [self insertSubview:self.player.view aboveSubview:self.backImageView];
    [self.player prepareToPlay];
    
    
    [self installMovieNotificationObservers];
    
    [self refreshMediaControl];
    
    [self startStopData:NO];
    [self startStopData:YES];
}
#pragma mark -
#pragma mark   ==============进入后台通知暂停==============
- (void)notificationCenterShutDown {
    if (self.player) {
        [self.player pause];
    }
}
- (BOOL)isHaveVideo {
    if (self.player.view == nil) {
        return NO;
    }
    return YES;
}

#pragma mark -
#pragma mark   ==============设置暂未图==============
- (void)setPlaceholderImage:(NSURL *)imageUrl {
    [self.backImageView sd_setImageWithURL:imageUrl];
}
- (void)setTitle:(NSString *)title {
    self.titleL.text = [NSString stringWithFormat:@"%@",title];
}
#pragma mark Install Movie Notifications
/* Register observers for the various movie object notifications. */
-(void)installMovieNotificationObservers {
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loadStateDidChange:)
                                                 name:IJKMPMoviePlayerLoadStateDidChangeNotification
                                               object:_player];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlayBackDidFinish:)
                                                 name:IJKMPMoviePlayerPlaybackDidFinishNotification
                                               object:_player];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(mediaIsPreparedToPlayDidChange:)
                                                 name:IJKMPMediaPlaybackIsPreparedToPlayDidChangeNotification
                                               object:_player];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlayBackStateDidChange:)
                                                 name:IJKMPMoviePlayerPlaybackStateDidChangeNotification
                                               object:_player];
}
#pragma mark Remove Movie Notification Handlers
/* Remove the movie notification observers from the movie object. */
-(void)removeMovieNotificationObservers {
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:IJKMPMoviePlayerLoadStateDidChangeNotification object:_player];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:IJKMPMoviePlayerPlaybackDidFinishNotification object:_player];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:IJKMPMediaPlaybackIsPreparedToPlayDidChangeNotification object:_player];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:IJKMPMoviePlayerPlaybackStateDidChangeNotification object:_player];
}
#pragma mark IBAction
- (void)loadStateDidChange:(NSNotification*)notification {
    IJKMPMovieLoadState loadState = _player.loadState;
    
    if ((loadState & IJKMPMovieLoadStatePlaythroughOK) != 0) {
        //DLog(@"loadStateDidChange: IJKMPMovieLoadStatePlaythroughOK: %d\n", (int)loadState);
//        if (self.isFirst) {
//            //DLog(@"当前播放进度：%f",self.currentTime);
//            if (self.currentTime > 0.5) {
//                [self.player setCurrentPlaybackTime:self.currentTime];
//            }
//            self.isFirst = NO;
//        }else {
//            [self showStopActivityView:YES];
//            [self.player play];
//        }
    } else if ((loadState & IJKMPMovieLoadStateStalled) != 0) {
        [self.player pause];
        [self showStopActivityView:NO];
        //DLog(@"loadStateDidChange: IJKMPMovieLoadStateStalled: %d\n", (int)loadState);
    } else {
        //DLog(@"loadStateDidChange: ???: %d\n", (int)loadState);
    }
}
- (void)moviePlayBackDidFinish:(NSNotification*)notification {
    int reason = [[[notification userInfo] valueForKey:IJKMPMoviePlayerPlaybackDidFinishReasonUserInfoKey] intValue];
    
    switch (reason)
    {
        case IJKMPMovieFinishReasonPlaybackEnded:
            //DLog(@"playbackStateDidChange: IJKMPMovieFinishReasonPlaybackEnded: %d\n", reason);
            break;
            
        case IJKMPMovieFinishReasonUserExited:
            //DLog(@"playbackStateDidChange: IJKMPMovieFinishReasonUserExited: %d\n", reason);
            break;
            
        case IJKMPMovieFinishReasonPlaybackError:
            //DLog(@"playbackStateDidChange: IJKMPMovieFinishReasonPlaybackError: %d\n", reason);
            break;
            
        default:
            //DLog(@"playbackPlayBackDidFinish: ???: %d\n", reason);
            break;
    }
}

- (void)mediaIsPreparedToPlayDidChange:(NSNotification*)notification
{
    //DLog(@"mediaIsPreparedToPlayDidChange\n");
}

- (void)moviePlayBackStateDidChange:(NSNotification*)notification {
    switch (_player.playbackState)
    {
        case IJKMPMoviePlaybackStateStopped: {
            //DLog(@"IJKMPMoviePlayBackStateDidChange %d: stoped", (int)_player.playbackState);
            [self startStopData:NO];
            break;
        }
        case IJKMPMoviePlaybackStatePlaying: {
            if (self.playBtn.tag == 30) {
                [self startStopData:NO];
                [self startStopData:YES];
                self.playBtn.tag = 33;
            }
            //DLog(@"IJKMPMoviePlayBackStateDidChange %d: playing", (int)_player.playbackState);
            break;
        }
        case IJKMPMoviePlaybackStatePaused: {
            [self startStopData:NO];
            //DLog(@"IJKMPMoviePlayBackStateDidChange %d: paused", (int)_player.playbackState);
            break;
        }
        case IJKMPMoviePlaybackStateInterrupted: {
            //DLog(@"IJKMPMoviePlayBackStateDidChange %d: interrupted", (int)_player.playbackState);
            break;
        }
        case IJKMPMoviePlaybackStateSeekingForward:
        case IJKMPMoviePlaybackStateSeekingBackward: {
            [self.player pause];
            [self showStopActivityView:NO];
            //DLog(@"IJKMPMoviePlayBackStateDidChange %d: seeking", (int)_player.playbackState);
            break;
        }
        default: {
            // DLog(@"IJKMPMoviePlayBackStateDidChange %d: unknown", (int)_player.playbackState);
            break;
        }
    }
}

//卡顿占位动效
//关闭卡顿占位动效
- (void)showStopActivityView:(BOOL)isStop{
//    if (isStop) {
//        if ([self.activity isAnimating]) {
//            [self.activity stopAnimating];
//            self.activity.hidden = YES;
//        }
//    }else {
//        self.activity.hidden = NO;
//        if (![self.activity isAnimating]) {
//            [self.activity startAnimating];
//        }
//    }
}
- (BOOL)getPlayStatePlaying {
    
    return [self.player isPlaying];
}
- (void)shutDown {
    [self startStopData:NO];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(refreshMediaControl) object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"IJKPlayer" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIApplicationDidChangeStatusBarFrameNotification object:nil];
    [self removeMovieNotificationObservers];
    [self.player shutdown];
    [self.player.view removeFromSuperview];
    self.player = nil;
}
#pragma mark -
#pragma mark   ==============初始化时间==============
- (void)refreshMediaControl {
    // duration
    NSInteger intDuration = self.player.duration;
    if (intDuration > 0) {
        self.progressSlider.maximumValue = intDuration;
        self.rightTimeL.text = [NSString stringWithFormat:@"%02d:%02d", (int)(intDuration / 60), (int)(intDuration % 60)];
    } else {
        self.rightTimeL.text = @"00:00";
        self.progressSlider.maximumValue = 1.0f;
    }
    
    //bufferingProgress
    NSTimeInterval playableDuration = self.player.playableDuration;
    [self.cacheProgressView setProgress:playableDuration animated:YES];
    
    // position
    NSTimeInterval position;
    if (_isMediaSliderBeingDragged) {
        position = self.progressSlider.value;
    } else {
        position = self.player.currentPlaybackTime;
    }
    NSTimeInterval intPosition = position;
    if (intDuration > 0) {
        self.progressSlider.value = position;
    } else {
        self.progressSlider.value = 0.0f;
    }
    if (intPosition > intDuration) {
        intPosition = intDuration;
    }
    self.leftTimeL.text = [NSString stringWithFormat:@"%02d:%02d", (int)(((intPosition+0.5) / 60)), ((int)(intPosition +0.5) % 60)];
    
    // status
    BOOL isPlaying = [self.player isPlaying];
    self.playBtn.selected = isPlaying;
    self.leftPlayBtn.selected = isPlaying;
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(refreshMediaControl) object:nil];
    if (!self.playBtn.hidden) {
        [self performSelector:@selector(refreshMediaControl) withObject:nil afterDelay:0.5];
    }
}
#pragma mark -
#pragma mark   ==============监听自动切换横竖屏==============
- (void)changeRotate:(NSNotification*)noti {
    
    if ([[UIDevice currentDevice] orientation] == UIInterfaceOrientationPortrait
        || [[UIDevice currentDevice] orientation] == UIInterfaceOrientationPortraitUpsideDown) {
        //竖屏
        if ([self.delegate respondsToSelector:@selector(fullScreen:notificationFullScreen:)]) {
            self.lockBtn.hidden = YES;
            if (self.clarityBtn.selected) {
                [self definitionClick:self.clarityBtn];
            }
            [self.delegate fullScreen:self notificationFullScreen:NO];
        }
    } else {
        //横屏
        if ([self.delegate respondsToSelector:@selector(fullScreen:notificationFullScreen:)]) {
            self.fullBtn.selected = YES;
            self.lockBtn.hidden = NO;
            self.navView.hidden = NO;
            [self.delegate fullScreen:self notificationFullScreen:YES];
        }
    }
}
- (void)changeScreenFrame:(BOOL)isFull {
    if (isFull) {
        if ([self.delegate respondsToSelector:@selector(fullScreen:fullScreen:)]) {
            self.lockBtn.hidden = NO;
            self.navView.hidden = NO;
            [self.delegate fullScreen:self fullScreen:YES];
        }
    }else {
        if ([self.delegate respondsToSelector:@selector(fullScreen:fullScreen:)]) {
            self.lockBtn.hidden = YES;
            self.navView.hidden = YES;
            if (self.clarityBtn.selected) {
                [self definitionClick:self.clarityBtn];
            }
            [self.delegate fullScreen:self fullScreen:NO];
        }
    }
}
#pragma mark -
#pragma mark   ================layoutSubviews============
- (void)layoutSubviews {
    [super layoutSubviews];
    [self.player.view mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.and.top.and.bottom.equalTo(self);
    }];
}
#pragma mark -
#pragma mark   ==============滑动条事件==============
- (void)didSliderValueChanged:(UISlider *)slider {
    [self refreshMediaControl];
}
- (void)didSliderTouchDown:(UISlider *)slider {
    _isMediaSliderBeingDragged = YES;
}
- (void)didSliderTouchCancel:(UISlider *)slider {
    _isMediaSliderBeingDragged = NO;
}
- (void)didSliderTouchUpOutside:(UISlider *)slider {
    _isMediaSliderBeingDragged = NO;
}
- (void)didSliderTouchUpInside:(UISlider *)slider {
    self.player.currentPlaybackTime = self.progressSlider.value;
    _isMediaSliderBeingDragged = NO;
}
#pragma mark -
#pragma mark   ==============按钮点击事件==============
- (void)btnClick:(UIButton *)btn {
    
    if (btn.tag == 20) {
        if (self.player) {
            if (!btn.selected) {
                btn.selected = YES;
                [self changeScreenFrame:YES];
                
            }else {
                btn.selected = NO;
                [self changeScreenFrame:NO];
            }
        }
    }else if (btn.tag == 40){
        if (self.fullBtn.selected) {
            [self startStopData:NO];
            if (btn.selected) {
                btn.selected = NO;
            }else {
                btn.selected = YES;
            }
            [self startStopData:YES];
        }
    }else if (btn.tag == 50){
        if ([self.delegate respondsToSelector:@selector(fullScreen:fullScreen:)]) {
            self.lockBtn.hidden = YES;
            self.navView.hidden = YES;
            self.fullBtn.selected = NO;
            [self.delegate fullScreen:self fullScreen:NO];
        }
    }
}
- (void)playOpen:(UIButton *)btn{
    
    if (self.playUrl) {
        [self startStopData:NO];
        if (!btn.selected) {
            btn.selected = YES;
            [self.player play];
        }else {
            btn.selected = NO;
            [self.player pause];
        }
        [self startStopData:YES];
    }else {
        btn.hidden = YES;
    }
    if (btn.tag == 10) {
        self.playBtn.selected = btn.selected;
        self.playBtn.hidden = btn.hidden;
    }
}

#pragma mark -
#pragma mark   ==============UI - lazy==============
- (UILabel *)noticeL {
    if (!_noticeL) {
        _noticeL = [[UILabel alloc] init];
        _noticeL.font = [UIFont pingFangSCFontOfSize:14];
        _noticeL.hidden = YES;
    }
    return _noticeL;
}
- (UIButton *)lockBtn {
    if (!_lockBtn) {
        _lockBtn = [[UIButton alloc] init];
        _lockBtn.adjustsImageWhenHighlighted = NO;
        [_lockBtn setImage:[UIImage imageNamed:@"icon_lockscreen"] forState:UIControlStateSelected];
        [_lockBtn setImage:[UIImage imageNamed:@"icon_solutionscreen"] forState:UIControlStateNormal];
        [_lockBtn addTarget:self action:@selector(lockClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _lockBtn;
}
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 52, 100, 0)];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.hidden = YES;
        _tableView.tag = 1000;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cellT"];
        
        UIImageView *imageV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_definition"]];
        imageV.userInteractionEnabled = YES;
        [_tableView setBackgroundView:imageV];
        _tableView.backgroundColor = [UIColor clearColor];
    }
    return _tableView;
}
- (UILabel *)logoL {
    if (!_logoL) {
        _logoL = [[UILabel alloc] init];
        _logoL.text = @"SHIJKPlayer";
        _logoL.font = [UIFont semiboldPingFangSCFontOfSize:20];
        _logoL.textAlignment = NSTextAlignmentRight;
        _logoL.textColor = [UIColor whiteColor];
    }
    return _logoL;
}
- (UIButton *)clarityBtn {
    if (!_clarityBtn) {
        _clarityBtn = [[UIButton alloc] init];
        [_clarityBtn addTarget:self action:@selector(clarityClick:) forControlEvents:UIControlEventTouchUpInside];
        _clarityBtn.layer.cornerRadius = 5.f;
        _clarityBtn.clipsToBounds = YES;
        _clarityBtn.layer.borderColor = [UIColor whiteColor].CGColor;
        _clarityBtn.layer.borderWidth = 1.f;
        _clarityBtn.titleLabel.font = [UIFont pingFangSCFontOfSize:14];
        [_clarityBtn setTitle:@"标清" forState:UIControlStateNormal];
    }
    return _clarityBtn;
}
- (UILabel *)titleL {
    if (!_titleL) {
        _titleL = [[UILabel alloc] init];
        _titleL.textColor = [UIColor whiteColor];
        _titleL.font = [UIFont boldPingFangSCFontOfSize:16];
    }
    return _titleL;
}
- (UIButton *)backBtn {
    if (!_backBtn) {
        _backBtn = [[UIButton alloc] init];
        _backBtn.adjustsImageWhenHighlighted = NO;
        [_backBtn setImage:[UIImage imageNamed:@"guluback"] forState:UIControlStateNormal];
        [_backBtn addTarget:self action:@selector(backClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backBtn;
}
- (UIImageView *)navView {
    if (!_navView) {
        _navView = [[UIImageView alloc] init];
        _navView.userInteractionEnabled = YES;
    }
    return _navView;
}
- (UIButton *)fullBtn {
    if (!_fullBtn) {
        _fullBtn = [[UIButton alloc] init];
        [_fullBtn setImage:[UIImage imageNamed:@"icon_fullscreen_big"] forState:UIControlStateNormal];
        [_fullBtn setImage:[UIImage imageNamed:@"icon_fullscreen_small"] forState:UIControlStateSelected];
        [_fullBtn addTarget:self action:@selector(fullClick:) forControlEvents:UIControlEventTouchUpInside];
        _fullBtn.adjustsImageWhenHighlighted = NO;
    }
    return _fullBtn;
}
- (UILabel *)rightTimeL {
    if (!_rightTimeL) {
        _rightTimeL = [[UILabel alloc] init];
        _rightTimeL.textColor = [UIColor whiteColor];
        _rightTimeL.font = [UIFont pingFangSCFontOfSize:12];
        _rightTimeL.text = @"00:00";
    }
    return _rightTimeL;
}
- (UISlider *)progressSlider {
    if (!_progressSlider) {
        _progressSlider = [[UISlider alloc] init];
        _progressSlider.maximumValue = 1.0;
        _progressSlider.minimumValue = 0.0;
        _progressSlider.maximumTrackTintColor = [UIColor clearColor];
        _progressSlider.thumbTintColor = [UIColor whiteColor];
        _progressSlider.clipsToBounds = YES;
        _progressSlider.layer.cornerRadius = 1.f;
        [_progressSlider addTarget:self action:@selector(didSliderValueChanged:) forControlEvents:UIControlEventValueChanged];
        [_progressSlider setThumbImage:[UIImage imageNamed:@"live_icon_adjust"] forState:UIControlStateNormal];
        [_progressSlider setThumbImage:[UIImage imageNamed:@"live_icon_adjust"] forState:UIControlStateHighlighted];
    }
    return _progressSlider;
}
- (UIProgressView *)cacheProgressView {
    if (!_cacheProgressView) {
        _cacheProgressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
        _cacheProgressView.clipsToBounds = YES;
        _cacheProgressView.progressTintColor = [UIColor colorWithHexString:@"#747474"];
        _cacheProgressView.trackTintColor = [UIColor colorWithHexString:@"#4a4a4a"];
        _cacheProgressView.layer.cornerRadius = 1.f;
    }
    return _cacheProgressView;
}
- (UILabel *)leftTimeL {
    if (!_leftTimeL) {
        _leftTimeL = [[UILabel alloc] init];
        _leftTimeL.textColor = [UIColor whiteColor];
        _leftTimeL.font = [UIFont pingFangSCFontOfSize:12];
        _leftTimeL.textAlignment = NSTextAlignmentRight;
        _leftTimeL.text = @"00:00";
    }
    return _leftTimeL;
}
- (UIButton *)leftPlayBtn {
    if (!_leftPlayBtn) {
        _leftPlayBtn = [[UIButton alloc] init];
        _leftPlayBtn.adjustsImageWhenHighlighted = NO;
        [_leftPlayBtn addTarget:self action:@selector(leftPlayClick:) forControlEvents:UIControlEventTouchUpInside];
        [_leftPlayBtn setImage:[UIImage imageNamed:@"play_small"] forState:UIControlStateNormal];
        [_leftPlayBtn setImage:[UIImage imageNamed:@"icon_suspend"] forState:UIControlStateSelected];
    }
    return _leftPlayBtn;
}
- (UIButton *)playBtn {
    if (!_playBtn) {
        _playBtn = [[UIButton alloc] init];
        [_playBtn setImage:[UIImage imageNamed:@"icon_play"] forState:UIControlStateNormal];
        [_playBtn setImage:[UIImage imageNamed:@"icon_play"] forState:UIControlStateSelected];
        _playBtn.adjustsImageWhenHighlighted = NO;
        [_playBtn addTarget:self action:@selector(playClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _playBtn;
}
- (UIImageView *)backImageView {
    if (!_backImageView) {
        _backImageView = [[UIImageView alloc] init];
        _backImageView.userInteractionEnabled = YES;
        [_backImageView setContentMode:UIViewContentModeScaleAspectFit];
    }
    return _backImageView;
}
- (UIImageView *)backImageColor {
    if (!_backImageColor) {
        _backImageColor = [[UIImageView alloc] init];
        _backImageColor.userInteractionEnabled = YES;
        _backImageColor.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
    }
    return _backImageColor;
}
- (SHButton *)tapBtn {
    if (!_tapBtn) {
        _tapBtn = [[SHButton alloc] init];
        _tapBtn.touchDelegate = self;
    }
    return _tapBtn;
}
- (MPVolumeView *)volumeView {
    if (_volumeView == nil) {
        _volumeView  = [[MPVolumeView alloc] init];
        [_volumeView sizeToFit];
        for (UIView *view in [_volumeView subviews]){
            if ([view.class.description isEqualToString:@"MPVolumeSlider"]){
                self.volumeViewSlider = (UISlider*)view;
                break;
            }
        }
    }
    return _volumeView;
}
- (SHLabel *)hubTimeL {
    if (!_hubTimeL) {
        _hubTimeL = [SHLabel labelHubView];
        _hubTimeL.hidden = YES;
    }
    return _hubTimeL;
}
- (UIImageView *)functionBackV {
    if (!_functionBackV) {
        _functionBackV = [[UIImageView alloc] init];
        _functionBackV.userInteractionEnabled = YES;
    }
    return _functionBackV;
}@end


