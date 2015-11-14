/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:        货币基金(ETF)内部撤单VC
 * 文件标识:        
 * 摘要说明:        
 * 
 * 当前版本:        2.0
 * 作    者:       xyt
 * 更新日期:            
 * 整理修改:	
 *
 ***************************************************************/
#import "tztETFApplyWithDrawVC.h"

@implementation tztETFApplyWithDrawVC
@synthesize pApplyWithDraw = _pApplyWithDraw;

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
    if (_pApplyWithDraw) 
        [_pApplyWithDraw OnRequestData];
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
            case WT_ETFInquireEntrust://货币基金当日委托查询
            case MENU_JY_FUND_HBQueryDraw://货币基金当日委托
                strTitle = @"货币基金当日委托";
                break;
            case WT_ETFInquireHisEntrust:
                strTitle = @"货币基金历史委托";
                break;
            case MENU_JY_FUND_HBWithdraw://货币基金委托撤单
                strTitle = @"货币基金当日委托";
                break;
            default:
                break;
        }
    }
    self.nsTitle = [NSString stringWithFormat:@"%@", strTitle];
    [self onSetTztTitleView:self.nsTitle type:TZTTitleReport];
    
    CGRect rcBuySell = rcFrame;
    rcBuySell.origin.y += _tztTitleView.frame.size.height;
    rcBuySell.size.height -= (_tztTitleView.frame.size.height + TZTToolBarHeight);
    if (_pApplyWithDraw == nil)
    {
        _pApplyWithDraw = [[tztETFApplyWithDrawView alloc] init];
        _pApplyWithDraw.delegate = self;
        _pApplyWithDraw.nMsgType = _nMsgType;
        _pApplyWithDraw.frame = rcBuySell;
        [_tztBaseView addSubview:_pApplyWithDraw];
        [_pApplyWithDraw release];
    }
    else
    {
        _pApplyWithDraw.frame = rcBuySell;
    }
    
    
    [_tztBaseView bringSubviewToFront:_tztTitleView];
    if (g_pSystermConfig && g_pSystermConfig.bNSearchFuncJY)
        self.tztTitleView.fourthBtn.hidden = YES;
    
    [self CreateToolBar];
}

-(void)CreateToolBar
{
    NSMutableArray *pAy = NewObject(NSMutableArray);
    [pAy addObject:@"详细|6808"];
    [pAy addObject:@"刷新|6802"];
#ifdef IsZYSC
    if (_nMsgType == MENU_JY_FUND_HBWithdraw||_nMsgType == WT_ETFInquireEntrust){
        [pAy addObject:@"撤单|6807"];
    }
#else
    //货币基金当日委托测单
    if (_nMsgType == MENU_JY_FUND_HBWithdraw) {
        [pAy addObject:@"撤单|6807"];
    }
//    if (_nMsgType == MENU_JY_FUND_HBWithdraw)
//    {
//        [pAy addObject:@"撤单|6807"];
//    }
#endif
    
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
    if (_pApplyWithDraw)
    {
        bDeal = [_pApplyWithDraw OnToolbarMenuClick:sender];
    }
    
    if (!bDeal)
        [super OnToolbarMenuClick:sender];
}


@end
