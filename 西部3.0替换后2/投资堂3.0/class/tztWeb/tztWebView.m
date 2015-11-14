/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:        
 * 文件标识:        
 * 摘要说明:        
 * 
 * 当前版本:        2.0
 * 作    者:       yinjp
 * 更新日期:            
 * 整理修改:	
 *
 ***************************************************************/
#import "tztWebView.h"

#ifdef tzt_ChaoGen
#import "tztChaoGenKLineView.h"
#endif

@interface tztWebView()<UIGestureRecognizerDelegate>

@property(nonatomic,retain)UISwipeGestureRecognizer *swipeLeft;
@property(nonatomic,retain)UISwipeGestureRecognizer *swipeRight;

-(void)ClearCollect:(BOOL)bClear;
-(void)ClearInBox:(BOOL)bClear;
@end

@implementation tztWebView 
@synthesize nsURL = _nsURL;
@synthesize nWebType = _nWebType;
@synthesize bQianShu = _bQianShu;
@synthesize pStockInfo = _pStockInfo;
@synthesize bAddSwipe = _bAddSwipe;
@synthesize swipeLeft = _swipeLeft;
@synthesize swipeRight = _swipeRight;
-(id)init
{
    if (self = [super init])
    {
        _bQianShu = FALSE;
        if (g_nSkinType > 0)
        {
            self.clBackground = [UIColor tztThemeBackgroundColorJY];
        }
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame
{
    [super initWithFrame:frame];
    self.clBackground = [UIColor tztThemeBackgroundColorJY];
    return self;
}

-(void)dealloc
{
    [[tztMoblieStockComm getShareInstance] removeObj:self];
    [super dealloc];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    self.backgroundColor = [UIColor tztThemeBackgroundColorJY];
}

//设置网页地址
-(void)setWebURL:(NSString*)strURL
{
    if (strURL && [strURL length] > 0)
        self.nsURL = [NSString stringWithFormat:@"%@", strURL];
    if (![self.nsURL hasPrefix:@"http://"] && ![self.nsURL hasPrefix:@"https://"])
    {
        self.nsURL = [NSString stringWithFormat:@"http://%@", strURL];
    }
    [super setWebURL:self.nsURL];
}

-(void)setBAddSwipe:(BOOL)bSwipe
{
    _bAddSwipe = bSwipe;
    if (_bAddSwipe)
    {
        
        if (_swipeLeft == NULL)
        {
            _swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                                   action:@selector(SwipeLeftOrRight:)];
            _swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
            _swipeLeft.delegate = self;
            [self addGestureRecognizer:_swipeLeft];
            [_swipeLeft release];
        }
        if (_swipeRight == NULL)
        {
            _swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                                    action:@selector(SwipeLeftOrRight:)];
            _swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
            _swipeRight.delegate = self;
            [self addGestureRecognizer:_swipeRight];
            [_swipeRight release];
        }
    }
}

-(void)SwipeLeftOrRight:(UISwipeGestureRecognizer*)recognsizer
{
    if (self.tztDelegate && [self.tztDelegate respondsToSelector:@selector(tztOnSwipe:andView_:)])
    {
        [self.tztDelegate tztOnSwipe:recognsizer andView_:self];
    }
    
}

-(void)setLocalWebURL:(NSString*)strURL
{
    NSURL* url = [NSURL URLWithString:strURL];
    self.nsURL = [NSString stringWithFormat:@"%@", url];
    [super setLocalWebURL:self.nsURL];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if(![super webView:webView shouldStartLoadWithRequest:request navigationType:navigationType])
        return FALSE;
    else
    {
//        TZTLogInfo(@"%@",request);
        NSString* strUrl = request.mainDocumentURL.absoluteString;
        if(strUrl && [strUrl length] > 0)
        {
            if([strUrl hasSuffix:@"/"]) //移除最后一个"/"
            {
                strUrl = [strUrl substringToIndex:([strUrl length] -1)];
            }
        }
#ifndef tzt_NoTrade
        NSString* strUrllower = [strUrl lowercaseString];
        if([strUrllower hasPrefix:@"http://www.hx168.com.cn"]
           ||[strUrllower hasPrefix:@"https://www.hx168.com.cn"])
        {
            BOOL bFlag = TRUE;
            NSMutableDictionary* paramvalue = [[[NSMutableDictionary alloc] init] autorelease];
            NSArray* pAy = [strUrl componentsSeparatedByString:@"?"];
            if (pAy && [pAy count] > 1)
            {
                NSString* strParam = [pAy objectAtIndex:1];
                NSArray *ayParam = [strParam componentsSeparatedByString:@"&"];
                if (ayParam && [ayParam count] > 0)
                {
                    tztJYLoginInfo* pCurJyLoginInfo = [tztJYLoginInfo GetCurJYLoginInfo:TZTAccountPTType];
                    for (int i = 0; i < [ayParam count]; i++)
                    {
                        NSString* strParamValue = [ayParam objectAtIndex:i];
                        if (strParamValue && [strParamValue length] > 0)
                        {
                            NSArray* ayValue = [strParamValue componentsSeparatedByString:@"="];
                            if (ayValue && [ayValue count] == 2)
                            {
                                NSString* strKey = [ayValue objectAtIndex:0];
                                NSString* strValue = [ayValue objectAtIndex:1];
                                NSMutableString *s = [NSMutableString stringWithString:strValue];
                                NSRange beginRang = [s rangeOfString:@"($"];
                                if (beginRang.location == NSNotFound)
                                {
                                    [paramvalue setTztValue:s forKey:strKey];
                                }
                                while(beginRang.location != NSNotFound && [s length] > 0)
                                {
                                    bFlag = FALSE;
                                    NSRange searchRange = NSMakeRange(beginRang.location,[s length] - beginRang.location);
                                    NSRange endRang = [s rangeOfString: @")" options:0 range:searchRange];
                                    if(endRang.location != NSNotFound)
                                    {
                                        NSRange repRang = NSMakeRange(beginRang.location,NSMaxRange(endRang)- beginRang.location);
                                        NSString* strReplace = [s substringWithRange:repRang];
                                        NSRange keyRang = NSMakeRange(beginRang.length, [strReplace length]- beginRang.length - endRang.length );
                                        NSString* strRepKey = [strReplace substringWithRange:keyRang];
                                        NSString* strRepValue = @"";
#ifndef tzt_NoTrade
                                        if([tztHTTPData getShareInstance] && [[tztHTTPData getShareInstance] respondsToSelector:@selector(getlocalValueExten:withJyLoginInfo:)])
                                        {
                                            strRepValue = [[tztHTTPData getShareInstance] getlocalValueExten:strRepKey withJyLoginInfo:pCurJyLoginInfo];
                                        }
#endif
                                        if(strRepValue == nil || [strRepValue length] <= 0)
                                            strRepValue = [[tztHTTPData getShareInstance] getlocalValue:strRepKey];
                                        
                                        if(strRepValue)
                                            [s replaceOccurrencesOfString:strReplace withString:strRepValue options:NSCaseInsensitiveSearch range:NSMakeRange(0,[s length])];
                                        
                                        if ([s length] > endRang.location)
                                        {
                                            searchRange = NSMakeRange(endRang.location,[s length] - endRang.location);
                                        }
                                        else
                                        {
                                            searchRange = NSMakeRange(0, [s length]);
                                        }
                                        beginRang = [s rangeOfString:@"($" options:NSCaseInsensitiveSearch range:searchRange];
                                    }
                                    else
                                    {
                                        break;
                                    }
                                    [paramvalue setTztValue:s forKey:strKey];
                                }
                            }
                        }
                    }
                }
                
                if (!bFlag)
                {
                    //重新组织url
                    NSString* nsUrl = [NSString stringWithFormat:@"%@?",[pAy objectAtIndex:0]];
                    NSArray *ayKey = [paramvalue allKeys];
                    for (int i = 0; i < [ayKey count]; i++)
                    {
                        NSString* strKey = [ayKey objectAtIndex:i];
                        NSString* strValue = [paramvalue tztObjectForKey:strKey];
                        strKey = [strKey lowercaseString];
                        if (i == [ayKey count] - 1)
                        {
                            nsUrl = [NSString stringWithFormat:@"%@%@=%@",nsUrl, strKey, strValue];
                        }
                        else
                        {
                            nsUrl = [NSString stringWithFormat:@"%@%@=%@&",nsUrl, strKey, strValue];
                        }
                    }
                    
                    [self setWebURL:nsUrl];
                    return FALSE;
                }
            }
            else
            {
                [self setWebURL:strUrllower];
                return FALSE;
            }
        }
#endif
        //ZXL 2013 国泰风险测评返回测评分数处理
        if (self.tag == 1122)
        {
            if (strUrllower && [strUrllower length] > 0)
            {
                NSString* nsSum = @"";
                NSRange xrange=[strUrllower rangeOfString:@"sum="];
                
                if (xrange.location > 0 && (xrange.location + xrange.length) < [strUrllower length])
                {
                    nsSum = [strUrllower substringFromIndex:(xrange.location + xrange.length)];
                }
                
                if (nsSum && [nsSum length] > 0)
                {
                    if (_tztDelegate && [_tztDelegate respondsToSelector:@selector(DoSendFXCP:)])
                    {
                        [g_navigationController popViewControllerAnimated:NO];
                        [_tztDelegate DoSendFXCP:[nsSum intValue]];
                    }
                    return NO;
                }
            }
        }
    }
    return true;
}


-(BOOL)OnToolbarMenuClick:(id)sender
{
    UIButton *pBtn = (UIButton*)sender;
    switch (pBtn.tag)
    {         
        case 1234:
        {
#ifndef tzt_NoTrade             
            UIViewController* pVC = g_navigationController.topViewController;
            
            if (pVC && [pVC isKindOfClass:[TZTUIBaseViewController class]])
            {
                [(TZTUIBaseViewController*)pVC PopViewControllerDismiss];
            }
#endif
            [g_navigationController popViewControllerAnimated:UseAnimated];
            return TRUE;
        }
            break;
        case TZTToolbar_Fuction_Clear://清空
        {
            //清空数据
            if (_nWebType == tztWebCollect)
            {
                [self ClearCollect:FALSE];
            }
            else if(_nWebType == tztWebInBox)
            {
                [self ClearInBox:FALSE];
            }
            
            return TRUE;
        }
            break;
        //ZXL 20130718 国泰网页签署协议处理
        case TZTToolbar_Fuction_QianShu:
        {
            if (self.tztDelegate && [self.tztDelegate respondsToSelector:@selector(DealToolClick:)])
            {
                [_tztDelegate tztperformSelector:@"DealToolClick:" withObject:self];
//                [self.tztDelegate DealToolClick:self];
            }
            return TRUE;
        }
            break;
        default:
            break;
    }
    
    return FALSE;
}


-(void)ClearCollect:(BOOL)bClear
{
    if (!bClear)
    {
        [self showMessageBox:@"确定清空收藏夹记录？ "
                      nType_:TZTBoxTypeButtonBoth
                       nTag_:0x1111
                   delegate_:self
                  withTitle_:@"清空收藏夹"
                       nsOK_:@"清空"
                   nsCancel_:@"取消"];
        return;
    }
    
    NSString* nsFileName = @"InfoCenterMyNews";
    NSString* strPath = [nsFileName tztHttpfilepath];
    NSData *pData = NewObjectAutoD(NSData);
    [pData writeToFile:strPath atomically:YES];
    //重新刷新界面
    [self setWebURL:nil];
}

-(void)ClearInBox:(BOOL)bClear
{
    if (!bClear)
    {
        [self showMessageBox:@"确定清空收件箱？ "
                      nType_:TZTBoxTypeButtonBoth
                       nTag_:0x1112
                   delegate_:self
                  withTitle_:@"清空收件箱"
                       nsOK_:@"清空"
                   nsCancel_:@"取消"];
        return;
    }
    
    
    NSMutableDictionary* pDict = NewObject(NSMutableDictionary);
    [[tztMoblieStockComm getShareInstance] addObj:self];
    _ntztReqNo++;
    if (_ntztReqNo >= UINT16_MAX)
        _ntztReqNo = 1;
    NSString* strReqno = tztKeyReqno((long)self, _ntztReqNo);
    [pDict setTztValue:strReqno forKey:@"Reqno"];
    [pDict setTztValue:@"!" forKey:@"id"];/*zx_id改成了id,20130529 yinjp*/
    [[tztMoblieStockComm getShareInstance] onSendDataAction:@"41047" withDictValue:pDict];
    DelObject(pDict);
}

- (NSUInteger)OnCommNotify:(NSUInteger)wParam lParam_:(NSUInteger)lParam
{
    tztNewMSParse *pParse = (tztNewMSParse*)wParam;
    if (pParse == NULL)
        return 0;
    
    if (![pParse IsIphoneKey:(long)self reqno:_ntztReqNo])
        return 0;
    
    if ([pParse IsAction:@"41047"])
    {
        int nErrorNo = [pParse GetErrorNo];
        NSString* strErrMsg = [pParse GetErrorMessage];
        if (strErrMsg)
            [self showMessageBox:strErrMsg nType_:TZTBoxTypeNoButton nTag_:0 delegate_:nil withTitle_:@"清空收件箱"];
        
        if (nErrorNo >= 0)//处理成功，重新刷新界面
        {
            [self setWebURL:nil];
        }
        
    }
    return 1;
}

- (void)TZTUIMessageBox:(TZTUIMessageBox *)TZTUIMessageBox clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        switch (TZTUIMessageBox.tag)
        {
            case 0x1111:
            {
                [self ClearCollect:YES];
            }
                break;
            case 0x1112:
            {
                [self ClearInBox:YES];
            }
                break;
            default:
                break;
        }
    }
}

//zxl 20131022自营炒跟K线界面特殊处理
-(BOOL)OnReturnBack
{
    if (_nWebType == tztwebChaoGen)
    {
        BOOL Find = FALSE;
#ifdef tzt_ChaoGen
        for ( UIView * pView in self.subviews)
        {
            if ([pView isKindOfClass:[tztChaoGenKLineView class]])
           {
                Find = TRUE;
                [pView removeFromSuperview];
                break;
            }
        }
#endif
        if (!Find)
        {
            return [super OnReturnBack];
        }
        return TRUE;
    }else
    {
        return [super OnReturnBack];
    }
    return FALSE;
}

@end
