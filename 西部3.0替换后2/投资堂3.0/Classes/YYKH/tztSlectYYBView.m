//
//  tztSlectYYBView.m
//  tztMobileApp_yyz
//
//  Created by 张 小龙 on 13-6-6.
//
//

#import "tztSlectYYBView.h"
#import "tztUIMapViewController.h"
#import "mapPrarse.h"
#import "tztUIGTJAYYKHViewController.h"
#import "TZTUserInfoDeal.h"

@implementation tztSlectYYBView
@synthesize tztTable = _tztTable;
@synthesize ayBranchInfo = _ayBranchInfo;
@synthesize ayBranch = _ayBranch;
@synthesize mLocation = _mLocation;
@synthesize nsMyLat = _nsMyLat;
@synthesize nsMyLong = _nsMyLong;

#define URL @"GTJA"

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _ayBranchInfo = NewObject(NSMutableArray);
        _ayBranch = NewObject(NSMutableArray);
        
        [[tztMoblieStockComm getShareInstance] addObj:self];
        
        NSMutableDictionary * dictFlag = GetDictByListName(@"DownLoadXMLFlag");
        BOOL bDownLoadXMLFlag = [[dictFlag objectForKey:@"DownLoadXMLFlag"] boolValue];
        if (bDownLoadXMLFlag)
        {
            [self GetAllBranch];
        }else
        {
            [self GetYYBMSGXML];
        }
    }
    return self;
}
-(void)dealloc
{
    [[tztMoblieStockComm getShareInstance] removeObj:self];
    DelObject(_ayBranchInfo);
    DelObject(_ayBranch);
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
        [_tztTable setTableConfig:@"tztUIGTJAYYBShowSetting"];
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
            // 发生事件的的最小距离间隔（缺省是不指定）
            _mLocation.distanceFilter = kCLDistanceFilterNone;
            // 精度 (缺省是Best)
            _mLocation.desiredAccuracy = kCLLocationAccuracyBest;
            // 开始测量
            [_mLocation startUpdatingLocation];
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
    return 1;
}

-(void)SetDefaultData
{
    if (self.ayBranchInfo && [self.ayBranchInfo count] > 4)
    {
        [self.tztTable setLabelText:[self.ayBranchInfo objectAtIndex:1] withTag_:1000];
        [self.tztTable setLabelText:[self.ayBranchInfo objectAtIndex:3] withTag_:1001];
        [self.tztTable setLabelText:[self.ayBranchInfo objectAtIndex:2] withTag_:1002];
        [self.tztTable setLabelText:[self.ayBranchInfo objectAtIndex:4] withTag_:1003];
    }
    if (self.tztTable)
    {
        tztUILabel *lable = (tztUILabel *)[self.tztTable getViewWithTag:1002];
        if (lable)
        {
            lable.font = [UIFont systemFontOfSize:12.f];
            [lable setNumberOfLines:0];
            lable.lineBreakMode = UILineBreakModeWordWrap;
        }
        
        lable = (tztUILabel *)[self.tztTable getViewWithTag:1003];
        if (lable)
        {
            lable.font = [UIFont systemFontOfSize:12.f];
            [lable setNumberOfLines:0];
            lable.lineBreakMode = UILineBreakModeWordWrap;
        }
    }
}

-(void)ShowMap
{
    NSString *BranchCode = [self.ayBranchInfo objectAtIndex:0];
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
-(void)ShowYYKH
{
    tztUIGTJAYYKHViewController *pVC = NewObject(tztUIGTJAYYKHViewController);
    [pVC.ayBranchInfo setArray:self.ayBranchInfo];
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
        [self ShowYYKH];
    }
    if (nTag == 2001)
    {
        [self ShowMap];
    }
}

@end
