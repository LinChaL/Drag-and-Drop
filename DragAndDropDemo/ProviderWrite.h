//
//  ProviderWrite.h
//  YNote
//
//  Created by LinChanglong on 2017/9/4.
//  Copyright © 2017年 Youdao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MobileCoreServices/UTCoreTypes.h>

@interface ProviderWrite : NSObject <NSItemProviderWriting>

@property (class, nonatomic, readonly, copy) NSArray<NSString *> *writableTypeIdentifiersForItemProvider;
@property (nonatomic, strong) NSData * data;
@property (nonatomic, strong) NSString *typeIdentifier;
@property (nonatomic, strong) NSError *outError;

- (NSProgress *) loadDataWithTypeIdentifier:(NSString *)typeIdentifier forItemProviderCompletionHandler:(void (^)(NSData *, NSError *))completionHandler;
- (instancetype)initWithItemProviderData:(NSData *)data
                                   typeIdentifier:(NSString *)typeIdentifier
                                            error:(NSError **)outError;
+ (instancetype)objectWithItemProviderData:(NSData *)data
                                     typeIdentifier:(NSString *)typeIdentifier
                                              error:(NSError **)outError;
@end
