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

#import "tztBaseTradeView.h"
#import "tztBaseUIWebView.h"
@protocol tztIPADWebViewMsgDelegate;
@interface tztIPADWebView :tztBaseUIWebView
{
    id<tztIPADWebViewMsgDelegate> _tztmsgdelegate;
}
@property (nonatomic,assign) id<tztIPADWebViewMsgDelegate>  tztmsgdelegate;
@end

@interface tztTradeWebView : tztBaseTradeView<tztHTTPWebViewDelegate,tztIPADWebViewMsgDelegate>
{
    tztIPADWebView * _pWebView;
    BOOL           _bShowReturnBtn;//zxl 20130926 是否显示返回按钮
    UIButton       *_ReturnBtn;//zxl 20130926 Ipad交易中网页嵌套的时候没有返回，在web上显示返回按钮
}
@property (nonatomic,retain)tztIPADWebView * pWebView;
@property (nonatomic,retain)NSString * nsUrl;
@property(nonatomic,retain)UIButton       *ReturnBtn;
@property int nUrlType;
@property BOOL bShowReturnBtn;
@end

@protocol tztIPADWebViewMsgDelegate <NSObject>
@optional
-(void)OnMsg:(NSInteger)nMsgType wParam:(NSUInteger)wParam lParam:(NSUInteger)lParam;
@end