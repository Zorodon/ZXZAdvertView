//
//  ZXZAdvertView.h
//  BeiLu
//
//  Created by YKJ2 on 16/6/22.
//  Copyright © 2016年 YKJ1. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^ClickBlock)(NSInteger idx);   //点击事件

@interface ZXZAdvertView : UIView
@property (copy, nonatomic) ClickBlock clickBlock;
- (instancetype)initWithFrame:(CGRect )rect images:(NSArray *)images;
- (void)removeAdTimer;//移除定时器
@end
