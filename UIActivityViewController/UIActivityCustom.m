//
//  UIActivityCustom.m
//  ShareDemo
//
//  Created by Lemon on 2018/5/8.
//  Copyright © 2018年 Lemon. All rights reserved.
//

#import "UIActivityCustom.h"

static NSString * const kCustomActivityType = @"com.Lemon.custom.activity";

@implementation LMCustomModel

@end

@interface UIActivityCustom()
@property (nonatomic, strong)LMCustomModel *model;
@end

@implementation UIActivityCustom

- (instancetype)initWithModel:(LMCustomModel *)model
{
    self = [super init];
    if (self) {
        _model = model;
    }
    return self;
}

+ (UIActivityCategory)activityCategory{
    
    // 决定在UIActivityViewController中显示的位置，最上面是AirDrop，中间是Share，下面是Action
    return UIActivityCategoryAction;
}

- (NSString *)activityType {
    return kCustomActivityType;
}

- (NSString *)activityTitle {
    return _model.title;
}

- (UIImage *)activityImage {
    UIImage *imageToShare = [UIImage imageNamed:_model.imageName];
    return imageToShare;
}

- (BOOL)canPerformWithActivityItems:(NSArray *)activityItems {
    if (activityItems.count > 0) {
        return YES;
    }
    return NO;
}

- (void)prepareWithActivityItems:(NSArray *)activityItems {
    //准备分享所进行的方法，通常在这个方法里面，把item中的东西保存下来,items就是要传输的数据
    NSLog(@"prepareWithActivityItems===");
}

//实现activity的事件响应
- (void)performActivity {
    //用safari打开网址
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.baidu.com"]];
    
    //操作的最后必须使用下面方法告诉系统分享结束了
    [self activityDidFinish:YES];
    
}
@end
