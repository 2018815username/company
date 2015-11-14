/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:        基金定投开户
 * 文件标识:
 * 摘要说明:
 *
 * 当前版本:        2.0
 * 作    者:       yinjp
 * 更新日期:
 * 整理修改:
 *
 ***************************************************************/

#import "TZTUIFundDTKHVC.h"

@implementation TZTUIFundDTKHVC
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
    CGRect rcFrame = _tztBounds;
    //标题view
    NSString* strTitle = GetTitleByID(_nMsgType);
    if (!ISNSStringValid(strTitle))
    {
        switch (_nMsgType)
        {
            case WT_JJDTModify:
                strTitle = @"基金定投修改";
                break;
            default:
                strTitle = @"基金定投开户";
                break;
        }
    }
    
    self.nsTitle = [NSString stringWithFormat:@"%@", strTitle];
    [self onSetTztTitleView:self.nsTitle type:TZTTitleReport];
    
    CGRect rcBuySell = rcFrame;
    rcBuySell.origin.y += _tztTitleView.frame.size.height;
    //zxl 20130718 修改了不需要底部工具条Frame 高度修改
    if (!g_pSystermConfig.bShowbottomTool)
    {
        rcBuySell.size.height -= _tztTitleView.frame.size.height ;
    }else
    {
        rcBuySell.size.height -= (_tztTitleView.frame.size.height + TZTToolBarHeight);
    }
    if (_pFundTradeDTKH == nil)
    {
        _pFundTradeDTKH = [[tztUIFundDTKHView alloc] init];
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
    
    
    [self CreateToolBar];
    [_tztBaseView bringSubviewToFront:_pFundTradeDTKH];
    [_tztBaseView bringSubviewToFront:_tztTitleView];
    if (g_pSystermConfig && g_pSystermConfig.bNSearchFuncJY)
        self.tztTitleView.fourthBtn.hidden = YES;
}

-(void)CreateToolBar
{
    //zxl 20130718 修改了不需要底部工具条直接返回
    if (!g_pSystermConfig.bShowbottomTool)
        return;
    [super CreateToolBar];
    //加载默认
	[tztUIBarButtonItem GetToolBarItemByKey:@"TZTToolTradeFundKH" delegate_:self forToolbar_:toolBar];
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
