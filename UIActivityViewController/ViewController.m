//
//  ViewController.m
//  UIActivityViewController
//
//  Created by Lemon on 2018/8/9.
//  Copyright © 2018年 Lemon. All rights reserved.
//

#import "ViewController.h"
#import "UIActivityCustom.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIButton *shareButton;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Lemon Share";
}


- (IBAction)touchUpInsideShareButton:(id)sender {
    
    //获取分享的视图控制器
    UIViewController *shareVc = [self shareVc];
    //注意崩溃点：区分iPad,因为iPad以UIPopoverPresentationController的形式，不然直接present会崩溃
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        UIPopoverPresentationController *popVc = shareVc.popoverPresentationController;
        popVc.sourceView = self.shareButton;
        popVc.sourceRect = CGRectMake(CGRectGetMidX(self.shareButton.frame), CGRectGetMidY(self.shareButton.frame), 0, 0);
    }
    //必须模态
    [self presentViewController:shareVc animated:YES completion:nil];
}

-(UIActivityViewController *)shareVc{
    //要分享的内容，加在一个数组里边，初始化UIActivityViewController
    NSString *string = @"Lemon share Demo";
    
    //本地的图片，记得放在Assets里面，不然放在外面，分享出去，会显示不支持的类型
    UIImage *image = [UIImage imageNamed:@"image.png"];
    
    //URL分享出去，不同的分享平台有不同的处理，大多数都会load出URL的内容，以图文的形式分享出去
    NSURL *url = [NSURL URLWithString:@"http://www.baidu.com"];
    
    //分享的内容
    NSArray *activityItems = @[string,image,url];
    
    //自定义Activity
    UIActivityCustom * customActivity = [[UIActivityCustom alloc] initWithModel:[self customModelWithArr:activityItems]];
    NSArray *customActivities = @[customActivity];
    
    //初始化UIActivityViewController
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:customActivities];
    
    //禁掉不用的服务,（只能禁掉系统的），如果是用户自己下载的，比如微信，用户开关打开，这里就算屏蔽，也会显示出来。非系统的服务，是否屏蔽依赖用户的操作。
    activityVC.excludedActivityTypes = @[UIActivityTypePrint,UIActivityTypeAssignToContact,UIActivityTypeSaveToCameraRoll,UIActivityTypeAddToReadingList,UIActivityTypePostToFlickr];
    
    //初始化回调方法(ios 8 以后)
    activityVC.completionWithItemsHandler = ^(UIActivityType  _Nullable activityType, BOOL completed, NSArray * _Nullable returnedItems, NSError * _Nullable activityError) {
        NSLog(@"activityType :%@", activityType);
        /*
         注意：这里的comppleted 的值，是有平台区分的，并不代表真正分享成功，
         比如： 1. 分享到WhatsApp，中途取消，不分享了，这里的值也是YES，activityError也是nil
               2. 分享到facebook，中途取消，这里的值就是NO
         */
        [self showAlertWithMessage:activityType.length ? activityType : @"" success:completed];
    };
    
    return activityVC;
}

- (void)showAlertWithMessage:(NSString *)message success:(BOOL)success
{
    NSString *title = [NSString stringWithFormat:@"分享%@",success ? @"成功" : @"失败"];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alert addAction:sure];
    
}

- (LMCustomModel *)customModelWithArr:(NSArray *)arr
{
    LMCustomModel *model = [LMCustomModel new];
    model.title = @"Lemom";
    model.imageName = @"icon";
    model.itemArray = arr;
    return model;
}
@end
