//
//  ViewController.m
//  SHIJKPlayer
//
//  Created by angle on 2017/11/27.
//  Copyright © 2017年 angle. All rights reserved.
//

#import "ViewController.h"

#import "VideoDataModel.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    VideoDataManger *manger = [VideoDataManger sharedManager];
    
    
    NSLog(@"%@",manger.videoDict);
    
    for (NSString *key in manger.videoDict) {
        NSLog(@"================");
        VideoDataModel *model =manger.videoDict[key];
        NSURL *playUrl = [SHVideoInfoModel writeTofeildWithData:model.videos];
        NSLog(@"%@",playUrl);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
