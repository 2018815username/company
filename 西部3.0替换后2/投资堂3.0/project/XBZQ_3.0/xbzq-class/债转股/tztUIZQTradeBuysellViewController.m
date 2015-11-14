/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:		tztZQTradeBuySellView
 * 文件标识:
 * 摘要说明:		债转股,债券回售VC
 *
 * 当前版本:      2.0
 * 作    者:     xyt
 * 更新日期:
 * 整理修改:
 *
 ***************************************************************/
#import "tztUIZQTradeBuysellViewController.h"

@implementation tztUIZQTradeBuysellViewController
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
            case MENU_JY_PT_ZhaiZhuanGu://债转股
                strTitle = @"债转股";
                break;
            case MENU_JY_PT_ZhaiQuanHuiShou://债券回售
                strTitle = @"债券回售";
                break;
            
            default: strTitle =@"股转回售";
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
        _pView = [[tztZQTradeBuySellView alloc] init];
        _pView.tztStockDelegate = self;
        _pView.nMsgType = _nMsgType;
        _pView.bBuyFlag = _bBuyFlag;
        _pView.frame = rcView;
        if (self.CurStockCode && [self.CurStockCode length] > 0) // 赋值self.CurStockCode byDBQ20130729
        {
            [_pView setStockCode:self.CurStockCode];
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
        //pStock.stockCode = [NSString stringWithString:self.pView.CurStockCode];
        switch (_nMsgType)
        {
            case MENU_JY_PT_ZhaiZhuanGu:
                [TZTUIBaseVCMsg OnMsg:MENU_JY_PT_ZhaiQuanHuiShou wParam:(NSUInteger)pStock lParam:0];
                break;
            case MENU_JY_PT_ZhaiQuanHuiShou:
                [TZTUIBaseVCMsg OnMsg:MENU_JY_PT_ZhaiZhuanGu wParam:(NSUInteger)pStock lParam:0];
                break;
            default:
                break;
        }
        [pStock release];
        return;
    }else if(pBtn.tag == TZTToolbar_Fuction_WithDraw)
    {
        [TZTUIBaseVCMsg OnMsg:WT_WITHDRAW wParam:0 lParam:0];
        return;
    }
    
    if (!bDeal)
        [super OnToolbarMenuClick: sender];
}
@end
