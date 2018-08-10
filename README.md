#`UIActivityViewController`实现系统分享

##1. 前言
>目前很多分享可能都是考虑接入第三方SDK，一种是接入集成SDK，类似有盟，另外一种就是接入各个社交平台的官方SDK，UI定制性高，内容处理更灵活。但是如果需求上主要的社交平台是偏国际化的，用第三方不一定更适合，因为像比如whatapp是没有SDK提供的。所以去了解了一下系统的分享组件接入方式。
  系统分享组件接入，有两种方案：
  1，social.framework + extension方式，这种方式在iOS10以后不支持了，所以不建议使用；
  2，使用UIActivityViewController实现分享，相比接入多个SDK，此方案更加便捷。
  
  ##2. 可参考APP
  >亚马逊，知乎，简书等都有使用到系统分享。
  
  ##3. 各平台支持分享内容
  
  ##4. 实现分享三步走
    初始化接口设置分享内容，设置回调方法，打开页面，就可进行分享。
  ###4.1. 初始化
    
  ```
  //分享內容
  NSString *string = @"Lemon share Demo";
  UIImage *image = [UIImage imageNamed:@"image.png"];
  NSURL *url = [NSURL URLWithString:@"http://www.baidu.com"];
  NSArray *activityItems = @[string,image,url];
  
  //自定义Activity
  UIActivityCustom * customActivity = [[UIActivityCustom alloc] initWithModel:[self customModelWithArr:activityItems]];
 NSArray *customActivities = @[customActivity];
    
 //初始化：
 UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:customActivities];
  
  ```
    
   ###4.1.1. 初始化崩溃点
  * `ActivityItems`入参不能为nil，为空会崩溃，所以注意检查参数。（自定义`applicationActivities`入参可以为空）
  
  ###4.1.2. 初始化其他二三事
  * 分享链接：社交平台会自动加载链接`header`里面的`title`，`image`，`desc`信息，以图文的样式显示。
  * 分享文本+链接：有两种方式
    ```
    第一种：
    NSString *string = @"Lemon share Demo";
  NSURL *url = [NSURL URLWithString:@"http://www.baidu.com"];
    NSArray *activityItems = @[string,url];
    这种方式，每个分享平台都支持正常分享，但是个别平台，只会取URL，显示图文信息，不取文本信息，不显示文本，也就是不会显示`Lemon share Demo`
    ```
    ```
    第二种：
    NSString *string = @"Lemon share Demo http://www.baidu.com";
    NSArray *activityItems = @[string];
    这种方式，大部分平台都支持，但是个别平台，会提示不支持的分享类型，但支持的分享的平台，可以解决第一种里面不会显示文本的问题，也就是说只要支持分享，那么文本信息就会显示。
    ```
    
  * 分享图片：在自己写`demo`调研方案的时候，一般使用一张本地图片，本地图片需要放在`Assets`里面，不然分享时会提示“不支持的分享类型”。
  
###4.2. 模态打开分享页面
  
  ```
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
  ```
  ###4.2.1. 打开分享页崩溃点
  * 注意兼容`ipad`,分享到`iPad`必须用`UIPopoverPresentationController `形式，不然会崩溃。
  * `UIPopoverPresentationController `的`sourceView`不能为空，为空会崩溃
  * 必须模态打开分享页，不然会崩溃
  
###4.3. 设置回调
```
 activityVC.completionWithItemsHandler = ^(UIActivityType  _Nullable activityType, BOOL completed, NSArray * _Nullable returnedItems, NSError * _Nullable activityError) {
        NSLog(@"activityType :%@", activityType);
        [self showAlertWithMessage:activityType.length ? activityType : @"" success:completed];
    };
```

  ###4.2.1. 回调里的两三事

* 回调里的`comppleted`值，是有平台区分的，并不代表真正分享成功,所以如果你的业务需要用这个值时，请注意结合场景分析。
```
比如： 
  1. 分享到WhatsApp，中途取消，不分享了，这里的值也是YES，activityError也是nil
  2. 分享到facebook，中途取消，这里的值就是NO
```
    
>至此你已经可以进行各个社交平台分享了，但是如果需要定义入口，可以继续往下看。

###5. 自定义Activity
  >如果自定义的话，需要继承系统的`UIActivity`。

###5.1 接口介绍  
  ```
// 决定自定义Activity显示的位置，第一行是AirDrop，第二行是Share，第三行Action
  + (UIActivityCategory)activityCategory
  {
      return UIActivityCategoryAction;
  }
//自定义的title
- (NSString *)activityTitle 
  {
    return @"Lemon";
  }
//自定义的图片
- (UIImage *)activityImage 
  {
    return [UIImage imageNamed:@"image"];
  }
//实现activity的事件响应
  - (void)performActivity {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.baidu.com"]];
    [self activityDidFinish:YES];    
  }
  ```
  实现以上方法就可以进行自定义Activity了。
  
  ####5.1.2 自定义`activity`三两事
   * `activityImage`图片系统会重绘，所以你会发现它可能是灰色的，图片大小建议60 * 60
  

>若需要demo可以戳这里[demo地址](https://github.com/eleganceLiu/UIActivityViewControllerDemo.git)