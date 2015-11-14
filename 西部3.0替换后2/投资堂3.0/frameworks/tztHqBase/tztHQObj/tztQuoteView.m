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

#import "tztQuoteView.h"
#import "tztPriceView.h"

@interface tztQuoteView ()
{
    //股票名称
    UILabel     *_lblStockName;
    //股票代码
    UILabel     *_lblStockCode;
    
    //增删自选按钮
    UIButton    *_btnAddDelStock;
    
    //最新价
    UIButton    *_btnNewPriceValue;
    
    //涨跌
    UILabel     *_lblRatio;
    UILabel     *_lblRatioValue;
    
    //涨幅
    UILabel     *_lblRange;
    UILabel     *_lblRangeValue;
    
    //总成交额
    UILabel     *_lblTotal;
    UILabel     *_lblTotalValue;
    
    //最高
    UILabel     *_lblMaxPrice;
    UIButton    *_BtnMaxPriceValue;
    
    //最低
    UILabel     *_lblMinPrice;
    UIButton    *_BtnMinPriceValue;
    
    //开盘
    UILabel     *_lblOpenPrice;
    UIButton    *_BtnOpenPriceValue;
    
    //昨收
    UILabel     *_lblPreColsePrice;
    UIButton    *_BtnPreColsePriceValue;
    
    //时间
    UILabel     *_lblTime;
    UILabel     *_lblTimeValue;
    //板块指数
    UIButton    *_BtnBlockValue;
    
    /*场外基金单独*/
    //基金名称
    UILabel     *_lbOutFundNameTitle;
    UILabel     *_lbOutFundName;
    //基金净值
    UILabel     *_lbOutFundPriceTitle;
    UILabel     *_lbOutFundPrice;
    //周涨幅（万份收益）
    UILabel     *_lbOutFundValueTitle1;
    UILabel     *_lbOutFundValue1;
    //月涨幅（七日年化）
    UILabel     *_lbOutFundValueTitle2;
    UILabel     *_lbOutFundValue2;
    
}
-(CGFloat)CheckFontSize:(NSString*)str;
@end

@implementation tztQuoteView
@synthesize hasNoAddBtn = _hasNoAddBtn;

- (id)initWithFrame:(CGRect)frame 
{   
    self = [super initWithFrame:frame];
    if (self) 
    {
        [self initdata];
    }
    return self;
}

-(id)init
{
    if (self = [super init])
    {
        [self initdata];
    }
    return self;
}

-(void)initdata
{
    [super initdata];
//        self.backgroundColor =  [UIColor colorWithRGBULong:0x242424];// [UIColor colorWithPatternImage:[UIImage imageTztNamed:@"TZTHeadPriceBG"]];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    if (!IS_TZTIPAD)
    {
        self.backgroundColor = [UIColor tztThemeBackgroundColorHQ];
    }
    UIColor *cl = [UIColor tztThemeHQBalanceColor];
    _lblTotal.textColor = cl;
    _lblStockName.textColor = cl;
    _lblMaxPrice.textColor = cl;
    _lblMinPrice.textColor = cl;
    _lblOpenPrice.textColor = cl;
    _lblTime.textColor = cl;
    _lblPreColsePrice.textColor = cl;
}

- (void)dealloc 
{
    [super dealloc];
}

-(void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //绘制分割线
    if (_btnAddDelStock)
    {
        CGRect rcFrame = _btnAddDelStock.frame;
        if (!CGRectIsEmpty(rcFrame) && !CGRectIsNull(rcFrame))
        {
            float xOffset = rcFrame.origin.x + rcFrame.size.width + 1;
            CGRect rc = CGRectMake(xOffset, rect.origin.y, 1, rect.size.height);
            UIColor *pGridColor = [UIColor tztThemeHQGridColor];
            CGContextSetLineWidth(context, 1.0f);
            CGContextSetStrokeColorWithColor(context, pGridColor.CGColor);
            CGContextSetFillColorWithColor(context, pGridColor.CGColor);
            CGContextAddRect(context, rc);
            CGContextDrawPath(context, kCGPathFill);
        }
    }
    if (_BtnOpenPriceValue)
    {
        CGRect rcFrame = _BtnOpenPriceValue.frame;
        if (!CGRectIsEmpty(rcFrame) && !CGRectIsNull(rcFrame))
        {
            
            float xOffset = rcFrame.origin.x + rcFrame.size.width + 1;
            CGRect rc = CGRectMake(xOffset, rect.origin.y, 1, rect.size.height);
            UIColor *pGridColor = [UIColor tztThemeHQGridColor];
            
            CGContextSetLineWidth(context, 1.0f);
            CGContextSetStrokeColorWithColor(context, pGridColor.CGColor);
            CGContextSetFillColorWithColor(context, pGridColor.CGColor);
            CGContextAddRect(context, rc);
            CGContextDrawPath(context, kCGPathFill);
        }
    }
    
    CGRect rc = CGRectMake(0, rect.origin.y+rect.size.height-1, self.bounds.size.width, 1);
    UIColor *pGridColor = [UIColor tztThemeHQGridColor];
    
    CGContextSetLineWidth(context, 1.0f);
    CGContextSetStrokeColorWithColor(context, pGridColor.CGColor);
    CGContextSetFillColorWithColor(context, pGridColor.CGColor);
    CGContextAddRect(context, rc);
    CGContextDrawPath(context, kCGPathFill);
}

-(void)layoutOutFundSubviews_iphone
{
    CGRect rcFrame = self.bounds;
    rcFrame.size.height = MIN(60, rcFrame.size.height);
    rcFrame.origin.x += 5;
    rcFrame.size.height -= 6;
    int nPerWidth = rcFrame.size.width  / 2;
    UIColor* titlecolor = [UIColor tztThemeTextColorLabel];
    CGFloat fontsize = 13.f;
    
    UIFont* labfont = tztUIBaseViewTextFont(fontsize);
    
    //基金名称
    CGRect rcName = rcFrame;
    rcName.size.width = nPerWidth / 3;
    rcName.size.height = rcFrame.size.height / 2;
    
    //是否属于货币基金
    BOOL bIsFundHB = FALSE;
    bIsFundHB = MakeHTFundHBMarket(self.pStockInfo.stockType);
    
    
    if (bIsFundHB)
    {
        rcName.origin.y = (rcFrame.origin.y + rcFrame.size.height / 3);
        rcName.size.height = rcFrame.size.height / 3;
    }
    if (_lbOutFundNameTitle == NULL)
    {
        _lbOutFundNameTitle = [[UILabel alloc] initWithFrame:rcName];
        _lbOutFundNameTitle.backgroundColor = [UIColor clearColor];
        _lbOutFundNameTitle.textAlignment = NSTextAlignmentCenter;
        _lbOutFundNameTitle.font = labfont;
        _lbOutFundNameTitle.text = @"基金名称";
        _lbOutFundNameTitle.textColor = titlecolor;
        [self addSubview:_lbOutFundNameTitle];
        [_lbOutFundNameTitle release];
    }
    else
    {
        _lbOutFundNameTitle.frame = rcName;
    }
    
    rcName.origin.x += rcName.size.width + 2;
    rcName.size.width = nPerWidth * 2 / 3 - 2;
    if (_lbOutFundName == NULL)
    {
        _lbOutFundName = [[UILabel alloc] initWithFrame:rcName];
        _lbOutFundName.backgroundColor = [UIColor clearColor];
        _lbOutFundName.textAlignment = NSTextAlignmentLeft;
        _lbOutFundName.font = labfont;
        _lbOutFundName.textColor = [UIColor yellowColor];
        _lbOutFundName.adjustsFontSizeToFitWidth = YES;
        _lbOutFundName.text = @"";
        [self addSubview:_lbOutFundName];
        [_lbOutFundName release];
    }
    else
    {
        _lbOutFundName.frame = rcName;
    }
    
    if (!bIsFundHB)//货币基金不显示基金净值
    {
        //基金净值
        CGRect rcPrice = rcName;
        rcPrice.origin.y += rcName.size.height;
        rcPrice.origin.x = rcFrame.origin.x;
        rcPrice.size.width = nPerWidth / 3;
        if (_lbOutFundPriceTitle == NULL)
        {
            _lbOutFundPriceTitle = [[UILabel alloc] initWithFrame:rcPrice];
            _lbOutFundPriceTitle.backgroundColor = [UIColor clearColor];
            _lbOutFundPriceTitle.textAlignment = NSTextAlignmentCenter;
            _lbOutFundPriceTitle.font = labfont;
            _lbOutFundPriceTitle.textColor = titlecolor;
            _lbOutFundPriceTitle.text = @"基金净值";
            [self addSubview:_lbOutFundPriceTitle];
            [_lbOutFundPriceTitle release];
        }
        else
        {
            _lbOutFundPriceTitle.frame = rcPrice;
        }
        
        rcPrice.origin.x += rcPrice.size.width+2;
        rcPrice.size.width = nPerWidth * 2 / 3 - 2;
        if (_lbOutFundPrice == NULL)
        {
            _lbOutFundPrice = [[UILabel alloc] initWithFrame:rcPrice];
            _lbOutFundPrice.backgroundColor = [UIColor clearColor];
            _lbOutFundPrice.textAlignment = NSTextAlignmentLeft;
            _lbOutFundPrice.font = labfont;
            _lbOutFundPrice.text = @"";
            [self addSubview:_lbOutFundPrice];
            [_lbOutFundPrice release];
        }
        else
        {
            _lbOutFundPrice.frame = rcPrice;
        }
    }
    if(_lbOutFundPriceTitle)
        _lbOutFundPriceTitle.hidden = bIsFundHB;
    if(_lbOutFundPrice)
        _lbOutFundPrice.hidden = bIsFundHB;
    
    
    //周涨幅
    CGRect rcWeek = rcFrame;
    rcWeek.origin.x += nPerWidth;
    rcWeek.size.height = rcFrame.size.height / 2;
    rcWeek.size.width = nPerWidth /3;
    CGRect rcMonth = rcWeek;
    if (_lbOutFundValueTitle1 == NULL)
    {
        _lbOutFundValueTitle1 = [[UILabel alloc] initWithFrame:rcWeek];
        _lbOutFundValueTitle1.backgroundColor = [UIColor clearColor];
        _lbOutFundValueTitle1.font = labfont;
        _lbOutFundValueTitle1.textAlignment = NSTextAlignmentCenter;
        _lbOutFundValueTitle1.textColor = titlecolor;
        [self addSubview:_lbOutFundValueTitle1];
        [_lbOutFundValueTitle1 release];
    }
    else
    {
        _lbOutFundValueTitle1.frame = rcWeek;
    }
    if (!bIsFundHB)
        _lbOutFundValueTitle1.text = @"周涨幅";
    else
        _lbOutFundValueTitle1.text = @"万份收益";
    
    rcWeek.origin.x += rcWeek.size.width + 2;
    rcWeek.size.width = nPerWidth * 2 / 3 - 50;
    if (_lbOutFundValue1 == NULL)
    {
        _lbOutFundValue1 = [[UILabel alloc] initWithFrame:rcWeek];
        _lbOutFundValue1.backgroundColor = [UIColor clearColor];
        _lbOutFundValue1.font = labfont;
        _lbOutFundValue1.text = @"";
        _lbOutFundValue1.textAlignment = NSTextAlignmentLeft;
        [self addSubview:_lbOutFundValue1];
        [_lbOutFundValue1 release];
    }
    else
    {
        _lbOutFundValue1.frame = rcWeek;
    }
    
    //月涨幅
    rcMonth.origin.x = rcFrame.origin.x + nPerWidth;
    rcMonth.origin.y += rcWeek.size.height;
    rcMonth.size.width = nPerWidth / 3;
    if (_lbOutFundValueTitle2 == NULL)
    {
        _lbOutFundValueTitle2 = [[UILabel alloc] initWithFrame:rcMonth];
        _lbOutFundValueTitle2.backgroundColor = [UIColor clearColor];
        _lbOutFundValueTitle2.font = labfont;
        _lbOutFundValueTitle2.textColor = titlecolor;
        _lbOutFundValueTitle2.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_lbOutFundValueTitle2];
        [_lbOutFundValueTitle2 release];
    }
    else
    {
        _lbOutFundValueTitle2.frame = rcMonth;
    }
    if (!bIsFundHB)
        _lbOutFundValueTitle2.text = @"月涨幅";
    else
        _lbOutFundValueTitle2.text = @"七日年化";
    
    rcMonth.origin.x += rcMonth.size.width+2;
    rcMonth.size.width = nPerWidth * 2 / 3 - 50;
    if (_lbOutFundValue2 == NULL)
    {
        _lbOutFundValue2 = [[UILabel alloc] initWithFrame:rcMonth];
        _lbOutFundValue2.backgroundColor = [UIColor clearColor];
        _lbOutFundValue2.font = labfont;
        _lbOutFundValue2.text = @"";
        _lbOutFundValue2.textAlignment = NSTextAlignmentLeft;
        [self addSubview:_lbOutFundValue2];
        [_lbOutFundValue2 release];
    }
    else
    {
        _lbOutFundValue2.frame = rcMonth;
    }
    
    if (self.hasNoAddBtn)
        return;
    //自选股
    int nPerHeight = rcFrame.size.height;
    CGRect rcUserStock = rcMonth;
    rcUserStock.origin.x += rcUserStock.size.width;
    rcUserStock.size.width = nPerHeight* 2 / 4;
    rcUserStock.size.height = nPerHeight* 2 / 4;
    rcUserStock.origin.x += 5;
    rcUserStock.origin.y = (nPerHeight - rcUserStock.size.height) / 2;// - nPerHeight* 2 / 4;
    
    
    
    if (_btnAddDelStock == nil)
    {
        _btnAddDelStock = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btnAddDelStock setBackgroundImage:[UIImage imageTztNamed:@"TZTNavAddStock.png"] forState:UIControlStateNormal];
        _btnAddDelStock.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _btnAddDelStock.frame = rcUserStock;
        
        [_btnAddDelStock addTarget:self action:@selector(OnAddOrDelStock:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_btnAddDelStock];
    }
    else
        _btnAddDelStock.frame = rcUserStock;
    
    if (self.hasNoAddBtn)
        _btnAddDelStock.hidden = YES;

    
}

/*
 按照华泰的财富通，重新布局，其他券商统一采用这样的布局显示 yinjp 2014-01-17
 */

- (void)layoutSubviews_iphone
{
    if (self.pStockInfo == NULL)
        return;
    //场外基金
    if (MakeHTFundMarket(self.pStockInfo.stockType))
    {
        [self layoutOutFundSubviews_iphone];
        return;
    }
    
    /*显示区域，预留边距*/
    CGRect rcFrame = self.bounds;
    rcFrame.size.height = MIN(60, rcFrame.size.height);
//    rcFrame.origin.x += tztXMargin;
//    rcFrame.size.width -= 2 * tztXMargin;
    
//    rcFrame.origin.y += tztYMargin;
//    rcFrame.size.height -= 2 * tztYMargin;
    rcFrame.origin.y += 5;
    rcFrame.size.height -= 2 * 5;
    float fPerHeight = rcFrame.size.height;
    float fPerWidth = rcFrame.size.width / 3;
    UIColor* titlecolor = [UIColor tztThemeHQBalanceColor];
    CGFloat fontsize = 13.f;
    if (IS_TZTIPAD)
    {
        fontsize = 18.f;
    }
    UIFont* labfont = tztUIBaseViewTextFont(fontsize);
    
    //自选按钮操作图片
    CGSize sz = [UIImage imageTztNamed:@"TZTNavAddStock.png"].size;
    if (sz.width <= 0)
        sz.width = 10;
    sz.width += 4;//预留按钮左右边距
    
    
    //最新价
    CGRect rcNewPrice = rcFrame;
    rcNewPrice.size.width = fPerWidth - sz.width;
    rcNewPrice.size.height = fPerHeight * 2 / 3;
    if (_btnNewPriceValue == nil)
    {
        _btnNewPriceValue = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnNewPriceValue.frame = rcNewPrice;
        _btnNewPriceValue.backgroundColor = [UIColor clearColor];
        [_btnNewPriceValue setTitle:@"-" forState:UIControlStateNormal];
        _btnNewPriceValue.titleLabel.font = tztUIBaseViewTextBoldFont(25.0f);
        _btnNewPriceValue.titleLabel.adjustsFontSizeToFitWidth = YES;
        _btnNewPriceValue.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        [_btnNewPriceValue setContentMode:UIViewContentModeCenter];
        [_btnNewPriceValue.titleLabel setAdjustsFontSizeToFitWidth:TRUE];
        [self addSubview:_btnNewPriceValue];
    }
    else
    {
        _btnNewPriceValue.frame = rcNewPrice;
    }
    
    if (!self.hasNoAddBtn)
    {
        //自选股
        CGRect rcUserStock = rcNewPrice;
        rcUserStock.origin.x += rcUserStock.size.width + 2;
        rcUserStock.size.width = sz.width;
        rcUserStock.size.height = sz.width;
        rcUserStock.origin.y += (fPerHeight - sz.height) / 2;
        if (_btnAddDelStock == nil)
        {
            _btnAddDelStock = [UIButton buttonWithType:UIButtonTypeCustom];
            [_btnAddDelStock setBackgroundImage:[UIImage imageTztNamed:@"TZTNavAddStock.png"] forState:UIControlStateNormal];
            _btnAddDelStock.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
            _btnAddDelStock.frame = rcUserStock;
            
            [_btnAddDelStock addTarget:self action:@selector(OnAddOrDelStock:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:_btnAddDelStock];
        }
        else
            _btnAddDelStock.frame = rcUserStock;
    }
    else
    {
        _btnAddDelStock.hidden = YES;
    }
    
    //涨跌值 ＋ 涨跌幅
    CGRect rcRatio = rcNewPrice;
    rcRatio.origin.y += rcRatio.size.height;
    rcRatio.size.height = rcFrame.size.height / 3;
    if (_lblRatioValue == nil)
    {
        _lblRatioValue = [[UILabel alloc] initWithFrame:rcRatio];
        _lblRatioValue.backgroundColor = [UIColor clearColor];
        _lblRatioValue.textAlignment = NSTextAlignmentCenter;
        _lblRatioValue.adjustsFontSizeToFitWidth = YES;
        _lblRatioValue.font = labfont;
        [self addSubview:_lblRatioValue];
        [_lblRatioValue release];
    }
    else
        _lblRatioValue.frame = rcRatio;
    
    //总成交额
    CGRect rcTotal = rcNewPrice;
    rcTotal.origin.x += fPerWidth + 5;
    rcTotal.size.width = 20;// nPerHeight/3;
    rcTotal.size.height = fPerHeight/3;
    if (_lblTotal == nil)
    {
        _lblTotal = [[UILabel alloc] initWithFrame:rcTotal];
        _lblTotal.backgroundColor = [UIColor clearColor];
        _lblTotal.textAlignment = NSTextAlignmentCenter;
        _lblTotal.font = labfont;
        _lblTotal.textColor =titlecolor;
        _lblTotal.text = @"额:";
        [self addSubview:_lblTotal];
        [_lblTotal release];
        
    }
    else
        _lblTotal.frame = rcTotal;

    CGRect rcTotalValue = rcTotal;
    rcTotalValue.origin.x += rcTotalValue.size.width;
    rcTotalValue.size.width = fPerWidth * 4/ 7+ 5;
    if (_lblTotalValue == nil)
    {
        _lblTotalValue = [[UILabel alloc] initWithFrame:rcTotalValue];
        _lblTotalValue.backgroundColor = [UIColor clearColor];
        _lblTotalValue.textAlignment = NSTextAlignmentCenter;
        _lblTotalValue.font = labfont;
        _lblTotalValue.adjustsFontSizeToFitWidth = YES;
        _lblTotalValue.text = @"-";
        [self addSubview:_lblTotalValue];
        [_lblTotalValue release];
        
    }
    else
        _lblTotalValue.frame = rcTotalValue;
    
    //最高
    CGRect rcMax = rcTotal;
    rcMax.origin.y += rcMax.size.height;
    if (_lblMaxPrice == nil)
    {
        _lblMaxPrice = [[UILabel alloc] initWithFrame:rcMax];
        _lblMaxPrice.backgroundColor = [UIColor clearColor];
        _lblMaxPrice.textAlignment = NSTextAlignmentCenter;
        _lblMaxPrice.font = labfont;
        _lblMaxPrice.textColor =titlecolor;
        _lblMaxPrice.text = @"高:";
        [self addSubview:_lblMaxPrice];
        [_lblMaxPrice release];
        
    }
    else
        _lblMaxPrice.frame = rcMax;
    
    CGRect rcMaxValue = rcTotalValue;
    rcMaxValue.origin.y += rcMaxValue.size.height;
    if (_BtnMaxPriceValue == nil)
    {
        _BtnMaxPriceValue = [UIButton buttonWithType:UIButtonTypeCustom];
        _BtnMaxPriceValue.frame = rcMaxValue;
        _BtnMaxPriceValue.backgroundColor = [UIColor clearColor];
        [_BtnMaxPriceValue setTitle:@"-" forState:UIControlStateNormal];
        _BtnMaxPriceValue.titleLabel.font = labfont;
        _BtnMaxPriceValue.titleLabel.textAlignment = NSTextAlignmentLeft;
        _BtnMaxPriceValue.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        [_BtnMaxPriceValue setContentMode:UIViewContentModeCenter];
        [self addSubview:_BtnMaxPriceValue];
    }
    else
        _BtnMaxPriceValue.frame = rcMaxValue;
    
    //最低
    CGRect rcMin = rcMax;
    rcMin.origin.y += rcMin.size.height;
    if (_lblMinPrice == nil)
    {
        _lblMinPrice = [[UILabel alloc] initWithFrame:rcMin];
        _lblMinPrice.backgroundColor = [UIColor clearColor];
        _lblMinPrice.textAlignment = NSTextAlignmentCenter;
        _lblMinPrice.font = labfont;
        _lblMinPrice.textColor =titlecolor;
        _lblMinPrice.text = @"低:";
        [self addSubview:_lblMinPrice];
        [_lblMinPrice release];
        
    }
    else
        _lblMinPrice.frame = rcMin;
    
    CGRect rcMinValue = rcMaxValue;
    rcMinValue.origin.y += rcMinValue.size.height;
    if (_BtnMinPriceValue == nil)
    {
        _BtnMinPriceValue = [UIButton buttonWithType:UIButtonTypeCustom];
        _BtnMinPriceValue.frame = rcMinValue;
        _BtnMinPriceValue.backgroundColor = [UIColor clearColor];
        [_BtnMinPriceValue setTitle:@"-" forState:UIControlStateNormal];
        _BtnMinPriceValue.titleLabel.font = labfont;
        _BtnMinPriceValue.titleLabel.textAlignment = NSTextAlignmentLeft;
        _BtnMinPriceValue.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        [_BtnMinPriceValue setContentMode:UIViewContentModeCenter];
        [self addSubview:_BtnMinPriceValue];
    }
    else
        _BtnMinPriceValue.frame = rcMinValue;
    
    //开盘
    CGRect rcOpen = rcTotalValue;
    rcOpen.origin.x += rcOpen.size.width;
    rcOpen.size.width = 20;// fPerHeight/3;
    rcOpen.size.height = fPerHeight/3;
    if (_lblOpenPrice == nil)
    {
        _lblOpenPrice = [[UILabel alloc] initWithFrame:rcOpen];
        _lblOpenPrice.backgroundColor = [UIColor clearColor];
        _lblOpenPrice.textAlignment = NSTextAlignmentCenter;
        _lblOpenPrice.font = labfont;
        _lblOpenPrice.textColor =titlecolor;
        _lblOpenPrice.text = @"开:";
        [self addSubview:_lblOpenPrice];
        [_lblOpenPrice release];
        
    }
    else
        _lblOpenPrice.frame = rcOpen;
    
    CGRect rcOpenValue = rcOpen;
    rcOpenValue.origin.x += rcOpenValue.size.width;
    rcOpenValue.size.width = rcTotalValue.size.width;
    if (_BtnOpenPriceValue == nil)
    {
        _BtnOpenPriceValue = [UIButton buttonWithType:UIButtonTypeCustom];
        _BtnOpenPriceValue.frame = rcOpenValue;
        _BtnOpenPriceValue.backgroundColor = [UIColor clearColor];
        [_BtnOpenPriceValue setTitle:@"-" forState:UIControlStateNormal];
        _BtnOpenPriceValue.titleLabel.font = labfont;
        _BtnOpenPriceValue.titleLabel.textAlignment = NSTextAlignmentLeft;
        _BtnOpenPriceValue.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        [_BtnOpenPriceValue setContentMode:UIViewContentModeCenter];
        [self addSubview:_BtnOpenPriceValue];
    }
    else
        _BtnOpenPriceValue.frame = rcOpenValue;
    
    //昨收
    CGRect rcPreColse = rcOpen;
    rcPreColse.origin.y += rcPreColse.size.height;
    if (_lblPreColsePrice == nil)
    {
        _lblPreColsePrice = [[UILabel alloc] initWithFrame:rcPreColse];
        _lblPreColsePrice.backgroundColor = [UIColor clearColor];
        _lblPreColsePrice.textAlignment = NSTextAlignmentCenter;
        _lblPreColsePrice.font = labfont;
        _lblPreColsePrice.textColor =titlecolor;
        _lblPreColsePrice.text = @"收:";
        [self addSubview:_lblPreColsePrice];
        [_lblPreColsePrice release];
        
    }
    else
        _lblPreColsePrice.frame = rcPreColse;
    
    CGRect rcPreColseValue = rcOpenValue;
    rcPreColseValue.origin.y += rcPreColseValue.size.height;
    if (_BtnPreColsePriceValue == nil)
    {
        _BtnPreColsePriceValue = [UIButton buttonWithType:UIButtonTypeCustom];
        _BtnPreColsePriceValue.frame = rcPreColseValue;
        _BtnPreColsePriceValue.backgroundColor = [UIColor clearColor];
        [_BtnPreColsePriceValue setTitle:@"-" forState:UIControlStateNormal];
        _BtnPreColsePriceValue.titleLabel.font = labfont;
         _BtnPreColsePriceValue.titleLabel.textAlignment = NSTextAlignmentLeft;
        _BtnPreColsePriceValue.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        [_BtnPreColsePriceValue setContentMode:UIViewContentModeCenter];
        [self addSubview:_BtnPreColsePriceValue];
    }
    else
        _BtnPreColsePriceValue.frame = rcPreColseValue;
    
    //时间
    CGRect rcTime = rcPreColse;
    rcTime.origin.y += rcTime.size.height;
    if (_lblTime == nil)
    {
        _lblTime = [[UILabel alloc] initWithFrame:rcTime];
        _lblTime.backgroundColor = [UIColor clearColor];
        _lblTime.textAlignment = NSTextAlignmentCenter;
        _lblTime.font = labfont;
        _lblTime.textColor =titlecolor;
        _lblTime.text = @"时:";
        [self addSubview:_lblTime];
        [_lblTime release];
        
    }
    else
        _lblTime.frame = rcTime;
    
    CGRect rcTimeValue = rcPreColseValue;
    rcTimeValue.origin.y += rcTimeValue.size.height;
    if (_lblTimeValue == nil)
    {
        _lblTimeValue = [[UILabel alloc] initWithFrame:rcTimeValue];
        _lblTimeValue.backgroundColor = [UIColor clearColor];
        _lblTimeValue.textAlignment = NSTextAlignmentCenter;
        _lblTimeValue.font = labfont;
        _lblTimeValue.textColor =titlecolor;
        _lblTimeValue.text = @":";
        [self addSubview:_lblTimeValue];
        [_lblTimeValue release];
    }
    else
        _lblTimeValue.frame = rcTimeValue;
    
#ifndef Support_Iphone_HiddeBtnBlock
    CGRect rcBlock = rcOpenValue;
    rcBlock.origin.x += rcBlock.size.width;
    rcBlock.size.width = rcFrame.size.width-rcBlock.origin.x;
    rcBlock.size.height = fPerHeight;
    if(_BtnBlockValue == nil)
    {
        _BtnBlockValue = [UIButton buttonWithType:UIButtonTypeCustom];
        _BtnBlockValue.frame = rcBlock;
//        [_BtnBlockValue setBackgroundImage:[UIImage imageTztNamed:@"TZTBlockHQ.png"] forState:UIControlStateNormal];
        _BtnBlockValue.backgroundColor = [UIColor clearColor];
        _BtnBlockValue.titleLabel.numberOfLines = 2;
        if(IS_TZTIPAD)
            _BtnBlockValue.titleLabel.font = tztUIBaseViewTextBoldFont(25.0f);
        else
            _BtnBlockValue.titleLabel.font = tztUIBaseViewTextBoldFont(14.0f);
        _BtnBlockValue.titleLabel.adjustsFontSizeToFitWidth = YES;
        _BtnBlockValue.titleLabel.textAlignment = NSTextAlignmentCenter;
        _BtnBlockValue.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        [_BtnBlockValue setContentMode:UIViewContentModeCenter];
        [_BtnBlockValue setTztTitleEx:@"-\r\n-"];
        if (self)
            [_BtnBlockValue addTarget:self action:@selector(OnBtnBlock:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_BtnBlockValue];
    }
    else
        _BtnBlockValue.frame = rcBlock;
#endif
}


- (void)layoutSubviews_ipad
{
    CGRect rcFrame = self.bounds;
    rcFrame.size.height = MIN(80, rcFrame.size.height);
    rcFrame.origin.x += 5;
    rcFrame.size.height -= 10;
    //名称
    CGRect rcName = rcFrame;
    int nPerWidth = rcFrame.size.width * 5 / 24;
    rcName.size.width = rcFrame.size.width / 6;
    rcName.size.height = rcFrame.size.height/3*2;
    if (_lblStockName == nil)
    {
        _lblStockName = [[UILabel alloc] initWithFrame:rcName];
        _lblStockName.backgroundColor = [UIColor clearColor];
        _lblStockName.text = @"-";
        _lblStockName.textAlignment = NSTextAlignmentCenter;
        _lblStockName.textColor = [UIColor yellowColor];
        _lblStockName.adjustsFontSizeToFitWidth = YES;
        if(IS_TZTIPAD)
            _lblStockName.font = tztUIBaseViewTextBoldFont(28.0f);
        else
            _lblStockName.font = tztUIBaseViewTextBoldFont(12.0f);
        [self addSubview:_lblStockName];
    }
    else
    {
        _lblStockName.frame = rcName;
    }
    CGFloat fontsize = 10.f;
    if (IS_TZTIPAD)
    {
        fontsize = 18.f;
    }
    UIFont* labfont = tztUIBaseViewTextFont(fontsize);
    //代码
    CGRect rcCode = rcName;
    rcCode.origin.y += rcName.size.height;
    rcCode.size.height = rcFrame.size.height / 3;
    if (_lblStockCode == nil) 
    {
        _lblStockCode = [[UILabel alloc] initWithFrame:rcCode];
        _lblStockCode.backgroundColor = [UIColor clearColor];
        _lblStockCode.textColor = [UIColor whiteColor];
        _lblStockCode.textAlignment = NSTextAlignmentCenter;
        _lblStockCode.text = @"-";
        _lblStockCode.font = labfont;
        [self addSubview:_lblStockCode];
    }
    else
    {
        _lblStockCode.frame = rcCode;
    }
    //自选按钮
    
    //最新价
    CGRect rcNewPrice = rcCode;
    rcNewPrice.origin.x += rcCode.size.width;
    rcNewPrice.size.width = nPerWidth;
    rcNewPrice.origin.y = rcFrame.origin.y;
    rcNewPrice.size.height = rcFrame.size.height;
    if (_btnNewPriceValue == nil)
    {
        _btnNewPriceValue = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnNewPriceValue.frame = rcNewPrice;
        _btnNewPriceValue.backgroundColor = [UIColor clearColor];
        [_btnNewPriceValue setTitle:@"-" forState:UIControlStateNormal];
        if(IS_TZTIPAD)
            _btnNewPriceValue.titleLabel.font = tztUIBaseViewTextBoldFont(25.0f);
        else
            _btnNewPriceValue.titleLabel.font = tztUIBaseViewTextBoldFont(16.0f);
        _btnNewPriceValue.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        //        [_btnNewPriceValue setContentMode:UIViewContentModeCenter];
        [self addSubview:_btnNewPriceValue];
    }
    else
    {
        _btnNewPriceValue.frame = rcNewPrice;
    }
    
    //涨跌
    CGRect rcRatio = rcNewPrice;
    rcRatio.origin.x += rcNewPrice.size.width;
    rcRatio.size.width = nPerWidth / 3;
    rcRatio.size.height = rcFrame.size.height / 2;
    if (_lblRatio == nil)
    {
        _lblRatio = [[UILabel alloc] initWithFrame:rcRatio];
        _lblRatio.backgroundColor = [UIColor clearColor];
        _lblRatio.textAlignment = NSTextAlignmentLeft;
        _lblRatio.text = @"涨跌";
        _lblRatio.textColor = [UIColor whiteColor];
        _lblRatio.font = labfont;
        [self addSubview:_lblRatio];
    }
    else
    {
        _lblRatio.frame = rcRatio;
    }
    
    rcRatio.origin.y += rcRatio.size.height;
    if (_lblRange == nil)
    {
        _lblRange = [[UILabel alloc] initWithFrame:rcRatio];
        _lblRange.backgroundColor = [UIColor clearColor];
        _lblRange.textAlignment = NSTextAlignmentLeft;
        _lblRange.text = @"幅度";
        _lblRange.font = labfont;
        _lblRange.textColor = [UIColor whiteColor];
        [self addSubview:_lblRange];
    }
    else
    {
        _lblRange.frame = rcRatio;
    }
    
    rcRatio.origin.x += rcRatio.size.width;
    rcRatio.origin.y = rcFrame.origin.y;
    rcRatio.size.width = nPerWidth / 3 * 2;
    if (_lblRatioValue == nil)
    {
        _lblRatioValue = [[UILabel alloc] initWithFrame:rcRatio];
        _lblRatioValue.backgroundColor = [UIColor clearColor];
        _lblRatioValue.textAlignment = NSTextAlignmentCenter;
        _lblRatioValue.font = labfont;
        [self addSubview:_lblRatioValue];
    }
    else
        _lblRatioValue.frame = rcRatio;
    
    rcRatio.origin.y += rcRatio.size.height;
    if (_lblRangeValue == nil)
    {
        _lblRangeValue = [[UILabel alloc] initWithFrame:rcRatio];
        _lblRangeValue.backgroundColor = [UIColor clearColor];
        _lblRangeValue.textAlignment = NSTextAlignmentCenter;
        _lblRangeValue.font = labfont;
        [self addSubview:_lblRangeValue];
    }
    else
        _lblRangeValue.frame = rcRatio;
    
    //最高最低
    CGRect rcMax = rcRatio;
    rcMax.origin.y = rcFrame.origin.y;
    rcMax.origin.x += rcRatio.size.width;
    rcMax.size.width = nPerWidth / 3;
    if (_lblMaxPrice == nil)
    {
        _lblMaxPrice = [[UILabel alloc] initWithFrame:rcMax];
        _lblMaxPrice.backgroundColor = [UIColor clearColor];
        _lblMaxPrice.textAlignment = NSTextAlignmentLeft;
        _lblMaxPrice.text = @"最高";
        _lblMaxPrice.font = labfont;
        _lblMaxPrice.textColor = [UIColor whiteColor];
        [self addSubview:_lblMaxPrice];
    }
    else
        _lblMaxPrice.frame = rcMax;
    
    rcMax.origin.y += rcMax.size.height;
    if (_lblMinPrice == nil)
    {
        _lblMinPrice = [[UILabel alloc] initWithFrame:rcMax];
        _lblMinPrice.backgroundColor = [UIColor clearColor];
        _lblMinPrice.textAlignment = NSTextAlignmentLeft;
        _lblMinPrice.text = @"最低";
        _lblMinPrice.font = labfont;
        _lblMinPrice.textColor = [UIColor whiteColor];
        [self addSubview:_lblMinPrice];
    }
    else
        _lblMinPrice.frame = rcMax;
    
    rcMax.origin.x += rcMax.size.width;
    rcMax.origin.y = rcFrame.origin.y;
    rcMax.size.width = nPerWidth / 3 * 2;
    
    if (_BtnMaxPriceValue == nil)
    {
        _BtnMaxPriceValue = [UIButton buttonWithType:UIButtonTypeCustom];
        _BtnMaxPriceValue.backgroundColor = [UIColor clearColor];
        [_BtnMaxPriceValue setTitle:@"-" forState:UIControlStateNormal];
        _BtnMaxPriceValue.frame = rcMax;
        _BtnMaxPriceValue.titleLabel.font = labfont;
        [self addSubview:_BtnMaxPriceValue];
    }
    else
        _BtnMaxPriceValue.frame = rcMax;
    
    rcMax.origin.y += rcMax.size.height;
    
    if (_BtnMinPriceValue == nil)
    {
        _BtnMinPriceValue = [UIButton buttonWithType:UIButtonTypeCustom];
        _BtnMinPriceValue.backgroundColor = [UIColor clearColor];
        [_BtnMinPriceValue setTitle:@"-" forState:UIControlStateNormal];
        _BtnMinPriceValue.titleLabel.font = labfont;
        _BtnMinPriceValue.frame = rcMax;
        
        [self addSubview:_BtnMinPriceValue];
    }
    else
        _BtnMinPriceValue.frame = rcMax;
    
    //开盘，时间
    CGRect rcOpen = rcMax;
    rcOpen.origin.x += rcMax.size.width;
    rcOpen.origin.y = rcFrame.origin.y;
    rcOpen.size.width = nPerWidth / 3;
    if (_lblOpenPrice == nil)
    {
        _lblOpenPrice = [[UILabel alloc] initWithFrame:rcOpen];
        _lblOpenPrice.backgroundColor = [UIColor clearColor];
        _lblOpenPrice.textAlignment = NSTextAlignmentLeft;
        _lblOpenPrice.text = @"开盘";
        _lblOpenPrice.font = labfont;
        _lblOpenPrice.textColor = [UIColor whiteColor];
        [self addSubview:_lblOpenPrice];
    }
    else
        _lblOpenPrice.frame = rcOpen;
    
    rcOpen.origin.y += rcOpen.size.height;
    if (_lblTime == nil) 
    {
        _lblTime = [[UILabel alloc] initWithFrame:rcOpen];
        _lblTime.backgroundColor = [UIColor clearColor];
        _lblTime.textColor = [UIColor whiteColor];
        _lblTime.text = @"时间";
        _lblTime.font = labfont;
        _lblTime.textAlignment = NSTextAlignmentLeft;
        
        [self addSubview:_lblTime];
    }
    else
        _lblTime.frame = rcOpen;
    
    rcOpen.origin.x += rcOpen.size.width;
    rcOpen.origin.y = rcFrame.origin.y;
    rcOpen.size.width = nPerWidth / 3 * 2;
    if (_BtnOpenPriceValue == nil)
    {
        _BtnOpenPriceValue = [UIButton buttonWithType:UIButtonTypeCustom];
        _BtnOpenPriceValue.backgroundColor = [UIColor clearColor];
        _BtnOpenPriceValue.frame = rcOpen;
        _BtnOpenPriceValue.titleLabel.font = labfont;
        [_BtnOpenPriceValue setTitle:@"-" forState:UIControlStateNormal];
        
        [self addSubview:_BtnOpenPriceValue];
    }
    else
        _BtnOpenPriceValue.frame = rcOpen;
    
    rcOpen.origin.y += rcOpen.size.height;
    if (_lblTimeValue == nil)
    {
        _lblTimeValue = [[UILabel alloc] initWithFrame:rcOpen];
        _lblTimeValue.backgroundColor = [UIColor clearColor];
        _lblTimeValue.textAlignment = NSTextAlignmentCenter;
        _lblTimeValue.textColor = [UIColor whiteColor];
        _lblTimeValue.font = labfont;
        [self addSubview:_lblTimeValue];
    }
    else
        _lblTimeValue.frame = rcOpen;
}

-(void)setStockInfo:(tztStockInfo *)pStockCode Request:(int)nRequest
{
    [super setStockInfo:pStockCode Request:nRequest];
    [self setFrame:self.frame];
}

-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
//    if (!IS_TZTIPAD) 
//        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageTztNamed:@"TZTHeadPriceBG"]];
    if(IS_TZTIPAD)
    {
        [self layoutSubviews_ipad];
    }
    else
    {
        [self layoutSubviews_iphone];
    }
}


- (void)setPriceData:(TNewPriceData*)priceData len:(int)nLen
{
    [super setPriceData:priceData len:nLen];
    
    self.pStockInfo.stockName = getName_TNewPriceData(_TrendpriceData);
//    self.pStockInfo.stockType = _TrendpriceData->Kind;
    //判断市场类型
    if (MakeIndexMarket(self.pStockInfo.stockType))//指数
    {
        _BtnBlockValue.hidden = YES;
    }
    else if(MakeStockMarket(self.pStockInfo.stockType) && !MakeStockBlock(self.pStockInfo.stockType))//个股
    {
        _BtnBlockValue.hidden = NO;
    }
    else if(MakeHKMarket(self.pStockInfo.stockType))//港股
    {
        _BtnBlockValue.hidden = YES;
    }
    else if(MakeQHMarket(self.pStockInfo.stockType)    //期货
            || MakeWHMarket(self.pStockInfo.stockType) //外汇
            || MakeWPMarket(self.pStockInfo.stockType))//外盘
    {
        _BtnBlockValue.hidden = YES;
    }
    else
    {
        _BtnBlockValue.hidden = YES;
    }
    [self UpdateLabelData];
}


-(CGFloat)CheckFontSize:(NSString*)str
{
    CGRect rcFrame = self.bounds;
    rcFrame.size.height = MIN(60, rcFrame.size.height);
    rcFrame.origin.x += 5;
    rcFrame.size.height -= 6;
    int nPerWidth = rcFrame.size.width  / 3;
    nPerWidth = nPerWidth / 2 + 5;

    CGFloat fFontSize = 9.0f;
    
   [str sizeWithFont:tztUIBaseViewTextFont(13.f)
                       minFontSize:9.0f
                    actualFontSize:&fFontSize
                          forWidth:nPerWidth
                     lineBreakMode:NSLineBreakByCharWrapping];
    
    return fFontSize;
    
}

-(void)UpdateLabelDataOutFund
{
    if (_TrendpriceData == NULL)
        return;
    NSString* nsName = self.pStockInfo.stockName;
    
    if (_lbOutFundName && nsName)
        _lbOutFundName.text = nsName;
    else
        _lbOutFundName.text = @"-";
    
    UIColor* pColor;
    if (_TrendpriceData->Last_p > _TrendpriceData->Close_p)
        pColor = [UIColor tztThemeHQUpColor];
    else if(_TrendpriceData->Last_p < _TrendpriceData->Close_p)
        pColor = [UIColor tztThemeHQDownColor];
    else
        pColor = [UIColor tztThemeHQBalanceColor];
    NSString* nsNewPrice = NSStringOfVal_Ref_Dec_Div(_TrendpriceData->Last_p, 0, _TrendpriceData->nDecimal, 10000);
    if (nsNewPrice && _lbOutFundPrice)
    {
        _lbOutFundPrice.textColor = pColor;
        _lbOutFundPrice.text = nsNewPrice;
    }
    else
        _lbOutFundPrice.text = @"-";
    
    if(MakeHTFundHBMarket(self.pStockInfo.stockType))
    {
        _lbOutFundValue1.textColor = [tztTechSetting getInstance].balanceColor;
        _lbOutFundValue1.text = NSStringOfVal_Ref_Dec_Div(_techData->nWFSY, 0, _techData->nDecimal, 10000);
        
        _lbOutFundValue2.textColor = [tztTechSetting getInstance].axisTxtColor;
        NSString* strValue = @"";
//        if (_techData->nQRNH <= 0)
//        {
//            strValue = @"0.00";
//        }
//        else
        {
            strValue =  NSStringOfVal_Ref_Dec_Div(_techData->nQRNH, 0, 2, 10000);
        }
        strValue = [NSString stringWithFormat:@"%@%@", strValue, @"%"];
        _lbOutFundValue2.text = strValue;
        
    }
    else
    {
        _lbOutFundValue1.textColor = pColor;
        NSString* strValue = @"";
        strValue = NSStringOfVal_Ref_Dec_Div(_techData->nWeekUp, 0, 2, 100);
        strValue = [NSString stringWithFormat:@"%@%@", strValue, @"%"];
        _lbOutFundValue1.text = strValue;
        
        _lbOutFundValue2.textColor = pColor;
        strValue = NSStringOfVal_Ref_Dec_Div(_techData->nMonthUp, 0, 2, 100);
        strValue = [NSString stringWithFormat:@"%@%@", strValue, @"%"];
        _lbOutFundValue2.text = strValue;
    }
    
    if (_btnAddDelStock)
    {
        tztStockInfo *pStock = NewObject(tztStockInfo);
        pStock.stockCode = self.pStockInfo.stockCode;
        pStock.stockType = self.pStockInfo.stockType;
        pStock.stockName = self.pStockInfo.stockName;
        int bExist = [tztUserStock IndexUserStock:pStock];
        
        if (bExist >= 0)//已经存在，删除
        {
            [_btnAddDelStock setBackgroundImage:[UIImage imageTztNamed:@"TZTNavDelStock.png"] forState:UIControlStateNormal];
        }
        else
        {
            [_btnAddDelStock setBackgroundImage:[UIImage imageTztNamed:@"TZTNavAddStock.png"] forState:UIControlStateNormal];
        }
        DelObject(pStock);
    }
    
}

-(void)UpdateLabelData
{
    if (_TrendpriceData == NULL)
        return;
 
    if (MakeHTFundMarket(self.pStockInfo.stockType))
    {
        [self UpdateLabelDataOutFund];
        return;
    }
    //总成交额
    NSString *nsTotal = @"";
    if (MakeIndexMarket(self.pStockInfo.stockType))
    {
        nsTotal = NStringOfFloat(_TrendpriceData->Total_m * 100);
    }
    else
        nsTotal = NStringOfFloat(_TrendpriceData->Total_m);
    
    NSString *nsMax = NSStringOfVal_Ref_Dec_Div(_TrendpriceData->High_p, 0, _TrendpriceData->nDecimal, 1000);
    NSString* nsMin = NSStringOfVal_Ref_Dec_Div(_TrendpriceData->Low_p, 0, _TrendpriceData->nDecimal, 1000);
    
    CGFloat fTotal = 13.0f;
    if ([nsTotal length] > 8)
    {
        fTotal = MIN(fTotal, [self CheckFontSize:nsTotal]);
    }
    if ([nsMax length] > 8)
    {
        fTotal = MIN(fTotal, [self CheckFontSize:nsMax]);
    }
    
    UIFont *newFont = NULL;
    if (fTotal < 13.0f && fTotal > 9.0) 
    {
        newFont = tztUIBaseViewTextFont(fTotal);
    }
    
    NSString *nsName = nil;//[NSString stringWithUTF8String:_TrendpriceData->Name];
    NSString *nsCode = nil;//[NSString stringWithUTF8String:_TrendpriceData->Code];
    if (nsName == nil || [nsName length] < 1)
        nsName = self.pStockInfo.stockName;
    if (nsCode == nil || [nsCode length] < 1)
        nsCode = self.pStockInfo.stockCode;
    //名称
    if (_lblStockName && nsName && [nsName length] > 0)
        _lblStockName.text = nsName;
    else
        _lblStockName.text = @"-";
    
    //代码
    if (_lblStockCode && nsCode && [nsCode length] > 0)
        _lblStockCode.text = nsCode;
    else
        _lblStockCode.text = @"-";
    
    UIColor* pColor;// = [UIColor whiteColor];
    if (_TrendpriceData->Last_p > _TrendpriceData->Close_p)
        pColor = [UIColor tztThemeHQUpColor];
    else if(_TrendpriceData->Last_p < _TrendpriceData->Close_p)
        pColor = [UIColor tztThemeHQDownColor];
    else
        pColor = [UIColor tztThemeHQBalanceColor];
    
    int nUnit = 1000;
    
    if(MakeWHMarket(self.pStockInfo.stockType)) // 外汇除10000 byDBQ130922
    {
        nUnit = 10000;
    }
    
    //最新价
    NSString *nsPrice = NSStringOfVal_Ref_Dec_Div(_TrendpriceData->Last_p, 0, _TrendpriceData->nDecimal, nUnit);
    if (_btnNewPriceValue)
    {
        [_btnNewPriceValue setTitleColor:pColor forState:UIControlStateNormal];
        if (nsPrice && [nsPrice length] > 0)
        {
            [_btnNewPriceValue setTitle:nsPrice forState:UIControlStateNormal];
        }
        else
            [_btnNewPriceValue setTitle:@"-" forState:UIControlStateNormal];
    }
    
    if (_btnAddDelStock && !self.hasNoAddBtn)
    {
        tztStockInfo *pStock = NewObject(tztStockInfo);
        pStock.stockCode = self.pStockInfo.stockCode;
        pStock.stockType = self.pStockInfo.stockType;
        pStock.stockName = self.pStockInfo.stockName;
        int bExist = [tztUserStock IndexUserStock:pStock];
        
        if (bExist >= 0)//已经存在，删除
        {
            [_btnAddDelStock setBackgroundImage:[UIImage imageTztNamed:@"TZTNavDelStock.png"] forState:UIControlStateNormal];
        }
        else
        {
            [_btnAddDelStock setBackgroundImage:[UIImage imageTztNamed:@"TZTNavAddStock.png"] forState:UIControlStateNormal];
        }
        DelObject(pStock);
    }
   
    NSString* strRatioValue = @"--";
    if (_lblRatioValue)
    {
        _lblRatioValue.textColor = pColor;
        //涨跌
        if(_TrendpriceData->Last_p != 0)
            strRatioValue = NSStringOfVal_Ref_Dec_Div(_TrendpriceData->m_lUpPrice, 0, _TrendpriceData->nDecimal, 1000);
        else
            strRatioValue = NSStringOfVal_Ref_Dec_Div(0, 0, 2, 1000);
    }
  
    //涨跌幅
    NSString* nsRange = @"";
    if(_TrendpriceData->Last_p != 0)
    {
        nsRange = NSStringOfVal_Ref_Dec_Div(_TrendpriceData->m_lUpIndex, 0, 2, 100);
    }
    else
    {
        nsRange = NSStringOfVal_Ref_Dec_Div(0, 0, 2, 100);
    }
    nsRange = [NSString stringWithFormat:@"%@%%", nsRange];
    
    strRatioValue = [NSString stringWithFormat:@"%@  %@", strRatioValue, nsRange];
//    if (_lblRangeValue)
//    {
//        _lblRangeValue.textColor = pColor;
//        _lblRangeValue.text = nsRange;
//    }
    [_lblRatioValue setText:strRatioValue];
    
    if(_lblTotalValue)
    {
        if (newFont)
            _lblTotalValue.font = newFont;
        _lblTotalValue.textColor = [tztTechSetting getInstance].sumColor;
        _lblTotalValue.text = nsTotal; 
    }
    
    //昨收
    NSString *nsPreClose = NSStringOfVal_Ref_Dec_Div(_TrendpriceData->Close_p, 0, _TrendpriceData->nDecimal, 1000);
    if(_BtnPreColsePriceValue)
    {
        if (newFont)
            _BtnPreColsePriceValue.titleLabel.font = newFont;
        [_BtnPreColsePriceValue setTitleColor:[UIColor tztThemeHQBalanceColor] forState:UIControlStateNormal];
        [_BtnPreColsePriceValue setTitle:nsPreClose forState:UIControlStateNormal];
    }
    
    //最高，最低
    if (_BtnMaxPriceValue)
    {
        if (newFont)
            _BtnMaxPriceValue.titleLabel.font = newFont;
        [_BtnMaxPriceValue setTitleColor:[UIColor tztThemeHQBalanceColor] forState:UIControlStateNormal];
        [_BtnMaxPriceValue setTitle:nsMax forState:UIControlStateNormal];
        if (_TrendpriceData->High_p > _TrendpriceData->Close_p)
            [_BtnMaxPriceValue setTitleColor:[UIColor tztThemeHQUpColor] forState:UIControlStateNormal];
        else if(_TrendpriceData->High_p < _TrendpriceData->Close_p)
            [_BtnMaxPriceValue setTitleColor:[UIColor tztThemeHQDownColor] forState:UIControlStateNormal];
    }
    
    if (_BtnMinPriceValue)
    {
        if (newFont)
            _BtnMinPriceValue.titleLabel.font = newFont;
        [_BtnMinPriceValue setTitleColor:[UIColor tztThemeHQBalanceColor] forState:UIControlStateNormal];
        [_BtnMinPriceValue setTitle:nsMin forState:UIControlStateNormal];
        if (_TrendpriceData->Low_p > _TrendpriceData->Close_p)
            [_BtnMinPriceValue setTitleColor:[UIColor tztThemeHQUpColor] forState:UIControlStateNormal];
        else if(_TrendpriceData->Low_p < _TrendpriceData->Close_p)
            [_BtnMinPriceValue setTitleColor:[UIColor tztThemeHQDownColor] forState:UIControlStateNormal];
    }
    
    //开盘
    NSString* nsOpen = NSStringOfVal_Ref_Dec_Div(_TrendpriceData->Open_p, 0, _TrendpriceData->nDecimal, 1000);
    if (_BtnOpenPriceValue)
    {
        if (newFont)
            _BtnOpenPriceValue.titleLabel.font = newFont;
        [_BtnOpenPriceValue setTitleColor:[UIColor tztThemeHQBalanceColor] forState:UIControlStateNormal];
        [_BtnOpenPriceValue setTitle:nsOpen forState:UIControlStateNormal];
        if (_TrendpriceData->Open_p > _TrendpriceData->Close_p)
            [_BtnOpenPriceValue setTitleColor:[UIColor tztThemeHQUpColor] forState:UIControlStateNormal];
        if (_TrendpriceData->Open_p < _TrendpriceData->Close_p)
            [_BtnOpenPriceValue setTitleColor:[UIColor tztThemeHQDownColor] forState:UIControlStateNormal];
    }
    
    //时间
    NSString* nsTime = [NSString stringWithFormat:@"%02d:%02d", _TrendpriceData->nHour, _TrendpriceData->nMin];
    if (_lblTimeValue)
    {
        _lblTimeValue.text = nsTime;
        _lblTimeValue.textColor = [UIColor tztThemeHQFixTextColor];
    }
    
    //板块指数
    NSString *nsBlockValue = @"";
    
    NSString* nsBlockCode = getBlockCode_TNewPriceData(_TrendpriceData);
    if (nsBlockCode && nsBlockCode.length > 0)
    {
        if(_TrendpriceData->m_lBlockUpIndex != -10000)
            nsBlockValue = NSStringOfVal_Ref_Dec_Div(_TrendpriceData->m_lBlockUpIndex,0,2,100);
        else
            nsBlockValue = NSStringOfVal_Ref_Dec_Div(0,0,2,100);
        NSString* nsBlockName = getBlockName_TNewPriceData(_TrendpriceData);
        NSString* nsBlock = [NSString stringWithFormat:@"%@\r\n%@%%",nsBlockName,nsBlockValue];
        if (_BtnBlockValue)
        {
            [_BtnBlockValue setTitleColor:[UIColor tztThemeHQBalanceColor] forState:UIControlStateNormal];
            if (_TrendpriceData->m_lBlockUpIndex > 0)
                [_BtnBlockValue setTitleColor:[UIColor tztThemeHQUpColor] forState:UIControlStateNormal];
            else if(_TrendpriceData->m_lBlockUpIndex < 0)
                [_BtnBlockValue setTitleColor:[UIColor tztThemeHQDownColor] forState:UIControlStateNormal];
            [_BtnBlockValue setTztTitleEx:nsBlock];
            
        }
        _BtnBlockValue.hidden = NO;
    }
    else
    {
        _BtnBlockValue.hidden = YES;
    }
}

-(void)OnAddOrDelStock:(id)sender
{
    if (_tztdelegate && [_tztdelegate respondsToSelector:@selector(tzthqView:AddOrDelStockCode:)])
    {
        tztStockInfo *pStock = NewObjectAutoD(tztStockInfo);
        if (self.pStockInfo)
        {
            pStock.stockCode = self.pStockInfo.stockCode;
            pStock.stockName = self.pStockInfo.stockName;
            pStock.stockType = self.pStockInfo.stockType;
        }
        [_tztdelegate tzthqView:self AddOrDelStockCode:pStock];
        [self UpdateLabelData];
    }
}

-(void)OnBtnBlock:(id)sender
{
    //数据传递到上层，不在这里进行跳转
    
    NSString* strCode = getBlockCode_TNewPriceData(_TrendpriceData);
    NSString* strName = getBlockName_TNewPriceData(_TrendpriceData);
    if (strCode.length < 1)
        return;
    if (_tztdelegate && [_tztdelegate respondsToSelector:@selector(tztHqView:OnBlcokClick:)])
    {
        NSMutableDictionary *dict = NewObject(NSMutableDictionary);
        [dict setTztObject:strCode forKey:@"tztParams"];
        [dict setTztObject:@"20199" forKey:@"tztAction"];
        if (strName)
            [dict setTztObject:strName forKey:@"tztTitle"];
        [_tztdelegate tztHqView:self OnBlcokClick:dict];
        [dict release];
    }
}
@end
