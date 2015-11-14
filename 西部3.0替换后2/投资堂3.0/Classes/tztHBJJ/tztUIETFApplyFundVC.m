/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:        货币基金(ETF) 认购/申购/赎回 VC
 * 文件标识:        
 * 摘要说明:        
 * 
 * 当前版本:        2.0
 * 作    者:       xyt
 * 更新日期:            
 * 整理修改:	
 *
 ***************************************************************/
#import "tztUIETFApplyFundVC.h"

@implementation tztUIETFApplyFundVC
@synthesize pApplyFundView = _pApplyFundView;

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
        switch (_nMsgType) {
            case WT_ETFApplyFundRG://货币基金认购
            case MENU_JY_FUND_HBRenGou:
                strTitle = @"货币基金认购";// 12762
                break;
            case WT_ETFApplyFundSG://货币基金(ETF)申购641
            case MENU_JY_FUND_HBShenGou:
                strTitle = @"货币基金申购";
                break;
            case WT_ETFApplyFundSH://货币基金(ETF)赎回642
            case MENU_JY_FUND_HBShuHui://货币基金赎回
                strTitle = @"货币基金赎回";
                break;
            default:
                break;
        }
    }
    self.nsTitle = [NSString stringWithFormat:@"%@", strTitle];
    [self onSetTztTitleView:self.nsTitle type:TZTTitleReport];
    
    CGRect rcBuySell = rcFrame;
    rcBuySell.origin.y += _tztTitleView.frame.size.height;
    if (!g_pSystermConfig.bShowbottomTool)
        rcBuySell.size.height -= _tztTitleView.frame.size.height;
    else
        rcBuySell.size.height -= (_tztTitleView.frame.size.height + TZTToolBarHeight);
    if (_pApplyFundView == nil)
    {
        _pApplyFundView = [[tztETFApplyFundView alloc] init];
        _pApplyFundView.delegate = self;
        _pApplyFundView.nMsgType = _nMsgType;
        _pApplyFundView.frame = rcBuySell;
        [_pApplyFundView SetDefaultData];
        [_tztBaseView addSubview:_pApplyFundView];
        [_pApplyFundView release];
    }
    else
    {
        _pApplyFundView.frame = rcBuySell;
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
    NSMutableArray *pAy = NewObject(NSMutableArray);
    [pAy addObject:@"确定|6801"];
    [pAy addObject:@"刷新|6802"];
    [pAy addObject:@"清空|6803"];
    [pAy addObject:@"取消|3599"];
#ifdef tzt_NewVersion
    [tztUIBarButtonItem getTradeBottomItemByArray:pAy target:self withSEL:@selector(OnToolbarMenuClick:) forView:_tztBaseView];
#else
    [super CreateToolBar];
    [tztUIBarButtonItem GetToolBarItemByArray:pAy delegate_:self forToolbar_:toolBar];
#endif
    DelObject(pAy);
}


-(void)OnToolbarMenuClick:(id)sender
{
    BOOL bDeal = FALSE;
    if (_pApplyFundView)
    {
        bDeal = [_pApplyFundView OnToolbarMenuClick:sender];
    }
    
    if (!bDeal)
        [super OnToolbarMenuClick:sender];
}

@end
