/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:        委托撤单
 * 文件标识:        
 * 摘要说明:        
 * 
 * 当前版本:        2.0
 * 作    者:       yinjp
 * 更新日期:            
 * 整理修改:	
 *
 ***************************************************************/

#import "tztUITradeWithDrawViewController.h"

@implementation tztUITradeWithDrawViewController
@synthesize pWithDrawView = _pWithDrawView;

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
    if (_pWithDrawView)
        [_pWithDrawView OnRequestData];
}

- (void)viewDidUnload
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
    NSString *strTitle = GetTitleByID(_nMsgType);
    if (!ISNSStringValid(strTitle))
    {
        switch (_nMsgType)
        {
            case WT_QUERYDRWT:
            case MENU_JY_PT_QueryDraw:
                strTitle = @"当日委托";
                break;
            case WT_WITHDRAW://委托撤单
            case MENU_JY_PT_Withdraw:
                strTitle = @"委托撤单";
                break;
            default:
                break;
        }
    }
    self.nsTitle = [NSString stringWithFormat:@"%@", strTitle];
    [self onSetTztTitleView:self.nsTitle type:TZTTitleReport];
       
    CGRect rcSearch = rcFrame;
    rcSearch.origin.y += _tztTitleView.frame.size.height;
    rcSearch.size.height -= (_tztTitleView.frame.size.height + TZTToolBarHeight);
    if (_pWithDrawView == nil)
    {
        _pWithDrawView = [[tztTradeWithDrawView alloc] init];
        _pWithDrawView.delegate = self;
        [_tztBaseView addSubview:_pWithDrawView];
        [_pWithDrawView release];
    }
    _pWithDrawView.nMsgType = _nMsgType;
    _pWithDrawView.frame = rcSearch;
    [self CreateToolBar];
    if (g_pSystermConfig && g_pSystermConfig.bNSearchFuncJY)
        self.tztTitleView.fourthBtn.hidden = YES;
}

-(void)CreateToolBar
{
#ifdef tzt_NewVersion // 新版本去toolbar byDBQ20130716
#else
    [super CreateToolBar];
#endif
    
    NSMutableArray *pAy = NewObject(NSMutableArray);
    [pAy addObject:@"详细|6808"];
    [pAy addObject:@"刷新|6802"];
    [pAy addObject:@"撤单|6807"];
#ifdef tzt_NewVersion // 新版本改变样式 byDBQ20130716
    [tztUIBarButtonItem getTradeBottomItemByArray:pAy target:self withSEL:@selector(OnToolbarMenuClick:) forView:_tztBaseView];
#else
    [tztUIBarButtonItem GetToolBarItemByArray:pAy delegate_:self forToolbar_:toolBar];
#endif
    DelObject(pAy);
}
//基金撤单 以及委托撤单下面的详细，刷新，撤单; 点击
-(void)OnToolbarMenuClick:(id)sender
{
    BOOL bDeal = FALSE;
    if (_pWithDrawView)
    {
        bDeal = [_pWithDrawView OnToolbarMenuClick:sender];
    }
    
    UIButton *pBtn = (UIButton*)sender;
    
    if (!bDeal || pBtn.tag == TZTToolbar_Fuction_WithDraw)
        [super OnToolbarMenuClick:sender];
}

-(void)OnBtnNextStock:(id)sender
{
    if (_pWithDrawView)
        [_pWithDrawView OnGridNextStock:_pWithDrawView.pGridView ayTitle_:_pWithDrawView.ayTitle];
}

-(void)OnBtnPreStock:(id)sender
{
    if (_pWithDrawView)
        [_pWithDrawView OnGridPreStock:_pWithDrawView.pGridView ayTitle_:_pWithDrawView.ayTitle];
}

@end
