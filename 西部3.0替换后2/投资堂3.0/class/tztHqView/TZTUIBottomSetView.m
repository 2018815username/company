/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:        个股详情界面中的底部最新要闻、大单监控、上证BBD、深圳BBD、资金流向 的一个集合
 * 文件标识:        
 * 摘要说明:        
 * 
 * 当前版本:        2.0
 * 作    者:       zhangxl
 * 更新日期:            
 * 整理修改:	
 *
 ***************************************************************/

#import "TZTUIBottomSetView.h"
#define TZTBtnHeight 30
#define TZTBtnTag  200
#define TZTBtnWidth 100
#define TZTTopHeight (TZTBtnHeight + 6)
@implementation TZTUIBottomSetView
@synthesize pInfoView = _pInfoView;
@synthesize pFundFlowsView = _pFundFlowsView;
@synthesize pLargeView = _pLargeView;
@synthesize nViewtype = _nViewType;
@synthesize pStock = _pStock;
@synthesize nMaxCount = _nMaxCount;
@synthesize fLeftWidth = _fLeftWidth;
@synthesize uImageView = _uImageView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _pStock = NewObject(tztStockInfo);
        _pPreStock = NewObject(tztStockInfo);   
    }
    return self;
}

-(void)setFrame:(CGRect)frame
{
    if (CGRectIsNull(frame) || CGRectIsEmpty(frame)) 
        return;
    [super setFrame:frame];
    CGRect rcFrame = frame;
    rcFrame.origin.y = TZTTopHeight;
    rcFrame.size.height -= TZTTopHeight;
    if (_pInfoView == NULL)
    {
        _pInfoView = [[tztInfoTableView alloc] initWithFrame:rcFrame];
        _pInfoView.tztinfodelegate = self;
        _pInfoView.tztdelegate = self;
        [self addSubview:_pInfoView];
        [_pInfoView release];
    }
    else
        _pInfoView.frame = rcFrame;
    
    if (_pFundFlowsView)
    {
        _pFundFlowsView.frame = rcFrame;
        [_pFundFlowsView setNeedsDisplay];
    }
    if (_pLargeView)
    {
        _pLargeView.frame = rcFrame;
        [_pLargeView setNeedsDisplay];
    }
    
    rcFrame = CGRectMake(0, 0, frame.size.width, TZTTopHeight);
    if (_uImageView == NULL)
    {
        _uImageView = [[UIImageView alloc] initWithFrame:rcFrame];
        _uImageView.image = [UIImage imageTztNamed:@"TZTBottomBG.png"];
        [self addSubview:_uImageView];
        [_uImageView release];
    }else
        _uImageView.frame = rcFrame;
    
}
-(void)GreatButtonArray
{
    if (_pPreStock.stockType == _pStock.stockType &&
        !([_pStock.stockCode isEqualToString:@"1A0001"]
         ||[_pStock.stockCode isEqualToString:@"2A01"]
         ||[_pPreStock.stockCode isEqualToString:@"1A0001"]
         ||[_pPreStock.stockCode isEqualToString:@"2A01"]
         )
        )
        return;
    
    _pPreStock.stockCode = [NSString stringWithFormat:@"%@",_pStock.stockCode];
    _pPreStock.stockName = [NSString stringWithFormat:@"%@",_pStock.stockName];
    _pPreStock.stockType = _pStock.stockType;
    //先删除上面的所有button
    for (int y = 0; y < [self.subviews count]; y++)
    {
        UIView *view = [self.subviews objectAtIndex:y];
        if (view && [view isKindOfClass:[UIButton class]])
        {
            [view removeFromSuperview];
            y = 0;
        }
    }
    NSMutableArray *BtnArray = NewObject(NSMutableArray);
    [BtnArray removeAllObjects];
    [BtnArray addObject:@"最新要闻"];
    //根据股票类型来创建按钮
    if (MakeStockMarket(_pStock.stockType))
    {
        if ([_pStock.stockCode isEqualToString:@"1A0001"])
        {
            [BtnArray addObject:@"上证BBD"];
        }else if([_pStock.stockCode isEqualToString:@"2A01"])
        {
            [BtnArray addObject:@"深证BBD"];
        }else if(_pStock.stockType != SH_KIND_INDEX && _pStock.stockType != SZ_KIND_INDEX)
        {
           [BtnArray addObject:@"大单监控"];
           [BtnArray addObject:@"资金流向"]; 
        }
    }
    //创建按钮  根据按钮的tag = TZTBtnTag + 界面类型枚举
    CGRect rcFrame = CGRectMake(0, (TZTTopHeight - TZTBtnHeight)/2, TZTBtnWidth, TZTBtnHeight);
    for (int i = 0; i < [BtnArray count]; i++)
    {
        NSString *btnName = [BtnArray objectAtIndex:i];
        if (btnName == NULL||[btnName length] < 1)
            continue;
        rcFrame.origin.x = i*TZTBtnWidth;
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTztBackgroundImage:[UIImage imageTztNamed:@"TZTBottomBtn.png"]];
        [button addTarget:self action:@selector(OnButton:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitle:btnName forState:UIControlStateNormal];
        button.tag = TZTBtnTag + [self GetViewTypeByBtnName:btnName];
        button.frame = rcFrame;
        [self addSubview:button];
    }
    if ([BtnArray count] == 1)
    {
        if (self.pInfoView)
            self.pInfoView.hidden = NO;
        if (self.pFundFlowsView)
            self.pFundFlowsView.hidden = YES;
        if (self.pLargeView)
            self.pLargeView.hidden = YES;
    }
    [BtnArray release];
}
//通过按钮名称来获取按钮类型
-(int)GetViewTypeByBtnName:(NSString *)BtnName
{
    if (BtnName == NULL || [BtnName length] < 1)
        return -1;
    
    if ([BtnName isEqualToString:@"最新要闻"])
    {
        return BottomViewType_ZXYW;
    }
    else if([BtnName isEqualToString:@"上证BBD"])
    {
        return BottomViewType_SHZQBBD;
    }
    else if([BtnName isEqualToString:@"深证BBD"])
    {
        return BottomViewType_SZZQBBD;
    }
    else if([BtnName isEqualToString:@"大单监控"])
    {
        return BottomViewType_DDJK;
    }
    else if([BtnName isEqualToString:@"资金流向"])
    {
        return BottomViewType_ZJLS;
    }
    return -1;
}
//点击按钮处理
-(void)OnButton:(id)sender
{
    for (int i = 0; i < [self.subviews count]; i++)
    {
        UIView *view = [self.subviews objectAtIndex:i];
        if (view && [view isKindOfClass:[UIButton class]])
        {
            [(UIButton*)view setTztBackgroundImage:[UIImage imageTztNamed:@"TZTBottomBtn.png"]]; 
        }
    }
    
    UIButton *button = (UIButton *)sender;
    [button setTztBackgroundImage:[UIImage imageTztNamed:@"TZTBottomBtn_on.png"]];
    NSInteger viewtype = button.tag - TZTBtnTag;
    CGRect rcFrame = CGRectMake(0, TZTTopHeight, self.frame.size.width, self.frame.size.height - TZTTopHeight);
    switch (viewtype)
    {
        case BottomViewType_ZXYW:
        {
            if (_pInfoView == NULL)
            {
                _pInfoView = [[tztInfoTableView alloc] initWithFrame:rcFrame];
                _pInfoView.tztinfodelegate = self;
                _pInfoView.tztdelegate = self;
                [self addSubview:_pInfoView];
                [_pInfoView release];
            }
            else
                _pInfoView.frame = rcFrame;
            
            _pInfoView.hidden = NO;
            _pFundFlowsView.hidden = YES;
            _pLargeView.hidden = YES;
        }
            break;
        case BottomViewType_ZJLS:
        case BottomViewType_SZZQBBD:
        case BottomViewType_SHZQBBD:
        {
            if (_pFundFlowsView == NULL)
            {
                _pFundFlowsView = [[TZTUIFundFlowsView alloc] initWithFrame:rcFrame];
                _pFundFlowsView.tztdelegate = self;
                _pFundFlowsView.nMaxCount = _nMaxCount;
                _pFundFlowsView.fLeftWidth = _fLeftWidth;
                [self addSubview:_pFundFlowsView];
                [_pFundFlowsView release];
            }else
                _pFundFlowsView.frame = rcFrame;
            
            [_pFundFlowsView setStockInfo:self.pStock Request:1];
            
            _pInfoView.hidden = YES;
            _pFundFlowsView.hidden = NO;
            _pLargeView.hidden = YES;
        }
            break;
        case BottomViewType_DDJK:
        {
            if (_pLargeView == NULL)
            {
                _pLargeView = [[tztLargeMonitorView alloc] init];
                _pLargeView.tztdelegate = self;
                _pLargeView.frame = rcFrame;
                [self addSubview:_pLargeView];
                [_pLargeView release];
            }
            else
                _pLargeView.frame = rcFrame;
            
            [_pLargeView setStockInfo:self.pStock Request:1];
            _pInfoView.hidden = YES;
            _pFundFlowsView.hidden = YES;
            _pLargeView.hidden = NO;
        }
            break;
        default:
            break;
    }
}
-(void)onSetViewRequest:(BOOL)bRequest
{
    if (_pInfoView)
    {
        [_pInfoView onSetViewRequest:bRequest];
    }  
    if (_pFundFlowsView)
    {
        [_pFundFlowsView onSetViewRequest:bRequest];
    }
    if (_pLargeView)
    {
        [_pLargeView onSetViewRequest:bRequest];
    }
}
-(void)SetStock:(tztStockInfo*)Stock
{
    if (Stock == NULL || 
        Stock.stockCode == NULL ||
        [Stock.stockCode length] <= 0 || 
        [Stock.stockCode isEqualToString:_pPreStock.stockCode])
        return;
    
    _pStock.stockCode = [NSString stringWithFormat:@"%@",Stock.stockCode];
    _pStock.stockName = [NSString stringWithFormat:@"%@",Stock.stockName];
    _pStock.stockType = Stock.stockType;
    
    if (self.pInfoView && !self.pInfoView.hidden)
    {
        [self.pInfoView setStockInfo:Stock HsString_:@"000"];
        [self.pInfoView setStockInfo:Stock Request:1];
    }
    else if (self.pFundFlowsView && !self.pFundFlowsView.hidden)
    {
        self.pFundFlowsView.fLeftWidth = _fLeftWidth;
        self.pFundFlowsView.nMaxCount = _nMaxCount;
       [self.pFundFlowsView setStockInfo:Stock Request:1];
    }
    else if(self.pLargeView && !self.pLargeView.hidden)
    {
        [self.pLargeView setStockInfo:Stock Request:1];
    }
    
    [self GreatButtonArray];
}

-(void)SetInfoItem:(id)delegate pItem_:(tztInfoItem *)pItem
{
    if (delegate == self.pInfoView && pItem)
    {
        //弹出资讯内容显示
        [TZTUIBaseVCMsg OnMsg:HQ_MENU_Info_Content wParam:(NSUInteger)pItem lParam:(NSUInteger)self.pInfoView];
    }
}

-(void)MoveFenshiCurLine:(CGPoint)point
{
    if (self.pDelegate && [self.pDelegate respondsToSelector:@selector(MoveFenshiCurLine:)]) 
    {
        [self.pDelegate MoveFenshiCurLine:point];
    }
}
-(void)ShowFenshiCurLine:(BOOL)show Point:(CGPoint)point
{
    if (self.pDelegate && [self.pDelegate respondsToSelector:@selector(ShowFenshiCurLine:Point:)]) 
    {
        [self.pDelegate ShowFenshiCurLine:show Point:point];
    }
}
-(void)dealloc
{
    DelObject(_pStock);
    DelObject(_pPreStock);
    [super dealloc];
}
@end
