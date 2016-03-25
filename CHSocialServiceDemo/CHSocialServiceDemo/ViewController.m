//
//  ViewController.m
//  CHSocialServiceDemo
//
//  Created by Chausson on 16/3/24.
//  Copyright © 2016年 Chausson. All rights reserved.
//

#import "ViewController.h"
#import "CHSocialService.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)share:(UIButton *)sender {
    [[CHSocialServiceCenter shareInstance]shareTitle:@"测试分享标题" content:@"我是分享的内容" imageURL:nil image:[UIImage imageNamed:@"demo_image"] urlResource:@"http://www.alibaba.com" controller:self completion:^(BOOL successful) {
        
    }];

}

@end
