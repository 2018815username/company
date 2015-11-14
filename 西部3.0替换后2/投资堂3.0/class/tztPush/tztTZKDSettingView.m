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

#import "tztTZKDSettingView.h"

@implementation tztTZKDSettingView
@synthesize pVCBaseView = _pVCBaseView;
@synthesize nsTime = _nsTime;
@synthesize nsServer = _nsServer;

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
        //获取
        UIRemoteNotificationType type = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
        if ((type & UIRemoteNotificationTypeNone) == UIRemoteNotificationTypeNone)
        {
            _bReceive = FALSE;
        }
        if ((type & UIRemoteNotificationTypeSound) == UIRemoteNotificationTypeSound)
        {
            _bSound = TRUE;
        }
    }
    return self;
}

-(void)dealloc
{
    [[tztMoblieStockComm getShareInstance] removeObj:self];
    [super dealloc];
}

-(void) setFrame:(CGRect)frame
{
    if (CGRectIsNull(frame) || CGRectIsEmpty(frame))
        return;
    
    [super setFrame:frame];
    CGRect rcFrame = self.bounds;

    if (_pVCBaseView == nil)
    {
        _pVCBaseView = [[tztUIVCBaseView alloc] initWithFrame:rcFrame];
        _pVCBaseView.tztDelegate = self;
        [_pVCBaseView setTableConfig:@"tztUITZKDSet"];
        [self addSubview:_pVCBaseView];
        [_pVCBaseView release];
    }
    else
    {
        _pVCBaseView.frame = rcFrame;
    }
    
    
    [_pVCBaseView setLabelText:[[TZTServerListDeal getShareClass] GetJYAddress] withTag_:5000];
}


//获取推送时间
-(void)RequestPushTime
{
    NSMutableDictionary *pDict = NewObject(NSMutableDictionary);
    _ntztReqNo++;
    if (_ntztReqNo >= UINT16_MAX)
        _ntztReqNo = 1;
    NSString *strReqno = tztKeyReqno((long)self, _ntztReqNo);
    [pDict setTztValue:strReqno forKey:@"Reqno"];
    [[tztMoblieStockComm getShareInstance] onSendDataAction:@"41037" withDictValue:pDict];
    DelObject(pDict);
}

//设置推送时间
-(void)SetPushTime
{
    NSMutableDictionary *pDict = NewObject(NSMutableDictionary);
    _ntztReqNo++;
    if (_ntztReqNo >= UINT16_MAX)
        _ntztReqNo = 1;
    NSString *strReqno = tztKeyReqno((long)self, _ntztReqNo);
    [pDict setTztValue:strReqno forKey:@"Reqno"];
    NSString* strBegin = [_pVCBaseView getComBoxText:2000];
    if (strBegin == NULL || [strBegin length] < 5)
        strBegin = @"08:00";
    NSString* strEnd = [_pVCBaseView getComBoxText:2001];
    if (strEnd == NULL || [strEnd length] < 5)
        strEnd = @"20:00";
    
    NSArray *pAy = [strBegin componentsSeparatedByString:@":"];
    strBegin = [NSString stringWithFormat:@"%02d%02d", [[pAy objectAtIndex:0] intValue], [[pAy objectAtIndex:1] intValue]];
    
    pAy = [strEnd componentsSeparatedByString:@":"];
    strEnd = [NSString stringWithFormat:@"%02d%02d", [[pAy objectAtIndex:0] intValue], [[pAy objectAtIndex:1] intValue]];
//    strBegin = @"0500";
//    strEnd = @"1300";
    
    [pDict setTztObject:strBegin forKey:@"begindate"];
    [pDict setTztObject:strEnd forKey:@"enddate"];
    [[tztMoblieStockComm getShareInstance] onSendDataAction:@"41034" withDictValue:pDict];
    DelObject(pDict);
}

-(NSUInteger)OnCommNotify:(NSUInteger)wParam lParam_:(NSUInteger)lParam
{
    tztNewMSParse *pParse = (tztNewMSParse*)wParam;
    if (pParse == NULL)
        return 0;
    
    if (![pParse IsIphoneKey:(long)self reqno:_ntztReqNo])
        return 0;
    
    if ([pParse IsAction:@"41037"])
    {
        NSString* nsBeginTime = [pParse GetByName:@"begindate"];
        NSString* nsEndTime = [pParse GetByName:@"enddate"];
        
        if (nsBeginTime == NULL || [nsBeginTime length] <= 0)
            nsBeginTime = @"0800";
        if (nsEndTime == NULL || [nsEndTime length] <= 0)
            nsEndTime = @"2000";
        
        int nBeginH = [nsBeginTime intValue] / 100;
        int nBeginM = [nsBeginTime intValue] % 100;
        
        nsBeginTime = [NSString stringWithFormat:@"%02d:%02d", nBeginH, nBeginM];
        
        int nEndH = [nsEndTime intValue] / 100;
        int nEndM = [nsEndTime intValue] % 100;
        nsEndTime = [NSString stringWithFormat:@"%02d:%02d", nEndH, nEndM];
        
        if (_pVCBaseView)
        {
            [_pVCBaseView setComBoxText:nsBeginTime withTag_:2000];
            [_pVCBaseView setComBoxText:nsEndTime withTag_:2001];
        }
    }
    if ([pParse IsAction:@"41034"])
    {
        NSString* strMsg = [pParse GetErrorMessage];
        [self showMessageBox:strMsg nType_:TZTBoxTypeNoButton delegate_:nil];
    }
    
    return 0;
}

-(void)OnButtonClick:(id)sender
{
    tztUIButton *btn = (tztUIButton*)sender;
    switch ([btn.tzttagcode intValue])
    {
        case 6000:
        {
            [self SetPushTime];
        }
            break;
        case 6001:
        {
            [g_navigationController popViewControllerAnimated:UseAnimated];
        }
            break;
        default:
            break;
    }
}
@end
