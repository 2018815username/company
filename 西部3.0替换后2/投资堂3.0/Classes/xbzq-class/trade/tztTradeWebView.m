//
//  tztTradeWebView.m
//  tztMobileApp_GJUserStock
//
//  Created by King on 14-7-9.
//
//

#import "tztTradeWebView.h"

@implementation tztTradeWebView

//设置网页地址
-(void)setWebURL:(NSString*)strURL
{
    if (self.nsURL.length <= 0)
    {
        if (strURL && [strURL length] > 0)
            self.nsURL = [NSString stringWithFormat:@"%@", strURL];
        if (![self.nsURL hasPrefix:@"http://"] && ![self.nsURL hasPrefix:@"https://"])
        {
            self.nsURL = [NSString stringWithFormat:@"http://%@", strURL];
        }
        [super setWebURL:self.nsURL];
    }
    else
    {
        //只执行刷新
        [self tztStringByEvaluatingJavaScriptFromString:@"GoBackOnLoad();"];
    }
}
@end
