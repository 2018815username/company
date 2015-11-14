/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:        用户基本信息修改
 * 文件标识:
 * 摘要说明:
 *
 * 当前版本:        2.0
 * 作    者:       yinjp
 * 更新日期:
 * 整理修改:
 *
 ***************************************************************/

#import "tztUIChangeUserInfoView.h"

@implementation tztUIChangeUserInfoView
@synthesize tztTradeTable = _tztTradeTable;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

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
    if (_tztTradeTable == NULL)
    {
        _tztTradeTable = [[tztUIVCBaseView alloc] initWithFrame:rcFrame];
        _tztTradeTable.tztDelegate = self;
        [_tztTradeTable setTableConfig:@"tztUITradeUserInfo"];
        [self addSubview:_tztTradeTable];
        [_tztTradeTable release];
    }
    else
    {
        _tztTradeTable.frame = rcFrame;
    }
}

//请求数据
-(void)OnRequestData
{
    NSMutableDictionary* pDict = NewObject(NSMutableDictionary);
    
    _ntztReqNo++;
    if (_ntztReqNo >= UINT16_MAX)
        _ntztReqNo = 1;
    NSString* strReqno = tztKeyReqno((long)self, _ntztReqNo);
    
    [pDict setTztObject:strReqno forKey:@"Reqno"];
    [[tztMoblieStockComm getShareInstance] onSendDataAction:@"187" withDictValue:pDict];
    DelObject(pDict);
}

-(NSUInteger)OnCommNotify:(NSUInteger)wParam lParam_:(NSUInteger)lParam
{
    tztNewMSParse* pParse = (tztNewMSParse*)wParam;
    if (pParse == NULL)
        return 0;
    
    if (![pParse IsIphoneKey:(long)self reqno:_ntztReqNo])
        return 0;
    
    int nErrno = [pParse GetErrorNo];
    NSString* strErrMsg = [pParse GetErrorMessage];
    
    if (nErrno < 0)
    {
        if (strErrMsg)
            [self showMessageBox:strErrMsg nType_:TZTBoxTypeNoButton delegate_:NULL];
        return 0;
    }
    
    if ([pParse IsAction:@"187"])
    {
        //
        int nUserNameIndex = -1;
        int nMobilePhoneIndex = -1;
        int nTelePhoneIndex = -1;
        int nPostIndex = -1;
        int nEMailIndex = -1;
        int nAddressIndex = -1;
        
        NSString* strIndex = [pParse GetByName:@"UserNameIndex"];
        TZTStringToIndex(strIndex, nUserNameIndex);
        
        strIndex = [pParse GetByName:@"MobilePhoneIndex"];
        TZTStringToIndex(strIndex, nMobilePhoneIndex);
        
        strIndex = [pParse GetByName:@"TelePhoneIndex"];
        TZTStringToIndex(strIndex, nTelePhoneIndex);
        
        strIndex = [pParse GetByName:@"PostIndex"];
        TZTStringToIndex(strIndex, nPostIndex);
        
        strIndex = [pParse GetByName:@"EMailIndex"];
        TZTStringToIndex(strIndex, nEMailIndex);
        
        strIndex = [pParse GetByName:@"AddressIndex"];
        TZTStringToIndex(strIndex, nAddressIndex);
        
        NSArray *pGridAy = [pParse GetArrayByName:@"Grid"];
        for (int i = 1; i < [pGridAy count]; i++)
        {
            NSArray *ayData = [pGridAy objectAtIndex:i];
            if (ayData == NULL || [ayData count] <= 0)
                continue;
            
            if (nUserNameIndex >= 0 && nUserNameIndex < [ayData count])
            {
                NSString* strUserName = [ayData objectAtIndex:nUserNameIndex];
                if (strUserName)
                {
                    [_tztTradeTable setLabelText:strUserName withTag_:1000];
                }
            }
            
            if (nMobilePhoneIndex >= 0 && nMobilePhoneIndex < [ayData count])
            {
                NSString* strMobile = [ayData objectAtIndex:nMobilePhoneIndex];
                if (strMobile)
                {
                    [_tztTradeTable setEditorText:strMobile nsPlaceholder_:NULL withTag_:2000];
                }
            }
            
            if (nTelePhoneIndex >= 0 && nTelePhoneIndex < [ayData count])
            {
                NSString* strTel = [ayData objectAtIndex:nTelePhoneIndex];
                if (strTel)
                {
                    [_tztTradeTable setEditorText:strTel nsPlaceholder_:NULL withTag_:2001];
                }
            }
            
            if (nPostIndex >= 0 && nPostIndex < [ayData count])
            {
                NSString* strPost = [ayData objectAtIndex:nPostIndex];
                if (strPost)
                {
                    [_tztTradeTable setEditorText:strPost nsPlaceholder_:NULL withTag_:2002];
                }
            }
            
            if (nEMailIndex >= 0 && nEMailIndex < [ayData count])
            {
                NSString* strEmail = [ayData objectAtIndex:nEMailIndex];
                if (strEmail)
                {
                    [_tztTradeTable setEditorText:strEmail nsPlaceholder_:NULL withTag_:2003];
                }
            }
            if (nAddressIndex >= 0 && nAddressIndex < [ayData count])
            {
                NSString* strAdd = [ayData objectAtIndex:nAddressIndex];
                if (strAdd)
                {
                    [_tztTradeTable setEditorText:strAdd nsPlaceholder_:NULL withTag_:2004];
                }
            }
        }
        
    }
    
    if ([pParse IsAction:@"185"])
    {
        if (strErrMsg)
        {
            [self showMessageBox:strErrMsg nType_:TZTBoxTypeNoButton delegate_:NULL];
        }
    }
    return 1;
}

-(void)OnChangeInfo
{
    if (_tztTradeTable == NULL)
        return;
    
    NSString* strMobile = [_tztTradeTable GetEidtorText:2000];
    if (!ISNSStringValid(strMobile))
    {
        [self showMessageBox:@"请输入手机号码!" nType_:TZTBoxTypeNoButton delegate_:nil];
        return;
    }
    if (!ISMobileCodeValid(strMobile))
    {
        [self showMessageBox:@"手机号码输入不正确!" nType_:TZTBoxTypeNoButton delegate_:nil];
        return;
    }
    NSString* strTel = [_tztTradeTable GetEidtorText:2001];
    if (!ISNSStringValid(strTel))
    {
        [self showMessageBox:@"请输入联系电话!" nType_:TZTBoxTypeNoButton delegate_:nil];
        return;
    }
    NSString* strZip = [_tztTradeTable GetEidtorText:2002];
    if (!ISNSStringValid(strZip))
    {
        [self showMessageBox:@"请输入邮政编码!" nType_:TZTBoxTypeNoButton delegate_:nil];
        return;
    }
    NSString* strEmail = [_tztTradeTable GetEidtorText:2003];
    if (!ISNSStringValid(strEmail))
    {
        [self showMessageBox:@"请输入Email!" nType_:TZTBoxTypeNoButton delegate_:nil];
        return;
    }
    if (!ISEmailValid(strEmail))
    {
        [self showMessageBox:@"EMail输入不正确!" nType_:TZTBoxTypeNoButton delegate_:nil];
        return;
    }
    
    NSString* strAdd  = [_tztTradeTable GetEidtorText:2004];
    if (!ISNSStringValid(strAdd))
    {
        [self showMessageBox:@"请输入地址!" nType_:TZTBoxTypeNoButton delegate_:nil];
        return;
    }
    
    NSMutableDictionary *pDict = NewObject(NSMutableDictionary);
    
    _ntztReqNo++;
    if (_ntztReqNo >= UINT32_MAX)
        _ntztReqNo = 1;
    
    NSString* strReqno = tztKeyReqno((long)self, _ntztReqNo);
    [pDict setTztObject:strReqno forKey:@"Reqno"];
    
    if (strMobile)
        [pDict setTztObject:strMobile forKey:@"MOBILETELPHONE"];
    if (strTel)
        [pDict setTztObject:strTel forKey:@"PHONECODE"];
    if (strZip)
        [pDict setTztObject:strZip forKey:@"zipcode"];
    if (strEmail)
        [pDict setTztObject:strEmail forKey:@"EMAIL"];
    if (strAdd)
        [pDict setTztObject:strAdd forKey:@"Title"];
    
    
    [[tztMoblieStockComm getShareInstance] onSendDataAction:@"185" withDictValue:pDict];
    DelObject(pDict);
}

-(BOOL)OnToolbarMenuClick:(id)sender
{
    UIButton* pBtn = (UIButton*)sender;
    switch (pBtn.tag)
    {
        case TZTToolbar_Fuction_OK:
        {
            [self OnChangeInfo];
            return TRUE;
        }
            break;
            
        default:
            break;
    }
    return FALSE;
}

@end
