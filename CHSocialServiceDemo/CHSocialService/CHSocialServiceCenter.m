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
static NSMutableSet *sharesType;
typedef void(^ResultCallback)(BOOL successful) ;
@interface CHSocialServiceCenter ()<UMSocialUIDelegate>
@end
@implementation CHSocialServiceCenter{
    ResultCallback _callback;
}
+ (CHSocialServiceCenter *)shareInstance{
    static id instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc]init];
        sharesType = [NSMutableSet set];
        
    });
    return instance;
}
+ (void)setUmengAppkey:(NSString *)key{

    CHUMAPP_KEY = key;
    [UMSocialData setAppKey:CHUMAPP_KEY];
}
+ (BOOL)handleOpenURL:(NSURL *)url delegate:(id)delegate{
   return  [UMSocialSnsService handleOpenURL:url wxApiDelegate:nil];
}
+ (void)applicationDidBecomeActive{
        [UMSocialSnsService  applicationDidBecomeActive];
}
- (void)configurationAppKey:(NSString *)key
              AppIdentifier:(NSString *)identifier
                     secret:(NSString *)secret
                redirectURL:(NSString *)redirectURL
                  sourceURL:(NSString *)url
                       type:(CHSocialType)type{
    switch (type) {
        case CHSocialQQ:
            [UMSocialQQHandler setQQWithAppId:identifier appKey:key url:url];
            [sharesType addObject:UMShareToQQ];
            break;
        case CHSocialSina:
            [UMSocialSinaSSOHandler openNewSinaSSOWithAppKey:key
                                                      secret:secret
                                                 RedirectURL:redirectURL];
            [sharesType addObject:UMShareToSina];
            break;

        case CHSocialWeChat:
            [UMSocialWechatHandler setWXAppId:identifier appSecret:secret url:url];
            [sharesType addObject:UMShareToWechatSession];
            [sharesType addObject:UMShareToWechatTimeline];
            break;
            
        default:
            break;
    }
}
- (void)shareTitle:(NSString *)text
           content:(NSString *)content
         imageURL:(NSString *)imageUrl
            image:(UIImage *)image
      urlResource:(NSString *)url
       controller:(UIViewController *)controller
       completion:(void(^)(BOOL successful))finish{
    NSAssert(CHUMAPP_KEY.length > 0, @"UMKEY IS NIL PLEASE SET");
    UMSocialUrlResource *resource = [[UMSocialUrlResource alloc]initWithSnsResourceType:UMSocialUrlResourceTypeImage url:imageUrl];
    UMSocialUrlResource *qqResource = [[UMSocialUrlResource alloc]initWithSnsResourceType:UMSocialUrlResourceTypeWeb url:url];
    UMSocialUrlResource *sinaResource = [[UMSocialUrlResource alloc]initWithSnsResourceType:UMSocialUrlResourceTypeWeb url:url];
    UMSocialWechatSessionData *data = [[UMSocialWechatSessionData alloc]init];
    data.wxMessageType =  UMSocialWXMessageTypeWeb;
    data.url = url;
    data.title = text;
    data.urlResource = resource;
    UMSocialQQData *qqData = [[UMSocialQQData alloc]init];
    qqData.urlResource = qqResource;

    UMSocialSinaData *sinaData = [[UMSocialSinaData alloc]init];
    sinaData.shareText = content;
    if (image) {
        sinaData.shareImage = image;
    }
    sinaData.urlResource = sinaResource;
    [UMSocialData defaultData].extConfig.qqData = qqData;
    [UMSocialData defaultData].extConfig.wechatSessionData = data;
    [UMSocialData defaultData].extConfig.wechatTimelineData = (UMSocialWechatTimelineData *)data;
    [UMSocialData defaultData].extConfig.sinaData = sinaData;
    [UMSocialSnsService presentSnsIconSheetView:controller
                                         appKey:CHUMAPP_KEY
                                      shareText:content
                                     shareImage:image
                                shareToSnsNames:[sharesType copy]
                                       delegate:self];
    if (finish) {
        _callback = finish;
    }

}

- (void)loginInAppliactionType:(CHSocialType)type
                    controller:(UIViewController *)controller
                    completion:(void(^)(CHSocialResponseData *response))finish{
    _callback = nil;
//    [UMSocialControllerService defaultControllerService].socialUIDelegate = self;
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
    CHSocialResponseData *responseData = [[CHSocialResponseData alloc]init];
    NSString *platformName = [UMSocialSnsPlatformManager getSnsPlatformString:typeName];
    
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:platformName];
    snsPlatform.loginClickHandler(controller,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
        //           获取微博用户名、uid、token、第三方的原始用户信息thirdPlatformUserProfile等
        if (response.responseCode == UMSResponseCodeSuccess) {
            UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:platformName];
//            NSLog(@"\nusername = %@,\n usid = %@,\n token = %@ iconUrl = %@,\n unionId = %@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken,snsAccount.iconURL, snsAccount.unionId );
            if (finish) {
                responseData.accessToken = snsAccount.accessToken;
               responseData.iconURL = snsAccount.iconURL;
               responseData.unionId = snsAccount.unionId;
               responseData.usid = snsAccount.usid;
               responseData.userName = snsAccount.userName;
                finish(responseData);
            }
        }else{
            NSError *error = [[NSError alloc]initWithDomain:@"loginInAppliactionType Error" code:response.responseCode userInfo:@{@"Message":response.message}];
            response.error = error;
            finish(responseData);
        }
    });
    [[UMSocialDataService defaultDataService] requestSnsInformation:platformName  completion:^(UMSocialResponseEntity *response){
//        NSLog(@"SnsInformation is %@",response.data);
    }];
    
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
