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
        [[CHSocialServiceCenter shareInstance]shareText:@"um" image:nil controller:self completion:^(BOOL successful) {
            
        }];
}

@end
