/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:        首页-左边按钮界面
 * 文件标识:        
 * 摘要说明:        
 * 
 * 当前版本:        2.0
 * 作    者:       zhangxl
 * 更新日期:            
 * 整理修改:	
 *
 ***************************************************************/

#import "tztUIHomePageLeftView.h"
#import "TZTUIReportViewController.h"
#import "tztWebViewController.h"

@implementation tztUIHomePageLeftView
#define BtnTag 1000
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    _pNSArray = NewObject(NSMutableArray);
    [_pNSArray addObject:@"我的自选"];
    [_pNSArray addObject:@"综合排名"];
    [_pNSArray addObject:@"委托交易"];
    [_pNSArray addObject:@"期货市场"];
    [_pNSArray addObject:@"追踪操盘手"];
    [_pNSArray addObject:@"新股申购"];
    [_pNSArray addObject:@"在线客服"];
    return self;
}
-(void)dealloc
{
    [super dealloc];
    DelObject(_pNSArray);
}
-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [self setBackgroundColor:[UIColor clearColor]];
    CGRect rcFrame = CGRectZero;
    rcFrame.size = frame.size;
    if (_pImageBG == NULL)
    {
        _pImageBG = [[UIImageView alloc] initWithImage:[UIImage imageTztNamed:@"TZTUIHomePageMenu.png"]];
        _pImageBG.frame = rcFrame;
        [self addSubview:_pImageBG];
        [_pImageBG release];
    }else
        _pImageBG.frame = rcFrame;
 
	rcFrame = CGRectMake(30, 150 , 150, 40);
	if (_pSearchBar == NULL)
	{
		_pSearchBar = [[UISearchBar alloc] initWithFrame:rcFrame];
		_pSearchBar.delegate = self;
		_pSearchBar.autocorrectionType = UITextAutocorrectionTypeNo;
		_pSearchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
		_pSearchBar.placeholder = @"股票代码";
		_pSearchBar.keyboardType =  UIKeyboardTypeNumberPad;
		[[_pSearchBar.subviews objectAtIndex:0]removeFromSuperview];
		[self addSubview:_pSearchBar];
        [_pSearchBar release];
	}
	else
		_pSearchBar.frame = rcFrame;
    
    rcFrame.size.width = 100;
    if ([_pNSArray count] > 0)
    {
        for (int i = 0;i < [_pNSArray count] ;i++ )
        {
            UIButton *button = (UIButton *)[self viewWithTag:BtnTag + i];
            rcFrame.origin.y += 50;
            if (button == NULL) 
            {
                button = [UIButton buttonWithType:UIButtonTypeCustom];	
                [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [button setTitle:[_pNSArray objectAtIndex:i] forState:UIControlStateNormal];
                [button addTarget:self action:@selector(OnButton:) forControlEvents:UIControlEventTouchUpInside];
                button.frame = rcFrame;
                button.tag = BtnTag + i;
                [self addSubview:button];
            }else
                button.frame = rcFrame; 
        }
    }
}

-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    [TZTUIBaseVCMsg OnMsg:HQ_MENU_SearchStock wParam:(NSUInteger)searchBar lParam:0];
    return NO;
}

-(void)SelectStock:(tztStockInfo *)pStock
{
    if (g_pToolBarView)
    {
        [g_pToolBarView OnDealToolBarAtIndex:1 options_:NULL];
    }
    if ([g_navigationController.topViewController isKindOfClass:[TZTUIReportViewController class]])
    {
        TZTUIReportViewController * pVC = (TZTUIReportViewController *)g_navigationController.topViewController;
        pVC.bFlag = NO;
        pVC.pStockInfo = pStock;
        [pVC.pStockDetailView SetStockCode:pStock];
        [pVC.tztTitleView setCurrentStockInfo:pStock.stockCode nsName_:pStock.stockName];
    }
}

-(void)OnButton:(id)sender
{
    UIButton * button = (UIButton *)sender;
    NSInteger tag = button.tag - BtnTag;
    switch (tag)
    {
        case 0://我的自选
        {
            [g_pToolBarView OnDealToolBarAtIndex:1 options_:NULL];
        }
            break;
        case 1://综合排名
        {
            [g_pToolBarView OnDealToolBarAtIndex:3 options_:NULL];
        }
            break;
        case 2://委托交易
        {
            [g_pToolBarView OnDealToolBarAtIndex:4 options_:NULL];
        }
            break;
        case 3://期货市场
        {
            NSDictionary * option = [[NSDictionary alloc] initWithObjectsAndKeys:@"701",@"MenuID", nil];
            [g_pToolBarView OnDealToolBarAtIndex:3 options_:option];
            [option release];
//            if ([g_navigationController.topViewController isKindOfClass:[TZTUIReportViewController class]])
//            {
//                TZTUIReportViewController * pVC = (TZTUIReportViewController *)g_navigationController.topViewController;
//                pVC.pStrMenID = @"701";
//            }
        }
            break;
        case 4://追踪操盘手
        {
            tztWebViewController *pVC = [[tztWebViewController alloc] init];
            [pVC setTitle:@"追踪操盘手"];
            pVC.nHasToolbar = FALSE;
            TZTUIBaseViewController* pBottomVC = (TZTUIBaseViewController*)g_navigationController.topViewController;
            if (!pBottomVC)
                pBottomVC = (TZTUIBaseViewController*)((tztMobileAppAppDelegate*)[UIApplication sharedApplication].delegate).rootTabBarController.CurrentVC; // 修复moreNavigationController时弹出框不能点击问题 byDBQ20130729
            CGRect rcFrom = pBottomVC.view.frame;
            rcFrom.origin = pBottomVC.view.center;
            rcFrom.size.width -= 200;
            [pBottomVC PopViewControllerWithoutArrow:pVC rect:rcFrom];
            [pVC setWebURL:@"http://taogu.tzt.cn/?filter=planList&op=new_free"];
            [pVC release];
        }
            break;
        case 5://新股申购
        {
            tztWebViewController *pVC = [[tztWebViewController alloc] init];
            [pVC setTitle:@"新股申购"];
            pVC.nHasToolbar = FALSE;
            TZTUIBaseViewController* pBottomVC = (TZTUIBaseViewController*)g_navigationController.topViewController;
            if (!pBottomVC)
                pBottomVC = (TZTUIBaseViewController*)((tztMobileAppAppDelegate*)[UIApplication sharedApplication].delegate).rootTabBarController.CurrentVC; // 修复moreNavigationController时弹出框不能点击问题 byDBQ20130729
            CGRect rcFrom = pBottomVC.view.frame;
            rcFrom.origin = pBottomVC.view.center;
            rcFrom.size.width -= 200;
            [pBottomVC PopViewControllerWithoutArrow:pVC rect:rcFrom];
            [pVC setWebURL:@"http://www.tzt.cn/shuju.php?catid=26"];
            [pVC release];
        }
            break;
        case 6://在线客服
        {
            //需要登陆
            [TZTUIBaseVCMsg OnMsg:HQ_MENU_Online wParam:0 lParam:0];
            /*
            tztWebViewController *pVC = [[tztWebViewController alloc] init];
            [pVC setTitle:@"在线客服"];
            TZTUIBaseViewController* pBottomVC = (TZTUIBaseViewController*)g_navigationController.topViewController;
            CGRect rcFrom = pBottomVC.view.frame;
            rcFrom.origin = pBottomVC.view.center;
            rcFrom.size.width -= 200;
            pVC.nWebType = tztWebOnline;
            NSString *strURL = [g_pSystermConfig.pDict objectForKey:@"tztOnline"];
            NSString* strUrla = [NSString stringWithFormat:strURL,[((tztMobileAppAppDelegate*)[UIApplication sharedApplication].delegate).httpServer port]];
            
            [pVC setLocalWebURL:strUrla];
            [pBottomVC PopViewControllerWithoutArrow:pVC rect:rcFrom];
            [pVC release];
             */
        }
            break;
        default:
            break;
    }
}
@end
