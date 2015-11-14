//
//  TZTShareContentDelegate.m
//  tztMobileApp_GJUserStock
//
//  Created by DBQ on 5/7/14.
//
//

#import "TZTShareContentDelegate.h"
#import "TZTShareObject.h"

#define BUFFER_SIZE             1024 * 100
#define kTencentAppID           @"222222"
#define WiressSDKDemoAppKey     @"801478099"
#define WiressSDKDemoAppSecret  @"098b8d8df6bb288116d499b0ba410aa8"

TZTShareContentDelegate  *shareContentDelegate;

@interface TZTShareContentDelegate()<TencentSessionDelegate, WXApiDelegate>

@end

@implementation TZTShareContentDelegate

@synthesize wbapi;
@synthesize tencentOAuth;

+ (TZTShareContentDelegate*)shareDelegate
{
    if (shareContentDelegate == nil)
    {
        shareContentDelegate = NewObject(TZTShareContentDelegate);
    }
    return shareContentDelegate;
}

- (id)init
{
    self = [super init];
    if(self)
    {
#ifdef tzt_SupportTencent
        // 向QQ注册
        tencentOAuth = [TZTShareObject tencentOAuthWithAppID:kTencentAppID withDelegate:self];
#endif
#ifdef tzt_SupportWeiBo
        // 向腾讯微博注册
        wbapi = [TZTShareObject wbapiWithApppKey:WiressSDKDemoAppKey andAppSecret:WiressSDKDemoAppSecret];
#endif
    }
    return self;
}

#pragma mark - WechatBackDelegate

-(void) onReq:(BaseReq*)req
{
    if([req isKindOfClass:[GetMessageFromWXReq class]])
    {
        // 微信请求App提供内容， 需要app提供内容后使用sendRsp返回
        NSString *strTitle = [NSString stringWithFormat:@"微信请求App提供内容"];
        NSString *strMsg = @"微信请求App提供内容，App要调用sendResp:GetMessageFromWXResp返回给微信";
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        alert.tag = 1000;
        [alert show];
        [alert release];
    }
    else if([req isKindOfClass:[ShowMessageFromWXReq class]])
    {
        ShowMessageFromWXReq* temp = (ShowMessageFromWXReq*)req;
        WXMediaMessage *msg = temp.message;
        
        //显示微信传过来的内容
        WXAppExtendObject *obj = msg.mediaObject;
        
        NSString *strTitle = [NSString stringWithFormat:@"微信请求App显示内容"];
        NSString *strMsg = [NSString stringWithFormat:@"标题：%@ \n内容：%@ \n附带信息：%@ \n缩略图:%lu bytes\n\n", msg.title, msg.description, obj.extInfo, (unsigned long)msg.thumbData.length];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }
    else if([req isKindOfClass:[LaunchFromWXReq class]])
    {
        //从微信启动App
        NSString *strTitle = [NSString stringWithFormat:@"从微信启动"];
        NSString *strMsg = @"这是从微信启动的消息";
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }
}

-(void) onResp:(BaseResp*)resp
{
    if([resp isKindOfClass:[SendMessageToWXResp class]])
    {
        NSString *strTitle = [NSString stringWithFormat:@"发送媒体消息结果"];
        NSString *strMsg = [NSString stringWithFormat:@"errcode:%d", resp.errCode];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }
}

#pragma mark - WeiBoSinaBackDelegate

- (void)request:(WBHttpRequest *)request didFinishLoadingWithResult:(NSString *)result
{
    NSString *title = nil;
    UIAlertView *alert = nil;
    
    title = @"收到网络回调";
    alert = [[UIAlertView alloc] initWithTitle:title
                                       message:[NSString stringWithFormat:@"%@",result]
                                      delegate:nil
                             cancelButtonTitle:@"确定"
                             otherButtonTitles:nil];
    [alert show];
    [alert release];
}

- (void)request:(WBHttpRequest *)request didFailWithError:(NSError *)error;
{
    NSString *title = nil;
    UIAlertView *alert = nil;
    
    title = @"请求异常";
    alert = [[UIAlertView alloc] initWithTitle:title
                                       message:[NSString stringWithFormat:@"%@",error]
                                      delegate:nil
                             cancelButtonTitle:@"确定"
                             otherButtonTitles:nil];
    [alert show];
    [alert release];
}

#pragma mark - QQBackDelegate

- (void)handleSendResult:(QQApiSendResultCode)sendResult
{
    switch (sendResult)
    {
        case EQQAPIAPPNOTREGISTED:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"错误" message:@"App未注册" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            [msgbox release];
            
            break;
        }
        case EQQAPIMESSAGECONTENTINVALID:
        case EQQAPIMESSAGECONTENTNULL:
        case EQQAPIMESSAGETYPEINVALID:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"错误" message:@"发送参数错误" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            [msgbox release];
            
            break;
        }
        case EQQAPIQQNOTINSTALLED:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"错误" message:@"未安装手Q" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            [msgbox release];
            
            break;
        }
        case EQQAPIQQNOTSUPPORTAPI:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"错误" message:@"API接口不支持" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            [msgbox release];
            
            break;
        }
        case EQQAPISENDFAILD:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"错误" message:@"发送失败" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            [msgbox release];
            
            break;
        }
        default:
        {
            break;
        }
    }
}

#pragma mark - TencentAuthDelegate

/**
 * Called when the user successfully logged in.
 */
- (void)tencentDidLogin {
	
    
    if (tencentOAuth.accessToken
        && 0 != [tencentOAuth.accessToken length])
    {
        NSLog(@"%@",tencentOAuth.accessToken);
        //        [self showMessage:_tencentOAuth.accessToken];
        [self sendQQZoneTopic];
    }
    else
    {
        [self showMessage:@"登录不成功 没有获取accesstoken"];
    }
}

/**
 * Called when the user dismissed the dialog without logging in.
 */
- (void)tencentDidNotLogin:(BOOL)cancelled
{
	if (cancelled){
		[self showMessage:@"用户取消登录"];
	}
	else {
		[self showMessage:@"登录失败"];
	}
	
}

/**
 * Called when the notNewWork.
 */
-(void)tencentDidNotNetWork
{
	[self showMessage:@"无网络连接，请设置网络"];
}

#pragma mark - TCWeiboRequestDelegate

/**
 * @brief   接口调用成功后的回调
 * @param   INPUT   data    接口返回的数据
 * @param   INPUT   request 发起请求时的请求对象，可以用来管理异步请求
 * @return  无返回
 */
- (void)didReceiveRawData:(NSData *)data reqNo:(int)reqno
{
    NSString *strResult = [[NSString alloc] initWithBytes:[data bytes] length:[data length] encoding:NSUTF8StringEncoding];
    //[NSString stringWithCharacters:[data bytes] length:[data length]];
    NSLog(@"result = %@",strResult);
    
    [self showMessage:@"已分享"];
    [strResult release];
    
}
/**
 * @brief   接口调用失败后的回调
 * @param   INPUT   error   接口返回的错误信息
 * @param   INPUT   request 发起请求时的请求对象，可以用来管理异步请求
 * @return  无返回
 */
- (void)didFailWithError:(NSError *)error reqNo:(int)reqno
{
    NSString *str = [[NSString alloc] initWithFormat:@"refresh token error, errcode = %@",error.userInfo];
    
    [self showMessage:str];
    [str release];
}

#pragma mark - TCWeiboAuthDelegate
/**
 * @brief   重刷授权成功后的回调
 * @param   INPUT   wbapi 成功后返回的WeiboApi对象，accesstoken,openid,refreshtoken,expires 等授权信息都在此处返回
 * @return  无返回
 */
- (void)DidAuthRefreshed:(WeiboApi *)wbapi_
{
    
    
    NSString *str = [[NSString alloc]initWithFormat:@"accesstoken = %@\r openid = %@\r appkey=%@ \r appsecret=%@\r", wbapi_.accessToken, wbapi_.openid, wbapi_.appKey, wbapi_.appSecret];
    
    NSLog(@"result = %@",str);
    
    [self showMessage:@"重刷授权成功"];
    
    [str release];
    
}

/**
 * @brief   重刷授权失败后的回调
 * @param   INPUT   error   标准出错信息
 * @return  无返回
 */
- (void)DidAuthRefreshFail:(NSError *)error
{
    NSString *str = [[NSString alloc] initWithFormat:@"refresh token error, errcode = %@",error.userInfo];
    
    [self showMessage:@"重刷授权失败"];
    [str release];
}

/**
 * @brief   授权成功后的回调
 * @param   INPUT   wbapi 成功后返回的WeiboApi对象，accesstoken,openid,refreshtoken,expires 等授权信息都在此处返回
 * @return  无返回
 */
- (void)DidAuthFinished:(WeiboApi *)wbapi_
{
    NSString *str = [[NSString alloc]initWithFormat:@"accesstoken = %@\r openid = %@\r appkey=%@ \r appsecret=%@\r", wbapi_.accessToken, wbapi_.openid, wbapi_.appKey, wbapi_.appSecret];
    
    NSLog(@"result = %@",str);
    
    
    
    [self showAuthMessage];
    
    
    [str release];
}

/**
 * @brief   授权成功后的回调
 * @param   INPUT   wbapi   weiboapi 对象，取消授权后，授权信息会被清空
 * @return  无返回
 */
- (void)DidAuthCanceled:(WeiboApi *)wbapi_
{
    
}

/**
 * @brief   授权成功后的回调
 * @param   INPUT   error   标准出错信息
 * @return  无返回
 */
- (void)DidAuthFailWithError:(NSError *)error
{
    NSString *str = [[NSString alloc] initWithFormat:@"get token error, errcode = %@",error.userInfo];
    
    [self showMessage:@"授权出错"];
    [str release];
}

#pragma mark - SendContent

- (void)sendQQNewsMessage
{
    NSData* data = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Icon" ofType:@"png"]];
    
	NSURL* url = [NSURL URLWithString:@"http://www.yongjinbao.com.cn"];
	
    QQApiNewsObject* img = [QQApiNewsObject objectWithURL:url title:@"国金自选股" description:@"国金自选股" previewImageData:data];
    
    SendMessageToQQReq* req = [SendMessageToQQReq reqWithContent:img];
    
    BOOL sent = [QQApiInterface sendReq:req];
    [self handleSendResult:sent];
}

- (void)sendWeixinAppContentwithScene:(int)scene
{
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = @"国金自选股";
    message.description = @"国金自选股";
    [message setThumbImage:[UIImage imageNamed:@"Icon.png"]];
    
    WXAppExtendObject *ext = [WXAppExtendObject object];
    ext.extInfo = @"<xml>extend info</xml>";
    ext.url = @"http://www.yongjinbao.com.cn";
    
    Byte* pBuffer = (Byte *)malloc(BUFFER_SIZE);
    memset(pBuffer, 0, BUFFER_SIZE);
    NSData* data = [NSData dataWithBytes:pBuffer length:BUFFER_SIZE];
    free(pBuffer);
    
    ext.fileData = data;
    
    message.mediaObject = ext;
    
    SendMessageToWXReq* req = [[[SendMessageToWXReq alloc] init]autorelease];
    req.bText = NO;
    req.message = message;
    req.scene = scene;
    
    if (![WXApi sendReq:req]) {
        [self showMessage:@"尚未安装微信"];
    }
}

-(void)respAppContent
{
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = @"国金自选股";
    message.description = @"国金自选股";
    [message setThumbImage:[UIImage imageNamed:@"Icon"]];
    
    WXAppExtendObject *ext = [WXAppExtendObject object];
    ext.extInfo = @"<xml>extend info</xml>";
    ext.url = @"http://www.yongjinbao.com.cn";
    
    Byte* pBuffer = (Byte *)malloc(BUFFER_SIZE);
    memset(pBuffer, 0, BUFFER_SIZE);
    NSData* data = [NSData dataWithBytes:pBuffer length:BUFFER_SIZE];
    free(pBuffer);
    
    ext.fileData = data;
    
    message.mediaObject = ext;
    
    GetMessageFromWXResp* resp = [[[GetMessageFromWXResp alloc] init] autorelease];
    resp.message = message;
    resp.bText = NO;
    
    if (![WXApi sendResp:resp])
    {
        [self showMessage:@"尚未安装微信"];
    }
}

- (void)share2Weibo
{
    WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:[self weiboMessageToShare]];
    request.userInfo = @{@"ShareMessageFrom": @"SendMessageToWeiboViewController",
                         @"Other_Info_1": [NSNumber numberWithInt:123],
                         @"Other_Info_2": @[@"obj1", @"obj2"],
                         @"Other_Info_3": @{@"key1": @"obj1", @"key2": @"obj2"}};
    
    [WeiboSDK sendRequest:request];
}

- (WBMessageObject *)weiboMessageToShare
{
    WBMessageObject *message = [WBMessageObject message];
    
    message.text = @"国金自选股 http://www.yongjinbao.com.cn";
    
    WBImageObject *image = [WBImageObject object];
    image.imageData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Icon" ofType:@"png"]];
    message.imageObject = image;
    
    return message;
}

- (void)share2QQZone
{
//    if (tencentOAuth.accessToken
//        && 0 != [tencentOAuth.accessToken length])
//    {
//        [self sendQQZoneTopic];
//    }
//    else
//    {
//        [tencentOAuth authorize:[TZTShareObject permissions] inSafari:YES];
//    }
    [self sendQQNewsMessage];
}

/**
 * upTopic.
 */
-(void)sendQQZoneTopic{
	
    NSLog(@"%@",[[NSBundle mainBundle] pathForResource:@"Icon" ofType:@"png"]);
    
//    TCAddShareDic *params = [TCAddShareDic dictionary];
//    params.paramTitle = @"国金自选股";
//    params.paramComment = @"国金自选股";
//    params.paramSummary =  @"简介";
//    params.paramImages = nil;
//    params.paramUrl = @"http://www.yongjinbao.com.cn/images/yj_ban.jpg";
//	
//	if(![tencentOAuth addShareWithParams:params]){
//        [self showInvalidTokenOrOpenIDMessage];
//    }
//    else{
//        [self showMessage:@"分享成功"];
//    }
    
//    TCAddTopicDic *params = [TCAddTopicDic dictionary];
//    params.paramRichtype = @"2";
//    params.paramRichval = @"http://www.yongjinbao.com.cn";
//    params.paramCon = @"国金自选股";
//    params.paramLbs_nm = @"国金自选股 Address";
//    params.paramThirdSource = @"2";
//    params.paramLbs_x = @"39.909407";
//    params.paramLbs_y = @"116.397521";
//	if(![tencentOAuth addTopicWithParams:params]){
//        [self showInvalidTokenOrOpenIDMessage];
//    }
	
}

- (void)share2TCWeiboPic
{
    //    [wbapi  cancelAuth];
    if (wbapi.accessToken.length > 0) {
        [self share2TCWeiboPicContent];
    }
    else
    {
        [wbapi loginWithDelegate:self andRootController:g_navigationController.topViewController];
    }
}

- (void)share2TCWeiboPicContent
{
    
    UIImage *pic = [UIImage imageNamed:@"Icon.png"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc]initWithObjectsAndKeys:@"json",@"format",
                                   @"国金自选股  http://www.yongjinbao.com.cn", @"content",
                                   pic, @"pic",
                                   nil];
    [wbapi requestWithParams:params apiName:@"t/add_pic" httpMethod:@"POST" delegate:self];
    
//    [pic release];
    [params release];
    
}

#pragma mark - ShowAlert

- (void)showInvalidTokenOrOpenIDMessage{
    UIAlertView *alert = [[[UIAlertView alloc]initWithTitle:@"api调用失败" message:@"可能授权已过期，请重新获取" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] autorelease];
    [alert show];
}

- (void)showMessage:(NSString *) message
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                    message:message
                                                   delegate:self
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:nil, nil];
    [alert show];
    [alert release];
}

- (void)showAuthMessage
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                    message:@"授权成功"
                                                   delegate:self
                                          cancelButtonTitle:@"取消"
                                          otherButtonTitles:@"继续发表", nil];
    alert.tag = 1001;
    [alert show];
    [alert release];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (alertView.tag == 1001)
        
    {
        
        if (buttonIndex == 1)
        {
            [self share2TCWeiboPicContent];
        }
    }
    if (alertView.tag == 1000) {
        [self respAppContent];
    }
}

@end
