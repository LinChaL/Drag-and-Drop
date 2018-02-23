//
//  DragAndDropController.m
//  DragAndDropDemo
//
//  Created by LinChanglong on 2017/12/22.
//  Copyright © 2017年 linchl. All rights reserved.
//

#import "DragAndDropController.h"
#import <Masonry.h>
#import "ProviderReadItem.h"
#import "ProviderReadVideo.h"
#import "ProviderReadFolder.h"
#import "ProviderWrite.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "DocUtils.h"
#import "AttachView.h"

#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

// 单个附件大小上限（200M）
#define MAX_ATTACHEMT_SIZE          (200 * 1024 * 1024)
#define FILE_VIEW_WIDTH             240
#define FILE_VIEW_HEIGHT            50
#define MARGIN                      5

typedef void(^YNItemProviderDealAction)(NSItemProvider *provider);

@interface DragAndDropController () <UIDragInteractionDelegate, UIDropInteractionDelegate>
@property (nonatomic, assign) UIView *preView; //上次拖入的文件
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UILabel *topLabel;
@end

@implementation DragAndDropController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configViews];
    [self enableDrop];
}

- (UIScrollView *)scrollView {
    if (_scrollView == NULL) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.backgroundColor = self.view.backgroundColor;
        _scrollView.alwaysBounceVertical = YES;
        _scrollView.showsVerticalScrollIndicator = YES;
        if (@available(iOS 11.0, *)) {
            self.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        [self.view addSubview:_scrollView];
    }
    return _scrollView;
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    CGFloat height = 0;
    for (UIView *subView in self.contentView.subviews) {
        if ([subView isKindOfClass:[UILabel class]]) {
            UILabel *label = (UILabel *)subView;
            height += [label sizeThatFits:CGSizeMake(size.width - 2 * MARGIN, CGFLOAT_MAX)].height;
        } else if ([subView isKindOfClass:[UIImageView class]]) {
            UIImageView *imageView = (UIImageView *)subView;
            UIImage *image = imageView.image;
            CGFloat imageHeight = image.size.height;
            CGFloat imageWidth = image.size.width;
            height += (size.width - 2 * MARGIN) * imageHeight / imageWidth;
        } else {
            height += subView.frame.size.height;
        }
        height += MARGIN;
    }
    self.scrollView.contentSize = CGSizeMake(0, height);
}

- (UIView *)contentView {
    if (_contentView == NULL) {
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = self.view.backgroundColor;
        [self.scrollView addSubview:_contentView];
    }
    return _contentView;
}

- (UILabel *)topLabel {
    if (_topLabel == NULL) {
        _topLabel = [[UILabel alloc] init];
        [_topLabel setText:@"请拖入文字、图片、视频或文件"];
        [_topLabel setTextColor:[UIColor blueColor]];
        [_topLabel setFont:[UIFont systemFontOfSize:18.0f]];
        _topLabel.numberOfLines = 0;
        _topLabel.lineBreakMode = NSLineBreakByWordWrapping;
        [self.contentView addSubview:_topLabel];
    }
    return _topLabel;
}

- (UIView *)preView {
    if (_preView == NULL) {
        _preView = self.topLabel;
    }
    return _preView;
}

- (void)configViews {
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_safeAreaLayoutGuideTop);
        make.left.right.bottom.mas_equalTo(0);
    }];
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
        make.width.equalTo(self.view);
        make.bottom.equalTo(self.preView.mas_bottom);
    }];
    
    [self.topLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(MARGIN);
        make.left.mas_equalTo(MARGIN);
        make.right.mas_equalTo(-MARGIN);
    }];
}

// 根据UTI获取文件后缀
- (NSString *)pathExtensionFromUTI:(NSString *)uti {
    CFStringRef theUTI = (__bridge CFStringRef)uti;
    CFStringRef results = UTTypeCopyPreferredTagWithClass(theUTI, kUTTagClassFilenameExtension);
    return (__bridge_transfer NSString *)results;
}

// 根据文件后缀获取UTI
- (NSString *)preferredUTIForExtention:(NSString *)ext {
    //Request the UTI via the file extension
    CFStringRef extension = (__bridge CFStringRef)ext;
    NSString *theUTI = (__bridge_transfer NSString *)UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, extension, NULL);
    return theUTI;
}

// 将拖入的文件写入本地
- (NSURL *)writeFile:(ProviderRead *)file fileName:(NSString *)fileName {
    NSString *resID = [self genID];
    NSString *docPath = [self getDocumentPath:resID];
    NSString *docFile = [docPath stringByAppendingPathComponent:fileName];
    [file.data writeToFile:docFile atomically:YES];
    return [NSURL fileURLWithPath:docFile];
}

// 生成文件ID
- (NSString *)genID {
    long long interval = [[NSDate date] timeIntervalSince1970] * 1000000;
    NSString *resID = [NSString stringWithFormat:@"%d%lld", arc4random() % 1000, interval];
    return resID;
}

- (NSString *)getDocumentPath:(NSString *)fileName {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *localDir = [paths objectAtIndex:0];
    NSString *filePath = [localDir stringByAppendingPathComponent:fileName];
    BOOL isDir = YES;
    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath isDirectory:&isDir]) {
        NSError *error = nil;
        NSDictionary *attributes = [NSDictionary dictionaryWithObject:NSFileProtectionNone
                                                               forKey:NSFileProtectionKey];
        [[NSFileManager defaultManager] createDirectoryAtPath:filePath withIntermediateDirectories:YES attributes:attributes error:&error];
        if (error) {
            
        }
    }
    return filePath;
}

- (void)dropView:(UIView *)view withHeight:(CGFloat)height {
    [self.contentView addSubview:view];
    [self enableDragWithView:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.preView.mas_bottom).offset(10);
        make.left.mas_equalTo(10);
        if ([view isKindOfClass:[UIImageView class]]) {
            UIImageView *imageView = (UIImageView *)view;
            make.left.mas_equalTo(MARGIN);
            make.right.mas_equalTo(-MARGIN);
            make.height.equalTo(view.mas_width).multipliedBy(imageView.image.size.height / imageView.image.size.width);
        } else if ([view isKindOfClass:[UILabel class]]) {
            make.right.mas_equalTo(-MARGIN);
        } else {
            make.width.mas_equalTo(FILE_VIEW_WIDTH);
            make.height.mas_equalTo(FILE_VIEW_HEIGHT);
        }
    }];
    [self.contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.width.equalTo(self.view);
        make.bottom.equalTo(view.mas_bottom);
    }];
    self.scrollView.contentSize = CGSizeMake(self.contentView.frame.size.width, self.contentView.frame.size.height + MARGIN + height);
    self.preView = view;
}

- (void)enableDrop {
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"11.0")) {
        if (@available(iOS 11.0, *)) {
            UIDropInteraction *drop = [[UIDropInteraction alloc] initWithDelegate:self];
            [self.scrollView addInteraction:drop];
        }
    }
}

#pragma mark - UIDropInteractionDelegate
- (BOOL)dropInteraction:(UIDropInteraction *)interaction canHandleSession:(id<UIDropSession>)session
{
    if (session.localDragSession != nil) { //ignore drag session started within app
        return false;
    }
    if ([[session items] count] > 10) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"上传失败" message:@"一次最多上传10个文件" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *closeAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
        [alertController addAction:closeAction];
        [self presentViewController:alertController animated:YES completion:nil];
        return false;
    }
    BOOL canHandle = false;
    if ([[session items] count] == 1 && [session canLoadObjectsOfClass:[ProviderReadFolder class]]) {
        canHandle = false;
    } else {
        canHandle = [session canLoadObjectsOfClass:[ProviderReadVideo class]] || [session canLoadObjectsOfClass:[ProviderReadItem class]] || [session canLoadObjectsOfClass:[UIImage class]] || [session canLoadObjectsOfClass:[NSString class]];
    }
    return canHandle;
}

- (UIDropProposal *)dropInteraction:(UIDropInteraction *)interaction sessionDidUpdate:(id<UIDropSession>)session
{
    if (@available(iOS 11.0, *)) {
        return [[UIDropProposal alloc] initWithDropOperation:UIDropOperationCopy];
    }
    return nil;
}

- (void)dropInteraction:(UIDropInteraction *)interaction performDrop:(id<UIDropSession>)session
{
    uint64_t masSize = MAX_ATTACHEMT_SIZE;
    
    __block BOOL hasAlert = NO;
    for (UIDragItem *item in [session items]) {
        __block NSItemProvider *provider = [item itemProvider];
        if (@available(iOS 11.0, *)) {
            YNItemProviderDealAction fileAction = ^(NSItemProvider *provider) {
                [provider loadFileRepresentationForTypeIdentifier:[provider registeredTypeIdentifiers][0] completionHandler:^(NSURL * _Nullable url, NSError * _Nullable error) {
                    if (url) {
                        uint64_t recordSizeByBytes = [[NSFileManager defaultManager] fileExistsAtPath:[url path] isDirectory:nil] ? [[[NSFileManager defaultManager] attributesOfItemAtPath:[url path] error:nil][NSFileSize] longLongValue] : 0;
                        if (recordSizeByBytes <= masSize) {
                            __block NSString *fileName = [url lastPathComponent];
                            if (fileName.length > 0 && fileName.pathExtension.length <= 0) {
                                for (NSString *uti in provider.registeredTypeIdentifiers) {
                                    NSString *extension = [self pathExtensionFromUTI:uti];
                                    if (extension && extension.length > 0) {
                                        fileName = [fileName stringByAppendingPathExtension:extension];
                                        break;
                                    }
                                }
                            }
                            
                            [provider loadObjectOfClass:[ProviderReadItem class] completionHandler:^(id<NSItemProviderReading>  _Nullable object, NSError * _Nullable error) {
                                if (!error) {
                                    ProviderReadItem *item = (ProviderReadItem *)object;
                                    if (item) {
                                        dispatch_async(dispatch_get_main_queue(), ^{
                                            NSURL *url = [self writeFile:item fileName:fileName];
                                            AttachView *view = [[AttachView alloc] initWithFileName:fileName];
                                            view.url = url;
                                            
                                            [self dropView:view withHeight:FILE_VIEW_HEIGHT];
                                        });
                                    }
                                }
                            }];
                        } else if (!hasAlert) {
                            hasAlert = YES;
                            NSString *errMsg = @"无法上传大于200M的文件";
                            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"上传失败" message:errMsg preferredStyle:UIAlertControllerStyleAlert];
                            UIAlertAction *closeAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
                            [alertController addAction:closeAction];
                            [self presentViewController:alertController animated:YES completion:nil];
                        }
                    }
                }];
            };
            YNItemProviderDealAction imageAction = ^(NSItemProvider *provider) {
                [provider loadObjectOfClass:[UIImage class] completionHandler:^(id<NSItemProviderReading>  _Nullable object, NSError * _Nullable error) {
                    UIImage* image = (UIImage*)object;
                    if (image) {
                        //handle image
                        dispatch_async(dispatch_get_main_queue(), ^{
                            UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
                            [self dropView:imageView withHeight:image.size.height];
                        });
                    } else {
                        fileAction(provider);
                    }
                }];
            };
            YNItemProviderDealAction stringAction = ^(NSItemProvider *provider) {
                [provider loadObjectOfClass:[NSString class] completionHandler:^(id<NSItemProviderReading>  _Nullable object, NSError * _Nullable error) {
                    NSString *str = (NSString*)object;
                    if (str) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            UILabel *label = [[UILabel alloc] init];
                            [label setText:str];
                            [label setFont:[UIFont systemFontOfSize:15.0f]];
                            [label setTextColor:[UIColor blackColor]];
                            label.numberOfLines = 0;
                            label.lineBreakMode = NSLineBreakByWordWrapping;
                            CGSize labelSize = [label sizeThatFits:CGSizeMake(self.view.frame.size.width - 2 * MARGIN, CGFLOAT_MAX)];
                            [self dropView:label withHeight:labelSize.height];
                        });
                    } else {
                        fileAction(provider);
                    }
                }];
            };
            if ([provider canLoadObjectOfClass:[UIImage class]]) {
                imageAction(provider);
            } else if ([provider canLoadObjectOfClass:[NSString class]]) {
                stringAction(provider);
            } else if (![provider canLoadObjectOfClass:[ProviderReadFolder class]] && [provider canLoadObjectOfClass:[ProviderReadItem class]]) {
                fileAction(provider);
            }
        }
    }
}



- (void)enableDragWithView:(UIView *)view {
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"11.0")) {
        if (@available(iOS 11.0, *)) {
            UIDragInteraction *drag = [[UIDragInteraction alloc] initWithDelegate:self];
            [view addInteraction:drag];
            view.userInteractionEnabled = YES;
        }
    }
}

- (NSArray*)itemsForSession:(id<UIDragSession>)session
{
    NSItemProvider* provider;
    CGPoint point = [session locationInView:self.contentView];
    UIView *hitView = [self.contentView hitTest:point withEvent:nil];
    if (hitView) {
        if ([hitView isKindOfClass:[UIImageView class]]) {
            UIImageView *imageView = (UIImageView *)hitView;
            provider = [[NSItemProvider alloc] initWithObject:imageView.image];
        } else if ([hitView isKindOfClass:[UILabel class]]) {
            UILabel *label = (UILabel *)hitView;
            provider = [[NSItemProvider alloc] initWithObject:label.text];
        } else {
            AttachView *view = (AttachView *)hitView;
            NSData *data = [NSData dataWithContentsOfURL:view.url];
            if (data) {
                NSString *fileName = [view.url lastPathComponent];
                NSString *extension = [fileName pathExtension];
                NSString *identifier = [self preferredUTIForExtention:extension];
                ProviderWrite *providerWrite = [ProviderWrite objectWithItemProviderData:data typeIdentifier:identifier error:nil];
                provider = [[NSItemProvider alloc] initWithObject:providerWrite];
                if (provider) {
                    provider.suggestedName = fileName;
                }
            } else {
                return nil;
            }
        }
        UIDragItem* item = [[UIDragItem alloc] initWithItemProvider:provider];
        return @[item];
    } else {
        return nil;
    }
}

#pragma mark - UIDragInteractionDelegate
- (NSArray<UIDragItem *> *)dragInteraction:(UIDragInteraction *)interaction itemsForBeginningSession:(id<UIDragSession>)session
{
    interaction.allowsSimultaneousRecognitionDuringLift = YES;
    NSArray* items = [self itemsForSession:session];
    return items;
}

- (NSArray<UIDragItem *> *)dragInteraction:(UIDragInteraction *)interaction itemsForAddingToSession:(id<UIDragSession>)session withTouchAtPoint:(CGPoint)point
{
    NSArray* items = [self itemsForSession:session];
    return items;
}

//- (nullable UITargetedDragPreview *)dragInteraction:(UIDragInteraction *)interaction previewForLiftingItem:(UIDragItem *)item session:(id<UIDragSession>)session
//{
//    NSDictionary *dragJson = self.dragInfo[EDITOR_JSON_CONTENT][0];
//    NSString *imageName = @"";
//    NSString *str = self.dragInfo[EDITOR_TEXT_CONTENT];
//    if (str.length > 0) {
//        imageName = @"drag_txt";
//    } else if ([dragJson[@"blockType"] isEqualToString:@"image"]) {
//        imageName = @"drag_pic";
//    } else if ([dragJson[@"blockType"] isEqualToString:@"attachment"]) {
//        imageName = [YNDocUtils getDragIconByTitle:dragJson[@"fileName"]];
//    }
//    UIImageView *dragImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
//    self.dragImageView = dragImageView;
//    [self.editWebView addSubview:self.dragImageView];
//    self.dragImageView.size = self.dragImageView.image.size;
//    self.dragImageView.center = self.selectPoint;
//    UIDragPreviewParameters* params = [UIDragPreviewParameters new];
//    UIBezierPath* path = [UIBezierPath bezierPathWithRoundedRect:self.dragImageView.bounds cornerRadius:5];
//    params.visiblePath = path;
//    params.backgroundColor = [UIColor clearColor];
//
//    UIDragPreviewTarget* target = [[UIDragPreviewTarget alloc] initWithContainer:self.dragImageView.superview center:self.selectPoint];
//
//    UITargetedDragPreview* preview = [[UITargetedDragPreview alloc] initWithView:self.dragImageView parameters:params target:target];
//    [self.dragImageView removeFromSuperview];
//
//    return preview;
//}

//- (void)dragInteraction:(UIDragInteraction *)interaction session:(id<UIDragSession>)session didEndWithOperation:(UIDropOperation)operation {
//    [self.selectedDic removeAllObjects];
//    self.isMultiDrag = NO;
//}

@end


