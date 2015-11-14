/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:        基金转换view
 * 文件标识:
 * 摘要说明:
 *
 * 当前版本:        2.0
 * 作    者:       yinjp
 * 更新日期:
 * 整理修改:
 *  zxl 20131128 增加份额
 ***************************************************************/

#import "tztFundZHView.h"

enum  {
    KTagFE = 1000,
	kTagCode = 2000,
    KTagZc = 3000,
    KTagZr = 3001,
    KTagKY = 6000,
};
@interface tztFundZHView(tztPrivate)
//请求股票信息
-(void)OnRefresh;
@end

@implementation tztFundZHView

@synthesize tztTradeTable = _tztTradeTable;
@synthesize ayZHCode = _ayZHCode;
@synthesize ayZHCompany = _ayZHCompany;
@synthesize ayZRCode =_ayZRCode;
@synthesize nsCurStock =_nsCurStock;
@synthesize ayKYFenE = _ayKYFenE;

-(id)init
{
    if (self = [super init])
    {
        [[tztMoblieStockComm getShareInstance] addObj:self];
        _ayZHCode = NewObject(NSMutableArray);
        _ayZRCode =  NewObject(NSMutableArray);
        _ayZHCompany = NewObject(NSMutableDictionary);
        _ayKYFenE = NewObject(NSMutableDictionary);
    }
    return self;
}

-(void)dealloc
{
    [[tztMoblieStockComm getShareInstance] removeObj:self];
    DelObject(_ayZHCode);
    DelObject(_ayZRCode);
    DelObject(_ayZHCompany);
    DelObject(_ayKYFenE);
    [super dealloc];
    
}

-(void)setFrame:(CGRect)frame
{
    if (CGRectIsEmpty(frame) || CGRectIsNull(frame))
        return;
    
    [super setFrame:frame];
    
    CGRect rcFrame = self.bounds;
    
    if (_tztTradeTable == nil)
    {
        _tztTradeTable = [[tztUIVCBaseView alloc] initWithFrame:rcFrame];
        _tztTradeTable.tztDelegate = self;
        [_tztTradeTable setTableConfig:@"tztUITradeFundZH"];
        [self addSubview:_tztTradeTable];
        [_tztTradeTable release];
    }
    else
    {
        _tztTradeTable.frame = rcFrame;
    }
}

-(void)OnSendRequestData
{
    [_ayZHCode removeAllObjects];
    [_ayZHCompany removeAllObjects];
    [_ayKYFenE removeAllObjects];
    
    NSMutableDictionary *pDict = NewObject(NSMutableDictionary);
    [pDict setTztValue:@"100" forKey:@"MaxCount"];
    [pDict setTztValue:@"1" forKey:@"StartPos"];
    
    _ntztReqNo++;
    if (_ntztReqNo >= UINT16_MAX)
        _ntztReqNo = 1;
    NSString* strReq = tztKeyReqno((long)self, _ntztReqNo);
    [pDict setTztValue:strReq forKey:@"Reqno"];
    [[tztMoblieStockComm getShareInstance] onSendDataAction:@"137" withDictValue:pDict];
    DelObject(pDict);
}

//清空界面数据
-(void) ClearData
{
    
}

- (void)tztUIBaseView:(UIView *)tztUIBaseView textchange:(NSString *)text
{
    if (tztUIBaseView == NULL || ![tztUIBaseView isKindOfClass:[tztUITextField class]])
        return;
    
    tztUITextField* inputField = (tztUITextField*)tztUIBaseView;
    switch ([inputField.tzttagcode intValue])
	{
		case kTagCode:
		{
			if (inputField.text != NULL && [inputField.text length] == 6)
			{
                self.nsCurStock = [NSString stringWithFormat:@"%@", inputField.text];
                [self OnRefresh];
			}
		}
			break;
		default:
			break;
	}
}

//请求股票信息
-(void)OnRefresh
{
    NSMutableDictionary *pDict = NewObject(NSMutableDictionary);
    [pDict setTztValue:self.nsCurStock forKey:@"FUNDCODE"];
    [pDict setTztValue:@"1" forKey:@"StartPos"];
    [pDict setTztValue:@"100" forKey:@"Maxcount"];
    
    _ntztReqNo++;
    if (_ntztReqNo > UINT16_MAX)
        _ntztReqNo = 1;
    
    NSString* strReqNo = tztKeyReqno((long)self, _ntztReqNo);
    [pDict setTztValue:strReqNo forKey:@"Reqno"];
    [[tztMoblieStockComm getShareInstance] onSendDataAction:@"145" withDictValue:pDict];
    DelObject(pDict);
}

//根据公司代码得到相应基金名称代码
-(void)getListByCompany:(NSString*)nsGSDM
{
    [_ayZRCode removeAllObjects];
    
    NSMutableDictionary *pDict = NewObject(NSMutableDictionary);
    [pDict setTztValue:nsGSDM forKey:@"Filename"];
    [pDict setTztValue:@"1" forKey:@"StartPos"];
    [pDict setTztValue:@"1" forKey:@"Direction"];
    
    _ntztReqNo++;
    if (_ntztReqNo > UINT16_MAX)
        _ntztReqNo = 1;
    
    NSString* strReqNo = tztKeyReqno((long)self, _ntztReqNo);
    [pDict setTztValue:strReqNo forKey:@"Reqno"];
    [[tztMoblieStockComm getShareInstance] onSendDataAction:@"10109" withDictValue:pDict];
    DelObject(pDict);
}


-(void)OnSend
{
    
    if (_tztTradeTable == nil)
        return;
    NSMutableDictionary *pDict = NewObject(NSMutableDictionary);
    
    _ntztReqNo++;
    if (_ntztReqNo >= UINT16_MAX)
        _ntztReqNo = 1;
    
    NSString *strReqno = tztKeyReqno((long)self, _ntztReqNo);
    [pDict setTztValue:strReqno forKey:@"Reqno"];
    [pDict setTztValue:[_ayZHCode objectAtIndex:[_tztTradeTable getComBoxSelctedIndex:KTagZc]] forKey:@"OFUNDCODE"];
    [pDict setTztValue:[_tztTradeTable GetEidtorText:KTagFE] forKey:@"VOLUME"];
    [pDict setTztValue:[_ayZRCode objectAtIndex:[_tztTradeTable getComBoxSelctedIndex:KTagZr]] forKey:@"IFUNDCODE"];
    [[tztMoblieStockComm getShareInstance] onSendDataAction:@"143" withDictValue:pDict];
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
    int JJDMIndex = -1;
    int JJMCIndex = -1;
    int JJGSDMIndex = -1;
    if ([pParse IsAction:@"145"])
    {
        if(strError && [strError length] > 0)
        {
            [self showMessageBox:strError nType_:TZTBoxTypeNoButton nTag_:0];
            return 1;
        }
        NSString* strIndex = [pParse GetByName:@"JJGSDM"];
        if (strIndex && [strIndex length] > 0)
            JJGSDMIndex = [strIndex intValue];
        NSArray *ayGrid = [pParse GetArrayByName:@"Grid"];
        NSString *JJGSDM = @"";
        for (int i = 0; i < [ayGrid count]; i++)
        {
            NSArray *ayData = [ayGrid objectAtIndex:i];
            if (ayData == NULL|| [ayData count] < 1 || JJGSDMIndex >= [ayData count] )
                continue;
            JJGSDM = [NSString stringWithFormat:@"%@",[ayData objectAtIndex:JJGSDMIndex]];
        }
        if (JJGSDM && [JJGSDM length] > 0)
        {
            [self getListByCompany:JJGSDM];
        }
    }
    
    if ([pParse IsAction:@"137"] || [pParse IsAction:@"10109"])
    {
        if(strError && [strError length] > 0)
        {
            [self showMessageBox:strError nType_:TZTBoxTypeNoButton nTag_:0];
            return 1;
        }
        //基础索引，所以放在此处
        NSString* strIndex = [pParse GetByName:@"JJDMINDEX"];
        if (strIndex && [strIndex length] > 0)
            JJDMIndex = [strIndex intValue];
        
        strIndex = [pParse GetByName:@"JJMCINDEX"];
        if (strIndex && [strIndex length] > 0)
            JJMCIndex = [strIndex intValue];
        
        strIndex = [pParse GetByName:@"JJGSDM"];
        if (strIndex && [strIndex length] > 0)
        {
            JJGSDMIndex = [strIndex intValue];
        }else
        {
            strIndex = [pParse GetByName:@"JJGSDMINDEX"];
            if (strIndex && [strIndex length] > 0)
                JJGSDMIndex = [strIndex intValue];
        }
        
        int KYindex = -1;
        strIndex = [pParse GetByName:@"JJKYIndex"];
        if (strIndex && [strIndex length] > 0)
            KYindex = [strIndex intValue];
        
        NSMutableArray * ayShow = NewObject(NSMutableArray);
        
        NSArray *ayGrid = [pParse GetArrayByName:@"Grid"];
        for (int i = 0; i < [ayGrid count]; i++)
        {
            NSArray *ayData = [ayGrid objectAtIndex:i];
            if (ayData == NULL|| [ayData count] < 1
                || JJDMIndex >= [ayData count] || JJMCIndex >= [ayData count] ||JJGSDMIndex >= [ayData count])
            {
                continue;
            }
            
            NSString *jjdm = [NSString stringWithFormat:@"%@",[ayData objectAtIndex:JJDMIndex]];
            if ([pParse IsAction:@"137"])
            {
                if (KYindex  < 0 || KYindex >= [ayData count])
                {
                    continue;
                }
                
                if(jjdm && [jjdm length] > 0)
                    [_ayZHCode addObject:jjdm];
                
                NSString *jjgsdm = [NSString stringWithFormat:@"%@",[ayData objectAtIndex:JJGSDMIndex]];
                if(jjgsdm && [jjgsdm length] > 0 && jjdm)
                    [_ayZHCompany setObject:jjgsdm forKey:jjdm];
                
                NSString *jjKeY = [NSString stringWithFormat:@"%@",[ayData objectAtIndex:KYindex]];
                if(jjKeY && [jjKeY length] > 0)
                    [_ayKYFenE setObject:jjKeY forKey:jjdm];
                
            }
            
            if ([pParse IsAction:@"10109"])
            {
                if(jjdm && [jjdm length] > 0)
                    [_ayZRCode addObject:jjdm];
            }
            
            NSString *jjmc = [NSString stringWithFormat:@"%@",[ayData objectAtIndex:JJMCIndex]];
            if (jjmc && [jjmc length] > 0)
            {
                jjmc = [NSString stringWithFormat:@"%@(%@)",jjdm,jjmc];
                [ayShow addObject:jjmc];
            }
        }
        if ([pParse IsAction:@"137"])
        {
            [_tztTradeTable setComBoxData:ayShow ayContent_:ayShow AndIndex_:0 withTag_:KTagZc bDrop_:TRUE];
        }
        if ([pParse IsAction:@"10109"])
        {
            [_tztTradeTable setComBoxData:ayShow ayContent_:ayShow AndIndex_:0 withTag_:KTagZr];
        }
        DelObject(ayShow);
    }
    if ([pParse IsAction:@"143"])
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
    NSInteger indexZC = [_tztTradeTable getComBoxSelctedIndex:KTagZc];
    if (indexZC >= [_ayZHCode count])
        return FALSE;
//  　zxl　20131203　　修过获取转出基金代码
    NSString *zccode = [_ayZHCode objectAtIndex:indexZC];
    if (zccode == nil || [zccode length] < 1)
    {
        [self showMessageBox:@"转出基金代码不能为空！" nType_:TZTBoxTypeNoButton nTag_:0];
        return FALSE;
    }
    NSInteger index = [_tztTradeTable getComBoxSelctedIndex:KTagZr];
    if (index >= [_ayZRCode count])
        return FALSE;
    
    NSString *zrcode = [_ayZRCode objectAtIndex:index];
    if (zrcode == nil || [zrcode length] < 1)
    {
        [self showMessageBox:@"转入基金代码不能为空！" nType_:TZTBoxTypeNoButton nTag_:0];
        return FALSE;
    }
    NSString *volumn = [_tztTradeTable GetEidtorText:KTagFE];
    if (volumn == nil || [volumn length] < 1)
    {
        [self showMessageBox:@"转换份额不能为空！" nType_:TZTBoxTypeNoButton nTag_:0];
        return FALSE;
    }
    
    NSString* strInfo = [NSString stringWithFormat:@"转出基金代码:%@\r\n转入基金代码:%@\r\n委托数量:%@\r\n\r\n",zccode,zrcode,volumn];
    
    [self showMessageBox:strInfo
                  nType_:TZTBoxTypeButtonBoth
                   nTag_:0x1111
               delegate_:self
              withTitle_:@"基金转换"
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

//zxl 20131128 增加ipad点击处理
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        switch (alertView.tag)
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

-(void)OnButton:(id)sender
{
    
}

//选中列表数据
- (void)tztDroplistView:(tztUIDroplistView *)droplistview didSelectIndex:(NSInteger)index
{
    if ([droplistview.tzttagcode compare:[NSString stringWithFormat:@"%d",KTagZc]] ==  NSOrderedSame)
    {
        if (index >= [_ayZHCode count])
            return;
        
        NSString *Code = [_ayZHCode objectAtIndex:index];
        [_tztTradeTable setEditorText:Code nsPlaceholder_:NULL withTag_:kTagCode];
        self.nsCurStock  = [NSString stringWithFormat:@"%@",Code];
        
        NSString *keYong = [_ayKYFenE tztValueForKey: self.nsCurStock];
        [_tztTradeTable setLabelText:keYong withTag_:KTagKY];
        [self OnRefresh];
    }
    
}
- (void)tztDroplistViewGetData:(tztUIDroplistView*)droplistview
{
    if ([droplistview.tzttagcode compare:[NSString stringWithFormat:@"%d",KTagZc]] ==  NSOrderedSame)
    {
        if ([droplistview.ayData count] < 1 || [droplistview.ayValue count] < 1)
        {
            [self OnSendRequestData];//获取持仓 即可转换基金
        }
    }
    return;
}
-(void)OnButtonClick:(id)sender
{
    if (sender == NULL)
		return;
	tztUIButton * pButton = (tztUIButton*)sender;
	int nTag = [pButton.tzttagcode intValue];
    //zxl 20130711 添加了按钮确认处理方式
	if (nTag == 5001)
	{
        [self ClearData];
    }
    
    if (nTag == 5000)
	{
        [self CheckInput];
    }
}
@end




