/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:        ipad查询界面（在新的ipad查询界面上添加一个工具条界面上面放置刷新、撤单等 除去那些有时间查询的界面）
 * 文件标识:
 * 摘要说明:
 *
 * 当前版本:        2.0
 * 作    者:       zhangxl
 * 更新日期:
 * 整理修改:
 *
 ***************************************************************/

#import "tztTradeAddSearchView_ipad.h"
#import "tztStockBuySellView.h"

#ifdef Support_SBTrade
#import "tztSBTradeBuySellView.h"
#endif

#ifdef Support_RZRQ
#import "tztRZRQBuySellView.h"
#endif
#import "tztTradeSearchView_ipad.h"
//#import "tztDZJYTradeView.h"

@implementation tztTradeAddSearchView_ipad
@synthesize pTradeView = _pTradeView;
@synthesize pSearchView = _pSearchView;

#define tztTradeRightTopHeight 260

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
-(void)setFrame:(CGRect)frame
{
    if (CGRectIsEmpty(frame) || CGRectIsNull(frame))
        return;
    
    [super setFrame:frame];
    
    CGRect rcFrame = self.bounds;
    rcFrame.size.height = tztTradeRightTopHeight;
    //顶部的操作界面
    if (_pTradeView == nil)
    {
        _pTradeView = [self GetTradeBaseViewByMsgType];
        if (_pTradeView)
        {
            _pTradeView.nMsgType = _nMsgType;
            _pTradeView.frame = rcFrame;
            _pTradeView.delegate = self;
            [self addSubview:_pTradeView];
            [_pTradeView release];
        }
    }else
        _pTradeView.frame = rcFrame;
    //底部查询界面
    rcFrame.origin.y += rcFrame.size.height;
    rcFrame.size.height = self.bounds.size.height - rcFrame.size.height;
    if (_pSearchView == NULL)
    {
        _pSearchView = [self GetSearchBaseViewByMsgType];
        if (_pSearchView)
        {
            _pSearchView.nMsgType = [self GetSearchViewTypeByTradeViewType];
            _pSearchView.frame = rcFrame;
            _pSearchView.delegate = self;
            [self addSubview:_pSearchView];
            [_pSearchView release];
        }
    }else
        _pSearchView.frame = rcFrame;
    
    
}

-(void)removeFromSuperview
{
    if (_pSearchView)
        _pSearchView.bRequest = _bRequest;
    if (_pTradeView)
        _pTradeView.bRequest = _bRequest;
    [super removeFromSuperview];
}

//顶部 根据不同的功能操作界面创建
-(tztBaseTradeView *)GetTradeBaseViewByMsgType
{
    tztBaseTradeView * tradeView = nil;
    switch (_nMsgType)
    {
        case WT_BUY:
        case MENU_JY_PT_Buy:
        case WT_SALE:
        case MENU_JY_PT_Sell:
        case MENU_JY_PT_NiHuiGou: //12319  逆向回购
        {
            tradeView = [[tztStockBuySellView alloc] init];
            ((tztStockBuySellView*)tradeView).bBuyFlag = (_nMsgType == WT_BUY || _nMsgType == MENU_JY_PT_Buy);
        }
            break;
#ifdef Support_SBTrade
        case WT_SBDJBUY:
        case MENU_JY_SB_DJBuy:
        case WT_SBQRBUY:
        case MENU_JY_SB_QRBuy:
        case WT_SBYXBUY:
        case MENU_JY_SB_YXBuy:
        case WT_SBDJSALE:
        case MENU_JY_SB_DJSell:
        case WT_SBQRSALE:
        case MENU_JY_SB_QRSell:
        case WT_SBYXSALE:
        case MENU_JY_SB_YXSell:
        {
            tradeView = [[tztSBTradeBuySellView alloc] init];
            tradeView.nMsgType = _nMsgType;
            ((tztSBTradeBuySellView*)tradeView).bBuyFlag = (_nMsgType == WT_SBDJBUY || _nMsgType == MENU_JY_SB_DJBuy||_nMsgType == WT_SBQRBUY || _nMsgType == MENU_JY_SB_QRBuy ||_nMsgType == WT_SBYXBUY || _nMsgType == MENU_JY_SB_YXBuy);
        }
            break;
#endif 
#ifdef Support_RZRQ
        case WT_RZRQBUY://普通买入
        case WT_RZRQRZBUY:  //融资买入
        case WT_RZRQBUYRETURN: //融资融券买券还券 3926
            //新功能号 add by xyt 20131018
        case MENU_JY_RZRQ_PTBuy://普通买入（信用买入）
        case MENU_JY_RZRQ_XYBuy:// 融资买入        
        case MENU_JY_RZRQ_BuyReturn://买券还券
        
        {
            tradeView = [[tztRZRQBuySellView alloc] init];
            tradeView.nMsgType = _nMsgType;
            ((tztRZRQBuySellView*)tradeView).bBuyFlag = YES;
        }
            break;
        case WT_RZRQSALE: //融资融券普通卖出 3923
        case WT_RZRQRQSALE: //融资融券融券卖出 3925
        case WT_RZRQSALERETURN: //融资融券卖券还款 3927
            //新功能号
        case MENU_JY_RZRQ_PTSell://普通卖出（信用卖出）
        case MENU_JY_RZRQ_XYSell://融券卖出
        case MENU_JY_RZRQ_SellReturn://卖券还款
        {
            tradeView = [[tztRZRQBuySellView alloc] init];
            tradeView.nMsgType = _nMsgType;
            ((tztRZRQBuySellView*)tradeView).bBuyFlag = NO;
        }
            break;
#endif
        default:
            break;
    }
    return tradeView;
}

//底部 根据不同的查询界面创建界面
-(tztBaseTradeView *)GetSearchBaseViewByMsgType
{
    tztBaseTradeView * searchView = nil;
    int MsgType = [self GetSearchViewTypeByTradeViewType];
    switch (MsgType)
    {
        case WT_QUERYGP://查询股票
        case MENU_JY_PT_QueryStock:
        case WT_RZRQQUERYGP:
        case WT_DZJY_HQCX:
        {
            searchView = [[tztTradeSearchView_ipad alloc] init];
        }
            break;
        default:
            break;
    }
    return searchView;
}
// 根据不同的功能操作界面 关联不同的查询界面
-(int)GetSearchViewTypeByTradeViewType
{
    int MsgType = 0;
    switch (_nMsgType)
    {
        case WT_BUY:
        case MENU_JY_PT_Buy:
        case WT_SALE:
        case MENU_JY_PT_Sell:
        case MENU_JY_PT_NiHuiGou: //12319  逆向回购
        case WT_SBDJBUY:
        case MENU_JY_SB_DJBuy:
        case WT_SBQRBUY:
        case MENU_JY_SB_QRBuy:
        case WT_SBYXBUY:
        case MENU_JY_SB_YXBuy:
        case WT_SBDJSALE:
        case MENU_JY_SB_DJSell:
        case WT_SBQRSALE:
        case MENU_JY_SB_QRSell:
        case WT_SBYXSALE:
        case MENU_JY_SB_YXSell:
        {
            MsgType = WT_QUERYGP;
        }
            break;
        case WT_RZRQBUY://普通买入
        case WT_RZRQRZBUY:  //融资买入
        case WT_RZRQBUYRETURN: //融资融券买券还券 3926
        case WT_RZRQSALE: //融资融券普通卖出 3923
        case WT_RZRQRQSALE: //融资融券融券卖出 3925
        case WT_RZRQSALERETURN: //融资融券卖券还款 3927
            //新功能号 add by xyt 20131018
        case MENU_JY_RZRQ_PTBuy://普通买入（信用买入）
        case MENU_JY_RZRQ_PTSell://普通卖出（信用卖出）
        case MENU_JY_RZRQ_XYBuy:// 融资买入
        case MENU_JY_RZRQ_XYSell://融券卖出
        case MENU_JY_RZRQ_BuyReturn://买券还券
        case MENU_JY_RZRQ_SellReturn://卖券还款
        {
            MsgType = WT_RZRQQUERYGP;
        }
            break;
        case WT_DZJY_YXMR://意向买入
        case WT_DZJY_YXMC://意向卖出
        case WT_DZJY_DJMR://定价买入
        case WT_DZJY_DJMC://定价卖出
        case WT_DZJY_QRMR://确认买入
        case WT_DZJY_QRMC://确认卖出
        {
            MsgType = WT_DZJY_HQCX;
        }
            break;
        default:
            break;
    }
    return MsgType;
}


-(void)SetDefaultData
{
    if (_pSearchView)
    {
        [_pSearchView SetDefaultData];
    }
    if (_pTradeView)
    {
        [_pTradeView SetDefaultData];
    }
}
-(void)OnRequestData
{
    if (_pSearchView)
    {
        [_pSearchView OnRequestData];
    }
    if (_pTradeView)
    {
        [_pTradeView OnRequestData];
    }
}
-(void)OnRefresh
{
    if (_pSearchView)
    {
        [_pSearchView OnRefresh];
    }
    if (_pTradeView)
    {
        [_pTradeView OnRefresh];
    }
}
//交易中边下面股票选择设置上面股票
-(void)DealSelectRow:(NSArray *)gridData StockCodeIndex:(NSInteger)index
{
    if (gridData == NULL || [gridData count]== 0 || [gridData count] <= index)
        return;
    
    TZTGridData * data = (TZTGridData *)[gridData objectAtIndex:index];
    NSString * nsStockCode = [NSString stringWithFormat:@"%@",data.text];
    if (_pTradeView)
        [_pTradeView setStockCode:nsStockCode];
}

@end
