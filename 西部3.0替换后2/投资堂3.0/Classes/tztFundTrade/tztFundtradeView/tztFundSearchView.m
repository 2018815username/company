/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:        基金交易ipad
 * 文件标识:        
 * 摘要说明:        
 * 
 * 当前版本:        2.0
 * 作    者:       xyt
 * 更新日期:            
 * 整理修改:	
 *
 ***************************************************************/
#import "tztFundSearchView.h"
#import "tztUIFundTradeRGSGView.h"
#import "tztUIFundKHView.h"
#import "tztUIFundFHView.h"
#import "tztUIFundCNTradeView.h"

#define LeftViewWidth 400

@implementation tztFundSearchView
@synthesize pFundSearch = _pFundSearch;
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
    if (CGRectIsNull(frame) || CGRectIsEmpty(frame))
        return;
    [super setFrame:frame];
    [self ShowTool:NO];
    CGRect rcFrame = CGRectMake(0, 0,_pLeftWidth ,frame.size.height);
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
    if (_pFundSearch == NULL)
    {
        _pFundSearch = [[tztUIFundSearchView alloc] init];
        _pFundSearch.frame = rcFrame;
        _pFundSearch.delegate = self;
        _pFundSearch.pTradeToolBar.hidden = YES; // 隐藏toolBar区 byDBQ20130813
        _pFundSearch.frame = rcFrame;
        [self addSubview:_pFundSearch];
        [_pFundSearch release];
    }
    else
    {
        _pFundSearch.frame = rcFrame;
    }
    //设置查询界面
    switch (_nMsgType) {
        case WT_JJRGFUND://基金认购
        case MENU_JY_FUND_RenGou:
            _pFundSearch.nMsgType = WT_JJInquireRGFund;
            break;
        case WT_JJAPPLYFUND://基金申购
        case MENU_JY_FUND_ShenGou:
            _pFundSearch.nMsgType = WT_JJInquireSGFund;
            break;
        case WT_JJREDEEMFUND://基金赎回
        case MENU_JY_FUND_ShuHui:
            _pFundSearch.nMsgType = WT_JJINQUIREGUFEN;
            break;
        case WT_JJRGFUNDEX:     //场内认购
        case MENU_JY_FUNDIN_RenGou:
        case WT_JJAPPLYFUNDEX:  //场内申购
        case MENU_JY_FUNDIN_ShenGou:
        case WT_JJREDEEMFUNDEX: //场内赎回
        case MENU_JY_FUNDIN_ShuHui:
            _pFundSearch.nMsgType = WT_QUERYGP;
            break;
        case WT_XJLC_KTXJLC:
        case WT_XJLC_FWCL:
        case WT_XJLC_BLJE:
            _pFundSearch.nMsgType = WT_XJLC_CXZT; // 查询状态 byDBQ20130813
        case WT_XJLC_SZYYQK:   // 设置预约取款
        case WT_XJLC_QXYYQK:   // 取消预约取款
            _pFundSearch.nMsgType = WT_XJLC_CXYYQK; // 查询预约取款
            break;
        default:
            break;
    }
}

-(void)ShowRightView:(BOOL)Show
{
    _pFundSearch.hidden = !Show;
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
        case WT_JJRGFUND:       //基金认购
        case MENU_JY_FUND_RenGou:
        case WT_JJAPPLYFUND:    //基金申购
        case MENU_JY_FUND_ShenGou:
        case WT_JJREDEEMFUND:   //基金赎回
        case MENU_JY_FUND_ShuHui:
        {
            _pBaseView = [[tztUIFundTradeRGSGView alloc] init];
            ((tztUIFundTradeRGSGView*)_pBaseView).nMsgType = _nMsgType;
            _pBaseView.frame = rcFrame;
            _pBaseView.delegate = self;
            [self addSubview:_pBaseView];
            [_pBaseView release];
        }
            break;
        case WT_JJRGFUNDEX: //场内认购
        case MENU_JY_FUNDIN_RenGou:
        case WT_JJAPPLYFUNDEX://场内申购
        case MENU_JY_FUNDIN_ShenGou:
        case WT_JJREDEEMFUNDEX://场内赎回
        case MENU_JY_FUNDIN_ShuHui:
        {
            _pBaseView = [[tztUIFundCNTradeView alloc] init];
            ((tztUIFundCNTradeView*)_pBaseView).nMsgType = _nMsgType;
            _pBaseView.frame = rcFrame;
            _pBaseView.delegate = self;
            [self addSubview:_pBaseView];
            [_pBaseView release];
        }
            break;
        case WT_JJINZHUCEACCOUNTEx://基金开户
        case MENU_JY_FUND_Kaihu:
        {
            _pBaseView = [[tztUIFundKHView alloc] init];
            ((tztUIFundKHView*)_pBaseView).nMsgType = _nMsgType;
            _pBaseView.frame = rcFrame;
            _pBaseView.delegate = self;
            [self addSubview:_pBaseView];
            [_pBaseView release];
        }
            break;
        case WT_JJFHTypeChange://分红设置
        case MENU_JY_FUND_FenHongSet:
        {
            _pBaseView = [[tztUIFundFHView alloc] init];
            ((tztUIFundKHView*)_pBaseView).nMsgType = _nMsgType;
            _pBaseView.frame = rcFrame;
            _pBaseView.delegate = self;
            [self addSubview:_pBaseView];
            [_pBaseView release];
        }
            break;
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
    [(_pBaseView) ClearData];
    
    [_pBaseView tztperformSelector:@"setStockCode:" withObject:data.text];
//    [(_pBaseView) setStockCode:data.text];
    [(_pBaseView) OnRefresh];
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
    if (_pFundSearch)
        [_pFundSearch OnRefresh];
}

-(void)OnRequestData
{
    //分红变更和基金开户不需要右边查询界面 modify by xyt 20130927
    if (_nMsgType == WT_JJINZHUCEACCOUNTEx || _nMsgType == WT_JJFHTypeChange)
    {
        _pFundSearch.hidden = YES;
    }
    //默认设置
    if (_pBaseView && [_pBaseView respondsToSelector:@selector(SetDefaultData)])
    {
        [_pBaseView tztperformSelector:@"SetDefaultData"];
//        [_pBaseView SetDefaultData];
    }
    
    //查询
    if (_pFundSearch)
        [_pFundSearch OnRequestData];
}

@end
