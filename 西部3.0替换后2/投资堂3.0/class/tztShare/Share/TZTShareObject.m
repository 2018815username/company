//
//  TZTShareObject.m
//  Test
//
//  Created by 在琦中 on 14-2-17.
//  Copyright (c) 2014年 crte. All rights reserved.
//

#import "TZTShareObject.h"

#define REDIRECTURI             @"http://www.ying7wang7.com"

static TZTShareView *shareView;
static WeiboApi        *wbapi;
static TencentOAuth    *tencentOAuth;
static NSArray         *permissions;

@implementation TZTShareObject

+ (TencentOAuth *)tencentOAuthWithAppID:(NSString *)appID withDelegate:(id<TencentSessionDelegate>)delegate
{
    //向QQ注册
    if(tencentOAuth == nil)
    {
        tencentOAuth = [[TencentOAuth alloc] initWithAppId:appID andDelegate:delegate];
    }
    return tencentOAuth;
}

+ (WeiboApi *)wbapiWithApppKey:(NSString *)appKey andAppSecret:(NSString *)appSecret
{
    //向腾讯微博注册
    if(wbapi == nil)
    {
//        wbapi = [[WeiboApi alloc]initWithAppKey:appKey andSecret:appSecret andRedirectUri:REDIRECTURI];
    }
    return wbapi;
}

+ (NSArray *)permissions
{
    if (permissions == nil) {
        permissions = [[NSArray arrayWithObjects:
                        kOPEN_PERMISSION_GET_USER_INFO,
                        kOPEN_PERMISSION_GET_SIMPLE_USER_INFO,
                        kOPEN_PERMISSION_ADD_ALBUM,
                        kOPEN_PERMISSION_ADD_IDOL,
                        kOPEN_PERMISSION_ADD_ONE_BLOG,
                        kOPEN_PERMISSION_ADD_PIC_T,
                        kOPEN_PERMISSION_ADD_SHARE,
                        kOPEN_PERMISSION_ADD_TOPIC,
                        kOPEN_PERMISSION_CHECK_PAGE_FANS,
                        kOPEN_PERMISSION_DEL_IDOL,
                        kOPEN_PERMISSION_DEL_T,
                        kOPEN_PERMISSION_GET_FANSLIST,
                        kOPEN_PERMISSION_GET_IDOLLIST,
                        kOPEN_PERMISSION_GET_INFO,
                        kOPEN_PERMISSION_GET_OTHER_INFO,
                        kOPEN_PERMISSION_GET_REPOST_LIST,
                        kOPEN_PERMISSION_LIST_ALBUM,
                        kOPEN_PERMISSION_UPLOAD_PIC,
                        kOPEN_PERMISSION_GET_VIP_INFO,
                        kOPEN_PERMISSION_GET_VIP_RICH_INFO,
                        kOPEN_PERMISSION_GET_INTIMATE_FRIENDS_WEIBO,
                        kOPEN_PERMISSION_MATCH_NICK_TIPS_WEIBO,
                        nil] retain];
    }
    return permissions;
}

+ (void)addShareViewin:(UIView *)view withDelegate:(id<shareDelegate>)delegate andInfo:(NSMutableDictionary *)pDict
{
    //获取分享方式
    NSString* strShareType = [pDict tztObjectForKey:@"sharetype"];// 0:微信  1:微信朋友圈  2:QQ好友 3:QQ空间 4:腾讯微博 5:新浪微博 99:客户端选择
    if (strShareType.length < 1)
        strShareType = @"99";
    
    
    if (!shareView)
    {
        shareView = [[TZTShareView alloc]initWithTitle:@"分享到" referView:view];
        [shareView setShareInfo:pDict];
        
        if ([strShareType intValue] != 99)
        {
            switch ([strShareType intValue])
            {
                case 0://微信好友分享
                {
                    [shareView sendWeixinAppContentwithScene:WXSceneSession];
                }
                    break;
                case 1://微信分享朋友圈
                {
                    [shareView sendWeixinAppContentwithScene:WXSceneTimeline];
                }
                    break;
                case 2://qq好友
                {
                    [shareView sendQQNewsMessage];
                }
                    break;
                case 3://qq空间
                {
                    [shareView share2QQZone];
                }
                    break;
                case 4://腾讯微博
                {
                    [shareView share2TCWeiboPic];
                }
                    break;
                case 5://新浪微博
                {
                    [shareView share2Weibo];
                }
                    break;
                default:
                    break;
            }
            return;
        }
        
        TZTShareButton *shareBtn;
        shareBtn = [[TZTShareButton alloc] initWithText:@"腾讯微博" image:[UIImage imageTztNamed:@"share_platform_tencentWeibo"]];
        shareBtn.tztShareType = TZTShareTypeTencentWeibo;
        shareBtn.shareDelegate = shareView;
//        [shareBtn setShareInfo:pDict];
        [shareView shareWhiteViewAdd:shareBtn];
        
        shareBtn = [[TZTShareButton alloc] initWithText:@"新浪微博" image:[UIImage imageTztNamed:@"share_platform_sina"]];
        shareBtn.tztShareType = TZTShareTypeSinaWeibo;
        shareBtn.shareDelegate = shareView;
//        [shareBtn setShareInfo:pDict];
        [shareView shareWhiteViewAdd:shareBtn];
        
        shareBtn = [[TZTShareButton alloc] initWithText:@"QQ空间" image:[UIImage imageTztNamed:@"share_platform_qqZone"]];
        shareBtn.tztShareType = TZTShareTypeQQSpace;
        shareBtn.shareDelegate = shareView;
//        [shareBtn setShareInfo:pDict];
        [shareView shareWhiteViewAdd:shareBtn];
        
        shareBtn = [[TZTShareButton alloc] initWithText:@"微信好友" image:[UIImage imageTztNamed:@"share_platform_wechat"]];
        shareBtn.tztShareType = TZTShareTypeWeixiSession;
        shareBtn.shareDelegate = shareView;
//        [shareBtn setShareInfo:pDict];
        [shareView shareWhiteViewAdd:shareBtn];
        
        shareBtn = [[TZTShareButton alloc] initWithText:@"微信朋友圈" image:[UIImage imageTztNamed:@"share_platform_wechattimeline"]];
        shareBtn.tztShareType = TZTShareTypeWeixiTimeline;
        shareBtn.shareDelegate = shareView;
//        [shareBtn setShareInfo:pDict];
        [shareView shareWhiteViewAdd:shareBtn];
        
        shareBtn = [[TZTShareButton alloc] initWithText:@"QQ好友" image:[UIImage imageTztNamed:@"share_platform_qqfriends"]];
        shareBtn.tztShareType = TZTShareTypeQQ;
        shareBtn.shareDelegate = shareView;
//        [shareBtn setShareInfo:pDict];
        [shareView shareWhiteViewAdd:shareBtn];
        
        [shareView initShareWhiteView];
    }
    else
    {
        [shareView setShareInfo:pDict];
        if ([strShareType intValue] != 99)
        {
            switch ([strShareType intValue])
            {
                case 0://微信好友分享
                {
                    [shareView sendWeixinAppContentwithScene:WXSceneSession];
                }
                    break;
                case 1://微信分享朋友圈
                {
                    [shareView sendWeixinAppContentwithScene:WXSceneTimeline];
                }
                    break;
                case 2://qq好友
                {
                    [shareView sendQQNewsMessage];
                }
                    break;
                case 3://qq空间
                {
                    [shareView share2QQZone];
                }
                    break;
                case 4://腾讯微博
                {
                    [shareView share2TCWeiboPic];
                }
                    break;
                case 5://新浪微博
                {
                    [shareView share2Weibo];
                }
                    break;
                default:
                    break;
            }
            return;
        }
    }
    [shareView showShareView];
}

@end
