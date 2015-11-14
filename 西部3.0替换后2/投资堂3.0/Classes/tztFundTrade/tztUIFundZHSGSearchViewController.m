/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:        
 * 文件标识:
 * 摘要说明:
 *
 * 当前版本:        2.0
 * 作    者:       yinjp
 * 更新日期:
 * 整理修改:
 *
 ***************************************************************/

#import "tztUIFundZHSGSearchViewController.h"


@implementation tztUIFundZHSGSearchViewController
@synthesize pSearchView = _pSearchView;
@synthesize ayFundCode = _ayFundCode;
@synthesize nOpenAccountFlag = _nOpenAccountFlag;
@synthesize pView = _pView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self LoadLayoutView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)setDefaultData:(NSMutableArray *)pAy
{
}

-(void)LoadLayoutView
{
    CGRect rcFrame = _tztBounds;
    //标题view
    NSString* strTitle = GetTitleByID(_nMsgType);
    if (!ISNSStringValid(strTitle))
        strTitle = @"组合基金";
    self.nsTitle = [NSString stringWithFormat:@"%@", strTitle];
    [self onSetTztTitleView:self.nsTitle type:TZTTitleReport];
    
    CGRect rcView = rcFrame;
    rcView.origin.y += _tztTitleView.frame.size.height + 5;
    rcView.size.height = _tztTitleView.frame.size.height + 6;
    if (_pView == NULL)
    {
        _pView = [[tztUIVCBaseView alloc] initWithFrame:rcView];
        _pView.tztDelegate = self;
        [_pView setTableConfig:@"tztUITradeFundZHSH"];
        [_tztBaseView addSubview:_pView];
        [_pView release];
    }
    else
    {
        _pView.frame = rcView;
    }
    
    CGRect rcMain = rcFrame;
    rcMain.origin.y += _tztTitleView.frame.size.height + rcView.size.height;
    rcMain.size.height -= (_tztTitleView.frame.size.height + rcView.size.height + TZTToolBarHeight);
    
    if (_pSearchView == NULL)
    {
        _pSearchView = [[tztUIFundZHSGSearchView alloc] init];
        _pSearchView.nMsgType = _nMsgType;
        _pSearchView.delegate = self;
        if (self.ayFundCode)
        {
            _pSearchView.ayFundCode = self.ayFundCode;
        }
        _pSearchView.frame = rcMain;
        [_tztBaseView addSubview:_pSearchView];
        [_pSearchView release];
    }
    else
    {
        _pSearchView.frame = rcMain;
    }
    
    NSString* strName = [(NSMutableDictionary *)self.ayFundCode tztObjectForKey:@"tztGroupName"];
    [_pView setEditorText:strName nsPlaceholder_:NULL withTag_:1000];
    
    [_tztBaseView bringSubviewToFront:_tztTitleView];
    [self CreateToolBar];
    
    [_pSearchView OnRequestData];
    if (g_pSystermConfig && g_pSystermConfig.bNSearchFuncJY)
        self.tztTitleView.fourthBtn.hidden = YES;
}

-(void)CreateToolBar
{
    NSMutableArray  *pAy = NewObject(NSMutableArray);
    
    switch (_nMsgType)
    {
        case WT_JJZHSGSearch:
        {
            [pAy addObject:@"详细|6808"];
            [pAy addObject:@"刷新|6802"];
        }
            break;
        case WT_JJZHSGCreate:
        {
            [pAy addObject:@"详细|6808"];
            [pAy addObject:@"刷新|6802"];
            if (_nOpenAccountFlag == 1)
            {
                [pAy addObject:@"下单|6801"];
            }
            else
            {
                [pAy addObject:@"开户|6801"];
            }
        }
        default:
            break;
    }
    
#ifdef tzt_NewVersion
    [tztUIBarButtonItem getTradeBottomItemByArray:pAy target:self
                                          withSEL:@selector(OnToolbarMenuClick:) forView:_tztBaseView];
#else
    [super CreateToolBar];
    [tztUIBarButtonItem GetToolBarItemByArray:pAy delegate_:self forToolbar_:toolBar];
#endif
    DelObject(pAy);
}

-(void)setOpenAccountFlag:(int)nFlag
{
    _nOpenAccountFlag = nFlag;
    [self CreateToolBar];
}



-(void)OnToolbarMenuClick:(id)sender
{
    BOOL bDeal = FALSE;
    if (_pSearchView)
    {
        bDeal = [_pSearchView OnToolbarMenuClick:sender];
    }
    switch (((UIButton*)sender).tag)
    {
        case TZTToolbar_Fuction_OK:
        {
            if (_nOpenAccountFlag == 1)//下单
            {
                //
                if (_pSearchView)
                    [_pSearchView OnZHSG];
            }
            else//开户
            {
                if (_pSearchView)
                [_pSearchView OnOpenAccount];
            }
        }
            break;
            
        default:
            break;
    }
    if (!bDeal)
        [super OnToolbarMenuClick:sender];
}

@end
