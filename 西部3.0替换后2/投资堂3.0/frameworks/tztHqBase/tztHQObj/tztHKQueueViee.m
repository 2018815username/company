/*
 */
#import "tztHKQueueViee.h"

#define tztHKCellKey    @"tztHKCellKey"
#define tztHKCellName   @"tztHKCellName"
#define tztHKCellPrice  @"tztHKCellPrice"
#define tztHKCellPriceColor @"tztHKCellPriceColor"
#define tztHKCellTotal  @"tztHKCellTotal"
#define tztHKCellData   @"tztHKCellData"
#define tztHKCellDataString @"tztHKCellDataString"

@interface tztHKQueueVieeIn : UIView
{
    TNewOrderQueue *_pQueueData;
}

-(void)onClearData;
-(void)setQueueData:(NSData*)nsData;
@end

@implementation tztHKQueueVieeIn
-(id)init
{
    if (self = [super init])
    {
        [self initData];
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self initData];
    }
    return self;
}

-(void)initData
{
    if (_pQueueData == NULL)
        _pQueueData = malloc(sizeof(TNewOrderQueue));
    memset(_pQueueData, 0x00, sizeof(TNewOrderQueue));
}

-(void)onClearData
{
    if (_pQueueData)
        memset(_pQueueData, 0x00, sizeof(TNewOrderQueue));
}

-(void)setQueueData:(NSData *)nsData
{
    if (_pQueueData == NULL)
        _pQueueData = malloc(sizeof(TNewOrderQueue));
    
    if (nsData)
    {
        memcpy(_pQueueData, [nsData bytes], MIN([nsData length], sizeof(TNewOrderQueue)));
    }
    [self setNeedsDisplay];
}

//-(void)drawRect:(CGRect)rect
//{
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    UIFont *pFont = tztUIBaseViewTextFont(14.0f);// [tztTechSetting getInstance].drawTxtFont;
//    NSString *text = @"";
//    UIColor *textColor = [UIColor tztThemeHQFixTextColor];
//    CGContextSetStrokeColorWithColor(context, textColor.CGColor);
//    CGContextSetFillColorWithColor(context, textColor.CGColor);
//    //计算输出高度
//    CGSize szDrawSize;
//    //调整输出位置
//    int nBaseLine = 0;
//    
//    //从卖10-买10进行绘制，并记录下卖1的位置，作为剧中位置进行显示
//    
//    
//}

@end

#define tztCellMargin (5)
#define tztCellDataTag 0x1234
@interface tztHKDataCellView : UILabel

@property(nonatomic)int nCols;
@property(nonatomic,retain)NSMutableArray *ayData;
@property(nonatomic,retain)NSMutableArray *ayViews;

-(void)SetDataContent:(NSMutableArray*)ayData andCols_:(int)nCol;
@end

@implementation tztHKDataCellView

-(id)init
{
    if (self = [super init])
    {
        
    }
    return self;
}

-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    if (_nCols < 1)
        _nCols = 1;
    NSInteger nRows = self.ayData.count / _nCols + ((self.ayData.count % _nCols == 0) ? 0 : 1);
    CGRect rcFrame = self.bounds;
    
    int nWidth = (rcFrame.size.width - (_nCols + 1) * tztCellMargin) / _nCols;
    int nHeight = (rcFrame.size.height - (nRows + 1)*tztCellMargin) / nRows;
    
    if (_ayViews == NULL)
        _ayViews = NewObject(NSMutableArray);
    int nCount = 0;
    CGRect rcLabel = rcFrame;
    rcLabel.size.width = nWidth;
    rcLabel.size.height = nHeight;
    rcLabel.origin.x = tztCellMargin;
    rcLabel.origin.y = tztCellMargin;
    UIFont *font = tztUIBaseViewTextFont(13);
    for (int i = 0; i < nRows; i++)
    {
        for (int j = 0; j < _nCols; j++)
        {
            rcLabel.origin.x = (j * nWidth) + (j + 1)*tztCellMargin;
            UILabel *pLabel = (UILabel*)[self viewWithTag:tztCellDataTag + nCount];
            
            if (pLabel == NULL)
            {
                pLabel = [[UILabel alloc] initWithFrame:rcLabel];
                pLabel.textAlignment = NSTextAlignmentCenter;
                pLabel.font = font;
                pLabel.adjustsFontSizeToFitWidth = YES;
                pLabel.textColor = [UIColor whiteColor];
                [_ayViews addObject:pLabel];
                [self addSubview:pLabel];
                [pLabel release];
            }
            else
                pLabel.frame = rcLabel;
            pLabel.hidden = NO;
            pLabel.text = [self.ayData objectAtIndex:nCount];
            nCount++;
            if (nCount >= self.ayData.count)
                break;
        }
        
        rcLabel.origin.y = (i+1)*(nHeight+tztCellMargin);
    }
    
    for (int i = nCount; i < [_ayViews count]; i++)
    {
        UIView *pView = [_ayViews objectAtIndex:i];
        pView.hidden = YES;
    }
}

-(void)SetDataContent:(NSMutableArray *)ayData andCols_:(int)nCol
{
    [_ayData release];
    _ayData = [ayData retain];
    _nCols = nCol;
    if (_nCols < 1)
        _nCols = 1;
    
    [self setFrame:self.frame];
}

@end

@interface tztHKQueueCell : UITableViewCell

@property(nonatomic,retain)UILabel  *lbName;
@property(nonatomic,retain)UILabel  *lbPrice;
@property(nonatomic,retain)UILabel  *lbAmount;
@property(nonatomic,retain)UIView   *lineView;
@property(nonatomic,retain)tztHKDataCellView  *lbData;
@property(nonatomic,retain)NSDictionary *pDictData;
@property(nonatomic)int nCols;
@property(nonatomic,retain)NSMutableArray *ayViews;

-(void)setContentData:(NSMutableDictionary*)pDict;
@end

@implementation tztHKQueueCell
@synthesize lbName = _lbName;
@synthesize lbPrice = _lbPrice;
@synthesize lbAmount = _lbAmount;
@synthesize lbData = _lbData;
@synthesize pDictData = _pDictData;
@synthesize lineView = _lineView;

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        
    }
    return self;
}

-(void)layoutSubviews
{
    CGRect rcFrame = self.bounds;
    int nWidth = rcFrame.size.width / 6;
    CGRect rcName = rcFrame;
    rcName.size.width = nWidth;

    NSString* strName = @"";
    NSString* strPrice = @"";
    NSString* strAmount = @"";
    NSArray * ayData = nil;
    
    if (self.pDictData)
    {
        strName = [self.pDictData objectForKey:tztHKCellName];
        strPrice = [self.pDictData objectForKey:tztHKCellPrice];
        strAmount = [self.pDictData objectForKey:tztHKCellTotal];
        ayData = [self.pDictData objectForKey:tztHKCellData];
    }
    
    NSInteger nRows = (ayData.count / 3) + ((ayData.count % 3 == 0) ? 0 : 1);
    if (nRows < 1)
        nRows = 1;
    
    UIFont *font = tztUIBaseViewTextFont(15.f);
    
    if (_lbName == NULL)
    {
        _lbName = [[UILabel alloc] initWithFrame:rcName];
        _lbName.backgroundColor = [UIColor clearColor];
        _lbName.textColor = [UIColor yellowColor];
        _lbName.adjustsFontSizeToFitWidth = YES;
        _lbName.textAlignment = NSTextAlignmentCenter;
        _lbName.font = font;
        [self addSubview:_lbName];
        [_lbName release];
    }
    else
        _lbName.frame = rcName;
    
    _lbName.text = strName;
    
    rcName.origin.x += rcName.size.width - 8;
    if (_lbPrice == NULL)
    {
        _lbPrice = [[UILabel alloc] initWithFrame:rcName];
        _lbPrice.backgroundColor = [UIColor clearColor];
        _lbPrice.adjustsFontSizeToFitWidth = YES;
        _lbPrice.textColor = [UIColor whiteColor];
        _lbPrice.textAlignment = NSTextAlignmentCenter;
        _lbPrice.font = font;
        [self addSubview:_lbPrice];
        [_lbPrice release];
    }
    else
        _lbPrice.frame = rcName;
    
    _lbPrice.text = strPrice;
    
    rcName.origin.x += rcName.size.width +8;
    if (_lbAmount == NULL)
    {
        _lbAmount = [[UILabel alloc] initWithFrame:rcName];
        _lbAmount.backgroundColor = [UIColor clearColor];
        _lbAmount.textAlignment = NSTextAlignmentCenter;
        _lbAmount.font = font;
        _lbAmount.adjustsFontSizeToFitWidth = YES;
        _lbAmount.textColor = [UIColor whiteColor];
        [self addSubview:_lbAmount];
        [_lbAmount release];
    }
    else
        _lbAmount.frame = rcName;
    
    _lbAmount.text = strAmount;
    
    CGRect rcData = rcName;
    rcData.size.width = rcName.size.width * 3;
    rcData.origin.x += rcName.size.width;
    
    int nLeft = rcData.origin.x;
    
    _nCols = 3;
    if (_nCols < 1)
        _nCols = 1;
    
    rcFrame = rcData;
    
    int nDataWidth = (rcData.size.width - (_nCols + 1) * tztCellMargin) / _nCols;
    int nDataHeight = (rcData.size.height - (nRows + 1)*tztCellMargin) / nRows;
    
    int nCount = 0;
    CGRect rcLabel = rcFrame;
    rcLabel.size.width = nDataWidth;
    rcLabel.size.height = nDataHeight;
    rcLabel.origin.x += tztCellMargin;
    rcLabel.origin.y = tztCellMargin;
    
    if (_ayViews == NULL)
        _ayViews = NewObject(NSMutableArray);
    
    UIFont *fontdata = tztUIBaseViewTextFont(13);
    for (int i = 0; i < nRows; i++)
    {
        for (int j = 0; j < _nCols; j++)
        {
            rcLabel.origin.x = nLeft + (j * nDataWidth) + (j + 1)*tztCellMargin;
            UILabel *pLabel = (UILabel*)[self viewWithTag:tztCellDataTag + nCount];
            
            if (pLabel == NULL)
            {
                pLabel = [[UILabel alloc] initWithFrame:rcLabel];
                pLabel.textAlignment = NSTextAlignmentCenter;
                pLabel.font = fontdata;
                pLabel.tag = tztCellDataTag + nCount;
                pLabel.backgroundColor = [UIColor clearColor];
                pLabel.adjustsFontSizeToFitWidth = YES;
                pLabel.textColor = [UIColor whiteColor];
                [_ayViews addObject:pLabel];
                [self addSubview:pLabel];
                [pLabel release];
            }
            else
                pLabel.frame = rcLabel;
            pLabel.hidden = NO;
            if (nCount < ayData.count)
                pLabel.text = [ayData objectAtIndex:nCount];
            else
                pLabel.text = @"";
            nCount++;
            if (nCount >= ayData.count)
                break;
        }
        
        rcLabel.origin.x = rcData.origin.x;
        rcLabel.origin.y = (i+1)*(nDataHeight+tztCellMargin);
    }
//    
    for (int i = nCount; i < [_ayViews count]; i++)
    {
        UIView *pView = [_ayViews objectAtIndex:i];
        pView.hidden = YES;
    }
    
    CGRect rcLine = self.bounds;
    rcLine.origin.x += 10;
    rcLine.origin.y = self.bounds.size.height - 1;
    rcLine.size.height = 1;
    rcLine.size.width -= 10;
    if (_lineView == NULL)
    {
        _lineView = [[UIView alloc] initWithFrame:rcLine];
        _lineView.backgroundColor = [UIColor colorWithTztRGBStr:@"42,42,42"];
        [self addSubview:_lineView];
        [_lineView release];
    }
    else
        _lineView.frame = rcLine;
}

-(void)setContentData:(NSMutableDictionary*)pDict
{
    self.pDictData = pDict;
//    [self layoutSubviews];
}

@end

@interface tztHKQueueViee()<UITableViewDataSource, UITableViewDelegate>

@property(nonatomic,retain)NSMutableArray  *pAyData;
@property(nonatomic,retain)UITableView  *pTableView;
@property(nonatomic)CGFloat fTotalHeight;
@property(nonatomic)BOOL bFirst;
//@property(nonatomic,retain)UIScrollView *scrollView;
//@property(nonatomic,retain)tztHKQueueVieeIn *tztHKQueueInView;

-(void)initsubframe;
@end

@implementation tztHKQueueViee
@synthesize pAyData = _pAyData;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
    }
    return self;
}

-(id)init
{
    if (self = [super init])
    {
        
    }
    return self;
}

-(void)dealloc
{
    [[tztMoblieStockComm getSharehqInstance] removeObj:self];
    [super dealloc];
}

-(void)setStockInfo:(tztStockInfo *)pStockInfo Request:(int)nRequest
{
    [self onClearData];
    _bFirst = TRUE;
    [super setStockInfo:pStockInfo Request:nRequest];
}

-(void)initdata
{
    [super initdata];
    self.clipsToBounds = YES;

    if (_pAyData == NULL)
    {
        _pAyData = NewObject(NSMutableArray);
        
        //卖出10档
        for (int i = 10; i > 0; i--)
        {
            NSMutableDictionary *pDict = NewObject(NSMutableDictionary);
            [pDict setObject:[NSString stringWithFormat:@"卖%d", i] forKey:tztHKCellName];
            [pDict setObject:@"-.-" forKey:tztHKCellPrice];
            [pDict setObject:@"--" forKey:tztHKCellTotal];
            [pDict setObject:@"--" forKey:tztHKCellDataString];
            [pDict setObject:[NSString stringWithFormat:@"-%d",i] forKey:tztHKCellKey];
            
            NSMutableArray *pAy = NewObject(NSMutableArray);
            [pDict setObject:pAy forKey:tztHKCellData];
            DelObject(pAy);
            
            [_pAyData addObject:pDict];
            DelObject(pDict);
        }
        
        //买入10档
        for (int i = 1; i < 11; i++)
        {
            NSMutableDictionary *pDict = NewObject(NSMutableDictionary);
            [pDict setObject:[NSString stringWithFormat:@"买%d", i] forKey:tztHKCellName];
            [pDict setObject:@"-.-" forKey:tztHKCellPrice];
            [pDict setObject:@"--" forKey:tztHKCellTotal];
            [pDict setObject:@"--" forKey:tztHKCellDataString];
            [pDict setObject:[NSString stringWithFormat:@"%d",i] forKey:tztHKCellKey];
            
            NSMutableArray *pAy = NewObject(NSMutableArray);
            [pDict setObject:pAy forKey:tztHKCellData];
            DelObject(pAy);
            [_pAyData addObject:pDict];
            DelObject(pDict);
        }
    }
    
    [[tztMoblieStockComm getSharehqInstance] addObj:self];
    
    [self initsubframe];
}

-(void)onClearData
{
    for (int i = 0; i < [_pAyData count]; i++)
    {
        NSMutableDictionary *pDict = [_pAyData objectAtIndex:i];
        if (pDict == NULL)
            continue;
        
        [pDict setObject:@"-.-" forKey:tztHKCellPrice];
        [pDict setObject:@"--" forKey:tztHKCellTotal];
        [pDict setObject:@"--" forKey:tztHKCellDataString];
        
        NSMutableArray *ay = [pDict objectForKey:tztHKCellData];
        [ay removeAllObjects];
    }
    [super onClearData];
}

-(void)initsubframe
{
    self.backgroundColor = [UIColor tztThemeBackgroundColorHQ];
    _fTotalHeight = 0;
    if (_pTableView == NULL)
    {
        _pTableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
        _pTableView.dataSource = self;
        _pTableView.delegate = self;
        _pTableView.sectionHeaderHeight = 35;
        [self addSubview:_pTableView];
        [_pTableView release];
        _pTableView.backgroundColor = [UIColor tztThemeBackgroundColorHQ];
        _pTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//        _pTableView.separatorColor = [UIColor darkGrayColor];
    }
    else
    {
        _pTableView.frame = self.bounds;
    }
}

-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [self initsubframe];
}

-(void)onRequestData:(BOOL)bShowProcess
{
    TZTNSLog(@"%@", @"请求港股经纪商队列");
    if (_bRequest)
    {
        if (self.pStockInfo == nil || self.pStockInfo.stockCode == nil || [self.pStockInfo.stockCode length] <= 0)
        {
            TZTNSLog(@"%@", @"港股经纪商请求----股票代码为空!!!!!");
            return;
        }
        
        NSMutableDictionary *sendvalue = NewObject(NSMutableDictionary);
        [sendvalue setTztObject:self.pStockInfo.stockCode forKey:@"StockCode"];
        [sendvalue setTztObject:@"2" forKey:@"level"];
        [sendvalue setTztObject:@"10" forKey:@"MaxCount"];
        _ntztHqReq++;
        if (_ntztHqReq >= UINT16_MAX)
            _ntztHqReq = 1;
        
        NSString* strReqno = tztKeyReqno((long)self, _ntztHqReq);
        [sendvalue setTztObject:strReqno forKey:@"Reqno"];
        [[tztMoblieStockComm getSharehqInstance] onSendDataAction:@"20183" withDictValue:sendvalue];
        DelObject(sendvalue);
    }
    [super onRequestData:bShowProcess];
}

-(NSUInteger)OnCommNotify:(NSUInteger)wParam lParam_:(NSUInteger)lParam
{
    if (wParam == 0)
        return 0;
    tztNewMSParse *pParse = (tztNewMSParse*)wParam;
    if (![pParse IsIphoneKey:(long)self reqno:_ntztHqReq])
        return 0;
    
    if ([pParse GetAction] == 20183)
    {
        //取股票代码判断是否一致
        NSString* strCode = [pParse GetByName:@"StockCode"];
        if (strCode && [strCode caseInsensitiveCompare:self.pStockInfo.stockCode] != NSOrderedSame)
            return 0;
        
        //清除原来数据
        [self onClearData];
        
        NSArray *ayGrid = [pParse GetArrayByName:@"Grid"];
//        NSString* strGrid = [pParse GetByName:@"Grid"];
        
        NSString* strBaseData = [pParse GetByName:@"Level2Bin"];
        NSData *DataLevel2Bin = [NSData tztdataFromBase64String:strBaseData];
        
        TNewPriceDataTen _pTen;
        memset(&_pTen, 0x00, sizeof(TNewPriceDataTen));
        memcpy(&_pTen, DataLevel2Bin, MIN(sizeof(TNewPriceDataTen), [DataLevel2Bin length]));
        
        NSString* strValue = [pParse GetByNameUnicode:@"Grid"];
        NSArray* ay = [strValue componentsSeparatedByString:@"\r\n"];
        for (int i = 0; i < [ay count]; i++)
        {
            NSString* strData = [ay objectAtIndex:i];
            if (strData.length <= 0)
                continue;
            NSArray *aySub = [strData componentsSeparatedByString:@":"];
            if (aySub.count < 1)
                continue;
            NSString* strNum = [aySub objectAtIndex:0];
            NSString* strName = [aySub objectAtIndex:1];
            if (strNum.length <= 0)
                continue;
            
            int a = [strNum intValue];
            //strName要进行处理，去掉开始的大括号，和最后的大括号
            if ([strName hasPrefix:@"{"] && strName.length > 0)
                strName = [strName substringFromIndex:1];
            if ([strName hasSuffix:@"}"] && strName.length > 0)
                strName = [strName substringToIndex:[strName length] - 1];
            NSArray *ayName = [strName componentsSeparatedByString:@"|"];
            NSMutableDictionary* pDict = [self GetIndexWithNum:a];
            if (pDict == NULL)
                continue;
            //设置价格，颜色
            [self SetPriceWithData:&_pTen andNum_:a forDict_:pDict];
            
            NSMutableArray* ayCellData = [pDict objectForKey:tztHKCellData];
            [ayCellData removeAllObjects];
            //设置经纪商队列数据
            for (int i = 0; i < [ayName count]; i++)
            {
                NSString * str = [ayName objectAtIndex:i];
                if (str.length <= 0)
                    continue;
                NSArray *aySubName = [str componentsSeparatedByString:@","];
                if (aySubName.count < 1)
                    continue;
                NSString* strXWH = [aySubName objectAtIndex:0];
                NSString* strJJS = @"";
                if (aySubName.count > 1)
                    strJJS = [aySubName objectAtIndex:1];
                
                if (strJJS.length < 1)
                    [ayCellData addObject:strXWH];
                else
                    [ayCellData addObject:strJJS];
            }
            NSInteger nCount = [ayCellData count];
            if(nCount < 1)
                [pDict setObject:@"-" forKey:tztHKCellTotal];
            else
                [pDict setObject:[NSString stringWithFormat:@"%ld", (long)nCount] forKey:tztHKCellTotal];
        }

        if (_bFirst)
        {
            _fTotalHeight = 0;
        }
        [self.pTableView reloadData];
        _bFirst = FALSE;
//        //服务器返回数据从卖10-卖1～买1-买10
//        for (int i = 0; i < ayGrid.count; i++)
//        {
//            NSString* strData = [ayGrid objectAtIndex:i];
//            NSLog(@"%@", strData);
//        }
//        NSString* strBase = [pParse GetByName:@"Grid"];
//        NSData* DataGrid = [NSData tztdataFromBase64String:strBase];
//        
//        TNewOrderQueue _pQueue;
//        memset(&_pQueue, 0x00, sizeof(TNewOrderQueue));
//        memcpy(&_pQueue, [DataGrid bytes], MIN([DataGrid length], sizeof(TNewOrderQueue)));
//        NSLog(@"%@", @"123");
    }
    return 1;
}

-(void)SetPriceWithData:(TNewPriceDataTen*)pPriceData andNum_:(int)nNum forDict_:(NSMutableDictionary*)pDict
{
    NSString* strPrice = @"-.-";
    UIColor *clText = [UIColor tztThemeHQBalanceColor];
    if (pPriceData == NULL)
    {
        [pDict setObject:strPrice forKey:tztHKCellPrice];
        [pDict setObject:clText forKey:tztHKCellPriceColor];
        return;
    }
    
    int nDecimal = 3;
    int nDiv = 1000;
    
    switch (nNum)
    {
        case -10://卖十
        {
            strPrice = NSStringOfVal_Ref_Dec_Div(pPriceData->SellPrice10 ,0, nDecimal,nDiv);
        }
            break;
        case -9:
        {
            strPrice = NSStringOfVal_Ref_Dec_Div(pPriceData->SellPrice9 ,0, nDecimal,nDiv);
        }
            break;
        case -8:
        {
            strPrice = NSStringOfVal_Ref_Dec_Div(pPriceData->SellPrice8 ,0, nDecimal,nDiv);
        }
            break;
        case -7:
        {
            strPrice = NSStringOfVal_Ref_Dec_Div(pPriceData->SellPrice7 ,0, nDecimal,nDiv);
        }
            break;
        case -6:
        {
            strPrice = NSStringOfVal_Ref_Dec_Div(pPriceData->SellPrice6 ,0, nDecimal,nDiv);
        }
            break;
        case -5:
        {
            strPrice = NSStringOfVal_Ref_Dec_Div(pPriceData->SellPrice5 ,0, nDecimal,nDiv);
        }
            break;
        case -4:
        {
            strPrice = NSStringOfVal_Ref_Dec_Div(pPriceData->SellPrice4 ,0, nDecimal,nDiv);
        }
            break;
        case -3:
        {
            strPrice = NSStringOfVal_Ref_Dec_Div(pPriceData->SellPrice3 ,0, nDecimal,nDiv);
        }
            break;
        case -2:
        {
            strPrice = NSStringOfVal_Ref_Dec_Div(pPriceData->SellPrice2 ,0, nDecimal,nDiv);
        }
            break;
        case -1:
        {
            strPrice = NSStringOfVal_Ref_Dec_Div(pPriceData->SellPrice1 ,0, nDecimal,nDiv);
        }
            break;
        case 1:
        {
            strPrice = NSStringOfVal_Ref_Dec_Div(pPriceData->BuyPrice1 ,0, nDecimal,nDiv);
        }
            break;
        case 2:
        {
            strPrice = NSStringOfVal_Ref_Dec_Div(pPriceData->BuyPrice2 ,0, nDecimal,nDiv);
        }
            break;
        case 3:
        {
            strPrice = NSStringOfVal_Ref_Dec_Div(pPriceData->BuyPrice3 ,0, nDecimal,nDiv);
        }
            break;
        case 4:
        {
            strPrice = NSStringOfVal_Ref_Dec_Div(pPriceData->BuyPrice4 ,0, nDecimal,nDiv);
        }
            break;
        case 5:
        {
            strPrice = NSStringOfVal_Ref_Dec_Div(pPriceData->BuyPrice5 ,0, nDecimal,nDiv);
        }
            break;
        case 6:
        {
            strPrice = NSStringOfVal_Ref_Dec_Div(pPriceData->BuyPrice6 ,0, nDecimal,nDiv);
        }
            break;
        case 7:
        {
            strPrice = NSStringOfVal_Ref_Dec_Div(pPriceData->BuyPrice7 ,0, nDecimal,nDiv);
        }
            break;
        case 8:
        {
            strPrice = NSStringOfVal_Ref_Dec_Div(pPriceData->BuyPrice8 ,0, nDecimal,nDiv);
        }
            break;
        case 9:
        {
            strPrice = NSStringOfVal_Ref_Dec_Div(pPriceData->BuyPrice9 ,0, nDecimal,nDiv);
        }
            break;
        case 10:
        {
            strPrice = NSStringOfVal_Ref_Dec_Div(pPriceData->BuyPrice10 ,0, nDecimal,nDiv);
        }
            break;
            break;
            
        default:
            break;
    }
    
    [pDict setObject:strPrice forKey:tztHKCellPrice];
    [pDict setObject:clText forKey:tztHKCellPriceColor];
}

-(NSMutableDictionary*)GetIndexWithNum:(int)nNum
{
    if (_pAyData.count < 1)
        return NULL;
    for (int i = 0; i < [_pAyData count]; i++)
    {
        NSMutableDictionary* pDict = [_pAyData objectAtIndex:i];
        int nKey = [[pDict objectForKey:tztHKCellKey] intValue];
        if (nNum == nKey)
            return pDict;
    }
    return NULL;
}

#pragma table处理
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_pAyData count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //动态计算高度，最少是一行高度44
    NSInteger nCount = ((NSMutableArray*)[((NSMutableDictionary*)[_pAyData objectAtIndex:indexPath.row]) objectForKey:tztHKCellData]).count;
    
    NSInteger nRow = (nCount/3) + ((nCount%3==0) ? 0 : 1);
    
    if (nRow < 1)
        nRow = 1;
    
    CGFloat f = 38 * nRow;
    
    if (_bFirst)
    {
        if (indexPath.row < 9)
        {
            _fTotalHeight += f;
        }
        
        if (indexPath.row > 9)
        {
            tableView.contentOffset = CGPointMake(0, _fTotalHeight);
        }
    }
    return f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 35;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *sectionView = [[[UIView alloc] initWithFrame:CGRectMake(0,0, self.bounds.size.width, tableView.sectionHeaderHeight )] autorelease];
    float width = tableView.frame.size.width/6;
    
    UIButton *btnStockName = [UIButton buttonWithType:UIButtonTypeCustom];;
    btnStockName.titleLabel.font = [UIFont systemFontOfSize:14];
    [btnStockName setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
    btnStockName.frame = CGRectMake(0, 0, width, tableView.sectionHeaderHeight);
    btnStockName.tag = 0x1234+7;
    [btnStockName setTztTitleColor:[UIColor grayColor]];
    [btnStockName setTztTitle:@"档位"];
    [sectionView addSubview: btnStockName];
    
    UIButton *btnStockPrice = [UIButton buttonWithType:UIButtonTypeCustom];
    btnStockPrice.tag = 0x1234+8;
    btnStockPrice.titleLabel.font = [UIFont systemFontOfSize:14];
    [btnStockPrice setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
    btnStockPrice.frame = CGRectMake(width , 0, width, tableView.sectionHeaderHeight);
    [btnStockPrice setTztTitle:@"价格"];
    [sectionView addSubview: btnStockPrice];
    
    UIButton *btnStockWave = [UIButton buttonWithType:UIButtonTypeCustom];
    btnStockWave.titleLabel.font = [UIFont systemFontOfSize:14];
    [btnStockWave setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
    btnStockWave.frame = CGRectMake(width * 2 , 0, width, tableView.sectionHeaderHeight);
    [btnStockWave setTztTitle:@"总量"];
    [sectionView addSubview: btnStockWave];
    
    
    UIButton *btnStockUpDown = [UIButton buttonWithType:UIButtonTypeCustom];
    btnStockUpDown.titleLabel.font = [UIFont systemFontOfSize:14];
    [btnStockUpDown setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
    btnStockUpDown.frame = CGRectMake(3*width , 0, tableView.frame.size.width - 3* width, tableView.sectionHeaderHeight);
    [btnStockUpDown setTitle:@"经纪商" forState:UIControlStateNormal];
    [sectionView addSubview: btnStockUpDown];
    sectionView.backgroundColor = [UIColor tztThemeBackgroundColorSection];
    if (g_nSkinType == 0)
    {
        [btnStockName setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [btnStockPrice setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [btnStockWave setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [btnStockUpDown setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    }
    else if (g_nSkinType == 1)
    {
        //        sectionView.backgroundColor = GrayWhite;
        [btnStockName setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btnStockPrice setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btnStockWave setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btnStockUpDown setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    return sectionView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identify = [NSString stringWithFormat:@"cellId%ld%ld", (long)indexPath.section, (long)indexPath.row];
    tztHKQueueCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (cell == NULL)
    {
        cell = [[tztHKQueueCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    if (indexPath.row % 2 == 0)
//    {
//        cell.backgroundColor = [UIColor blueColor];
//    }
//    else
        cell.backgroundColor = [UIColor tztThemeBackgroundColorHQ];
    NSMutableDictionary *pDict = NULL;
    if (indexPath.row < self.pAyData.count)
    {
        pDict = [self.pAyData objectAtIndex:indexPath.row];
    }
    [cell setContentData:pDict];
    return cell;
}






@end
