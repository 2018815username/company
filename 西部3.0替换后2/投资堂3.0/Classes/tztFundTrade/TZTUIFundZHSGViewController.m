/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:        组合申购vc
 * 文件标识:
 * 摘要说明:
 *
 * 当前版本:        2.0
 * 作    者:       yinjp
 * 更新日期:
 * 整理修改:
 *
 ***************************************************************/

#import "TZTUIFundZHSGViewController.h"

@interface TZTUIFundZHSGViewController (tztPrivate)

@end

@implementation TZTUIFundZHSGViewController
@synthesize pZHSGView = _pZHSGView;
@synthesize nCurrentIndex = _nCurrentIndex;
@synthesize bShowAll = _bShowAll;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        _bShowAll = TRUE;
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

-(void)LoadLayoutView
{
    CGRect rcFrame = _tztBounds;
    //标题view
    NSString* strTitle = GetTitleByID(_nMsgType);
    if (!ISNSStringValid(strTitle))
        strTitle = @"组合申购";
    self.nsTitle = [NSString stringWithFormat:@"%@", strTitle];
    [self onSetTztTitleView:self.nsTitle type:TZTTitleReport];
    
    CGRect rcView = rcFrame;
    rcView.origin.y += _tztTitleView.frame.size.height;
    rcView.size.height -= _tztTitleView.frame.size.height;
    if (_pZHSGView == nil)
    {
        _pZHSGView = [[tztUIFundZHSGView alloc] init];
        _pZHSGView.nMsgType = _nMsgType;
        _pZHSGView.bShowAll = _bShowAll;
        _pZHSGView.frame = rcView;
        _pZHSGView.nCurrentIndex = _nCurrentIndex;
        [_pZHSGView OnRefresh];//请求数据
        [_tztBaseView addSubview:_pZHSGView];
        [_pZHSGView release];
    }
    else
    {
        _pZHSGView.frame = rcView;
    }
    
    [_tztBaseView bringSubviewToFront:_tztTitleView];
    if (g_pSystermConfig && g_pSystermConfig.bNSearchFuncJY)
        self.tztTitleView.fourthBtn.hidden = YES;
}

-(void)CreateToolBar
{
    
}
@end
