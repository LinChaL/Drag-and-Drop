//
//  DocUtils.m
//  DragAndDropDemo
//
//  Created by LinChanglong on 2017/12/22.
//  Copyright © 2017年 linchl. All rights reserved.
//

#import "DocUtils.h"

@implementation DocUtils

+ (FileType)getFileType:(NSString *)title
{
    title = [title lowercaseString];
    NSString *extenstion = [title pathExtension];
    if ([extenstion isEqualToString:@"txt"]) {
        return DocFileTypeText;
    }
    if ([extenstion isEqualToString:@"doc"] || [extenstion isEqualToString:@"docx"] || [extenstion isEqualToString:@"rtf"]) {
        return DocFileTypeWord;
    }
    if ([extenstion isEqualToString:@"ppt"] || [extenstion isEqualToString:@"pptx"]) {
        return DocFileTypePPT;
    }
    if ([extenstion isEqualToString:@"xls"] || [extenstion isEqualToString:@"xlsx"]) {
        return DocFileTypeExcel;
    }
    if ([extenstion isEqualToString:@"pdf"]) {
        return DocFileTypePdf;
    }
    NSArray *audios = @[@"mp3", @"aac", @"ogg", @"wav", @"flac", @"m4a", @"ape", @"amr"];
    for (NSString *type in audios)
    {
        if ([extenstion isEqualToString:type]) {
            return DocFileTypeAudio;
        }
    }
    NSArray *videos = @[@"rm", @"rmvb", @"avi", @"mkv", @"mpg", @"mpeg",
                        @"wmv", @"ts", @"m4v", @"mp4", @"wma", @"mov"];
    for (NSString *type in videos)
    {
        if ([extenstion isEqualToString:type]) {
            return DocFileTypeVideo;
        }
    }
    NSArray *pictures = @[@"jpg", @"jpeg", @"gif", @"png", @"bmp"];
    for (NSString *type in pictures)
    {
        if ([extenstion isEqualToString:type]) {
            return DocFileTypeImage;
        }
    }
    NSArray *rars = @[@"zip", @"rar"];
    for (NSString *type in rars)
    {
        if ([extenstion isEqualToString:type]) {
            return DocFileTypeRar;
        }
    }
    NSArray *htmls = @[@"mht"];
    for (NSString *type in htmls)
    {
        if ([extenstion isEqualToString:type]) {
            return DocFileTypeHtml;
        }
    }
    NSArray *swfs = @[@"swf", @"flv"];
    for (NSString *type in swfs)
    {
        if ([extenstion isEqualToString:type]) {
            return DocFileTypeSwf;
        }
    }
    
    if ([[extenstion lowercaseString] isEqualToString:@"audio"]) {
        return DocFileTypeASRNote;
    }
    
    if ([[extenstion lowercaseString] isEqualToString:@"js"]
        || [[extenstion lowercaseString] isEqualToString:@"sh"]
        ||[[extenstion lowercaseString] isEqualToString:@"cpp"]
        || [[extenstion lowercaseString] isEqualToString:@"c"]
        || [[extenstion lowercaseString] isEqualToString:@"h"]
        || [[extenstion lowercaseString] isEqualToString:@"cc"]
        || [[extenstion lowercaseString] isEqualToString:@"hpp"]
        || [[extenstion lowercaseString] isEqualToString:@"css"]
        || [[extenstion lowercaseString] isEqualToString:@"less"]
        || [[extenstion lowercaseString] isEqualToString:@"scss"]
        || [[extenstion lowercaseString] isEqualToString:@"coffee"]
        || [[extenstion lowercaseString] isEqualToString:@"html"]
        || [[extenstion lowercaseString] isEqualToString:@"xml"]
        || [[extenstion lowercaseString] isEqualToString:@"htm"]
        || [[extenstion lowercaseString] isEqualToString:@"json"]
        || [[extenstion lowercaseString] isEqualToString:@"java"]
        || [[extenstion lowercaseString] isEqualToString:@"php"]
        || [[extenstion lowercaseString] isEqualToString:@"pl"]
        || [[extenstion lowercaseString] isEqualToString:@"py"]
        || [[extenstion lowercaseString] isEqualToString:@"rb"]
        || [[extenstion lowercaseString] isEqualToString:@"sql"]
        || [[extenstion lowercaseString] isEqualToString:@"db"]
        || [[extenstion lowercaseString] isEqualToString:@"go"]
        || [[extenstion lowercaseString] isEqualToString:@"ini"]
        || [[extenstion lowercaseString] isEqualToString:@"conf"]) {
        return DocFileTypeCode;
    }
    if ([extenstion isEqualToString:@"numbers"]) {
        return DocFileTypeNumbers;
    }
    if ([extenstion isEqualToString:@"pages"]) {
        return DocFileTypePages;
    }
    if ([extenstion isEqualToString:@"keynote"]) {
        return DocFileTypeKeynote;
    }
    return DocFileTypeOther;
}

+ (NSString *)getDragIconByTitle:(NSString *)title
{
    FileType type = [self getFileType:title];
    switch (type) {
        case DocFileTypeOther:
            return @"drag_other";
        case DocFileTypeText:
            return @"drag_txt";
        case DocFileTypeWord:
            return @"drag_word";
        case DocFileTypePPT:
            return @"drag_ppt";
        case DocFileTypeExcel:
            return @"drag_excel";
        case DocFileTypePdf:
            return @"drag_pdf";
        case DocFileTypeAudio:
            return @"drag_audio";
        case DocFileTypeVideo:
            return @"drag_video";
        case DocFileTypeImage:
            return @"drag_pic";
        case DocFileTypeRar:
            return @"drag_rar";
        case DocFileTypeHtml:
            return @"drag_html";
        case DocFileTypeSwf:
            return @"drag_flash";
        case DocFileTypeCode:
            return @"drag_code";
        case DocFileTypeASRNote:
            return @"drag_asr";
        case DocFileTypeNumbers:
            return @"drag_numbers";
        case DocFileTypePages:
            return @"drag_pages";
        case DocFileTypeKeynote:
            return @"drag_keynote";
        default:
            return @"drag_other";
    }
}

@end
