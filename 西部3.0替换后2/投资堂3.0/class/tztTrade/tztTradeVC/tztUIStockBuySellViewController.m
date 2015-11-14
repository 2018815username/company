/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:        
 * 文件标识:        
 * 摘要说明:        
 * 
 * 当前版本:        2.0
 * 作    者:       yinjp
 * 更新日期:            
 * 整理修改:	
 *
 ***************************************************************/

#import "tztUIStockBuySellViewController.h"
#import "tztMainViewController.h"

@implementation tztUIStockBuySellViewController
@synthesize pStockBuySell = _pStockBuySell;
@synthesize bBuyFlag = _bBuyFlag;
@synthesize CurStockCode = _CurStockCode;

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
    if (!IS_TZTIPAD)
    {
        [self LoadLayoutView];
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (IS_TZTIPAD)
        [self LoadLayoutView];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (_pStockBuySell && IS_TZTIPAD)
        [[tztMoblieStockComm getShareInstance] addObj:_pStockBuySell];
    [self OnRequestData];
}

-(void)OnRequestData
{
    if (self.CurStockCode == NULL || self.CurStockCode.length < 1)
    {
        if (_pStockBuySell)
        {
            [_pStockBuySell ClearData];
        }
    }
    else
    {
        if (_pStockBuySell)
        {
            [_pStockBuySell ClearData];
            if (_pStockBuySell.dictOption)
            {
                NSString* strAccount = [_pStockBuySell.dictOption tztObjectForKey:@"wtaccount"];
                NSString* strAccountType = [_pStockBuySell.dictOption tztObjectForKey:@"wtaccounttype"];
                [_pStockBuySell tztperformSelector:@"setWTAccount:andAccountType:" withObject:strAccount withObject:strAccountType];
            }
            [_pStockBuySell setStockCode:self.CurStockCode];
//            [_pStockBuySell OnRefresh];
        }
    }
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //避免弹出新界面时候,定时器还在刷新
    if (_pStockBuySell && IS_TZTIPAD)
        [[tztMoblieStockComm getShareInstance] removeObj:_pStockBuySell];
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

-(void)setBBuyFlag:(BOOL)bBuyFlag
{
    if (_bBuyFlag != bBuyFlag)
    {
        _bBuyFlag = bBuyFlag;
        _pStockBuySell = nil;
    }
}

-(void)LoadLayoutView
{
    CGRect rcFrame = _tztBounds;
    NSString *strTitle = GetTitleByID(_nMsgType);
    if (!ISNSStringValid(strTitle))
    {
        switch (_nMsgType)
        {
            case WT_BUY:
            case MENU_JY_PT_Buy:
                strTitle = @"委托买入";
                break;
            case WT_SALE:
            case MENU_JY_PT_Sell:
                strTitle = @"委托卖出";
                break;
            default:
                break;
        }
    }
    self.nsTitle = [NSString stringWithFormat:@"%@", strTitle];
    int nType = (IS_TZTIPAD ? TZTTitleNormal : TZTTitleReport);
    [self onSetTztTitleView:self.nsTitle type:nType];
    if (IS_TZTIPAD)
    {
        _tztTitleView.bHasCloseBtn = YES;
    }
    
    CGRect rcBuySell = rcFrame;
    rcBuySell.origin.y += _tztTitleView.frame.size.height;
    if (IS_TZTIPAD || !g_pSystermConfig.bShowbottomTool)
        rcBuySell.size.height -= _tztTitleView.frame.size.height;
    else
        rcBuySell.size.height -= (_tztTitleView.frame.size.height + TZTToolBarHeight);
    
    if (_pStockBuySell == nil)
    {
        _pStockBuySell = [[tztStockBuySellView alloc] init];
        _pStockBuySell.bBuyFlag = _bBuyFlag;
//        _pStockBuySell.delegate = self;
        _pStockBuySell.tztStockDelegate = self; // 指定委托 byDBQ20130718
        _pStockBuySell.nMsgType = _nMsgType;
        _pStockBuySell.frame = rcBuySell;
//        if (self.CurStockCode && [self.CurStockCode length] > 0)
//        {
//            [_pStockBuySell setStockCode:self.CurStockCode];
//            [_pStockBuySell OnRefresh];
//        }
        [_tztBaseView addSubview:_pStockBuySell];
        [_pStockBuySell release];
    }
    else
    {
        _pStockBuySell.frame = rcBuySell;
    }
    
    [_tztBaseView bringSubviewToFront:_tztTitleView];
    
    [self CreateToolBar];
    
    if (g_pSystermConfig && g_pSystermConfig.bNSearchFuncJY)
        self.tztTitleView.fourthBtn.hidden = YES;
}

-(void)CreateToolBar
{
#ifdef tzt_NewVersion // 新版委托买卖去toolbar byDBQ20130716
#else
    if (IS_TZTIPAD || !g_pSystermConfig.bShowbottomTool)
        return;
    [super CreateToolBar];
    //加载默认
	[tztUIBarButtonItem GetToolBarItemByKey:@"TZTToolTradeStockBuy" delegate_:self forToolbar_:toolBar];
#endif
}

-(void)OnToolbarMenuClick:(id)sender
{
    BOOL bDeal = FALSE;
    if (_pStockBuySell)
    {
        bDeal = [_pStockBuySell OnToolbarMenuClick:sender];
    }
    
    UIButton* pBtn = (UIButton*)sender;
    if (pBtn.tag == TZTToolbar_Fuction_Switch)
    {
        [self pushQHView];
        return;
    }
    
    if (!bDeal)
        [super OnToolbarMenuClick: sender];
}

- (void)pushQHView // 切换用的委托方法 byDBQ20130718
{
    NSString *stockCode = @"";
    //zxl 20130806 添加了空判断
    if (self.pStockBuySell.CurStockCode &&[self.pStockBuySell.CurStockCode length] > 0 )
    {
        stockCode = [NSString stringWithString:self.pStockBuySell.CurStockCode];
    }

    tztStockInfo *pStockInfo = NewObject(tztStockInfo);
    pStockInfo.stockCode = [NSString stringWithFormat:@"%@", stockCode];
    
    [TZTUIBaseVCMsg OnMsg:(_bBuyFlag ? WT_SALE : WT_BUY ) wParam:(NSUInteger)pStockInfo lParam:1];
    [pStockInfo release];
    return;
    
    //需要登录
    BOOL bPush = FALSE;
    tztUIStockBuySellViewController *pVC = (tztUIStockBuySellViewController *)gettztHaveViewContrller([tztUIStockBuySellViewController class], tztvckind_JY,[NSString stringWithFormat:@"%d",tztVcShowTypeSame],&bPush,FALSE);
    [pVC retain];
    pVC.CurStockCode = stockCode; // 带股票代码到切换页 byDBQ20130729
    pVC.bBuyFlag = !_bBuyFlag;
    pVC.nMsgType = (pVC.bBuyFlag ? WT_BUY : WT_SALE);
    if(bPush)
    {
        [g_navigationController pushViewController: pVC animated:UseAnimated];
    }
    else
    {
        [_tztTitleView setTitle:(pVC.bBuyFlag ? @"委托买入" : @"委托卖出")];
        [pVC OnRequestData];
    }
    [pVC release];
}

-(void)tztRefreshData
{
    if (_pStockBuySell && [_pStockBuySell respondsToSelector:@selector(tztRefreshData)])
    {
        [_pStockBuySell tztRefreshData];
    }
}

@end
