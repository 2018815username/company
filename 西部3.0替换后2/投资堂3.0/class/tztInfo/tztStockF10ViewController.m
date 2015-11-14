/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:        f10
 * 文件标识:
 * 摘要说明:
 *
 * 当前版本:        2.0
 * 作    者:       yinjp
 * 更新日期:
 * 整理修改:    modify by xyt
 *            F10有三级菜单,中间一级不显示,直接显示内容;然后通过上一条，下一条来切换  
 ***************************************************************/

#import "tztStockF10ViewController.h"

#define tztZXLeftWidth 200
@interface tztStockF10ViewController ()

@end

@implementation tztStockF10ViewController
@synthesize tztTableInfoView = _tztTableInfoView;
@synthesize tztSecondInfoView = _tztSecondInfoView;
@synthesize tztContentInfoView = _tztContentInfoView;
@synthesize nLevel = _nLevel;

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
    [self OnRefreshData];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self LoadLayoutView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    
//    rcFrame.origin = CGPointZero;
//    rcFrame.size = CGSizeMake(600, 680);
    
    [self onSetTztTitleView:@"F10" type:TZTTitleReturn|TZTTitleNormal];
    _tztTitleView.bHasCloseBtn = YES;//带右侧的关闭按钮
    
    rcFrame.origin.y += _tztTitleView.frame.size.height;
    rcFrame.size.height -= _tztTitleView.frame.size.height;
    //一级菜单列表
    CGRect rcFirst = rcFrame;
    rcFirst.size.width = tztZXLeftWidth;
    if (_tztTableInfoView == nil)
    {
        _tztTableInfoView = [[tztInfoTableView alloc] initWithFrame:rcFirst];
        _tztTableInfoView.tztdelegate = self;
        _tztTableInfoView.tztinfodelegate = self;
        _tztTableInfoView.nMinShowRow = 21;
        _tztTableInfoView.nMaxCount = 100;//第一级全部请求
        _tztTableInfoView.nsBackImage = @"TZTZXListbg.png";
        [_tztBaseView addSubview:_tztTableInfoView];
        [_tztTableInfoView release];
    }
    else
    {
        _tztTableInfoView.frame = rcFirst;
    }
    
    //第二季菜单 ,隐藏不显示
    if (_tztSecondInfoView == nil)
    {
        _tztSecondInfoView = [[tztInfoTableView alloc] initWithFrame:rcFirst];
        _tztSecondInfoView.tztinfodelegate = self;
        _tztSecondInfoView.tztdelegate = self;
        _tztSecondInfoView.nMinShowRow = 15;
        //_tztSecondInfoView.nMaxCount = 15;
        _tztSecondInfoView.nMaxCount = 100;//请求条数
        _tztSecondInfoView.nsBackImage = @"TZTZXsecendBG.png";
        _tztSecondInfoView.hidden = YES;
        [_tztBaseView addSubview:_tztSecondInfoView];
        [_tztSecondInfoView release];
    }
    else
    {
        _tztSecondInfoView.frame = rcFirst;
    }
    CGRect rcContent = rcFirst;
    
    rcContent.origin.x = rcFirst.origin.x + rcFirst.size.width;
    //    rcContent.origin.y = rcSecond.origin.y + rcSecond.size.height;
    rcContent.size.width = rcFrame.size.width - rcFirst.size.width;
    rcContent.size.height = rcFrame.size.height;
    
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
    
    
    UIButton* pBtnPre =  [UIButton buttonWithType:UIButtonTypeRoundedRect];
    pBtnPre.frame = CGRectMake(rcContent.origin.x + rcContent.size.width - 200, rcContent.origin.y + rcContent.size.height - 50, 80, 35);
    [pBtnPre setTitle:@"上一条" forState:UIControlStateNormal];
    [pBtnPre addTarget:self action:@selector(OnBtnPre) forControlEvents:UIControlEventTouchUpInside];
    [_tztBaseView addSubview:pBtnPre];
    
    UIButton* pBtnNext =  [UIButton buttonWithType:UIButtonTypeRoundedRect];
    pBtnNext.frame = CGRectMake(rcContent.origin.x + rcContent.size.width - 100, rcContent.origin.y + rcContent.size.height - 50, 80, 35);
    [pBtnNext setTitle:@"下一条" forState:UIControlStateNormal];
    [pBtnNext addTarget:self action:@selector(OnBtnNext) forControlEvents:UIControlEventTouchUpInside];
    [_tztBaseView addSubview:pBtnNext];
}

-(void)OnRefreshData
{
    if (_tztTableInfoView)
    {
        [_tztTableInfoView setStockInfo:_pStockInfo HsString_:nil];
        [_tztTableInfoView setStockInfo:_pStockInfo Request:1];
        [_tztTableInfoView.aySubMenuData removeAllObjects];
    }
}

-(void)OnBtnPre
{
    if (_tztContentInfoView)
    {
        NSInteger nStartPos = _tztSecondInfoView.nSelectRow;
        //int nMax = _tztSecondInfoView.infoBase.nHaveMax;
        if (nStartPos < 1)
        {
            [self showMessageBox:@"当前是第一条!" nType_:TZTBoxTypeNoButton delegate_:nil];
            return;
        }
        else
        {
            nStartPos = _tztSecondInfoView.nSelectRow - 1;
            if (nStartPos < 0)
                nStartPos = 0;
            if (_tztSecondInfoView.ayInfoData == NULL || [_tztSecondInfoView.ayInfoData count] <= nStartPos) 
                return;
            _tztSecondInfoView.nSelectRow = nStartPos;
            tztInfoItem *pItem = [_tztSecondInfoView.ayInfoData objectAtIndex:nStartPos];
            if (pItem == NULL || ![pItem isKindOfClass:[tztInfoItem class]]) 
                return;
            //_tztContentInfoView.infoBase.nStartPos = nStartPos;
            //[_tztContentInfoView setStockInfo:_pStockInfo Request:1];
            
            [_tztContentInfoView setStockInfo:_pStockInfo HsString_:pItem.IndexID];
            [_tztContentInfoView setStockInfo:_pStockInfo Request:1];
        }
    }
}

-(void)OnBtnNext
{
    if (_tztContentInfoView)
    {
        NSInteger nStartPos = _tztSecondInfoView.nSelectRow + 1;
        if (nStartPos < 0)
            nStartPos = 0;
        NSInteger nMax = _tztSecondInfoView.infoBase.nHaveMax;
        if (nStartPos >= nMax) 
        {
            [self showMessageBox:@"当前是最后一条!" nType_:TZTBoxTypeNoButton delegate_:nil];
            return;
        }
        else
        {
            //int nCount = [_tztSecondInfoView.ayInfoData count];
            if (_tztSecondInfoView.ayInfoData == NULL || [_tztSecondInfoView.ayInfoData count] <= nStartPos) 
                return;
            _tztSecondInfoView.nSelectRow = nStartPos;
            tztInfoItem *pItem = [_tztSecondInfoView.ayInfoData objectAtIndex:nStartPos];
            if (pItem == NULL || ![pItem isKindOfClass:[tztInfoItem class]]) 
                return;
            //_tztContentInfoView.infoBase.nStartPos = nStartPos;
            
            [_tztContentInfoView setStockInfo:_pStockInfo HsString_:pItem.IndexID];
            [_tztContentInfoView setStockInfo:_pStockInfo Request:1];
            
        }
        
    }
}

-(void)SetInfoItem:(id)delegate pItem_:(tztInfoItem *)pItem
{
    if (delegate && [delegate isKindOfClass:[tztInfoTableView class]])
    {
        tztInfoTableView* pInfoTable = (tztInfoTableView*)delegate;
        if (pInfoTable == _tztTableInfoView)//
        {
            if(_tztSecondInfoView)
            {
                [_tztSecondInfoView setStockInfo:_pStockInfo HsString_:pItem.IndexID];
                [_tztSecondInfoView setStockInfo:_pStockInfo Request:1];
            }
            
            //保存选中的Item
            if (_tztTableInfoView.pSelItem == nil)
                _tztTableInfoView.pSelItem = NewObjectAutoD(tztInfoItem);
            
            _tztTableInfoView.pSelItem = pItem;
        }
        if (pInfoTable == _tztSecondInfoView)
        {
            //还是列表，回到第一个进行处理
            if (pItem.nIsIndex)
            {
                NSMutableArray* aySubItem = NewObject(NSMutableArray);
                NSMutableArray* aySubMenu = NewObject(NSMutableArray);
                //有子菜单时候,保存
                if (_tztTableInfoView.aySubMenuData == nil)
                    _tztTableInfoView.aySubMenuData = NewObject(NSMutableArray);
                
                //保存子菜单Item  和 对应的子菜单 
                [aySubItem addObject:_tztTableInfoView.pSelItem];
                [aySubMenu setArray:_tztSecondInfoView.ayInfoData];
                [aySubItem addObject:aySubMenu];
                [_tztTableInfoView.aySubMenuData addObject:aySubItem];
                
                DelObject(aySubMenu);
                DelObject(aySubItem);
                
                [_tztTableInfoView InsertSubMenu:_tztSecondInfoView.ayInfoData leven_:_tztTableInfoView.pSelItem.nLevel];
            }
            else
            {
                if (_tztContentInfoView)
                {
                    [_tztContentInfoView setStockInfo:_pStockInfo HsString_:pItem.IndexID];
                    [_tztContentInfoView setStockInfo:_pStockInfo Request:1];
                    //                [_tztContentInfoView RequestInfoData];
                }
            }
        }
    }
}

@end
