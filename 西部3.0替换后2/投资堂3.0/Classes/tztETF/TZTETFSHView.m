//
//  TZTETFSHView.m
//  tztMobileApp_XCSC_iPad
//
//  Created by 在琦中 on 13-10-30.
//
//

#import "TZTETFSHView.h"

@implementation TZTETFSHView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    _ptztCrashTable.tableConfig = @"tztTradeETF_SHViewSetting";
}

-(void)OnSendBuySell
{
    if (_ptztCrashTable == nil)
        return;
    
    NSInteger nIndex = [_ptztCrashTable getComBoxSelctedIndex:kTagETFGDDm];
    if (nIndex < 0 || nIndex >= [_ayAccount count] || nIndex >= [_ayType count])
        return ;
    
    NSString* nsAccount = [_ayAccount objectAtIndex:nIndex];
    NSString* nsAccountType = [_ayType objectAtIndex:nIndex];
    
    //ETF代码
    NSString *nsCode = [_ptztCrashTable GetEidtorText:kTagETFCode];
    if (nsCode == NULL || [nsCode length] < 1)
        return;
    
    //委托数量
    NSString* nsAmount = [_ptztCrashTable GetEidtorText:kTagETFRGFE];
    if (nsAmount == NULL || [nsAmount length] < 1 || [nsAmount intValue] < 1)
    {
        [self showMessageBox:@"认购份额输入有误!" nType_:TZTBoxTypeNoButton nTag_:0];
        return ;
    }
    //NSString *nsPrice = [_ptztCrashTable GetLabelText:kTagETFKYZJ];
    self.CurStockCode = nsCode;
    NSMutableDictionary *pDict = NewObject(NSMutableDictionary);
    
    _ntztReqNo++;
    if (_ntztReqNo >= UINT16_MAX)
        _ntztReqNo = 1;
    
    NSString *strReqno = tztKeyReqno((long)self, _ntztReqNo);
    [pDict setTztValue:strReqno forKey:@"Reqno"];
    [pDict setTztValue:nsAccount forKey:@"WTAccount"];
    [pDict setTztValue:nsAccountType forKey:@"WTAccountType"];
    [pDict setTztValue:nsCode forKey:@"StockCode"];
    [pDict setTztValue:nsAmount forKey:@"VOLUME"];
    [pDict setTztValue:@"1" forKey:@"Price"];
    [pDict setTztValue:@"N" forKey:@"PriceType"];
    [pDict setTztValue:@"S" forKey:@"DIRECTION"];
    [[tztMoblieStockComm getShareInstance] onSendDataAction:@"110" withDictValue:pDict];
    
    DelObject(pDict);
    
}

@end
