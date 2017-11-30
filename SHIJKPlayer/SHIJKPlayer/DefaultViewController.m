//
//  DefaultViewController.m
//  SHIJKPlayer
//
//  Created by angle on 2017/11/29.
//  Copyright © 2017年 angle. All rights reserved.
//

#import "DefaultViewController.h"


@interface DefaultViewController ()

@property(atomic, retain) id<IJKMediaPlayback> player;

@end

@implementation DefaultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   
    
    VideoDataManger *manger = [VideoDataManger sharedManager];
    
    NSLog(@"%@",manger.videoDict);
    NSLog(@"%@",manger.definition);
    VideoDataModel *model = manger.videoDict[manger.definition[2]];
    if (model) {
        NSURL *playUrl = [SHVideoInfoModel writeTofeildWithData:model.videos];
        
        [self addPlayerView:playUrl];
    }
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
    self.player.view.frame = CGRectMake(0, 64, SCREEN_WIDTH, ceilf(SCREEN_WIDTH * 9 / 16));
    self.player.scalingMode = IJKMPMovieScalingModeAspectFill;
    self.player.shouldAutoplay = YES;
    [self.view addSubview:self.player.view];
    [self.player prepareToPlay];
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
