
#import <Foundation/Foundation.h>
#import <TencentOpenAPI/TencentOAuthObject.h>
#import <TencentOpenAPI/TencentOAuth.h>
#ifdef tzt_Share
#import "WeiboApi.h"
#endif
#import "TZTShareView.h"

/**
 *    @author yinjp
 *
 *    @brief  分享
 */

/*
 tzt_SupportTencent //腾讯分享（qq分享，腾讯微博，qq空间）
 tzt_Support_WeiBo  //新浪微博分享
 tzt_Support_WeiX   //微信分享（发送朋友，分享朋友圈）
 */

@interface TZTShareObject : NSObject

+ (TencentOAuth *)tencentOAuthWithAppID:(NSString *)appID withDelegate:(id<TencentSessionDelegate>)delegate;
+ (WeiboApi *)wbapiWithApppKey:(NSString *)appKey andAppSecret:(NSString *)appSecret;
+ (NSArray *)permissions;
+ (void)addShareViewin:(UIView *)view withDelegate:(id<shareDelegate>)delegate andInfo:(NSMutableDictionary*)pDict;

@end
