//
//  TZTFundSearchPlansTransView.m
//  tztMobileApp
//
//  Created by deng wei on 13-3-20.
//  Copyright (c) 2013年 中焯. All rights reserved.
//

#import "TZTFundSearchPlansTransView.h"
enum  {
	kTagCode = 1000,
    kTagName = 2000,
    kTagGSName = 3000,
    kTagKHName = 4000,
    kTagZJAccount = 5000,
    kTagCYJE = 6000,
    kTagCYRQ = 7000,
};
@interface TZTFundSearchPlansTransView(tztPrivate)
//请求股票信息
-(void)OnRefresh;
@end

@implementation TZTFundSearchPlansTransView
@synthesize nsGSDM = _nsGSDM;
@synthesize nsGSMC = _nsGSMC;
@synthesize nsCode = _nsCode;
@synthesize nsCodeName = _nsCodeName;
@synthesize nType = _nType;
@synthesize tztTradeTable = _tztTradeTable;

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
    [super dealloc];
    
}

-(void)setFrame:(CGRect)frame
{
    if (CGRectIsEmpty(frame) || CGRectIsNull(frame))
        return;
    
    [super setFrame:frame];
    
    CGRect rcFrame = self.bounds;
    
    
    if (IS_TZTIPAD)
    {
        rcFrame.size.width = rcFrame.size.width / 5 * 3;
    }
    else
        rcFrame.size.height = rcFrame.size.height;
    
    if (_tztTradeTable == nil)
    {
        _tztTradeTable = [[tztUIVCBaseView alloc] initWithFrame:rcFrame];
        _tztTradeTable.tztDelegate = self;
        [_tztTradeTable setTableConfig:@"tztUITradeFundZZCY"];
        [self addSubview:_tztTradeTable];
        [_tztTradeTable release];
        [self SetDefaultData];
    }
    else
    {
        _tztTradeTable.frame = rcFrame;
    }
    
}

-(void)SetDefaultData
{
    //国泰的默认定 股票代码952010
    if (self.nsCode == NULL || [self.nsCode length] < 1)
    {
        self.nsCode = @"952010";
    }
    if (self.nsCodeName == NULL || [self.nsCodeName length] < 1)
    {
        self.nsCodeName = @"君得利二";
    }
    if (self.nsGSDM == NULL || [self.nsGSDM length] < 1)
    {
        self.nsGSDM = @"19";
    }
    if (self.nsGSMC == NULL || [self.nsGSMC length] < 1)
    {
        self.nsGSMC = @"上海登记";
    }
    
    [_tztTradeTable setLabelText:self.nsCode withTag_:1000];
    [_tztTradeTable setLabelText:self.nsCodeName withTag_:2000];
    [_tztTradeTable setLabelText:self.nsGSMC withTag_:3000];
    
    tztJYLoginInfo *CurInfo = [tztJYLoginInfo GetCurJYLoginInfo:TZTAccountPTType];
    if (CurInfo)
    {
        [_tztTradeTable setLabelText:CurInfo.nsUserName withTag_:4000];
        [_tztTradeTable setLabelText:CurInfo.nsAccount withTag_:5000];
    }
    
    NSMutableArray * ayDate = NewObject(NSMutableArray);
    for (int i = 1;i < 29 ; i++)
    {
        [ayDate addObject:[NSString stringWithFormat:@"%d",i]];
    }
    [_tztTradeTable setComBoxData:ayDate ayContent_:ayDate AndIndex_:0 withTag_:7000];
    DelObject(ayDate);
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
    
    if ([pParse IsAction:@"557"])
    {
        if(strError && [strError length] > 0)
        {
            [self showMessageBox:strError nType_:TZTBoxTypeNoButton nTag_:0];
        }
    }
    return 1;
}

-(BOOL)CheckInput
{
    NSString * nsCode = [_tztTradeTable GetLabelText:1000];
    if (nsCode == nil || [nsCode length] < 1)
    {
        [self showMessageBox:@"基金代码不能为空！" nType_:TZTBoxTypeNoButton nTag_:0];
        return FALSE;
    }
    
    if (self.nsGSDM == nil || [self.nsGSDM length] < 1)
    {
        [self showMessageBox:@"基金公司代码数据不正确！" nType_:TZTBoxTypeNoButton nTag_:0];
        return FALSE;
    }
    
    NSString *BLJE = [_tztTradeTable GetEidtorText:6000];
    if (BLJE == nil || [BLJE length] < 1)
    {
        [self showMessageBox:@"最低保存金额不能为空！" nType_:TZTBoxTypeNoButton nTag_:0];
        return FALSE;
    }
    
    NSString * Time = [_tztTradeTable getComBoxText:7000];
    if (Time == nil || [Time length] < 1)
    {
        [self showMessageBox:@"日期错误！" nType_:TZTBoxTypeNoButton nTag_:0];
        return FALSE;
    }
    
    NSString* strInfo = [NSString stringWithFormat:@"基金代码:%@\r\n基金名称:%@\r\n基金公司:%@\r\n资金账号:%@\r\n参与金额:%@\r\n参与日期:%@\r\n\r\n",nsCode,self.nsCodeName,self.nsGSMC,[_tztTradeTable GetLabelText:5000],BLJE,Time];
    
    [self showMessageBox:strInfo
                  nType_:TZTBoxTypeButtonBoth
                   nTag_:0x1111
               delegate_:self
              withTitle_:@"系统提示"
                   nsOK_:@"确定"
               nsCancel_:@"取消"];
    
    return TRUE;
    
}

-(void)OnSend
{
    
    if (_tztTradeTable == nil)
        return;
    
    NSString *BLJE = [_tztTradeTable GetEidtorText:6000];
    NSString * Time = [_tztTradeTable getComBoxText:7000];
    
    NSMutableDictionary *pDict = NewObject(NSMutableDictionary);
    
    _ntztReqNo++;
    if (_ntztReqNo >= UINT16_MAX)
        _ntztReqNo = 1;
    
    NSString *strReqno = tztKeyReqno((long)self, _ntztReqNo);
    [pDict setTztValue:strReqno forKey:@"Reqno"];
    [pDict setTztValue:_nsGSDM forKey:@"JJDJGSDM"];
    [pDict setTztValue:BLJE forKey:@"VOLUME"];
    [pDict setTztValue:_nsCode forKey:@"FUNDCODE"];
    [pDict setTztValue:Time forKey:@"SENDDAY"];
    if (_nType == 0)
    {
        [pDict setTztValue:@"A" forKey:@"OPERATION"];
    }
    else if(_nType == 1)
    {
        [pDict setTztValue:@"D" forKey:@"OPERATION"];
    }
    else
    {
        [pDict setTztValue:@"D" forKey:@"OPERATION"];
    }
    
    [[tztMoblieStockComm getShareInstance] onSendDataAction:@"557" withDictValue:pDict];
    DelObject(pDict);
    
    
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
                [self OnSend];
            }
                break;
                
            default:
                break;
        }
    }
}

-(void)OnButtonClick:(id)sender
{
    if (sender == NULL)
		return;
	tztUIButton * pButton = (tztUIButton*)sender;
	int nTag = [pButton.tzttagcode intValue];
    //zxl 20130711 添加了按钮确认处理方式
	if (nTag == 4001)
	{
        [self CheckInput];
    }
}

@end




