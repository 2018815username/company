/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:		tztUITHBSearchViewController
 * 文件标识:
 * 摘要说明:		天汇宝查询界面
 *
 * 当前版本:	2.0
 * 作    者:	zhangxl
 * 更新日期:
 * 整理修改:
 *
 ***************************************************************/

#import "tztUITHBSearchViewController.h"


@implementation tztUITHBSearchViewController

@synthesize pTitleView = _pTitleView;
@synthesize pView = _pView;
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

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear: animated];
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
    self.nsTitle = GetTitleByID(_nMsgType);
    [self onSetTztTitleView:self.nsTitle type:TZTTitleReport];
    
    CGRect rcView = _tztBounds;
    rcView.origin = CGPointZero;
    rcView.origin.y += _tztTitleView.frame.size.height;
    rcView.size.height -= (_tztTitleView.frame.size.height);
    
    if (_pView == NULL)
    {
        _pView = [[tztTHBSearchView alloc] init];
        _pView.delegate = self;
        _pView.nMsgType = _nMsgType;
        _pView.frame = rcView;
        [_tztBaseView addSubview:_pView];
        [_pView release];
    }
    else
        _pView.frame = rcView;
}

-(void)CreateToolBar
{
    CGRect rc = CGRectMake(0.0, self.view.bounds.size.height - TZTToolBarHeight, self.view.bounds.size.width, TZTToolBarHeight);
    if (toolBar == nil)
	{
		toolBar = [[UIToolbar alloc]initWithFrame:rc];
		toolBar.barStyle = UIBarStyleBlackOpaque;
		[self.view addSubview:toolBar];
		[toolBar release];
	}
    else
    {
        toolBar.frame = rc;
    }
    NSMutableArray  *pAy = NewObject(NSMutableArray);
    switch (_nMsgType)
    {
        case WT_THB_YWSearch:
        case WT_THB_HYSearch:
        case WT_THB_ZYQSearch:
        {
            [pAy addObject:@"详细|6808"];
            [pAy addObject:@"刷新|6802"];
        }
            break;
        case WT_THB_NEWKHG:
        {
            [pAy addObject:@"刷新|6802"];
            [pAy addObject:@"新开|6801"];
        }
            break;
        case WT_THB_BZXZ:
        {
            [pAy addObject:@"刷新|6802"];
            [pAy addObject:@"不再续做|6801"];
        }
            break;
        case WT_THB_DLWT:
        {
            [pAy addObject:@"开通|6801"];
            [pAy addObject:@"取消|6819"];
            [pAy addObject:@"撤单|6807"];
            [pAy addObject:@"预留金额|6820"];
        }
            break;
        case WT_THB_TQGH:
        {
            [pAy addObject:@"刷新|6802"];
            [pAy addObject:@"提前购回|6801"];
        }
            break;
        case WT_THB_TQGHYY:
        {
            [pAy addObject:@"刷新|6802"];
            [pAy addObject:@"购回预约|6801"];
        }
            break;
        default:
            break;
    }
    
    [tztUIBarButtonItem GetToolBarItemByArray:pAy delegate_:self forToolbar_:toolBar];
    DelObject(pAy);
    if (_nMsgType == WT_THB_DLWT)
    {
         [_pView CheckDLWT];
    }
   
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
//代理委托界面对工具条的按钮特殊处理
//首次开通的情况下按钮都是灰的不能点击，未开通的情况下预留金额设置和取消是灰的不能点击，开通情况下开通按钮是灰的不能点击。
-(void)ChangeTool:(int)type
{
    if (_nMsgType != WT_THB_DLWT)
        return;
    for (UIView *subView in toolBar.subviews)
    {
        if (subView && [subView isKindOfClass:[UIButton class]])
        {
            UIButton *button = (UIButton *)subView;
            [button setTztTitleColor:[UIColor whiteColor]];
             button.enabled = TRUE;
            if (type == 1)
            {
                if (button.tag == 6801)
                {
                    [button setTztTitleColor:[UIColor grayColor]];
                    button.enabled = FALSE;
                }
            }else if(type == 0)
            {
                if (button.tag == 6819)
                {
                    [button setTztTitleColor:[UIColor grayColor]];
                    button.enabled = FALSE;
                }
                if (button.tag == 6820)
                {
                    [button setTztTitleColor:[UIColor grayColor]];
                    button.enabled = FALSE;
                }
            }else
            {
                [button setTztTitleColor:[UIColor grayColor]];
                button.enabled = FALSE;
            }
        }
    }
}
@end
