//
//  DocUtils.h
//  DragAndDropDemo
//
//  Created by LinChanglong on 2017/12/22.
//  Copyright © 2017年 linchl. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, FileType)
{
    DocFileTypeOther,
    DocFileTypeText,      // 文字
    DocFileTypeWord,      // word
    DocFileTypePPT,
    DocFileTypeExcel,
    DocFileTypePdf,
    DocFileTypeAudio,
    DocFileTypeVideo,
    DocFileTypeImage,
    DocFileTypeRar,
    DocFileTypeHtml,
    DocFileTypeSwf,
    DocFileTypeCode,
    DocFileTypeNumbers,
    DocFileTypePages,
    DocFileTypeKeynote,
    DocFileTypeASRNote
};

@interface DocUtils : NSObject

+ (FileType)getFileType:(NSString *)title;
+ (NSString *)getDragIconByTitle:(NSString *)title;

@end
