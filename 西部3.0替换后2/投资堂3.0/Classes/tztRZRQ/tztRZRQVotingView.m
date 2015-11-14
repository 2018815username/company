/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:        融资融券投票
 * 文件标识:
 * 摘要说明:
 *
 * 当前版本:        2.0
 * 作    者:       yinjp
 * 更新日期:
 * 整理修改:
 *
 ***************************************************************/

#import "tztRZRQVotingView.h"

extern tztJYLoginInfo   *g_curJYLoginInfo;

@implementation tztRZRQVotingView
@synthesize tztTableView = _tztTableView;
@synthesize CurStockCode = _CurStockCode;
@synthesize ayAccount = _ayAccount;
@synthesize ayType = _ayType;
-(id) init
{
    if (self = [super init])
    {
        _fMoveStep = 100;
        _nDotValid = 2;
        _ayAccount = NewObject(NSMutableArray);
        _ayType = NewObject(NSMutableArray);
        [[tztMoblieStockComm getShareInstance] addObj:self];
    }
    return self;
}

-(void)dealloc
{
    [[tztMoblieStockComm getShareInstance] removeObj:self];
    DelObject(_ayAccount);
    DelObject(_ayType);
    [super dealloc];
}

-(void)setFrame:(CGRect)frame
{
    if (CGRectIsNull(frame) || CGRectIsEmpty(frame))
        return;
    
    [super setFrame:frame];
    CGRect rcFrame = self.bounds;
    rcFrame.origin = CGPointZero;
    if (_tztTableView == NULL)
    {
        _tztTableView = NewObject(tztUIVCBaseView);
        _tztTableView.tztDelegate = self;
        _tztTableView.tableConfig = @"tztRZRQVotingSetting";
        _tztTableView.frame = rcFrame;
        [self addSubview:_tztTableView];
        [_tztTableView release];
    }else
        _tztTableView.frame = rcFrame;
}

- (void)tztUIBaseView:(UIView *)tztUIBaseView textchange:(NSString *)text
{
    if (tztUIBaseView == NULL || ![tztUIBaseView isKindOfClass:[tztUITextField class]])
        return;
    
    tztUITextField* inputField = (tztUITextField*)tztUIBaseView;
    if ([inputField.tzttagcode intValue] == 2000)
    {
        if (self.CurStockCode == NULL)
            self.CurStockCode = @"";
        if ([inputField.text length] <= 0)
        {
            self.CurStockCode = @"";
            //清空界面其它数据
        }
        
        if (inputField.text != NULL)
        {
            self.CurStockCode = [NSString stringWithFormat:@"%@", inputField.text];
        }
        
        if ([self.CurStockCode length] == 6)
        {
            [self OnRefresh];
        }
    }
}


-(void)OnRefresh
{
    NSString* nsCode = [_tztTableView GetEidtorText:2000];
    if (nsCode == NULL || [nsCode length] != 6)
    {
        [self showMessageBox:@"请输入正确的证券代码!" nType_:TZTBoxTypeNoButton nTag_:0];
        return;
    }
    
    NSMutableDictionary *pDict = NewObject(NSMutableDictionary);
    [pDict setTztValue:nsCode forKey:@"StockCode"];
    [pDict setTztValue:@"1" forKey:@"StartPos"];
    [pDict setTztValue:@"1" forKey:@"NeedCheck"];
    [pDict setTztValue:@"100" forKey:@"MaxCount"];
    [pDict setTztValue:@"1" forKey:@"CommBatchEntrustInfo"];
    [pDict setTztValue:@"4" forKey:@"CREDITTYPE"];
    [pDict setTztValue:@"S" forKey:@"Direction"];
    
    _ntztReqNo++;
    if (_ntztReqNo > UINT16_MAX)
        _ntztReqNo = 1;
    
    NSString* strReqNo = tztKeyReqno((long)self, _ntztReqNo);
    [pDict setTztValue:strReqNo forKey:@"Reqno"];
    [pDict setTztObject:[NSString stringWithFormat:@"%d",TZTAccountRZRQType] forKey:tztTokenType];
    [[tztMoblieStockComm getShareInstance] onSendDataAction:@"429" withDictValue:pDict];
    DelObject(pDict);
}
-(void)OnButtonClick:(id)sender
{
    tztUIButton *button = (tztUIButton *)sender;
    if ([button.tzttagcode intValue] == 4000)
    {
        [self OnOK:NO];
    }
}
-(void)OnOK:(BOOL)bFlag
{
    //股票代码
    NSString* nsCode = [_tztTableView GetEidtorText:2000];
    if (nsCode == NULL || [nsCode length] < 6)
        return;
    //价格
    NSString* nsPrice = [_tztTableView GetEidtorText:2001];
    if (nsPrice == NULL || [nsPrice length] < 1)
        return;
    //委托数量
    NSString* nsAmount = [_tztTableView GetEidtorText:2002];
    if (nsAmount == NULL || [nsAmount length] < 1)
        return;
    //委托账号及类型
    NSString* nsAccount = [_tztTableView getComBoxText:1000];
    if (nsAccount == NULL || [nsAccount length] < 1)
        return;
    NSInteger select = [_tztTableView getComBoxSelctedIndex:1000];
    if (select >= [_ayType count])
        return;
    NSString* nsAccountType = [_ayType objectAtIndex:select];
    if (nsAccountType == NULL || [nsAccountType length] < 1)
        return;
    
    if (!bFlag)//提示客户确认信息
    {
        NSString* str = [NSString stringWithFormat:@"委托账号:%@\r\n证券代码:%@\r\n投票价格:%@\r\n委托数量:%@\r\n\r\n确认投票?",
                         nsAccount, nsCode, nsPrice, nsAmount];
        
        [self showMessageBox:str
                      nType_:TZTBoxTypeButtonBoth
                       nTag_:1024
                   delegate_:self
                  withTitle_:@"客户投票"
                       nsOK_:@"投票"
                   nsCancel_:@"取消"];
        return;
    }
    else//发送请求
    {
        NSMutableDictionary *pDict = NewObject(NSMutableDictionary);
        
        [pDict setTztValue:nsCode forKey:@"StockCode"];
        [pDict setTztValue:nsPrice forKey:@"Price"];
        [pDict setTztValue:nsAmount forKey:@"Volume"];
        [pDict setTztValue:nsAccount forKey:@"WTACCOUNT"];
        [pDict setTztValue:nsAccountType forKey:@"WTACCOUNTTYPE"];
        
        _ntztReqNo++;
        if (_ntztReqNo > UINT16_MAX)
            _ntztReqNo = 1;
        
        NSString* strReqNo = tztKeyReqno((long)self, _ntztReqNo);
        [pDict setTztValue:strReqNo forKey:@"Reqno"];
        [pDict setTztObject:[NSString stringWithFormat:@"%d",TZTAccountRZRQType] forKey:tztTokenType];
        [[tztMoblieStockComm getShareInstance] onSendDataAction:@"440" withDictValue:pDict];
        DelObject(pDict);
    }
}
// zxl 20131128 ipad 添加点击处理
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        switch (alertView.tag)
        {
            case 1024:
            {
                [self OnOK:YES];
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
            case 1024:
            {
                [self OnOK:YES];
            }
                break;
                
            default:
                break;
        }
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
            [self showMessageBox:strError nType_:TZTBoxTypeNoButton nTag_:0];
        return 0;
    }
    
    if (nErrNo && strError)
    {
        [self showMessageBox:strError nType_:TZTBoxTypeNoButton nTag_:0];
        return 0;
    }
    
    if ([pParse IsAction:@"151"] || [pParse IsAction:@"429"])
    {
        [self dealInquireStock:pParse];
        return 1;
    }
    
    if (strError)
        [self showMessageBox:strError nType_:TZTBoxTypeNoButton nTag_:0];
    
    return 1;
}

-(void)dealInquireStock:(tztNewMSParse*)pParse
{
    if (pParse == NULL)
        return;
    NSString* strCode = [pParse GetByName:@"StockCode"];
    if (strCode == NULL || [strCode length] <= 0)//错误
        return;
    //返回的跟当前的代码不一致
    if ([strCode compare:self.CurStockCode] != NSOrderedSame)
    {
        return;
    }
    
    //股票名称 // // 不做判断 byDBQ20131011
    NSString* strName = [pParse GetByNameUnicode:@"Title"];
//    if (strName && [strName length] > 0)
    {
        if (_tztTableView)
        {
            [_tztTableView setLabelText:strName withTag_:3000];
        }
    }
//    else
//    {
//        [self showMessageBox:@"该股票代码不存在!" nType_:TZTBoxTypeNoButton nTag_:0];
//        return;
//    }
    
    NSArray *pAy = [pParse GetArrayByName:@"Grid"];
    if (pAy == NULL || [pAy count] <= 0)
        return;
    [_ayAccount removeAllObjects];
    [_ayType removeAllObjects];
    for (int i = 0; i < [pAy count]; i++)
    {
        NSArray *ayData = [pAy objectAtIndex:i];
        if (ayData == NULL || [ayData count] < 3)
            continue;
        
        NSString* strAccount = [ayData objectAtIndex:0];
        if (strAccount == NULL || [strAccount length] <= 0)
            continue;
        
        [_ayAccount addObject:strAccount];
        
        NSString* strType = [ayData objectAtIndex:1];
        if (strType == NULL || [strType length] <= 0)
            strType = @"";
        
        [_ayType addObject:strType];
    }
    [_tztTableView setComBoxData:_ayAccount ayContent_:_ayType AndIndex_:0 withTag_:1000];
}

@end
