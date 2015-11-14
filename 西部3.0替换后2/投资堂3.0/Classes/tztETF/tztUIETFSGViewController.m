/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:        ETF申购vc
 * 文件标识:        
 * 摘要说明:        
 * 
 * 当前版本:        2.0
 * 作    者:       xyt
 * 更新日期:            
 * 整理修改:	
 *
 ***************************************************************/

#import "tztUIETFSGViewController.h"

@implementation tztUIETFSGViewController
@synthesize pTradeView = _pTradeView;

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

-(void)dealloc
{
    [super dealloc];
}

-(void)LoadLayoutView
{
    CGRect rcFrame = _tztBounds;
    NSString *strTitle = GetTitleByID(_nMsgType);
    if (!ISNSStringValid(strTitle))
        strTitle = @"ETF申购";
    self.nsTitle = [NSString stringWithFormat:@"%@", strTitle];
    [self onSetTztTitleView:self.nsTitle type:TZTTitleReport];
    
    rcFrame.origin.y += _tztTitleView.frame.size.height;
    if (!g_pSystermConfig.bShowbottomTool)
        rcFrame.size.height -= _tztTitleView.frame.size.height;
    else
        rcFrame.size.height -= (_tztTitleView.frame.size.height + TZTToolBarHeight);
    
    if (_pTradeView == nil)
    {
        _pTradeView = [[TZTETFSGView alloc] init];
        _pTradeView.delegate = self;
        _pTradeView.nMsgType = _nMsgType;
        _pTradeView.frame = rcFrame;
        [_tztBaseView addSubview:_pTradeView];
        [_pTradeView release];
    }
    else
    {
        _pTradeView.frame = rcFrame;
    }
    
    [_tztBaseView bringSubviewToFront:_tztTitleView];
    [self CreateToolBar];
}

-(void)CreateToolBar
{
    if (!g_pSystermConfig.bShowbottomTool)
        return;
}



@end
