//
//  UIActivityCustom.h
//  ShareDemo
//
//  Created by Lemon on 2018/5/8.
//  Copyright © 2018年 Lemon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LMCustomModel : NSObject

@property (nonatomic, copy) NSString *imageName;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSArray *itemArray;

@end


@interface UIActivityCustom : UIActivity
- (instancetype)initWithModel:(LMCustomModel *)model;

@end
