/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:       IPAD web展示
 * 文件标识:
 * 摘要说明:
 *
 * 当前版本:        2.0
 * 作    者:       zxl
 * 更新日期:
 * 整理修改:
 *
 ***************************************************************/

#import "tztTradeWebView.h"

@implementation tztIPADWebView
@synthesize tztmsgdelegate = _tztmsgdelegate;

-(tztHTTPWebViewLoadType)ontztWebURL:(UIWebView*)tztWebView strURL:(NSString *)strUrl WithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
//-(tztHTTPWebViewLoadType)ontztWebURL:(NSString *)strUrl WithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType //IPAD webview逻辑处理
{
    tztHTTPWebViewLoadType loadType = tztHTTPWebViewTrue | tztHTTPWebViewContinue;
    NSString* strUrlMsg = [strUrl lowercaseString];
    if ([strUrlMsg hasPrefix:@"http://action:"] ) //处理action
    {
        NSString* strParam = @"";
        NSString* strAction = [strUrlMsg substringFromIndex:[@"http://action:" length]];
        NSRange paramRang = [strAction rangeOfString:@"?"];
        if( paramRang.location != NSNotFound)
        {
            strParam = [strAction substringFromIndex:paramRang.location+paramRang.length];
            strAction = [strAction substringToIndex:paramRang.location-1];
        }
        int nAction = [strAction intValue];
        switch (nAction)
        {
            case AJAX_MENU_CloseAllWeb:
            case 19018://zxl 20131022 天天发 申购返回处理
            {
                if(_tztmsgdelegate && [_tztmsgdelegate respondsToSelector:@selector(OnMsg: wParam: lParam:)])
                {
                    [_tztmsgdelegate OnMsg:nAction wParam:(NSUInteger)strParam lParam:(NSUInteger)strUrl];
                }
            }
                break;
            case 10002://返回
            {
                if(_tztmsgdelegate && [_tztmsgdelegate respondsToSelector:@selector(OnReturnBack)])
                {
                    [_tztmsgdelegate OnReturnBack];
                }
            }
                break;
            default:
                break;
        }
        return tztHTTPWebViewFalse | tztHTTPWebViewBreak;
    }
    return loadType;
}

@end


@implementation tztTradeWebView
@synthesize pWebView = _pWebView;
@synthesize nsUrl  = _nsUrl;
@synthesize nUrlType = _nUrlType;
@synthesize bShowReturnBtn = _bShowReturnBtn;
@synthesize ReturnBtn = _ReturnBtn;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.nsUrl = @"";
        self.nUrlType = 0;
    }
    return self;
}
-(void)setFrame:(CGRect)frame
{
    if (CGRectIsNull(frame) || CGRectIsEmpty(frame))
        return;
    
    [super setFrame:frame];
    CGRect rcFrame = frame;
    if (_pWebView == nil)
    {
        _pWebView = [[tztIPADWebView alloc] initWithFrame:rcFrame];
        _pWebView.tztDelegate = self;
        _pWebView.tztmsgdelegate = self;
        if (![self.nsUrl hasPrefix:@"http://"] && ![self.nsUrl hasPrefix:@"https://"])
        {
            self.nsUrl = [NSString stringWithFormat:@"http://%@", self.nsUrl];
        }
        [_pWebView setWebURL:self.nsUrl];
        [self addSubview:_pWebView];
        [_pWebView release];
    }else
    {
        _pWebView.frame = rcFrame;
    }
    
    rcFrame.origin.y  = 10;
    rcFrame.size.width = 60;
    rcFrame.origin.x = frame.size.width - rcFrame.size.width - 10;
    rcFrame.size.height = 55;
    // zxl 20130927 ipad 嵌套的web 添加返回按钮
    if (self.ReturnBtn == NULL)
    {
        self.ReturnBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.ReturnBtn setTztBackgroundImage:[UIImage imageTztNamed:@"TZTnavbarbackbg.png"]];
        [self.ReturnBtn addTarget:self action:@selector(OnReturnBack) forControlEvents:UIControlEventTouchUpInside];
        self.ReturnBtn.frame = rcFrame;
        [self addSubview:self.ReturnBtn];
        self.ReturnBtn.hidden = YES;
    }else
        self.ReturnBtn.frame = rcFrame;
    
    if (!self.bShowReturnBtn)
    {
        self.ReturnBtn.hidden = YES;
    }else
        self.ReturnBtn.hidden = NO;
    
    [self bringSubviewToFront:self.ReturnBtn];
}

-(BOOL)tztWebViewIsRoot:(tztHTTPWebView*)webView
{
    return TRUE;
}

-(void)OnRequestData
{
    if (self.pWebView)
    {
//        [self.pWebView closeCurHTTPWebView];
        [self.pWebView setWebURL:self.nsUrl];
    }
}
-(void)OnReturnBack
{
    if (self.pWebView)
    {
        [self.pWebView OnReturnBack];
    }
}

-(BOOL)OnToolbarMenuClick:(id)sender
{
    UIButton* pBtn = (UIButton*)sender;
    switch (pBtn.tag)
    {
        case TZTToolbar_Fuction_QuXiao:
        {
            if (self.pWebView)
            {
                [self.pWebView OnReturnBack];
            }
            return TRUE;
        }
            break;
        default:
            break;
    }
    return FALSE;
}

-(void)OnMsg:(NSInteger)nMsgType wParam:(NSUInteger)wParam lParam:(NSUInteger)lParam
{
    switch (nMsgType)
    {
        case AJAX_MENU_CloseAllWeb: //3413
        {
            //zxl 20131022 清空当前页面
            if (self.delegate && [self.delegate respondsToSelector:@selector(ShutDownCurView)])
            {
                [self.delegate ShutDownCurView];
            }
        }
            break;
        case 19018://zxl 20131022 天天发 申购返回处理
        {
            if (self.delegate && [self.delegate respondsToSelector:@selector(OnMsg:wParam:lParam:)])
            {
                [self.delegate OnMsg:MENU_JY_XJB_ShenGou wParam:0 lParam:0];
            }
        }
            break;
        default:
            break;
    }
}
@end
