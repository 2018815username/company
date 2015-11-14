/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:        iPad资讯展示vc
 * 文件标识:        
 * 摘要说明:        
 * 
 * 当前版本:        2.0
 * 作    者:       yinjp
 * 更新日期:            
 * 整理修改:	
 *
 ***************************************************************/

#import "tztZXCenterViewController.h"

#define tztZXLeftWidth 222
#define tztZXCenterWidth 330

@implementation tztZXCenterViewController
@synthesize tztFirstInfoView = _tztFirstInfoView;
@synthesize tztSecondInfoView = _tztSecondInfoView;
@synthesize tztContentInfoView = _tztContentInfoView;
@synthesize nLevel = _nLevel;


- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle


- (void)viewDidLoad
{
    [self setTitle:@"资讯中心"];
    [super viewDidLoad];
    
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self LoadLayoutView];
    
    [self OnRefreshData];
}

-(void)dealloc
{
    [super dealloc];
}

-(void)LoadLayoutView
{
    CGRect rcFrame = _tztBounds;
    if (CGRectIsNull(rcFrame) || CGRectIsEmpty(rcFrame))
        return;
    BOOL bLandScape = FALSE;//默认竖屏
    if (rcFrame.size.width > rcFrame.size.height)
    {
        bLandScape = TRUE;//横屏
    }
    rcFrame.origin = CGPointZero;
    [self onSetTztTitleView:@"资讯中心" type:TZTTitleNormal];
     
    rcFrame.origin.y += _tztTitleView.frame.size.height;
    rcFrame.size.height -= _tztTitleView.frame.size.height;
    //一级菜单列表
    CGRect rcFirst = rcFrame;
    rcFirst.size.width = tztZXLeftWidth;
    if (_tztFirstInfoView == nil)
    {
        _tztFirstInfoView = [[tztInfoTableView alloc] initWithFrame:rcFirst];
        _tztFirstInfoView.tztdelegate = self;
        _tztFirstInfoView.tztinfodelegate = self;
        _tztFirstInfoView.nMinShowRow = 21;
        _tztFirstInfoView.nMaxCount = 100;//第一级全部请求
        _tztFirstInfoView.nsBackImage = @"TZTZXListbg.png";
        [_tztBaseView addSubview:_tztFirstInfoView];
        [_tztFirstInfoView release];
    }
    else
    {
        _tztFirstInfoView.frame = rcFirst;
    }
    
    //二级菜单
    CGRect rcSecond = rcFrame;
    rcSecond.origin.x += rcFirst.size.width;
    if (bLandScape)//横屏
    {
        rcSecond.size.width = tztZXCenterWidth;
    }
    else
    {
        rcSecond.size.height = rcFrame.size.height / 2;
    }
    
    if (_tztSecondInfoView == nil)
    {
        _tztSecondInfoView = [[tztInfoTableView alloc] initWithFrame:rcSecond];
        _tztSecondInfoView.tztinfodelegate = self;
        _tztSecondInfoView.tztdelegate = self;
        _tztSecondInfoView.nMinShowRow = 15;
        _tztSecondInfoView.nMaxCount = 15;
        _tztSecondInfoView.nsBackImage = @"TZTZXsecendBG.png";
        [_tztBaseView addSubview:_tztSecondInfoView];
        [_tztSecondInfoView release];
    }
    else
    {
        _tztSecondInfoView.frame = rcSecond;
    }
    
    //三级内容显示
    CGRect rcContent = rcSecond;
    if (bLandScape)//横屏
    {
        rcContent.origin.x += rcSecond.size.width;
        rcContent.size.width = rcFrame.size.width - rcFirst.size.width - rcSecond.size.width;
    }
    else//竖屏
    {
        rcContent.origin.x = rcFirst.origin.x + rcFirst.size.width;
        rcContent.origin.y = rcSecond.origin.y + rcSecond.size.height;
        rcContent.size.width = rcFrame.size.width - rcFirst.size.width;
        rcContent.size.height = rcFrame.size.height / 2;
    }
    
    if (_tztContentInfoView == nil)
    {
        _tztContentInfoView = [[tztInfoContentView alloc] initWithFrame:rcContent];
        _tztContentInfoView.tztdelegate = self;
        [_tztBaseView addSubview:_tztContentInfoView];
        [_tztContentInfoView release];
    }
    else
    {
        _tztContentInfoView.frame = rcContent;
    }
}

-(void)OnRefreshData
{
    if (_tztFirstInfoView)
    {
        [_tztFirstInfoView setStockInfo:nil HsString_:nil ];
        [_tztFirstInfoView setStockInfo:nil Request:1];
        //界面切换的时候,清空保存的Item和子菜单
        [_tztFirstInfoView.aySubMenuData removeAllObjects];
    }
}

-(void)SetInfoItem:(id)delegate pItem_:(tztInfoItem *)pItem
{
    if (delegate && [delegate isKindOfClass:[tztInfoTableView class]])
    {
        tztInfoTableView* pInfoTable = (tztInfoTableView*)delegate;
        if (pInfoTable == _tztFirstInfoView)//
        {
            if(_tztSecondInfoView)
            {
                [_tztSecondInfoView setStockInfo:nil HsString_:pItem.IndexID];
                [_tztSecondInfoView setStockInfo:nil Request:1];
            }
            
            //保存选中的Item
            if (_tztFirstInfoView.pSelItem == nil)
                _tztFirstInfoView.pSelItem = NewObjectAutoD(tztInfoItem);
            
            _tztFirstInfoView.pSelItem = pItem;
        }
        if (pInfoTable == _tztSecondInfoView)
        {
            //还是列表，回到第一个进行处理
            if (pItem.nIsIndex)
            {
                NSMutableArray* aySubItem = NewObject(NSMutableArray);
                NSMutableArray* aySubMenu = NewObject(NSMutableArray);
                //有子菜单时候,保存
                if (_tztFirstInfoView.aySubMenuData == nil)
                    _tztFirstInfoView.aySubMenuData = NewObject(NSMutableArray);
                
                //保存子菜单Item  和 对应的子菜单 
                [aySubItem addObject:_tztFirstInfoView.pSelItem];
                [aySubMenu setArray:_tztSecondInfoView.ayInfoData];
                [aySubItem addObject:aySubMenu];
                [_tztFirstInfoView.aySubMenuData addObject:aySubItem];
                
                DelObject(aySubMenu);
                DelObject(aySubItem);
                
                [_tztFirstInfoView InsertSubMenu:_tztSecondInfoView.ayInfoData leven_:_tztFirstInfoView.pSelItem.nLevel];
            }
            else
            {
                if (_tztContentInfoView)
                {
                    [_tztContentInfoView setStockInfo:nil HsString_:pItem.IndexID];
                    [_tztContentInfoView setStockInfo:nil Request:1];
    //                [_tztContentInfoView RequestInfoData];
                }
            }
        }
    }
}

- (void)CreateToolBar // iPad版本底部无toolBar byDBQ20130713
{
    
}

@end
