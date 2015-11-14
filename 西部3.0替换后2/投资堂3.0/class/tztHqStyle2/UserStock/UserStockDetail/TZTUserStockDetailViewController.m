//
//  TZTUserStockDetailViewController.m
//  tztMobileApp_GJUserStock
//
//  Created by 在琦中 on 14-3-26.
//
//

#import "TZTUserStockDetailViewController.h"

#define BLUEColor [UIColor colorWithRed:56.0/255 green:117.0/255 blue:197.0/255 alpha:1.0]
#define BlueColor [UIColor colorWithRed:67.0/255 green:148.0/255 blue:255.0/255 alpha:1.0]
#define BaseColor [UIColor colorWithRed:34.0/255 green:35.0/255 blue:36.0/255 alpha:1.0]
#define BottomHeight 44.0f

id g_pUserStockDetail = nil;
@interface TZTUserStockDetailViewController ()<tztBottomOperateViewDelegate>
{
    NSInteger pageIndex;
    int marketType;
}

@property(nonatomic, retain)tztStockInfo *preStockInfo;
@property(nonatomic, retain)tztStockInfo *nextStockInfo;
@end

@implementation TZTUserStockDetailViewController
@synthesize preStockInfo = _preStockInfo;
@synthesize nextStockInfo = _nextStockInfo;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

-(id)init
{
    if (self = [super init])
    {
        _nTitleType = TZTTitleReturn|TZTTitleSearch;
        self.nsTitle = @"";
    }
    return self;
}

- (void)dealloc
{
    if (_pAyViews)
    {
        [_pAyViews removeAllObjects];
    }
    DelObject(_pAyViews);
    userTableView.tztdelegate = nil;
    userTableView = nil;
    userTableView2.tztdelegate = nil;
    userTableView2 = nil;
    userTableView3.tztdelegate = nil;
    userTableView3 = nil;
    
    //取消主推
    [[tztAutoPushObj getShareInstance] cancelAutoPush:nil];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self getStockInfos];
    [self LoadLayoutView];
    [self setStockInfo:self.pStockInfo nRequest_:1];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)viewWillAppear:(BOOL)animated
{
    if (!IS_TZTIPAD)
    {
        [super viewWillAppear:animated];//????此处暂时先注释，pad版本弹出会导致右侧的关闭按钮失效，原因待查
        [self LoadLayoutView];
        
        [self requestAsPageIndex];
    }
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self setVcShowKind:tztvckind_Pop];
    UIView *pCurrentView = nil;
    for (NSInteger i = 0; i < _pMutilViews.pageViews.count; i++)
    {
        UIView *pView = [_pMutilViews.pageViews objectAtIndex:i];
        if (pView && [pView isKindOfClass:[tztHqBaseView class]])
        {
            if (i == _pMutilViews.nCurPage)
            {
                [(tztHqBaseView*)pView onSetViewRequest:YES];
                pCurrentView = pView;
            }
            else
                [(tztHqBaseView*)pView onSetViewRequest:NO];
        }
    }
    
    //增加主推数据请求
    if (g_bUseHQAutoPush)
    {
        if (self.pStockInfo && self.pStockInfo.stockCode)
        {
            [[tztAutoPushObj getShareInstance] setAutoPushDataWithString:[NSString stringWithFormat:@"%@|%d", self.pStockInfo.stockCode, self.pStockInfo.stockType] andDelegate_:(tztHqBaseView*)pCurrentView];
        }
    }
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    if (userTableView)
        [userTableView onSetViewRequest:NO];
    if (userTableView2)
        [userTableView2 onSetViewRequest:NO];
    if (userTableView3)
        [userTableView3 onSetViewRequest:NO];
}

-(void)OnToolbarMenuClick:(id)sender
{
    [super OnToolbarMenuClick:sender];
}

-(void)LoadLayoutView
{
    CGRect rcFrame = _tztBounds;
    if (CGRectIsEmpty(rcFrame) || CGRectIsNull(rcFrame))
        return;
    
    [self onSetTztTitleView:@"" type:_nTitleType];
    if (_pMutilViews == NULL)
    {
        _pMutilViews = [[tztMutilScrollView alloc] init];
        _pMutilViews.bSupportLoop = NO;
        _pMutilViews.tztdelegate = self;
        _pMutilViews.backgroundColor = [UIColor clearColor];
        _pMutilViews.hidePagecontrol = YES;
        _pMutilViews.bounces = YES;
        [_tztBaseView addSubview:_pMutilViews];
        [_pMutilViews release];
        
        if(_pAyViews == nil)
            _pAyViews = NewObject(NSMutableArray);
        [_pAyViews removeAllObjects];
        NSInteger nCount = [self.stockArray count];
        if (nCount > 1)
            nCount = 3;
        for (int i = 0; i < nCount; i++)
        {
            CGRect rcTable = rcFrame;
            if ( i == 0)
            {
                userTableView = [[TZTUserStockDetailTableView alloc] init];
                userTableView.tztdelegate = self;
                userTableView.stockDetailTittleView = stockDetailTittleVeiw;
                userTableView.frame = rcTable;
                [_pAyViews addObject:userTableView];
                [userTableView release];
            }
            else if( i == 1)
            {
                userTableView2 = [[TZTUserStockDetailTableView alloc] init];
                userTableView2.tztdelegate = self;
                userTableView2.stockDetailTittleView = stockDetailTittleVeiw2;
                userTableView2.frame = rcTable;
                [_pAyViews addObject:userTableView2];
                [userTableView2 release];
            }
            else if ( i == 2)
            {
                userTableView3 = [[TZTUserStockDetailTableView alloc] init];
                userTableView3.tztdelegate = self;
                userTableView3.stockDetailTittleView = stockDetailTittleVeiw3;
                userTableView3.frame = rcTable;
                [_pAyViews addObject:userTableView3];
                [userTableView3 release];
            }
        }
        _pMutilViews.pageViews = _pAyViews;
        _pMutilViews.nCurPage = (nCount > 2 ? 0 : 1);
        pageIndex = _pMutilViews.nCurPage;
        _pMutilViews.bSupportLoop = (nCount != 2);// (nCount > 2 ? YES : NO);
        [_pMutilViews setScrollEnabled:(nCount > 1)];
    }
    _pMutilViews.frame = _tztBounds;
    [_tztBaseView bringSubviewToFront:_tztTitleView];
    _tztTitleView.backgroundColor = [UIColor clearColor];
}

- (void)getStockInfos
{
    NSInteger count = [self.stockArray count];
    if (count == 0) {
        return;
    }
    NSInteger i = [self getIndexOfStockInfo];
    
    NSInteger pre, next;
    
    if (i == 0)
    {
        pre = count - 1;
        next = i+1;
    }
    else if (i == count - 1) {
        pre = i - 1;
        next = 0;
    }
    else
    {
        pre = i-1;
        next = i+1;
    }
    if (count == 1)
    {
        pre = next = 0;
    }
    if (pre >= 0 && pre < [self.stockArray count])
        self.preStockInfo = [self getStockInfoFromDic:[self.stockArray objectAtIndex:pre]];
    else
        self.preStockInfo = nil;
    if (next >= 0 && next < [self.stockArray count])
        self.nextStockInfo = [self getStockInfoFromDic:[self.stockArray objectAtIndex:next]];
    else
        self.nextStockInfo = nil;
}

- (tztStockInfo *)getStockInfoFromDic:(id)dic
{
    if (dic && [dic isKindOfClass:[tztStockInfo class]])
        return dic;
    tztStockInfo *stockInfo = [[[tztStockInfo alloc] init] autorelease];
    NSString* nsCode = @"";
    NSString* nsName = @"";
    id strCode = [dic objectForKey:@"Code"];
    if ([strCode isKindOfClass:[NSDictionary class]])
        nsCode = [strCode objectForKey:@"value"];
    else if ([strCode isKindOfClass:[NSString class]])
        nsCode = strCode;
    stockInfo.stockCode = nsCode;
    
    id vName = [dic objectForKey:@"Name"];
    if ([vName isKindOfClass:[NSDictionary class]])
        nsName = [vName objectForKey:@"value"];
    else if ([vName isKindOfClass:[NSString class]])
        nsName = vName;
    stockInfo.stockName = nsName;
    
    stockInfo.stockType = [[dic objectForKey:@"StockType"] intValue];
    
    return stockInfo;
}

-(void)OnBottomOperateButtonClick:(id)sender
{
    UIButton *pBtn = (UIButton*)sender;
    if (pBtn == NULL)
        return;
    switch (pBtn.tag)
    {
        case TZT_MENU_AddUserStock:
        {
            if ([tztUserStock IndexUserStock:_pStockInfo] < 0)
            {
                [tztUserStock AddUserStock:self.pStockInfo];
                UIImageView *imageView = (UIImageView*)[pBtn viewWithTag:0x9999];
                [imageView setImage:[UIImage imageTztNamed:@"tztQuickDel.png"]];
            }
            else
            {
                [tztUserStock DelUserStock:self.pStockInfo];
                UIImageView *imageView = (UIImageView*)[pBtn viewWithTag:0x9999];
                [imageView setImage:[UIImage imageTztNamed:@"tztQuickAdd.png"]];
            }
        }
            break;
        case MENU_JY_PT_Buy://买入
        case MENU_JY_PT_Sell://卖出
        case MENU_SYS_UserWarning://预警
        {
            [TZTUIBaseVCMsg OnMsg:pBtn.tag wParam:(NSUInteger)self.pStockInfo lParam:0];
        }
            break;
        default:
        {
            [TZTUIBaseVCMsg OnMsg:pBtn.tag wParam:0 lParam:0];
        }
            break;
    }
}

- (NSInteger)getIndexOfStockInfo
{
    for (NSInteger i = 0; i < self.stockArray.count; i++) {
        id dic = [self.stockArray objectAtIndex:i];
        if (dic)
        {
            if ([dic isKindOfClass:[NSDictionary class]])
            {
                NSString* strCode = @"";
                id value = [dic objectForKey:@"Code"];
                if ([value isKindOfClass:[NSDictionary class]])
                    strCode = [value objectForKey:@"value"];
                else if ([value isKindOfClass:[NSString class]])
                    strCode = value;
                int nStockType = [[dic objectForKey:@"StockType"] intValue];
                if ([strCode caseInsensitiveCompare:self.pStockInfo.stockCode] == NSOrderedSame &&
                    nStockType == self.pStockInfo.stockType)
                    return i;
            }
            else if ([dic isKindOfClass:[tztStockInfo class]])
            {
                tztStockInfo *stock = (tztStockInfo*)dic;
                if ([stock.stockCode isEqualToString:self.pStockInfo.stockCode]
                    && stock.stockType == self.pStockInfo.stockType)
                    return i;
            }
        }
    }
    return -1;
}

-(void)ClearData
{
    [self.stockArray removeAllObjects];
    self.pStockInfo = nil;
    if (userTableView)
    {
        [userTableView ClearData];
    }
    if (userTableView2)
        [userTableView2 ClearData];
    if (userTableView3)
        [userTableView3 ClearData];
}

//显示
-(void)tztMutilPageViewDidAppear:(NSInteger)CurrentViewIndex
{
    NSArray *array = self.stockArray;
    if (array.count<=0)
        return;
    
    NSInteger i = [self getIndexOfStockInfo];
    if (i < 0)
        return;
//    
    if (pageIndex - CurrentViewIndex == -2 || pageIndex - CurrentViewIndex == 1) // Left
    {
        if (i==0)
            i = [array count] - 1;
        else
            i -- ;
    }
    else
    {
        if (i==[array count] - 1)
            i = 0;
        else
            i ++;
    }
    pageIndex = CurrentViewIndex;
    id dic = [array objectAtIndex:i];
    if (dic == NULL)
        return;
    if ([dic isKindOfClass:[NSDictionary class]])
    {
        tztStockInfo *sInfo = [[tztStockInfo alloc] init];
        NSString* nsCode = @"";
        NSString* nsName = @"";
        id strCode = [dic objectForKey:@"Code"];
        if ([strCode isKindOfClass:[NSDictionary class]])
            nsCode = [strCode objectForKey:@"value"];
        else if ([strCode isKindOfClass:[NSString class]])
            nsCode = strCode;
        sInfo.stockCode = nsCode;
        
        id vName = [dic objectForKey:@"Name"];
        if ([vName isKindOfClass:[NSDictionary class]])
            nsName = [vName objectForKey:@"value"];
        else if ([vName isKindOfClass:[NSString class]])
            nsName = vName;
        sInfo.stockName = nsName;
        
        sInfo.stockType = [[dic objectForKey:@"StockType"] intValue];
        [self setStockInfo:sInfo nRequest_:YES];
        [sInfo release];
    }
    else if ([dic isKindOfClass:[tztStockInfo class]])
    {
        [self setStockInfo:dic nRequest_:YES];
    }
    
    if (g_bUseHQAutoPush)
    {//代码变更，需要重新发起推送
        if (self.pStockInfo && self.pStockInfo.stockCode)
        {
            UIView* pCurrentView = [_pMutilViews.pageViews objectAtIndex:_pMutilViews.nCurPage];
            [[tztAutoPushObj getShareInstance] setAutoPushDataWithString:[NSString stringWithFormat:@"%@|%d", self.pStockInfo.stockCode, self.pStockInfo.stockType] andDelegate_:(tztHqBaseView*)pCurrentView];
        }
    }
}

- (void)requestAsPageIndex
{
    switch (pageIndex) {
        case 0:
        {
            if (self.pStockInfo && self.pStockInfo.stockCode)
            {
                [userTableView setStockInfo:self.pStockInfo Request:1];
                [userTableView onSetViewRequest:YES];
                [userTableView2 setStockInfo:self.nextStockInfo Request:0];
//                [userTableView2 onSetViewRequest:NO];
                [userTableView3 setStockInfo:self.preStockInfo Request:0];
//                [userTableView3 onSetViewRequest:NO];
                
            }
        }
            break;
        case 1:
        {
            if (self.pStockInfo && self.pStockInfo.stockCode)
            {
                [userTableView2 setStockInfo:self.pStockInfo Request:1];
                [userTableView2 onSetViewRequest:YES];
                [userTableView setStockInfo:self.preStockInfo Request:0];
//                [userTableView onSetViewRequest:NO];
                [userTableView3 setStockInfo:self.nextStockInfo Request:0];
//                [userTableView3 onSetViewRequest:NO];
            }
        }
            break;
        case 2:
        {
            if (self.pStockInfo && self.pStockInfo.stockCode)
            {
                [userTableView3 setStockInfo:self.pStockInfo Request:1];
                [userTableView3 onSetViewRequest:YES];
                [userTableView setStockInfo:self.nextStockInfo Request:0];
//                [userTableView onSetViewRequest:NO];
                [userTableView2 setStockInfo:self.preStockInfo Request:0];
//                [userTableView2 onSetViewRequest:NO];
            }
        }
            break;
            
        default:
            break;
    }
}

-(void)OnRequestNewData:(tztStockInfo*)pStock
{
    if (self.stockArray.count < 3)
        pageIndex = 0;
    else
        pageIndex = 1;
    _pMutilViews.nCurPage = pageIndex;
    [_pMutilViews setScrollEnabled:(self.stockArray.count > 1)];
    if (userTableView)
        [userTableView SetDefaultSelect];
    if (userTableView2)
        [userTableView2 SetDefaultSelect];
    if (userTableView3)
        [userTableView3 SetDefaultSelect];
    [self setStockInfo:pStock nRequest_:1];
}

-(void)setStockInfo:(tztStockInfo *)pStock nRequest_:(int)nRequest
{
    self.pStockInfo = pStock;
    marketType = pStock.stockType;
    [self getStockInfos];
    
    [self requestAsPageIndex];
    
}

- (void)UpdateData:(id)obj
{
    BOOL bNeedRefresh = FALSE;
    if (obj && [obj isKindOfClass:[tztHqBaseView class]])
    {
        tztStockInfo *stockInfo = ((tztHqBaseView*)obj).pStockInfo;
        if (stockInfo && stockInfo.stockCode.length > 0 && [self.pStockInfo.stockCode caseInsensitiveCompare:stockInfo.stockCode] == NSOrderedSame && (stockInfo.stockType != 0) && ((stockInfo.stockType != self.pStockInfo.stockType) || marketType == 0))
        {
            self.pStockInfo.stockType = stockInfo.stockType;
            marketType = stockInfo.stockType;
            bNeedRefresh = YES;
            if (self.stockArray.count == 1 && bNeedRefresh)
            {
                userTableView.pStockInfo = self.pStockInfo;
                //需要重发一次推送，前面市场类型不对，会导致主推失效
                if (g_bUseHQAutoPush)
                {
                    if (self.pStockInfo && self.pStockInfo.stockCode)
                    {
                        [[tztAutoPushObj getShareInstance] setAutoPushDataWithString:[NSString stringWithFormat:@"%@|%d", self.pStockInfo.stockCode, self.pStockInfo.stockType] andDelegate_:userTableView];
                    }
                }
                return;
            }
        }
    }
    switch (pageIndex) {
        case 0:
        {
            if (self.pStockInfo && self.pStockInfo.stockCode)
            {
                if (bNeedRefresh)
                    userTableView.pStockInfo = self.pStockInfo;
                
            }
        }
            break;
        case 1:
        {
            if (self.pStockInfo && self.pStockInfo.stockCode)
            {
                if (bNeedRefresh)
                    userTableView2.pStockInfo = self.pStockInfo;
            }
        }
            break;
        case 2:
        {
            if (self.pStockInfo && self.pStockInfo.stockCode)
            {
                if (bNeedRefresh)
                    userTableView3.pStockInfo = self.pStockInfo;
            }
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - Gesture

//- (void)addGestureOnTable
//{
//    UISwipeGestureRecognizer* recognizer;
//    // handleSwipeFrom 是偵測到手势，所要呼叫的方法
//    recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
//    
//    recognizer.direction = UISwipeGestureRecognizerDirectionLeft;
//    [_userTableView addGestureRecognizer:recognizer];
//    [recognizer release];
//}

- (void)handleSwipeFrom:(UISwipeGestureRecognizer*)recognizer {
    // 触发手勢事件后，在这里作些事情
    
    
    // 底下是刪除手势的方法
    //    [_pTableView removeGestureRecognizer:recognizer];
}

-(void)tztDetailHeader:(id)sender OnTapClicked:(BOOL)bExpand
{
    UIView *pView = (UIView*)sender;
    [_tztBaseView bringSubviewToFront:pView];
}

-(void)tztHqView:(id)hqView setTitleStatus:(NSInteger)nStatus andStockType_:(NSInteger)nType
{
    if (self.tztTitleView)
    {
        [self.tztTitleView setStockDetailInfo:nType nStatus:nStatus];
        self.tztTitleView.backgroundColor = [UIColor tztThemeBackgroundColorTitle];
    }
}
@end
