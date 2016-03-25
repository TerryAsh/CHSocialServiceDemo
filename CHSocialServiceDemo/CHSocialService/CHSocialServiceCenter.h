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
    CHSocialQQ
};
//typedef enum {
//    CHSocialUrlResourceTypeDefault,             //无
//    CHSocialUrlResourceTypeImage,               //图片
//    CHSocialUrlResourceTypeVideo,               //视频
//    CHSocialUrlResourceTypeMusic,                //音乐
//    CHSocialUrlResourceTypeWeb,                //网页
//    CHSocialUrlResourceTypeCount
//}CHSocialUrlResourceType;

@interface CHSocialServiceCenter : NSObject
+ (CHSocialServiceCenter *)shareInstance;
/*
 @ brieft 设置友盟的APP KEY
 */
+ (void)setUmengAppkey:(NSString *)key;

- (void)shareTitle:(NSString *)text
           content:(NSString *)content
          imageURL:(NSString *)imageUrl
             image:(UIImage *)image
       urlResource:(NSString *)url
        controller:(UIViewController *)controller
        completion:(void(^)(BOOL successful))finish;

- (void)configurationAppKey:(NSString *)key
              AppIdentifier:(NSString *)identifier
                     secret:(NSString *)secret
                redirectURL:(NSString *)redirectURL
                  sourceURL:(NSString *)url
                       type:(CHSocialType)type;

- (void)loginInAppliactionType:(CHSocialType)type
                    controller:(UIViewController *)controller
                    completion:(void(^)(NSDictionary *info))finish;

+ (instancetype)new __unavailable;
- (instancetype)init __unavailable;


@end
