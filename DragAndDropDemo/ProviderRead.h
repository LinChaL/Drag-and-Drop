//
//  ProviderRead.h
//  YNote
//
//  Created by LinChanglong on 2017/7/26.
//  Copyright © 2017年 Youdao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MobileCoreServices/UTCoreTypes.h>

@interface ProviderRead : NSObject<NSItemProviderReading>

@property (class, NS_NONATOMIC_IOSONLY, readonly, copy) NSArray<NSString *> *readableTypeIdentifiersForItemProvider;
@property (nonatomic, strong) NSData *data;
@property (nonatomic, strong) NSString *typeIdentifier;
@end
