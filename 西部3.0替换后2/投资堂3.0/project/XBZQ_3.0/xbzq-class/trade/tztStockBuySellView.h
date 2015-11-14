/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:        股票买卖
 * 文件标识:
 * 摘要说明:
 *
 * 当前版本:        2.0
 * 作    者:       yinjp
 * 更新日期:
 * 整理修改://zxl 20131019 自营修改了炒跟的弹出界面方式和键盘隐藏的处理
 *
 ***************************************************************/

#import "tztBaseTradeView.h"

@protocol tztStockBuySellViewDelegate <NSObject>
@optional
- (void)pushQHView; // 切换用的委托 byDBQ20130718
@end

#ifdef tzt_ChaoGen
#import "tztChaoGenView.h"

@interface tztStockBuySellView : tztBaseTradeView<tztUIAlertViewDelegate, UIAlertViewDelegate>
#else
@interface tztStockBuySellView : tztBaseTradeView<UIAlertViewDelegate, tztMutilScrollViewDelegate, tztHqBaseViewDelegate>
#endif
{
    tztUIVCBaseView         *_tztTradeView;
    tztUIVCBaseView         *_wudang;
    tztTrendView            *pTrend;
    
    NSString                *_CurStockCode;
    //
    NSString                *_CurStockName;
    //
    NSMutableArray          *_ayAccount;
    NSMutableArray          *_ayType;
    NSMutableArray          *_ayTypeContent;
    NSMutableArray          *_ayStockNum;
    NSMutableArray          *_ayTransType;//市价委托类型
    
    NSInteger                     _nAccountIndex;
    float                   _fMoveStep;
    int                     _nDotValid;
    
    BOOL                    _bBuyFlag;
    
    //退市整理标识
    int                     _nLeadTSFlag;
    //退市提示信息
    NSString                *_nsTSInfo;
    NSString                *_nsNewPrice;//现价
@private
    BOOL                    _bCanChange;
    
    id<tztStockBuySellViewDelegate> _tztStockDelegate; // 切换用的委托 byDBQ20130718
    
    
}

@property(nonatomic,retain)tztUIVCBaseView   *tztTradeView;
@property(nonatomic,retain)NSString             *CurStockCode;
@property(nonatomic,retain)NSString             *CurStockName;
@property(nonatomic,retain)NSMutableArray       *ayAccount;
@property(nonatomic,retain)NSMutableArray       *ayType;
@property(nonatomic,retain)NSMutableArray       *ayStockNum;
@property(nonatomic,retain)NSMutableArray       *ayTransType;
@property(nonatomic,retain)NSString             *nsTSInfo;
@property(nonatomic,retain)NSString             *nsNewPrice;
@property(nonatomic, retain)tztMutilScrollView *pMutilViews;
@property(nonatomic, retain)NSMutableArray *pAyViews;
@property BOOL  bBuyFlag;
@property(nonatomic,assign) id<tztStockBuySellViewDelegate> tztStockDelegate; // 切换用的委托 byDBQ20130718
@property(nonatomic,retain)NSString             *strCode; // xinlan 股票代码

@property (nonatomic,assign) NSInteger currentSelect;
//买卖确定
-(void)OnSendBuySell;
-(void)setStockCode:(NSString*)nsCode;
-(void)setCanChange:(BOOL)bChange;

/*
 函数功能：解析处理五档行情
 入参：数据解析类
 出参：无
 */
-(void)DealWithBuySell:(tztNewMSParse *)pParse;
@end
