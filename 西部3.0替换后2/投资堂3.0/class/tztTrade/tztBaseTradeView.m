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

#import "tztBaseTradeView.h"
#import "TZTUIBaseVCMsg.h"
#import "tztListDetailView.h"
#ifdef kSUPPORT_XBSC
#import "RZRQMacro.h"
#endif
#define ToolButtonHeight 32 // 自定的底部button所在高度 byDBQ20130723

@interface tztBaseTradeView()
{
    TZTUIReportGridView *_pGridView;
    NSMutableArray      *_ayTitle;
}
@end

@implementation tztBaseTradeView
@synthesize nMsgType = _nMsgType;
@synthesize delegate = _delegate;
@synthesize ntztReqNo = _ntztReqNo;
@synthesize pTradeToolBar = _pTradeToolBar;
@synthesize ayToolBtn = _ayToolBtn;
@synthesize nRZRQHZStock = _nRZRQHZStock;
@synthesize bRequest = _bRequest;

-(id)init
{
    if (self = [super init])
    {
        
    }
    return self;
}

-(void)dealloc
{
    [super dealloc];
}

-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    self.backgroundColor = [UIColor tztThemeBackgroundColorJY];
    CGRect rcFrame = CGRectMake(0, frame.size.height - ToolButtonHeight , frame.size.width, ToolButtonHeight);
    if (IS_TZTIPAD)
    {
        if (_pTradeToolBar == nil)
        {
            _pTradeToolBar = [[tztUITradeToolBarView alloc] initWithFrame:rcFrame];
            _pTradeToolBar.pDelegate = self;
            [_pTradeToolBar SetBtnArrayByPageType:_nMsgType];
//            if (!IS_TZTIPAD)
                [self ShowTool:NO];
            [self addSubview:_pTradeToolBar];
            [_pTradeToolBar release];
        }
        else
        {
            _pTradeToolBar.frame = rcFrame;
            [_pTradeToolBar SetBtnArrayByPageType:_nMsgType];
        }
    }
    
    [self reloadTheme];
}

- (void)reloadTheme
{
    self.backgroundColor = [UIColor tztThemeBackgroundColor];
}

-(void)ShowTool:(BOOL)bShow
{
    _pTradeToolBar.hidden = !bShow;
}

-(void)OnRequestData
{
    
}
-(void)SetDefaultData
{
    
}
-(void)OnRefresh
{
    
}

-(void)ClearData
{
    
}

-(void)setStockCode:(NSString*)nsCode
{
    
}

- (void)removeFromSuperview
{
    if (!IS_TZTIPAD)
        [[tztMoblieStockComm getShareInstance] removeObj:self];
    [super removeFromSuperview];
}

+(BOOL)IsExitError:(int)nError
{
    if ( (nError == COMM_ERR_NO_EXIT1) ||       //时间戳错误
             (nError == COMM_ERR_NO_EXIT2) ||   //超时
             (nError == COMM_ERR_NO_EXIT3 ||    //密码错误
              (nError == COMM_ERR_NO_EXIT4))    //无效在线客户号
            )
    {
        return TRUE;
    }
    return FALSE;
}

/*
 退出时候,用定时器调用,避免上次动画没有结束 add by xyt 20130820
 */
-(void)onReturn
{
    if (IS_TZTIPAD)
    {
        if (g_pToolBarView)
        {
            [g_pToolBarView OnDealToolBarByName:@"我的自选"];
        }
        [[TZTAppObj getShareInstance] tztAppObj:nil didSelectItemByPageType:tztTradePage options_:nil];
        
        if (IsRZRQMsgType(_nMsgType))
        {
            [TZTUIBaseVCMsg OnMsg:WT_RZRQ_IPAD wParam:0 lParam:0];
        }
        else
        {
            [TZTUIBaseVCMsg OnMsg:WT_Trade_IPAD wParam:0 lParam:0];
        }
    }
    else
    {
#ifdef tzt_NewVersion
        [g_navigationController popToRootViewControllerAnimated:NO];
        [TZTUIBaseVCMsg OnMsg:_nMsgType wParam:0 lParam:0];
#else
        [g_navigationController popViewControllerAnimated:NO];
        [TZTUIBaseVCMsg OnMsg:_nMsgType wParam:0 lParam:0];
#endif
    }
}

-(void)OnNeedLoginOut
{
    if (IsRZRQMsgType(_nMsgType))
    {
        //融资融券登出后,担保品登录的Token设置为空 add by xyt 20130820
        g_CurUserData.nsDBPLoginToken = @"";
        [TZTUserInfoDeal SetTradeLogState:Trade_Logout lLoginType_:RZRQTrade_Log];
    }
    else
    {
        [TZTUserInfoDeal SetTradeLogState:Trade_Logout lLoginType_:StockTrade_Log];
    }
    
//    [TZTUserInfoDeal SetTradeLogState:Trade_Logout lLoginType_:AllTrade_Log];//直接登出所有
    [tztJYLoginInfo SetLoginAllOut];
    //退出时候,用定时器调用,避免上次动画没有结束 add by xyt 20130820
    [NSTimer scheduledTimerWithTimeInterval:0.8
                                     target:self
                                   selector:@selector(onReturn)
                                   userInfo:nil
                                    repeats:NO];
    
//    if (IS_TZTIPAD)
//    {
//        [TZTUIBaseVCMsg OnMsg:WT_Trade_IPAD wParam:0 lParam:0];
//    }
//    else
//    {
//#ifdef tzt_NewVersion
//        [g_navigationController popToRootViewControllerAnimated:UseAnimated];
//#else
//        [g_navigationController popViewControllerAnimated:NO];
//        [TZTUIBaseVCMsg OnMsg:_nMsgType wParam:0 lParam:0];
//#endif
//    }
}


-(BOOL)OnToolbarMenuClick:(id)sender
{
    UIButton *pBtn = (UIButton*)sender;
    if (pBtn.tag == TZTToolbar_Fuction_WithDraw)
    {
        tztListDetailView *pDetail = (tztListDetailView*)[self viewWithTag:0x2323];
        if (pDetail)
        {
            [pDetail OnToolbarMenuClick:sender];
        }
    }
    
    return FALSE;
}

-(BOOL)OnDetail:(TZTUIReportGridView*)gridview ayTitle_:(NSMutableArray*)ayTitle
{
    return [self OnDetail:gridview ayTitle_:ayTitle dictIndex_:nil];
}

-(BOOL)OnDetail:(TZTUIReportGridView*)gridview ayTitle_:(NSMutableArray*)ayTitle dictIndex_:(NSMutableDictionary*)dictIndex
{
    if (IS_TZTIPAD || _bDetailNew || _nMsgType == MENU_SYS_UserWarningList)
    {
        NSMutableDictionary* pDict = NewObject(NSMutableDictionary);
        [pDict setTztObject:gridview.ayData forKey:@"GridDATA"];
        [pDict setTztObject:ayTitle forKey:@"TitleData"];
        [pDict setTztObject:[NSString stringWithFormat:@"%d",(int)gridview.curIndexRow] forKey:@"CurIndex"];
        [pDict setTztObject:[NSString stringWithFormat:@"%d", (int)gridview.nMaxColNum] forKey:@"MaxColNum"];
        NSString* strTitle = [NSString stringWithFormat:@"%d", (int)_nMsgType];
        [pDict setTztObject:strTitle forKey:@"tztMsgType"];
        if (dictIndex)
            [pDict setTztObject:dictIndex forKey:@"tztDictIndex"];
        if (_nMsgType == MENU_JY_PT_QueryStock)
        {
        
            NSMutableArray *pAy = NewObjectAutoD(NSMutableArray);

            [pAy addObject:@"行情|3300"];
            [pAy addObject:@"卖出|3804"];

            
            [pDict setTztObject:pAy forKey:@"tztToolBarBtn"];
        }
        [TZTUIBaseVCMsg OnMsg:TZTToolbar_Fuction_Detail wParam:(NSUInteger)pDict lParam:0];
        [pDict release];
        return 1;
    }
    if (gridview.ayGriddata == NULL || [gridview.ayGriddata count] < 1)
        return TRUE;
    NSInteger nIndex = gridview.curIndexRow;
    if (nIndex < 0)
        return TRUE;
 
    _pGridView = gridview;
    
    tztListDetailView *pDetail = (tztListDetailView*)[self viewWithTag:0x2323];
    
    if (pDetail == NULL)
    {
        pDetail = [[tztListDetailView alloc] init];
        pDetail.backgroundColor = [UIColor tztThemeBackgroundColorJY];
        pDetail.tztdelegate = self;
        pDetail.tag = 0x2323;
        [self addSubview:pDetail];
        [pDetail release];
        if (_delegate && [_delegate respondsToSelector:@selector(GetAyToolBar)])
        {
            self.ayToolBtn = [_delegate GetAyToolBar];
        }
        
        NSMutableArray *pAy = NewObject(NSMutableArray);
#ifdef kSUPPORT_XBSC
        if (self.nMsgType==kMENU_JY_RZRQ_ZDHYHK||self.nMsgType==kMENU_JY_RZRQ_ZDMQHK) //判断是否 指定合约还款活着指定卖券还款信息
        {
            if (self.nMsgType==15444)
            {
               [pAy addObject:@"确定|15446"];  //指定合约还款
            }
            if (self.nMsgType==15445)
            {
                [pAy addObject:@"确定|15447"]; //WT_RZRQSALERETURN 指定卖券还款
            }
           
            
        }
        else
#endif
        {
            [pAy addObject:@"上条|6809"];
            [pAy addObject:@"下条|6810"];
       
        }
        for (int i = 0; i < [self.ayToolBtn count]; i++)
        {
#ifdef tzt_NewVersion
            UIButton* pBtn = (UIButton*)[self.ayToolBtn objectAtIndex:i];
            if (pBtn.tag == TZTToolbar_Fuction_Detail
                || pBtn.tag == TZTToolbar_Fuction_Pre
                || pBtn.tag == TZTToolbar_Fuction_Next
                || pBtn.tag == TZTToolbar_Fuction_Refresh)
                continue;
            if (g_pSystermConfig.bGPAndZJ && (pBtn.tag == WT_RZRQQUERYFUNE || pBtn.tag == WT_RZRQQUERYGP || pBtn.tag == WT_QUERYGP || pBtn.tag == WT_QUERYFUNE)) // 进入详情界面不要资金股票按钮 byDBQ20131213
            {
                continue;
            }
            
            NSString* str = [NSString stringWithFormat:@"%@|%d", [pBtn titleForState:UIControlStateNormal], (int)pBtn.tag];
            [pAy addObject:str];
#else
            tztUIBarButtonItem *pBarItem = (tztUIBarButtonItem*)[self.ayToolBtn objectAtIndex:i];
            if (pBarItem.ntztTag == TZTToolbar_Fuction_Detail
                || pBarItem.ntztTag == TZTToolbar_Fuction_Pre
                || pBarItem.ntztTag == TZTToolbar_Fuction_Next
                || pBarItem.ntztTag == TZTToolbar_Fuction_Refresh)
                continue;
            
            NSString* str = [NSString stringWithFormat:@"%@|%d", pBarItem.nsTitle , pBarItem.ntztTag];
            [pAy addObject:str];
#endif
            
        }
        if (_delegate && [_delegate respondsToSelector:@selector(onSetToolBarBtn:bDetail_:)])
        {
            [_delegate onSetToolBarBtn:pAy bDetail_:TRUE];
        }
        DelObject(pAy)
        CGRect rcFrame = gridview.frame;
        pDetail.frame = rcFrame;
        if (gridview.nMaxColNum > 0 && gridview.nMaxColNum < [ayTitle count])
        {
            NSArray *subAy = [ayTitle subarrayWithRange:NSMakeRange(0, gridview.nMaxColNum)];
            [pDetail SetDetailData:subAy ayContent_:[self GetContent:gridview nIndex_:nIndex]];
        }
        else
        {
            [pDetail SetDetailData:ayTitle ayContent_:[self GetContent:gridview nIndex_:nIndex]];
        }
    }
    else
    {
    
//    [self bringSubviewToFront:pDetail];
//    [pDetail SetDetailData:ayTitle ayContent_:[self GetContent:gridview nIndex_:nIndex]];
        [pDetail SetDetailData:[self GetContent:gridview nIndex_:nIndex]];
    }
    
    return TRUE;
}

-(void)OnGridNextStock:(TZTUIReportGridView*)gridView ayTitle_:(NSMutableArray *)ayTitle
{
    if (gridView == NULL)
        return;
    UIView *pView = [self viewWithTag:0x2323];
    if (pView == NULL)
        return;
    NSInteger nIndex = gridView.curIndexRow;
    nIndex++;
    
    if (nIndex >= [gridView.ayData count])
    {
        nIndex = [gridView.ayData count] - 1;
        [self showMessageBox:@"当前页最后一条记录!" nType_:TZTBoxTypeNoButton delegate_:nil];
        return;
    }
    if (pView)
    {
        [gridView setSelectRow:nIndex];
        [self OnDetail:gridView ayTitle_:ayTitle];
    }
}

-(void)OnGridPreStock:(TZTUIReportGridView*)gridView ayTitle_:(NSMutableArray *)ayTitle
{
    if (gridView == NULL)
        return;
    
    UIView *pView = [self viewWithTag:0x2323];
    if (pView == NULL)
        return;
    
    NSInteger nIndex = gridView.curIndexRow;
    nIndex--;
    
    if (nIndex < 0)
    {
        nIndex = 0;
        [self showMessageBox:@"当前页第一条记录!" nType_:TZTBoxTypeNoButton delegate_:nil];
        return;
    }
    if (pView)
    {
        [gridView setSelectRow:nIndex];
        [self OnDetail:gridView ayTitle_:ayTitle];
    }
}

-(NSMutableArray*)GetContent:(TZTUIReportGridView*)gridview nIndex_:(NSInteger)nIndex
{
    if (gridview.ayGriddata == NULL || [gridview.ayGriddata count] < 1)
        return NULL;
    
    if (nIndex >= [gridview.ayData count] || nIndex < 0)
        return NULL;
    
    NSMutableArray* ay = [gridview.ayData objectAtIndex: nIndex];
    if (gridview.nMaxColNum > 0 &&  gridview.nMaxColNum < [ay count])
        return (NSMutableArray*)[ay subarrayWithRange:NSMakeRange(0, gridview.nMaxColNum)];
    return ay;
}

-(void)setToolBarBtn
{
    if (_delegate && [_delegate respondsToSelector:@selector(onSetToolBarBtn:bDetail_:)])
    {
        [_delegate onSetToolBarBtn:NULL bDetail_:NO];
    }
}

-(BOOL)isEqualMsgType:(NSInteger)nType
{
    return (self.nMsgType == nType);
}
@end
