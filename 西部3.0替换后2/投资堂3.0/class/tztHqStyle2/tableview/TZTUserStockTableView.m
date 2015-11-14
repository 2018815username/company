/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:
 * 文件标识:
 * 摘要说明:    自选股表
 *
 * 当前版本:
 * 作    者:       DBQ
 * 更新日期:
 * 整理修改:
 *
 ***************************************************************/

#import "TZTUserStockTableView.h"
#import "TZTUserStockTableViewCell.h"
#import "tztTrendView_scroll.h"
//#import "TZTShareContentDelegate.h"
#define HegightForHeader    30.0f

#define GrayWhite [UIColor colorWithRed:237.0/255 green:237.0/255 blue:237.0/255 alpha:1.0]

@interface tztEmptyUserStock : UIView

@property(nonatomic,retain)UILabel      *pLblInfo;
@property(nonatomic,retain)UIButton     *pBtnAdd;
@end

@implementation tztEmptyUserStock
@synthesize pLblInfo = _pLblInfo;
@synthesize pBtnAdd = _pBtnAdd;

-(id)init
{
    if (self = [super init])
    {
        
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
    }
    return self;
}

-(void)setFrame:(CGRect)frame
{
    if (CGRectIsEmpty(frame) || CGRectIsNull(frame))
        return;
    
    [super setFrame:frame];
    
    CGRect rcFrame = self.bounds;
    rcFrame.origin.y += 10;
    rcFrame.size.height = 50;
    if (_pLblInfo == NULL)
    {
        _pLblInfo = [[UILabel alloc] initWithFrame:rcFrame];
        [self addSubview:_pLblInfo];
        _pLblInfo.textColor = [UIColor colorWithRGBULong:0x5c5c5c];
        _pLblInfo.font = [UIFont boldSystemFontOfSize:22];
        _pLblInfo.textAlignment = NSTextAlignmentCenter;
        _pLblInfo.backgroundColor = [UIColor clearColor];
//        _pLblInfo.text = @"亲，还没添加自选股哦";
    }
    else
        _pLblInfo.frame = rcFrame;
    
    rcFrame.origin.y += rcFrame.size.height + 15;
    UIImage *image = [UIImage imageTztNamed:@"tztEmptyViewAdd.png"];
    CGSize sz = image.size;
    if (sz.width <= 0 || sz.height <= 0)
        sz = CGSizeMake(200, 50);
    rcFrame.size = sz;
    
    rcFrame.origin.x += (self.bounds.size.width - rcFrame.size.width)/2;
    if (_pBtnAdd == NULL)
    {
        _pBtnAdd = [UIButton buttonWithType:UIButtonTypeCustom];
        _pBtnAdd.frame = rcFrame;
        if (image)
            [_pBtnAdd setTztImage:image];
        else
        {
            _pBtnAdd.titleLabel.font = [UIFont boldSystemFontOfSize:18];
            _pBtnAdd.titleLabel.textAlignment = NSTextAlignmentCenter;
            [_pBtnAdd setTztTitle:@"点击添加自选股"];
        }
        [_pBtnAdd addTarget:self action:@selector(OnBtnAdd) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_pBtnAdd];
    }
    else
        _pBtnAdd.frame = rcFrame;
}

-(void)OnBtnAdd
{
    [TZTUIBaseVCMsg OnMsg:MENU_HQ_SearchStock wParam:0 lParam:0];
}
@end

@interface TZTUserStockTableView()<UITableViewDataSource, UITableViewDelegate, SWTableViewCellDelegate,tztHqBaseViewDelegate>
{
   
}

@property(nonatomic, retain)tztTrendView_scroll *pTrendViewScroll;
@property(nonatomic, retain)NSMutableArray *dataArray;
@property (nonatomic,retain) NSMutableArray         *ayStockType;
@property (nonatomic,retain) UIButton               *pView;
@property SWCellState nCellState;
@property (nonatomic,retain) tztEmptyUserStock      *pEmptyView;


@property (nonatomic,retain) UIView                 *pTitleView;
@property (nonatomic,retain) UIButton               *pBtnName;
@property (nonatomic,retain) UIButton               *pBtnPrice;
@property (nonatomic,retain) UIButton               *pBtnWave;
@property (nonatomic,retain) UIButton               *pBtnRatio;

@property(nonatomic,retain)NSString                 *nsAccountIndex;
@property(nonatomic,retain)NSString                 *nsOrderIndex;

@property(nonatomic,retain)UIView                   *pSepLine;
@end

@implementation TZTUserStockTableView

@synthesize dataArray = _dataArray;
@synthesize pTableView = _pTableView;
@synthesize ayStockType = _ayStockType;
@synthesize priceType, rankType, centerCount, nonCenCount, priceCount, rankCount;
@synthesize pView = _pView;
@synthesize pTrendViewScroll = _pTrendViewScroll;
@synthesize pEmptyView = _pEmptyView;

@synthesize pTitleView = _pTitleView;
@synthesize pBtnName = _pBtnName;
@synthesize pBtnPrice = _pBtnPrice;
@synthesize pBtnWave = _pBtnWave;
@synthesize pBtnRatio = _pBtnRatio;

@synthesize nsAccountIndex = _nsAccountIndex;
@synthesize nsOrderIndex = _nsOrderIndex;

-(id)init
{
    if (self = [super init])
    {
        [self initdata];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self initdata];
    }
    return self;
}

-(void)initdata
{
    // Initialization code
    centerCount = 0;
    nonCenCount = 0;
    _nTickCount = 0;
    priceCount = 99;
    rankCount = 99;
    self.nsAccountIndex = @"9";
    self.nsOrderIndex = @"1";
    rankType = RankNature;
    priceType = PriceNature;
    self.backgroundColor = [UIColor clearColor];
    _dataArray = [[NSMutableArray alloc] init];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:tztUserStockNotificationName object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(OnUserStockChanged:) name:tztUserStockNotificationName object:nil];
    
    [[tztMoblieStockComm getSharehqInstance] addObj:self];
}

-(void)dealloc
{
    [[tztMoblieStockComm getSharehqInstance] removeObj:self];
    [super dealloc];
}

-(void)onSetViewRequest:(BOOL)bRequest
{
    if (self.pTrendViewScroll)
    {
        [self.pTrendViewScroll onSetViewRequest:bRequest];
    }
    [[tztMoblieStockComm getSharehqInstance] removeObj:self];
    [super onSetViewRequest:bRequest];
    
    if (g_bUseHQAutoPush)
    {//代码变更，需要重新发起推送
        if (bRequest)//需要发起请求
        {
            [[tztAutoPushObj getShareInstance] setAutoPushDataWithString:[NSString stringWithFormat:@"%@", [tztUserStock GetNSUserStock]] andDelegate_:(tztHqBaseView*)self];
        }
        else//取消主推
        {
            [[tztAutoPushObj getShareInstance] cancelAutoPush:nil];
        }
    }
}

-(void)onRequestDataAutoPush
{
    if (!_bRequest)
        return;
    [self onRequestData:YES];
}

-(void)setFrame:(CGRect)frame
{ 
    [super setFrame:frame];
    
    CGRect rcTitle = self.bounds;
    if (_nShowInQuote)
    {
        rcTitle.size.height = 0;
    }
    else
    {
        rcTitle.size.height = HegightForHeader;
        if (_pTitleView == NULL)
        {
            _pTitleView = [[UIView alloc] initWithFrame:rcTitle];
            [self addSubview:_pTitleView];
            [_pTitleView release];
        }
        else
        {
            _pTitleView.frame = rcTitle;
        }
        
        CGRect rcLine = rcTitle;
        rcLine.origin.y += rcTitle.size.height - 0.5;
        rcLine.size.height = 0.5f;
        if (_pSepLine == NULL)
        {
            _pSepLine = [[UIView alloc] initWithFrame:rcTitle];
            [self addSubview:_pSepLine];
            [_pSepLine release];
        }
        else
            _pSepLine.frame = rcLine;
        self.pSepLine.backgroundColor = [UIColor tztThemeBorderColorGrid];
        self.pTitleView.backgroundColor = [UIColor tztThemeBackgroundColorTagView];
        [self setTitleShow];
    }
    
//    CGRect rcTrend = rcFrame;
//    
//    //
//    BOOL bHidden = [[NSUserDefaults standardUserDefaults] boolForKey:@"trendscrollHidden"];
//    if (bHidden)
//        rcTrend.origin.y -= 112;
//    rcTrend.size.height = 170;
//    if (_pTrendViewScroll == NULL)
//    {
//        _pTrendViewScroll = [[tztTrendView_scroll alloc] initWithFrame:rcTrend];
//        _pTrendViewScroll.nShowTop = 1;
//        _pTrendViewScroll.hasHiddenBtn = TRUE;
//        _pTrendViewScroll.tztDelegate = self;
//        [self addSubview:_pTrendViewScroll];
//        [_pTrendViewScroll RequestReportData];
//        [_pTrendViewScroll release];
//    }
//    else
//    {
//        _pTrendViewScroll.frame = rcTrend;
//    }
//    
//    rcFrame.origin.y += (rcTrend.origin.y + rcTrend.size.height);
//    rcFrame.size.height -= (rcTrend.origin.y + rcTrend.size.height);
    
    CGRect rcFrame = self.bounds;
    rcFrame.origin.y += rcTitle.size.height;
    rcFrame.size.height -= rcTitle.size.height;
    
    if (_pTableView == NULL)
    {
        _pTableView = [[UITableView alloc] initWithFrame:rcFrame style:UITableViewStylePlain];
        _pTableView.delegate = self;
        _pTableView.directionalLockEnabled = YES;
        _pTableView.dataSource = self;
        _pTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        [self addSubview:_pTableView];
        [_pTableView release];
    }
    else
    {
        _pTableView.frame = rcFrame;
    }
    
    NSMutableArray *ay = [tztUserStock GetUserStockArray];
    rcFrame = _pTableView.bounds;
    rcFrame.origin.y += 30;
    rcFrame.size.height -= 30;
    if (_pEmptyView == NULL)
    {
        _pEmptyView = [[tztEmptyUserStock alloc] initWithFrame:rcFrame];
        [_pTableView addSubview:_pEmptyView];
        [_pEmptyView release];
    }
    else
    {
        _pEmptyView.frame = rcFrame;
    }
    
    _pEmptyView.hidden = ([ay count] > 0 ? 1 : 0);
    
    _pTableView.backgroundColor = [UIColor tztThemeBackgroundColorHQ];
    _pEmptyView.backgroundColor = [UIColor colorWithTztRGBStr:@"48,48,48"];
}


-(void)setTitleShow
{
    CGRect rcTitle = self.pTitleView.frame;
    float width = rcTitle.size.width/3;
    if (_pBtnName == NULL)
    {
        self.pBtnName = [UIButton buttonWithType:UIButtonTypeCustom];
        self.pBtnName.titleLabel.font = tztUIBaseViewTextFont(14);
        [self.pBtnName setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
#ifndef tzt_ZSSC
        [self.pBtnName addTarget:self action:@selector(priceRank:) forControlEvents:UIControlEventTouchUpInside];
#endif
        [self.pTitleView addSubview:self.pBtnName];
    }
    self.pBtnName.frame = CGRectMake(10, 0, width-20, rcTitle.size.height);
    [self.pBtnName setTitle:[self makeChangeTitle:@" 名称代码" withType:0] forState:UIControlStateNormal];
    
    if (_pBtnPrice == NULL)
    {
        self.pBtnPrice = [UIButton buttonWithType:UIButtonTypeCustom];
        self.pBtnPrice.titleLabel.font = tztUIBaseViewTextFont(14);
        [self.pBtnPrice setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
        [self.pBtnPrice addTarget:self action:@selector(priceRank:) forControlEvents:UIControlEventTouchUpInside];
        [self.pTitleView addSubview:self.pBtnPrice];
        self.pBtnPrice.tag = 999;
    }
    [self.pBtnPrice setTitle:[self makeChangeTitle:@"当前价" withType:priceType] forState:UIControlStateNormal];
    self.pBtnPrice.frame = CGRectMake(width + 15 , 0, width-20, rcTitle.size.height);
    
    if (_pBtnWave == NULL)
    {
        self.pBtnWave = [UIButton buttonWithType:UIButtonTypeCustom];
        self.pBtnWave.titleLabel.font = tztUIBaseViewTextFont(14);
        [self.pBtnWave setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
        self.pBtnWave.tag = 99;
        [self.pBtnWave addTarget:self action:@selector(rank:) forControlEvents:UIControlEventTouchUpInside];
        [self.pTitleView addSubview:self.pBtnWave];
    }
    self.pBtnWave.frame = CGRectMake(width * 2 + 15, 0, width - 20, rcTitle.size.height);
    NSString *title = @"";
    switch (_nTickCount)
    {
        case 1:
            title = @"涨跌额"; // Ratio
            break;
        case 2:
            title = @"成交额"; // TotalValue
            break;
        default:
            title = @"涨跌幅"; // Range
            break;
    }
    [self.pBtnWave setTitle:[self makeChangeTitle:title withType:rankType] forState:UIControlStateNormal];
    [self.pBtnName setTitleColor:[UIColor tztThemeTextColorTag] forState:UIControlStateNormal];
    [self.pBtnPrice setTitleColor:[UIColor tztThemeTextColorTag] forState:UIControlStateNormal];
    [self.pBtnWave setTitleColor:[UIColor tztThemeTextColorTag] forState:UIControlStateNormal];
    
}

-(void)tztTrendScroll:(id)send showOrHiddenWithRect:(CGRect)rect
{
    if (send != _pTrendViewScroll)
        return;
    
    CGRect rcFrame = self.bounds;
    if (rect.origin.y < 0)//展开
    {
        rect.origin.y += 112;
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"trendscrollHidden"];
    }
    else//收缩
    {
        rect.origin.y -= 112;
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"trendscrollHidden"];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    rcFrame.origin.y += (rect.origin.y + rect.size.height);
    rcFrame.size.height -= (rect.origin.y + rect.size.height);
    
    [UIView beginAnimations:@"hideSelectionView" context:nil];
    [UIView setAnimationDuration:0.2f];
    [UIView setAnimationDelegate:self];
    
    _pTrendViewScroll.frame = rect;
    _pTableView.frame = rcFrame;
    CGRect rcEmpTy = _pTableView.bounds;
    rcEmpTy.origin.y += 30;
    rcEmpTy.size.height -= 30;
    _pEmptyView.frame = rcEmpTy;
    [UIView commitAnimations];
    
    [self.pTableView reloadData];
}

-(void)OnUserStockChanged:(NSNotification*)notification
{
    NSMutableArray *ay = [tztUserStock GetUserStockArray];
    _pEmptyView.hidden = ([ay count] > 0 ? 1 : 0);
    
    rankCount = 0;
    rankType = RankNature;
    
    self.nsAccountIndex = @"9";
    self.nsOrderIndex = @"0";
    //重新亲求数据
    [self setStockCode:[tztUserStock GetNSUserStock] Request:1];
}

-(void)onRequestData:(BOOL)bShowProcess
{
    if (_bRequest && !self.bNOFresh)
    {
        NSInteger nCount = [[tztUserStock GetUserStockArray] count];
        if (nCount < 1)
            return;
        
        NSMutableDictionary *sendvalue = NewObject(NSMutableDictionary);
        _ntztHqReq++;
        if (_ntztHqReq >= UINT16_MAX)
            _ntztHqReq = 1;
        NSString *strReqno = tztKeyReqno((long)self, _ntztHqReq);
        [sendvalue setTztObject:strReqno forKey:@"Reqno"];
        
        NSString *accountIndext;
        NSString *direction;
        
        if (priceType == PriceAscend)
        {
            accountIndext = @"8";
            direction = @"1";
        }
        else if (priceType == PriceDesend)
        {
            accountIndext = @"8";
            direction = @"0";
        }
        else if (rankType == RankAscend || rankType == RankDesend)
        {
            if (rankType == RankAscend) {
                direction = @"1";
            }
            else
            {
                direction = @"0";
            }
            switch (_nTickCount)
            {
                case 0:
                    accountIndext = @"0"; // Range
                    break;
                    
                case 1:
                    accountIndext = @"10"; // Ratio
                    break;
                    
                case 2:
                    accountIndext = @"4"; // TotalValue
                    break;
                    
                default:
                {
                    accountIndext = @"9"; // Ratio
                    direction = @"1";
                }
                    break;
            }
            
        }
        else {
            accountIndext = @"9";
            direction = @"1";
        }
        [sendvalue setTztObject:accountIndext forKey:@"AccountIndex"];
        [sendvalue setTztObject:direction forKey:@"Direction"];
        [sendvalue setTztObject:@"0" forKey:@"DeviceType"];
        [sendvalue setTztObject:@"1" forKey:@"Lead"];
        [sendvalue setTztObject:@"0" forKey:@"StartPos"];
        [sendvalue setTztObject:@"1" forKey:@"StockIndex"];
        [sendvalue setTztObject:@"0" forKey:@"NewMarketNo"];
        [sendvalue setTztObject:[NSString stringWithFormat:@"%ld",(long)nCount] forKey:@"MaxCount"];
        NSString *strCode = [tztUserStock GetNSUserStock];
        [sendvalue setTztObject:strCode forKey:@"Grid"];
        [[tztMoblieStockComm getSharehqInstance] onSendDataAction:@"60" withDictValue:sendvalue];
        DelObject(sendvalue);
    }
}

-(NSUInteger)OnCommNotify:(NSUInteger)wParam lParam_:(NSUInteger)lParam
{
    if (wParam == 0)
        return 0;
    tztNewMSParse *pParse = (tztNewMSParse*)wParam;
    if (pParse == NULL)
        return 0;
    if (![pParse IsIphoneKey:(long)self reqno:_ntztHqReq])
        return 0;
    
    [self.dataArray removeAllObjects];
    if ([pParse IsAction:@"60"])
    {
        NSArray *ayGridVol = [pParse GetArrayByName:@"Grid"];
        if ([ayGridVol count] <= 0)
        {
            [self.pTableView reloadData];
            [self setTitleShow];
            return 0;
        }
        
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
        int nNameIndex = 0;//名称索引
        int nPriceIndex = 1;//最新价索引
        int nRatioIndex = 3;//涨跌索引
        int nRangeIndex = 2;//幅度索引
        int nTotalValueIndex = 10;//总市值索引
        
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
        
        //股票属性
        NSString* strStockProp = [pParse GetByName:@"StockProp"];
        NSArray *ayStockProp = [strStockProp componentsSeparatedByString:@"|"];
        
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
            
            if (ayStockProp && [ayStockProp count] > (i-1))
            {
                [pStockDict setTztObject:[ayStockProp objectAtIndex:(i-1)] forKey:tztStockProp];
            }
            
            [self.dataArray addObject:pStockDict];
            [pStockDict release];
        }
        
        [self.pTableView reloadData];
        [self setTitleShow];
    }
    
    return 1;
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

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //此处需要进行判断计算；若有持仓数据，则显示持仓以及盈亏
    return 44.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (_nShowInQuote)
        return 30;
    else
        return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *sectionView = [[[UIView alloc] initWithFrame:CGRectMake(0,0, self.bounds.size.width, tableView.sectionHeaderHeight )] autorelease];
    sectionView.backgroundColor = [UIColor tztThemeBackgroundColorSection];
    
    float width = tableView.frame.size.width/3;
    
    UIButton *btnStockName = [UIButton buttonWithType:UIButtonTypeCustom];;
    btnStockName.titleLabel.font = [UIFont systemFontOfSize:14];
    [btnStockName setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    btnStockName.frame = CGRectMake(9, 0, width, 30);
    btnStockName.tag = 0x1234+7;
    
    [btnStockName setTztTitleColor:[UIColor grayColor]];
    [btnStockName setTitle:[self makeChangeTitle:@"名称" withType:([self.nsAccountIndex intValue] == 7 ? priceType : PriceNature)] forState:UIControlStateNormal];
    [btnStockName addTarget:self action:@selector(priceRank:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [sectionView addSubview: btnStockName];
    
    UIButton *btnStockPrice = [UIButton buttonWithType:UIButtonTypeCustom];
    btnStockPrice.tag = 0x1234+8;
    btnStockPrice.titleLabel.font = [UIFont systemFontOfSize:14];
    [btnStockPrice setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    btnStockPrice.frame = CGRectMake(width + 20 , 0, width-20, 30);
    [btnStockPrice setTitle:[self makeChangeTitle:@"当前价" withType:([self.nsAccountIndex intValue] == 8 ? priceType : PriceNature)] forState:UIControlStateNormal];
    [btnStockPrice addTarget:self action:@selector(priceRank:) forControlEvents:UIControlEventTouchUpInside];
    [sectionView addSubview: btnStockPrice];
    
   
    
    if (/* DISABLES CODE */ (0))
    {
        UIButton *btnStockUpDown = [UIButton buttonWithType:UIButtonTypeCustom];
        btnStockUpDown.titleLabel.font = [UIFont systemFontOfSize:14];
        [btnStockUpDown setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
        btnStockUpDown.frame = CGRectMake(2*width+5 , 0, width-20, 30);
        [btnStockUpDown setTitle:@"涨跌" forState:UIControlStateNormal];
    //    btnStockUpDown.tag = 999;
    //    [btnStockUpDown addTarget:self action:@selector(priceRank:) forControlEvents:UIControlEventTouchUpInside];
        
        [sectionView addSubview: btnStockUpDown];
    }
    
    
    UIButton *btnStockWave = [UIButton buttonWithType:UIButtonTypeCustom];
    btnStockWave.titleLabel.font = [UIFont systemFontOfSize:14];
    [btnStockWave setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    sectionView.backgroundColor = [UIColor tztThemeBackgroundColorSection];
    
    
    
    btnStockWave = [UIButton buttonWithType:UIButtonTypeCustom];
    btnStockWave.titleLabel.font = [UIFont systemFontOfSize:14];
    [btnStockWave setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    btnStockWave.frame = CGRectMake(2*width + 8 , 0, width-20, 30);
    NSString *title;
    switch (_nTickCount)
    {
        case 1:
            title = @"涨跌额"; // Ratio
            btnStockWave.tag = 0x1234-1;
            break;
        case 2:
            title = @"成交额"; // TotalValue
            btnStockWave.tag = 0x1234+4;
            break;
        default:
            title = @"涨幅"; // Range
            btnStockWave.tag = 0x1234+0;
            break;
    }
    
    [btnStockWave setTitle:[self makeChangeTitle:title withType:rankType] forState:UIControlStateNormal];
    [btnStockWave addTarget:self action:@selector(rank:) forControlEvents:UIControlEventTouchUpInside];
    [sectionView addSubview: btnStockWave];
    
    if (g_nThemeColor == 0)
    {
        [btnStockName setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [btnStockPrice setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [btnStockWave setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
//        [btnStockUpDown setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    }
    else if (g_nThemeColor == 1)
    {
        //sectionView.backgroundColor = GrayWhite;
        [btnStockName setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btnStockPrice setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btnStockWave setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        [btnStockUpDown setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    return sectionView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TZTUserStockTableViewCell *cell = (TZTUserStockTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
    if (cell && [cell CancelQuickSellShow])
    {
        return;
    }
    if (indexPath.row >= self.dataArray.count)
        return;
    NSDictionary *pDict = [self.dataArray objectAtIndex:indexPath.row];
    
    NSDictionary* dictName = [pDict tztObjectForKey:@"Name"];
    NSDictionary* dictCode = [pDict tztObjectForKey:@"Code"];
    
    if (dictCode == NULL || dictCode.count <= 0)
        return;
    
    tztStockInfo *pStock = NewObjectAutoD(tztStockInfo);
    pStock.stockName = [dictName tztObjectForKey:@"value"];
    pStock.stockCode = [dictCode tztObjectForKey:@"value"];
    
    if (_ayStockType && indexPath.row < [_ayStockType count])
    {
        NSString* strType = [_ayStockType objectAtIndex:indexPath.row];
        if (strType && [strType length] > 0)
        {
            pStock.stockType = [strType intValue];
        }
    }
    NSArray *arr = [self getSendStockArray:self.dataArray];
    [TZTUIBaseVCMsg OnMsg:MENU_HQ_Trend wParam:(NSUInteger)pStock lParam:(NSUInteger)arr];
    
    [cell CancelSelected];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int nCount = tableView.frame.size.height / 44 + 1;
    return [self.dataArray count] + 1;
    return MAX([self.dataArray count], nCount);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identify = [NSString stringWithFormat:@"cellId%ld%ld", (long)indexPath.section, (long)indexPath.row];
    
    TZTUserStockTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (cell == nil)
    {
        NSMutableArray *rightUtilityButtons = [[NSMutableArray alloc] init];
        
        [rightUtilityButtons addUtilityButtonWithColor:[UIColor clearColor]
                                                  icon:@"TZTCellBuy"];
        [rightUtilityButtons addUtilityButtonWithColor:[UIColor clearColor]
                                                  icon:@"TZTCellSell"];
        
        // 根据配置 是否显示预警
        if ([[g_pSystermConfig.pDict tztObjectForKey:tztSystermConfig_SupportWarning] intValue] > 0)
        {
            [rightUtilityButtons addUtilityButtonWithColor:[UIColor clearColor]
                                                      icon:@"TZTCellWarning"];
        }
        
        BOOL bUseSep = ([[g_pSystermConfig.pDict tztObjectForKey:tztSystermConfig_HQTableUseGrid] intValue] > 0);
        cell = [[[TZTUserStockTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:identify
                                  containingTableView:tableView // Used for row height and selection
                                   leftUtilityButtons:nil
                                  rightUtilityButtons:rightUtilityButtons
                                           ayColKeys_:(NSMutableArray*)@[@"Name",@"NewPrice|0",@"Range"]
                                             bUseSep_:bUseSep] autorelease];
        cell.nRowIndex = indexPath.row;
        cell.bUserStock = YES;
        [rightUtilityButtons release];
        cell.delegate = self;
    
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.tztDelegate = self;
        cell.backgroundColor = [UIColor clearColor];
    }
    
    NSString *nsKey = @"Ratio";
    //此处还要考虑到上面标题的变换，请自行处理
    switch (_nTickCount)
    {
        case 1:
            nsKey = @"Ratio";
            break;
        case 2:
            nsKey = @"TotalValue";
            break;
        default:
            nsKey = @"Range";
            break;
    }
    if (indexPath.row >= self.dataArray.count)
    {
        [cell setCellContent:NULL nsKey_:@""];
        return cell;
    }
    
    NSDictionary *pDict = [self.dataArray objectAtIndex:indexPath.row];
    cell.cellState = _nCellState;
    [cell setCellContent:pDict nsKey_:nsKey];
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

#pragma mark - SWTableViewDelegate

- (void)swippableTableViewCell:(TZTUserStockTableViewCell *)cell didTriggerLeftUtilityButtonWithIndex:(NSInteger)index
{
    NSIndexPath *cellIndexPath = [self.pTableView indexPathForCell:cell];
    if (cellIndexPath.row >= self.dataArray.count)
        return;
    NSDictionary *pDict = [self.dataArray objectAtIndex:cellIndexPath.row];
    
    tztStockInfo *pStock = NewObjectAutoD(tztStockInfo);
    pStock.stockName = [pDict tztObjectForKey:@"Name"];
    pStock.stockCode = [pDict tztObjectForKey:@"Code"];
    
    if (_ayStockType && cellIndexPath.row < [_ayStockType count])
    {
        NSString* strType = [_ayStockType objectAtIndex:cellIndexPath.row];
        if (strType && [strType length] > 0)
        {
            pStock.stockType = [strType intValue];
        }
    }
    
    switch (index) {
        case 0:
        {
            // Delete button was pressed
            [tztUserStock DelUserStock:pStock];
            [self.dataArray removeObjectAtIndex:cellIndexPath.row];
            [self.pTableView deleteRowsAtIndexPaths:@[cellIndexPath] withRowAnimation:UITableViewRowAnimationLeft];
        }
            break;
            
        case 1:
        {
        }
            break;
            
        case 2:
        {
            
        }
            break;
        
        default:
            break;
    }
    [cell hideUtilityButtonsAnimated:YES];
}

- (void)swippableTableViewCell:(TZTUserStockTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index
{
    NSIndexPath *cellIndexPath = [self.pTableView indexPathForCell:cell];
    if (cellIndexPath.row >= self.dataArray.count)
        return;
    NSDictionary *pDict = [self.dataArray objectAtIndex:cellIndexPath.row];
    
    tztStockInfo *pStock = NewObjectAutoD(tztStockInfo);
    pStock.stockName = [pDict tztObjectForKey:@"Name"];
    pStock.stockCode = [pDict tztObjectForKey:@"Code"];
    
    if (_ayStockType && cellIndexPath.row < [_ayStockType count])
    {
        NSString* strType = [_ayStockType objectAtIndex:cellIndexPath.row];
        if (strType && [strType length] > 0)
        {
            pStock.stockType = [strType intValue];
        }
    }
    switch (index) {
        case 0:
        {
            [TZTUIBaseVCMsg OnMsg:WT_BUY wParam:(NSUInteger)pStock lParam:0];
            break;
        }
        case 1:
        {
            [TZTUIBaseVCMsg OnMsg:WT_SALE wParam:(NSUInteger)pStock lParam:0];
            break;
        }
        case 2:
        {
            //提醒
            [TZTUIBaseVCMsg OnMsg:MENU_SYS_UserWarning wParam:(NSUInteger)pStock lParam:0];
            //分享
//            [TZTUIBaseVCMsg OnMsg:TZT_MENU_Share wParam:0 lParam:0];
            break;
        }
        default:
            break;
    }
    [cell hideUtilityButtonsAnimated:YES];
}

- (void)swippableTableViewCell:(TZTUserStockTableViewCell *)cell scrollingToState:(SWCellState)state
{
    _nCellState = state;
    if (state == kCellStateCenter) {
        centerCount ++;
    }
    else
    {
        nonCenCount ++;
    }
    if (centerCount == nonCenCount) {
        self.bNOFresh = NO;
    }
    else
    {
//        self.bNOFresh = YES;
    }
}

#pragma mark -

- (void)OnChange:(id)sender
{
    _nTickCount++;
    int nMax = 3;
#ifdef tzt_ZSSC
    nMax = 2;
#endif
    if (_nTickCount >= nMax)
        _nTickCount = 0;
    [self setTitleShow];
    [self.pTableView reloadData];
    return;
}

- (NSString *)makeChangeTitle:(NSString *)title withType:(int)type
{
    switch (type) {
        case RankNature:
        case PriceNature:
        {
            //⋮
            return [NSString stringWithFormat:@"%@", title];
        }
            break;
            
        case RankAscend:
        case PriceAscend:
        {
            return [NSString stringWithFormat:@"%@↓", title];
        }
            break;
            
        case RankDesend:
        case PriceDesend:
        {
            return [NSString stringWithFormat:@"%@↑", title];
        }
            break;
            
        default:
        {
            return [NSString stringWithFormat:@"%@", title];
        }
            break;
    }
}

- (void)rank:(id)sender
{
    rankCount ++;
    //    if (_nTickCount >= 2)
    //        return;
    switch (rankCount % 3) {
        case 0:
        {
            rankType = RankNature;
        }
            break;
        case 1:
        {
            rankType = RankAscend;
            priceType = PriceNature;
            priceCount = 99;
        }
            break;
        case 2:
        {
            rankType = RankDesend;
            priceType = PriceNature;
            priceCount = 99;
        }
            break;
            
        default:
            break;
    }
    [self onRequestData:NO];
}

- (void)priceRank:(id)sender
{
    priceCount ++;
    switch (priceCount % 3) {
        case 0:
        {
            priceType = PriceNature;
        }
            break;
        case 1:
        {
            priceType = PriceAscend;
            rankType = RankNature;
            rankCount = 99;
        }
            break;
        case 2:
        {
            priceType = PriceDesend;
            rankType = RankNature;
            rankCount = 99;
        }
            break;
            
        default:
            break;
    }
    [self onRequestData:NO];
}


-(void)HiddenQuickSell:(TZTUserStockTableViewCell *)cell
{
    NSArray *ay = [self.pTableView visibleCells];
    for (int i = 0; i < ay.count; i++)
    {
        [cell HiddenQuickSell:[ay objectAtIndex:i]];
    }
}
@end
