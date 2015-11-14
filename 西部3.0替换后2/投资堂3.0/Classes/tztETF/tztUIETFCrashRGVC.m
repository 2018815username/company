/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:        ETF现金认购vc
 * 文件标识:        
 * 摘要说明:        
 * 
 * 当前版本:        2.0
 * 作    者:       xyt
 * 更新日期:            
 * 整理修改:	
 *
 ***************************************************************/

#import "tztUIETFCrashRGVC.h"

@implementation tztUIETFCrashRGVC
@synthesize pTitleView = _pTitleView;
@synthesize pCrashView = _pCrashView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) 
    {
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self LoadLayoutView];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)dealloc
{
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if (IS_TZTIPAD)
    {
        return YES;
    }
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)LoadLayoutView
{
    CGRect rcFrame = _tztBounds;
    //标题view
    NSString *strTitle = GetTitleByID(_nMsgType);
    if (!ISNSStringValid(strTitle))
    {
        switch (_nMsgType)
        {
            case WT_ETFCrashRG:
            case MENU_JY_ETFWX_FundBuy: //14010  现金认购
                strTitle = @"网下现金认购";
                break;
            case WT_ETF_HS_CrashRG:
            case MENU_JY_ETFKS_HSFundBuy: //14071  沪市现金认购
                strTitle = @"沪市现金认购";
                break;
            default:
                break;
        }
    }
    self.nsTitle = [NSString stringWithFormat:@"%@", strTitle];
    [self onSetTztTitleView:self.nsTitle type:TZTTitleReport];
    
    CGRect rcBuySell = rcFrame;
    rcBuySell.origin.y += _tztTitleView.frame.size.height;
#ifdef tzt_NewVersion
    rcBuySell.size.height -= _tztTitleView.frame.size.height;
#else
    rcBuySell.size.height -= (_tztTitleView.frame.size.height + TZTToolBarHeight);
#endif
    if (_pCrashView == nil)
    {
        _pCrashView = [[tztETFCrashRGView alloc] init];
        _pCrashView.delegate = self;
        _pCrashView.nMsgType = _nMsgType;
        _pCrashView.frame = rcBuySell;
        [_tztBaseView addSubview:_pCrashView];
        [_pCrashView release];
    }
    else
    {
        _pCrashView.frame = rcBuySell;
    }
    
    [_tztBaseView bringSubviewToFront:_tztTitleView];
    
    if (g_pSystermConfig && g_pSystermConfig.bNSearchFuncJY)
        self.tztTitleView.fourthBtn.hidden = YES;
    [self CreateToolBar];
}

-(void)CreateToolBar
{
    if (!g_pSystermConfig.bShowbottomTool)
        return;
#ifndef tzt_NewVersion
    [super CreateToolBar];
    
    NSMutableArray  *pAy = NewObject(NSMutableArray);
    [pAy addObject:@"确定|6801"];
    [pAy addObject:@"刷新|6802"];
    [pAy addObject:@"清空|6803"];
    [pAy addObject:@"取消|3599"];
    
    //加载默认
    [tztUIBarButtonItem GetToolBarItemByArray:pAy delegate_:self forToolbar_:toolBar];
	DelObject(pAy);
#endif
}

-(void)OnToolbarMenuClick:(id)sender
{
    BOOL bDeal = FALSE;
    if (_pCrashView)
    {
        bDeal = [_pCrashView OnToolbarMenuClick:sender];
    }
    
    if (!bDeal)
        [super OnToolbarMenuClick: sender];
}

@end
