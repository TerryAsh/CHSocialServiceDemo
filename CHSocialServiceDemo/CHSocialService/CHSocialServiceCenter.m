//
//  CHSocialServiceCenter.m
//  CHSocialServiceDemo
//
//  Created by Chausson on 16/3/24.
//  Copyright © 2016年 Chausson. All rights reserved.
//
#import "UMSocial.h"
#import "CHSocialServiceCenter.h"
#import "UMSocialSinaSSOHandler.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialLaiwangHandler.h"
#import "UMSocialQQHandler.h"
#import "UMSocialControllerService.h"
static NSString *CHUMAPP_KEY ;
typedef void(^ResultCallback)(BOOL successful) ;
@interface CHSocialServiceCenter ()<UMSocialUIDelegate>
@property (strong ,nonatomic) NSMutableDictionary *sharesType;
@end
@implementation CHSocialServiceCenter{
    ResultCallback _callback;
}
+ (CHSocialServiceCenter *)shareInstance{
    static id instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc]init];
        
    });
    return instance;
}
+ (void)setUmengAppkey:(NSString *)key{

    CHUMAPP_KEY = key;
}
- (void)configurationAppKey:(NSString *)key
              AppIdentifier:(NSString *)identifier
                     secret:(NSString *)secret
                redirectURL:(NSString *)redirectURL
                  sourceURL:(NSString *)url
                       type:(CHSocialType)type{
    switch (type) {
        case CHSocialQQHandler:
            [UMSocialQQHandler setQQWithAppId:identifier appKey:key url:url];
            break;
        case CHSocialSina:
            [UMSocialSinaSSOHandler openNewSinaSSOWithAppKey:key
                                                      secret:secret
                                                 RedirectURL:redirectURL];
            break;

        case CHSocialWeChat:
            [UMSocialWechatHandler setWXAppId:identifier appSecret:secret url:url];
            break;
            
        default:
            break;
    }
}
- (void)shareText:(NSString *)text
            image:(UIImage *)image
       controller:(UIViewController *)controller
       completion:(void(^)(BOOL successful))finish{
    NSAssert(CHUMAPP_KEY.length > 0, @"UMKEY IS NIL PLEASE SET");
    [UMSocialSnsService presentSnsIconSheetView:controller
                                         appKey:CHUMAPP_KEY
                                      shareText:text
                                     shareImage:image
                                shareToSnsNames:nil
                                       delegate:self];
    
    if (finish) {
        _callback = finish;
    }
}
- (void)loginInAppliactionType:(CHSocialType)type
                    controller:(UIViewController *)controller
                    completion:(void(^)(NSDictionary *info))finish{
    [UMSocialControllerService defaultControllerService].socialUIDelegate = self;
    UMSocialSnsType typeName;
    switch (type) {
        case CHSocialSina:
            typeName = UMSocialSnsTypeSina;
            break;
        case CHSocialWeChat:
            typeName = UMSocialSnsTypeWechatSession;
            break;
        case CHSocialQQ:
            typeName = UMSocialSnsTypeMobileQQ;
            break;
            
        default:
            break;
    }
    NSString *platformName = [UMSocialSnsPlatformManager getSnsPlatformString:typeName];
    
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:platformName];
    snsPlatform.loginClickHandler(controller,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
        //           获取微博用户名、uid、token、第三方的原始用户信息thirdPlatformUserProfile等
        if (response.responseCode == UMSResponseCodeSuccess) {
            UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:platformName];
            NSLog(@"\nusername = %@,\n usid = %@,\n token = %@ iconUrl = %@,\n unionId = %@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken,snsAccount.iconURL, snsAccount.unionId );
            if (finish) {
                finish(@{@"name":snsAccount.userName});
            }
        }
        //这里可以获取到腾讯微博openid,Qzone的token等
        /*
         if ([platformName isEqualToString:UMShareToTencent]) {
         [[UMSocialDataService defaultDataService] requestSnsInformation:UMShareToTencent completion:^(UMSocialResponseEntity *respose){
         NSLog(@"get openid  response is %@",respose);
         }];
         }
         */
    });
}
#pragma mark UMSocialUIDelegate
-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response{
    if (response.responseCode == UMSResponseCodeSuccess) {
        if (_callback) {
            _callback(YES);
        }
    }else{
        if (_callback) {
            _callback(NO);
        }
    }
    _callback = nil;
    
}

/**
 关闭当前页面之后
 
 @param fromViewControllerType 关闭的页面类型
 
 */
-(void)didCloseUIViewController:(UMSViewControllerType)fromViewControllerType{
    
}

/**
 各个页面执行授权完成、分享完成、或者评论完成时的回调函数
 
 @param response 返回`UMSocialResponseEntity`对象，`UMSocialResponseEntity`里面的viewControllerType属性可以获得页面类型
 */

@end
