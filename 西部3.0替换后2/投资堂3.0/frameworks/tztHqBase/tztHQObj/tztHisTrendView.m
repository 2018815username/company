/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:        历史分时view
 * 文件标识:
 * 摘要说明:
 *
 * 当前版本:        2.0
 * 作    者:       yinjp
 * 更新日期:        2013-07－12
 * 整理修改:        只显示分时走势图，其余五档，盘口等都不显示
 *
 ***************************************************************/

#import "tztHisTrendView.h"
@interface tztHisTrendView ()
{
    BOOL _bHisDate;
    UISwipeGestureRecognizer *swipeLeftTap;
    UISwipeGestureRecognizer *swipeRightTap;
}
@end

@implementation tztHisTrendView
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
    }
    return self;
}

-(void)dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}

-(void)initdata
{
    [super initdata];
    self.tztPriceStyle = TrendPriceNon;
    _bHisDate = FALSE;
    
    //增加左右滑动手势
    if(swipeLeftTap == nil)
    {
        swipeLeftTap = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(OnMoveLeftOrRight:)];
        [swipeLeftTap setDirection:UISwipeGestureRecognizerDirectionLeft];
        [self addGestureRecognizer:swipeLeftTap];
        [swipeLeftTap release];
    }
    
    if(swipeRightTap == nil)
    {
        swipeRightTap = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(OnMoveLeftOrRight:)];
        [swipeRightTap setDirection:UISwipeGestureRecognizerDirectionRight];
        [self addGestureRecognizer:swipeRightTap];
        [swipeRightTap release];
    }
}

-(void)onRequestHisData:(NSString *)nsDate
{
    if (self.pStockInfo == nil || self.pStockInfo.stockCode == nil || [self.pStockInfo.stockCode length] <= 0)
    {
        return;
    }
    if(_tztPriceView)
    {
        _tztPriceView.pStockInfo = self.pStockInfo;
    }
    
    NSMutableDictionary* sendvalue = NewObject(NSMutableDictionary);
    NSInteger nStartPos = 0;
    if (MakeWHMarket(self.pStockInfo.stockType))
    {
        [self onClearData];
    }
    
    NSString* nsMarket = [NSString stringWithFormat:@"%d", self.pStockInfo.stockType];
    [sendvalue setTztObject:nsMarket forKey:@"NewMarketNo"];
    
    if (nsDate && [nsDate length] > 0)
    {
        _bHisDate = TRUE;
        [self onClearData];
        [sendvalue setTztObject:nsDate forKey:@"BeginDate"];
    }
    else
    {
        if(self.ayTrendValues && [self.ayTrendValues count] > 0)
            nStartPos = [self.ayTrendValues count] -1;
        _bHisDate = FALSE;
    }
    
    NSString* strPos = [NSString stringWithFormat:@"%ld",(long)nStartPos];
    [sendvalue setTztObject:self.pStockInfo.stockCode forKey:@"StockCode"];
    [sendvalue setTztObject:strPos forKey:@"StartPos"];
    [sendvalue setTztObject:@"2" forKey:@"AccountIndex"];
    _ntztHqReq++;
    if(_ntztHqReq >= UINT16_MAX)
        _ntztHqReq = 1;
    NSString* strReqno = tztKeyReqno((long)self, _ntztHqReq);
    [sendvalue setTztObject:strReqno forKey:@"Reqno"];
    [[tztMoblieStockComm getSharehqInstance] onSendDataAction:@"20109" withDictValue:sendvalue];
    DelObject(sendvalue);
}


-(void)onRequestData:(BOOL)bShowProcess
{
    if (_bRequest && (!_bHisDate) )//当日数据需要实时刷新数据
    {
        [self onRequestHisData:@""];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    swipeLeftTap.enabled = (!self.bTrendDrawCursor);
    swipeRightTap.enabled = (!self.bTrendDrawCursor);
    
}
//左右滑屏事件处理前后切换
-(void)OnMoveLeftOrRight:(UISwipeGestureRecognizer*)recognsizer
{
    //显示光标线时，不处理
    if (self.bTrendDrawCursor)
        return;
    //向左滑动,下一条
    if (recognsizer.direction == UISwipeGestureRecognizerDirectionLeft)
    {
        if (_tztdelegate && [_tztdelegate respondsToSelector:@selector(tztUIHisTrendChanged:)])
        {
            [_tztdelegate tztUIHisTrendChanged:1];
        }
    }
    //向右滑动上一条
    else if(recognsizer.direction == UISwipeGestureRecognizerDirectionRight)
    {
        if (_tztdelegate && [_tztdelegate respondsToSelector:@selector(tztUIHisTrendChanged:)])
        {
            [_tztdelegate tztUIHisTrendChanged:0];
        }
    }
}

@end
