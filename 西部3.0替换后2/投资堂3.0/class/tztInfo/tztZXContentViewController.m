/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:        资讯内容
 * 文件标识:        
 * 摘要说明:        
 * 
 * 当前版本:        2.0
 * 作    者:       yinjp
 * 更新日期:            
 * 整理修改:	
 *
 ***************************************************************/

#import "tztZXContentViewController.h"


@implementation tztZXContentViewController
@synthesize pAyInfo = _pAyInfo;
@synthesize tztInfoContent = _tztInfoContent;
@synthesize pInfoItem = _pInfoItem;
@synthesize stockCode = _stockCode;
@synthesize pListView = _pListView;

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
}

- (void)viewDidUnload
{
    [super viewDidUnload]; 
}

-(void)dealloc
{
    [super dealloc];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    self.hidesBottomBarWhenPushed = YES;
    [self LoadLayoutView];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
//    self.hidesBottomBarWhenPushed = NO;
}

-(void)LoadLayoutView
{
    CGRect rcFrame = _tztBounds;
//    在这里设置资讯正文标题
//    [self onSetTztTitleView:@"资讯正文" type:TZTTitleDetail];
    [self onSetTztTitleView:@"资讯正文" type:TZTTitleReport];
    if (IS_TZTIPAD)
    {
        _tztTitleView.bShowSearchBar = NO;
        _tztTitleView.bHasCloseBtn = YES;
        _tztTitleView.nType = TZTTitleNormal;
        [_tztTitleView setFrame:_tztTitleView.frame];
    }
    
    CGRect rcContent = rcFrame;
    rcContent.origin.y += _tztTitleView.frame.size.height;
    
    if (IS_TZTIPAD)//iPad版本没有底部工具栏
    {
        rcContent.size.height -= _tztTitleView.frame.size.height;
    }
    else
    {
#ifdef tzt_NewVersion
        rcContent.size.height -= (_tztTitleView.frame.size.height);
#else
        if (g_pSystermConfig && !g_pSystermConfig.bShowbottomTool)
            rcContent.size.height -= (_tztTitleView.frame.size.height);
        else
            rcContent.size.height -= (_tztTitleView.frame.size.height + TZTToolBarHeight);
#endif
    }
    
    if (_tztInfoContent == nil)
    {
        _tztInfoContent = [[tztInfoContentView alloc] initWithFrame:rcContent];
        _tztInfoContent.tztdelegate = self;
        _tztInfoContent.pFont = tztUIBaseViewTextFont(16.0f);
        if (self.pInfoItem)
        {
            NSString* strIndexID = self.pInfoItem.IndexID;
            NSString *_infoContetn=self.pInfoItem.InfoContent;
            NSString *_infoTitle=self.pInfoItem.InfoTitle;
            NSString *_titleDate=self.pInfoItem.InfoTime;
            NSString *hsString=strIndexID;
            [_tztInfoContent  setDate:_titleDate];
             [_tztInfoContent setMenu:_infoTitle infoContetn:_infoContetn];
            if ([_infoTitle isEqual:@"特别提示"]) {
                 hsString=@"2002";
            }
            else if ([_infoTitle isEqual:@"今日关注"])
            {
                hsString=@"805632192";

            }
            else if ([_infoTitle isEqual:@"股评天地"])
            {
                hsString=@"2081";
                
            }

            [_tztInfoContent setStockInfo:self.pStockInfo HsString_:hsString];
//            [_tztInfoContent setStockInfo:self.pStockInfo HsString_:strIndexID];
            [_tztInfoContent setStockInfo:self.pStockInfo Request:1];
        }
        else
        {
            [_tztInfoContent setStockInfo:self.pStockInfo HsString_:nil];
            [_tztInfoContent setStockInfo:nil Request:1];   
        }
        
        if (self.pListView)
        {
            _tztInfoContent.pListView = self.pListView;
        }
        [_tztBaseView addSubview:_tztInfoContent];
        [_tztInfoContent release];
    }
    else
        _tztInfoContent.frame = rcContent;
    
#ifndef tzt_NewVersion
    [self CreateToolBar];
#endif
}

-(void)OnBtnPreStock:(id)sender
{
    if(_tztInfoContent)
        [_tztInfoContent onPreInfo];
}

-(void)OnBtnNextStock:(id)sender
{
    if(_tztInfoContent)
        [_tztInfoContent onNextInfo];
}

-(void)OnReturnBack
{
//#ifdef tzt_NewVersion
//    [TZTUIBaseVCMsg IPadPopViewController:NULL];
//#else
    [super OnReturnBack];
//#endif
}



-(void)CreateToolBar
{
#ifdef tzt_NewVersion
    return;
#endif
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
@end
