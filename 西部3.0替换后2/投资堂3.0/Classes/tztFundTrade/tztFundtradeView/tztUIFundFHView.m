//
//  tztUIFundFHView.m
//  tztMobileApp
//
//  Created by deng wei on 13-3-12.
//  Copyright (c) 2013年 中焯. All rights reserved.
//

#import "tztUIFundFHView.h"
enum  {
	kTagCode = 1000,//公司代码
    kTagFH = 2000,//分红方式
    KTagCurSet = 3000,//基金账号
    kTagName = 4000, // 基金名称
    KTagPriceIndex = 2001,//基金净值
};

#define tztFundCode @"tztFundCode"
#define tztFundName @"tztFundName"
#define tztCurrentSet @"tztCurrentSet"
#define tztPriceIndex @"tztPriceIndex"

@implementation tztUIFundFHView

@synthesize tztTradeTable = _tztTradeTable;
@synthesize ayType = _ayType;
@synthesize ayTypeData = _ayTypeData;
@synthesize ayFundData = _ayFundData;
@synthesize pCurSetStr = _pCurSetStr;

-(id)init
{
    if (self = [super init])
    {
        [[tztMoblieStockComm getShareInstance] addObj:self];
    }
    return self;
}

-(void)dealloc
{
    [[tztMoblieStockComm getShareInstance] removeObj:self];
    DelObject(_ayType);
    DelObject(_ayTypeData);
    DelObject(_ayFundData);
    [super dealloc];
    
}

-(void)setFrame:(CGRect)frame
{
    if (CGRectIsEmpty(frame) || CGRectIsNull(frame)) 
        return;
    
    [super setFrame:frame];
    CGRect rcFrame = self.bounds;
    if(!_pTradeToolBar.hidden)
    {
        rcFrame.size.height -= _pTradeToolBar.frame.size.height;
    }
    //zxl  20131022 调整了界面初始设置
    if (_tztTradeTable == nil)
    {
        _tztTradeTable = [[tztUIVCBaseView alloc] initWithFrame:rcFrame];
        _tztTradeTable.tztDelegate = self;
        if (_nMsgType == TZT_MENU_JY_LCCP_FH) // 理财产品分红
            [_tztTradeTable setTableConfig:@"tztUITradeLCFundKSetFH"];
        else if (_nMsgType == TZT_MENU_JY_LCCP_GL_LIST) // 理财产品列表
            [_tztTradeTable setTableConfig:@"tztUITradeLCFundKSetFH"];
        else
            [_tztTradeTable setTableConfig:@"tztUITradeFundKSetFH"];
        [self addSubview:_tztTradeTable];
        
        if (_ayType == nil || [_ayType count] < 1)
        {
            _ayType = NewObject(NSMutableArray);
            [_ayType addObject:@"现金分红"];
            [_ayType addObject:@"份额分红"];
        }
        
        if (_ayTypeData == nil || [_ayTypeData count] < 1)
        {
            _ayTypeData = NewObject(NSMutableArray);
            [_ayTypeData addObject:@"1"];
            [_ayTypeData addObject:@"0"];
        }
        
    }
    else
    {
        _tztTradeTable.frame = rcFrame;
    }
    //zxl 20131022 修改了初始类型设置
    [_tztTradeTable setComBoxData:_ayType ayContent_:_ayType AndIndex_:-1 withTag_:2000];
}


// iPad会在加载时调用请求信息 byDBQ20130829
- (void)OnSendRequestData
{
    //查询持仓基金信息
    NSMutableDictionary *pDict = NewObject(NSMutableDictionary);
    
    _ntztReqNo++;
    if (_ntztReqNo >= UINT16_MAX)
        _ntztReqNo = 1;
    
    NSString *strReqno = tztKeyReqno((long)self, _ntztReqNo);
    [pDict setTztValue:strReqno forKey:@"Reqno"];
    [pDict setTztObject:@"1000" forKey:@"Maxcount"];
    [pDict setTztObject:@"0" forKey:@"StartPos"];
    if (_nMsgType == TZT_MENU_JY_LCCP_FH) // 理财产品分红
    {
        [[tztMoblieStockComm getShareInstance] onSendDataAction:@"355" withDictValue:pDict];
    }
    else if(_nMsgType == TZT_MENU_JY_LCCP_GL_LIST) // 理财产品列表
    {
        [[tztMoblieStockComm getShareInstance] onSendDataAction:@"355" withDictValue:pDict];
    }
    else
    {
        [[tztMoblieStockComm getShareInstance] onSendDataAction:@"137" withDictValue:pDict];
    }
    
    DelObject(pDict);
}

//清空界面数据
-(void) ClearData
{
    if (_tztTradeTable == NULL)
        return;
    [_tztTradeTable setLabelText:@"" withTag_:kTagCode];
    [_tztTradeTable setLabelText:@"" withTag_:KTagPriceIndex];
    [_tztTradeTable setLabelText:@"" withTag_:KTagCurSet];
    [_tztTradeTable setComBoxText:nil withTag_:kTagName];
    [_tztTradeTable setComBoxText:nil withTag_:kTagFH];
}

-(void)OnSendFH
{
    if (_tztTradeTable == NULL)
        return;
    NSString* strCode = [_tztTradeTable GetLabelText:kTagCode];
    if (strCode == NULL || strCode.length < 1)
        return;
    
    NSInteger nIndex = [_tztTradeTable getComBoxSelctedIndex:kTagFH];
    if (nIndex < 0 || nIndex >= [_ayTypeData count])
        return;
    NSMutableDictionary *pDict = NewObject(NSMutableDictionary);
    _ntztReqNo++;
    if (_ntztReqNo >= UINT16_MAX)
        _ntztReqNo = 1;
    
    NSString *strReqno = tztKeyReqno((long)self, _ntztReqNo);
    [pDict setTztValue:strReqno forKey:@"Reqno"];
    [pDict setTztValue:strCode forKey:@"FUNDCODE"];
    [pDict setTztValue:[_ayTypeData  objectAtIndex:nIndex] forKey:@"FHTYPE"];
    [[tztMoblieStockComm getShareInstance] onSendDataAction:@"142" withDictValue:pDict];
    DelObject(pDict);
    
    
}


-(NSUInteger)OnCommNotify:(NSUInteger)wParam lParam_:(NSUInteger)lParam
{
    tztNewMSParse *pParse = (tztNewMSParse*)wParam;
    if (pParse == NULL)
        return 0;
    if (![pParse IsIphoneKey:(long)self reqno:_ntztReqNo]) 
        return 0;
    
    int nErrNo = [pParse GetErrorNo];
    NSString* strError = [pParse GetErrorMessage];
    
    if ([tztBaseTradeView IsExitError:nErrNo])
    {
        [self OnNeedLoginOut];
        if (strError)
            tztAfxMessageBox(strError);
        return 0;
    }
    
    if (nErrNo < 0)
    {
        if(strError)
        {
            [self showMessageBox:strError nType_:TZTBoxTypeNoButton nTag_:0];
        }
        return 0;
    }
    
    if ([pParse IsAction:@"142"])
    {
        if (strError && [strError length] > 0)
            [self showMessageBox:strError nType_:TZTBoxTypeNoButton nTag_:0];
        [self ClearData];
        return 1;
    }
    
    if ([pParse IsAction:@"137"] || [pParse IsAction:@"355"])
    {
        int nFundCodeIndex = -1;
        int nFundNameIndex = -1;
        int nCurrentSetIndex = -1;
        int nPriceIndex = -1;
        
        NSString* strIndex = [pParse GetByName:@"JJDMIndex"];
        TZTStringToIndex(strIndex, nFundCodeIndex);
        
        strIndex = [pParse GetByName:@"JJMCIndex"];
        TZTStringToIndex(strIndex, nFundNameIndex);
        
        strIndex = [pParse GetByName:@"currentset"];
        TZTStringToIndex(strIndex, nCurrentSetIndex);
        
        strIndex = [pParse GetByName:@"PriceIndex"];
        TZTStringToIndex(strIndex, nPriceIndex);
        
        if (nFundCodeIndex < 0)//代码字段小于0
            return 0;
        
        NSArray *pGridAy = [pParse GetArrayByName:@"Grid"];
        //zxl 20131021 修改了当无信息返回时显示返回的提示信息
        if ([pGridAy count] == 1)
        {
            if (strError && [strError length] > 0)
                [self showMessageBox:strError nType_:TZTBoxTypeNoButton nTag_:0];
            return 0;
        }
        
        NSMutableArray *pAyTitle = NewObject(NSMutableArray);
        if (_ayFundData == NULL)
            _ayFundData = NewObject(NSMutableArray);
        [_ayFundData removeAllObjects];
        
        for (NSInteger i = 1; i < [pGridAy count]; i++)
        {
            NSMutableArray* pAy = [pGridAy objectAtIndex:i];
            if (pAy == NULL)
                continue;
            NSInteger nRet = [g_pSystermConfig CheckValidRow:pAy nRowIndex_:i nComIndex_:nFundCodeIndex nMsgType_:_nMsgType bCodeCheck_:TRUE];
            if (nRet <= 0)
                continue;
            NSInteger nCount = [pAy count];
            if (nCount < 1 || nFundCodeIndex >= nCount || nFundNameIndex >= nCount)
                continue;
            
            NSString* strCode = [pAy objectAtIndex:nFundCodeIndex];
            if (strCode == NULL || [strCode length] < 1)
                continue;
            NSMutableDictionary *pDict = NewObject(NSMutableDictionary);
            [pDict setTztObject:strCode forKey:tztFundCode];
            NSString* strName = [pAy objectAtIndex:nFundNameIndex];
            [pDict setTztObject:strName forKey:tztFundName];
            if (nCurrentSetIndex >= 0 && nCurrentSetIndex < nCount)
            {
                NSString* strCurrentSet = [pAy objectAtIndex:nCurrentSetIndex];
                [pDict setTztObject:strCurrentSet forKey:tztCurrentSet];
            }
            if (nPriceIndex >= 0 && nPriceIndex < nCount)
            {
                NSString* strPriceIndex = [pAy objectAtIndex:nPriceIndex];
                [pDict setTztObject:strPriceIndex forKey:tztPriceIndex];
            }
            
            [_ayFundData addObject:pDict];
            NSString* strTitle = [NSString stringWithFormat:@"%@(%@)",strName, strCode];
            [pAyTitle addObject:strTitle];
            DelObject(pDict);
        }
        
        if ([pAyTitle count] < 1)
        {
            [self showMessageBox:@"查无相关数据!" nType_:TZTBoxTypeNoButton nTag_:0];
        }
        else
        {
            if (_tztTradeTable)
                [_tztTradeTable setComBoxData:pAyTitle ayContent_:pAyTitle AndIndex_:-1 withTag_:kTagName bDrop_:TRUE];
        
        }
        DelObject(pAyTitle);
    }
    
    
    
    return 1;
}

-(void)setSelectData:(int)nIndex
{
    if (_tztTradeTable == NULL || _ayFundData == NULL || nIndex < 0 || nIndex >= [_ayFundData count])
        return;
    
    NSMutableDictionary *pDict = [_ayFundData objectAtIndex:nIndex];
    if (pDict == NULL)
        return;
    
    NSString* strCode = [pDict tztObjectForKey:tztFundCode];
    if (strCode == NULL)
        strCode = @"";
    NSString* strSet = [pDict tztObjectForKey:tztCurrentSet];
    if (strSet == NULL)
        strSet = @"";
    NSString* strPriceIndex = [pDict tztObjectForKey:tztPriceIndex];
    if (strPriceIndex == NULL)
        strPriceIndex = @"";
    
    [_tztTradeTable setLabelText:strCode withTag_:kTagCode];
    [_tztTradeTable setLabelText:strPriceIndex withTag_:KTagPriceIndex];
    [_tztTradeTable setLabelText:strSet withTag_:KTagCurSet];
}

//zxl 20131022 获取数据
-(void)tztDroplistViewGetData:(tztUIDroplistView*)droplistview
{
    if ([droplistview.tzttagcode intValue] == kTagName)
        [self OnSendRequestData];
}
//zxl 20131022 添加了 点击选择框是清空数据
- (void)tztDroplistViewBeginShowData:(tztUIDroplistView*)droplistview
{
    if ([droplistview.tzttagcode intValue] == kTagName)
    {
        [self ClearData];
        [_tztTradeTable setComBoxData:nil ayContent_:nil AndIndex_:0 withTag_:kTagName];
    }
}

- (void)tztDroplistView:(tztUIDroplistView *)droplistview didSelectIndex:(int)index
{
    if ([droplistview.tzttagcode intValue] == kTagName)
        [self setSelectData:index];
}

-(BOOL)CheckInput
{
    if (_tztTradeTable == NULL)
        return FALSE;
    NSInteger nIndex = [_tztTradeTable getComBoxSelctedIndex:kTagName];
    if (nIndex < 0 || nIndex >= [_ayFundData count])
    {
        [self showMessageBox:@"基金代码错误！" nType_:TZTBoxTypeNoButton delegate_:nil];
        return FALSE;
    }
    

    NSString* strCode = [_tztTradeTable GetLabelText:kTagCode];
    
    NSInteger nFlag = [_tztTradeTable getComBoxSelctedIndex:kTagFH];
    if (nFlag < 0 && nFlag >= [_ayType count])
        return FALSE;
    
    if(strCode == nil || [strCode length] < 1)
    {
        [self showMessageBox:@"基金公司代码有误，请刷新重试！" nType_:TZTBoxTypeNoButton nTag_:0];
        return FALSE;
    }
    
    
    NSString* strInfo = @"";
    strInfo = [NSString stringWithFormat:@"基金代码:%@\r\n分红方式:%@\r\n\r\n",strCode,[_ayType objectAtIndex:nFlag]];
    
    [self showMessageBox:strInfo
                  nType_:TZTBoxTypeButtonBoth
                   nTag_:0x1111
               delegate_:self
              withTitle_:@"分红设置"
                   nsOK_:@"确定"
               nsCancel_:@"取消"];
    
    return TRUE;
}



//工具栏点击事件
-(BOOL)OnToolbarMenuClick:(id)sender
{
    UIButton* pBtn = (UIButton*)sender;
    if (pBtn == NULL)
        return FALSE;
    
    switch (pBtn.tag)
    {
        case TZTToolbar_Fuction_OK:
        {
            if (_tztTradeTable)
            {
                if ([self CheckInput])
                {
                    return TRUE;
                }
            }
        }
            break;
        default:
            break;
    }
    return FALSE;
}

-(void)TZTUIMessageBox:(TZTUIMessageBox *)TZTUIMessageBox clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        switch (TZTUIMessageBox.tag)
        {
            case 0x1111:
            {
                [self OnSendFH];
            }
                break;
                
            default:
                break;
        }
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        switch (alertView.tag)
        {
            case 0x1111:
            {
                [self OnSendFH];
            }
                break;
                
            default:
                break;
        }
    }
}


-(void)OnButtonClick:(id)sender
{
    tztUIButton* pBtn = (tztUIButton*)sender;
    switch ([pBtn.tzttagcode intValue])
    {
        case 10000:
        {
            if (_tztTradeTable)
            {
                [self CheckInput];
            }
        }
            break;
        case 10001:
        {
            [g_navigationController popViewControllerAnimated:UseAnimated];
            //返回，取消风火轮显示
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            UIViewController* pTop = g_navigationController.topViewController;
            if (![pTop isKindOfClass:[TZTUIBaseViewController class]])
            {
                g_navigationController.navigationBar.hidden = NO;
                [[TZTAppObj getShareInstance] setMenuBarHidden:NO animated:YES];
            }
        }
            break;
        default:
            break;
    }
}

@end

