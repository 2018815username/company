//
//  TZTUIFundFlowsView.m
//  tztMobileApp
//
//  Created by  on 13-2-26.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "TZTUIFundFlowsView.h"

@interface TZTUIFundFlowsView ()
{
    NSMutableArray *    _ayFundFlowsValues;//数据集合
    NSString *          _pPreStockCode;//上个股票的代码
    CGContextRef        _context;//绘制用
    float *             _fFundFlowsJinE;//资金流向净额变化值集合
    float               _fTwoPointWidth;//2点之间的宽度（即2个值之间的像素点）
    float               _fMinValue;//最小值
    float               _fMaxValue;//最大值
    BOOL                _bCursorLine;//是否绘制光标线
    BOOL                _Move;      //是否是移动光标操作
    int                 _nMaxCount;//绘制值个数（即一天的数据点 241）
    float               _fLeftWidth;//左边宽度 - 跟分时界面左边宽度对齐
    CGPoint             _pCurPoint;//触摸点
}
@end

@implementation TZTUIFundFlowsView
@synthesize ayFundFlowsValues = _ayFundFlowsValues;
@synthesize nMaxCount = _nMaxCount;
@synthesize fLeftWidth = _fLeftWidth;
@synthesize pCurPoint = _pCurPoint;
@synthesize bCursorLine = _bCursorLine;
@synthesize pPreStockCode = _pPreStockCode;
#define tztMapTopHeight 20 //走势图 上面留的高度
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
    }
 
    return self;
}

-(void)setHidden:(BOOL)bHidden
{
    [super setHidden:bHidden];
    if (bHidden)
    {
        [self onSetViewRequest:NO];
    }
    else
    {
        [self onSetViewRequest:YES];
    }
    [self onRequestData:NO];
}

- (void)initdata
{
    [super initdata];
    //zxl 20130730 设置资金流向的背景
    [self setBackgroundColor:[UIColor tztThemeBackgroundColorHQ]];
    _ayFundFlowsValues = NewObject(NSMutableArray);
    [[tztMoblieStockComm getSharehqInstance] addObj:self];
    _fFundFlowsJinE = malloc(sizeof(float) * 1000);
    memset(_fFundFlowsJinE, 0x00, sizeof(float) * 1000);
    _bCursorLine = FALSE;
    _Move = FALSE;
}
#pragma 请求
- (void)onRequestData:(BOOL)bShowProcess
{		
    TZTNSLog(@"%@",@"onRequestData");
//    if (!(MakeStockMarket(self.pStock.stockType) 
//          && self.pStock.stockType != SH_KIND_INDEX 
//          && self.pStock.stockType != SZ_KIND_INDEX)) 
//        return;
    
    if(_bRequest)
    {
        if (self.pStockInfo.stockCode == nil || [self.pStockInfo.stockCode length] <= 0)
        {
            return;
        }
        
        if (![self.pPreStockCode isEqualToString:self.pStockInfo.stockCode])
        {
            [_ayFundFlowsValues removeAllObjects];
            memset(_fFundFlowsJinE, 0x00, sizeof(float) * 1000);
        }
            
        self.pPreStockCode = [NSString stringWithFormat:@"%@", self.pStockInfo.stockCode];
        
        NSInteger nStartPos = 0;
        NSInteger nMaxCount = 1000;
        if (_ayFundFlowsValues && [_ayFundFlowsValues  count] > 0)
        {
            nStartPos = [_ayFundFlowsValues count] - 1;
            nMaxCount = 1;
        }
            
        
        
        NSString* strPos = [NSString stringWithFormat:@"%ld",(long)nStartPos];
        NSMutableDictionary* sendvalue = NewObject(NSMutableDictionary);
        [sendvalue setTztObject:self.pStockInfo.stockCode forKey:@"StockCode"];
        [sendvalue setTztObject:strPos forKey:@"StartPos"];
        [sendvalue setTztObject:[NSString stringWithFormat:@"%ld",(long)nMaxCount] forKey:@"MaxCount"];
        
        _ntztHqReq++;
        if(_ntztHqReq >= UINT16_MAX)
            _ntztHqReq = 1;
        NSString* strReqno = tztKeyReqno((long)self, _ntztHqReq);
        [sendvalue setTztObject:strReqno forKey:@"Reqno"];
        [[tztMoblieStockComm getSharehqInstance] onSendDataAction:@"20118" withDictValue:sendvalue];
        DelObject(sendvalue);
    }
    [super onRequestData:bShowProcess];
}
//接收数据
- (NSUInteger)OnCommNotify:(NSUInteger)wParam lParam_:(NSUInteger)lParam
{
    if( wParam == 0 )
        return 0;
    tztNewMSParse *parse = (tztNewMSParse*)wParam;
    if([parse GetAction] == 20118)
    {
        if(![parse IsIphoneKey:(long)self reqno:_ntztHqReq])
        {
            return 0;
        }
        NSArray* ayGrid = [parse GetArrayByName:@"Grid"];
        for (int i = 1; i < [ayGrid count]; i++)
        {
            NSMutableArray *grid = [ayGrid objectAtIndex:i];
            if (grid == NULL || [grid count] < 6 )
                continue;
            
            tztFundFlowsValue * FundValue = NewObject(tztFundFlowsValue);
            NSString * value = [grid objectAtIndex:0];
            if (value && [value length] > 0)
            {
                FundValue.pTime = value;
            }
            value = [grid objectAtIndex:1];
            if (value && [value length] > 0)
            {
                FundValue.PJing = value;
                float JingE = [self NSstringChangFloat:value];
                _fFundFlowsJinE[[_ayFundFlowsValues count]] = JingE;
            }
            value = [grid objectAtIndex:2];
            if (value && [value length] > 0)
            {
                FundValue.pZhuLi = value;
            }
            value = [grid objectAtIndex:3];
            if (value && [value length] > 0)
            {
                FundValue.pDaHu = value;
            }
            value = [grid objectAtIndex:4];
            if (value && [value length] > 0)
            {
                FundValue.PZhongHu = value;
            }
            
            value = [grid objectAtIndex:5];
            if (value && [value length] > 0)
            {
                FundValue.pSanHu = value;
            }
            
            [_ayFundFlowsValues addObject:FundValue];
            [FundValue release];
        }
        if ([ayGrid  count] > 1)
        {
            [self setNeedsDisplay];
        }
        
        if (_tztdelegate && [_tztdelegate respondsToSelector:@selector(tzthqViewNeedsDisplay:)])
        {
            [_tztdelegate tzthqViewNeedsDisplay:self];
        }
        
    }
    return 0;
}
//绘制2点之间的线
-(void)DrawLine:(CGContextRef)context FirstPoint_:(CGPoint)firstpoint SecondPoint_:(CGPoint)secondpoint Color_:(UIColor *)color
{
	if (CGPointEqualToPoint(firstpoint,secondpoint ))
		return;
	
	CGContextMoveToPoint(context, firstpoint.x , firstpoint.y);
	CGContextAddLineToPoint(context,  secondpoint.x, secondpoint.y);
	CGContextSetStrokeColorWithColor(context,color.CGColor);
	CGContextSetLineWidth(context, 1);
	CGContextStrokePath(context);
}

#pragma mark -值转换成在所画区域的Y点
-(float)ValueToPoint:(float)value
{
    if ((_fMaxValue - _fMinValue) == 0)
    {
        return 0;
    }
    float nPos  = 0;
    nPos  = (value - _fMinValue)/(_fMaxValue - _fMinValue) * (self.frame.size.height - tztMapTopHeight);
	nPos = self.frame.size.height - nPos;
	if (nPos <= tztMapTopHeight)
	{
		nPos = tztMapTopHeight +1;
	}
	if (nPos >= self.frame.size.height - tztMapTopHeight)
	{
		nPos = self.frame.size.height - 1;
	}
	return nPos;
}

#pragma mark -值集合转点集合并且画走势图
-(void)DrawPointChangeLineMap:(CGContextRef)context pValues_:(float*)pValues  nValueNum_:(NSInteger)nValueNum
{
	if (pValues == NULL)
		return;
	
	CGPoint firstpoint = CGPointZero;
	CGPoint secondpoint = CGPointZero;
	float pointx = _fLeftWidth+1;
	float pointy = [self ValueToPoint:pValues[0]];
    UIColor *color;
	for (int i = 1;i < nValueNum ;i++ ) 
	{		
		if (pValues[i] == 0x7fffffff)
			continue;
		firstpoint = secondpoint;
		if (i == 1)
			firstpoint = CGPointMake(pointx,pointy);
		
		pointx = pointx + _fTwoPointWidth;
		pointy = [self ValueToPoint:pValues[i]];
        if (pValues[i] > 0)
            color = [UIColor tztThemeHQUpColor];
        else
            color = [UIColor tztThemeHQDownColor];
        
		secondpoint = CGPointMake(pointx,pointy);
		[self DrawLine:context FirstPoint_:firstpoint SecondPoint_:secondpoint Color_:color];
	}
}
//获取最大最小值
-(void)GetMinAndMax
{
    _fMinValue = _fFundFlowsJinE[0];
    _fMaxValue = _fFundFlowsJinE[0];
    for (int i = 0; i < [_ayFundFlowsValues count];i++ ) 
    {
        if (_fFundFlowsJinE[i] == 0x7fffffff)
			continue;
        float value= _fFundFlowsJinE[i];
        if (value > _fMaxValue)
            _fMaxValue = value;
            
        if (value < _fMinValue)
            _fMinValue = value;
            
    }
}
//绘制TOP数据显示
-(void)DrawTop:(CGContextRef)context
{    
    int width = 2;
    UIFont* font = tztUIBaseViewTextFont(10.5f);
    if (IS_TZTIPAD)
        font = tztUIBaseViewTextFont(15.0f);
    NSString *Vaule = @"-";
    CGPoint point = CGPointMake(_fLeftWidth, tztMapTopHeight - [Vaule sizeWithFont:font].height); 
    if (_fTwoPointWidth <= 0 ||
        _ayFundFlowsValues == NULL||
         [_ayFundFlowsValues count] == 0)
    {
        
        Vaule = @"-净";
        CGContextSetFillColorWithColor(context, [UIColor yellowColor].CGColor);
        [Vaule drawAtPoint:point withFont:font];
        
        point.x += [Vaule sizeWithFont:font].width + width;
        Vaule = @"-主";
        CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
        [Vaule drawAtPoint:point withFont:font];
        
        point.x += [Vaule sizeWithFont:font].width + width;
        Vaule = @"-大";
        CGContextSetFillColorWithColor(context, [tztTechSetting getInstance].kLineUpColor.CGColor);
        [Vaule drawAtPoint:point withFont:font];
        
        point.x += [Vaule sizeWithFont:font].width + width;
        Vaule = @"-中";
        CGContextSetFillColorWithColor(context, [tztTechSetting getInstance].kLineDownColor.CGColor);
        [Vaule drawAtPoint:point withFont:font];
        
        point.x += [Vaule sizeWithFont:font].width + width;
        Vaule = @"-散";
        CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
        [Vaule drawAtPoint:point withFont:font];
    }else
    {
        NSInteger index = (_pCurPoint.x - _fLeftWidth)/_fTwoPointWidth;
        if (index >= [_ayFundFlowsValues count])
            index = [_ayFundFlowsValues count] - 1;
        tztFundFlowsValue * Fundflows = [_ayFundFlowsValues objectAtIndex:index];
        if (Fundflows)
        {
            Vaule =[NSString stringWithFormat:@"%@%@",@"净", [self ValueSubstring:Fundflows.pJing]];
            CGContextSetFillColorWithColor(context, [UIColor yellowColor].CGColor);
            [Vaule drawAtPoint:point withFont:font];
            
            point.x += [Vaule sizeWithFont:font].width + width;
            Vaule = [NSString stringWithFormat:@"%@%@",@"主", [self ValueSubstring:Fundflows.pZhuLi]];
            CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
            [Vaule drawAtPoint:point withFont:font];
            
            point.x += [Vaule sizeWithFont:font].width + width;
            Vaule = [NSString stringWithFormat:@"%@%@",@"大", [self ValueSubstring:Fundflows.pDaHu]];
            CGContextSetFillColorWithColor(context, [tztTechSetting getInstance].kLineUpColor.CGColor);
            [Vaule drawAtPoint:point withFont:font];
            
            point.x += [Vaule sizeWithFont:font].width + width;
            Vaule = [NSString stringWithFormat:@"%@%@",@"中", [self ValueSubstring:Fundflows.pZhongHu]];
            CGContextSetFillColorWithColor(context, [tztTechSetting getInstance].kLineDownColor.CGColor);
            [Vaule drawAtPoint:point withFont:font];
            
            point.x += [Vaule sizeWithFont:font].width + width;
            Vaule = [NSString stringWithFormat:@"%@%@",@"散", [self ValueSubstring:Fundflows.pSanHu]];
            CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
            [Vaule drawAtPoint:point withFont:font];
        }
    }
}
//绘制光标线
-(void)DrawCurLine:(CGContextRef)context
{
    if (!_bCursorLine)
        return;
    
    if (_pCurPoint.x <= _fLeftWidth)
        _pCurPoint.x = _fLeftWidth + 1;
    if (_pCurPoint.x >= _fLeftWidth + 1 + _fTwoPointWidth*[_ayFundFlowsValues count])
        _pCurPoint.x = _fLeftWidth + _fTwoPointWidth*[_ayFundFlowsValues count];
    
    [self DrawLine:context 
       FirstPoint_:CGPointMake(_pCurPoint.x, tztMapTopHeight)
      SecondPoint_:CGPointMake(_pCurPoint.x, self.frame.size.height) 
            Color_:[UIColor whiteColor]];
}
//绘制数据走势图
-(void)DrawMap:(CGContextRef)context
{
    [self GetMinAndMax];
    _fTwoPointWidth = (self.frame.size.width - _fLeftWidth)/_nMaxCount;
    [self DrawPointChangeLineMap:context pValues_:_fFundFlowsJinE nValueNum_:[_ayFundFlowsValues count]];
}
//绘制背景 和左侧坐标
-(void)DrawBG:(CGContextRef)context
{
    CGContextSetAlpha(context, 0.5);
    [self DrawLine:context 
       FirstPoint_:CGPointMake(_fLeftWidth, tztMapTopHeight)
      SecondPoint_:CGPointMake(_fLeftWidth, self.frame.size.height) 
            Color_:[UIColor whiteColor]];
    
//    [self DrawLine:context 
//       FirstPoint_:CGPointMake(_fLeftWidth, tztMapTopHeight + (self.frame.size.height - tztMapTopHeight)/2)
//      SecondPoint_:CGPointMake(self.frame.size.width, tztMapTopHeight + (self.frame.size.height - tztMapTopHeight)/2) 
//            Color_:[UIColor whiteColor]];
    CGContextSetAlpha(context, 1);
    
    //左侧坐标值
    CGContextSetFillColorWithColor(context, [UIColor redColor].CGColor);
    UIFont *font = tztUIBaseViewTextFont(12.0f);
    NSString * Value = [NSString stringWithFormat:@"%.2f",_fMinValue];
    
    //由于前面的数据全部转万 所以这里有可能前面的亿转万  这里显示左边的时候再进行万转亿
    if (_fMinValue/10000 > 1 || _fMinValue/10000 < -1)
    {
        Value = [NSString stringWithFormat:@"%.2f%@",_fMinValue /10000,@"亿"];
    }else
    {
        Value = [NSString stringWithFormat:@"%@%@",Value,@"万"];
    }
    CGSize size = [Value sizeWithFont:font];
    [Value drawAtPoint:CGPointMake(_fLeftWidth - size.width, self.frame.size.height - size.height)  withFont:font];
    
    Value = [NSString stringWithFormat:@"%.2f",_fMaxValue];
    
    if (_fMaxValue/10000 > 1 || _fMaxValue/10000 < -1)
    {
        Value = [NSString stringWithFormat:@"%.2f%@",_fMaxValue /10000,@"亿"];
    }else
    {
        Value = [NSString stringWithFormat:@"%@%@",Value,@"万"];
    }
    size = [Value sizeWithFont:font];
    [Value drawAtPoint:CGPointMake(_fLeftWidth - size.width, tztMapTopHeight)  withFont:font];
    
    Value = [NSString stringWithFormat:@"%.2f",_fMinValue + (_fMaxValue - _fMinValue)/2];
    if ((_fMinValue + (_fMaxValue - _fMinValue)/2) /10000 > 1 || (_fMinValue + (_fMaxValue - _fMinValue)/2)/10000 < -1)
    {
        Value = [NSString stringWithFormat:@"%.2f%@",(_fMinValue + (_fMaxValue - _fMinValue)/2) /10000,@"亿"];
    }else
    {
          Value = [NSString stringWithFormat:@"%@%@",Value,@"万"];
    }
    size = [Value sizeWithFont:font];
    [Value drawAtPoint:CGPointMake(_fLeftWidth - size.width, tztMapTopHeight + (self.frame.size.height - tztMapTopHeight)/2 - 10)  withFont:font];
}

-(float)GetLeftMargin
{
    [self GetMinAndMax];
    UIFont *font = tztUIBaseViewTextFont(12.0f);
    NSString * Value = [NSString stringWithFormat:@"%.2f",_fMinValue];
    
    //由于前面的数据全部转万 所以这里有可能前面的亿转万  这里显示左边的时候再进行万转亿
    if (_fMinValue/10000 > 1 || _fMinValue/10000 < -1)
    {
        Value = [NSString stringWithFormat:@"%.2f%@",_fMinValue /10000,@"亿"];
    }else
    {
        Value = [NSString stringWithFormat:@"%@%@",Value,@"万"];
    }
    CGSize sizeMin = [Value sizeWithFont:font];
    
    Value = [NSString stringWithFormat:@"%.2f",_fMaxValue];
    
    if (_fMaxValue/10000 > 1 || _fMaxValue/10000 < -1)
    {
        Value = [NSString stringWithFormat:@"%.2f%@",_fMaxValue /10000,@"亿"];
    }else
    {
        Value = [NSString stringWithFormat:@"%@%@",Value,@"万"];
    }
    CGSize sizeMax = [Value sizeWithFont:font];
    
    return MAX(sizeMin.width, sizeMax.width);
}

-(void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    if (_context == NULL)
		_context = UIGraphicsGetCurrentContext();
    CGContextSetAlpha(_context, 1);
    
    [self DrawMap:_context];//画数据走势图
    [self DrawBG:_context];//背景框包括 右边坐标
    [self DrawCurLine:_context];//画光标
    [self DrawTop:_context];//画顶部数据

}

//由于Iphone 显示的位子不够所以数据截取整数
-(NSString *)ValueSubstring:(NSString *)Value
{
    NSString *Str = [Value substringWithRange:NSMakeRange([Value length] -1, 1)];
    if (Str && [Str length] > 0 && [Str isEqualToString:@"万"])
    {
        Str = [Value substringWithRange:NSMakeRange(0, [Value length] - 1)];
        Str = [NSString stringWithFormat:@"%d%@",[Str intValue],@"万"];
    }else
    {
        return Value;
    }
    return Str;
}

//字符串转float 用于服务器返回的数据转成float 然后画图
-(float)NSstringChangFloat:(NSString *)Value
{
    if (Value == NULL && [Value length] < 1)
        return 0.00f;
    float fvalue = 0.00f;
    NSString *Str = [Value substringWithRange:NSMakeRange(0, [Value length] - 1)];
    if (Str && [Str length] > 0)
    {
        fvalue = [Str floatValue];
    }
    Str = [Value substringWithRange:NSMakeRange([Value length] -1, 1)];
    if (Str && [Str length] > 0 && [Str isEqualToString:@"亿"])
    {
        fvalue = fvalue * 10000;
    }
    return fvalue;
}
#pragma touches
//点击处理
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	UITouch *touch = [[touches allObjects] objectAtIndex:0];
    _pCurPoint = [touch locationInView:self];
    _bCursorLine = !_bCursorLine;
    if (_Move)
    {
        _bCursorLine = TRUE;
        
    }
    //白线点击处理关联分时白线点击的处理
    if (self.tztdelegate && [self.tztdelegate respondsToSelector:@selector(ShowFenshiCurLine:Point:)])
    {
        if (!IS_TZTIPAD)//iphone 由于资金流向在量比上所以单独处理下
        {
            if (!_Move)
            {
                [self.tztdelegate ShowFenshiCurLine:_bCursorLine Point:_pCurPoint];
            } 
        }
        else
            [self.tztdelegate ShowFenshiCurLine:_bCursorLine Point:_pCurPoint];
    }
    _Move = FALSE;
    [self setNeedsDisplay];
}
//白线移动处理
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [[touches allObjects] objectAtIndex:0];
    CGPoint ptMove = [touch locationInView:self];
    if (ptMove.x >0&&ptMove.y > 0)
    {
        _pCurPoint = ptMove;
        //白线移动关联分时白线的移动位子
        if (self.tztdelegate && [self.tztdelegate respondsToSelector:@selector(MoveFenshiCurLine:)])
        {
            [self.tztdelegate MoveFenshiCurLine:_pCurPoint];
        }
        _Move = TRUE;
        [self setNeedsDisplay];
    }
}

-(void)dealloc
{
    if (_fFundFlowsJinE)
    {
        free(_fFundFlowsJinE);
        _fFundFlowsJinE = nil;
    }
    [[tztMoblieStockComm getSharehqInstance] removeObj:self];
    [super dealloc];
}

@end
