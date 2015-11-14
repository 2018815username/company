/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:        web展示vc
 * 文件标识:        
 * 摘要说明:        
 * 
 * 当前版本:        2.0
 * 作    者:       yinjp
 * 更新日期:            
 * 整理修改:	
 *
 ***************************************************************/

#import "TZTUIBaseViewController.h"
#import "tztWebView.h"


@interface tztWebViewController : TZTUIBaseViewController<tztHTTPWebViewDelegate>
{
    
    tztWebView          *_pWebView;
    NSString    *_nsURL;
    int         _nWebType;
    //是否显示工具栏
    int         _nHasToolbar;
    int         _nTitleType;//标题类型
    
    id          _tztDelegate;// ZXL 2013 界面功能回调用
    int         _ViewTag;//ZXL 20130718 界面区分
    BOOL        _bQianShu;//ZXL 20130718 国泰网页签署协议
    NSDictionary    *_dictWebParams;
}
@property(nonatomic, retain)tztWebView   *pWebView;
@property(nonatomic, retain)NSString    *nsURL;
@property int   nWebType;
@property int   nHasToolbar;
@property int   nTitleType;


@property(nonatomic,assign)id           tztDelegate;
@property int   ViewTag;
@property BOOL   bQianShu;
@property(nonatomic,retain)NSDictionary *dictWebParams;
//设置网页地址
-(void)setWebURL:(NSString *)nsURL;
//本地http
-(void)setLocalWebURL:(NSString*)nsURL;
//直接加载静态网页格式
-(void)LoadHtmlData:(NSString*)nsHTML;
//清空缓存url历史
-(void)CleanWebURL;

//
-(void)setRiskSign:(NSString*)nsSign;

-(BOOL)IsHaveWebView;
@end
