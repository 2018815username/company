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
#ifndef __TZTBASETRADEVIEW_H__
#define __TZTBASETRADEVIEW_H__
#import "TZTUIBaseVCMsg.h"
@protocol tztUIRightSearchDelegate <NSObject>
@optional
-(void)DealSelectRow:(NSArray *)gridData StockCodeIndex:(NSInteger)index;
-(void)SetStockBySelectStock:(NSString *)stockcode StockName:(NSString *)name;
-(void)onOk:(NSString*)nsYLXX; // 预留查询 byDBQ20130924
- (void)presentSelf:(NSMutableDictionary*)dic; // 交易登录中推进连心锁代理 byDBQ20130930
@end


static NSString* tztAccount = @"tztAccount";
static NSString* tztAccountType = @"tztAccountType";
static NSString* tzzAccountNum = @"tztAccountNum";

@interface tztBaseTradeView : /*TZTUIBaseView*/UIView<tztSocketDataDelegate>
{
    NSInteger     _nMsgType;
    int     _ntztReqNo;
    id      _delegate;
    tztUITradeToolBarView   *_pTradeToolBar;
    NSMutableArray          *_ayToolBtn;
    int     _nRZRQHZStock;
    BOOL    _bDetailNew;
    BOOL    _bRequest;
}

@property(nonatomic,assign)id delegate;
@property(nonatomic,retain)tztUITradeToolBarView *pTradeToolBar;
@property(nonatomic,retain)NSMutableArray        *ayToolBtn;
@property NSInteger nMsgType;
@property int ntztReqNo;
@property BOOL bDetailNew;
@property int nRZRQHZStock;
@property BOOL bRequest;

-(BOOL)OnToolbarMenuClick:(id)sender;

-(void)OnRefresh;
//登出交易
-(void)OnNeedLoginOut;
//判断是否登出交易
+(BOOL)IsExitError:(int)nError;
-(void)ShowTool:(BOOL)bShow;
-(void)OnRequestData;
-(void)ClearData;

-(BOOL)OnDetail:(TZTUIReportGridView*)gridview ayTitle_:(NSMutableArray*)ayTitle dictIndex_:(NSMutableDictionary*)dictIndex;
-(BOOL)OnDetail:(TZTUIReportGridView*)gridview ayTitle_:(NSMutableArray*)ayTitle;
-(void)OnGridNextStock:(TZTUIReportGridView*)gridView ayTitle_:(NSMutableArray*)ayTitle;
-(void)OnGridPreStock:(TZTUIReportGridView*)gridView ayTitle_:(NSMutableArray*)ayTitle;
-(void)setToolBarBtn;
-(BOOL)isEqualMsgType:(NSInteger)nType;
-(void)SetDefaultData;
-(void)setStockCode:(NSString*)nsCode;
@end

#endif