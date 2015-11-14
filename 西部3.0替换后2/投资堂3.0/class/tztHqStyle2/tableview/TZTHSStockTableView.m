/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:
 * 文件标识:
 * 摘要说明:    沪深表
 *
 * 当前版本:
 * 作    者:       DBQ
 * 更新日期:
 * 整理修改:     by yinjp 整理使用配置，提高代码重用
 *
 ***************************************************************/

#import "TZTHSStockTableView.h"
#import "TZTUserStockTableViewCell.h"
#import "TZTIndustryView.h"
#import "TZTHQHeaderView.h"
#import "tztTrendView_scroll.h"

#define kHeaderViewTag 100
#define HeaderHeight 158
#define HQBtnTag 1000

#define tztIndexReqNo   (1024)

#define GrayWhite [UIColor colorWithRed:237.0/255 green:237.0/255 blue:237.0/255 alpha:1.0]
#define BgWhite [UIColor colorWithRed:247.0/255 green:247.0/255 blue:247.0/255 alpha:1.0]



@interface tztHQTableDataObj : NSObject

@property(nonatomic)NSInteger   nSection;
@property(nonatomic)NSInteger   nSectionType;
@property(nonatomic)CGFloat     fSectionHeight;
@property(nonatomic)CGFloat     fRowHeight;
@property(nonatomic)NSInteger    nMembers;
@property(nonatomic)BOOL         bOpen;
@property(nonatomic,retain)NSString*    nsSectionName;
@property(nonatomic,retain)NSMutableDictionary *dictRequest;
@property(nonatomic,retain)NSMutableArray      *ayStockType;
@property(nonatomic,retain)NSString            *nsHQMenuID;
@property(nonatomic,retain)NSString            *nsMarketID;
@property(nonatomic,retain)NSString            *nsOrderKey;
@property(nonatomic,retain)NSMutableArray      *ayContent;
@property(nonatomic,retain)NSMutableArray      *ayShowColKeys;
@property(nonatomic,assign)BOOL                bIndexUseBackColor;
@property(nonatomic,assign)BOOL                bIndexUseArrow;
@end

@implementation tztHQTableDataObj
@synthesize nSection = _nSection;
@synthesize nsSectionName = _nsSectionName;
@synthesize fSectionHeight = _fSectionHeight;
@synthesize fRowHeight = _fRowHeight;
@synthesize bOpen = _bOpen;
@synthesize nMembers = _nMembers;
@synthesize dictRequest = _dictRequest;
@synthesize ayStockType = _ayStockType;
@synthesize nsHQMenuID = _nsHQMenuID;
@synthesize nsMarketID = _nsMarketID;
@synthesize nSectionType = _nSectionType;
@synthesize nsOrderKey = _nsOrderKey;
@synthesize ayContent = _ayContent;
@synthesize ayShowColKeys = _ayShowColKeys;
@synthesize bIndexUseArrow = _bIndexUseArrow;
@synthesize bIndexUseBackColor = _bIndexUseBackColor;

-(id)init
{
    if (self = [super init])
    {
        _nSection = 0;
        _nSectionType = 0;//0-默认表格 1-分时行情 2-指数报价 3-板块报价
        _nMembers = 0;
        _bOpen = TRUE;
        _bIndexUseArrow = YES;
        _bIndexUseBackColor = NO;
        _fSectionHeight = 35.f;
        _fRowHeight = 44.f;
        self.nsSectionName = @"";
        self.nsHQMenuID = @"";
        self.nsMarketID = @"";
        self.nsOrderKey = @"";
        self.dictRequest = nil;
        _ayStockType = NewObject(NSMutableArray);
        _ayContent = NewObject(NSMutableArray);
        _ayShowColKeys = NewObject(NSMutableArray);
    }
    return self;
}

-(void)setAyStockType:(NSMutableArray *)ayType
{
    if (_ayStockType == nil)
        _ayStockType = NewObject(NSMutableArray);
    [_ayStockType removeAllObjects];
    
    for (id data in ayType)
    {
        [_ayStockType addObject:data];
    }
}

-(void)setAyShowColKeys:(NSMutableArray *)ayKeys
{
    if (_ayShowColKeys == nil)
        _ayShowColKeys = NewObject(NSMutableArray);
    [_ayShowColKeys removeAllObjects];
    for (id data in ayKeys)
    {
        [_ayShowColKeys addObject:data];
    }
}

-(void)setDictRequest:(NSMutableDictionary *)request
{
    if (_dictRequest == nil)
        _dictRequest = NewObject(NSMutableDictionary);
    [_dictRequest removeAllObjects];
    
    for (NSString* strKey in request.allKeys)
    {
        [_dictRequest setTztObject:[request tztObjectForKey:strKey] forKey:strKey];
    }
    
}

-(void)setNsSectionName:(NSString *)nsName
{
    [_nsSectionName release];
    _nsSectionName = [nsName retain];
}

-(void)dealloc
{
    [_ayStockType removeAllObjects];
    DelObject(_ayStockType);
    [_dictRequest removeAllObjects];
    DelObject(_dictRequest);
    [_ayContent removeAllObjects];
    DelObject(_ayContent);
    [_ayShowColKeys removeAllObjects];
    DelObject(_ayShowColKeys);
    [super dealloc];
}

@end

@interface tztHqTableConfig : NSObject
//从文件读取数据
@property(nonatomic,retain)NSMutableArray   *ayData;
@property(nonatomic,retain)NSString         *nsConfig;

-(id)initWithConfig:(NSString*)nsFileName;
-(tztHQTableDataObj*)dictionaryAtIndex:(NSInteger)nIndex;
-(NSInteger)GetSectionAtIndex:(NSInteger)nIndex;
-(NSString*)GetSectionNameAtIndex:(NSInteger)nIndex;
-(NSMutableDictionary*)GetRequestDataDictAtIndex:(NSInteger)nIndex;
-(NSMutableArray*)GetStockTypeArrayAtIndex:(NSInteger)nIndex;
-(void)SetStockTypeArray:(NSMutableArray*)ayType AtIndex:(NSInteger)nIndex;

@end

@implementation tztHqTableConfig

-(id)initWithConfig:(NSString *)nsFileName
{
    if ([self init])
    {
        self.nsConfig = [NSString stringWithFormat:@"%@", nsFileName];
        [self initData];
    }
    return self;
}

-(void)initData
{
    if (self.ayData == NULL)
        self.ayData = NewObject(NSMutableArray);
    [self.ayData removeAllObjects];
    //读取配置文件
    NSMutableArray* ay = GetArrayByListName(self.nsConfig);
    for (NSDictionary * dict in ay)
    {
        NSInteger nSection = [[dict tztObjectForKey:@"Section"] intValue];
        NSInteger nMembers = [[dict tztObjectForKey:@"MemberCount"] intValue];
        NSString* strSectionHeight = [dict tztObjectForKey:@"SectionHeight"];
        CGFloat fSectionHeight = 35.f;
        if (strSectionHeight.length > 0)
        {
           fSectionHeight =  [strSectionHeight floatValue];
        }
        
        NSString* strRowHeight = [dict tztObjectForKey:@"RowHeight"];
        CGFloat fRowHeight = 44.f;
        if (strRowHeight.length > 0)
        {
            fRowHeight = [strRowHeight floatValue];
        }
        NSInteger nSectionType = [[dict tztObjectForKey:@"SectionType"] intValue];
        
        NSString *nsSectionName = [dict tztObjectForKey:@"SectionName"];
        NSString *nsHQMenuID = [dict tztObjectForKey:@"HQMenuID"];
        NSString *nsMarketID = [dict tztObjectForKey:@"MarketID"];
        NSString *nsOrderKey = [dict tztObjectForKey:@"OrderKey"];
        
        NSString *nsUseBackColor = [dict tztObjectForKey:@"IndexUseBackColor"];
        NSString *nsUseArrow = [dict tztObjectForKey:@"IndexUseArrow"];
        
        
        BOOL bOpen = [[dict tztObjectForKey:@"Open"] boolValue];
        
        NSArray *ayKeys = [dict tztObjectForKey:@"ShowColKeys"];
        
        NSMutableDictionary *request = [dict tztObjectForKey:@"RequestData"];
        
        tztHQTableDataObj *obj = NewObject(tztHQTableDataObj);
        obj.nSection = nSection;
        obj.nMembers = nMembers;
        obj.nSectionType = nSectionType;
        obj.fSectionHeight = fSectionHeight;
        obj.fRowHeight = fRowHeight;
        if (nsSectionName)
            obj.nsSectionName = [NSString stringWithFormat:@"%@", nsSectionName];
        if (nsHQMenuID)
            obj.nsHQMenuID = [NSString stringWithFormat:@"%@", nsHQMenuID];
        if (nsMarketID)
            obj.nsMarketID = [NSString stringWithFormat:@"%@", nsMarketID];
        if (nsOrderKey)
            obj.nsOrderKey = [NSString stringWithFormat:@"%@", nsOrderKey];
        if (ISNSStringValid(nsUseBackColor))
            obj.bIndexUseBackColor = ([nsUseBackColor intValue] > 0);
        if (ISNSStringValid(nsUseArrow))
            obj.bIndexUseArrow = ([nsUseArrow intValue] > 0);
        if (ayKeys.count < 1)//默认名称，代码，最新价，涨跌值，涨跌幅
        {
            ayKeys = @[@"Name",@"NewPrice",@"Range"];
        }
        obj.ayShowColKeys = (NSMutableArray*)ayKeys;
        obj.bOpen = bOpen;
        obj.dictRequest = request;
        [self.ayData addObject:obj];
        [obj release];
    }
}

-(tztHQTableDataObj*)dictionaryAtIndex:(NSInteger)nIndex
{
    if (nIndex < 0 || nIndex >= self.ayData.count)
        return Nil;
    
    tztHQTableDataObj* dict = [self.ayData objectAtIndex:nIndex];
    return dict;
}

-(NSInteger)GetSectionAtIndex:(NSInteger)nIndex
{
    tztHQTableDataObj *obj = [self dictionaryAtIndex:nIndex];
    if (obj == nil)
        return -1;
    
    return obj.nSection;
}

-(NSString*)GetSectionNameAtIndex:(NSInteger)nIndex
{
    tztHQTableDataObj *obj = [self dictionaryAtIndex:nIndex];
    if (obj == nil)
        return nil;
    
    return obj.nsSectionName;
}

-(NSMutableDictionary*)GetRequestDataDictAtIndex:(NSInteger)nIndex
{
    tztHQTableDataObj *obj = [self dictionaryAtIndex:nIndex];
    if (obj == nil)
        return nil;
    return obj.dictRequest;
}

-(NSMutableArray*)GetStockTypeArrayAtIndex:(NSInteger)nIndex
{
    tztHQTableDataObj *obj = [self dictionaryAtIndex:nIndex];
    if (obj == nil)
        return nil;
    
    return obj.ayStockType;
}

-(void)SetStockTypeArray:(NSMutableArray*)ayType AtIndex:(NSInteger)nIndex;
{
    tztHQTableDataObj *obj = [self dictionaryAtIndex:nIndex];
    if (obj == nil)
        return;
    
    [obj setAyStockType:ayType];
}

@end


@interface TZTHSStockTableView()  <UITableViewDataSource, UITableViewDelegate, HeadDelegate, SWTableViewCellDelegate,UIGestureRecognizerDelegate>
{
    int centerCount;
    int nonCenCount;
}

@property(nonatomic,retain)UISwipeGestureRecognizer *swipeLeft;
@property(nonatomic,retain)UISwipeGestureRecognizer *swipeRight;

@property(nonatomic, retain)tztTrendView_scroll *pScrollIndexView;
@property(nonatomic, retain)TZTHQHeaderView *pIndexHQView;
@property(nonatomic, retain)TZTIndustryCell *pIndustryView;
@property (nonatomic, assign)BOOL     bNOFresh; // To control the tableView not to fresh so that can prevent scrollview disordered

@property(nonatomic,retain)tztHqTableConfig *tableConfig;

@property(nonatomic, retain)UITableView     *pTableView;
@property(nonatomic, retain)NSMutableArray  *data;
@property (nonatomic,retain) NSMutableArray *ayStockType;

@end

@implementation TZTHSStockTableView

@synthesize pScrollIndexView = _pScrollIndexView;
@synthesize ayStockType = _ayStockType;
@synthesize ntztMarket = _ntztMarket;
@synthesize swipeLeft = _swipeLeft;
@synthesize swipeRight = _swipeRight;
@synthesize tableConfig = _tableConfig;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self initdata];
        self.backgroundColor = [UIColor tztThemeBackgroundColorHQ];
        [self initData];
    }
    return self;
}

-(id)init
{
    if (self = [super init])
    {
        [self initData];
    }
    return self;
}

- (void)initData
{
    centerCount = 0;
    nonCenCount = 0;
    //默认是沪深
    _ntztMarket = MENU_HQ_HS;
    [[tztMoblieStockComm getSharehqInstance] addObj:self];
    
}

-(void)dealloc
{
    [[tztMoblieStockComm getSharehqInstance] removeObj:self];
    [super dealloc];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    [self.pIndexHQView layoutSubviews];
    [self.pIndustryView layoutSubviews];
    [self.pScrollIndexView layoutSubviews];
}

-(void)setNtztMarket:(int)nMarket
{
    _ntztMarket = nMarket;
    //此处应该根据market类型判断读取不同配置文件
    switch (_ntztMarket)
    {
        case MENU_HQ_HK:
        {
            self.tableConfig = [[[tztHqTableConfig alloc] initWithConfig:@"tztHKTableConfig"] autorelease];
        }
            break;
        case MENU_HQ_Global:
        {
            self.tableConfig = [[[tztHqTableConfig alloc] initWithConfig:@"tztQQTableConfig"] autorelease];
        }
            break;
        case MENU_HQ_FundLiuxiang:
        {
            self.tableConfig = [[[tztHqTableConfig alloc] initWithConfig:@"tztLXTableConfig"] autorelease];
        }
            break;
        case MENU_HQ_Index://大盘
        {
            self.tableConfig = [[[tztHqTableConfig alloc] initWithConfig:@"tztDPTableConfig"] autorelease];
        }
            break;
        case MENU_HQ_BlockHq://板块
        {
            self.tableConfig = [[[tztHqTableConfig alloc] initWithConfig:@"tztBlockTableConfig"] autorelease];
        }
            break;
            
        default:
        {
            self.tableConfig = [[[tztHqTableConfig alloc] initWithConfig:@"tztHSTableConfig"] autorelease];
        }
            break;
    }
}

-(void)onSetViewRequest:(BOOL)bRequest
{
    if (self.pScrollIndexView)
    {
        [self.pScrollIndexView onSetViewRequest:bRequest];
    }
    [super onSetViewRequest:bRequest];
}

-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    CGRect rcFrame = self.bounds;
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
    
    if (_swipeLeft == NULL)
    {
        _swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                               action:@selector(SwipeLeftOrRight:)];
        _swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
        _swipeLeft.delegate = self;
        [self addGestureRecognizer:_swipeLeft];
        [_swipeLeft release];
    }
    if (_swipeRight == NULL)
    {
        _swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                               action:@selector(SwipeLeftOrRight:)];
        _swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
        _swipeRight.delegate = self;
        [self addGestureRecognizer:_swipeRight];
        [_swipeRight release];
    }
    _pTableView.backgroundColor = [UIColor tztThemeBackgroundColorHQ];
}

-(void)SwipeLeftOrRight:(UISwipeGestureRecognizer*)recognsizer
{
    if (self.tztdelegate && [self.tztdelegate respondsToSelector:@selector(tztOnSwipe:andView_:)])
    {
        [self.tztdelegate tztOnSwipe:recognsizer andView_:self];
    }
    
}

#pragma mark - Actions

- (void)open:(id)sender
{
    TZTHSHeaderView *headerView = (TZTHSHeaderView *)sender;
    //切换展开和收起状态
    headerView.open = !headerView.open;
    
    //取得section
    NSInteger section = headerView.tag-kHeaderViewTag;
    tztHQTableDataObj *obj = [self.tableConfig dictionaryAtIndex:section];
    obj.bOpen = headerView.open;
    [self.pTableView reloadSections:[NSIndexSet indexSetWithIndex:section]
             withRowAnimation:UITableViewRowAnimationFade];
    
}

- (void)more:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    NSMutableDictionary *dic = nil;
    NSInteger nTag = btn.tag - kHeaderViewTag;
    
    tztHQTableDataObj *obj = [self.tableConfig dictionaryAtIndex:nTag];
    if (obj == nil)
        return;
    
    dic = obj.dictRequest;
    self.pStockInfo.stockCode = [dic objectForKey:@"StockCode"];
    self.pStockInfo.stockName = [dic objectForKey:@"Name"];
    
    NSMutableDictionary *dict = NewObject(NSMutableDictionary);
    [dict setTztObject:obj.nsHQMenuID forKey:@"HQMenuID"];
    [dict setTztObject:obj.nsMarketID forKey:@"Market"];
    [dict setTztObject:obj.nsSectionName forKey:@"Name"];
    
    NSString* strAction = [dic tztObjectForKey:@"Action"];
    NSString* strAccountIndex = [dic tztObjectForKey:@"AccountIndex"];
    NSString* strDirection = [dic tztObjectForKey:@"Direction"];
    if (strAction)
        [dict setTztObject:strAction forKey:@"Action"];
    if (strAccountIndex)
        [dict setTztObject:strAccountIndex forKey:@"AccountIndex"];
    if (strDirection)
        [dict setTztObject:strDirection forKey:@"Direction"];
    
    
    [TZTUIBaseVCMsg OnMsg:0x123456 wParam:(NSUInteger)self.pStockInfo lParam:(NSUInteger)dict];
    DelObject(dict);
    return;
}

- (NSArray *)getSendStockArray:(NSArray *)sourceArray
{
    NSMutableArray *stockArray = [NSMutableArray array];
    
    int i = 0;
    for (NSDictionary *pDict in sourceArray)
    {
        tztStockInfo *pStock = NewObjectAutoD(tztStockInfo);
        pStock.stockName = [pDict tztObjectForKey:@"Name"];
        pStock.stockCode = [pDict tztObjectForKey:@"Code"];
        if (_ayStockType && i < [_ayStockType count])
        {
            NSString* strType = [_ayStockType objectAtIndex:i];
            if (strType && [strType length] > 0)
            {
                pStock.stockType = [strType intValue];
            }
        }
        [stockArray addObject:pStock];
        i ++;
    }
    
    return stockArray;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    tztHQTableDataObj * obj = [self.tableConfig dictionaryAtIndex:indexPath.section];
    BOOL opened = obj.bOpen;
    NSInteger numberOfRows;
    //判断展开状态,如果展开则显示组员
    if (opened)
    {
        numberOfRows = obj.nMembers;
    }
    else
    {
        numberOfRows = 0;
    }
    
    if (numberOfRows <= 0)
        return 0;
    
    return obj.fRowHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    tztHQTableDataObj *obj = [self.tableConfig dictionaryAtIndex:section];
    return obj.fSectionHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    tztHQTableDataObj *obj = [self.tableConfig dictionaryAtIndex:section];
    if (obj == nil)
        return nil;
    
    CGRect sectionRect = CGRectMake(0, 0, self.bounds.size.width, obj.fSectionHeight /*tableView.sectionHeaderHeight*/ );
    UIView *groupHeaderView = nil;
    //判断类型
    switch (obj.nSectionType)
    {
        case 1://1-分时行情
        {
            sectionRect.size.height = obj.fSectionHeight;
            if (self.pScrollIndexView == nil)
            {
                self.pScrollIndexView = [[[tztTrendView_scroll alloc] initWithFrame:sectionRect] autorelease];
                _pScrollIndexView.nShowTop = 0;
                _pScrollIndexView.hasHiddenBtn = FALSE;
                _pScrollIndexView.tztDelegate = self;
                [_pScrollIndexView RequestReportData];
            }
            return self.pScrollIndexView;
        }
            break;
        default:
        {
            groupHeaderView = (TZTHSHeaderView*)[tableView viewWithTag:kHeaderViewTag+section];
            if (groupHeaderView==nil) {
                groupHeaderView = [[[TZTHSHeaderView alloc]initWithFrame:sectionRect]autorelease];
                groupHeaderView.tag = kHeaderViewTag+section;
                ((TZTHSHeaderView*)groupHeaderView).btnMore.tag = kHeaderViewTag + section;
                groupHeaderView.backgroundColor = [UIColor tztThemeBackgroundColorSection];
                ((TZTHSHeaderView*)groupHeaderView).delegate = self;
            }
            //取得群组对应的dic
            //设置群组名称
            ((TZTHSHeaderView*)groupHeaderView).groupName = [NSString stringWithFormat:@"%@", obj.nsSectionName];// obj.nsSectionName;
            ((TZTHSHeaderView*)groupHeaderView).open = obj.bOpen;
        }
            break;
    }
    return groupHeaderView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TZTUserStockTableViewCell *cell = (TZTUserStockTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
    
    cell.selected = FALSE;
    if (cell && [cell CancelQuickSellShow])
    {
        return;
    }
    NSDictionary *pDict = nil;
    NSArray     *stockTypeArr;
    NSArray     *sendStockArray;
    
    tztHQTableDataObj *obj = [self.tableConfig dictionaryAtIndex:indexPath.section];
    if (obj == nil || indexPath.row >= obj.ayContent.count)
    {
        [cell CancelSelected];
        return;
    }
    
    pDict = [obj.ayContent objectAtIndex:indexPath.row];
    stockTypeArr = obj.ayStockType;
    sendStockArray = obj.ayContent;
    
    NSDictionary* dictName = [pDict tztObjectForKey:@"Name"];
    NSDictionary* dictCode = [pDict tztObjectForKey:@"Code"];
    
    if (dictCode == NULL || dictCode.count <= 0)
    {
        [cell CancelSelected];
        return;
    }
    
    if (pDict == NULL || [dictCode tztObjectForKey:@"value"] == NULL)
    {
        [cell CancelSelected];
        return;
    }
    tztStockInfo *pStock = NewObjectAutoD(tztStockInfo);
    pStock.stockName = [dictName tztObjectForKey:@"value"];
    pStock.stockCode = [dictCode tztObjectForKey:@"value"];
    
    if (stockTypeArr && indexPath.row < [stockTypeArr count])
    {
        NSString* strType = [stockTypeArr objectAtIndex:indexPath.row];
        if (strType && [strType length] > 0)
        {
            pStock.stockType = [strType intValue];
        }
    }
    
    if (_ntztMarket == MENU_HQ_BlockHq && [[obj.dictRequest objectForKey:@"Action"] intValue] == 20196)
    {
        NSDictionary* dict = @{@"Action":@"20199"};
        [TZTUIBaseVCMsg OnMsg:0x123456 wParam:(NSUInteger)pStock lParam:(NSUInteger)dict];
    }
    else
        [TZTUIBaseVCMsg OnMsg:MENU_HQ_Trend wParam:(NSUInteger)pStock lParam:(NSUInteger)sendStockArray];
    [cell CancelSelected];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.tableConfig.ayData count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    tztHQTableDataObj *obj = [self.tableConfig dictionaryAtIndex:section];
    NSInteger numberOfRows = obj.nMembers;
    return numberOfRows;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    tztHQTableDataObj *obj = [self.tableConfig dictionaryAtIndex:indexPath.section];
    if (obj == nil)
        return;
    
    switch (obj.nSectionType)
    {
//        case 1://分时
//        {
//            
//        }
//            break;
        case 2://指数
        {
            [self.pIndexHQView setContent:obj.ayContent];
        }
            break;
        case 3://板块
        {
            [self.pIndustryView setContentData:obj.ayContent];
        }
            break;
        default:
        {
            ((TZTUserStockTableViewCell*)cell).nsSection = obj.nsOrderKey;
            if (obj.ayContent.count > indexPath.row)
                [(TZTUserStockTableViewCell*)cell setContent:[obj.ayContent objectAtIndex:indexPath.row]];
            else
            {
                [(TZTUserStockTableViewCell*)cell setContent:NULL];
            }
        }
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identify = [NSString stringWithFormat:@"cellId%ld%ld", (long)indexPath.section, (long)indexPath.row ];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    
    tztHQTableDataObj *obj = [self.tableConfig dictionaryAtIndex:indexPath.section];
    BOOL opened = obj.bOpen;
    if (cell == nil)
    {
        switch (obj.nSectionType)
        {
            case 2://指数报价
            {
                if (self.pIndexHQView==nil)
                {
                    self.pIndexHQView = [[[TZTHQHeaderView alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify andTotalCol:3 bUseBackColor_:obj.bIndexUseBackColor bShowArrow_:obj.bIndexUseArrow] autorelease];
                    cell = self.pIndexHQView;
                }
            }
                break;
            case 3://板块指数
            {
                self.pIndustryView = [[[TZTIndustryCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify andTotalCount_:6 andGrid_:obj.bIndexUseBackColor bHasTopStock:!obj.bIndexUseArrow] autorelease];
                self.pIndustryView.clBackColor = [UIColor tztThemeBackgroundColorHQ];
                cell = self.pIndustryView;
            }
                break;
                
            default:
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
                                                              ayColKeys_:obj.ayShowColKeys
                                                                bUseSep_:bUseSep] autorelease];
                ((TZTUserStockTableViewCell *)cell).delegate = self;
                ((TZTUserStockTableViewCell *)cell).tztDelegate = self;
                ((TZTUserStockTableViewCell *)cell).nRowIndex = indexPath.row;
                
                [rightUtilityButtons release];
            }
                break;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    //判断展开状态,如果展开则显示组员
    cell.hidden = !opened;
    self.pIndustryView.backgroundColor = [UIColor tztThemeBackgroundColorHQ];
    return cell;
}

#pragma mark - SWTableViewDelegate

- (void)swippableTableViewCell:(TZTUserStockTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index
{
    NSIndexPath *indexPath = [self.pTableView indexPathForCell:cell];
    NSDictionary *pDict = nil;
    NSArray     *stockTypeArr;
    
    tztHQTableDataObj *obj = [self.tableConfig dictionaryAtIndex:indexPath.section];
    
    if (obj == nil || indexPath.row >= obj.ayContent.count)
        return;
    
    pDict = [obj.ayContent objectAtIndex:indexPath.row];
    stockTypeArr = obj.ayStockType;
    
    if (pDict == NULL || [pDict tztObjectForKey:@"Code"] == NULL)
        return;
    
    tztStockInfo *pStock = NewObjectAutoD(tztStockInfo);
    pStock.stockName = [[pDict tztObjectForKey:@"Name"] objectForKey:@"value"];
    pStock.stockCode = [[pDict tztObjectForKey:@"Code"] objectForKey:@"value"];
    
    if (stockTypeArr && indexPath.row < [stockTypeArr count])
    {
        NSString* strType = [stockTypeArr objectAtIndex:indexPath.row];
        if (strType && [strType length] > 0)
        {
            pStock.stockType = [strType intValue];
        }
    }
    
    switch (index)
    {
        case 0:
        {
            [TZTUIBaseVCMsg OnMsg:MENU_JY_PT_Buy wParam:(NSUInteger)pStock lParam:0];
            break;
        }
        case 1:
        {
            [TZTUIBaseVCMsg OnMsg:MENU_JY_PT_Sell wParam:(NSUInteger)pStock lParam:0];
            break;
        }
        case 2:
        {
            [TZTUIBaseVCMsg OnMsg:MENU_SYS_UserWarning wParam:(NSUInteger)pStock lParam:0];
            break;
        }
        default:
            break;
    }
    [cell hideUtilityButtonsAnimated:YES];
}

- (void)swippableTableViewCell:(TZTUserStockTableViewCell *)cell scrollingToState:(SWCellState)state
{
    
    if (state == kCellStateCenter)
    {
        centerCount ++;
    }
    else
    {
        nonCenCount ++;
    }
    if (centerCount == nonCenCount)
    {
        self.bNOFresh = NO;
    }
    else
    {
        self.bNOFresh = YES;
    }
}

-(void)onRequestData:(BOOL)bShowProcess
{
    //总共6个请求
    //沪深指数＋热门行业＋涨幅榜＋跌幅榜＋换手率榜＋振幅榜
    //制定特定的reqno，6个请求同时发送，处理特定的reqno
    
//    [self.pScrollIndexView RequestReportData];

    if (_bRequest && !self.bNOFresh)
    {
        for (NSInteger i = 0; i < [self.tableConfig.ayData count]; i++)
        {
            tztHQTableDataObj *obj = [self.tableConfig dictionaryAtIndex:i];
            if (obj == nil || obj.dictRequest == nil || obj.dictRequest.count < 1)
                continue;
            NSString* strAction = [obj.dictRequest tztObjectForKey:@"Action"];
            if (strAction.length < 1)
                continue;
            
            NSMutableDictionary *pDict = NewObject(NSMutableDictionary);
            NSDictionary *request = obj.dictRequest;
            
            for (NSString* strKey in request.allKeys)
            {
                if ([strKey caseInsensitiveCompare:@"Action"] == NSOrderedSame)
                    continue;
                
                [pDict setTztObject:[request tztObjectForKey:strKey] forKey:strKey];
            }
            
            NSString *strReqno = tztKeyReqno((long)self, (int)(tztIndexReqNo + obj.nSection));
            [pDict setTztObject:strReqno forKey:@"Reqno"];
            [[tztMoblieStockComm getSharehqInstance] onSendDataAction:strAction withDictValue:pDict];
            DelObject(pDict);
        }
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat sectionHeaderHeight = 40;
    if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
    }
}

//数据处理
-(NSUInteger)OnCommNotify:(NSUInteger)wParam lParam_:(NSUInteger)lParam
{
    if (wParam == 0)
        return 0;
    tztNewMSParse* pParse = (tztNewMSParse*)wParam;
    if (pParse == NULL)
        return 0;
    
    
    //获取reqno
    NSString* strAction = [pParse GetByName:@"Action"];
    NSString* strReqno = [pParse GetByName:@"Reqno"];
    long iPhoneKey = tztGetIphoneKey(strReqno);
    int nReqno = tztGetReqno(strReqno);
    
    if (iPhoneKey != (long)self)
        return 0;
    
    for (tztHQTableDataObj *obj in self.tableConfig.ayData)
    {
        NSString* reqAction = [obj.dictRequest tztObjectForKey:@"Action"];
        if (strAction && [strAction caseInsensitiveCompare:reqAction] == NSOrderedSame
            && obj.nSection == nReqno - tztIndexReqNo)
        {
            [self dealRecvData:pParse andAyData_:obj.ayContent];
            if (_ayStockType)
            {
                obj.ayStockType = _ayStockType;
            }
            switch (obj.nSectionType)
            {
                case 2://指数
                {
                    [self.pIndexHQView setContent:obj.ayContent];
                }
                    break;
                case 3://板块
                {
                    [self.pIndustryView setContentData:obj.ayContent];
                }
                    break;
                default:
                {
                    NSIndexSet *set = [NSIndexSet indexSetWithIndex:obj.nSection];
                    [self.pTableView reloadSections:set withRowAnimation:UITableViewRowAnimationNone];
                }
                    break;
            }
        }
    }
    return 1;
}


-(void)dealRecvData:(tztNewMSParse*)pParse andAyData_:(NSMutableArray*)ayStockList
{
    if (ayStockList == NULL)
        return;
    [ayStockList removeAllObjects];
    
    //解析指数数据
    NSArray *ayGridVol = [pParse GetArrayByName:@"Grid"];
    if ([ayGridVol count] <= 0)
    {
        return;
    }
    
    NSInteger nCodeIndex = -1;//代码索引
    /*
     注：
     默认返回数据的固定位置，然后去获取索引，若没索引，直接用固定制*/
    int nNameIndex = 0;//名称索引
    int nPriceIndex = 1;//最新价索引
    int nRatioIndex = 3;//涨跌索引
    int nRangeIndex = 2;//幅度索引
    int nTotalValueIndex = 10;//总市值索引
    int nchangeIndex = 12;//换手率
    int nZFIndex = 13;//振幅
    
    int nLeadStockCodeIndex = -1;
    int nLeadStockNameIndex = -1;
    int nLeadNewPriceIndex = -1;
    int nLeadUpDownPIndex = -1;
    
    NSString *strIndex = [pParse GetByName:@"stockcodeindex"];
    TZTStringToIndex(strIndex, nCodeIndex);
    
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
    
    strIndex = [pParse GetByName:@"ChangePerIndex"];
    TZTStringToIndex(strIndex, nchangeIndex);
    if (nchangeIndex < 0)
        nchangeIndex = 12;
    
    strIndex = [pParse GetByName:@"SHOCKRANGINDEX"];
    TZTStringToIndex(strIndex, nZFIndex);
    if (nZFIndex < 0)
        nZFIndex = 13;
    
    strIndex = [pParse GetByName:@"LeadStockCodeIndex"];
    TZTStringToIndex(strIndex, nLeadStockCodeIndex);
    
    strIndex = [pParse GetByName:@"LeadStockNameIndex"];
    TZTStringToIndex(strIndex, nLeadStockNameIndex);
    
    strIndex = [pParse GetByName:@"LeadUpDownPIndex"];
    TZTStringToIndex(strIndex, nLeadUpDownPIndex);
    
    strIndex = [pParse GetByName:@"LeadNewPriceIndex"];
    TZTStringToIndex(strIndex, nLeadNewPriceIndex);
    
    
    //颜色
    NSString* strBase = [pParse GetByName:@"BinData"];
    NSData* DataBinData = [NSData tztdataFromBase64String:strBase];
    char *pColor = (char*)[DataBinData bytes];
    if(pColor)
        pColor = pColor + 2;//时间 2个字节
    
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
    
    //
    NSString* strStockProp = [pParse GetByName:@"StockProp"];
    NSArray* ayStockProp = [strStockProp componentsSeparatedByString:@"|"];
    
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
                bDeal = TRUE;
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
                strKey = @"Name";
                if (pColor)
                    txtColor = [UIColor colorWithChar:*pColor];
            }
            else if (j == nCodeIndex)
            {
                bDeal = TRUE;
                strKey = @"Code";
                strValue= [NSString stringWithFormat:@"%@", [ayData objectAtIndex:j]];
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
            else if (j == nPriceIndex)//最新价
            {
                bDeal = TRUE;
                strKey = @"NewPrice";
                strValue = [NSString stringWithFormat:@"%@", [ayData objectAtIndex:j]];
                if (pColor)
                    txtColor = [UIColor colorWithChar:*pColor];
            }
            else if (j == nRatioIndex)//涨跌值
            {
                bDeal = TRUE;
                strKey = @"Ratio";
                strValue = [NSString stringWithFormat:@"%@", [ayData objectAtIndex:j]];
                if (pColor)
                    txtColor = [UIColor colorWithChar:*pColor];
            }
            else if (j == nRangeIndex)//涨跌幅
            {
                bDeal = TRUE;
                strKey = @"Range";
                strValue = [NSString stringWithFormat:@"%@", [ayData objectAtIndex:j]];
                if (pColor)
                    txtColor = [UIColor colorWithChar:*pColor];
            }
            else if (j == nTotalValueIndex)//总市值
            {
                bDeal = TRUE;
                strKey = @"TotalValue";
                strValue = [NSString stringWithFormat:@"%@", [ayData objectAtIndex:j]];
                if (pColor)
                    txtColor = [UIColor colorWithChar:*pColor];
            }
            else if (j == nchangeIndex)//换手率
            {
                bDeal = TRUE;
                strKey = @"ChangeValue";
                strValue = [NSString stringWithFormat:@"%@", [ayData objectAtIndex:j]];
                if (pColor)
                    txtColor = [UIColor colorWithChar:*pColor];
            }
            else if (j == nZFIndex)//振幅
            {
                bDeal = TRUE;
                strKey = @"RangeValue";
                strValue = [NSString stringWithFormat:@"%@", [ayData objectAtIndex:j]];
                if (pColor)
                    txtColor = [UIColor colorWithChar:*pColor];
            }
            else if (j == nLeadStockCodeIndex)
            {
                bDeal = TRUE;
                strKey = @"LeadStockCode";
                strValue = [NSString stringWithFormat:@"%@", [ayData objectAtIndex:j]];
                if (pColor)
                    txtColor = [UIColor colorWithChar:*pColor];
            }
            else if (j == nLeadStockNameIndex)
            {
                bDeal = TRUE;
                strKey = @"LeadStockName";
                strValue = [NSString stringWithFormat:@"%@", [ayData objectAtIndex:j]];
                if (pColor)
                    txtColor = [UIColor colorWithChar:*pColor];
            }
            else if (j == nLeadUpDownPIndex)
            {
                bDeal = TRUE;
                strKey = @"LeadRange";
                strValue = [NSString stringWithFormat:@"%@", [ayData objectAtIndex:j]];
                if (pColor)
                    txtColor = [UIColor colorWithChar:*pColor];
            }
            else if (j == nLeadNewPriceIndex)
            {
                bDeal = TRUE;
                strKey = @"LeadNewPrice";
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
        
        [ayStockList addObject:pStockDict];
        [pStockDict release];
    }

}

-(void)HiddenQuickSell:(TZTUserStockTableViewCell *)cell
{
    NSArray *ay = [self.pTableView visibleCells];
    for (int i = 0; i < ay.count; i++)
    {
        id subCell = [ay objectAtIndex:i];
        if (subCell && [subCell isKindOfClass:[TZTUserStockTableViewCell class]])
            [cell HiddenQuickSell:subCell];
    }
}

-(void)tztTrendScroll:(id)send showOrHiddenWithRect:(CGRect)rect
{
    [TZTUIBaseVCMsg OnMsg:MENU_HQ_Index wParam:0 lParam:0];
}
@end
