//
//  TZTShareView.m
//  tztAjaxApp
//
//  Created by 在琦中 on 14-2-20.
//  Copyright (c) 2014年 zztzt. All rights reserved.
//

#import "TZTShareView.h"
#import "TZTShareObject.h"

#define BUFFER_SIZE             1024 * 100
#define ShareWhiteHeight 240
#define ShareBtnWidth 60

@interface TZTShareButton ()


@property(nonatomic, retain)NSString    *nsURL;
@property(nonatomic, retain)NSString    *nsTitle;
@property(nonatomic, retain)NSString    *nsContent;

@property(nonatomic,retain)NSMutableDictionary *pDictInfo;
@end

@implementation TZTShareButton

@synthesize text = _text, image = _image, tztShareType = _tztShareType;
@synthesize shareDelegate = _shareDelegate;
@synthesize nsURL = _nsURL;
@synthesize nsTitle = _nsTitle;
@synthesize nsContent = _nsContent;


- (id)initWithText:(NSString *)text image:(UIImage *)image
{
    self = [super init];
    if (self) {
        self.text = text;
        self.image = image;
        
        [self setup];
        
    }
    return self;
}

- (void)setup
{
    self.frame = CGRectMake(0, 0, ShareBtnWidth, ShareBtnWidth);
    self.backgroundColor = [UIColor clearColor];
    [self setImage:self.image forState:UIControlStateNormal];
    [self addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)dealloc
{
    DelObject(_pDictInfo);
    [super dealloc];
}

- (void) setShareInfo:(NSMutableDictionary*)pDict
{
    if (_pDictInfo == NULL)
    {
        _pDictInfo = NewObject(NSMutableDictionary);
    }
    
    [_pDictInfo removeAllObjects];
    for (int i = 0; i < [[pDict allKeys] count]; i++)
    {
        NSString *strKey = [[pDict allKeys] objectAtIndex:i];
        NSString *strValue = [pDict valueForKey:strKey];
        
        [_pDictInfo setObject:strValue forKey:strKey];
    }
    
//    NSString* strUrl = [pDictInfo tztObjectForKey:@"url"];
//    if (strUrl)
//        self.nsURL = [NSString stringWithFormat:@"%@", strUrl];
//    else
//        self.nsURL = @"";
//    
//    NSString* strTitle = [pDictInfo tztObjectForKey:@"title"];
//    if (strTitle)
//        self.nsTitle = [NSString stringWithFormat:@"%@", strTitle];
//    else
//        self.nsTitle = @"";
//    
//    NSString* strContent = [pDictInfo tztObjectForKey:@"message"];
//    if (strContent)
//        self.nsContent = [NSString stringWithFormat:@"%@", strContent];
//    else
//        self.nsContent = @"";
}

- (void)clickBtn:(UIButton *)button
{
    switch(self.tztShareType)
    {
        case TZTShareTypeSinaWeibo:
        {
            if (self.shareDelegate && [self.shareDelegate respondsToSelector:@selector(share2Weibo)])
                [self.shareDelegate share2Weibo];
        }
            break;
        case TZTShareTypeTencentWeibo:
        {
            if (self.shareDelegate && [self.shareDelegate respondsToSelector:@selector(share2TCWeiboPic)])
                [self.shareDelegate share2TCWeiboPic];
        }
            break;
        case TZTShareTypeQQSpace:
        {
            if (self.shareDelegate && [self.shareDelegate respondsToSelector:@selector(share2QQZone)])
                [self.shareDelegate share2QQZone];
        }
            break;
        case TZTShareTypeWeixiSession:
        {
            
            if (self.shareDelegate && [self.shareDelegate respondsToSelector:@selector(sendWeixinAppContentwithScene:)])
                [self.shareDelegate sendWeixinAppContentwithScene:WXSceneSession];
        }
            break;
        case TZTShareTypeWeixiTimeline:
        {
            
            if (self.shareDelegate && [self.shareDelegate respondsToSelector:@selector(sendWeixinAppContentwithScene:)])
                [self.shareDelegate sendWeixinAppContentwithScene:WXSceneTimeline];
        }
            break;
        case TZTShareTypeQQ:
        {
            if (self.shareDelegate && [self.shareDelegate respondsToSelector:@selector(sendQQNewsMessage)])
                [self.shareDelegate sendQQNewsMessage];
        }
            break;
        default:
            break;
    }
}

@end



extern WeiboApi        *wbapi;
extern TencentOAuth    *tencentOAuth;

@implementation TZTShareView

@synthesize title = _title;
@synthesize referView = _referView;
@synthesize blackBtn = _blackBtn;
@synthesize shareWhiteView = _shareWhiteView;
@synthesize btnArray = _btnArray;
@synthesize pDictInfo = _pDictInfo;
@synthesize tencentOAuth = _tencentOAuth;
@synthesize wbapi = _wbapi;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _btnArray = NewObject(NSMutableArray);
    }
    return self;
}

- (id)initWithTitle:(NSString *)title referView:(UIView *)referView
{
    self = [super init];
    if (self)
    {
        [TZTShareObject permissions];
#ifdef kWechatID
        //向微信注册
        NSLog(@"kWechatID%@", kWechatID);
        BOOL b = [WXApi registerApp:kWechatID];
#endif
        //向新浪微博注册
        [WeiboSDK enableDebugMode:YES];
#ifdef kAppKey
        NSLog(@"kAppKey%@", kAppKey);
        b = [WeiboSDK registerApp:kAppKey];
#endif
        
#ifdef kTencentAppID
        // 向QQ注册
        _tencentOAuth = [TZTShareObject tencentOAuthWithAppID:kTencentAppID withDelegate:self];
#endif
        // 向腾讯微博注册
#if (defined WiressSDKDemoAppKey && defined WiressSDKDemoAppSecret)
        _wbapi = [TZTShareObject wbapiWithApppKey:WiressSDKDemoAppKey andAppSecret:WiressSDKDemoAppSecret];
#endif
        
        self.title = title;
        if (referView)
        {
            self.referView = referView;
            [self viewDisplay];
        }
    }
    return self;
}

- (void)viewDisplay
{
    self.blackBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.blackBtn.frame = CGRectMake(0, 0, self.referView.frame.size.width, self.referView.frame.size.height - ShareWhiteHeight);
    [self.blackBtn setBackgroundColor:[UIColor blackColor]];
    self.blackBtn.alpha = 0.0;
    [self.blackBtn addTarget:self action:@selector(disappear) forControlEvents:UIControlEventTouchUpInside];
    [self.referView addSubview:self.blackBtn];
    
    _shareWhiteView = [[UIView alloc] initWithFrame:CGRectMake(0, self.referView.frame.size.height, self.referView.frame.size.width,  ShareWhiteHeight)];
    self.shareWhiteView.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.95];
    self.shareWhiteView.alpha = 0.3;
    [self.referView addSubview:self.shareWhiteView];
}

- (void)initShareWhiteView
{
    CGRect lbFrame;
    lbFrame.size.width = 100;
    lbFrame.size.height = 30;
    lbFrame.origin.x = (self.referView.frame.size.width - lbFrame.size.width)/ 2;
    lbFrame.origin.y = 5;
    
    UILabel *lable = [[UILabel alloc] initWithFrame:lbFrame];
    lable.text = self.title;
    lable.textColor = [UIColor blackColor];
    lable.textAlignment = NSTextAlignmentCenter;
    [self.shareWhiteView addSubview:lable];
    [lable release];
    
    CGRect cancleFrame;
    cancleFrame.size.width = self.referView.frame.size.width;
    cancleFrame.size.height = 30;
    cancleFrame.origin.x = 0;
    cancleFrame.origin.y = ShareWhiteHeight - lbFrame.size.height - 5;
    
    UIButton *cancleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancleBtn.frame = cancleFrame;
    [cancleBtn setBackgroundColor:[UIColor clearColor]];
    [cancleBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancleBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [cancleBtn addTarget:self action:@selector(disappear) forControlEvents:UIControlEventTouchUpInside];
    [self.shareWhiteView addSubview:cancleBtn];
    
    int i = 0;
    int xSpace = 28;
    int ySpace = 15;

    int x = (self.shareWhiteView.frame.size.width - ShareBtnWidth*3 - 2*xSpace)/ 2;
    int y = 50;
    
    for (UIButton *btn in _btnArray) {
        if (i < 3) {
            btn.frame = CGRectMake(x + i*(ShareBtnWidth+xSpace), y, ShareBtnWidth, ShareBtnWidth);
        }
        else
        {
            btn.frame = CGRectMake(x + (i - 3)*(ShareBtnWidth+xSpace), y + ShareBtnWidth + ySpace, ShareBtnWidth, ShareBtnWidth);
        }
        [self.shareWhiteView addSubview:btn];
        i ++;
    }
}

- (void)shareWhiteViewAdd:(UIButton *)btn
{
    [self.btnArray addObject:btn];
}

- (void) setShareInfo:(NSMutableDictionary*)pDict
{
    if (_pDictInfo == NULL)
    {
        _pDictInfo = NewObject(NSMutableDictionary);
    }
    
    [_pDictInfo removeAllObjects];
    for (int i = 0; i < [[pDict allKeys] count]; i++)
    {
        NSString *strKey = [[pDict allKeys] objectAtIndex:i];
        NSString *strValue = [pDict valueForKey:strKey];
        
        [_pDictInfo setObject:strValue forKey:strKey];
    }
}

- (void)disappear
{
//    [self.blackBtn setHidden:YES];
//    [self.shareWhiteView setHidden:YES];
    [UIView animateWithDuration:0.1f animations:^{
        self.blackBtn.alpha = 0.0;
        
    }];
    [UIView animateWithDuration:0.25f animations:^{
        self.shareWhiteView.frame = CGRectMake(0, self.referView.frame.size.height, self.referView.frame.size.width,  ShareWhiteHeight);
        self.shareWhiteView.alpha = 0.3;
        
    }];
    
}

- (void)showShareView
{
    [self.blackBtn setHidden:NO];
    [self.shareWhiteView setHidden:NO];
    [UIView animateWithDuration:0.25f animations:^{
        self.shareWhiteView.frame = CGRectMake(0, self.referView.frame.size.height - ShareWhiteHeight, self.referView.frame.size.width,  ShareWhiteHeight);
        self.shareWhiteView.alpha = 1.0;
        
    }];
    [UIView animateWithDuration:0.7f animations:^{
        self.blackBtn.alpha = 0.2;
        
    }];
}

#pragma mark WeChatBackDelegate - 微信
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

#pragma mark - WeiBoSinaBackDelegate －新浪微博

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
    
    NSString *strMessage = [self.pDictInfo tztObjectForKey:@"message"];
    if (strMessage.length < 1)
        strMessage = g_pSystermConfig.strMainTitle;
    if (strMessage.length > 140)
    {
        strMessage = [strMessage substringToIndex:130];
    }
    message.text = strMessage;// @"华西理财App http://42.121.107.194:7777/download/devhxsc/index.htm";
    WBImageObject *image = [WBImageObject object];
    image.imageData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Icon" ofType:@"png"]];
    message.imageObject = image;
    return message;
}


- (void)didReceiveWeiboResponse:(WBBaseResponse *)response
{
    NSLog(@"%@", response.description);
}

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

#pragma mark - QQBackDelegate － QQ认证

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

#pragma mark - TencentAuthDelegate - 腾讯认证

/**
 * Called when the user successfully logged in.
 */
- (void)tencentDidLogin
{
    if (_tencentOAuth.accessToken
        && 0 != [_tencentOAuth.accessToken length])
    {
        NSLog(@"%@",_tencentOAuth.accessToken);
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
	if (cancelled)
    {
		[self showMessage:@"用户取消登录"];
	}
	else
    {
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


- (void)sendQQNewsMessage
{
    NSData* data = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Icon" ofType:@"png"]];
    NSURL *url = nil;
    NSString *strUrl = [self.pDictInfo tztObjectForKey:@"url"];
    if (strUrl)
        url = [NSURL URLWithString:strUrl];
    NSString *strTitle = [self.pDictInfo tztObjectForKey:@"title"];
    if (strTitle.length < 1)
        strTitle = g_pSystermConfig.strMainTitle;
    
    NSString *strMessage = [self.pDictInfo tztObjectForKey:@"message"];
    if (strMessage.length < 1)
        strMessage = @"";
    if (strMessage.length > 512)//长度有限制，不能超过512个字
    {
        strMessage = [strMessage substringToIndex:500];
    }
	
    QQApiNewsObject* img = [QQApiNewsObject objectWithURL:url title:strTitle description:strMessage previewImageData:data];
    SendMessageToQQReq* req = [SendMessageToQQReq reqWithContent:img];
    BOOL sent = [QQApiInterface sendReq:req];
    [self handleSendResult:sent];
}

- (void)sendWeixinAppContentwithScene:(int)scene
{
    WXMediaMessage *message = [WXMediaMessage message];
    NSString *strUrl = [self.pDictInfo tztObjectForKey:@"url"];
    NSString *strTitle = [self.pDictInfo tztObjectForKey:@"title"];
    if (strTitle.length < 1)
        strTitle = g_pSystermConfig.strMainTitle;
    
    NSString *strMessage = [self.pDictInfo tztObjectForKey:@"message"];
    if (strMessage.length < 1)
        strMessage = @"";
    
    message.title = strTitle;
    message.description = strMessage;
    [message setThumbImage: [UIImage imageNamed:@"Icon"]];
    
    WXAppExtendObject *ext = [WXAppExtendObject object];
    ext.extInfo = @"<xml>extend info</xml>";
    if (strUrl.length > 0)
        ext.url = strUrl;
    
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
    [WXApi sendReq:req];
}

-(void)respAppContent
{
    WXMediaMessage *message = [WXMediaMessage message];
    NSString *strUrl = [self.pDictInfo tztObjectForKey:@"url"];
    NSString *strTitle = [self.pDictInfo tztObjectForKey:@"title"];
    if (strTitle.length < 1)
        strTitle = g_pSystermConfig.strMainTitle;
    
    NSString *strMessage = [self.pDictInfo tztObjectForKey:@"message"];
    if (strMessage.length < 1)
        strMessage = @"";
    
    message.title = strTitle;
    message.description = strMessage;
    [message setThumbImage:[UIImage imageNamed:@"Icon"]];
    
    WXAppExtendObject *ext = [WXAppExtendObject object];
    ext.extInfo = @"<xml>extend info</xml>";
    ext.url = strUrl;
    
    Byte* pBuffer = (Byte *)malloc(BUFFER_SIZE);
    memset(pBuffer, 0, BUFFER_SIZE);
    NSData* data = [NSData dataWithBytes:pBuffer length:BUFFER_SIZE];
    free(pBuffer);
    
    ext.fileData = data;
    
    message.mediaObject = ext;
    
    GetMessageFromWXResp* resp = [[[GetMessageFromWXResp alloc] init] autorelease];
    resp.message = message;
    resp.bText = NO;
    
    [WXApi sendResp:resp];
}

- (void)share2QQZone
{
    NSData* data = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Icon" ofType:@"png"]];
    NSURL *url = nil;
    NSString *strUrl = [self.pDictInfo tztObjectForKey:@"url"];
    if (strUrl)
        url = [NSURL URLWithString:strUrl];
    NSString *strTitle = [self.pDictInfo tztObjectForKey:@"title"];
    if (strTitle.length < 1)
        strTitle = g_pSystermConfig.strMainTitle;
    
    NSString *strMessage = [self.pDictInfo tztObjectForKey:@"message"];
    if (strMessage.length < 1)
        strMessage = @"";
    if (strMessage.length > 512)//长度有限制，不能超过512个字
    {
        strMessage = [strMessage substringToIndex:500];
    }
	
    QQApiNewsObject* img = [QQApiNewsObject objectWithURL:url title:strTitle description:strMessage previewImageData:data];
    SendMessageToQQReq* req = [SendMessageToQQReq reqWithContent:img];
    BOOL sent = [QQApiInterface SendReqToQZone:req];
    [self handleSendResult:sent];
    
//    if (_tencentOAuth.accessToken
//        && 0 != [_tencentOAuth.accessToken length])
//    {
//        [self sendQQZoneTopic];
//    }
//    else
//    {
//        [_tencentOAuth authorize:[TZTShareObject permissions] inSafari:YES];
//    }
    
}

/**
 * upTopic.
 */
-(void)sendQQZoneTopic
{
    NSLog(@"%@",[[NSBundle mainBundle] pathForResource:@"Icon" ofType:@"png"]);
    NSString *strUrl = [self.pDictInfo tztObjectForKey:@"url"];
    NSString *strTitle = [self.pDictInfo tztObjectForKey:@"title"];
    if (strTitle.length < 1)
        strTitle = g_pSystermConfig.strMainTitle;
    
    NSString *strMessage = [self.pDictInfo tztObjectForKey:@"message"];
    if (strMessage.length < 1)
        strMessage = @"";
    
    TCAddShareDic *params = [TCAddShareDic dictionary];
    params.paramTitle = strTitle;
    params.paramComment = strTitle;//@"华西理财";
    params.paramSummary =  strMessage;
    params.paramImages = nil;
    params.paramUrl = strUrl;// @"http://img1.gtimg.com/tech/pics/hv1/95/153/847/55115285.jpg";
	
	if(![_tencentOAuth addShareWithParams:params]){
        [self showInvalidTokenOrOpenIDMessage];
    }
    else
    {
        [self showMessage:@"分享成功"];
    }
	
}

- (void)share2TCWeiboPic
{
    if (_wbapi.accessToken.length > 0)
    {
        [self share2TCWeiboPicContent];
    }
    else
    {
        [_wbapi loginWithDelegate:self andRootController:g_navigationController.topViewController];
    }
}

- (void)share2TCWeiboPicContent
{
    UIImage *pic = [UIImage imageNamed:@"Icon.png"];
//    NSString *strUrl = [self.pDictInfo tztObjectForKey:@"url"];
    NSString *strTitle = [self.pDictInfo tztObjectForKey:@"title"];
    if (strTitle.length < 1)
        strTitle = g_pSystermConfig.strMainTitle;
    
    NSString *strMessage = [self.pDictInfo tztObjectForKey:@"message"];
    if (strMessage.length < 1)
        strMessage = @"";
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc]initWithObjectsAndKeys:@"json",@"format",
                                   strMessage, @"content",
                                   pic, @"pic",
                                   nil];
    [_wbapi requestWithParams:params apiName:@"t/add_pic" httpMethod:@"POST" delegate:self];
    [pic release];
    [params release];
}

#pragma mark - ShowAlert

- (void)showInvalidTokenOrOpenIDMessage
{
    UIAlertView *alert = [[[UIAlertView alloc]initWithTitle:@"api调用失败"
                                                    message:@"可能授权已过期，请重新获取"
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil, nil]
                          autorelease];
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
