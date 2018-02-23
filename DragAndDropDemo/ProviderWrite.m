//
//  ProviderWrite.m
//  YNote
//
//  Created by LinChanglong on 2017/9/4.
//  Copyright © 2017年 Youdao. All rights reserved.
//

#import "ProviderWrite.h"

static ProviderWrite *providerWrite;
@implementation ProviderWrite

- (nullable instancetype)initWithItemProviderData:(NSData *)data
                                   typeIdentifier:(NSString *)typeIdentifier
                                            error:(NSError **)outError {
    if (!data) {
        return nil;
    }
    self = [super init];
    if (self) {
        _data = data;
        _typeIdentifier = typeIdentifier;
        providerWrite = self;
    }
    return self;
}

+ (nullable instancetype)objectWithItemProviderData:(NSData *)data
                                     typeIdentifier:(NSString *)typeIdentifier
                                              error:(NSError **)outError {
    
    return [[self alloc] initWithItemProviderData:data typeIdentifier:typeIdentifier
                                    error:outError];
}

+ (NSArray<NSString *> *) writableTypeIdentifiersForItemProvider {
    return @[providerWrite.typeIdentifier];
}

- (nullable NSProgress *) loadDataWithTypeIdentifier:(nonnull NSString *)typeIdentifier forItemProviderCompletionHandler:(nonnull void (^)(NSData * _Nullable, NSError * _Nullable))completionHandler {
    NSProgress *progress = [NSProgress new];
    completionHandler(self.data, nil);
    return progress;
}

@end


