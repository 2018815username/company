/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:        首页-小分时界面
 * 文件标识:        
 * 摘要说明:        
 * 
 * 当前版本:        2.0
 * 作    者:       zhangxl
 * 更新日期:            
 * 整理修改:	
 *
 ***************************************************************/

#import "tztUIHomePageFenShiView.h"

@implementation tztUIHomePageFenShiView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) 
    {
        // Initialization code
    }
    return self;
}
-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    CGRect rcFrame = CGRectZero;
    rcFrame.size = frame.size;
    if (_pImageBG == NULL)
    {
        _pImageBG = [[UIImageView alloc] initWithImage:[UIImage imageTztNamed:@"TZTUIHomePageReport.png"]];
        _pImageBG.frame = rcFrame;
        [self addSubview:_pImageBG];
        [_pImageBG release];
    }else
        _pImageBG.frame = rcFrame;
    
    rcFrame = CGRectMake((frame.size.width - 80)/2, 10, 80, 20);
    
    if (_pTitle == NULL)
	{
		_pTitle = [[UILabel alloc]initWithFrame:rcFrame];
		_pTitle.font = [UIFont systemFontOfSize:20];
		_pTitle.textAlignment = UITextAlignmentLeft;
		_pTitle.adjustsFontSizeToFitWidth = YES;
		_pTitle.backgroundColor = [UIColor clearColor];
		_pTitle.textColor = [UIColor whiteColor];
		_pTitle.minimumFontSize = 14;
		[self addSubview:_pTitle];
        [_pTitle release];
	}else
	{
		_pTitle.frame = rcFrame;
	}
    
    rcFrame = CGRectMake(7, 45, frame.size.width - 14, 30);
	if (_pSegStock == NULL) 
	{		
		_pSegStock = [[UISegmentedControl alloc] initWithFrame:rcFrame];
		[_pSegStock insertSegmentWithTitle:@"上证" atIndex:0 animated:NO];
		[_pSegStock insertSegmentWithTitle:@"深证" atIndex:1 animated:NO];
		[_pSegStock insertSegmentWithTitle:@"黄金" atIndex:2 animated:NO];
		[_pSegStock insertSegmentWithTitle:@"原油" atIndex:3 animated:NO];
		[_pSegStock addTarget:self action:@selector(OnChangeStock) forControlEvents:UIControlEventValueChanged];
		_pSegStock.segmentedControlStyle = UISegmentedControlStyleBordered;
		
		_pSegStock.tintColor = [UIColor colorWithTztRGBStr:@"83,83,83"];
		[self addSubview:_pSegStock];
        [_pSegStock release];
		_pSegStock.selectedSegmentIndex = 0;
	}
	else 
        _pSegStock.frame = rcFrame;
    
    rcFrame.origin.x = 2;
    rcFrame.origin.y = _pSegStock.frame.origin.y + _pSegStock.frame.size.height + 10;
    rcFrame.size.width = 50;
    rcFrame.size.height = 20;
    if (_pNew == NULL)
    {
        _pNew = [[UILabel alloc] initWithFrame:rcFrame];
        _pNew.font = [UIFont systemFontOfSize:15];
		_pNew.textAlignment = UITextAlignmentRight;
        _pNew.textColor = [UIColor blackColor];
        _pNew.text = @"最新:";
        [self addSubview:_pNew];
        [_pNew release];
    }else
        _pNew.frame = rcFrame;
    
    rcFrame.origin.x = _pNew.frame.origin.x + _pNew.frame.size.width + 2;
    rcFrame.size.width = 200;
    if (_pPriceData == NULL)
    {
        _pPriceData = [[UILabel alloc] initWithFrame:rcFrame];
        _pPriceData.font = [UIFont systemFontOfSize:15];
		_pPriceData.textAlignment = UITextAlignmentLeft;
        [self addSubview:_pPriceData];
        [_pPriceData release];
    }else
        _pPriceData.frame = rcFrame;
    
    rcFrame.origin.x = 2;
    rcFrame.origin.y = _pNew.frame.origin.y + _pNew.frame.size.height + 5;
    rcFrame.size.width = frame.size.width  - 9;
    rcFrame.size.height = frame.size.height - rcFrame.origin.y - 1;
    if (_pTrendView == nil)
    {
        _pTrendView = [[tztTrendView alloc] init];
        _pTrendView.bHideVolume = YES;
        _pTrendView.nsBackColor = @"1";
//        _pTrendView.bCurLineShow = FALSE;
//        [_pTrendView setOtherBG:YES];
        _pTrendView.tztdelegate = self;
        _pTrendView.frame = rcFrame;
        [self addSubview:_pTrendView];
        [_pTrendView release];
        [self OnChangeStock];
    }else
        _pTrendView.frame = rcFrame;
    
    [self setBackgroundColor:[UIColor clearColor]];
}
-(void)OnChangeStock
{
    tztStockInfo *pStock = NewObjectAutoD(tztStockInfo);
    switch (_pSegStock.selectedSegmentIndex)
    {
        case 0:
        {
            pStock.stockName = @"上证指数";
            pStock.stockCode = @"1A0001";
        }
            break;
        case 1:
        {
            pStock.stockName = @"深圳成指";
            pStock.stockCode = @"2A01";
        }
            break;
        case 2:
        {
            pStock.stockName = @"伦敦金";
            pStock.stockCode = @"60881";
        }
            break;
        case 3:
        {
            pStock.stockName = @"美原油指";
            pStock.stockCode = @"633";
        }
            break;
        default:
            break;
    }
    _pTitle.text = pStock.stockName;
    [_pTrendView setStockInfo:pStock Request:1];
    [_pTrendView setNeedsDisplay];
}

-(void)UpdateData:(id)obj
{
    if (obj && (obj == _pTrendView))
    {
        if ([_pTrendView.ayTrendValues count] <= 0)
            return;
        tztTrendValue* trendvalue= [_pTrendView.ayTrendValues objectAtIndex:[_pTrendView.ayTrendValues count] - 1];
        TNewTrendHead *TrendHead = [_pTrendView GetNewTrendHead];
        UIColor* upColor = [tztTechSetting getInstance].upColor;
        UIColor* downColor = [tztTechSetting getInstance].downColor;
        UIColor* balanceColor = [tztTechSetting getInstance].balanceColor;
        
        _pPriceData.textColor = balanceColor;
        if (trendvalue.ulClosePrice > TrendHead->nPreClosePrice)
        {
            _pPriceData.textColor = upColor;
        }
        else if (trendvalue.ulClosePrice < TrendHead->nPreClosePrice)
        {
            _pPriceData.textColor = downColor;
        }
        NSString * value = [_pTrendView getValueString:trendvalue.ulClosePrice];
        NSString * text = [NSString stringWithFormat:@"%@",value];
        value = [_pTrendView getValueString:trendvalue.ulClosePrice - TrendHead->nPreClosePrice];
        text = [NSString stringWithFormat:@"%@ %@",text,value];
        value = [NSString stringWithFormat:@"%.2f%%",((long)trendvalue.ulClosePrice - TrendHead->nPreClosePrice) * 100.0 /(long)TrendHead->nPreClosePrice ];
        text = [NSString stringWithFormat:@"%@ %@",text,value];
        _pPriceData.text = text;
    }
}
@end
