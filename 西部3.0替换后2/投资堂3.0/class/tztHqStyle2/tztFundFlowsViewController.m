/*******************************************************************************
 * Copyright (c)2012, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称：    tztUIQuoteViewController
 * 文件标识：
 * 摘    要：   华泰新行情首页显示
 *
 * 当前版本：    1.0
 * 作    者：   yinjp
 * 完成日期：    2013-12-02
 *
 * 备    注：
 *
 * 修改记录：
 *
 *******************************************************************************/

#import <tztMobileBase/tztSystemFunction.h>
#import "tztUIReportViewController_iphone.h"
#import "TZTInitReportMarketMenu.h"
#import "tztMenuViewController_iphone.h"
#import "tztFundFlowsViewController.h"
//新版
#import "TZTUserStockTableView.h"
#import "TZTHSStockTableView.h"
#import "tztMarketMoreView.h"

@interface tztFundFlowsViewController ()<tztTagViewDelegate>
{
    int    _nShowed;
}
-(NSMutableDictionary*)GetMarketMenu;
@end

@implementation tztFundFlowsViewController
@synthesize nsFirstID = _nsFirstID;
@synthesize nsMenuID = _nsMenuID;
@synthesize pMarketView = _pMarketView;
@synthesize pSubMarketView = _pSubMarketView;
@synthesize pReportList = _pReportList;
@synthesize pMenuDict = _pMenuDict;
//@synthesize pMenuView = _pMenuView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    _tztBaseView.backgroundColor = [tztTechSetting getInstance].backgroundColor;
    if(self.nsMenuID)
        [self SetMenuID:self.nsMenuID];
    [self LoadLayoutView];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
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

-(void)LoadLayoutView
{
    CGRect rcFrame = _tztBounds;//self.view.bounds;
    
    if (CGRectIsEmpty(rcFrame) || CGRectIsNull(rcFrame))
        return;
    
    [self onSetTztTitleView:self.nsTitle type:TZTTitleReport];
    CGRect rcTitle = self.tztTitleView.frame;
    /*
     市场菜单区域
     */
    CGRect rcMarket = rcFrame;
    rcMarket.origin = CGPointZero;
    rcMarket.origin.y += rcTitle.size.height;
    rcMarket.size.height = 38;
    if (_pMarketView == nil)
    {
        _pMarketView = [[tztUINewMarketView alloc] init];
        _pMarketView.frame = rcMarket;
        _pMarketView.pDelegate = self;
        [_tztBaseView addSubview:_pMarketView];
        [_pMarketView release];
    }
    else
        _pMarketView.frame = rcMarket;
    
    CGRect rcSub = rcMarket;
    rcSub.origin.y += rcMarket.size.height /*+ 10*/;
    if (_pSubMarketView == nil)
    {
        _pSubMarketView = [[tztUINewMarketView alloc] init];
        _pSubMarketView.frame = rcSub;
        _pSubMarketView.clBackColor = [UIColor colorWithTztRGBStr:@"30,30,30"];
        _pSubMarketView.nsHightLightImage = @"tztSubMarket_On.png";
        _pSubMarketView.nsNormalImage = @"tztSubMarket.png";
        _pSubMarketView.pDelegate = self;
        [_tztBaseView addSubview:_pSubMarketView];
        [_pSubMarketView release];
    }
    else
        _pSubMarketView.frame = rcSub;
    
    CGRect rcList = rcFrame;
    rcList.origin.y += (rcSub.origin.y + rcSub.size.height);
    rcList.size.height -= (rcSub.origin.y + rcSub.size.height);
    if (_pReportList == NULL)
    {
        _pReportList = [[tztReportListView alloc] initWithFrame:rcList];
        _pReportList.tztdelegate = self;
        _pReportList.frame = rcList;
        [_tztBaseView addSubview:_pReportList];
        [_pReportList release];
    }
    else
    {
        _pReportList.frame = rcList;
    }
    
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
}

-(NSString*)GetnsMenuSelData
{
    NSMutableDictionary *pDict = [g_pReportMarket GetSubMenuById:self.pMenuDict nsID_:self.nsFirstID];
    
//    for (int i = 0; i < [self.pMenuDict count]; i++)
//    {
//        NSDictionary *pDict = [self.pMenuDict objectAtIndex:i];
//        if (pDict == NULL)
//            return;
        NSString* strMenuData = [pDict objectForKey:@"MenuData"];
        if (strMenuData == NULL || [strMenuData length] < 1)
            return nil;
        NSArray *pAy = [strMenuData componentsSeparatedByString:@"|"];
        if (pAy == NULL || [pAy count] < 3)
            return nil;
        NSString* strAction = [pAy objectAtIndex:0];
        NSString* strParam = [pAy objectAtIndex:3];
        NSString* str = [NSString stringWithFormat:@"%@#%@",strParam,strAction];
//        if ([nsData compare:str] == NSOrderedSame && [nsData length] == [str length])
//        {
//            nIndex = i;
//            break;
//        }
//    }
    return str;
}

-(void)tztUIMarket:(id)sender DidSelectMarket:(NSMutableDictionary *)pDict marketMenu:(NSDictionary *)pMenu
{
    if(sender == _pMarketView)
    {
        if (pDict == NULL || [pDict count] <= 0)
            return;
        NSString* strParam = [pDict tztObjectForKey:@"tztParam"];
        NSString* strMenuData = [pDict tztObjectForKey:@"tztMenuData"];
        NSArray *pAyParam = [strParam componentsSeparatedByString:@"#"];
        if (pAyParam == NULL || [pAyParam count] < 2)
            return;
        NSArray *pAyMenuData = [strMenuData componentsSeparatedByString:@"|"];
        if ([pAyMenuData count] < 2)
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
            if (pDictValue && [pDictValue count] > 0
                && [[pDictValue objectForKey:@"tradelist"] count] > 1 )
            {
                [_pSubMarketView SetMarketData:pDictValue];
                [_pSubMarketView OnDefaultMenu:0];
            }
            
            _pSubMarketView.frame = _pSubMarketView.frame;
            
            return;
        }
        /*判断处理结束*/
    }
    else if (sender == _pSubMarketView)
    {
        if (pDict == NULL || [pDict count] <= 0)
            return;
        NSString* strTitle = [pDict tztObjectForKey:@"tztTitle"];
        NSString* strParam = [pDict tztObjectForKey:@"tztParam"];
        NSString* strMenuData = [pDict tztObjectForKey:@"tztMenuData"];
        NSArray *pAyParam = [strParam componentsSeparatedByString:@"#"];
        if (pAyParam == NULL || [pAyParam count] < 2)
            return;
        NSArray *pAyMenuData = [strMenuData componentsSeparatedByString:@"|"];
        if ([pAyMenuData count] < 2)
            return;
        
        /*
         此处需要增加判断，下级是不是可以直接请求数据，还是要列表展示菜单
         */
        NSString* nsMenuID  = @"";
        NSString* nsParam   = @"";
        NSString* nsOrder   = @"";
        
        if ([pAyMenuData count] > 3)
            nsParam = [pAyMenuData objectAtIndex:3];
        
        if ([pAyMenuData count] > 4)
        {
            nsMenuID = [pAyMenuData objectAtIndex:0];
            nsOrder = [NSString stringWithFormat:@"%@",[pAyMenuData objectAtIndex:4]];
            
            int nOrder = [nsOrder intValue];
            int accountIndex = nOrder / 2;
            int nDirection = nOrder % 10;
            _pReportList.accountIndex = accountIndex;// [self.nsOrdered intValue];
            _pReportList.direction = nDirection;
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
        nsParam = [pAyParam objectAtIndex:0];
        if(nAction == 20610 || nAction == 20611 || nAction == 20612 || nAction == 20613)
        {
            nsParam = [NSString stringWithFormat:@"%@",[tztUserStock GetNSUserStock]];
            if(nsParam.length <= 0) //无自选股数据，从服务器下载请求
            {
                [[tztUserStock getShareClass] Download];
            }
        }
        
        if (_pSubMarketView)
        {
            NSString *nsdata =  [NSString stringWithFormat:@"%@#%@",strParam,nsMenuID];
            if (nAction == 20610 || nAction == 20611 || nAction == 20612 || nAction == 20613)
            {
                nsdata = [NSString stringWithFormat:@"#%d#%@", nAction, nsMenuID];
            }
            [_pSubMarketView setSelBtIndex:nsdata];
        }
        
        [_pReportList setCurrentIndex:-1];
        _pReportList.startindex = 1;//切换市场，回到第一条
        _pReportList.reqchange = INT16_MIN;
        
        [self setTitle:strTitle];
        NSString* strAction = [NSString stringWithFormat:@"%@", [pAyParam objectAtIndex:1]];
        NSString* strReqParam = [NSString stringWithFormat:@"%@", nsParam];

        
        _pReportList.reqAction = strAction;
        tztStockInfo *pStock = NewObjectAutoD(tztStockInfo);
        pStock.stockCode = [NSString stringWithFormat:@"%@", strReqParam];
        [_pReportList tztShowNewType];
        [_pReportList setStockInfo:pStock Request:1];
        
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

-(BOOL)RequestDefaultMenuData:(NSString*)nsID
{
    if (nsID == NULL)
        return FALSE;
    
    [self SetMenuID:nsID];
    //    self.nsMenuID = [NSString stringWithFormat:@"%@",nsID];
    
    if (self.pMenuDict)
    {
        NSMutableArray *pData = [self.pMenuDict objectForKey:@"tradelist"];
        if (pData == NULL || [pData count] <= 0)
            return FALSE;
     
        NSString* strTempData= @"";
        for (int i = 0; i < [pData count]; i++)
        {
            NSDictionary *pDict = [pData objectAtIndex:i];
            if (pDict == NULL)
                return FALSE;
            NSString* strMenuData = [pDict objectForKey:@"MenuData"];
            if (strMenuData == NULL || [strMenuData length] < 1)
                return FALSE;
            NSArray *pAy = [strMenuData componentsSeparatedByString:@"|"];
            if (pAy == NULL || [pAy count] < 3)
                return FALSE;
            
            NSString *strLast = [pAy lastObject];
            if (strLast && [strLast caseInsensitiveCompare:@"F"] == NSOrderedSame)
                continue;
            else
            {
                strTempData = [NSString stringWithFormat:@"%@", strMenuData];
                break;
            }
        }
        
        
        NSArray *pAy = [strTempData componentsSeparatedByString:@"|"];
        if (pAy == NULL || [pAy count] < 3)
            return FALSE;
//
//        
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
        int nAction = 0 ;
        if (nsParam && [nsParam length] > 0)
        {
            NSArray *ayParam = [nsParam componentsSeparatedByString:@"#"];
            if (ayParam && [ayParam count] > 1)
            {
                nAction = [[ayParam objectAtIndex:1] intValue];
                bSubMenu = (/*(nsID == NULL || [nsID length] <= 0)*/ (nAction <= 0));
            }
        }
        
        NSMutableDictionary *pDictValue = [[NSMutableDictionary alloc] init];
        //还是菜单
        if ([nsType caseInsensitiveCompare:@"s"] == NSOrderedSame
            || bSubMenu)
        {
            //判断此处的菜单是否有下级菜单
            if ([self IsHaveSubMenu:self.pMenuDict returnValue_:&pDictValue])
            {
                if (_pMarketView)
                {
                    [_pMarketView SetMarketData:self.pMenuDict];
//                    _pMenuView.hidden = NO;
//                    _pMenuView.frame = _pMenuView.frame;
//                    [_pMenuView setAyListInfo:[pDictValue objectForKey:@"tradelist"]];
//                    [_pMenuView reloadData];
                    
                    NSString *nsdata = [NSString stringWithFormat:@"%@#%@",nsParam,nsMenuID];
                    if (nAction == 20610 || nAction == 20611 || nAction == 20612 || nAction == 20613)
                    {
                        nsdata = [NSString stringWithFormat:@"#%d#%@", nAction,nsMenuID];
                    }
                    [_pMarketView setSelBtIndex:nsdata];
                }
//                [pDictValue release];
                return FALSE;
            }
        }
//        [pDictValue release];
        /*判断处理结束*/
    }
    return TRUE;
}

-(void)tzthqView:(id)hqView setStockCode:(tztStockInfo *)pStock
{
    if (hqView)
    {
        [TZTUIBaseVCMsg OnMsg:HQ_MENU_Trend wParam:(NSUInteger)pStock lParam:(NSUInteger)hqView];
    }
}
@end
