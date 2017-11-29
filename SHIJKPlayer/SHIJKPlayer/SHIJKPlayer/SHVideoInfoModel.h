//
//  SHVideoInfoModel.h
//  SHIJKPlayer
//
//  Created by angle on 2017/11/29.
//  Copyright © 2017年 angle. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SHVideoInfoModel : NSObject

/* 分片视频的时长，单位s */
@property (nonatomic, copy) NSString *duration;

/* 分片视频的时长，单位B */
@property (nonatomic, copy) NSString *size;

/* 分片视频的url */
@property (nonatomic, copy) NSString *url;

+ (SHVideoInfoModel *)modelWithDict:(NSDictionary *)dict;

/**
 将分片视频写入本地并读出相对应的url

 @param urlArr 分片视频数组
 @return 拼接好的播放地址
 */
+ (NSURL *)writeTofeildWithData:(NSArray<SHVideoInfoModel *> *)urlArr;

@end
