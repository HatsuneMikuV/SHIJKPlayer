//
//  ShardViewController.m
//  SHIJKPlayer
//
//  Created by angle on 2017/11/29.
//  Copyright © 2017年 angle. All rights reserved.
//

#import "ShardViewController.h"

@interface ShardViewController ()

@property(atomic, retain) id<IJKMediaPlayback> player;

@end

@implementation ShardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor purpleColor];
    
    VideoDataManger *manger = [VideoDataManger sharedManager];
    
    VideoDataModel *model = manger.videoDict[manger.definition[2]];
    if (model) {
        NSURL *playUrl = [SHVideoInfoModel writeTofeildWithData:model.videos];
        
        NSLog(@"===================================\n%@",playUrl);
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
    self.player.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, ceilf(SCREEN_WIDTH * 9 / 16));
    self.player.shouldAutoplay = YES;
    [self.view addSubview:self.player.view];
    [self.player prepareToPlay];
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
