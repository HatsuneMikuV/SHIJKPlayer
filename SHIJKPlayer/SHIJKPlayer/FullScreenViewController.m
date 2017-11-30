//
//  FullScreenViewController.m
//  SHIJKPlayer
//
//  Created by angle on 2017/11/29.
//  Copyright © 2017年 angle. All rights reserved.
//

#import "FullScreenViewController.h"

@interface FullScreenViewController ()

@property(atomic, retain) id<IJKMediaPlayback> player;

@end

@implementation FullScreenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    VideoDataManger *manger = [VideoDataManger sharedManager];
    
    VideoDataModel *model = manger.videoDict[manger.definition[1]];
    if (model) {
        NSURL *playUrl = [SHVideoInfoModel writeTofeildWithData:model.videos];
        
        NSLog(@"===================================\n%@",playUrl);
        [self addPlayerView:playUrl];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [VideoDataManger interfaceOrientation:YES finishBlock:^{
        VideoDataManger *manger = [VideoDataManger sharedManager];
        manger.Orientation = UIInterfaceOrientationMaskLandscape;
    }];
}


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
    self.player.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    self.player.scalingMode = IJKMPMovieScalingModeAspectFill;
    self.player.shouldAutoplay = YES;
    [self.view addSubview:self.player.view];
    [self.player prepareToPlay];
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [VideoDataManger interfaceOrientation:NO finishBlock:^{
        VideoDataManger *manger = [VideoDataManger sharedManager];
        manger.Orientation = UIInterfaceOrientationMaskPortrait;
    }];
}
- (void)dealloc {
    [self.player stop];
    [self.player shutdown];
    [self.player.view removeFromSuperview];
    self.player = nil;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
