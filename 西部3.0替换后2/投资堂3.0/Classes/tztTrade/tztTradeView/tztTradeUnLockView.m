//
//  tztTradeLockView.m
//  tztMobileApp_yyz
//
//  Created by 张 小龙 on 13-5-22.
//
//

#import "tztTradeUnLockView.h"
#import "TZTUserInfoDeal.h"
#import "tztUIAddTokenViewController.h"

extern tztJYLoginInfo *g_pCurJYLoginInfo;

@implementation tztTradeUnLockView
@synthesize tztTableView = _tztTableView;
@synthesize pCurZJInfo = _pCurZJInfo;
@synthesize bHasToken = _bHasToken;
@synthesize pToken = _pToken;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [[tztMoblieStockComm getShareInstance] addObj:self];
        _pCurZJInfo = NewObject(tztZJAccountInfo);
        _pToken = NULL;
    }
    return self;
}
-(void)dealloc
{
    [[tztMoblieStockComm getShareInstance] removeObj:self];
    DelObject(_pCurZJInfo);
    [super dealloc];
}
-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    CGRect rcFrame = self.bounds;
    rcFrame.origin = CGPointZero;
    if (_tztTableView == NULL)
    {
        _tztTableView = NewObject(tztUIVCBaseView);
        _tztTableView.tztDelegate = self;
        _tztTableView.tableConfig = @"tztUnLockTradeSetting";
        _tztTableView.frame = rcFrame;
        [self addSubview:_tztTableView];
        [_tztTableView release];
        [NSTimer scheduledTimerWithTimeInterval:0.5f
                                         target:self
                                       selector:@selector(SetDefaultData)
                                       userInfo:NULL
                                        repeats:NO];
    }
    else
        _tztTableView.frame = rcFrame;
}
-(void)SetDefaultData
{
    if ([g_ayJYLoginInfo count] < 1)
        return;
    tztJYLoginInfo *pCurjy = [tztJYLoginInfo GetCurJYLoginInfo:TZTAccountPTType];
    if (g_pCurJYLoginInfo.tokenType == TZTAccountRZRQType)
    {
        pCurjy = [tztJYLoginInfo GetCurJYLoginInfo:TZTAccountRZRQType];
    }
    
    if (pCurjy)
    {
        [_tztTableView setLabelText:pCurjy.nsAccount withTag_:1000];
        [_pCurZJInfo SetZJAccountInfo:pCurjy.ZjAccountInfo];
        [self checkToken];
    }
}
-(void)OnButtonClick:(id)sender
{
    tztUIButton *button = (tztUIButton *)sender;
    int tag = [button.tzttagcode intValue];
    switch (tag)
    {
        case 3000:
        {
            [self doToken];
        }
            break;
        case 4000:
        {
            [self OnLogin];
        }
            break;
        default:
            break;
    }
}
-(void)OnLogin
{
    NSString* nsPass = [_tztTableView GetEidtorText:2000];
    if (nsPass == NULL || [nsPass length] <= 0)
    {
        nsPass = [_tztTableView GetEidtorText:2000];
        if (nsPass == NULL || [nsPass length] <= 0)
            return;
    }
    
    NSString* nsCommPass = [_tztTableView GetEidtorText:2001];
    
    NSMutableDictionary *pDict = NewObject(NSMutableDictionary);
    _ntztReqNo++;
    if (_ntztReqNo >= UINT16_MAX)
        _ntztReqNo = 1;
    NSString* strReqno = tztKeyReqno((long)self, _ntztReqNo);
    [pDict setTztValue:strReqno forKey:@"Reqno"];
    
    if (self.pCurZJInfo.nsAccountType)
        [pDict setTztValue:self.pCurZJInfo.nsAccountType forKey:@"accounttype"];
    if (self.pCurZJInfo.nsCellIndex)
        [pDict setTztValue:self.pCurZJInfo.nsCellIndex forKey:@"YybCode"];
    
    [pDict setTztValue:self.pCurZJInfo.nsAccount forKey:@"account"];
    [pDict setTztValue:nsPass forKey:@"password"];
    [pDict setTztValue:@"100" forKey:@"Maxcount"];
    //存在令牌，增加口令值，调用JYMLogin
	if(_bHasToken)
	{
		NSString* passToken = [self.pToken generatePassword];
		if(passToken == NULL || [passToken length] <= 0 )
		{
			[self showMessageBox:@"令牌错误,请更新或者注销令牌!" nType_:TZTBoxTypeNoButton delegate_:self];
			return;
		}
        nsCommPass = [NSString stringWithFormat:@"%@",passToken];
        [pDict setTztValue:@"1" forKey:@"Direction"];
		[self.pToken advanceCounter];
		[passToken release];
	}
    
    if (nsCommPass)
        [pDict setTztValue:nsCommPass forKey:@"ComPassword"];
    
    [[tztMoblieStockComm getShareInstance] onSendDataAction:@"100" withDictValue:pDict];
    DelObject(pDict);
}
-(void)checkToken
{
	if(_pCurZJInfo != NULL && [_pCurZJInfo.nsCustomID length] > 0 && [_pCurZJInfo.nsAccount length] > 0 )
	{
		NSString *cid = [NSString stringWithFormat:@"%@",_pCurZJInfo.nsCustomID];
		if(cid && [cid length] > 0)
		{
			if([TZTTokenM isExists:cid])
			{
                [_tztTableView setButtonBGImage:[UIImage imageTztNamed:@"tt3.png"] withTag_:3000];
				_bHasToken = TRUE;
				self.pToken = [TZTTokenM tokensWithId:cid];
				if (self.pToken != nil)
				{
					[self.pToken bEqualUDID];
				}
				return;
			}
		}
	}
	
    [_tztTableView setButtonBGImage:[UIImage imageTztNamed:@"tt4.png"] withTag_:3000];
	_bHasToken = FALSE;
}
-(void)doToken
{
    if(_pCurZJInfo == NULL ||[_pCurZJInfo.nsCustomID length] <= 0 ||[_pCurZJInfo.nsAccount length] <= 0 )
	{
		return;
	}
    
    tztUIAddTokenViewController *addView = [[tztUIAddTokenViewController alloc] init];
    [addView.pCurZJInfo SetZJAccountInfo:_pCurZJInfo];
    addView.bHasToken = _bHasToken;
    addView.nsPassWord = [_tztTableView GetEidtorText:2000];
    [g_navigationController pushViewController:addView animated:UseAnimated];
    [addView release];
    //清空密码
    [_tztTableView setEditorText:@"" nsPlaceholder_:@"" withTag_:2000];
}

-(UInt32)OnCommNotify:(UInt32)wParam lParam_:(UInt32)lParam
{
    tztNewMSParse *pParse = (tztNewMSParse*)wParam;
    if (pParse == NULL)
        return 0;
    
    if (![pParse IsIphoneKey:(long)self reqno:_ntztReqNo])
        return 0;
    
    if ([pParse GetErrorNo] < 0)
    {
        [self GTDealErrorNO:pParse];
        return 0;
    }
    
    if ([pParse IsAction:@"100"])
    {
		tztZJAccountInfo* pCurZJ =  NULL;
		if(g_ZJAccountArray && g_AccountIndex >= 0 && g_AccountIndex < [g_ZJAccountArray count])//数组越界
			pCurZJ = [g_ZJAccountArray objectAtIndex:g_AccountIndex];
        NSString* nsPass = [_tztTableView GetEidtorText:2000];
		[tztJYLoginInfo SetLoginInAccount:pParse Pass_:nsPass AccountInfo_:pCurZJ AccountType:g_pCurJYLoginInfo.tokenType];
        
        g_bShowLock = FALSE;
        if (g_CurUserData)
        {
            g_CurUserData.bNeedShowLock = TRUE;
        }
        
        [g_navigationController popViewControllerAnimated:NO];
    }
    return 0;
}
-(void)TZTUIMessageBox:(TZTUIMessageBox *)TZTUIMessageBox clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        switch (TZTUIMessageBox.tag)
        {
            case 1:
            case 2:
            {
                [self doToken];
            }
                break;
            case 3:
            {
                if (_pCurZJInfo &&_pCurZJInfo.nsCustomID&&[_pCurZJInfo.nsCustomID length]>0)
                {
                    [TZTTokenM DeleteTokenData:_pCurZJInfo.nsCustomID];
                }
                [self checkToken];
            }
            default:
                break;
        }
    }
    
    return;
}
@end
