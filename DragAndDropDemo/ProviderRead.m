//
//  ProviderRead.m
//  YNote
//
//  Created by LinChanglong on 2017/7/26.
//  Copyright © 2017年 Youdao. All rights reserved.
//

#import "ProviderRead.h"
@interface ProviderRead()

@end

@implementation ProviderRead

+ (NSArray<NSString *> *)readableTypeIdentifiersForItemProvider {
    return nil;
}

- (nullable instancetype) initWithItemProviderData:(nonnull NSData *)data typeIdentifier:(nonnull NSString *)typeIdentifier error:(NSError * _Nullable __autoreleasing * _Nullable)outError {
    
    self = [super init];
    if (self) {
        _data = data;
        _typeIdentifier = typeIdentifier;
    }
    return self;
}

+ (instancetype)objectWithItemProviderData:(NSData *)data typeIdentifier:(NSString *)typeIdentifier error:(NSError * _Nullable __autoreleasing *)outError {
    return [[self alloc] initWithItemProviderData:data typeIdentifier:typeIdentifier error:outError];
}

@end
