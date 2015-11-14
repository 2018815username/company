/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:        新股申购
 * 文件标识:
 * 摘要说明:
 *
 * 当前版本:        2.0
 * 作    者:       zxl
 * 更新日期:
 * 整理修改:
 *
 ***************************************************************/

#import "tztNewStockSGViewController.h"

@interface tztNewStockSGViewController ()

@end

@implementation tztNewStockSGViewController
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
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)LoadLayoutView
{
    CGRect rcFrame = _tztBounds;
    //标题view
    NSString *strTitle = GetTitleByID(_nMsgType);
    if (strTitle.length>0) {
    self.nsTitle = [NSString stringWithFormat:@"%@", strTitle];
    }else{
        switch (self.nMsgType) {
            case 12318:
                self.nsTitle =@"新股申购";
                break;
            case 12366:
                self.nsTitle = @"新股申购额度";
//            case 12384:
//                self.nsTitle =@"新股中签";
                break;
            case MENU_JY_RZRQ_NewStockSG:
                self.nsTitle = @"新股申购";
                break;
            default:
                break;
        }
    }

    
    [self onSetTztTitleView:self.nsTitle type:TZTTitleReturn]; // 标题取消搜索按钮  Tjf
    
    CGRect rcBuySell = rcFrame;
    rcBuySell.origin.y += _tztTitleView.frame.size.height;
    rcBuySell.size.height -= _tztTitleView.frame.size.height;
    
    if (_pView == nil)
    {
        _pView = [[tztNewStockSGView alloc] init];
        _pView.delegate = self;
        _pView.nMsgType = _nMsgType;
        _pView.frame = rcBuySell;
        [_tztBaseView addSubview:_pView];
        [_pView release];
    }
    else
    {
        _pView.frame = rcBuySell;
    }
    
    [_tztBaseView bringSubviewToFront:_tztTitleView];
}

-(void)CreateToolBar
{
    
}

@end
