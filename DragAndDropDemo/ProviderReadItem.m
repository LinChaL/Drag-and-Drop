//
//  ProviderReadItem.m
//  YNote
//
//  Created by LinChanglong on 2017/8/15.
//  Copyright © 2017年 Youdao. All rights reserved.
//

#import "ProviderReadItem.h"

@implementation ProviderReadItem

+ (NSArray<NSString *> *)readableTypeIdentifiersForItemProvider {
    return @[(NSString *)kUTTypeItem];
}

@end
