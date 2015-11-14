/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:        交易界面右边是查询股票界面（买卖界面）
 * 文件标识:        
 * 摘要说明:        
 * 
 * 当前版本:        2.0
 * 作    者:       zhangxl
 * 更新日期:            
 * 整理修改:	
 *
 ***************************************************************/
#import "tztUIRightSearchView.h"

#ifdef Support_SBTrade
#import "tztSBTradeBuySellView.h"
#import "tztSBTradeHQSelectView.h"
#import "tztSBTradeSearchView.h"
#import "tztSBTradeWithDrawView.h"
#endif

#define LeftViewWidth 400

@implementation tztUIRightSearchView
@synthesize pSearchView = _pSearchView;
@synthesize pBaseView = _pBaseView;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) 
    {
        _pLeftWidth = LeftViewWidth;
    }
    return self;
}
-(void)setFrame:(CGRect)frame
{
    if (CGRectIsEmpty(frame) || CGRectIsNull(frame))
        return;
    
    self.layer.borderWidth = 1.0f;
    self.layer.borderColor = [UIColor colorWithPatternImage:[UIImage imageTztNamed:@"filetab-bg_shu.png"]].CGColor;
    
    [super setFrame:frame];
    [self ShowTool:NO];
    CGRect rcFrame = CGRectMake(0, 0,_pLeftWidth ,frame.size.height);
    rcFrame.origin.x += self.layer.borderWidth;
    rcFrame.origin.y += self.layer.borderWidth;
    rcFrame.size.width -= self.layer.borderWidth * 2;
    rcFrame.size.height -= self.layer.borderWidth * 2;
    
    if (_pBaseView == NULL)
    {
        _pBaseView = [[tztBaseTradeView alloc] initWithFrame:rcFrame];
        _pBaseView.delegate = self;
        [self addSubview:_pBaseView];
        [_pBaseView release];
    }
    else
        _pBaseView.frame = rcFrame;
    
    rcFrame.origin.x = _pBaseView.frame.origin.x + _pBaseView.frame.size.width;
    rcFrame.size.width = frame.size.width - _pBaseView.frame.size.width;
    if (_pSearchView == NULL)
    {
        _pSearchView = [[tztTradeSearchView alloc] init];
        _pSearchView.nMsgType = WT_QUERYGP;
        _pSearchView.frame = rcFrame;
        _pSearchView.delegate = self;
        _pSearchView.pTradeToolBar.hidden = YES; // 隐藏toolBar区 byDBQ20130723
        _pSearchView.frame = rcFrame; // 再赋值 byDBQ20130723
        [_pSearchView OnRequestData];
        [self addSubview:_pSearchView];
        [_pSearchView release];
    }
    else
    {
        _pSearchView.frame = rcFrame;
    }
}

-(void)ShowRightView:(BOOL)Show
{
    _pSearchView.hidden = !Show;
    if (Show)
        _pLeftWidth = self.frame.size.width;
    else
        _pLeftWidth = LeftViewWidth;
    [self setFrame:self.frame];
}

-(void)SetLeftViewByPageType
{
    CGRect rcFrame = _pBaseView.frame;
    [_pBaseView removeFromSuperview];
    _pBaseView = nil;
    switch (_nMsgType)
    {
        case WT_BUY:
        case MENU_JY_PT_Buy:
        case WT_SALE:
        case MENU_JY_PT_Sell:
        {
            _pBaseView = [[tztStockBuySellView alloc] init];
            ((tztStockBuySellView*)_pBaseView).nMsgType = _nMsgType;
            ((tztStockBuySellView*)_pBaseView).bBuyFlag = (_nMsgType== WT_BUY || _nMsgType == MENU_JY_PT_Buy);
            _pBaseView.frame = rcFrame;
            _pBaseView.delegate = self;
            [self addSubview:_pBaseView];
            [_pBaseView release];
        }
            break;
            
        case WT_BANKTODEALER://卡转证券
        case MENU_JY_PT_Bank2Card:
        case WT_DEALERTOBANK://证券转卡
        case MENU_JY_PT_Card2Bank:
        case WT_QUERYBALANCE://查询余额
        case MENU_JY_PT_BankYue:
        {
            _pBaseView = [[tztBankDealerView alloc] init];
            ((tztBankDealerView*)_pBaseView).nMsgType = _nMsgType;
            _pBaseView.frame = rcFrame;
            _pBaseView.delegate = self;
            [self addSubview:_pBaseView];
            [_pBaseView release];
        }
            break;
            
            /********************三板功能*************************/
#ifdef Support_SBTrade
        case WT_SBDJBUY:
        case MENU_JY_SB_DJBuy:
        case WT_SBQRBUY:
        case MENU_JY_SB_QRBuy:
        case WT_SBYXBUY:
        case MENU_JY_SB_YXBuy:
            
        {
            _pBaseView = [[tztSBTradeBuySellView alloc] init];
            ((tztSBTradeBuySellView*)_pBaseView).nMsgType = _nMsgType;
            ((tztSBTradeBuySellView*)_pBaseView).bBuyFlag = TRUE;
            _pBaseView.frame = rcFrame;
            _pBaseView.delegate = self;
            [self addSubview:_pBaseView];
            [_pBaseView release];
        }
            break;
        case WT_SBDJSALE:
        case MENU_JY_SB_DJSell:
        case WT_SBQRSALE:
        case MENU_JY_SB_QRSell:
        case WT_SBYXSALE:
        case MENU_JY_SB_YXSell:
        {
            _pBaseView = [[tztSBTradeBuySellView alloc] init];
            ((tztSBTradeBuySellView*)_pBaseView).nMsgType = _nMsgType;
            ((tztSBTradeBuySellView*)_pBaseView).bBuyFlag = FALSE;
            _pBaseView.frame = rcFrame;
            _pBaseView.delegate = self;
            [self addSubview:_pBaseView];
            [_pBaseView release];
        }
            break;
#endif
            /********************三板功能end*************************/
        default:
            break;
    }
}

-(void)DealSelectRow:(NSArray *)gridData StockCodeIndex:(NSInteger)index
{
    if (gridData == NULL || [gridData count]== 0 || [gridData count] <= index)
        return;
    
    if (self.delegate &&[self.delegate respondsToSelector:@selector(DealSelectRow:StockCodeIndex:)])
    {
        [self.delegate DealSelectRow:gridData StockCodeIndex:index];
    }
    TZTGridData * data = (TZTGridData *)[gridData objectAtIndex:index];
    [((tztStockBuySellView*)_pBaseView) ClearData];
    [((tztStockBuySellView*)_pBaseView) setStockCode:data.text];
    [((tztStockBuySellView*)_pBaseView) OnRefresh];
    
    
}
-(void)SetStockBySelectStock:(NSString *)stockcode StockName:(NSString *)name
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(SetStockBySelectStock:StockName:)])
    {
        [self.delegate SetStockBySelectStock:stockcode StockName:name];
    }
}
-(void)OnRefresh
{
    [super OnRefresh];
    if (_pBaseView)
        [_pBaseView OnRefresh];
    if (_pSearchView)
        [_pSearchView OnRefresh];
}
@end
