/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:		tztUIDFCGSearchViewController
 * 文件标识:
 * 摘要说明:		多方存管查询界面
 *
 * 当前版本:	2.0
 * 作    者:	zhangxl
 * 更新日期:
 * 整理修改:
 *
 ***************************************************************/
#import "tztUIDFCGSearchViewController.h"

@implementation tztUIDFCGSearchViewController
@synthesize pView = _pView;
@synthesize nsBeginDate = _nsBeginDate;
@synthesize nsEndDate =_nsEndDate;
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
    if (_pView)
        [_pView OnRequestData];
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
            case WT_GuiJiResult://资金归集
            case MENU_JY_DFBANK_Input://资金归集
                strTitle = @"资金归集";
                break;
            case WT_DFQUERYDRNZ://当日内转查询
                strTitle = @"当日内转";
                break;
            case WT_NeiZhuanResult://调拨流水
            case MENU_JY_DFBANK_QueryTransitHis://调拨流水
                strTitle = @"调拨流水";
                break;
            case WT_DFTRANSHISTORY://转账流水
            case MENU_JY_DFBANK_QueryBankHis://查询流水
                strTitle = @"转账流水";
                break;
            case WT_DFQUERYNZLS://历史内转查询
                strTitle = @"历史内转";
                break;
            case WT_DFQUERYHISTORYEx://计划查询流水
                strTitle = @"计划流水";
                break;
            default:
                break;
        }
    }
    self.nsTitle = [NSString stringWithFormat:@"%@", strTitle];
    [self onSetTztTitleView:self.nsTitle type:TZTTitleReport];
    
    CGRect rcView = rcFrame;
    rcView.origin.y += _tztTitleView.frame.size.height;
    rcView.size.height -= (_tztTitleView.frame.size.height + TZTToolBarHeight);
    if (_pView == NULL)
    {
        _pView = [[tztDFCGSearchView alloc] init];
        _pView.delegate = self;
        _pView.nMsgType = _nMsgType;
        if (_nsBeginDate && [_nsBeginDate length] > 0)
            _pView.nsBeginDate = _nsBeginDate;
        if (_nsEndDate && [_nsEndDate length] > 0)
            _pView.nsEndDate = _nsEndDate;
        _pView.frame = rcView;
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
    NSMutableArray  *pAy = NewObject(NSMutableArray);
    [pAy addObject:@"详细|6808"];
    [pAy addObject:@"刷新|6802"];
    if (_nMsgType == WT_GuiJiResult || _nMsgType == MENU_JY_DFBANK_Input)
        [pAy addObject:@"归集|6817"];
    
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
    if (_pView)
    {
        bDeal = [_pView OnToolbarMenuClick:sender];
    }
    if (!bDeal)
        [super OnToolbarMenuClick:sender];
}

-(void)OnBtnNextStock:(id)sender
{
    if (_pView)
        [_pView OnGridNextStock:_pView.pGridView ayTitle_:_pView.ayTitle];
}

-(void)OnBtnPreStock:(id)sender
{
    if (_pView)
        [_pView OnGridPreStock:_pView.pGridView ayTitle_:_pView.ayTitle];
}

@end
