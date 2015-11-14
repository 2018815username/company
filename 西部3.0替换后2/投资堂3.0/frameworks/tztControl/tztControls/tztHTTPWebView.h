/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:        tztHTTPWebView.h
 * 文件标识:        webview基类
 * 摘要说明:        只处理webview加载、显示逻辑，具体业务请各自派生处理。
 *
 * 当前版本:        2.0
 * 作    者:       yangdl
 * 更新日期:
 * 整理修改:
 *
 ***************************************************************/

typedef NS_ENUM(NSInteger, tztHTTPWebViewLoadType) {
    tztHTTPWebViewTrue = 1,  //Load True
    tztHTTPWebViewFalse = 1 << 1, //Load FALSE
    tztHTTPWebViewContinue = 1 << 2, //继续加载
    tztHTTPWebViewBreak = 1 << 3, //中断加载
};

#import <UIKit/UIKit.h>
@class tztUIWebView;

@protocol tztUIWebViewDelegate <NSObject>
@optional
- (void) webView:(tztUIWebView*)webView didReceive:(int)nReces totals:(int)nTotals;
@end

@interface tztUIWebView: UIWebView
{
    id<tztUIWebViewDelegate> _tztdelegate;
    int _ntotals;
    int _nreces;
}
@property (nonatomic, assign) int ntotals;
@property (nonatomic, assign) int nreces;
@property (nonatomic,assign) id<tztUIWebViewDelegate> tztdelegate;
@end

@class UIProgressView;

@interface tztUIWebViewProgressBar : UIProgressView {
	UIColor *_tintColor;
    NSTimer *_animationTimer;
}
- (tztUIWebViewProgressBar *)initWithFrame:(CGRect)frame;
- (void)setProgress:(CGFloat)value animated:(BOOL)animated;
@end

@protocol tztHTTPWebViewDelegate;
@protocol takingPhotoDelegate;
@protocol BaseViewControllerDelegate;
@protocol CreateP10;

/**webview基类*/
@interface tztHTTPWebView : UIView <UIWebViewDelegate,tztUIWebViewDelegate>
{
    id<tztHTTPWebViewDelegate>  _tztDelegate;
}
/**系统webview的bounces效果,默认false*/
@property(nonatomic)  BOOL   bounces;
/**是否每个不同的url都创建一个新的webview，默认TRUE*/
@property(nonatomic)  BOOL   bnewviews;
/**是否使用黑色背景，默认YES；若指定clBackground，则该参数无效*/
@property(nonatomic)  BOOL   bblackground;
/**网页返回调用的js函数名称，默认GoBackOnLoad();*/
@property(nonatomic,retain)  NSString   *strJsGoBack;
/**网页背景颜色，使用该参数后，则bblackgournd无效，默认nil*/
@property(nonatomic,retain)  UIColor    *clBackground;
/**代理*/
@property(nonatomic,assign)id<tztHTTPWebViewDelegate>tztDelegate;
/**是否删除已经显示过的webview，默认FALSE*/
@property(nonatomic)  BOOL   bNotDelete;
/**webview scalesPageToFit属性设置，默认FALSE*/
@property(nonatomic)  BOOL   bScalesPageToFit;
/**https认证结果*/
@property(nonatomic,assign)BOOL isAuthed;
/**https认证时记录的request*/
@property(nonatomic,retain)NSURLRequest *riginRequest;


/**初始化页面数据*/
- (void)initdata;
/**设置URL,判断strURL是否有http://或者https://头，并自动补缺*/
-(void)setWebURL:(NSString*)strURL;
/**设置本地URL*/
-(void)setLocalWebURL:(NSString*)strURL;
/**设置HTML数据*/
-(void)LoadHtmlData:(NSString*)strHTML;
/**返回前一页*/
-(BOOL)OnReturnBack;
/**页面可返回*/
-(BOOL)canReturnBack;
/**获取网页标题*/
-(NSString*)getWebTitle;
/**关闭当前页面*/
-(void)closeCurHTTPWebView;
/**关闭所有页面*/
-(void)closeAllHTTPWebView;
/**关闭指定webview以外的其他所有view， 若返回TRUE，表示指定的webview存在，返回false，则是全部关闭了*/
-(BOOL)closeHttpWebViewWithOut:(UIWebView*)webView;
/**回到第一个webview，并关闭后面打开的所有webview,并执行该页面上的strJSGoBack函数*/
-(void)returnRootWebView;
/**回到第一个webview，并关闭后面打开的所有webview,并且bFlag＝TRUE时，执行该页面上的strJSGoBack函数*/
-(void)returnRootWebViewEx:(BOOL)bFlag;
/**获取最新显示的页面的URL*/
-(NSString*)getCurWebViewUrl;
/**获取当前的webview*/
-(UIWebView*)getCurWebView;
/**返回指定url对应webview，不存在，返回NULL*/
-(UIWebView*)webViewWithURL:(NSString*)nsURL;
/**滚动到webview顶部*/
-(void)scrollToTop;
/**当前是否有webview*/
-(BOOL)IsHaveWebView;
/**刷新制定位置web，nIndex==-1,刷新全部*/
-(void)RefreshWebView:(int)nIndex;
/**停止刷新*/
-(void)stopLoad;
/**处理webview url*/
-(tztHTTPWebViewLoadType)ontztWebURL:(UIWebView*)tztWebView strURL:(NSString *)strUrl WithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType;
/**执行页面js,对str内容进行decode处理后执行*/
-(void)tztStringByEvaluatingJavaScriptFromString:(NSString*)str;
/**执行页面js,根据bDecode=TRUE,对str内容进行decode处理后执行,否则不decode就执行*/
-(void)tztStringByEvaluatingJavaScriptFromString:(NSString*)str decode:(BOOL)bDecode;
/**根据状态 设置页面URL*/
- (void)tztSetNextUrl:(BOOL)bsucess;
/**处理完毕回调页面*/
- (void)tztSetNextUrl:(BOOL)bsucess resValue:(NSDictionary *)resDictionary;
/**获取列表*/
-(NSMutableArray*)GetAyWebViews;
/**页面是否可以滚动设置 bEnable＝TRUE，可滚动*/
-(void)setScrollEnable:(BOOL)bEnable;
@end

/**webview代理*/
@protocol tztHTTPWebViewDelegate <NSObject>
@optional
/**是否为第一个根webview*/
-(BOOL)tztWebViewIsRoot:(tztHTTPWebView*)webView;
/**是否可以执行return*/
-(BOOL)tztWebViewCanGoBack:(tztHTTPWebView*)webView;
/**返回页面标题供上层处理，取的是页面的document.title*/
-(void)tztWebView:(tztHTTPWebView *)webView withTitle:(NSString *)title;
/**新增webview*/
-(void)tztWebView:(tztHTTPWebView *)webView addSubView:(UIWebView *)subview;
/**页面加载完毕 成功或失败*/
-(void)tztWebViewDidFinishLoad:(tztHTTPWebView *)webView fail:(BOOL)bfail;
/**处理webview url*/
-(tztHTTPWebViewLoadType)tztWebView:(tztHTTPWebView *)webView withMsg:(NSString *)msg WithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType;
/**拍照*/
-(void)showCamera:(NSString*)strUrl;
@end
