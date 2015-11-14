/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:        基金定投申请,修改,删除
 * 文件标识:
 * 摘要说明:
 *
 * 当前版本:        2.0
 * 作    者:       xyt
 * 更新日期:
 * 整理修改:
 *
 ***************************************************************/
#import "tztUIFundDTModifyVC.h"

@implementation tztUIFundDTModifyVC
@synthesize pFundTradeDTKH = _pFundTradeDTKH;
@synthesize CurStockCode = _CurStockCode;
@synthesize pDefaultDateDict = _pDefaultDataDict;

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

//-(void)setPDefaultDateDict:(NSMutableDictionary *)pDict
//{
//    if (_pDefaultDataDict == NULL)
//        _pDefaultDataDict = NewObject(NSMutableDictionary);
//    
//    if (pDict == NULL)
//        return;
//    
//    
//    [_pDefaultDataDict initWithDictionary:pDict copyItems:YES];
//}

-(void)LoadLayoutView
{
    CGRect rcFrame = _tztBounds;//self.view.bounds;
    //标题view
    NSString *strTitle = GetTitleByID(_nMsgType);
    if (!ISNSStringValid(strTitle))
    {
        switch (_nMsgType) {
            case WT_JJWWModify:
            case MENU_JY_FUND_DTChange:
                strTitle = @"基金定投修改";
                break;
            case WT_JJWWOpen:
            case MENU_JY_FUND_DTReq:
                strTitle = @"基金定投申请";
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
    rcBuySell.size.height -= (_tztTitleView.frame.size.height);
#else
    rcBuySell.size.height -= (_tztTitleView.frame.size.height + TZTToolBarHeight);
#endif
    if (_pFundTradeDTKH == nil)
    {
        _pFundTradeDTKH = [[tztFundDTModifyView alloc] init];
        _pFundTradeDTKH.delegate = self;
        _pFundTradeDTKH.nMsgType = _nMsgType;
        _pFundTradeDTKH.frame = rcBuySell;
        _pFundTradeDTKH.pDefaultDataDict = self.pDefaultDateDict;
        if (self.pDefaultDateDict)
        {
            _CurStockCode = [self.pDefaultDateDict tztObjectForKey:@"tztJJDM"];
        }
        if (_CurStockCode)
            _pFundTradeDTKH.CurStockCode = [NSString stringWithFormat:@"%@", _CurStockCode];
        [_pFundTradeDTKH SetDefaultData];
        [_tztBaseView addSubview:_pFundTradeDTKH];
        [_pFundTradeDTKH release];
    }
    else
    {
        _pFundTradeDTKH.frame = rcBuySell;
    }
    
    
    if (g_pSystermConfig && g_pSystermConfig.bNSearchFuncJY)
        self.tztTitleView.fourthBtn.hidden = YES;
    
    [_tztBaseView bringSubviewToFront:_tztTitleView];
    [self CreateToolBar];
}

-(void)CreateToolBar
{
#ifdef tzt_NewVersion
    return;
#else
    if (!g_pSystermConfig.bShowbottomTool)
        return;
    [super CreateToolBar];
    //加载默认
	[tztUIBarButtonItem GetToolBarItemByKey:@"TZTToolTradeFundKH" delegate_:self forToolbar_:toolBar];
#endif
}

-(void)OnToolbarMenuClick:(id)sender
{
    BOOL bDeal = FALSE;
    if (_pFundTradeDTKH)
    {
        bDeal = [_pFundTradeDTKH OnToolbarMenuClick:sender];
    }
    
    if (!bDeal)
        [super OnToolbarMenuClick: sender];
}
@end