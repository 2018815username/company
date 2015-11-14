//
//  tztBaseUIWebView.m
//  tztMobileApp
//
//  Created by yangares on 13-7-31.
//
//

#import "tztHTTPWebView.h"
#import <QuartzCore/QuartzCore.h>
#import <JavaScriptCore/JavaScriptCore.h>
@interface tztUIWebView()
-(id)webView:(id)view identifierForInitialRequest:(id)initialRequest fromDataSource:(id)dataSource;
-(void)webView:(id)view resource:(id)resource didFinishLoadingFromDataSource:(id)dataSource;
-(void)webView:(id)view resource:(id)resource didFailLoadingWithError:(id)error fromDataSource:(id)dataSource;
@end

@implementation tztUIWebView
@synthesize tztdelegate = _tztdelegate;
@synthesize ntotals = _ntotals;
@synthesize nreces = _nreces;
-(id)webView:(id)view identifierForInitialRequest:(id)initialRequest fromDataSource:(id)dataSource
{
    [super webView:view identifierForInitialRequest:initialRequest fromDataSource:dataSource];
    return [NSNumber numberWithInt:_ntotals++];
}

- (void)webView:(id)view resource:(id)resource didFailLoadingWithError:(id)error fromDataSource:(id)dataSource {
    [super webView:view resource:resource didFailLoadingWithError:error fromDataSource:dataSource];
    _nreces++;
    if ([self.tztdelegate respondsToSelector:@selector(webView:didReceive:totals:)]) {
        [self.tztdelegate webView:self didReceive:_nreces totals:_ntotals];
    }
}

-(void)webView:(id)view resource:(id)resource didFinishLoadingFromDataSource:(id)dataSource
{
    [super webView:view resource:resource didFinishLoadingFromDataSource:dataSource];
    _nreces++;
    if ([self.tztdelegate respondsToSelector:@selector(webView:didReceive:totals:)]) {
        [self.tztdelegate webView:self didReceive:_nreces totals:_ntotals];
    }
}

@end

@implementation tztUIWebViewProgressBar
- (void)drawRect:(CGRect)rect {
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGRect progressRect = rect;
    
    progressRect.size.width *= [self progress];
    
    CGContextSetFillColorWithColor(ctx, [_tintColor CGColor]);
    CGContextFillRect(ctx, progressRect);

    if (self.progress == 1.0f &&
        _animationTimer == nil) {
        _animationTimer = [NSTimer scheduledTimerWithTimeInterval:0.3 target:self selector:@selector(hideWithFadeOut) userInfo:nil repeats:YES];
    }
    
}

- (void) hideWithFadeOut {
    CATransition *animation = [CATransition animation];
    animation.type = kCATransitionFade;
    animation.duration = 0.5;
    [self.layer addAnimation:animation forKey:nil];
    self.hidden = YES;
    if (_animationTimer != nil) {
        [_animationTimer invalidate];
        _animationTimer = nil;
    }
}

- (void) setProgress:(CGFloat)value animated:(BOOL)animated {
    if ((!animated && value > self.progress) || animated) {
        self.progress = value;
    }
}

- (tztUIWebViewProgressBar *)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	if(self) {
        _tintColor = [[UIColor colorWithTztRGBStr:tztAppStringValue(tztappstringshttp, @"tztapp_http_progbarcolor",@"0,0,255")] retain];
		self.progress = 0;
        self.progressTintColor = _tintColor;
        self.trackTintColor = _tintColor;
	}
	return self;
}

- (void)dealloc {
    [_tintColor release];
    [_animationTimer release];
	[super dealloc];
}
@end


@interface tztHTTPWebView ()<tztSocketDataDelegate>
{
    BOOL _bGoBack;
    NSMutableArray* _ayWebView;
    NSMutableArray* _ayWebUrl;
    BOOL            _isAuthed;
    tztUIWebViewProgressBar* _progressBar;
}
- (void)initdata;
- (tztHTTPWebViewLoadType)onPretztWebURL:(UIWebView*)tztWebView strURL:(NSString *)strUrl WithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType;
- (tztHTTPWebViewLoadType)onfinishtztWebURL:(UIWebView*)tztWebView strURL:(NSString *)strUrl WithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType;

@end

@implementation tztHTTPWebView
@synthesize bounces = _bounces;
@synthesize bnewviews = _bnewviews;
@synthesize bblackground = _bblackground;
@synthesize strJsGoBack = _strJsGoBack;
@synthesize tztDelegate = _tztDelegate;
@synthesize clBackground = _clBackground;
@synthesize bNotDelete = _bNotDelete;
@synthesize bScalesPageToFit = _bScalesPageToFit;

+(void)initialize
{
    UIWebView *webView=[[UIWebView alloc] initWithFrame:CGRectZero];
    NSString *userAgent=[webView stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
    
    NSRange range = [[userAgent lowercaseString] rangeOfString:@"www.tzt.cn"];
    if (range.location != NSNotFound)
        return;
    NSDictionary *infoAgentDic = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"www.tzt.cn %@",userAgent],
                                  @"UserAgent",nil];
    [[NSUserDefaults standardUserDefaults] registerDefaults:infoAgentDic];
}

- (id)init
{
    self = [super init];
    if (self)
    {
        [self initdata];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self initdata];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initdata];
    }
    return self;
}

- (void)initdata
{
    self.tztDelegate = nil;
    self.bounces = FALSE;
    self.bnewviews = TRUE;
    self.bblackground = TRUE;
    self.strJsGoBack = @"GoBackOnLoad();";
    _bGoBack = FALSE;
    _bNotDelete = FALSE;
    self.clBackground = nil;
    if(_ayWebView == nil)
    {
        _ayWebView = NewObject(NSMutableArray);
    }
    if(_ayWebUrl == nil)
    {
        _ayWebUrl = NewObject(NSMutableArray);
    }
    int nShowPro = tztAppStringInt(tztappstringshttp, @"tztapp_http_progbarshow", 1);
    if (nShowPro)
    {
        if(_progressBar == nil){
            _progressBar = [[tztUIWebViewProgressBar alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.bounds.size.width, 1.5)];
            [self addSubview:_progressBar];
            [_progressBar release];
        }else{
            [_progressBar setFrame:CGRectMake(0.0f, 0.0f, self.bounds.size.width, 1.5f)];
        }
    }
}

- (void)dealloc
{
    [[tztMoblieStockComm getSharehqInstance] removeObj:self];
    DelObject(_ayWebView);
    DelObject(_ayWebUrl);
    NilObject(self.tztDelegate);
    [super dealloc];
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    if(_progressBar){
        _progressBar.frame = CGRectMake(0, 0, frame.size.width, 4.0f);
    }
    for (int i = 0; i < [_ayWebView count]; i++)
    {
        UIWebView* pView = [_ayWebView objectAtIndex:i];
        pView.frame = self.bounds;
        if (IS_TZTIOS(5))
        {
            pView.scrollView.bounces = _bounces;
        }
    }
}


- (void)setWebURL:(NSString*)strURL
{
    if(strURL && [strURL length] > 0)
    {
        if (![strURL hasPrefix:@"http://"] && ![strURL hasPrefix:@"https://"])
        {
            strURL = [NSString stringWithFormat:@"http://%@", strURL];
        }
        if([self setWebView:strURL])
            return ;
        UIWebView* pWebView = [_ayWebView lastObject];
        if(pWebView)
        {
            [self setWebViewRequest:pWebView strURL_:strURL];
        }
    }
}

- (void)setWebViewRequest:(UIWebView*)pWebView  strURL_:(NSString*)strURL
{
    NSString* strCrc = [tztHTTPServer MD5:strURL];
    NSString* strFormat = @"?";
    if([strURL rangeOfString:strFormat].length > 0)
    {
        strFormat = @"&";
    }
    
    NSURL *url = nil;
    
    NSString* nsUrl = strURL;
    if ([strURL hasPrefix:@"http://127.0.0.1"]
        || [strURL hasPrefix:@"https://127.0.0.1"])
    {
        url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@=%@",strURL,strFormat,tztIphoneREQUSTCRC,strCrc]];
        if(url == nil)
        {
            url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@=%@",[strURL tztencodeURLString],strFormat,tztIphoneREQUSTCRC,strCrc]];
        }
    }
    else
    {
        url = [NSURL URLWithString:nsUrl];
    }
    [pWebView stopLoading];
    NSMutableURLRequest* pRequest = [NSMutableURLRequest requestWithURL:url];
    if(_progressBar)
    {
        [_progressBar setHidden:FALSE];
        [_progressBar setProgress:0];
        [self bringSubviewToFront:_progressBar];
    }
    [self bringSubviewToFront:pWebView];
    
    [pWebView loadRequest:pRequest];
}

- (BOOL)setWebView:(NSString*)strURL
{
    if(strURL && [strURL length] > 0)
    {
        UIWebView* pWebView = nil;
        NSString* str = [NSString stringWithFormat:@"%@",strURL];
        if(_bnewviews)
        {
            NSArray* ayStr = [strURL componentsSeparatedByString:@"?"];
            if(ayStr && [ayStr count] > 0)
            {
                str = [NSString stringWithFormat:@"%@",[ayStr objectAtIndex:0]];
                NSUInteger nIndex = [_ayWebUrl indexOfObject:str];
                if(nIndex < [_ayWebUrl count] && nIndex < [_ayWebView count])
                {
                    pWebView = [_ayWebView objectAtIndex:nIndex];
                    if( (nIndex != [_ayWebView count]-1)) //不是当前显示webview
                    {
                        if (!_bNotDelete )
                        {
                            [pWebView removeFromSuperview];
                            [_ayWebView removeObjectAtIndex:nIndex];
                            [_ayWebUrl removeObjectAtIndex:nIndex];
                            pWebView = nil;
                        }
                        else
                        {
                            [_ayWebView moveObjectFromIndex:nIndex toIndex:[_ayWebView count] - 1];
                            [_ayWebUrl moveObjectFromIndex:nIndex toIndex:[_ayWebView count] - 1];
                            [self bringSubviewToFront:pWebView];
                            [pWebView stringByEvaluatingJavaScriptFromString:@"OnRefreshWebView();"];
                            //更改标题
                            NSString *title = [pWebView stringByEvaluatingJavaScriptFromString:@"document.title"];
                            if (_tztDelegate && [_tztDelegate respondsToSelector:@selector(tztWebView: withTitle:)])
                            {
                                [_tztDelegate tztWebView:self withTitle:title];
                            }
                            return TRUE;
                        }
                    }
                }
            }
        }
        else
        {
            pWebView = [_ayWebView lastObject];
        }
        
        if (pWebView == nil)
        {
            [self CreateWebView:str];
        }
    }
    return FALSE;
}

- (void)webView:(tztUIWebView *)webView didReceive:(int)nReces totals:(int)nTotals
{
    //Set progress value
    if(_progressBar){
        [_progressBar setProgress:((float)nReces) / ((float)nTotals) animated:NO];
    }
    if (nReces == nTotals) {
        webView.nreces = 0;
        webView.ntotals = 0;
        
        //加载结束
        if (_tztDelegate && [_tztDelegate respondsToSelector:@selector(tztWebViewDidFinishLoad: fail:)])
        {
            [_tztDelegate tztWebViewDidFinishLoad:self fail:NO];
        }
    }
}

-(void)CreateWebView:(NSString*)str
{
    tztUIWebView *pWebView = nil;
    if(pWebView == nil)
    {
        pWebView = [[tztUIWebView alloc] init];
        pWebView.tztdelegate = self;
        pWebView.delegate = self;
        pWebView.frame = self.bounds;
        pWebView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleBottomMargin;
        pWebView.suppressesIncrementalRendering = YES;
        pWebView.scalesPageToFit = _bScalesPageToFit;
        if (IS_TZTIOS(5))
        {
            pWebView.scrollView.bounces = _bounces;
        }
        id scroller = [pWebView.subviews objectAtIndex:0];
        for(UIView *subView in [scroller subviews])
        {
            if ([[[subView class] description] isEqualToString:@"UIScrollView"])
                ((UIScrollView*)subView).bounces = _bounces;
        }
        
        if (self.clBackground)
        {
//            self.backgroundColor  = [UIColor clearColor];//  self.clBackground;
            self.backgroundColor = self.clBackground;
            pWebView.backgroundColor = self.clBackground;
            [pWebView setOpaque:NO];
            pWebView.clearsContextBeforeDrawing = NO;
        }
        else if(_bblackground)
        {
            pWebView.backgroundColor = [UIColor blackColor];
            [pWebView setOpaque:NO];
            pWebView.clearsContextBeforeDrawing = NO;
        }
        
        //新增UIWebView
        if (_tztDelegate && [_tztDelegate respondsToSelector:@selector(tztWebView: addSubView:)])
        {
            [_tztDelegate tztWebView:self addSubView:pWebView];
        }
        [self addSubview:pWebView];
     
        //iOS7及以上才支持
        if (IS_TZTIOS(7))
        {
            JSContext *context = [pWebView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
            context[@"onWebdataEncrypt"] = ^()
            {
                NSArray *args = [JSContext currentArguments];
                NSString* strValue = @"";
                for (NSInteger i = 0; i < args.count; i++)
                {
                    JSValue *jsVal = [args objectAtIndex:i];
                    if (i == 0)
                    {
                        strValue = jsVal.toString;
                        break;
                    }
                }
                return [NSString tztEncryptData:strValue];
            };
        }
        
        [_ayWebView addObject:pWebView];
        [pWebView release];
        [_ayWebUrl addObject:str];
        
        //每次创建新的界面，都从定时器数组中移除，等收到定时刷新的10077请求后再加入
        [[tztMoblieStockComm getSharehqInstance] removeObj:self];
        //新增就修改
        if (_tztDelegate && [_tztDelegate respondsToSelector:@selector(tztWebViewCanGoBack:)])
        {
            [_tztDelegate tztWebViewCanGoBack:self];
        }
    }
}

- (void)setLocalWebURL:(NSString*)strURL
{
    if(strURL && [strURL length] > 0)
    {
        if([self setWebView:strURL])
            return;
        UIWebView* pWebView = [_ayWebView lastObject];
        if(pWebView)
        {
            NSString* strCrc = [tztHTTPServer MD5:strURL];
            NSString* strFormat = @"?";
            if([strURL rangeOfString:strFormat].length > 0)
            {
                strFormat = @"&";
            }
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@=%@",strURL,strFormat,tztIphoneREQUSTCRC,strCrc]];
            NSURLRequest* pRequest = [NSURLRequest requestWithURL:url];
            if(_progressBar){
                [_progressBar setHidden:FALSE];
                [self bringSubviewToFront:pWebView];
                [self bringSubviewToFront:_progressBar];
            }
            [pWebView loadRequest:pRequest];
        }
    }
}

- (void)LoadHtmlData:(NSString*)strHTML
{
    if(strHTML && [strHTML length] > 0)
    {
        [self setWebView:@"http://loadhtmldata"];
        UIWebView* pWebView = [_ayWebView lastObject];
        if (pWebView)
        {
            [pWebView loadHTMLString:strHTML baseURL:nil];
        }
    }
}

//根据状态 设置页面URL
- (void)tztSetNextUrl:(BOOL)bsucess
{
    
}

- (void)tztSetNextUrl:(BOOL)bsucess resValue:(NSDictionary *)resDictionary
{
    
}

-(void)tztStringByEvaluatingJavaScriptFromString:(NSString*)str decode:(BOOL)bDecode
{
    if (str == NULL || str.length <= 0)
        return;
    if ([_ayWebView count] > 0)
    {
        UIWebView* webView = [_ayWebView lastObject];
        NSString* strJS = str;
        if (bDecode)
            strJS = [str tztdecodeURLString];
        NSString* strResult = [webView stringByEvaluatingJavaScriptFromString:strJS];
        TZTLogInfo(@"%@",strResult);
        if ([str rangeOfString:@"webkitTextSizeAdjust"].length > 0)
        {
            NSString* strFile = @"tztFontSize";
            NSString* strURL = [strFile tztHttpfilepath];
            [str writeToFile:strURL atomically:YES encoding:NSUTF8StringEncoding error:nil];
        }
    }
}
//执行JS
-(void)tztStringByEvaluatingJavaScriptFromString:(NSString*)str
{
    [self tztStringByEvaluatingJavaScriptFromString:str decode:YES];
}

//是否可返回
-(BOOL)canReturnBack
{
    int ntztMin = 0;
    if (_tztDelegate && [_tztDelegate respondsToSelector:@selector(tztWebViewIsRoot:)])
    {
        if ([_tztDelegate tztWebViewIsRoot:self])
            ntztMin = 1;
    }
    
    if(_ayWebView)
    {
        UIWebView* pView = [_ayWebView lastObject];
        if(pView && [pView canGoBack])
        {
            return TRUE;
        }
        else if(pView && [_ayWebView count] > ntztMin && _bnewviews)
        {
            return TRUE;
        }
    }
    return FALSE;
}

//返回前一页面
- (BOOL)OnReturnBack
{
    int ntztMin = 0;
    if (_tztDelegate && [_tztDelegate respondsToSelector:@selector(tztWebViewIsRoot:)])
    {
        if ([_tztDelegate tztWebViewIsRoot:self])
            ntztMin = 1;
    }
    
    //返回，移除定时器,若前一界面要执行定时请求，则会在GoBackOnLoad中执行10077通知
    [[tztMoblieStockComm getSharehqInstance] removeObj:self];
    
    if(_ayWebView)
    {
        UIWebView* pView = [_ayWebView lastObject];
        if(pView && [pView canGoBack])
        {
            [self webViewDidCloseActiveIndicator:pView];
            [pView goBack];
            return TRUE;
        }
        else if(pView && [_ayWebView count] > ntztMin && _bnewviews)
        {
            [self webViewDidCloseActiveIndicator:pView];
            _bGoBack = FALSE;
            NSString *onJSGoBack = [pView stringByEvaluatingJavaScriptFromString:@"document.getElementById('GoBackOnLoad').value"];
            if(onJSGoBack && [onJSGoBack length] > 0)
            {
                self.strJsGoBack = [NSString stringWithFormat:@"%@",onJSGoBack];
            }
            
            if ([_ayWebView count] > 1)
            {
                pView.hidden = YES;
                [pView removeFromSuperview];
            }
            
            [_ayWebView removeLastObject];
            [_ayWebUrl removeLastObject];
            
            if (_tztDelegate && [_tztDelegate respondsToSelector:@selector(tztWebViewCanGoBack:)])
            {
                [_tztDelegate tztWebViewCanGoBack:self];
            }
            if ([_ayWebView count] > 0)
            {
                UIWebView* webView = [_ayWebView lastObject];
                _bGoBack = FALSE;
                [webView stringByEvaluatingJavaScriptFromString:self.strJsGoBack];
                
                NSString *title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
                if (_tztDelegate && [_tztDelegate respondsToSelector:@selector(tztWebView: withTitle:)])
                {
                    [_tztDelegate tztWebView:self withTitle:title];
                }
            }
            return ([_ayWebView count] > 0);
        }
    }
    return FALSE;
}

//停止加载
-(void)stopLoad
{
    UIWebView* pView = [_ayWebView lastObject];
    [pView stopLoading];
}

//关闭当前页面
-(void)closeCurHTTPWebView
{
    UIWebView* pView = [_ayWebView lastObject];
    if(pView && _bnewviews)
    {
        pView.hidden = YES;
        pView.delegate = nil;
        [pView removeFromSuperview];
        [_ayWebView removeLastObject];
        [_ayWebUrl removeLastObject];
        if (_tztDelegate && [_tztDelegate respondsToSelector:@selector(tztWebViewCanGoBack:)])
        {
            [_tztDelegate tztWebViewCanGoBack:self];
        }
        
        if ([_ayWebView count] > 0)
        {
            UIWebView* webView = [_ayWebView lastObject];
            
            if (_tztDelegate && [_tztDelegate respondsToSelector:@selector(tztWebView:withTitle:)])
            {
                [_tztDelegate tztWebView:self withTitle:[self getWebTitle]];
            }
            _bGoBack = FALSE;
            [webView stringByEvaluatingJavaScriptFromString:self.strJsGoBack];
        }
    }
}

//关闭所有页面
-(void)closeAllHTTPWebView
{
    UIWebView* pView = NULL;
    do {
        pView = [_ayWebView lastObject];
        if(pView)
        {
            [pView stopLoading];
            pView.hidden = YES;
            pView.delegate = nil;
            [pView removeFromSuperview];
            [_ayWebView removeLastObject];
            [_ayWebUrl removeLastObject];
        }
    }
    while (pView != NULL);
}

//获取当前URL
-(NSString*)getCurWebViewUrl
{
    if (_ayWebUrl && [_ayWebUrl count] > 0)
        return [_ayWebUrl lastObject];
    else
        return NULL;
}

//获取当前webView
-(UIWebView*)getCurWebView
{
    if (_ayWebView && [_ayWebView count] > 0)
        return [_ayWebView lastObject];
    return NULL;
}

//关闭指定webview以外的其他所有view， 若返回TRUE，表示指定的webview存在，返回false，则是全部关闭了
-(BOOL)closeHttpWebViewWithOut:(UIWebView*)webView
{
    if (_ayWebView == NULL || [_ayWebView count] < 1)
        return FALSE;
    if (webView == NULL)
    {
        [self closeAllHTTPWebView];
        return FALSE;
    }
    
    BOOL bFlag = FALSE;
    UIWebView* pWeb = NULL;
    for (int i = 0; i < [_ayWebView count]; i++)
    {
        pWeb = [_ayWebView objectAtIndex:i];
        if (pWeb == NULL || pWeb == webView)
        {
            bFlag = TRUE;
            continue;
        }
        
        pWeb.hidden = YES;
        pWeb.delegate = nil;
        [pWeb removeFromSuperview];
        [_ayWebView removeObjectAtIndex:i];
        [_ayWebView removeObjectAtIndex:i];
    }
    return bFlag;
}

//返回指定url对应webview
-(UIWebView*)webViewWithURL:(NSString*)nsURL
{
    if (nsURL == NULL || nsURL.length <= 0)
        return NULL;
    
    NSInteger nIndex = -1;
    if (![nsURL hasPrefix:@"http://"] && ![nsURL hasPrefix:@"https://"])
    {
        nsURL = [NSString stringWithFormat:@"http://%@", nsURL];
    }
    nIndex = [_ayWebUrl indexOfObject:nsURL];
    if (nIndex >= [_ayWebUrl count])
        nIndex = -1;
    
    if (nIndex < 0 || nIndex >= [_ayWebView count])
        return NULL;
    return [_ayWebView objectAtIndex:nIndex];
}

//返回到首页
-(void)returnRootWebViewEx:(BOOL)bFlag
{
    UIWebView *pView = NULL;
    pView = [_ayWebView lastObject];
    while (pView && [_ayWebView count] > 1)
    {
        if (pView)
        {
            pView.hidden = YES;
            pView.delegate = nil;
            [pView removeFromSuperview];
            [_ayWebView removeLastObject];
            [_ayWebUrl removeLastObject];
        }
        pView = [_ayWebView lastObject];
    }
    _bGoBack = FALSE;
    
    if (_tztDelegate && [_tztDelegate respondsToSelector:@selector(tztWebViewCanGoBack:)])
    {
        [_tztDelegate tztWebViewCanGoBack:self];
    }
    if (bFlag)
        [pView stringByEvaluatingJavaScriptFromString:self.strJsGoBack];
    
    NSString *title = [pView stringByEvaluatingJavaScriptFromString:@"document.title"];
    if (_tztDelegate && [_tztDelegate respondsToSelector:@selector(tztWebView: withTitle:)])
    {
        [_tztDelegate tztWebView:self withTitle:title];
    }
}

-(void)returnRootWebView
{
    [self returnRootWebViewEx:YES];
}

//获取当前显示页面标题
-(NSString*)getWebTitle
{
    if(_ayWebView && [_ayWebView count] > 0)
    {
        UIWebView* pView = [_ayWebView lastObject];
        if(pView )
        {
            return [pView stringByEvaluatingJavaScriptFromString:@"document.title"];
        }
    }
    return @"";
}
//页面滚动到顶部
-(void)scrollToTop
{
    if(_ayWebView && [_ayWebView count] > 0)
    {
        UIWebView* pView = [_ayWebView lastObject];
        if(pView )
        {
//                [scrollView setContentOffset:CGPointMake(0, 0) animated:YES]; //web会触发到底下的事件，华泰左侧web页面
            if (IS_TZTIOS(5))
            {
                UIScrollView* scrollView = pView.scrollView;
                scrollView.contentOffset = CGPointZero;
                [pView scrollViewDidScrollToTop:scrollView];
            }
            else if ([pView subviews] && [[pView subviews] count] > 1)
            {
                UIScrollView* scrollView = [[pView subviews] objectAtIndex:0];
                scrollView.contentOffset = CGPointZero;
                [pView scrollViewDidScrollToTop:scrollView];
            }
        }
    }
}

//关闭进度条滚轮
-(void)webViewDidCloseActiveIndicator:(UIWebView*)webView
{
    NSString* strHttp = @"http://action:10049/?show=2";
    [self ontztWebURL:webView strURL:strHttp WithRequest:nil navigationType:0];
}

-(void)webViewDidStartLoad:(UIWebView *)webView
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    NSString* strHttp = @"http://action:10049/?show=1";
    [self ontztWebURL:webView strURL:strHttp WithRequest:nil navigationType:0];
    if(_progressBar){
        [_progressBar setHidden:FALSE];
        [_progressBar setProgress:0];
        //        [self bringSubviewToFront:webView];
        [self bringSubviewToFront:_progressBar];
    }

}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    //设置标题
    if (webView == [_ayWebView lastObject])
    {
        NSString *title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
        if (_tztDelegate && [_tztDelegate respondsToSelector:@selector(tztWebView: withTitle:)])
        {
            [_tztDelegate tztWebView:self withTitle:title];
        }
    }
    //加载结束
    if (_tztDelegate && [_tztDelegate respondsToSelector:@selector(tztWebViewDidFinishLoad: fail:)])
    {
        [_tztDelegate tztWebViewDidFinishLoad:self fail:NO];
    }
    
    //新增就修改
    if (_tztDelegate && [_tztDelegate respondsToSelector:@selector(tztWebViewCanGoBack:)])
    {
        [_tztDelegate tztWebViewCanGoBack:self];
    }
    
    if(_bGoBack)
    {
        _bGoBack = FALSE;
        NSString *str = [webView stringByEvaluatingJavaScriptFromString:self.strJsGoBack];
        TZTLogInfo(@"%@",str);
    }
    [self webViewDidCloseActiveIndicator:webView];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    if([error code] == NSURLErrorCancelled)
    {
        return;
    }
    TZTLogInfo(@"webView didFailLoadWithError:\r\n%@",error);
    [self webViewDidCloseActiveIndicator:webView];
    if (_tztDelegate && [_tztDelegate respondsToSelector:@selector(tztWebViewDidFinishLoad: fail:)])
    {
        [_tztDelegate tztWebViewDidFinishLoad:self fail:YES];
    }
    _bGoBack = FALSE;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    TZTLogInfo(@"%@",request);
    NSString* scheme = [[request URL] scheme];
    TZTNSLog(@"scheme = %@",scheme);
    //判断是不是https
    if ([scheme caseInsensitiveCompare:@"https"] == NSOrderedSame)
    {
        //如果是https:的话，那么就用NSURLConnection来重发请求。从而在请求的过程当中吧要请求的URL做信任处理。
        if (!self.isAuthed)
        {
            self.riginRequest = request;
            NSURLConnection* conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
            [conn start];
            [webView stopLoading];
            return NO;        
        }    
    }
    NSString* strUrl = request.URL.absoluteString;
    if(strUrl && [strUrl length] > 0)
    {
        if([strUrl hasSuffix:@"/"]) //移除最后一个"/"
        {
            strUrl = [strUrl substringToIndex:([strUrl length] -1)];
        }
    }
    tztHTTPWebViewLoadType loadType = tztHTTPWebViewTrue | tztHTTPWebViewContinue;
    //调用webview url预处理函数
    loadType = [self onPretztWebURL:webView strURL:strUrl WithRequest:request navigationType:navigationType];
    if((loadType & tztHTTPWebViewBreak) == tztHTTPWebViewBreak)
        return ((loadType & tztHTTPWebViewTrue) == tztHTTPWebViewTrue);
    
    //调用回调接口
    if(_tztDelegate && [_tztDelegate respondsToSelector:@selector(tztWebView: withMsg: WithRequest: navigationType:)])
    {
        loadType = [_tztDelegate tztWebView:self withMsg:strUrl WithRequest:request navigationType:navigationType];
    }
    if((loadType & tztHTTPWebViewBreak) == tztHTTPWebViewBreak)
        return ((loadType & tztHTTPWebViewTrue) == tztHTTPWebViewTrue);
    
    //调用webview url处理函数
    loadType = [self ontztWebURL:webView strURL:strUrl WithRequest:request navigationType:navigationType];
    if((loadType & tztHTTPWebViewBreak) == tztHTTPWebViewBreak)
        return ((loadType & tztHTTPWebViewTrue) == tztHTTPWebViewTrue);
    
    //调用webview url预处理函数
    loadType = [self onfinishtztWebURL:webView strURL:strUrl WithRequest:request navigationType:navigationType];
    BOOL bTrue = ((loadType & tztHTTPWebViewTrue) == tztHTTPWebViewTrue);
    if(bTrue)
    {
        [self webViewDidCloseActiveIndicator:webView];
    }
    return bTrue;
}

//预处理 目前就处理了1964 关闭当前页面设置 新URL
-(tztHTTPWebViewLoadType)onPretztWebURL:(UIWebView*)tztWebView strURL:(NSString *)strUrl WithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    tztHTTPWebViewLoadType loadType = tztHTTPWebViewTrue | tztHTTPWebViewContinue;
    NSString* strUrlMsg = [strUrl lowercaseString];
    if ([strUrlMsg hasPrefix:tztHTTPAction] ) //处理action
    {
        NSString* strParam = @"";
        NSString* strAction = [strUrl substringFromIndex:[tztHTTPAction length]];
        NSRange paramRang = [strAction rangeOfString:@"?"];
        if( paramRang.location != NSNotFound)
        {
            strParam = [strAction substringFromIndex:paramRang.location+paramRang.length];
            strAction = [strAction substringToIndex:paramRang.location-1];
        }
        int nAction = [strAction intValue];
        if(nAction == AJAX_MENU_CloseCurWeb)//1964 关闭当前页面，设置新url
        {
            [self closeCurHTTPWebView];
        }
        else if (nAction == AJAX_MENU_CloseAllWeb)
        {
            //解析其中是否存在提示语
            NSMutableDictionary* pDict = [strParam tztNSMutableDictionarySeparatedByString:tztHTTPStrSep decodeurl:YES];
            NSString* strContent = nil;
            strContent = [pDict tztObjectForKey:@"content"];
            if (ISNSStringValid(strContent))
            {
                NSString* strTitle = [pDict tztObjectForKey:@"title"];
                tztAfxMessageBlockAnimated(strContent, strTitle, nil, TZTBoxTypeButtonBoth, ^(NSInteger nIndex)
                                   {
                                       if (nIndex == 0)//确定
                                       {
                                           //去掉后面参数，直接处理
                                           NSString *nsURL = @"http://action:3413/?";
                                           //调用回调接口
                                           if(_tztDelegate && [_tztDelegate respondsToSelector:@selector(tztWebView: withMsg: WithRequest: navigationType:)])
                                           {
                                               [_tztDelegate tztWebView:self withMsg:nsURL WithRequest:request navigationType:navigationType];
                                           }
                                           if((loadType & tztHTTPWebViewBreak) == tztHTTPWebViewBreak)
                                               return;
                                           
                                           //调用webview url处理函数
                                           [self ontztWebURL:tztWebView strURL:nsURL WithRequest:request navigationType:navigationType];
                                           if((loadType & tztHTTPWebViewBreak) == tztHTTPWebViewBreak)
                                               return;
                                           
                                           //调用webview url预处理函数
                                           [self onfinishtztWebURL:tztWebView strURL:nsURL WithRequest:request navigationType:navigationType];
                                           BOOL bTrue = ((loadType & tztHTTPWebViewTrue) == tztHTTPWebViewTrue);
                                           if(bTrue)
                                           {
                                               [self webViewDidCloseActiveIndicator:tztWebView];
                                           }
                                       }
                                   }, YES);
                return tztHTTPWebViewFalse|tztHTTPWebViewBreak;
            }
            
        }
        else if(nAction == 1901)//1901,修改底部tabbar图片显示
        {
            //截取url
            NSMutableDictionary* pDict = [strParam tztNSMutableDictionarySeparatedByString:tztHTTPStrSep decodeurl:YES];
            //存储数据
            NSString* nsFileName = tztTabbarStatusFile;
            NSString* strPath = [nsFileName tztHttpfilepath];
            NSError *error = nil;
            [pDict writeToFile:strPath atomically:YES];
            if (error)
            {
                TZTLogInfo(@"Action:1901,写文件出错，原因：%@",[error description]);
            }
            
            //通知上层进行tabbar处理
            NSNotification* pNotifi = [NSNotification notificationWithName:TZTNotifi_ChangeTabBarStatus object:[NSString stringWithFormat:@"%@",strParam]];
            [[NSNotificationCenter defaultCenter] postNotification:pNotifi];
            
            NSString *nsURL = [pDict tztObjectForKey:@"url"];
            //执行url
            if (nsURL && nsURL.length > 0)
            {
//                nsURL = [nsURL tztdecodeURLString];
                //调用回调接口
                if(_tztDelegate && [_tztDelegate respondsToSelector:@selector(tztWebView: withMsg: WithRequest: navigationType:)])
                {
                    [_tztDelegate tztWebView:self withMsg:nsURL WithRequest:request navigationType:navigationType];
                }
                if((loadType & tztHTTPWebViewBreak) == tztHTTPWebViewBreak)
                    return tztHTTPWebViewFalse|tztHTTPWebViewBreak;
                
                //调用webview url处理函数
                [self ontztWebURL:tztWebView strURL:nsURL WithRequest:request navigationType:navigationType];
                if((loadType & tztHTTPWebViewBreak) == tztHTTPWebViewBreak)
                    return tztHTTPWebViewFalse|tztHTTPWebViewBreak;
                
                //调用webview url预处理函数
                [self onfinishtztWebURL:tztWebView strURL:nsURL WithRequest:request navigationType:navigationType];
                BOOL bTrue = ((loadType & tztHTTPWebViewTrue) == tztHTTPWebViewTrue);
                if(bTrue)
                {
                    [self webViewDidCloseActiveIndicator:tztWebView];
                }
            }
            return tztHTTPWebViewFalse|tztHTTPWebViewBreak;
        }
        else if (nAction == TZT_MENU_WebTimer)
        {
            //加入定时请求
            [[tztMoblieStockComm getSharehqInstance] addObj:self];
        }
    }
    return loadType;
}

//后处理 防止没有进行一些特殊处理
-(tztHTTPWebViewLoadType)onfinishtztWebURL:(UIWebView*)tztWebView strURL:(NSString *)strUrl WithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    tztHTTPWebViewLoadType loadType = tztHTTPWebViewTrue | tztHTTPWebViewContinue;
    NSString* strUrllower = [strUrl lowercaseString];
    if ( [strUrllower hasPrefix:tztHTTPAction] )
    {
        return tztHTTPWebViewFalse | tztHTTPWebViewBreak;
    }
    else if ( [strUrllower hasPrefix:@"http://tel:"] )
    {
        return tztHTTPWebViewFalse | tztHTTPWebViewBreak;
    }
    else if ( [strUrllower hasPrefix:@"tel:"] )
    {
        return tztHTTPWebViewFalse | tztHTTPWebViewBreak;
    }
    else if ( [strUrllower hasPrefix:@"http://stock:"] )
    {
        return tztHTTPWebViewFalse | tztHTTPWebViewBreak;
    }
    
//    NSString* str = [strUrl tztdecodeURLString];
    NSUInteger nPosHash = [strUrl rangeOfString:@"#"].location;
    if(nPosHash != NSNotFound )
    {
        NSString* strOldUrl = tztWebView.request.URL.absoluteString;
        NSString* strNewUrl = [strUrl substringToIndex:nPosHash];
        if(strOldUrl && [strOldUrl hasPrefix:strNewUrl])
        {
            if(navigationType == UIWebViewNavigationTypeBackForward)
                _bGoBack = TRUE;
            return loadType;
        }
    }
    
    if([strUrl rangeOfString:[NSString stringWithFormat:@"&%@=",tztIphoneREQUSTCRC] options:NSCaseInsensitiveSearch ].length <= 0 && [strUrl rangeOfString:[NSString stringWithFormat:@"?%@=",tztIphoneREQUSTCRC] options:NSCaseInsensitiveSearch ].length <= 0 && [strUrl rangeOfString:@"127.0.0.1:" options:NSCaseInsensitiveSearch ].length > 0)
    {
        TZTLogWarn(@"New WebView");
        [self webViewDidCloseActiveIndicator:tztWebView];
        [self setWebURL:strUrl];
        return FALSE;
    }
    if(navigationType == UIWebViewNavigationTypeBackForward)
        _bGoBack = TRUE;
    return loadType;
}


-(tztHTTPWebViewLoadType)ontztWebURL:(UIWebView*)tztWebView strURL:(NSString *)strUrl WithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    tztHTTPWebViewLoadType loadType = tztHTTPWebViewTrue | tztHTTPWebViewContinue;
    return loadType;
}

-(BOOL)IsHaveWebView
{
    return ([_ayWebView count] > 0);
}

//刷新制定位置web，nIndex<0,刷新全部
-(void)RefreshWebView:(int)nIndex
{
    NSUInteger nCount = [_ayWebView count];
    if (nIndex == -1)
    {
        for (int i = 0; i < nCount; i++)
        {
            UIWebView *pWebView = [_ayWebView objectAtIndex:i];
            if (pWebView)
            {
                if (i < [_ayWebUrl count])
                {
                    NSString* strURL = [_ayWebUrl objectAtIndex:i];
                    if (strURL)
                    {
                        [self setWebViewRequest:pWebView strURL_:strURL];
                    }
                }
            }
        }
    }
    else
    {
        if (nIndex >= nCount)
            nIndex = 0;
        if (nIndex >= 0 && nIndex < nCount)
        {
            UIWebView *pWebView = [_ayWebView objectAtIndex:nIndex];
            if (pWebView)
            {
                if (nIndex < [_ayWebUrl count])
                {
                    NSString* strURL = [_ayWebUrl objectAtIndex:nIndex];
                    if (strURL)
                    {
                        [self setWebViewRequest:pWebView strURL_:strURL];
                    }
                }
            }
        }
    }
}

-(NSMutableArray*)GetAyWebViews
{
    return _ayWebView;
}

-(void)setScrollEnable:(BOOL)bEnable
{
    UIWebView* web = [self getCurWebView];
    if (web)
    {
        web.scrollView.scrollEnabled = bEnable;
    }
}

- (void)connection:(NSURLConnection *)connection willSendRequestForAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
    self.isAuthed = YES;
    //NSURLCredential 这个类是表示身份验证凭据不可变对象。凭证的实际类型声明的类的构造函数来确定。
    NSURLCredential* cre = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
    [challenge.sender useCredential:cre forAuthenticationChallenge:challenge];
}

- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace NS_DEPRECATED(10_6, 10_10, 3_0, 8_0, "Use -connection:willSendRequestForAuthenticationChallenge: instead.")
{
    return YES;
}

- (NSURLRequest *)connection:(NSURLConnection *)connection willSendRequest:(NSURLRequest *)request redirectResponse:(NSURLResponse *)response
{
    TZTNSLog(@"%@",request);
    return request;
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    self.isAuthed = YES;    //webview 重新加载请求。
    [self setWebURL:[[self.riginRequest URL] scheme]];
//    [[self getCurWebView] loadRequest:self.riginRequest];
    [connection cancel];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"%@", error);
}

-(NSUInteger)OnRequestData:(NSUInteger)wParam lParam_:(NSUInteger)lParam
{
    [self performSelectorOnMainThread:@selector(dealRefreshTimer)
                           withObject:nil
                        waitUntilDone:NO];
    return 1;
}

-(void)dealRefreshTimer
{
    //执行定时请求
    UIWebView* pView = [_ayWebView lastObject];
    if (pView.isLoading)
        return;
    [self tztStringByEvaluatingJavaScriptFromString:@"dealRefreshTimer();"];
}
@end
