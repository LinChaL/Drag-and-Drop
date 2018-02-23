//
//  AttachView.m
//  DragAndDropDemo
//
//  Created by LinChanglong on 2018/1/2.
//  Copyright © 2018年 linchl. All rights reserved.
//

#import "AttachView.h"
#import "DocUtils.h"
#import "Masonry.h"


#define UI_COLOR(r,g,b) [UIColor colorWithRed:r/255.f green:g/255.f blue:b/255.f alpha:1.0]

#define MARGIN          5

#define ICON_WIDTH      40
#define ICON_HEIGHT     40

@implementation AttachView

- (instancetype) initWithFileName:(NSString *)fileName {
    if (self = [super init]) {
        self.backgroundColor = UI_COLOR(242, 243, 244);
        self.fileName = fileName;
        [self configViews];
    }
    return self;
}

- (void)configViews {
    NSString *imageName = [DocUtils getDragIconByTitle:self.fileName];
    UIImageView *fileIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
    [self addSubview:fileIcon];
    
    UILabel *label = [[UILabel alloc] init];
    [label setText:self.fileName];
    [label setTextColor:[UIColor grayColor]];
    [label setFont:[UIFont systemFontOfSize:13.0f]];
    label.lineBreakMode = NSLineBreakByTruncatingMiddle;
    [self addSubview:label];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(fileIcon.mas_right).offset(MARGIN);
        make.centerY.equalTo(self);
        make.right.equalTo(self).offset(-MARGIN);
    }];
    
    [fileIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(MARGIN);
        make.bottom.mas_equalTo(-MARGIN);
        make.width.equalTo(fileIcon.mas_height);
    }];
}

@end
