//
//  tztTrendView_scroll.m
//  tztMobileApp_HTSC
//
//  Created by King on 14-2-10.
//
//
#import "tztTrendView_scroll.h"
#define tztTrendScrollTag 0x1000

@interface tztTrendScrollCell : UIView
{
    UILabel     *_nameLabel;
    UILabel     *_priceLabel;
    UILabel     *_ratioLabel;
    UILabel     *_codeLabel;
    UInt32      _nStockType;
    
    UIImageView     *_imageLabel;
    BOOL        _bSelected;
}
@property (nonatomic) BOOL  bSelected;
@property (nonatomic) int   nShowType;

-(void)initdata;
-(void)setData:(NSArray*)ayData andType_:(UInt32)nStockType;
-(NSString*)getStockCode;
-(NSString*)getStockName;
-(UInt32)getStockType;
@end

@implementation tztTrendScrollCell
@synthesize bSelected = _bSelected;
@synthesize nShowType = _nShowType;

-(void)initdata
{
    
}

-(void)setBSelected:(BOOL)bFlag
{
    _bSelected = bFlag;
    if (_imageLabel)
        _imageLabel.hidden = !_bSelected;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    _nameLabel.textColor = [UIColor tztThemeHQBalanceColor];
}

-(void)setFrame:(CGRect)frame
{
    if (CGRectIsEmpty(frame) || CGRectIsNull(frame))
        return;
    [super setFrame:frame];
    
    CGRect rcFrame = self.bounds;
    rcFrame.origin.x += 2;
    rcFrame.size.width -= 8;
    rcFrame.size.height -= 10;
    if (_nShowType == 1)
        rcFrame.origin.y += 10;
 
    CGRect rcImage = self.bounds;
    if (_nShowType == 1)
        rcImage.origin.y = 10;
    else
        rcImage.origin.y += rcFrame.size.height;
    rcImage.size.height = 5;
    if (_imageLabel == NULL)
    {
        _imageLabel = [[UIImageView alloc] initWithFrame:rcImage];
        if (_nShowType == 1)
            [_imageLabel setImage:[UIImage imageTztNamed:@"tztKuohuEx"]];
        else
            [_imageLabel setImage:[UIImage imageTztNamed:@"tztKuohu"]];
        [self addSubview:_imageLabel];
        [_imageLabel release];
    }
    else
    {
        _imageLabel.frame = rcImage;
    }
    
    _imageLabel.hidden = !self.bSelected;
    
    int nPerHeight = rcFrame.size.height / 3;
    UIColor *titleColor = [UIColor tztThemeHQBalanceColor];
    CGFloat fontsize = 10.f;
    CGFloat pricesize = 18.0f;
    
    UIFont *labfont = tztUIBaseViewTextFont(fontsize);
    UIFont *pricefont = tztUIBaseViewTextBoldFont(pricesize);
    
    //最新价
    CGRect rcPrice = rcFrame;
    rcPrice.size.height = 2 * nPerHeight;
    if (_priceLabel == NULL)
    {
        _priceLabel = [[UILabel alloc] initWithFrame:rcPrice];
        _priceLabel.backgroundColor = [UIColor clearColor];
        _priceLabel.textAlignment = NSTextAlignmentCenter;
        _priceLabel.textColor = titleColor;
        _priceLabel.font = pricefont;
        _priceLabel.userInteractionEnabled = NO;
        _priceLabel.text = @"-.-";
        _priceLabel.adjustsFontSizeToFitWidth = YES;
        [self addSubview:_priceLabel];
        [_priceLabel release];
    }
    else
    {
        _priceLabel.frame = rcPrice;
    }
    
    if (_codeLabel == NULL)
    {
        _codeLabel = [[UILabel alloc]initWithFrame:rcPrice];
        [self addSubview:_codeLabel];
        _codeLabel.hidden = YES;
        _codeLabel.userInteractionEnabled = NO;
        _codeLabel.text = @"--";
        [_codeLabel release];
    }
    else
    {
        _codeLabel.frame = rcPrice;
    }
    
    //名称
    CGRect rcName = rcFrame;
    rcName.origin.y += rcPrice.size.height - 5;
    rcName.size.height = nPerHeight;
    rcName.size.width = rcFrame.size.width / 2;
    if (_nameLabel == NULL)
    {
        _nameLabel = [[UILabel alloc] initWithFrame:rcName];
        _nameLabel.backgroundColor = [UIColor clearColor];
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        _nameLabel.font = labfont;
        _nameLabel.textColor = [UIColor tztThemeHQBalanceColor];
        _nameLabel.text = @"--";
        _nameLabel.userInteractionEnabled = NO;
        _nameLabel.adjustsFontSizeToFitWidth = YES;
        [self addSubview:_nameLabel];
        [_nameLabel release];
    }
    else
    {
        _nameLabel.frame = rcName;
    }
    
    //涨跌幅
    CGRect rcRatio = rcName;
    rcRatio.origin.x += rcName.size.width;
    if (_ratioLabel == NULL)
    {
        _ratioLabel = [[UILabel alloc] initWithFrame:rcRatio];
        _ratioLabel.backgroundColor = [UIColor clearColor];
        _ratioLabel.textAlignment = NSTextAlignmentCenter;
        _ratioLabel.font = labfont;
        _ratioLabel.textColor = titleColor;
        _ratioLabel.text = @"-.-";
        [self addSubview:_ratioLabel];
        [_ratioLabel release];
        _ratioLabel.userInteractionEnabled = NO;
    }
    else
    {
        _ratioLabel.frame = rcRatio;
    }
}

-(void)setData:(NSArray *)ayData andType_:(UInt32)nStockType
{
    if (ayData == NULL || [ayData count] < 4)
        return;
    _nStockType = nStockType;
    //0-名称，1-最新价，2-涨跌，3-代码
    TZTGridData *ObjName = [ayData objectAtIndex:0];
    TZTGridData *ObjCode = [ayData objectAtIndex:3];
    TZTGridData *ObjPrice = [ayData objectAtIndex:1];
    TZTGridData *ObjRang = [ayData objectAtIndex:2];
    
    if (ObjName == nil || ObjPrice == nil || ObjRang == nil || ObjCode == nil)
        return;
    
    if (_nameLabel)
    {
        NSString* nsName = [NSString stringWithFormat:@"%@", ObjName.text];
        NSArray* pAy = [nsName componentsSeparatedByString:@"."];
        if ([pAy count] > 1)
        {
            nsName = [NSString stringWithFormat:@"%@", [pAy objectAtIndex:1]];
        }
        else
        {
            nsName = [NSString stringWithFormat:@"%@", nsName];
        }
        _nameLabel.text = nsName;
    }
    if (_priceLabel)
    {
        _priceLabel.text = ObjPrice.text;
        _priceLabel.textColor = ObjPrice.textColor;
    }
    
    if (_ratioLabel)
    {
        _ratioLabel.textColor = ObjRang.textColor;
        _ratioLabel.text = ObjRang.text;
    }
    if (_codeLabel)
    {
        _codeLabel.text = ObjCode.text;
    }
}

-(NSString*)getStockCode
{
    if (_codeLabel)
    {
        NSString *strCode = _codeLabel.text;
        if (strCode && [strCode compare:@"--"] == NSOrderedSame)
            strCode = @"";
        return strCode;
    }
    return @"";
}

-(NSString*)getStockName
{
    if (_nameLabel)
        return _nameLabel.text;
    return @"";
}

-(UInt32)getStockType
{
    return _nStockType;
}

@end

@interface tztTrendView_scroll()
{
    NSInteger     _nCurSel;
    BOOL        _bFlag;
    BOOL        _bRequest;
    
    UInt16      _ntztHqReq;
    
    UISwipeGestureRecognizer    *_pSwipeLeft;
    UISwipeGestureRecognizer    *_pSwipeRight;
}
@property(nonatomic,retain)UISwipeGestureRecognizer *pSwipeLeft;
@property(nonatomic,retain)UISwipeGestureRecognizer *pSwipeRight;
@property(nonatomic,retain)UIButton *pHiddenBtn;
@end

@implementation tztTrendView_scroll
@synthesize pScrollView = _pScrollView;
@synthesize pTrendView = _pTrendView;
@synthesize pAyButton = _pAyButton;
@synthesize pAyData = _pAyData;
@synthesize nShowTop = _nShowTop;
@synthesize pSwipeLeft = _pSwipeLeft;
@synthesize pSwipeRight = _pSwipeRight;
@synthesize hasHiddenBtn = _hasHiddenBtn;
@synthesize nHiddenBtnWidth = _nHiddenBtnWidth;
@synthesize pHiddenBtn = _pHiddenBtn;
@synthesize tztDelegate = _tztDelegate;
@synthesize dataArray = _dataArray;
@synthesize ayStockType =_ayStockType;
@synthesize trendButton;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
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

-(void)dealloc
{
    [[tztMoblieStockComm gethqInstance] removeObj:self];
    [super dealloc];
}

-(void)initdata
{
    _nCurSel = -1;
    [[tztMoblieStockComm gethqInstance] addObj:self];
}

-(void)onSetViewRequest:(BOOL)bRequest
{
    _bRequest = bRequest;
    if (!_bRequest)//不请求数据，从通讯数组中移除当前句柄
    {
        [[tztMoblieStockComm getSharehqInstance] removeObj:self];
    }
    else//请求数据，则添加
    {
        [[tztMoblieStockComm getSharehqInstance] addObj:self];
    }
    if (self.pTrendView)
    {
        [self.pTrendView onSetViewRequest:bRequest];
    }
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    self.backgroundColor = [UIColor tztThemeBackgroundColorHQ];
    _pScrollView.backgroundColor = [UIColor tztThemeBackgroundColorHQ];
    if (g_nHQBackBlackColor)
        _pTrendView.nsBackColor = @"0";//默认黑色
    else
        _pTrendView.nsBackColor = @"1";
    [_pTrendView setNeedsDisplay];
}

-(void)setFrame:(CGRect)frame
{
    if (CGRectIsEmpty(frame) || CGRectIsNull(frame))
        return;
    [super setFrame:frame];
    
    CGRect rcFrame = self.bounds;
    
    if (_hasHiddenBtn)
    {
        if (_nHiddenBtnWidth <= 0)
            _nHiddenBtnWidth = 30;
    }
    else
        _nHiddenBtnWidth = 0;
    
    CGRect rcScroll = rcFrame;
    rcScroll.size.height = rcScroll.size.height / 3;
    if (rcScroll.size.height < 40)
        rcScroll.size.height = 40;
    rcScroll.size.width -= _nHiddenBtnWidth;
    if (_nShowTop == 1)//显示在下面
        rcScroll.origin.y = rcFrame.size.height - rcScroll.size.height;
    
    if (_pScrollView == NULL)
    {
        _pScrollView = [[UIScrollView alloc] initWithFrame:rcScroll];
        _pScrollView.backgroundColor = [UIColor tztThemeBackgroundColorHQ];
        _pScrollView.pagingEnabled = YES;
        [self addSubview:_pScrollView];
        [_pScrollView release];
    }
    else
    {
        _pScrollView.frame = rcScroll;
    }
    
    //＋5是上面括号的高度
    CGRect rcButton = CGRectMake(self.frame.size.width - _nHiddenBtnWidth, rcScroll.origin.y + 5, _nHiddenBtnWidth, rcScroll.size.height / 3 * 2);
    if (_pHiddenBtn == NULL)
    {
        _pHiddenBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _pHiddenBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_pHiddenBtn setBackgroundColor:[UIColor clearColor]];
        CGAffineTransform at = CGAffineTransformMakeRotation(0);
        [_pHiddenBtn setTztTitle:@"▲"];///▲▶︎
        if (self.ishidden)
        {
        }
        else
        {
            at = CGAffineTransformMakeRotation(-M_PI);
        }
        [self.pHiddenBtn setTransform:at];
        [_pHiddenBtn setTztTitleColor:[UIColor colorWithTztRGBStr:@"82,82,82"]];
        [_pHiddenBtn.titleLabel setFont:tztUIBaseViewTextFont(13.f)];
        _pHiddenBtn.frame = rcButton;
        _pHiddenBtn.showsTouchWhenHighlighted = YES;
        [self addSubview:_pHiddenBtn];
        [_pHiddenBtn addTarget:self action:@selector(OnBtnHiden) forControlEvents:UIControlEventTouchUpInside];
    }
    else
    {
        _pHiddenBtn.frame = rcButton;
    }
    _pHiddenBtn.hidden = !_hasHiddenBtn;
 //   _pHiddenBtn.hidden = TRUE;
    CGRect rcTrend = rcFrame;
    rcTrend.origin.x += 2;
    rcTrend.size.width -= 5;
    rcTrend.size.height -= rcScroll.size.height-15;
    if (_nShowTop == 0)
    {
        rcTrend.origin.y += rcScroll.size.height;
//        rcTrend.size.height -= 5;
    }
    else
        rcTrend.origin.y += 10;
    if (_pTrendView == NULL)
    {
        _pTrendView = [[tztTrendView alloc] initWithFrame:rcTrend];
        trendButton = [[UIButton alloc] initWithFrame:rcTrend];
        [trendButton addTarget:self action:@selector(InsideTrend:) forControlEvents:UIControlEventTouchDown];
        _pTrendView.tztdelegate = self;
        _pTrendView.bHideVolume = TRUE;
        _pTrendView.bHideFundFlows = TRUE;
        _pTrendView.bShowMaxMinPrice = TRUE;
        _pTrendView.bSupportTrendCursor = FALSE;
        _pTrendView.bShowAvgPriceLine = FALSE;
        _pTrendView.bShowLeadLine = FALSE;
        _pTrendView.bShowRightRatio = FALSE;
        _pTrendView.tztPriceStyle = TrendPriceNon;
        [self addSubview:_pTrendView];
        [self addSubview:trendButton];
        [_pTrendView release];
        [trendButton release];
    }
    else
    {
        _pTrendView.frame = rcTrend;
        trendButton.frame = rcTrend;
    }
    
  //  [self setHiddButtonArrow];
    if (self.pSwipeLeft == NULL)
    {
        self.pSwipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(OnMoveLeftRight:)];
        [self.pSwipeLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
        [self addGestureRecognizer:self.pSwipeLeft];
    }
    
    if (self.pSwipeRight == NULL)
    {
        self.pSwipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(OnMoveLeftRight:)];
        [self.pSwipeRight setDirection:UISwipeGestureRecognizerDirectionRight];
        [self addGestureRecognizer:self.pSwipeRight];
    }
}

-(void)InsideTrend:(id)sender
{
    if (_nCurSel >= [_pAyButton count] || _nCurSel >= [_pAyData count])
    {
        return;
    }
    tztTrendScrollCell *pCell = [_pAyData objectAtIndex:_nCurSel];
    NSString* stockcode = [pCell getStockCode];
    tztStockInfo *pStock = NewObject(tztStockInfo);
    pStock.stockCode = [NSString stringWithFormat:@"%@", stockcode];
    if (_ayStockType && _nCurSel < [_ayStockType count])
    {
        NSString* strType = [_ayStockType objectAtIndex:_nCurSel];
        if (strType && [strType length] > 0)
        {
            pStock.stockType = [strType intValue];
        }
    }
    NSArray *arr = [self getSendStockArray:self.dataArray];
    [TZTUIBaseVCMsg OnMsg:MENU_HQ_Trend wParam:(NSUInteger)pStock lParam:(NSUInteger)arr];
    [pStock release];
}


-(void)OnMoveLeftRight:(UISwipeGestureRecognizer*)recognizer
{
    if (recognizer.direction == UISwipeGestureRecognizerDirectionLeft)//向左滑动，右移
    {
        NSInteger nSel = _nCurSel;
        nSel++;
        if (nSel >= [_pAyData count])
            nSel = 0;
        [self DealWithSelect:nSel bFirst_:FALSE];
    }
    if (recognizer.direction == UISwipeGestureRecognizerDirectionRight)//向右滑动，左移
    {
        NSInteger nSel = _nCurSel;
        nSel--;
        if (nSel < 0)
            nSel = [_pAyData count]-1;
        [self DealWithSelect:nSel bFirst_:FALSE];
    }
}

-(void)OnBtnHiden
{
    [self setHiddButtonArrow];
    if (self.tztDelegate && [self.tztDelegate respondsToSelector:@selector(tztTrendScroll:showOrHiddenWithRect:)])
    {
        [self.tztDelegate tztTrendScroll:self showOrHiddenWithRect:self.frame];
    }
}

-(void)setHiddButtonArrow
{
    [UIView animateWithDuration:0.2f
                     animations:^{
                         
                         if (self.ishidden)
                         {
                             CGAffineTransform at = CGAffineTransformMakeRotation(-M_PI);
                             [self.pHiddenBtn setTransform:at];
                         }
                         else
                         {
                             CGAffineTransform at = CGAffineTransformMakeRotation(0);
                             [self.pHiddenBtn setTransform:at];
                         }
                     }];
}

-(void)RequestReportData
{
    _bRequest = TRUE;
    [self onRequestData:1];
    _bFlag = TRUE;
}

-(void)onRequestData:(BOOL)bShowProcess
{
    TZTNSLog(@"%@",@"onRequestData");
    if(_bRequest)
    {
        NSMutableDictionary* sendvalue = NewObject(NSMutableDictionary);
        [sendvalue setTztValue:@"1A0001,2A01,1A0300" forKey:@"Grid"];
        [sendvalue setTztValue:@"1" forKey:@"StockIndex"];
        [sendvalue setTztObject:[NSString stringWithFormat:@"%d", 1] forKey:@"NewMarketNo"];
        [sendvalue setTztObject:[NSString stringWithFormat:@"%d",0] forKey:@"StartPos"];
        [sendvalue setTztObject:[NSString stringWithFormat:@"%d",10] forKey:@"MaxCount"];
        [sendvalue setTztObject:[NSString stringWithFormat:@"%d",9] forKey:@"AccountIndex"];
        [sendvalue setTztObject:@"1" forKey:@"Direction"];
        [sendvalue setTztObject:@"0" forKey:@"DeviceType"];
        [sendvalue setTztObject:@"1" forKey:@"Lead"];
        _ntztHqReq++;
        if(_ntztHqReq >= UINT16_MAX)
            _ntztHqReq = 1;
        NSString* strReqno = tztKeyReqno((long)self, _ntztHqReq);
        [sendvalue setTztObject:strReqno forKey:@"Reqno"];
        [[tztMoblieStockComm getSharehqInstance] onSendDataAction:@"60" withDictValue:sendvalue];
        DelObject(sendvalue);
    }
}

-(NSUInteger)OnRequestData:(NSUInteger)wParam lParam_:(NSUInteger)lParam
{
    [self onRequestData:1];
    return 1;
}

-(NSUInteger)OnCommNotify:(NSUInteger)wParam lParam_:(NSUInteger)lParam
{
    if( wParam == 0 )
        return 0;
    tztNewMSParse *parse = (tztNewMSParse*)wParam;
    if([parse GetAction] == 60 && [parse IsIphoneKey:(long)self reqno:_ntztHqReq])
    {
        NSArray* ayGridVol = [parse GetArrayByName:@"Grid"];
        if(ayGridVol == nil || [ayGridVol count] <= 0)
        {
            [self showMessageBox:@"查无相应的排名数据!" nType_:TZTBoxTypeNoButton nTag_:0];
            return 0;
        }
        
        //
        NSInteger nCodeIndex = -1;
        NSInteger nNameIndex = -1;
        
        NSString *strIndex = [parse GetByName:@"stocknameindex"];
        TZTStringToIndex(strIndex, nNameIndex);
        
        strIndex = [parse GetByName:@"stockcodeindex"];
        TZTStringToIndex(strIndex, nCodeIndex);
        
        NSMutableArray *ayStockData = NewObject(NSMutableArray);
        NSMutableArray* ayTitle = NewObject(NSMutableArray);
        NSMutableArray* ayGridData = NewObject(NSMutableArray);
        NSData* DataBinData = [parse GetNSData:@"BinData"];
        if(DataBinData && [DataBinData length] > 0)
        {
            NSArray* ayValue = [ayGridVol objectAtIndex:0];
#ifndef tzt2013Protocol
            char *pColor = (char*)[DataBinData bytes];
#else
            NSString* strBase = [parse GetByName:@"BinData"];
            DataBinData = [NSData tztdataFromBase64String:strBase];
            char *pColor = (char*)[DataBinData bytes];
#endif
            if(pColor)
                pColor = pColor + 2;//时间 2个字节
            for (int i = 0; i < [ayValue count]; i++)
            {
                TZTGridDataTitle* obj = NewObject(TZTGridDataTitle);
                NSString* str = [ayValue objectAtIndex:i];
                obj.text = str;
                if(pColor)
                {
                    obj.textColor = [UIColor colorWithChar:*pColor];
                }
                [obj setTagValue];
                [ayTitle addObject:obj];
                if(pColor)
                    pColor++;
                [obj release];
            }
            NSString* strGridType = [parse GetByName:@"NewMarketNo"];
            if (strGridType == NULL || strGridType.length < 1)
                strGridType = [parse GetByName:@"DeviceType"];
//            NSArray* ayGridType = [strGridType componentsSeparatedByString:@"|"];
//            if(_ayStockType == NULL)
//                _ayStockType = NewObject(NSMutableArray);
//            [_ayStockType removeAllObjects];
//            for (int i = 0; i < [ayGridType count]; i++)
//            {
//                NSString* strtype = [ayGridType objectAtIndex:i];
//                if (strtype)
//                    [_ayStockType addObject:strtype];
//                else
//                    [_ayStockType addObject:@"0"];
//            }
            
            for (int i = 1; i < [ayGridVol count]; i++)
            {
                NSArray* ayData = [ayGridVol objectAtIndex:i];
                NSMutableArray* ayGridValue = NewObject(NSMutableArray);
                
                if (nNameIndex < 0)
                    nNameIndex = 0;
                if (nCodeIndex < 0)
                    nCodeIndex = [ayData count] -1;
                NSMutableDictionary* pStockDict = NewObject(NSMutableDictionary);
                if ([ayData count] < 4)
                    continue;
                
                //0-名称，1-最新价，2-涨跌，3-代码
                for (int j = 0; j < [ayData count]; j++) //最后一个竖线
                {
                    if (j == nNameIndex)
                    {
                        NSString* nsName = [NSString stringWithFormat:@"%@", [ayData objectAtIndex:j]];
                        NSArray* pAy = [nsName componentsSeparatedByString:@"."];
                        if ([pAy count] > 1)
                        {
                            nsName = [NSString stringWithFormat:@"%@", [pAy objectAtIndex:1]];
                        }
                        else
                        {
                            nsName = [NSString stringWithFormat:@"%@", nsName];
                        }
                        [pStockDict setTztValue:nsName forKey:@"Name"];
                    }
                    if (j == nCodeIndex)
                    {
                        NSString* strCode = [NSString stringWithFormat:@"%@", [ayData objectAtIndex:j]];
                        [pStockDict setTztValue:strCode forKey:@"Code"];
                    }
                    
                    TZTGridData* GridData = NewObject(TZTGridData);
                    GridData.text = [ayData objectAtIndex:j];
                    if(pColor)
                        GridData.textColor = [UIColor colorWithChar:*pColor];
                    [ayGridValue addObject:GridData];
                    [GridData release];
                    if(pColor)
                        pColor++;
                }
                [ayStockData addObject:pStockDict];
                [pStockDict release];
                
                [ayGridData addObject:ayGridValue];
                [ayGridValue release];
            }
        }
        [ayStockData release];
        
        
        NSMutableArray *ayData = NewObject(NSMutableArray);
        for (int i = 0; i < [ayGridData count]; i++)
        {
            NSArray *ay = [ayGridData objectAtIndex:i];
            if (ay == NULL || [ay count] < 4)
                continue;
            NSMutableArray *ayTempData = NewObject(NSMutableArray);
            [ayTempData addObject:[ay objectAtIndex:0]];
            [ayTempData addObject:[ay objectAtIndex:1]];
            [ayTempData addObject:[ay objectAtIndex:2]];
            [ayTempData addObject:[ay objectAtIndex:[ay count] - 1]];
            
            [ayData addObject:ayTempData];
            [ayTempData release];
        }
        [self setAyScrollData:ayData];
        [ayData release];
//        [self setAyScrollData:ayGridData];
        [ayGridData release];
        [ayTitle release];
        [self FixStockData:parse];
    }
    
    return 1;
}

-(void)FixStockData:(tztNewMSParse *)pParse
{
    if (_dataArray == NULL)
    {
        _dataArray = NewObject(NSMutableArray);
    }
    [self.dataArray removeAllObjects];
    NSArray *ayGridVol = [pParse GetArrayByName:@"Grid"];
    //颜色
    NSString* strBase = [pParse GetByName:@"BinData"];
    NSData* DataBinData = [NSData tztdataFromBase64String:strBase];
    char *pColor = (char*)[DataBinData bytes];
    if(pColor)
        pColor = pColor + 2;//时间 2个字节
    NSInteger nCodeIndex = -1;//代码索引
    /*
     
     注：
     
     默认返回数据的固定位置，然后去获取索引，若没索引，直接用固定制*/
    
    NSInteger nNameIndex = 0;//名称索引
    
    NSInteger nPriceIndex = 1;//最新价索引
    
    NSInteger nRatioIndex = 3;//涨跌索引
    
    NSInteger nRangeIndex = 2;//幅度索引
    
    NSInteger nTotalValueIndex = 10;//总市值索引
    
    
    
    NSString *strIndex = [pParse GetByName:@"stockcodeindex"];
    
    //        TZTStringToIndex(strIndex, nCodeIndex);
    
    
    
    strIndex = [pParse GetByName:@"stocknameindex"];
    
    TZTStringToIndex(strIndex, nNameIndex);
    
    if (nNameIndex < 0)
        
        nNameIndex = 0;
    
    
    
    strIndex = [pParse GetByName:@"NewPriceIndex"];
    
    TZTStringToIndex(strIndex, nPriceIndex);
    
    if (nPriceIndex < 0)
        
        nPriceIndex = 1;
    
    
    
    strIndex = [pParse GetByName:@"UPDOWNINDEX"];
    
    TZTStringToIndex(strIndex, nRatioIndex);
    
    if (nRatioIndex < 0)
        
        nRatioIndex = 3;
    
    
    
    strIndex = [pParse GetByName:@"UPDOWNPINDEX"];
    
    TZTStringToIndex(strIndex, nRangeIndex);
    
    if (nRangeIndex < 0)
        
        nRangeIndex = 2;
    
    
    
    strIndex = [pParse GetByName:@"TotalMIndex"];
    
    TZTStringToIndex(strIndex, nTotalValueIndex);
    
    if (nTotalValueIndex < 0)
        
        nTotalValueIndex = 10;
    
    
    
    
    
    /*目前只解析了数据，没有解析股票的市场类型，请参照reportList里ayStockType进行完善，因为点击跳转到分时的时候，需要用到改市场类型进行判断*/
    
    
    
    NSString* strGridType = [pParse GetByName:@"NewMarketNo"];
    
    if (strGridType == NULL || strGridType.length < 1)
        
        strGridType = [pParse GetByName:@"DeviceType"];
    
    NSArray* ayGridType = [strGridType componentsSeparatedByString:@"|"];
    if(_ayStockType == NULL)
        
        _ayStockType = NewObject(NSMutableArray);
    
    [_ayStockType removeAllObjects];
    
    for (int i = 0; i < [ayGridType count]; i++)
        
    {
        
        NSString* strtype = [ayGridType objectAtIndex:i];
        
        if (strtype)
            
            [_ayStockType addObject:strtype];
        
        else
            
            [_ayStockType addObject:@"0"];
        
    }
    

    //增加掉标题颜色偏移处理
    
    if (ayGridVol.count > 0)
    {
        NSArray* ay = [ayGridVol objectAtIndex:0];
        pColor += [ay count];
    }
    for (int i = 1; i < [ayGridVol count]; i++)
    {
        NSArray* ayData = [ayGridVol objectAtIndex:i];
        if (nNameIndex < 0)
            nNameIndex = 0;
        if (nCodeIndex < 0)
            nCodeIndex = [ayData count] -1;
        NSMutableDictionary* pStockDict = NewObject(NSMutableDictionary);
        for (int j = 0; j < [ayData count]; j++) //最后一个竖线
        {
            NSString* strValue = @"";
            NSString* strKey = @"";
            UIColor*  txtColor = nil;
            BOOL bDeal = FALSE;
            if (j == nNameIndex)
            {
                bDeal = YES;
                strKey = @"Name";
                strValue = [NSString stringWithFormat:@"%@", [ayData objectAtIndex:j]];
                NSArray* pAy = [strValue componentsSeparatedByString:@"."];
                if ([pAy count] > 1)
                {
                    strValue = [NSString stringWithFormat:@"%@", [pAy objectAtIndex:1]];
                }
                else
                {
                    strValue = [NSString stringWithFormat:@"%@", strValue];
                }
                if (pColor)
                    txtColor = [UIColor colorWithChar:*pColor];
            }
            else if (j == nCodeIndex)
            {
                bDeal = YES;
                
                strKey = @"Code";
                
                strValue = [NSString stringWithFormat:@"%@", [ayData objectAtIndex:j]];
                
                if (pColor)
                    
                    txtColor = [UIColor colorWithChar:*pColor];
                
            }
            else if (j == nPriceIndex)//最新价
            {
                
                bDeal = YES;
                
                strKey = @"NewPrice";
                
                strValue = [NSString stringWithFormat:@"%@", [ayData objectAtIndex:j]];
                
                if (pColor)
                    
                    txtColor = [UIColor colorWithChar:*pColor];
                
            }
            else if (j == nRatioIndex)//涨跌值
            {
                
                bDeal = YES;
                
                strKey = @"Ratio";
                
                strValue = [NSString stringWithFormat:@"%@", [ayData objectAtIndex:j]];
                
                if (pColor)
                    
                    txtColor = [UIColor colorWithChar:*pColor];
                
            }
            else if (j == nRangeIndex)//涨跌幅
            {
                
                bDeal = YES;
                
                strKey = @"Range";
                
                strValue = [NSString stringWithFormat:@"%@", [ayData objectAtIndex:j]];
                
                if (pColor)
                    
                    txtColor = [UIColor colorWithChar:*pColor];
                
            }
            else if (j == nTotalValueIndex)//总市值
            {
                
                bDeal = YES;
                
                strKey = @"TotalValue";
                
                strValue = [NSString stringWithFormat:@"%@", [ayData objectAtIndex:j]];
                
                if (pColor)
                    
                    txtColor = [UIColor colorWithChar:*pColor];
                
            }
            if (bDeal)
            {
                
                NSMutableDictionary* pDict = NewObject(NSMutableDictionary);
                
                [pDict setTztObject:strValue forKey:@"value"];
                
                if (txtColor)
                    
                    [pDict setTztObject:txtColor forKey:@"color"];
                
                [pStockDict setTztObject:pDict forKey:strKey];
                
            }
            pColor++;
        }
        if (ayGridType && [ayGridType count] > (i-1))
        {
            [pStockDict setTztObject:[ayGridType objectAtIndex:(i-1)] forKey:@"StockType"];
        }
        [self.dataArray addObject:pStockDict];
        [pStockDict release];
    }
}

-(void)setAyScrollData:(NSMutableArray*)ayData
{
    if (_pAyButton == NULL)
        _pAyButton = NewObject(NSMutableArray);
    
    if (_pAyData == NULL)
        _pAyData = NewObject(NSMutableArray);
    
    for (int i = 0; i < [_pAyButton count]; i++)
    {
        UIView *pView = [_pScrollView viewWithTag:tztTrendScrollTag + i];
        if (pView)
            [pView removeFromSuperview];
    }
    
    if (_hasHiddenBtn)
    {
        if (_nHiddenBtnWidth <= 0)
            _nHiddenBtnWidth = 40;
    }
    else
        _nHiddenBtnWidth = 0;
    
    float fTrendBtnWidth = (self.frame.size.width - _nHiddenBtnWidth) / 3;
    int nWidth = [ayData count] * fTrendBtnWidth;
    
    _pScrollView.contentSize = CGSizeMake(MAX(nWidth, _pScrollView.frame.size.width), _pScrollView.frame.size.height);
    
    [_pAyButton removeAllObjects];
    [_pAyData removeAllObjects];
    
    CGRect rcSwitch = _pScrollView.bounds;
    rcSwitch.origin.x = 0;
    rcSwitch.size.width = fTrendBtnWidth;
    for (int i = 0; i < [ayData count]; i++)
    {
        tztUISwitch *pSwitch = [[tztUISwitch alloc] initWithFrame:rcSwitch];
        tztTrendScrollCell *pCell = NewObject(tztTrendScrollCell);
        pCell.nShowType = _nShowTop;
        pCell.userInteractionEnabled = NO;
        pSwitch.yesImage = nil;
        pCell.frame = CGRectMake(0, 0, rcSwitch.size.width, rcSwitch.size.height);
        [pSwitch addSubview:pCell];
        pSwitch.tag = tztTrendScrollTag + i;
        if (_nCurSel == i)
            pCell.bSelected = TRUE;
        else
            pCell.bSelected = FALSE;
        [pSwitch addTarget:self action:@selector(OnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_pScrollView addSubview:pSwitch];
        [_pAyButton addObject:pSwitch];
        [_pAyData addObject:pCell];
        [pCell setData:[ayData objectAtIndex:i] andType_:0];
        [pCell release];
        [pSwitch release];
        rcSwitch.origin.x += rcSwitch.size.width;
    }
    
    [self DealWithSelect:_nCurSel bFirst_:NO];
}

-(void)OnClick:(id)sender
{
    tztUISwitch *pSwitch = (tztUISwitch*)sender;
    if (pSwitch == NULL)
        return;
    
    NSInteger nSel = pSwitch.tag - tztTrendScrollTag;
    
    if (nSel == _nCurSel)
    {
        [self JumpStock:nSel];
        return;
    }
    
    [self DealWithSelect:nSel bFirst_:FALSE];
    [self JumpStock:nSel];
}

-(void)JumpStock:(NSInteger)nSel
{
    BOOL bHidden = [[NSUserDefaults standardUserDefaults] boolForKey:@"trendscrollHidden"];//lxy 2011.11.17增加点击大盘的跳转
    if(!bHidden)
    {
        return;
    }
    if (nSel < 0)
    {
        nSel = 0;
    }
    if (nSel >= [_pAyButton count] || nSel >= [_pAyData count])
    {
        return;
    }

    tztTrendScrollCell *pCell = [_pAyData objectAtIndex:_nCurSel];
    NSString* stockcode = [pCell getStockCode];
    NSString* stockname = [pCell getStockName]; // 增加名字，不然行情首页进去没有name   Tjf
    tztStockInfo *pStock = NewObject(tztStockInfo);
    pStock.stockCode = [NSString stringWithFormat:@"%@", stockcode];
    pStock.stockName = [NSString stringWithFormat:@"%@", stockname];
    if (_ayStockType && nSel < [_ayStockType count])
    {
        NSString* strType = [_ayStockType objectAtIndex:nSel];
        if (strType && [strType length] > 0)
        {
            pStock.stockType = [strType intValue];
        }
    }
    NSArray *arr = [self getSendStockArray:self.dataArray];
    [TZTUIBaseVCMsg OnMsg:MENU_HQ_Trend wParam:(NSUInteger)pStock lParam:(NSUInteger)arr];
    [pStock release];
}

- (NSMutableArray *)getSendStockArray:(NSMutableArray *)sourceArray
{
    int i = 0;
    for (NSMutableDictionary *pDict in sourceArray) {
        
        if (_ayStockType && i < [_ayStockType count])
        {
            NSString* strType = [_ayStockType objectAtIndex:i];
            if (strType && [strType length] > 0)
            {
                [pDict setObject:strType forKey:@"StockType"];
            }
        }
        i ++;
    }
    
    return sourceArray;
}

-(void)DealWithSelect:(NSInteger)nSel bFirst_:(BOOL)bFirst
{
    if (nSel < 0)
        nSel = 0;
    if (nSel >= [_pAyButton count] || nSel >= [_pAyData count])
        return;
    
    if (_nCurSel == nSel && !_bFlag)
        return;
    _nCurSel = nSel;
    _bFlag = FALSE;
    //选中效果
    for (int i = 0; i < [_pAyData count]; i++)
    {
        tztTrendScrollCell *pCell = [_pAyData objectAtIndex:i];
        if (i == _nCurSel)
        {
            pCell.bSelected = TRUE;
        }
        else
            pCell.bSelected = FALSE;
        [pCell setNeedsLayout];
    }
    
    //分时切换
    tztTrendScrollCell *pCell = [_pAyData objectAtIndex:_nCurSel];
    NSString* stockcode = [pCell getStockCode];
    UInt32 nStockType = [pCell getStockType];
    
    tztStockInfo *pStock = NewObject(tztStockInfo);
    pStock.stockCode = [NSString stringWithFormat:@"%@", stockcode];
    pStock.stockType = nStockType;
    if (pStock.stockCode && [pStock.stockCode caseInsensitiveCompare:self.pTrendView.pStockInfo.stockCode] == NSOrderedSame && (pStock.stockType == self.pTrendView.pStockInfo.stockType || pStock.stockType == 0))
    {
        [self.pTrendView onRequestData:1];
    }
    else
    {
        [self.pTrendView setStockInfo:pStock Request:1];
    }
//    _pTrendView.pStockInfo = pStock;
//    static BOOL bFirstFlag = YES;
//    if (bFirstFlag)
//    {
//        [_pTrendView setStockInfo:pStock Request:1];
//        bFirstFlag = NO;
//    }
//    else
//    {
//        [_pTrendView onRequestData:1];
//    }
//    if (_pTrendView)
//    {
//        [_pTrendView setStockInfo:pStock Request:1];
//    }
//    if(!bFirst)
//    {
//        BOOL bHidden = [[NSUserDefaults standardUserDefaults] boolForKey:@"trendscrollHidden"];//lxy 2011.11.17增加点击大盘的跳转
//        if(bHidden)
//        {
//            NSArray *arr = [self getSendStockArray:self.dataArray];
//            [TZTUIBaseVCMsg OnMsg:MENU_HQ_Trend wParam:(NSUInteger)pStock lParam:(NSUInteger)arr];
//        }
//    }
    [pStock release];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
