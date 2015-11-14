//
//  tztYYWDView.m
//  tztMobileApp_yyz
//
//  Created by 张 小龙 on 13-6-6.
//
//

#import "tztYYBDWView.h"
#import "tztUISelectYYBViewController.h"

@implementation tztYYBDWView
@synthesize tztTable = _tztTable;
@synthesize ayBranch = _ayBranch;
@synthesize ayAddressCode = _ayAddressCode;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _ayBranch = NewObject(NSMutableArray);
        _ayAddressCode = NewObject(NSMutableDictionary);
        [[tztMoblieStockComm getShareInstance] addObj:self];
    }
    return self;
}
-(void)dealloc
{
    [[tztMoblieStockComm getShareInstance] removeObj:self];
    DelObject(_ayBranch);
    DelObject(_ayAddressCode);
    [super dealloc];
}
-(void)setFrame:(CGRect)frame
{
    if (CGRectIsEmpty(frame) || CGRectIsNull(frame))
        return;
    
    [super setFrame:frame];
    
    CGRect rcFrame = self.bounds;
    
    if (_tztTable == nil)
    {
        _tztTable = [[tztUIVCBaseView alloc] initWithFrame:rcFrame];
        _tztTable.tztDelegate = self;
        [_tztTable setTableConfig:@"tztUIGTJAYYBDWSetting"];
        [self addSubview:_tztTable];
        [_tztTable release];
    }
    else
    {
        _tztTable.frame = rcFrame;
    }
}
-(void)GetKHDQ
{
    NSMutableDictionary *pDict = NewObject(NSMutableDictionary);
    _ntztReqNo++;
    if (_ntztReqNo > UINT16_MAX)
        _ntztReqNo = 1;
    
    NSString* strReqNo = tztKeyReqno((long)self, _ntztReqNo);
    [pDict setTztValue:strReqNo forKey:@"Reqno"];
    [pDict setTztValue:@"1" forKey:@"StartPos"];
    [pDict setTztValue:@"100" forKey:@"MaxCount"];
    [pDict setTztValue:@"zhongzhuo" forKey:@"AccountType"];
    
    [[tztMoblieStockComm getShareInstance] onSendDataAction:@"26501" withDictValue:pDict];
	DelObject(pDict);
}

-(void)GetBranchByProvince
{
    NSString * nsProvince = [self.tztTable getComBoxText:1000];
    if (nsProvince == NULL || [nsProvince length] < 1 || [self.ayAddressCode count] < 1)
        return;
    NSString *nsProvinceCode = [self.ayAddressCode tztObjectForKey:nsProvince];
    if (nsProvinceCode == NULL || [nsProvinceCode length] < 1)
        return;
    
    NSMutableDictionary *pDict = NewObject(NSMutableDictionary);
    _ntztReqNo++;
    if (_ntztReqNo > UINT16_MAX)
        _ntztReqNo = 1;
    
    NSString* strReqNo = tztKeyReqno((long)self, _ntztReqNo);
    [pDict setTztValue:strReqNo forKey:@"Reqno"];
    [pDict setTztValue:@"1" forKey:@"StartPos"];
    [pDict setTztValue:@"100" forKey:@"MaxCount"];
    [pDict setTztValue:@"zhongzhuo" forKey:@"AccountType"];
    [pDict setTztValue:nsProvinceCode forKey:@"provinceId"];
    
    [[tztMoblieStockComm getShareInstance] onSendDataAction:@"26502" withDictValue:pDict];
    
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
        NSString* strErrMsg = [pParse GetErrorMessage];
        [self showMessageBox:strErrMsg nType_:TZTBoxTypeNoButton nTag_:0];
        
        if ([tztBaseTradeView IsExitError:[pParse GetErrorNo]])
        {
            [self OnNeedLoginOut];
        }
        return 0;
    }
    
    if ([pParse IsAction:@"26501"])
    {
        int provinceIdIndex = -1;
        int provinceNameIndex = -1;
        
        NSString *strIndex = [pParse GetByName:@"provinceIdIndex"];
        TZTStringToIndex(strIndex, provinceIdIndex);
        
        strIndex = [pParse GetByName:@"provinceNameIndex"];
        TZTStringToIndex(strIndex, provinceNameIndex);
        NSArray *ayGrid = [pParse GetArrayByName:@"Grid"];
        if (ayGrid)
        {
            [self.ayAddressCode removeAllObjects];
            NSMutableArray * ayName = NewObject(NSMutableArray);
            for (int i = 1; i < [ayGrid count]; i++)
            {
                NSArray* ayValue = [ayGrid objectAtIndex:i];
                if (ayValue == NULL ||
                    [ayValue count] == 0||
                    [ayValue count] <= provinceIdIndex ||
                    [ayValue count] <= provinceNameIndex)
                {
                    continue;
                }
                
                NSString *name = [ayValue objectAtIndex:provinceNameIndex];
                NSString *code = [ayValue objectAtIndex:provinceIdIndex];
                if (code && [code length]> 0 && name &&[name length] > 0)
                {
                    [self.ayAddressCode setTztObject:code forKey:name];
                    [ayName addObject:name];
                }
            }
  
            [self.tztTable setComBoxData:ayName ayContent_:ayName AndIndex_:0 withTag_:1000 bDrop_:TRUE];
        }
    }
    if ([pParse IsAction:@"26502"])
    {
        int branchIdIndex = -1;
        int branchNameIndex = -1;
        int branchAddressIndex = -1;
        int branchPhoneIndex = -1;
        int branchSeatNumIndex = -1;
        NSString *strIndex = [pParse GetByName:@"branchIdIndex"];
        TZTStringToIndex(strIndex, branchIdIndex);
        
        strIndex = [pParse GetByName:@"branchNameIndex"];
        TZTStringToIndex(strIndex, branchNameIndex);
        
        strIndex = [pParse GetByName:@"branchAddressIndex"];
        TZTStringToIndex(strIndex, branchAddressIndex);
        
        strIndex = [pParse GetByName:@"branchPhoneIndex"];
        TZTStringToIndex(strIndex, branchPhoneIndex);
        
        strIndex = [pParse GetByName:@"branchSeatNumIndex"];
        TZTStringToIndex(strIndex, branchSeatNumIndex);
        
        NSArray *ayGrid = [pParse GetArrayByName:@"Grid"];
        if (ayGrid)
        {
            [self.ayBranch removeAllObjects];
            NSMutableArray * ayName = NewObject(NSMutableArray);
            for (int i = 1; i < [ayGrid count]; i++)
            {
                NSArray* ayValue = [ayGrid objectAtIndex:i];
                if (ayValue == NULL ||
                    [ayValue count] == 0||
                    [ayValue count] <= branchIdIndex ||
                    [ayValue count] <= branchNameIndex||
                    [ayValue count] <= branchAddressIndex||
                    [ayValue count] <= branchPhoneIndex||
                    [ayValue count] <= branchSeatNumIndex)
                {
                    continue;
                }
                
                NSString *name = [ayValue objectAtIndex:branchNameIndex];
                NSString *code = [ayValue objectAtIndex:branchIdIndex];
                NSString *address = [ayValue objectAtIndex:branchAddressIndex];
                NSString *phone = [ayValue objectAtIndex:branchPhoneIndex];
                NSString *seatnum = [ayValue objectAtIndex:branchSeatNumIndex];
                if (code && [code length]> 0
                    && name &&[name length] > 0
                    && address &&[address length] > 0
                    && phone &&[phone length] > 0
                    && seatnum &&[seatnum length] > 0)
                {
                    [ayName addObject:name];
                    
                    NSMutableArray * branchinfo = NewObject(NSMutableArray);
                    [branchinfo addObject:code];
                    [branchinfo addObject:name];
                    [branchinfo addObject:address];
                    [branchinfo addObject:phone];
                    [branchinfo addObject:seatnum];
                    [self.ayBranch addObject:branchinfo];
                    [branchinfo release];
                    
                }
            }
            
            [self.tztTable setComBoxData:ayName ayContent_:ayName AndIndex_:0 withTag_:1001 bDrop_:FALSE];
        }
    }
    return 1;
}

-(void)tztDroplistView:(tztUIDroplistView *)droplistview didSelectIndex:(int)index
{
    if ([droplistview.tzttagcode intValue] == 1000)
    {
        [self GetBranchByProvince];
    }
}

-(void)tztDroplistViewGetData:(tztUIDroplistView *)droplistview
{
    if ([droplistview.tzttagcode intValue] == 1000)
    {
        [self GetKHDQ];
    }
    if ([droplistview.tzttagcode intValue] == 1001)
    {
        [self GetBranchByProvince];
    }
}
-(BOOL)CheckInput
{
    NSString *nsProvince = [self.tztTable getComBoxText:1000];
    if (nsProvince == NULL || [nsProvince length] < 1)
    {
        [self showMessageBox:@"所在地区不能为空！" nType_:TZTBoxTypeNoButton nTag_:0];
        return FALSE;
    }
    NSString *nsBranch = [self.tztTable getComBoxText:1001];
    if (nsBranch == NULL || [nsBranch length] < 1)
    {
        [self showMessageBox:@"网点名称不能为空！" nType_:TZTBoxTypeNoButton nTag_:0];
        return FALSE;
    }
    return TRUE;
}
-(void)ShowBranchInfo
{
    int index = [self.tztTable getComBoxSelctedIndex:1001];
    if (index < 0 || index >= [self.ayBranch count])
    {
        [self showMessageBox:@"查询错误！" nType_:TZTBoxTypeNoButton nTag_:0];
        return;
    }
    
    NSMutableArray *branchInfo = [self.ayBranch objectAtIndex:index];
    if (branchInfo == NULL && [branchInfo count] < 1)
    {
        [self showMessageBox:@"查询错误！" nType_:TZTBoxTypeNoButton nTag_:0];
        return;
    }
    NSString * strProvince = [self.tztTable  getComBoxText:1000];
    if (strProvince && [strProvince length] > 0)
    {
        [branchInfo addObject:strProvince];
    }
    tztUISelectYYBViewController *pVC = NewObject(tztUISelectYYBViewController);
    [pVC.ayBranchInfo setArray:branchInfo];
    [g_navigationController pushViewController:pVC animated:NO];
    [pVC release];
}
-(void)OnButtonClick:(id)sender
{
    if (sender == NULL)
		return;
	tztUIButton * pButton = (tztUIButton*)sender;
	int nTag = [pButton.tzttagcode intValue];
    if (nTag == 2000)
    {
       if([self CheckInput])
       {
           [self ShowBranchInfo];
       }
    }
}
@end
