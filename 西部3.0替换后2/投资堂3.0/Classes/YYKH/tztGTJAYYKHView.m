//
//  tztGTJAYYKHView.m
//  tztMobileApp_yyz
//
//  Created by 张 小龙 on 13-6-4.
//
//

#import "tztGTJAYYKHView.h"
#import "mapPrarse.h"
#import "tztUINearBranchViewController.h"
#import "tztUIMapViewController.h"
#import "TZTUserInfoDeal.h"

@implementation tztGTJAYYKHView
@synthesize tztTable = _tztTable;
@synthesize ayAddressCode = _ayAddressCode;
@synthesize ayBranchCode = _ayBranchCode;
@synthesize mLocation = _mLocation;
@synthesize ayBranch = _ayBranch;
@synthesize ayNearBranch = _ayNearBranch;
@synthesize nsMyLat = _nsMyLat;
@synthesize nsMyLong = _nsMyLong;
@synthesize ayDefaultBranch = _ayDefaultBranch;
#define URL @"GTJA"
#define rad(A) A*M_PI/180.0

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [[tztMoblieStockComm getShareInstance] addObj:self];
        _bGetAllBranch = FALSE;
        _bGetEmptyProvince =  FALSE;
        self.ayAddressCode = NewObject(NSMutableDictionary);
        self.ayBranchCode = NewObject(NSMutableDictionary);
        self.ayBranch = NewObject(NSMutableArray);
        self.ayNearBranch = NewObject(NSMutableArray);
        self.ayDefaultBranch = NewObject(NSMutableArray);
        
        NSMutableDictionary * dictFlag = GetDictByListName(@"DownLoadXMLFlag");
        BOOL bDownLoadXMLFlag = [[dictFlag objectForKey:@"DownLoadXMLFlag"] boolValue];
        if (bDownLoadXMLFlag)
        {
            [self GetAllBranch];
        }else
        {
            [self GetYYBMSGXML];
        }
        self.nsMyLat= @"30.276961";
        self.nsMyLong = @"120.116359";
        
    }
    return self;
}
-(void)dealloc
{
    DelObject(_mLocation);
    DelObject(_ayAddressCode);
    DelObject(_ayBranchCode);
    DelObject(_ayNearBranch);
    DelObject(_ayDefaultBranch);
    [[tztMoblieStockComm getShareInstance] removeObj:self];
    [super dealloc];
}

-(void)setDefault
{
    if (self.ayDefaultBranch && [self.ayDefaultBranch count] > 0)
    {
        if ([self.ayDefaultBranch count] >= 6)
        {
            [self.tztTable setComBoxText:[self.ayDefaultBranch objectAtIndex:5] withTag_:1000];
        }
        if ([self.ayDefaultBranch count] >= 2)
        {
            [self.tztTable setComBoxText:[self.ayDefaultBranch objectAtIndex:1] withTag_:1001];
        }
    }
}

-(void)GetAllBranch
{
    mapPrarse *mp=[[mapPrarse alloc]init];
    [mp GetAllBranch:URL _BranchMSG:self.ayBranch];
	[mp release];
    NSLog(@"%d",[self.ayBranch count]);
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
        [_tztTable setTableConfig:@"tztUIGTJAYYKHSetting"];
        [self addSubview:_tztTable];
        [_tztTable release];
    }
    else
    {
        _tztTable.frame = rcFrame;
    }
    
    if(_mLocation == NULL)
    {
        _mLocation = [[CLLocationManager alloc] init];
        if([_mLocation locationServicesEnabled])
        {
            // 接收事件的实例
            _mLocation.delegate = self;
            // 精度 (缺省是Best)
            _mLocation.desiredAccuracy = kCLLocationAccuracyBest;
            // 开始测量
            [_mLocation startUpdatingLocation];
        }
    }
}
- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error
{
//    NSLog([error localizedDescription]);
}
-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    // 取得经纬度
    CLLocationCoordinate2D nowlocation = newLocation.coordinate;
    self.nsMyLat = [NSString stringWithFormat:@"%f",nowlocation.latitude];
    self.nsMyLong = [NSString stringWithFormat:@"%f",nowlocation.longitude];
    NSLog(@"%@",self.nsMyLat);
    NSLog(@"%@",self.nsMyLong);
    [_mLocation stopUpdatingLocation];
}

-(void)GetYYBMSGXML
{
    _ntztReqNo++;
    if (_ntztReqNo >= UINT16_MAX)
        _ntztReqNo = 1;
    
    NSString* strReqno = tztKeyReqno((long)self, _ntztReqNo);
    NSMutableDictionary* pDict = NewObject(NSMutableDictionary);
    
    [pDict setTztValue:strReqno forKey:@"Reqno"];
    [pDict setTztValue:@"GTJA.xml" forKey:@"filename"];
    [pDict setTztValue:@"0" forKey:@"StartPos"];
    NSString *strCrc = @"0";
    if (g_CurUserData.nsGTJAXMLCrc && [g_CurUserData.nsGTJAXMLCrc length] > 0)
    {
        strCrc = [NSString stringWithFormat:@"%@",g_CurUserData.nsGTJAXMLCrc];
    }
    [pDict setTztValue:strCrc forKey:@"Volume"];
    [[tztMoblieStockComm getShareInstance] onSendDataAction:@"255" withDictValue:pDict];
    DelObject(pDict);
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
-(void)GetAllBranchRequest
{
    _bGetAllBranch = TRUE;
    NSMutableDictionary *pDict = NewObject(NSMutableDictionary);
    _ntztReqNo++;
    if (_ntztReqNo > UINT16_MAX)
        _ntztReqNo = 1;
    
    NSString* strReqNo = tztKeyReqno((long)self, _ntztReqNo);
    [pDict setTztValue:strReqNo forKey:@"Reqno"];
    [pDict setTztValue:@"1" forKey:@"StartPos"];
    [pDict setTztValue:@"1000" forKey:@"MaxCount"];
    [pDict setTztValue:@"zhongzhuo" forKey:@"AccountType"];
    
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
    
    if ([pParse IsAction:@"255"])
    {
        NSString* strVolume = [pParse GetByName:@"Volume"];
        if (strVolume && [strVolume length] > 0)
        {
            NSString* strBase = [pParse GetByName:@"BinData"];
            NSData * DataGrid = [NSData tztdataFromBase64String:strBase];
            
            NSFileManager *fileManager = [NSFileManager defaultManager];
            //获取document路径,括号中属性为当前应用程序独享
            NSArray *directoryPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *documentDirectory = [directoryPaths objectAtIndex:0];
            
            //定义记录文件全名以及路径的字符串filePath
            
            NSString *filePath = [documentDirectory stringByAppendingPathComponent:@"GTJA.xml"];
            
            
            if (![strVolume isEqualToString:g_CurUserData.nsGTJAXMLCrc] || [strVolume isEqualToString:@"0"]|| ![fileManager fileExistsAtPath:filePath])
            {
                g_CurUserData.nsGTJAXMLCrc = [NSString stringWithFormat:@"%@",strVolume];
                
                if (![fileManager fileExistsAtPath:filePath])
                {
                    [fileManager createFileAtPath:filePath contents:nil attributes:nil];
                }
                [DataGrid writeToFile:filePath atomically:TRUE];
            }
            NSMutableDictionary *pDict = [NSMutableDictionary dictionary];
            [pDict setTztObject:@"1" forKey:@"DownLoadXMLFlag"];
            SetDictByListName(pDict, @"DownLoadXMLFlag");
    
            
            [self GetAllBranch];
        }
        
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
            NSString * strProvince = [self.tztTable getComBoxText:1000];
            int index = -1;
            if (strProvince && [strProvince length] > 0)
            {
                for (int i = 0; i < [ayName count]; i ++)
                {
                    NSString * strOne = [ayName objectAtIndex:i];
                    if ([strProvince isEqualToString:strOne])
                    {
                        index = i;
                    }
                }
            }
            if (_bGetEmptyProvince)
            {
                [self.tztTable setComBoxData:ayName ayContent_:ayName AndIndex_:index withTag_:1000 ];
                [self GetBranchByProvince];
            }else
                [self.tztTable setComBoxData:ayName ayContent_:ayName AndIndex_:index withTag_:1000 bDrop_:TRUE];
        }
    }
    if ([pParse IsAction:@"26502"])
    {
        int branchIdIndex = -1;
        int branchNameIndex = -1;
        int branchAddressIndex = -1;
        int branchPhoneIndex = -1;
        NSString *strIndex = [pParse GetByName:@"branchIdIndex"];
        TZTStringToIndex(strIndex, branchIdIndex);
        
        strIndex = [pParse GetByName:@"branchNameIndex"];
        TZTStringToIndex(strIndex, branchNameIndex);
        
        strIndex = [pParse GetByName:@"branchAddressIndex"];
        TZTStringToIndex(strIndex, branchAddressIndex);
        
        strIndex = [pParse GetByName:@"branchPhoneIndex"];
        TZTStringToIndex(strIndex, branchPhoneIndex);
        
        NSArray *ayGrid = [pParse GetArrayByName:@"Grid"];
        if (ayGrid)
        {
            if (_bGetAllBranch)
            {
                NSMutableArray *NearBranchInfo = NewObject(NSMutableArray);
                for (int i = 1; i < [ayGrid count]; i++)
                {
                    NSArray* ayValue = [ayGrid objectAtIndex:i];
                    if (ayValue == NULL ||
                        [ayValue count] == 0||
                        [ayValue count] <= branchIdIndex ||
                        [ayValue count] <= branchNameIndex ||
                        [ayValue count] <= branchAddressIndex ||
                        [ayValue count] <= branchPhoneIndex)
                    {
                        continue;
                    }
                    NSString *code = [ayValue objectAtIndex:branchIdIndex];
                    if (code && [code length]> 0)
                    {
                        BOOL add = FALSE;
                        int BranchIndex = 0;
                        for (int y = 0; y < [self.ayNearBranch count]; y++)
                        {
                            NSMutableArray *BranchMsg = [self.ayNearBranch objectAtIndex:y];
                            if (BranchMsg == NULL || [BranchMsg count] < 2)
                                continue;
                            NSString *nearcode = [BranchMsg objectAtIndex:0];
                            if ([nearcode isEqualToString:code])
                            {
                                add = TRUE;
                                BranchIndex = y;
                                break;
                            }
                        }
                        if (add)
                        {
                            NSMutableArray *branchinfo = NewObject(NSMutableArray);
                            NSString *name = [ayValue objectAtIndex:branchNameIndex];
                            NSString *address = [ayValue objectAtIndex:branchAddressIndex];
                            NSString *phone = [ayValue objectAtIndex:branchPhoneIndex];
                            [branchinfo addObject:code];
                            [branchinfo addObject:name];
                            [branchinfo addObject:address];
                            [branchinfo addObject:phone];
                            NSMutableArray *BranchMsg = [self.ayNearBranch objectAtIndex:BranchIndex];
                            if (BranchMsg && [BranchMsg count] >= 3)
                            {
                                [branchinfo addObject:[BranchMsg objectAtIndex:1]];
                                [branchinfo addObject:[BranchMsg objectAtIndex:2]];
                            }
                            
                            [NearBranchInfo addObject:branchinfo];
                            [branchinfo release];
                        }
                    }
                }
                if ([NearBranchInfo count] > 0)
                {
                    [self ShowNearBranch:NearBranchInfo];
                }else
                {
                    [self showMessageBox:@"获取最近营业部错误！" nType_:TZTBoxTypeNoButton nTag_:0];
                }
                [NearBranchInfo release];
                _bGetAllBranch = FALSE;
            }else
            {
                [self.ayBranchCode removeAllObjects];
                NSMutableArray * ayName = NewObject(NSMutableArray);
                for (int i = 1; i < [ayGrid count]; i++)
                {
                    NSArray* ayValue = [ayGrid objectAtIndex:i];
                    if (ayValue == NULL ||
                        [ayValue count] == 0||
                        [ayValue count] <= branchIdIndex ||
                        [ayValue count] <= branchNameIndex)
                    {
                        continue;
                    }
                    
                    NSString *name = [ayValue objectAtIndex:branchNameIndex];
                    NSString *code = [ayValue objectAtIndex:branchIdIndex];
                    if (code && [code length]> 0 && name &&[name length] > 0)
                    {
                        [self.ayBranchCode setTztObject:code forKey:name];
                        [ayName addObject:name];
                    }
                }
                if (_bGetEmptyProvince)
                {
                    [self.tztTable setComBoxData:ayName ayContent_:ayName AndIndex_:0 withTag_:1001 bDrop_:TRUE];
                    _bGetEmptyProvince = FALSE;
                }else
                    [self.tztTable setComBoxData:ayName ayContent_:ayName AndIndex_:0 withTag_:1001 bDrop_:FALSE];
            }
        }
    }
    if ([pParse IsAction:@"26500"])
    {
        NSString* strErrMsg = [pParse GetErrorMessage];
        [self showMessageBox:strErrMsg nType_:TZTBoxTypeNoButton nTag_:0];
        [self ClearView];
    }
    return 1;
}
-(void)ClearView
{
    [self.tztTable setEditorText:@"" nsPlaceholder_:NULL withTag_:2000];
    [self.tztTable setEditorText:@"" nsPlaceholder_:NULL withTag_:2001];
    [self.tztTable setComBoxText:@"" withTag_:1000];
    [self.tztTable setComBoxText:@"" withTag_:1001];
    [self.tztTable setComBoxText:@"" withTag_:1002];
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
        if (self.ayDefaultBranch)
            [self.ayDefaultBranch removeAllObjects];
        [self GetKHDQ];
    }
    if ([droplistview.tzttagcode intValue] == 1001)
    {
        NSString * province = [self.tztTable getComBoxText:1000];
        if (province && [province length] > 0&&[self.ayAddressCode count]< 1)
        {
            _bGetEmptyProvince = TRUE;
            [self GetKHDQ];
        }
        if (self.ayDefaultBranch)
            [self.ayDefaultBranch removeAllObjects];
        
        [self GetBranchByProvince];
    }
}
-(void)ShowMap
{
    NSString * Province = [self.tztTable getComBoxText:1000];
    NSString * Branch = [self.tztTable getComBoxText:1001];
    if (Province == NULL || [Province length] < 1 || Branch == NULL || [Branch length] < 1)
    {
        [self showMessageBox:@"没有选择开户地区或者营业部地图无法定位！" nType_:TZTBoxTypeNoButton nTag_:0];
        return;
    }
    NSString *BranchCode = [self.ayBranchCode tztObjectForKey:Branch];
    
    if (BranchCode == NULL || [BranchCode length] < 1)
    {
        if (self.ayDefaultBranch && [self.ayDefaultBranch count] > 0)
        {
            BranchCode = [self.ayDefaultBranch objectAtIndex:0];
        }
        if (BranchCode == NULL || [BranchCode length] < 1)
        {
            [self showMessageBox:@"获取信息错误！" nType_:TZTBoxTypeNoButton nTag_:0];
            return;
        }
    }
    
    int idnex = -1;
    for (int i = 0; i< [self.ayBranch count];i++ )
    {
        NSMutableArray * branchInfo = [self.ayBranch objectAtIndex:i];
        NSString * code = [branchInfo objectAtIndex:0];
        if ([BranchCode isEqualToString:code])
        {
            idnex = i;
        }
    }
    
    if (idnex < 0)
    {
        [self showMessageBox:@"该营业部地理位置未录入。" nType_:TZTBoxTypeNoButton nTag_:0];
        return;
    }
    
    NSMutableArray * branchInfo = [self.ayBranch objectAtIndex:idnex];
    NSString *strlat = [branchInfo objectAtIndex:4];
    NSString *strlng = [branchInfo objectAtIndex:5];
    CLLocationCoordinate2D DLocation ;
    DLocation.latitude = [strlat doubleValue];
    DLocation.longitude = [strlng doubleValue];

    CLLocationCoordinate2D DMyLocation ;
    DMyLocation.latitude = [self.nsMyLat doubleValue];
    DMyLocation.longitude = [self.nsMyLong doubleValue];
    
    tztUIMapViewController * pVC = NewObject(tztUIMapViewController);
    pVC.DLocation.DLocation = DLocation;
    pVC.DMyLocation.DLocation = DMyLocation;
    [g_navigationController pushViewController:pVC animated:NO];
    [pVC release];

}
-(void)ShowNearBranch:(NSMutableArray *)ayBranch
{
    NSMutableArray *ayNearMyBranch = NewObject(NSMutableArray);
    int count = [ayBranch count];
    for (int i = 0; i  < count; i ++ )
    {
        NSMutableArray * MinBranch = [ayBranch objectAtIndex:0];
        int selectIndex = 0;
        if ([ayBranch count] > 1)
        {
            for (int j = 1; j < [ayBranch count]; j++)
            {
                NSMutableArray *CurBranch = [ayBranch objectAtIndex:j];
                double dMin = [[MinBranch objectAtIndex:4] doubleValue];
                double dCur = [[CurBranch objectAtIndex:4] doubleValue];
                if (dMin > dCur)
                {
                    MinBranch = CurBranch;
                    selectIndex = j;
                }
            }
        }
        [ayNearMyBranch addObject:MinBranch];
        [ayBranch removeObjectAtIndex:selectIndex];
    }
    tztUINearBranchViewController *pVC = NewObject(tztUINearBranchViewController);
    if (pVC.ayBranch == NULL)
        pVC.ayBranch = NewObject(NSMutableArray);
    [pVC.ayBranch setArray:ayNearMyBranch];
    [g_navigationController pushViewController:pVC animated:NO];
    [pVC release];
    DelObject(ayNearMyBranch);
}
-(BOOL)CheckInput
{
    NSString *nsProvince = [self.tztTable getComBoxText:1000];
    if (nsProvince == NULL || [nsProvince length] < 1)
    {
         [self showMessageBox:@"获取信息错误！" nType_:TZTBoxTypeNoButton nTag_:0];
        return false;
    }
    
    NSString *nsbranch = [self.tztTable getComBoxText:1001];
    if (nsbranch == NULL || [nsbranch length] < 1)
    {
        [self showMessageBox:@"获取信息错误！" nType_:TZTBoxTypeNoButton nTag_:0];
        return false;
    }
    
    NSString *username = [self.tztTable GetEidtorText:2000];
    if (username == NULL || [username length] < 1)
    {
        [self showMessageBox:@"用户名输入错误！" nType_:TZTBoxTypeNoButton nTag_:0];
        return false;
    }
    
    NSString *phone = [self.tztTable GetEidtorText:2001];
    if (phone == NULL || [phone length] != 11)
    {
        [self showMessageBox:@"手机号码输入错误！" nType_:TZTBoxTypeNoButton nTag_:0];
        return false;
    }
    
    NSString *nsdata = [self.tztTable getComBoxText:1002];
    if (nsdata == NULL || [nsdata length] < 1)
    {
        [self showMessageBox:@"获取日期错误！" nType_:TZTBoxTypeNoButton nTag_:0];
        return false;
    }
    
    return TRUE;
}
-(void)YYKHRequest
{
    NSString * branchid = [self.ayBranchCode tztObjectForKey:[self.tztTable getComBoxText:1001]];
    if (branchid == NULL || [branchid length] < 1)
    {
        if (self.ayDefaultBranch && [self.ayDefaultBranch count] > 0)
        {
            branchid = [self.ayDefaultBranch objectAtIndex:0];
        }
        if (branchid == NULL || [branchid length] < 1)
        {
            [self showMessageBox:@"获取信息错误！" nType_:TZTBoxTypeNoButton nTag_:0];
            return;
        }
    }
    
    NSMutableDictionary *pDict = NewObject(NSMutableDictionary);
    _ntztReqNo++;
    if (_ntztReqNo > UINT16_MAX)
        _ntztReqNo = 1;
    
    NSString* strReqNo = tztKeyReqno((long)self, _ntztReqNo);
    [pDict setTztValue:strReqNo forKey:@"Reqno"];
    [pDict setTztValue:branchid forKey:@"branchId"];
    [pDict setTztValue:[self.tztTable GetEidtorText:2000] forKey:@"Title"];
    [pDict setTztValue:[self.tztTable GetEidtorText:2001] forKey:@"YykhMobile"];
    [pDict setTztValue:[self.tztTable getComBoxText:1002] forKey:@"BeginDate"];
    
    [pDict setTztValue:@"zhongzhuo" forKey:@"AccountType"];
    
    [[tztMoblieStockComm getShareInstance] onSendDataAction:@"26500" withDictValue:pDict];
}
-(double)GetBranchToMy:(NSString *)nsLat strLng:(NSString *)nsLng
{
    if (nsLat == NULL || [nsLat length] < 1 || nsLng == NULL || [nsLng length] < 1)
        return -1;
    
    double lat = [nsLat doubleValue];
    double lng = [nsLng doubleValue];
    double latMy = [self.nsMyLat doubleValue];
    double lngMy = [self.nsMyLong doubleValue];
    double a = rad(lat) - rad(latMy);
    double b = rad(lng) - rad(lngMy);
    double s = 2*asin(sqrt(pow(sin(a/2), 2)
                           + cos(rad(lat))* cos(rad(latMy))
                           * pow(sin(b/2), 2)));
    s = s * 6378.137;// 地球半径 6378.137
    s = round(s*1000)/1000;
    return s;
}

-(BOOL)GetNearBranch
{
    if (self.nsMyLat == NULL
        || [self.nsMyLat length] < 1
        || self.nsMyLong == NULL
        || [self.nsMyLong length] < 1
        || [self.ayBranch count] <= 3)
        return FALSE;
    
    int nearFirst = 0;
    int nearSecond = 1;
    int nearThird = 2;
    double FirstS = 0;
    double secondS = 0;
    double ThirdS = 0;
    
    if ([self.ayBranch count] > 3)
    {
        NSMutableArray * branch = [self.ayBranch objectAtIndex:0];
        NSString *StrLat = [branch objectAtIndex:4];
        NSString *StrLng = [branch objectAtIndex:5];
        FirstS = [self GetBranchToMy:StrLat strLng:StrLng];
        
        branch = [self.ayBranch objectAtIndex:1];
        StrLat = [branch objectAtIndex:4];
        StrLng = [branch objectAtIndex:5];
        secondS = [self GetBranchToMy:StrLat strLng:StrLng];
        
        branch = [self.ayBranch objectAtIndex:2];
        StrLat = [branch objectAtIndex:4];
        StrLng = [branch objectAtIndex:5];
        ThirdS = [self GetBranchToMy:StrLat strLng:StrLng];
        
        double From = FirstS;
        int nearindex = nearFirst;
        if (FirstS > secondS)
        {
            FirstS = secondS;
            secondS = From;
            nearFirst = nearSecond;
            nearSecond = nearindex;
        }

        From = FirstS;
        nearindex = nearFirst;
        if (FirstS > ThirdS)
        {
            FirstS = ThirdS;
            ThirdS = From;
            nearFirst = nearThird;
            nearThird = nearindex;
        }
        
        From = secondS;
        nearindex = nearSecond;
        if (secondS > ThirdS)
        {
            secondS = ThirdS;
            ThirdS = From;
            nearSecond = nearThird;
            nearThird = nearindex;
        }
        
        
        for (int i = 2; i < [self.ayBranch count]; i++)
        {
            branch = [self.ayBranch objectAtIndex:i];
            StrLat = [branch objectAtIndex:4];
            StrLng = [branch objectAtIndex:5];
            double nowS = [self GetBranchToMy:StrLat strLng:StrLng];
            
            if (nowS <= FirstS)
            {
                ThirdS = secondS;
                nearThird = nearSecond;
                
                secondS = FirstS;
                nearSecond = nearFirst;
                
                FirstS = nowS;
                nearFirst = i;
            }else
            {
                if (nowS <= secondS)
                {
                    ThirdS = secondS;
                    nearThird = nearSecond;
                    
                    secondS = nowS;
                    nearSecond = i;
                }else
                {
                    if (nowS <= ThirdS)
                    {
                        ThirdS = nowS;
                        nearThird = i;
                    }
                }
            }
        }
    }
    
    NSMutableArray * branchNear = [self.ayBranch objectAtIndex:nearFirst];
    NSString * nearFirstCode = [NSString stringWithFormat:@"%@",[branchNear objectAtIndex:0]];
    NSString * nearFirstProvince = [NSString stringWithFormat:@"%@",[branchNear objectAtIndex:1]];
    
    branchNear = [self.ayBranch objectAtIndex:nearSecond];
    NSString * nearSecondCode = [NSString stringWithFormat:@"%@",[branchNear objectAtIndex:0]];
    NSString * nearSecondProvince = [NSString stringWithFormat:@"%@",[branchNear objectAtIndex:1]];
    
    branchNear = [self.ayBranch objectAtIndex:nearThird];
    NSString * nearThirdCode = [NSString stringWithFormat:@"%@",[branchNear objectAtIndex:0]];
    NSString * nearThirdProvince = [NSString stringWithFormat:@"%@",[branchNear objectAtIndex:1]];
    [self.ayNearBranch removeAllObjects];
    
    NSMutableArray *FirstArray = NewObject(NSMutableArray);
    [FirstArray addObject:nearFirstCode];
    [FirstArray addObject:[NSString stringWithFormat:@"%0.1f",FirstS]];
    [FirstArray addObject:nearFirstProvince];
    [self.ayNearBranch addObject:FirstArray];
    DelObject(FirstArray);
    
    NSMutableArray *SecondArray = NewObject(NSMutableArray);
    [SecondArray addObject:nearSecondCode];
    [SecondArray addObject:[NSString stringWithFormat:@"%0.1f",secondS]];
    [SecondArray addObject:nearSecondProvince];
    [self.ayNearBranch addObject:SecondArray];
    DelObject(SecondArray);
    
    NSMutableArray *ThirdArray = NewObject(NSMutableArray);
    [ThirdArray addObject:nearThirdCode];
    [ThirdArray addObject:[NSString stringWithFormat:@"%0.1f",ThirdS]];
    [ThirdArray addObject:nearThirdProvince];
    [self.ayNearBranch addObject:ThirdArray];
    DelObject(ThirdArray);
    
    if ([self.ayNearBranch count] > 0)
        return TRUE;
    return FALSE;
}
-(void)OnButtonClick:(id)sender
{
    if (sender == NULL)
		return;
	tztUIButton * pButton = (tztUIButton*)sender;
	int nTag = [pButton.tzttagcode intValue];
    //确认
    switch (nTag)
    {
        case 3000:
        {
            [self ShowMap];
        }
            break;
        case 3001:
        {
            if ([self GetNearBranch])
            {
                [self GetAllBranchRequest];
            }else
            {
                 [self showMessageBox:@"获取最近营业部错误！" nType_:TZTBoxTypeNoButton nTag_:0];
            }
        }
            break;
        case 3002:
        {
            if ([self CheckInput])
            {
                [self YYKHRequest];
            }
        }
            break;
        default:
            break;
    }
}
@end
