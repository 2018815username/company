/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:        资讯中心（iphone）
 * 文件标识:        
 * 摘要说明:        
 * 
 * 当前版本:        2.0
 * 作    者:       yinjp
 * 更新日期:            
 * 整理修改:	
 *
 ***************************************************************/

#import "tztZXCenterViewController_iphone.h"
#import "tztZXContentViewController.h"

@interface tztZXCenterViewController_iphone()

@property(nonatomic,retain)UIView   *pLeftView;
@end

@implementation tztZXCenterViewController_iphone
@synthesize tztInfoView = _tztInfoView;
@synthesize pInfoItem = _pInfoItem;
@synthesize stockCode = _stockCode;
@synthesize pLeftView = _pLeftView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)dealloc
{
    [super dealloc];
}

-(void)LoadLayoutView
{
    CGRect rcFrame = _tztBounds;
    [self onSetTztTitleView:(self.nsTitle ? self.nsTitle : @"资讯中心") type:TZTTitleName];
    CGRect rcContent = rcFrame;
    rcContent.origin.y += _tztTitleView.frame.size.height;
#ifdef tzt_NewVersion // 去toolbar高度 byDBQ20130716
    rcContent.size.height -= (_tztTitleView.frame.size.height + 0);
#else
    if (g_pSystermConfig && !g_pSystermConfig.bShowbottomTool)
        rcContent.size.height -= (_tztTitleView.frame.size.height);
    else
        rcContent.size.height -= (_tztTitleView.frame.size.height + TZTToolBarHeight);
#endif
    
    if (_tztInfoView == nil)
    {
        _tztInfoView = [[tztInfoTableView alloc] initWithFrame:rcContent];
        _tztInfoView.nsBackImage = @"TZTReportContentBG.png";
        _tztInfoView.tztdelegate = self;
        _tztInfoView.tztinfodelegate = self;
        _tztInfoView.pFont = tztUIBaseViewTextFont(16.0f);
        if (self.pInfoItem)
        {
            [_tztInfoView setStockInfo:self.pStockInfo HsString_:self.pInfoItem.IndexID];
            [_tztInfoView setStockInfo:self.pStockInfo Request:1];
        }
        else
        {
            [_tztInfoView setStockInfo:self.pStockInfo HsString_:nil];
            [_tztInfoView setStockInfo:self.pStockInfo Request:1];   
        }
        [_tztBaseView addSubview:_tztInfoView];
        [_tztInfoView release];
    }
    else
        _tztInfoView.frame = rcContent;
#ifdef tzt_NewVersion // 去toolbar byDBQ20130716
#else
    [self CreateToolBar];
#endif
    
    
    /**/
    //增加左侧可拖动功能
    [[TZTAppObj getShareInstance].rootTabBarController.ayViews removeObject:_tztTitleView];
    [[TZTAppObj getShareInstance].rootTabBarController.ayViews addObject:_tztTitleView];
    CGRect rcLeft = CGRectMake(0, _tztTitleView.frame.size.height, 15, _tztBounds.size.height);
    if (_pLeftView == nil)
    {
        _pLeftView = [[UIView alloc] initWithFrame:rcLeft];
        _pLeftView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:_pLeftView];
        [_pLeftView release];
    }
    else
    {
        _pLeftView.frame = rcLeft;
    }
    
    [[TZTAppObj getShareInstance].rootTabBarController.ayViews removeObject:_pLeftView];
    [[TZTAppObj getShareInstance].rootTabBarController.ayViews addObject:_pLeftView];
    
    [[TZTAppObj getShareInstance].rootTabBarController RefreshAddCustomsViews];
}

-(void)CreateToolBar
{
    if (g_pSystermConfig && !g_pSystermConfig.bShowbottomTool)
        return;
    [super CreateToolBar];
    
    if (![super toolBarItemForContainService])
    {
        NSMutableArray *ay = NewObject(NSMutableArray);
        [ay addObject:@"首页|3200"];
        [ay addObject:@"自选|3202"];
        [ay addObject:@"排名|12004"];
        [ay addObject:@"交易|3818"];
        [ay addObject:@"设置|5801"];
        
        [tztUIBarButtonItem GetToolBarItemByArray:ay delegate_:self forToolbar_:toolBar];
        DelObject(ay);
    }
    
}

-(void)SetInfoItem:(id)delegate pItem_:(tztInfoItem *)pItem
{
    if (pItem == NULL)
        return;
    if (delegate == _tztInfoView)
    {
        [TZTUIBaseVCMsg OnMsg:HQ_MENU_Info_Content wParam:(NSUInteger)pItem lParam:(NSUInteger)_tztInfoView];
    }
}


//-(void)OnReturnBack
//{
//#ifdef tzt_NewVersion
//    if ([g_navigationController.viewControllers count] <=1)
//    {
//        [[TZTAppObj getShareInstance] tztAppObj:nil didSelectItemByPageType:tztHomePage options_:NULL];
//    }
//    else
//#endif
//        [super OnReturnBack];
//}
@end
