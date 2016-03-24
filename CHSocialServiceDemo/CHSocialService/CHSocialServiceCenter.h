//
//  CHSocialServiceCenter.h
//  CHSocialServiceDemo
//
//  Created by Chausson on 16/3/24.
//  Copyright © 2016年 Chausson. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_OPTIONS(NSInteger ,CHSocialType) {
    CHSocialSina,
    CHSocialWeChat,
    CHSocialQQHandler
};
@interface CHSocialServiceCenter : NSObject
+ (CHSocialServiceCenter *)shareInstance;
/*
 @ brieft 设置友盟的APP KEY
 */
+ (void)setUmengAppkey:(NSString *)key;

- (void)shareText:(NSString *)text
            image:(UIImage *)image
       controller:(UIViewController *)controller
       completion:(void(^)(BOOL successful))finish;

- (void)configurationAppKey:(NSString *)key
              AppIdentifier:(NSString *)identifier
                     secret:(NSString *)secret
                redirectURL:(NSString *)redirectURL
                  sourceURL:(NSString *)url
                       type:(CHSocialType)type;


+ (instancetype)new __unavailable;
- (instancetype)init __unavailable;


@end
