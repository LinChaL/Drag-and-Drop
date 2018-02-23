//
//  ProviderReadFolder.m
//  YNote
//
//  Created by LinChanglong on 2017/8/15.
//  Copyright © 2017年 Youdao. All rights reserved.
//

#import "ProviderReadFolder.h"

@implementation ProviderReadFolder

+ (NSArray<NSString *> *)readableTypeIdentifiersForItemProvider {
    return @[(NSString *)kUTTypeFolder];
}

@end
