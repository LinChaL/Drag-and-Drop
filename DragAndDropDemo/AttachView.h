//
//  AttachView.h
//  DragAndDropDemo
//
//  Created by LinChanglong on 2018/1/2.
//  Copyright © 2018年 linchl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AttachView : UIView

@property (nonatomic, strong) NSString *fileName;
@property (nonatomic, strong) NSURL *url;

- (instancetype) initWithFileName:(NSString *)fileName;

@end
