/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:        webview自定义
 * 文件标识:        
 * 摘要说明:        
 * 
 * 当前版本:        2.0
 * 作    者:       yinjp
 * 更新日期:            
 * 整理修改:	
 *
 ***************************************************************/

#import <UIKit/UIKit.h>
#import "tztBaseUIWebView.h"
enum
{
    tztWebOnline = 1,
    tztWebHudon,
    tztWebMessage,
    tztWebLoadHtml,
    tztWebInBox,
    tztWebCollect,
    tztWebHomeList,//华西首页点击出现
    tztwebChaoGen,//炒跟
    tztWebChaoGenSet,
    tztWebSelect,//网页需要操作的
    tztWebMyRoom, // 我的空间 byDBQ130904
    tztWebF10,  //图表F10
    
    tztWebMall = 100,//商城
    tztWebZhangTing, //掌厅
    tztWebTrade,    //交易
};

@interface tztWebView : tztBaseUIWebView<tztSocketDataDelegate>
{
    NSString        *_nsURL;
    int             _nWebType;
    int             _ntztReqNo;
    BOOL            _bQianShu;//ZXL 20130718 国泰网页签署协议
}
@property(nonatomic,retain)tztStockInfo* pStockInfo;
@property(nonatomic,retain)NSString     *nsURL;
@property   int     nWebType;
@property BOOL   bQianShu;
@property(nonatomic)BOOL bAddSwipe;



-(BOOL)OnToolbarMenuClick:(id)sender;
@end

@protocol tztWebViewDelegate <NSObject>
@optional
-(void)DealToolClick:(id)Sender;
-(void)DoSendFXCP:(int)nSocre;
@end
