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
@end
