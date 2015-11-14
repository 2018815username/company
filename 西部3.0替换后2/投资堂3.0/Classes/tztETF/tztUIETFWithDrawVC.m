/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:        ETF撤单vc
 * 文件标识:        
 * 摘要说明:        
 * 
 * 当前版本:        2.0
 * 作    者:       xyt
 * 更新日期:            
 * 整理修改:	
 *
 ***************************************************************/
#import "tztUIETFWithDrawVC.h"

@implementation tztUIETFWithDrawVC
@synthesize pTitleView = _pTitleView;
@synthesize pETFWithDraw = _pETFWithDraw;

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
            case WT_ETFXJRGCD:
                strTitle = @"网下现金认购撤单";
                break;
            case WT_ETFGPRGCD:
                strTitle = @"网下股票认购撤单";
                break;
            case WT_ETF_HS_XJCD:
                strTitle = @"沪市现金撤单";
                break;
            case WT_ETF_HS_GPCD:
            case MENU_JY_ETFKS_HSStockWithdraw: //14075  沪市股票撤单
                strTitle = @"沪市股票撤单";
                break;
            case WT_ETF_SS_RGCD:
            case MENU_JY_ETFKS_SSRGWithdraw: // 14076  深市认购撤单
                strTitle = @"深市认购撤单";
                break;
            default:
                break;
        }
    }
    self.nsTitle = [NSString stringWithFormat:@"%@", strTitle];
    [self onSetTztTitleView:self.nsTitle type:TZTTitleReport];
    
    CGRect rcBuySell = rcFrame;
    rcBuySell.origin.y += _tztTitleView.frame.size.height;
    //rcBuySell.size.height -= (_tztTitleView.frame.size.height + TZTToolBarHeight);
    //修改了不需要底部工具条Frame 高度修改
    if (!g_pSystermConfig.bShowbottomTool)
        rcBuySell.size.height -= _tztTitleView.frame.size.height;
    else
        rcBuySell.size.height -= (_tztTitleView.frame.size.height + TZTToolBarHeight);
    if (_pETFWithDraw == nil)
    {
        _pETFWithDraw = [[tztETFWithDraw alloc] init];
        _pETFWithDraw.nMsgType = _nMsgType;
        _pETFWithDraw.delegate = self;
        _pETFWithDraw.frame = rcBuySell;
        [_tztBaseView addSubview:_pETFWithDraw];
        [_pETFWithDraw release];
    }
    else
    {
        _pETFWithDraw.frame = rcBuySell;
    }
    
    if (g_pSystermConfig && g_pSystermConfig.bNSearchFuncJY)
        self.tztTitleView.fourthBtn.hidden = YES;
    [_tztBaseView bringSubviewToFront:_tztTitleView];
    [self CreateToolBar];
}

-(void)CreateToolBar
{
    NSMutableArray  *pAy = NewObject(NSMutableArray);
    [pAy addObject:@"确定|6801"];
    [pAy addObject:@"刷新|6802"];
    [pAy addObject:@"清空|6803"];
    [pAy addObject:@"取消|3599"];
 
#ifdef tzt_NewVersion
    //修改ETF撤单按钮,新版本按钮在配置文件中配置 modify by xyt 20131107
    //    [tztUIBarButtonItem getTradeBottomItemByArray:pAy target:self withSEL:@selector(OnToolbarMenuClick:) forView:_tztBaseView];
#else
    [super CreateToolBar];
    //加载默认
    [tztUIBarButtonItem GetToolBarItemByArray:pAy delegate_:self forToolbar_:toolBar];
#endif
	DelObject(pAy);
}

-(void)OnToolbarMenuClick:(id)sender
{
    BOOL bDeal = FALSE;
    if (_pETFWithDraw)
    {
        bDeal = [_pETFWithDraw OnToolbarMenuClick:sender];
    }
    
    if (!bDeal)
        [super OnToolbarMenuClick: sender];
}

@end
