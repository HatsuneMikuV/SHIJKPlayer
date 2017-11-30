//
//  VideoDataModel.m
//  SHIJKPlayer
//
//  Created by angle on 2017/11/29.
//  Copyright © 2017年 angle. All rights reserved.
//

#import "VideoDataModel.h"

@implementation VideoDataModel

+ (VideoDataModel *)modelWithDict:(NSDictionary *)dict {
    return [[self alloc] initWithDict:dict];
}
- (instancetype)initWithDict:(NSDictionary *)dict {
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}
- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    NSLog(@"%@未使用的key---%@",self.class,key);
    if ([key isEqualToString:@"segments"]) {
        NSMutableArray *arr = [NSMutableArray array];
        for (NSDictionary *dict in value) {
            SHVideoInfoModel *model = [SHVideoInfoModel modelWithDict:dict];
            [arr addObject:model];
        }
        self.videos = arr.copy;
    }
}

@end


@interface VideoDataManger ()

@property (nonatomic, strong) NSDictionary *dataDict;

@end

@implementation VideoDataManger

+ (instancetype)sharedManager {
    static VideoDataManger *_videoManager = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _videoManager = [[self alloc] init];
    });
    
    return _videoManager;
}

- (instancetype)init {
    self = [super init];
    if (self) {

        NSData *JSONData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Video" ofType:@"json"]];
        
        NSDictionary *dataDict = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingAllowFragments error:nil];
        
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        if (dataDict) {
            for (NSString *key in dataDict) {
                VideoDataModel *model = [VideoDataModel modelWithDict:dataDict[key]];
                [dict setObject:model forKey:key];
            }
        }
        self.dataDict = dict;
    }
    return self;
}
- (NSDictionary *)videoDict {
    return self.dataDict;
}
- (NSArray *)definition {
    return [self.dataDict.allKeys sortedArrayUsingSelector:@selector(compare:)];
}
#pragma mark 强制屏幕转屏
+ (void)interfaceOrientation:(BOOL)orientation finishBlock:(void (^)(void))finish{
    if (orientation) {
        [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIDeviceOrientationLandscapeLeft] forKey:@"orientation"];
    }else {
        [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIDeviceOrientationPortrait] forKey:@"orientation"];
    }
    [UIViewController attemptRotationToDeviceOrientation];
    if (finish) {
        finish();
    }
}
@end
