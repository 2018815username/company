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

#import "tztTZKDSettingViewController.h"

@interface tztTZKDSettingViewController ()

@end

@implementation tztTZKDSettingViewController
@synthesize pSetView = _pSetView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self LoadLayoutView];
    
    [_pSetView RequestPushTime];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)LoadLayoutView
{
    [self onSetTztTitleView:@"快递设置" type:TZTTitleReport];
    CGRect rcSet = _tztBounds;
    rcSet.origin = CGPointZero;
    rcSet.origin.y += _tztTitleView.frame.size.height;
    rcSet.size.height -= (_tztTitleView.frame.size.height);
    if (_pSetView == nil)
    {
        _pSetView = [[tztTZKDSettingView alloc] init];
        _pSetView.pDelegate = self;
        _pSetView.frame = rcSet;
        [_tztBaseView addSubview:_pSetView];
        [_pSetView release];
    }
    else
    {
        _pSetView.frame = rcSet;
    }
    [_tztBaseView bringSubviewToFront:_tztTitleView];
}

-(void)CreateToolBar
{
    
}

@end
