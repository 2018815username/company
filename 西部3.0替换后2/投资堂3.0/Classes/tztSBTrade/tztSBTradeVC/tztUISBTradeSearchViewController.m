/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:		tztUISBTradeSearchViewController
 * 文件标识:
 * 摘要说明:		股转系统查询界面
 *
 * 当前版本:	2.0
 * 作    者:	zhangxl
 * 更新日期:
 * 整理修改:
 *
 ***************************************************************/

#import "tztUISBTradeSearchViewController.h"

@implementation tztUISBTradeSearchViewController
@synthesize pTitleView = _pTitleView;
@synthesize pView = _pView;
@synthesize nsStock = _nsStock;
@synthesize nsType = _nsType;

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
            case WT_QUERYSBHQ:
            case MENU_JY_SB_HQ:
                strTitle = @"股转行情";
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
        _pView = [[tztSBTradeSearchView alloc] init];
        _pView.delegate = self;
        _pView.nMsgType = _nMsgType;
        _pView.frame = rcView;
        [_tztBaseView addSubview:_pView];
        [_pView release];
        
        if (_nsStock && [_nsStock length] > 0)
            _pView.nsStock = _nsStock;
        if (_nsType && [_nsType length]> 0)
            _pView.nsHQType = _nsType;
    }
    else
        _pView.frame = rcView;
    
    [_tztBaseView bringSubviewToFront:_pTitleView];
    [self CreateToolBar];
}
// xinlan 西部证券三板交易查询新增toolbar
-(void)westCreateToolBarEX
{
}

-(void)CreateToolBar
{
    NSMutableArray  *pAy = NewObject(NSMutableArray);
    [pAy addObject:@"详细|6808"];
    [pAy addObject:@"分时|3300"];
    [pAy addObject:@"刷新|6802"];
#ifdef XBZQ_3
    if ([_nsType isEqual:@"OB"])
     {
        [pAy addObject:@"成交确认卖出|13013"];
    }
    else if([_nsType isEqual:@"OS"])
    {
        [pAy addObject:@"成交确认买入|13012"];
    }
    
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
