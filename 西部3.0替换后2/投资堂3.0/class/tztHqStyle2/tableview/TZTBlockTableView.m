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
 * 整理修改:
 *
 ***************************************************************/

#import "TZTBlockTableView.h"
#import "TZTUserStockTableViewCell.h"
#import "TZTIndustryView.h"
#import "TZTHQHeaderView.h"
#import "tztTrendView_scroll.h"
#import "tztUINewMarketView.h"
#import "tztInitReportMarketMenu.h"

#define kHeaderViewTag 100
#define HeaderHeight 158
#define HQBtnTag 1000

#define tztBlockReqNo   (1024)

#define RangType    @"RangType"

#define GrayWhite [UIColor colorWithRed:237.0/255 green:237.0/255 blue:237.0/255 alpha:1.0]
#define BgWhite [UIColor colorWithRed:247.0/255 green:247.0/255 blue:247.0/255 alpha:1.0]

@interface TZTBlockTableView()  <UITableViewDataSource, UITableViewDelegate, HeadDelegate, SWTableViewCellDelegate,UIGestureRecognizerDelegate,tztUITableListViewDelegate>
{
    int centerCount;
    int nonCenCount;
    
    uint16_t _ntztBlockReqno;
}

@property(nonatomic,retain)UISwipeGestureRecognizer *swipeLeft;
@property(nonatomic,retain)UISwipeGestureRecognizer *swipeRight;

@property (nonatomic, assign)BOOL     bNOFresh; // To control the tableView not to fresh so that can prevent scrollview disordered

@property(nonatomic, retain)UITableView     *pTableView;
@property(nonatomic, retain)NSMutableArray  *data;
@property(nonatomic, retain)NSMutableArray  *ayBlockData;   //热门行业数据
@property (nonatomic,retain) NSMutableArray *ayStockType;
@property (nonatomic, retain)NSMutableArray *ayRankRequest;
@property (nonatomic, retain)NSMutableDictionary *dicType;

@property(nonatomic,retain)tztUITableListView* pMenuView;
@property(nonatomic,retain)tztUINewMarketView     *pMarketView;

@property(nonatomic,retain)NSMutableDictionary *pMenuDict;
@property(nonatomic,retain)NSString            *nsMenuID;
@property(nonatomic,retain)NSString            *nsFirstID;

@property(nonatomic,retain)NSString             *strRequestData;
@property(nonatomic,retain)NSString             *strTitle;


@end

@implementation TZTBlockTableView
@synthesize ayStockType = _ayStockType;
@synthesize ntztMarket = _ntztMarket;
@synthesize swipeLeft = _swipeLeft;
@synthesize swipeRight = _swipeRight;

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
    if (_ntztBlockReqno < 1)
        _ntztBlockReqno = tztBlockReqNo;
    
    centerCount = 0;
    nonCenCount = 0;
    
    if (_data == NULL)
        _data = [[NSMutableArray alloc] init];
    if (_ayRankRequest == NULL)
        _ayRankRequest = [[NSMutableArray alloc] init];
    if (_dicType == NULL)
        _dicType = [[NSMutableDictionary alloc] init];
    [[tztMoblieStockComm getSharehqInstance] addObj:self];
    
}

-(void)dealloc
{
    [[tztMoblieStockComm getSharehqInstance] removeObj:self];
    [super dealloc];
}

-(void)setNtztMarket:(int)nMarket
{
    _ntztMarket = nMarket;
    
    [self.data removeAllObjects];

    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:@"1" forKey:@"open"];
    [dic setObject:@"涨幅榜" forKey:@"sectionName"];
    NSMutableArray *arr = [NSMutableArray arrayWithObjects:@"0", @"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", nil];
    [dic setObject:arr forKey:@"memberList"];
    
    [self.data addObject:dic];
}

-(void)onSetViewRequest:(BOOL)bRequest
{
//    [[tztMoblieStockComm getSharehqInstance] removeObj:self];
    if (_pMenuView && !_pMenuView.hidden)
        [super onSetViewRequest:NO];
    else
        [super onSetViewRequest:bRequest];
}

-(void)setFrame:(CGRect)frame
{
    if (CGRectIsEmpty(frame) || CGRectIsNull(frame))
        return;
    [super setFrame:frame];
    
    CGRect rcFrame = self.bounds;
    
    CGRect rcMarket = rcFrame;
    rcMarket.size.height = 35;
    if (_pMarketView == NULL)
    {
        _pMarketView = [[tztUINewMarketView alloc] init];
        _pMarketView.frame = rcMarket;
        _pMarketView.pDelegate = self;
        [self addSubview:_pMarketView];
        [_pMarketView release];
    }
    else
    {
        _pMarketView.frame = rcMarket;
    }
    
    [self SetMenuID:@"4"];
    self.nsMenuID = @"4";
    
    if (self.pMenuDict && [self.pMenuDict count] > 0
        && [[self.pMenuDict objectForKey:@"tradelist"] count] > 1 )
    {
        [_pMarketView SetMarketData:self.pMenuDict];
        if (_pMarketView.nsCurSel && _pMarketView.nsCurSel.length > 0)
        {
            NSString *str = [NSString stringWithFormat:@"%@",_pMarketView.nsCurSel];
            [_pMarketView setSelBtIndex:str];
        }
        else
        {
            NSString *str = @"";
            if (self.nsFirstID.length > 0)
                str= [self GetnsMenuSelData];
            
            if (str.length > 0)
            {
                int nIndex = [_pMarketView setSelBtIndex:str];
                [_pMarketView OnDefaultMenu:nIndex];
            }
            else
                [_pMarketView OnDefaultMenu:0];
        }
    }
    
    _pMarketView.frame = rcMarket;
    
    rcFrame.origin.y += rcMarket.size.height;
    rcFrame.size.height -= rcMarket.size.height;
    
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
    
    if (_pMenuView == nil)
    {
        _pMenuView = [[tztUITableListView alloc] initWithFrame:rcFrame];
        _pMenuView.tztdelegate = self;
        _pMenuView.bLocalTitle = NO;
        _pMenuView.hidden = YES;
        [self addSubview:_pMenuView];
        [_pMenuView release];
    }
    else
    {
        _pMenuView.frame = rcFrame;
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


-(void)SetMenuID:(NSString *)nsID
{
    [self.pMenuDict removeAllObjects];
    if (nsID)
        self.nsMenuID = [NSString stringWithFormat:@"%@", nsID];
    self.pMenuDict = [self GetMarketMenu];
}


-(NSMutableDictionary*)GetMarketMenu
{
    if (self.nsMenuID == NULL || [self.nsMenuID length] <= 0)
        return NULL;
    return [g_pReportMarket GetSubMenuById:nil nsID_:self.nsMenuID];
}

-(NSString*)GetnsMenuSelData
{
    NSMutableDictionary *pDict = [g_pReportMarket GetSubMenuById:self.pMenuDict nsID_:self.nsFirstID];
    NSString* strMenuData = [pDict objectForKey:@"MenuData"];
    if (strMenuData == NULL || [strMenuData length] < 1)
        return nil;
    NSArray *pAy = [strMenuData componentsSeparatedByString:@"|"];
    if (pAy == NULL || [pAy count] < 3)
        return nil;
    NSString* strAction = [pAy objectAtIndex:0];
    NSString* strParam = [pAy objectAtIndex:3];
    NSString* str = [NSString stringWithFormat:@"%@#%@",strParam,strAction];
    return str;
}

-(void)tztUIMarket:(id)sender DidSelectMarket:(NSMutableDictionary *)pDict marketMenu:(NSDictionary *)pMenu
{
    if(sender == _pMarketView)
    {
        if (pDict == NULL || [pDict count] <= 0)
            return;
//        NSString* strTitle = [pDict tztObjectForKey:@"tztTitle"];
        NSString* strParam = [pDict tztObjectForKey:@"tztParam"];
        NSString* strMenuData = [pDict tztObjectForKey:@"tztMenuData"];
        NSArray *pAyParam = [strParam componentsSeparatedByString:@"#"];
        if (pAyParam == NULL || [pAyParam count] < 2)
            return;
        
        NSArray *pAyMenuData = [strMenuData componentsSeparatedByString:@"|"];
        if (pAyMenuData.count < 2)
            return;
        
        
        /*
         此处需要增加判断，下级是不是可以直接请求数据，还是要列表展示菜单
         */
        NSString* nsMenuID  = @"";
        NSString* nsID      = @"";
        NSString* nsType    = @"";
        NSString* nsParam   = @"";
        
        if ([pAyMenuData count] > 3)
            nsParam = [pAyMenuData objectAtIndex:3];
        
        if ([pAyMenuData count] >= 3)
        {
            nsMenuID = [pAyMenuData objectAtIndex:0];
            nsID     = [NSString stringWithFormat:@"%@", [pAyMenuData objectAtIndex:[pAyMenuData count] - 2]];
            nsType   = [NSString stringWithFormat:@"%@", [pAyMenuData objectAtIndex:[pAyMenuData count] - 3]];
        }
        
        BOOL bSubMenu = FALSE;
        int nAction = 0;
        if (nsParam && [nsParam length] > 0)
        {
            NSArray *ayParam = [nsParam componentsSeparatedByString:@"#"];
            if (ayParam && [ayParam count] > 1)
            {
                nAction = [[ayParam objectAtIndex:1] intValue];
                bSubMenu = (/*(nsID == NULL || [nsID length] <= 0)*/ (nAction <= 0));
            }
        }
        
        //还是菜单
        if ([nsType caseInsensitiveCompare:@"s"] == NSOrderedSame
            || bSubMenu)
        {
            if (_pMarketView)
            {
                NSString *nsdata = [NSString stringWithFormat:@"%@#%@",nsParam,nsMenuID];
                if (nAction == 20610 || nAction == 20611 || nAction == 20612 || nAction == 20613)
                {
                    nsdata = [NSString stringWithFormat:@"#%d#%@", nAction, nsMenuID];
                }
                [_pMarketView setSelBtIndex:nsdata];
            }
            
            NSMutableDictionary *pDictValue = [g_pReportMarket GetSubMenuById:nil nsID_:nsMenuID];
            _pMenuView.hidden = NO;
            _pMenuView.frame = _pMenuView.frame;
            [_pMenuView setAyListInfo:[pDictValue objectForKey:@"tradelist"]];
            [_pMenuView reloadData];
            [self onSetViewRequest:NO];
            return;
        }
        /*判断处理结束*/
        
        NSString *nsdata = [NSString stringWithFormat:@"%@#%@",nsParam,nsMenuID];
        [_pMarketView setSelBtIndex:nsdata];
        [self onSetViewRequest:YES];
//        self.nsCurrentID = @"";
        if ([pAyMenuData count] > 4)
        {
            self.strTitle = [NSString stringWithFormat:@"%@",[pAyMenuData objectAtIndex:1]];
            self.strRequestData = [NSString stringWithFormat:@"%@#%@", [pAyMenuData objectAtIndex:3], [pAyMenuData objectAtIndex:4]];
            [self onRequestData:YES];
        }
        _pMenuView.hidden = YES;
    }
}

-(BOOL)IsHaveSubMenu:(NSMutableDictionary*)pSubDict returnValue_:(NSMutableDictionary**)returnDict
{
    if (pSubDict == NULL)
        return FALSE;
    
    NSMutableArray *pData = [pSubDict objectForKey:@"tradelist"];
    if (pData == NULL || [pData count] <= 0)
        return FALSE;
    
    NSDictionary *pDict = [pData objectAtIndex:0];
    if (pDict == NULL)
        return FALSE;
    NSString* strMenuData = [pDict objectForKey:@"MenuData"];
    if (strMenuData == NULL || [strMenuData length] < 1)
        return FALSE;
    NSArray *pAy = [strMenuData componentsSeparatedByString:@"|"];
    if (pAy == NULL || [pAy count] < 3)
        return FALSE;
    
    /*
     此处需要增加判断，下级是不是可以直接请求数据，还是要列表展示菜单
     */
    NSString* nsMenuID  = @"";
    NSString* nsID      = @"";
    NSString* nsType    = @"";
    NSString* nsParam   = @"";
    
    if ([pAy count] > 3)
        nsParam = [pAy objectAtIndex:3];
    
    if ([pAy count] >= 3)
    {
        nsMenuID = [pAy objectAtIndex:0];
        nsID     = [NSString stringWithFormat:@"%@", [pAy objectAtIndex:[pAy count] - 2]];
        nsType   = [NSString stringWithFormat:@"%@", [pAy objectAtIndex:[pAy count] - 3]];
    }
    
    BOOL bSubMenu = FALSE;
    if (nsParam && [nsParam length] > 0)
    {
        NSArray *ayParam = [nsParam componentsSeparatedByString:@"#"];
        if (ayParam && [ayParam count] > 1)
        {
            bSubMenu = (/*(nsID == NULL || [nsID length] <= 0)*/ ([[ayParam objectAtIndex:1] intValue] <= 0));
        }
    }
    //还是菜单
    if ([nsType caseInsensitiveCompare:@"s"] == NSOrderedSame
        || bSubMenu)
    {
        NSMutableDictionary *pSubDict1 = [g_pReportMarket GetSubMenuById:self.pMenuDict nsID_:nsMenuID];
        //判断此处的菜单是否有下级菜单
        *returnDict = pSubDict1;
        return TRUE;
    }
    
    return FALSE;
}


-(BOOL)tztUITableListView:(tztUITableListView*)tableView withMsgType:(NSInteger)nMsgType withMsgValue:(NSString*)strMsgValue
{
    NSString* nsMenuID = @"0";
    NSArray* pAy = [strMsgValue componentsSeparatedByString:@"|"];
    if(pAy && [pAy count] > 3)
        nsMenuID = [pAy objectAtIndex:0];
    [TZTUIBaseVCMsg OnMsg:MENU_HQ_Report wParam:(NSUInteger)[NSString stringWithFormat:@"%@", nsMenuID] lParam:(NSUInteger)strMsgValue];
    return TRUE;
}

#pragma mark - Actions

- (void)open:(id)sender
{
    TZTHSHeaderView *headerView = (TZTHSHeaderView *)sender;
    //切换展开和收起状态
    headerView.open = !headerView.open;
    
    //取得section
    NSInteger section = headerView.tag-kHeaderViewTag;
    NSMutableDictionary *groupDic = [self.data objectAtIndex:section];
    //设置groupDic中的展开状态
    [groupDic setObject:[NSNumber numberWithBool:headerView.open] forKey:@"open"];
    [self.pTableView reloadSections:[NSIndexSet indexSetWithIndex:section]
             withRowAnimation:UITableViewRowAnimationFade];
    
}

- (void)more:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    NSMutableDictionary *dic = nil;
    NSInteger nTag = btn.tag - kHeaderViewTag;
    if (self.ntztMarket == MENU_HQ_HK || self.ntztMarket == MENU_HQ_Global)
        nTag -= 1;
    if (nTag < 0 || nTag >= [self.ayRankRequest count])
        return;
    dic = [self.ayRankRequest objectAtIndex:nTag];
    self.pStockInfo.stockCode = [dic objectForKey:@"StockCode"];
    self.pStockInfo.stockName = [dic objectForKey:@"Name"];
    [TZTUIBaseVCMsg OnMsg:0x123456 wParam:(NSUInteger)self.pStockInfo lParam:(NSUInteger)dic];
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
    NSDictionary *groupDic = [self.data objectAtIndex:indexPath.section];
    BOOL opened = [[groupDic objectForKey:@"open"]boolValue];
    NSInteger numberOfRows;
    //判断展开状态,如果展开则显示组员
    if (opened)
    {
        NSArray *memberList = [groupDic objectForKey:@"memberList"];
        numberOfRows = memberList.count;
    }
    else
    {
        numberOfRows = 0;
    }
    
    if (numberOfRows <= 0)
        return 0;
    return 44.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    CGRect sectionRect = CGRectMake(0, 0, self.bounds.size.width, 30 /*tableView.sectionHeaderHeight*/ );
    UIView *groupHeaderView = nil;
    groupHeaderView = (TZTHSHeaderView*)[tableView viewWithTag:kHeaderViewTag+section];
    if (groupHeaderView==nil) {
        groupHeaderView = [[[TZTHSHeaderView alloc]initWithFrame:sectionRect]autorelease];
        groupHeaderView.tag = kHeaderViewTag+section;
        ((TZTHSHeaderView*)groupHeaderView).btnMore.tag = kHeaderViewTag + section;
        groupHeaderView.backgroundColor = [UIColor tztThemeBackgroundColorSection];
        ((TZTHSHeaderView*)groupHeaderView).delegate = self;
    }
    //取得群组对应的dic
    NSMutableDictionary *groupDic = [self.data objectAtIndex:section];
    //设置群组名称
    ((TZTHSHeaderView*)groupHeaderView).groupName = [groupDic objectForKey:@"sectionName"];
    ((TZTHSHeaderView*)groupHeaderView).open = [[groupDic objectForKey:@"open"] boolValue];
    return groupHeaderView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *pDict = nil;
    NSArray     *stockTypeArr = nil;
    NSArray     *sendStockArray;
    switch (indexPath.section)
    {
        case 0:
        {
            if (indexPath.row >= [self.ayBlockData count])
                return;
            pDict = [self.ayBlockData objectAtIndex:indexPath.row];
            stockTypeArr = [self.dicType objectForKey:RangType];
            sendStockArray = self.ayBlockData;
        }
            break;
            
        default:
            break;
    }
    
    
    NSDictionary* dictName = [pDict tztObjectForKey:@"Name"];
    NSDictionary* dictCode = [pDict tztObjectForKey:@"Code"];
    
    if (dictCode == NULL || dictCode.count <= 0)
        return;
    
    if (pDict == NULL || [dictCode tztObjectForKey:@"value"] == NULL)
        return;
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
    
    [TZTUIBaseVCMsg OnMsg:MENU_HQ_Trend wParam:(NSUInteger)pStock lParam:(NSUInteger)sendStockArray];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    /*沪深 0-热门板块 1-涨幅 2-跌幅 3-换手率 4-资金流向 5-大盘指数*/
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSDictionary *groupDic = [self.data objectAtIndex:section];
//    BOOL opened = [[groupDic objectForKey:@"open"]boolValue];
    NSInteger numberOfRows;
    //判断展开状态,如果展开则显示组员
//    if (opened)
    {
        NSArray *memberList = [groupDic objectForKey:@"memberList"];
        numberOfRows = memberList.count;
        
        switch (section)
        {
            case 0:
            {
                numberOfRows = [self.ayBlockData count];
            }
                break;
            default:
                break;
        }
    }
   return numberOfRows;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section)
    {
        case 0:
        {
            ((TZTUserStockTableViewCell*)cell).nsSection = @"Range";
            if ([self.ayBlockData count] > indexPath.row)
            {
                [(TZTUserStockTableViewCell*)cell setContent:[self.ayBlockData objectAtIndex:indexPath.row]];
            }
            else
            {
                [(TZTUserStockTableViewCell*)cell setContent:NULL];
            }
        }
            break;
        default:
            break;
    }

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identify = [NSString stringWithFormat:@"cellId%ld%ld", (long)indexPath.section, (long)indexPath.row ];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    
    NSDictionary *groupDic = [self.data objectAtIndex:indexPath.section];
    BOOL opened = [[groupDic objectForKey:@"open"]boolValue];
    
    if (cell == nil)
    {
         NSMutableArray *rightUtilityButtons = [[NSMutableArray alloc] init];
        cell = [[[TZTUserStockTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                                reuseIdentifier:identify
                                            containingTableView:tableView // Used for row height and selection
                                             leftUtilityButtons:nil
                                            rightUtilityButtons:rightUtilityButtons] autorelease];
        ((TZTUserStockTableViewCell *)cell).delegate = self;
        ((TZTUserStockTableViewCell *)cell).tztDelegate = self;
        ((TZTUserStockTableViewCell *)cell).nRowIndex = indexPath.row;
        
        [rightUtilityButtons release];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    //判断展开状态,如果展开则显示组员
    cell.hidden = !opened;
    return cell;
}

#pragma mark - SWTableViewDelegate

- (void)swippableTableViewCell:(TZTUserStockTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index
{
    NSIndexPath *indexPath = [self.pTableView indexPathForCell:cell];
    NSDictionary *pDict = nil;
    NSArray     *stockTypeArr = nil;
    switch (indexPath.section) {
        case 0:
        {
            pDict = [self.ayBlockData objectAtIndex:indexPath.row];
            stockTypeArr = [self.dicType objectForKey:RangType];
        }
            break;
        default:
            break;
    }
    
    if (pDict == NULL || [pDict tztObjectForKey:@"Code"] == NULL)
        return;
    
    tztStockInfo *pStock = NewObjectAutoD(tztStockInfo);
    pStock.stockName = [pDict tztObjectForKey:@"Name"];
    pStock.stockCode = [pDict tztObjectForKey:@"Code"];
    
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

#pragma mark -

-(void)onRequestData:(BOOL)bShowProcess
{
    if (self.strRequestData.length <= 0)
        return;
    if (_bRequest && !self.bNOFresh)
    {
        NSString* strAction = @"";
        NSString* strGrid = @"";
        NSString* strAccountIndex = @"0";
        NSString* strDircetion = @"1";
        
        NSArray *ayData = [self.strRequestData componentsSeparatedByString:@"#"];
        if (ayData.count > 1)
        {
            strAction = [ayData objectAtIndex:1];
            strGrid = [ayData objectAtIndex:0];
            if (ayData.count > 2)
            {
                NSString* nsOrder = [ayData objectAtIndex:2];
                if (nsOrder.length > 0)
                {
                    int nOrder = [nsOrder intValue];
                    int accountIndex = nOrder / 2;
                    int nDirection = nOrder % 10;
                    strAccountIndex = [NSString stringWithFormat:@"%d",accountIndex];
                    strDircetion = [NSString stringWithFormat:@"%d", nDirection];
                }
            }
        }
        if (self.ayRankRequest)
            [self.ayRankRequest removeAllObjects];
        NSMutableDictionary *pDict = NewObject(NSMutableDictionary);
        [pDict removeAllObjects];
        
        _ntztBlockReqno++;
        if (_ntztBlockReqno >= UINT16_MAX)
            _ntztBlockReqno = tztBlockReqNo;
        
        NSString* strReqno = tztKeyReqno((long)self, _ntztBlockReqno);
        [pDict setTztObject:strReqno forKey:@"Reqno"];
        [pDict setTztObject:strDircetion forKey:@"Direction"];
        [pDict setTztObject:strAccountIndex forKey:@"AccountIndex"];
        [pDict setTztObject:@"0" forKey:@"DeviceType"];
        [pDict setTztObject:@"1" forKey:@"StartPos"];
        [pDict setTztObject:@"0" forKey:@"NewMarketNo"];
        [pDict setTztObject:@"10" forKey:@"MaxCount"];
        [pDict setTztObject:@"1" forKey:@"Lead"];
        
        [pDict setTztObject:strGrid forKey:@"StockCode"];
        [pDict setTztObject:@"1" forKey:@"StockIndex"];
        NSDictionary *dic = @{@"Direction": strDircetion, @"AccountIndex":strAccountIndex, @"StockCode":strGrid, @"Action":strAction, @"Name":(self.strTitle != NULL ? self.strTitle : @"")};
        [self.ayRankRequest addObject:dic];
        [[tztMoblieStockComm getSharehqInstance] onSendDataAction:strAction withDictValue:pDict];
        
        DelObject(pDict);
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
    //考虑只刷新对应的section
    if ([pParse IsIphoneKey:(long)self reqno:_ntztBlockReqno])
    {
        //对应section2
        if (self.ayBlockData == NULL)
            _ayBlockData = NewObject(NSMutableArray);
        [self dealRecvData:pParse andAyData_:self.ayBlockData];
        if (_ayStockType)
            [self.dicType setObject:[NSArray arrayWithArray:_ayStockType] forKey:RangType];

        NSIndexSet *set = [NSIndexSet indexSetWithIndex:0];
        [self.pTableView reloadSections:set withRowAnimation:UITableViewRowAnimationNone];
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
    NSInteger nNameIndex = 0;//名称索引
    NSInteger nPriceIndex = 1;//最新价索引
    NSInteger nRatioIndex = 3;//涨跌索引
    NSInteger nRangeIndex = 2;//幅度索引
    NSInteger nTotalValueIndex = 10;//总市值索引
    NSInteger nchangeIndex = 12;//换手率
    NSInteger nZFIndex = 13;//振幅
    
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

@end
