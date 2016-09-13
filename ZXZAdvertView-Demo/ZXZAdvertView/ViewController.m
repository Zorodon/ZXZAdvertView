//
//  ViewController.m
//  ZXZAdvertView
//
//  Created by YKJ2 on 16/9/13.
//  Copyright © 2016年 AAA. All rights reserved.
//

#import "ViewController.h"
#import "ZXZAdvertView.h"

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSArray *arr = @[@"http://u68001-mk.thecloudimages.com/images/2016/08/MK_1.png",@"http://u68001-mk.thecloudimages.com/images/2016/08/MK_2.png",@"m1",@"m2",@"m3"];
    ZXZAdvertView *advertView = [[ZXZAdvertView alloc] initWithFrame:CGRectMake(0, 20, kScreenWidth, 120) images:arr];
    [self.view addSubview:advertView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
