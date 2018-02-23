//
//  ProviderReadVideo.m
//  YNote
//
//  Created by LinChanglong on 2017/7/27.
//  Copyright © 2017年 Youdao. All rights reserved.
//

#import "ProviderReadVideo.h"

@implementation ProviderReadVideo

+ (NSArray<NSString *> *)readableTypeIdentifiersForItemProvider {
    return  @[(NSString *)kUTTypeMPEG4,
              (NSString *)kUTTypeMPEG,
              (NSString *)kUTTypeMovie,
              (NSString *)kUTTypeVideo,
              (NSString *)kUTTypeAVIMovie,
              (NSString *)kUTTypeMPEG2Video,
              (NSString *)kUTTypeAppleProtectedMPEG4Video,
              (NSString *)kUTTypeQuickTimeMovie,
              (NSString *)kUTTypeMPEG2TransportStream];
}

@end
