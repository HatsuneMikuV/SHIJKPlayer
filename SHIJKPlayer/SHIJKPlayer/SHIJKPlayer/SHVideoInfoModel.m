//
//  SHVideoInfoModel.m
//  SHIJKPlayer
//
//  Created by angle on 2017/11/29.
//  Copyright © 2017年 angle. All rights reserved.
//

#import "SHVideoInfoModel.h"

@implementation SHVideoInfoModel

+ (SHVideoInfoModel *)modelWithDict:(NSDictionary *)dict {
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
}

+ (NSURL *)writeTofeildWithData:(NSArray<SHVideoInfoModel *> *)urlArr {
    if ([urlArr count] == 0) {
        return nil;
    }
    if ([urlArr count] == 1) {
        return [NSURL URLWithString:[urlArr.firstObject url]];
    }
    // 1.找到Documents文件夹路径
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    // 2.创建要存储的内容：字符串
    NSString *str = @"ffconcat version 1.0";
    for (SHVideoInfoModel *model in urlArr) {
        str = [NSString stringWithFormat:@"%@\nfile %@\nduration %.0f",str,model.url,[model.duration floatValue]];
    }
    NSLog(@"分片视频数据：%@",str);
    // 3.需要知道字符串最终存储的地方，所以需要创建一个路径去存储字符串
    NSString *strPath = [documentsPath stringByAppendingPathComponent:@"videoUrl.concat"];
    // 4.将字符串写入文件
    [str writeToFile:strPath atomically:YES encoding:NSUTF8StringEncoding error:nil];
    NSURL *URL = [[NSURL alloc] initFileURLWithPath:strPath];
    return URL;
}

@end
