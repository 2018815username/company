/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:		tztUISBTradeBuySellViewController
 * 文件标识:
 * 摘要说明:		股转系统买卖界面
 *
 * 当前版本:	2.0
 * 作    者:	zhangxl
 * 更新日期:
 * 整理修改:
 *
 ***************************************************************/

#import "tztUISBTradeBuySellViewController.h"

@implementation tztUISBTradeBuySellViewController
@synthesize pView = _pView;
@synthesize CurStockCode = _CurStockCode;
@synthesize bBuyFlag = _bBuyFlag;
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
    
    NSString *strTitle = GetTitleByID(_nMsgType);
    if (!ISNSStringValid(strTitle))
    {
        switch (_nMsgType)
        {
            case WT_SBYXBUY:
            case MENU_JY_SB_YXBuy:
                strTitle = @"限价买入";
                break;
            case WT_SBYXSALE:
            case MENU_JY_SB_YXSell:
                strTitle = @"限价卖出";
                break;
            case WT_SBQRBUY:
            case MENU_JY_SB_QRBuy:
                strTitle = @"确认买入";
                break;
            case WT_SBQRSALE:
            case MENU_JY_SB_QRSell:
                strTitle = @"确认卖出";
                break;
            case WT_SBDJBUY:
            case MENU_JY_SB_DJBuy:
                strTitle = @"定价买入";
                break;
            case WT_SBDJSALE:
            case MENU_JY_SB_DJSell:
                strTitle = @"定价卖出";
                break;
            case 13016:
                strTitle =@"互报成交确认买入";
                break;
            case 13017:
                strTitle =@"互报成交确认卖出";
                break;
            default:
                break;
        }
    }
    self.nsTitle = [NSString stringWithFormat:@"%@", strTitle];
    
    [self onSetTztTitleView:self.nsTitle type:TZTTitleReport];
    
    CGRect rcView = rcFrame;
    rcView.origin.y += _tztTitleView.frame.size.height;
    if (g_pSystermConfig.bShowbottomTool)
    {
        rcView.size.height -= (_tztTitleView.frame.size.height + TZTToolBarHeight);
    }
    else
    {
        rcView.size.height -= _tztTitleView.frame.size.height;
    }
    
    if (_pView == NULL)
    {
        _pView = [[tztSBTradeBuySellView alloc] init];
        _pView.tztStockDelegate = self;
        _pView.nMsgType = _nMsgType;
        _pView.bBuyFlag = _bBuyFlag;
        _pView.frame = rcView;
        if (self.CurStockCode && [self.CurStockCode length] > 0) // 赋值self.CurStockCode byDBQ20130729
        {
            [_pView setStockCode:self.CurStockCode];

            [_pView tztperformSelector:@"setAppointmentSerial:" withObject:self.CurAppointmentSerial];
            [_pView tztperformSelector:@"setTradeUnit:" withObject:self.CurtradeUnit];
            [_pView OnRefresh];
        }
        [_tztBaseView addSubview:_pView];
        [_pView release];
    }
    else
        _pView.frame = rcView;
     [_tztBaseView bringSubviewToFront:_tztTitleView];
    
    [self CreateToolBar];
}
-(void)CreateToolBar
{
    if (!g_pSystermConfig.bShowbottomTool)
        return;
    
    [super CreateToolBar];
    //加载默认
    NSMutableArray *pAy = NewObject(NSMutableArray);
    [pAy addObject:@"确定|6801"];
    [pAy addObject:@"刷新|6802"];
    [pAy addObject:@"清空|6803"];
    [pAy addObject:@"切换|6804"];
    [pAy addObject:@"撤单|6807"];
    [tztUIBarButtonItem GetToolBarItemByArray:pAy delegate_:self forToolbar_:toolBar];
    DelObject(pAy);
}

-(void)OnToolbarMenuClick:(id)sender
{
    BOOL bDeal = FALSE;
    if (_pView)
    {
        bDeal = [_pView OnToolbarMenuClick:sender];
    }
    
    UIButton* pBtn = (UIButton*)sender;
    if (pBtn.tag == TZTToolbar_Fuction_Switch)
    {
        tztStockInfo *pStock = NewObject(tztStockInfo); // 传股票信息
        //修改切换崩溃问题  modify by xyt 20131008
        if (self.pView.CurStockCode && [self.pView.CurStockCode length] > 0)
        {
            pStock.stockCode = [NSString stringWithString:self.pView.CurStockCode];
        }        
        switch (_nMsgType)
        {
            case WT_SBYXBUY:
            case MENU_JY_SB_YXBuy:
                [TZTUIBaseVCMsg OnMsg:WT_SBYXSALE wParam:(NSUInteger)pStock lParam:0];
                break;
            case WT_SBYXSALE:
            case MENU_JY_SB_YXSell:
                [TZTUIBaseVCMsg OnMsg:WT_SBYXBUY wParam:(NSUInteger)pStock lParam:0];
                break;
            case WT_SBQRBUY:
            case MENU_JY_SB_QRBuy:
                [TZTUIBaseVCMsg OnMsg:WT_SBQRSALE wParam:(NSUInteger)pStock lParam:0];
                break;
            case WT_SBQRSALE:
            case MENU_JY_SB_QRSell:
                [TZTUIBaseVCMsg OnMsg:WT_SBQRBUY wParam:(NSUInteger)pStock lParam:0];
                break;
            case WT_SBDJBUY:
            case MENU_JY_SB_DJBuy:
                [TZTUIBaseVCMsg OnMsg:WT_SBDJSALE wParam:(NSUInteger)pStock lParam:0];
                break;
            case WT_SBDJSALE:
            case MENU_JY_SB_DJSell:
                [TZTUIBaseVCMsg OnMsg:WT_SBDJBUY wParam:(NSUInteger)pStock lParam:0];
                break;
            default:
                break;
        }
        [pStock release];
        return;
    }else if(pBtn.tag == TZTToolbar_Fuction_WithDraw)
    {
        [TZTUIBaseVCMsg OnMsg:WT_SBWITHDRAW wParam:0 lParam:0];
        return;
    }
    
    if (!bDeal)
        [super OnToolbarMenuClick: sender];
}


- (void)pushQHView // 切换用的委托方法 byDBQ20130718
{
    NSString *stockCode = @"";
    if (self.pView.CurStockCode &&[self.pView.CurStockCode length] > 0)
    {
         stockCode = [NSString stringWithString:self.pView.CurStockCode];
    }
    
    
    //updat by ruyi 页面切换底部tabbar隐藏
    //需要登录
//    BOOL bPush = FALSE;
//    tztUISBTradeBuySellViewController *pVC = (tztUISBTradeBuySellViewController *)gettztHaveViewContrller([tztUISBTradeBuySellViewController class], tztvckind_JY,[NSString stringWithFormat:@"%d",tztVcShowTypeSame],&bPush,FALSE);
//    [pVC retain];
    [g_navigationController popViewControllerAnimated:NO];
    tztUISBTradeBuySellViewController *pVC = [[tztUISBTradeBuySellViewController alloc] init];
    pVC.CurStockCode = stockCode; // 带股票代码到切换页 byDBQ20130729
    pVC.bBuyFlag = !_bBuyFlag;
    int nType = 0;
    if (_bBuyFlag)
    {
        if (_nMsgType == WT_SBYXBUY || _nMsgType == MENU_JY_SB_YXBuy)
            nType = WT_SBYXSALE;
        if (_nMsgType == WT_SBDJBUY || _nMsgType == MENU_JY_SB_DJBuy)
            nType = WT_SBDJSALE;
        if (_nMsgType == WT_SBQRBUY || _nMsgType == MENU_JY_SB_QRBuy)
            nType = WT_SBQRSALE;
    }
    else
    {
        if (_nMsgType == WT_SBYXSALE || _nMsgType == MENU_JY_SB_YXSell)
            nType = WT_SBYXBUY;
        if (_nMsgType == WT_SBDJSALE || _nMsgType == MENU_JY_SB_DJSell)
            nType = WT_SBDJBUY;
        if (_nMsgType == WT_SBQRSALE || _nMsgType == MENU_JY_SB_QRSell)
            nType = WT_SBQRBUY;
    }
    pVC.nMsgType = nType;//(pVC.bBuyFlag ? WT_SBYXBUY : WT_SBYXSALE);

    [pVC SetHidesBottomBarWhenPushed:YES];
    [g_navigationController pushViewController: pVC animated:UseAnimated];
    [pVC release];
}
@end
