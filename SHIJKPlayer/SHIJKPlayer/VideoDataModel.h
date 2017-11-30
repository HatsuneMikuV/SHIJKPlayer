//
//  VideoDataModel.h
//  SHIJKPlayer
//
//  Created by angle on 2017/11/29.
//  Copyright © 2017年 angle. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SHIJKPlayer.h"

@interface VideoDataModel : NSObject

@property (nonatomic, copy) NSString *duration;
@property (nonatomic, copy) NSString *size;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *type;

@property (nonatomic, strong) NSArray<SHVideoInfoModel *> *videos;

+ (VideoDataModel *)modelWithDict:(NSDictionary *)dict;

@end


@interface VideoDataManger : NSObject

@property (nonatomic, strong, readonly) NSDictionary *videoDict;

@property (nonatomic, strong, readonly) NSArray *definition;

+ (instancetype)sharedManager;

@property (nonatomic, assign) UIInterfaceOrientationMask Orientation;

+ (void)interfaceOrientation:(BOOL)orientation finishBlock:(void (^)(void))finish;

@end
