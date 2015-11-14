/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:        融资融券直接还款vc
 * 文件标识:        
 * 摘要说明:        
 * 
 * 当前版本:        2.0
 * 作    者:       xyt
 * 更新日期:            
 * 整理修改:	
 *
 ***************************************************************/
#import "tztUIRZRQFundReturnViewController.h"
#ifdef kSUPPORT_XBSC
#import "RZRQMacro.h"
#endif
@implementation tztUIRZRQFundReturnViewController
@synthesize pFundReturn = _pFundReturn;
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
-(void)viewDidLoad
{
    [super viewDidLoad];
    [self LoadLayoutView];
    if (_pFundReturn)
        [_pFundReturn OnRequestData];
}

-(void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)LoadLayoutView
{
    CGRect rcFrame = _tztBounds;
    //标题view
    NSString *strTitle = GetTitleByID(_nMsgType);
#ifdef kSUPPORT_XBSC
    if (_nMsgType==kRZRQ_ZDHYHK) {
        strTitle = @"指定合约还款";
    }
#endif

    if (!ISNSStringValid(strTitle))
    {
        strTitle = @"直接还款";
    }
    self.nsTitle = [NSString stringWithFormat:@"%@", strTitle];
    [self onSetTztTitleView:self.nsTitle type:TZTTitleReport];
    
    CGRect rcSearch = rcFrame;
    rcSearch.origin.y += _tztTitleView.frame.size.height;
    if (!g_pSystermConfig.bShowbottomTool)
    {
        rcSearch.size.height -= _tztTitleView.frame.size.height;
    }else
    {
        rcSearch.size.height -= (_tztTitleView.frame.size.height + TZTToolBarHeight);
    }
    if (_pFundReturn == nil)
    {
        _pFundReturn = [[tztRZRQFundReturn alloc] init];
        _pFundReturn.delegate = self;
        _pFundReturn.nMsgType = _nMsgType;
        _pFundReturn.frame = rcSearch;
       
        //设置股票代码
        [_pFundReturn setStockCode:self.CurStockCode];
#ifdef kSUPPORT_XBSC
        //设置股票名称
        [_pFundReturn setStockName:self.CurStockName];

        //xinlan
        //设置合约编号
        
        [_pFundReturn setCurContractNumber:self.contractNumber];
        //设置到期日期
         [_pFundReturn setbackDate:self.backDate];
        if([self.debitType isEqualToString:@"融资负债"])
        {
            //负债金额
            [_pFundReturn setdebitBalance:self.debitBalance];
            //费用负债
            [_pFundReturn setFareDebit:@"0"];
        }
        else if ([self.debitType isEqualToString:@"费用负债"])
        {
            //负债金额
            [_pFundReturn setdebitBalance:@"0"];
            //费用负债
            [_pFundReturn setFareDebit:self.debitBalance];
        }
        
        //设置预计利息
         [_pFundReturn setdebitInterest:self.debitInterest];
        //设置需还款数量 (需还款金额 )
         [_pFundReturn setCurRepaymentAmount:self.repaymentAmount];
#endif
        
        [_tztBaseView addSubview:_pFundReturn];
        [_pFundReturn release];
    }
    else
    {
        _pFundReturn.frame = rcSearch;
    }
    
    if (g_pSystermConfig && g_pSystermConfig.bNSearchFuncJY)
        self.tztTitleView.fourthBtn.hidden = YES;
    [_tztBaseView bringSubviewToFront:_tztTitleView];
    [self CreateToolBar];
}

-(void)CreateToolBar
{
    if (!g_pSystermConfig.bShowbottomTool)
        return;
    
    [super CreateToolBar];
    
    NSMutableArray *pAy = NewObject(NSMutableArray);
    [pAy addObject:@"确定|6801"];
    [pAy addObject:@"刷新|6802"];
    [pAy addObject:@"返回|3599"];
    [tztUIBarButtonItem GetToolBarItemByArray:pAy delegate_:self forToolbar_:toolBar];
    DelObject(pAy);
}

-(void)OnToolbarMenuClick:(id)sender
{
    BOOL bDeal = FALSE;
    if (_pFundReturn)
    {
        bDeal = [_pFundReturn OnToolbarMenuClick:sender];
    }
    
    if (!bDeal)
        [super OnToolbarMenuClick:sender];
}

@end
