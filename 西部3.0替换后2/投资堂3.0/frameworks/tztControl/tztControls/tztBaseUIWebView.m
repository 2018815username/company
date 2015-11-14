#import "tztBaseUIWebView.h"

@implementation tztBaseUIWebView

-(tztHTTPWebViewLoadType)ontztWebURL:(UIWebView*)tztWebView strURL:(NSString *)strUrl WithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    tztHTTPWebViewLoadType loadType =tztHTTPWebViewTrue | tztHTTPWebViewContinue;
#ifndef tzt_NoTrade
    NSString* strUrllower = [strUrl lowercaseString];
    if ( [strUrllower hasPrefix:@"http://tel:"] )
    {
        NSString* strTelCode = [strUrl substringFromIndex:[@"http://tel:" length]];
        NSString* strTelPhone = [NSString stringWithFormat:@"%@",strTelCode];
        [TZTUIBaseVCMsg OnMsg:HQ_MENU_TztTelPhone wParam:(NSUInteger)strTelPhone lParam:[strTelPhone length]];
        return tztHTTPWebViewFalse | tztHTTPWebViewBreak;
    }
    else if ( [strUrllower hasPrefix:@"tel:"] )
    {
        NSString* strTelCode = [strUrl substringFromIndex:[@"tel:" length]];
        NSString* strTelPhone = [NSString stringWithFormat:@"%@",strTelCode];
        [TZTUIBaseVCMsg OnMsg:HQ_MENU_TztTelPhone wParam:(NSUInteger)strTelPhone lParam:[strTelPhone length]];
        return tztHTTPWebViewFalse | tztHTTPWebViewBreak;
    }
    else if ( [strUrllower hasPrefix:@"http://stock:"] )
    {
        NSString* strStockCode = [strUrl substringFromIndex:[@"http://stock:" length]];
        if(strStockCode && [strStockCode length] > 0)
        {
            tztStockInfo* pStock = NewObject(tztStockInfo);
            pStock.stockCode = strStockCode;
            [TZTUIBaseVCMsg OnMsg:HQ_MENU_Trend wParam:(NSUInteger)pStock lParam:0];
            [pStock release];
        }
        return tztHTTPWebViewFalse | tztHTTPWebViewBreak;
    }
    else if ( [strUrllower hasPrefix:@"http://action:"] )
    {
        NSString* strAction = [strUrl substringFromIndex:[@"http://action:" length]];
        if(strAction && [strAction length] > 0)
        {
            if ([strAction intValue]== TZT_MENU_SignProtcol)
            {
//                NSString* strPath = strAction;
                NSString* strParam = @"";
                if(strAction && [strAction length] > 0)
                {
                    NSRange pathRang = [strAction rangeOfString:@"?"];
                    if(pathRang.location == NSNotFound) //不带参数
                    {
                        strParam = @"";
                    }
                    else
                    {
//                        strPath = [strAction substringToIndex:pathRang.location-1];
                        strParam = [strAction substringFromIndex:pathRang.location+pathRang.length];
                    }
                }
                if (_tztDelegate && [_tztDelegate respondsToSelector:@selector(setRiskSign:)])
                {
                    [_tztDelegate setRiskSign:strParam];
                }
            }
            else
            {
                    [TZTUIBaseVCMsg OnMsg:ID_MENU_ACTION wParam:(NSUInteger)strAction lParam:(NSUInteger)self];
            }
        }
        return tztHTTPWebViewFalse | tztHTTPWebViewBreak;
    }
#endif
//    
//    if([strUrl rangeOfString:[NSString stringWithFormat:@"&%@=",tztIphoneREQUSTCRC] options:NSCaseInsensitiveSearch ].length <= 0 && [strUrl rangeOfString:[NSString stringWithFormat:@"?%@=",tztIphoneREQUSTCRC] options:NSCaseInsensitiveSearch ].length <= 0 && [strUrl rangeOfString:@"127.0.0.1:" options:NSCaseInsensitiveSearch ].length > 0)
//    {
//        TZTLogInfo(@"New WebView");
//        [self setWebURL:strUrl];
//        return tztHTTPWebViewFalse | tztHTTPWebViewBreak;
//    }
//    if(navigationType == UIWebViewNavigationTypeBackForward)
//        _bGoBack = TRUE;
    
    return loadType;
}
@end