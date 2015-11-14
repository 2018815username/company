//
//  TZTFundCashProdSignView.m
//  tztMobileApp
//
//  Created by deng wei on 13-3-18.
//  Copyright (c) 2013年 中焯. All rights reserved.
//

#import "TZTFundCashProdSignView.h"
enum  {
	kTagCode = 1000,
    kTagName = 2000,
    kTagGSName = 3000,
    kTagKHName = 4000,
    kTagZJAccount = 5000,
    kTagMobileCode = 6000,
    kTagKHNameEmail = 7000,
    kTagBCJE = 8000,
};
@interface TZTFundCashProdSignView(tztPrivate)
//请求股票信息
-(void)OnRefresh;
@end

@implementation TZTFundCashProdSignView
@synthesize nsGSDM = _nsGSDM;
@synthesize nsGSMC = _nsGSMC;
@synthesize nsCode = _nsCode;
@synthesize nsCodeName = _nsCodeName;
@synthesize nType = _nType;
@synthesize tztTradeTable = _tztTradeTable;
@synthesize nsPhone = _nsPhone;
@synthesize nsEmail = _nsEmail;
@synthesize nsLowmat = _nsLowmat;

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
        [_tztTradeTable setTableConfig:@"tztUITradeFundXJCP"];
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
    [_tztTradeTable setLabelText:self.nsCode withTag_:1000];
    [_tztTradeTable setLabelText:self.nsCodeName withTag_:2000];
    [_tztTradeTable setLabelText:self.nsGSMC withTag_:3000];
    [_tztTradeTable setEditorText:self.nsEmail nsPlaceholder_:nil withTag_:7000];
    [_tztTradeTable setEditorText:self.nsPhone nsPlaceholder_:nil withTag_:6000];
    [_tztTradeTable setEditorText:self.nsLowmat nsPlaceholder_:nil withTag_:8000];
    
    tztJYLoginInfo *CurInfo = [tztJYLoginInfo GetCurJYLoginInfo:TZTAccountPTType];
    if (CurInfo)
    {
        [_tztTradeTable setLabelText:CurInfo.nsUserName withTag_:4000];
        [_tztTradeTable setLabelText:CurInfo.nsAccount withTag_:5000];
    }
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
    
    if ([pParse IsAction:@"555"])
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
    
    NSString *Phone = [_tztTradeTable GetEidtorText:6000];
    if (Phone == nil || [Phone length] < 1)
    {
        [self showMessageBox:@"手机号码不能为空！" nType_:TZTBoxTypeNoButton nTag_:0];
        return FALSE;
    }
    
    NSString *Email = [_tztTradeTable GetEidtorText:7000];
    if (Email == nil || [Email length] < 1)
    {
        [self showMessageBox:@"电子邮箱不能为空！" nType_:TZTBoxTypeNoButton nTag_:0];
        return FALSE;
    }
    
    NSString *BLJE = [_tztTradeTable GetEidtorText:8000];
    if (BLJE == nil || [BLJE length] < 1)
    {
        [self showMessageBox:@"最低保存金额不能为空！" nType_:TZTBoxTypeNoButton nTag_:0];
        return FALSE;
    }
    
    NSString* strInfo = [NSString stringWithFormat:@"基金代码:%@\r\n基金名称:%@\r\n基金公司:%@\r\n资金账号:%@\r\n手机号码:%@\r\n电子邮箱:%@\r\n最低保存金额:%@\r\n\r\n",nsCode,self.nsCodeName,self.nsGSMC,[_tztTradeTable GetLabelText:5000],Phone,Email,BLJE];;
    
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
    NSString *Phone = [_tztTradeTable GetEidtorText:6000];
    NSString *Email = [_tztTradeTable GetEidtorText:7000];
    NSString *BLJE = [_tztTradeTable GetEidtorText:8000];
    
    if (_tztTradeTable == nil)
        return;
    NSMutableDictionary *pDict = NewObject(NSMutableDictionary);
    
    _ntztReqNo++;
    if (_ntztReqNo >= UINT16_MAX)
        _ntztReqNo = 1;
    
    NSString *strReqno = tztKeyReqno((long)self, _ntztReqNo);
    [pDict setTztValue:strReqno forKey:@"Reqno"];
    [pDict setTztValue:self.nsGSDM forKey:@"JJDJGSDM"];
    [pDict setTztValue:BLJE forKey:@"LOWAMT"];
    [pDict setTztValue:self.nsCode forKey:@"FUNDCODE"];
    [pDict setTztValue:Phone forKey:@"MOBILETELPHONE"];
    [pDict setTztValue:Email forKey:@"JJEMAIL"];
    if (_nType == 0)
    {
        [pDict setTztValue:@"A" forKey:@"OPERATION"];
    }
    else if(_nType == 1)
    {
        [pDict setTztValue:@"U" forKey:@"OPERATION"];
    }
    else
    {
        [pDict setTztValue:@"D" forKey:@"OPERATION"];
    }
    
    [[tztMoblieStockComm getShareInstance] onSendDataAction:@"555" withDictValue:pDict];
    
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




