//
//  ProviderReadFolder.h
//  YNote
//
//  Created by LinChanglong on 2017/8/15.
//  Copyright © 2017年 Youdao. All rights reserved.
//

#import "ProviderRead.h"

@interface ProviderReadFolder : ProviderRead

+ (NSArray<NSString *> *)readableTypeIdentifiersForItemProvider;

@end
