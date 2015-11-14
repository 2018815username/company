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

#import "tztCommRequestView.h"
#import "tztUIDocumentViewController.h"
@implementation tztCommRequestView
@synthesize pListView;
@synthesize nsTztFileData = _nsTztFileData;
@synthesize nsTztFileType = _nsTztFileType;
@synthesize nsReqAction = _nsReqAction;

-(id)init
{
    if (self = [super init])
    {
        
    }
    return self;
}


-(void)setFrame:(CGRect)frame
{
    if (CGRectIsNull(frame) || CGRectIsEmpty(frame))
        return;
    
    [super setFrame:frame];
    CGRect rcFrame = self.bounds;
    rcFrame.origin = CGPointZero;
    
    if (_pListView == NULL)
    {
        _pListView = [[TZTUIReportGridView alloc] init];
        _pListView.delegate = self;
        _pListView.frame = rcFrame;
        [self addSubview:_pListView];
        [_pListView release];
    }
    else
        _pListView.frame = rcFrame;
}

//查询产品有效期
-(void)OnRequestValidDate
{
//    if (_pListView)
//    {
//        [_pListView setStockCode:@"" Request:1];
//    }
}

//增删自选，添加到服务器
-(void)SendToServer:(tztStockInfo*)pStock nDirection_:(int)nDirect
{
    
}
//从服务器下载自选
-(void)DownFromServer:(tztStockInfo*)pStock
{
    
}

-(NSUInteger)OnCommNotify:(NSUInteger)wParam lParam_:(NSUInteger)lParam
{
    tztNewMSParse *pParse = (tztNewMSParse*)wParam;
    if (pParse == NULL)
        return 0;
    if (![pParse IsIphoneKey:(long)self reqno:_ntztReqNo])
        return 0;
    /*
     解析下载文件请求
     270001
     */
    
    if ([pParse IsAction:self.nsReqAction] && !_bCancel)
    {
        int nErrNo = [pParse GetErrorNo];
        if (nErrNo < 0)
        {
            _bCancel = NO;
            [tztUIProgressView hidden];
            //错误信息要提示
            tztAfxMessageBox([pParse GetErrorMessage]);
            return 0;
        }
        
        //下载文件
        //获取指定字段的数据
        if (self.nsTztFileData == NULL || self.nsTztFileData.length < 1)
        {
            _bCancel = NO;
            [tztUIProgressView hidden];
            return 0;
        }
        
        
//        int nCellIndex = [[pParse GetByName:@"CellIndex"] intValue];
//        if (nCellIndex == 1)
        {
            NSData* pData = [pParse GetNSDataBase64:self.nsTztFileData];
            if (pData.length <= 0)
            {
                _bCancel = NO;
                [tztUIProgressView hidden];
                return 0;
            }
            [tztUIProgressView showWithMsg:@"正在打开文件..." withdelegate:self];
            NSString* strFileName = [NSString stringWithFormat:@"/查看资讯.%@", self.nsTztFileType];
            NSString* str = [strFileName tztHttpfilepath];
            [pData writeToFile:str atomically:YES];
            //发送通知，打开文档
            NSNotification* pNotifi = [NSNotification notificationWithName:TZTNotifi_OpenDocument object:str];
            [[NSNotificationCenter defaultCenter] postNotification:pNotifi];
        }
        _bCancel = NO;
        [tztUIProgressView hidden];
    }
    return 1;
}

//下载文件
/*
 http://action:10054?tztfiledata=GRID&&tztfiletype=pdf&&url=action=20106&MOBILECODE=($mobilecode)&filename="a.pdf"&startpos=1&reqno=($reqno)
 
 Action = 27001;
 Cfrom = "htsczl.iphone";
 IphoneKey = 425551280;
 ReqLinkType = 2;
 Reqno = "425551280=3=0=0=0=25127.354";
 Tfrom = "htsc.iphone.lc";
 action = 27001;
 from = "htsczl.iphone";
 funcId = 101003;
 path = "/htsc_hub/info";
 reportId = 1000011130279754;
 */
-(void)DownloadFile:(NSString *)strData
{
    self.nsTztFileType = @"";
    self.nsTztFileData = @"";
    if (strData == NULL || strData.length < 1)
        return;
    
    //解析数据
    NSString* strParam = strData;
    NSMutableDictionary* pDict = nil;
    if(strParam && [strParam length] > 0)
    {
        pDict = (NSMutableDictionary*)[strParam tztNSMutableDictionarySeparatedByString:@"&&"];
    }
    
    if (pDict == NULL)
        return ;
    
    self.nsTztFileData = [pDict tztObjectForKey:@"tztfiledata"];
    self.nsTztFileType = [pDict tztObjectForKey:@"tztfiletype"];
    if (self.nsTztFileType.length <= 0 || [self.nsTztFileType caseInsensitiveCompare:@"undefined"] == NSOrderedSame)
        self.nsTztFileType = @"pdf";
//    if ([self.nsTztFileType caseInsensitiveCompare:@"application/pdf"] == NSOrderedSame)
//    {
//        self.nsTztFileType = @".pdf";
//    }
    
    /*
     
     */
    
    
    NSString* strURL = [pDict tztObjectForKey:@"url"];
    if (strURL.length < 1)
        return;
    strURL = [strURL tztdecodeURLString];
    NSMutableDictionary* dictParams = [strURL tztNSMutableDictionarySeparatedByString:@"&"];
    
    NSString* strFuncID = [dictParams tztObjectForKey:@"funcId"];
    
    if (strFuncID.length < 1 && ([strURL hasPrefix:@"http://"] || [strURL hasPrefix:@"https://"]))//直接下载
    {
        id nav = g_navigationController;
        
        if (g_nSupportLeftSide || g_nSupportRightSide)
        {
            PPRevealSideDirection direction = [[TZTAppObj getShareInstance].rootTabBarController.revealSideViewController getSideToClose];
            if (direction > 0)
            {
                if (direction == PPRevealSideDirectionLeft)
                {
                    nav = [TZTAppObj getShareInstance].rootTabBarController.leftVC.navigationController;
                }
                else if (direction == PPRevealSideDirectionRight)
                {
                    nav = [TZTAppObj getShareInstance].rootTabBarController.rightVC.navigationController;
                }
            }
        }
        [TZTUIBaseVCMsg IPadPushViewController:nav pop:[tztUIDocumentViewController getShareInstance]];
        [[tztUIDocumentViewController getShareInstance] OpenDocumentWithURL:strURL];
        return;
    }
    
    if (dictParams == NULL || [dictParams count] < 1)
        return;
    
    NSMutableDictionary *sendvalue = NewObject(NSMutableDictionary);
    int nTokenType = TZTAccountPTType;
    NSString* strAccountType = @"";
    strAccountType = [dictParams tztObjectForKey:tztTokenType];
    if (strAccountType && strAccountType.length > 0)
        nTokenType = [strAccountType intValue];
    [tztHTTPData replaceValue:sendvalue withValue:dictParams AtTokenType:nTokenType];
    NSString* strAction = [sendvalue tztValueForKey:@"Action"];
    self.nsReqAction = [NSString stringWithFormat:@"%@", strAction];
    if(strAction == nil || [strAction length] <= 0)
    {
        DelObject(sendvalue);
        return;
    }
    NSInteger bSendReq = 0;
    int nReqLinkType = [[dictParams tztObjectForKey:@"ReqLinkType"] intValue];
    
    _ntztReqNo++;
    NSString* strReqno = tztKeyReqno((long)self, _ntztReqNo);
    tztNewReqno *pReqNo = [tztNewReqno reqnoWithString:strReqno];
    [pReqNo setReqdefOne:[strFuncID intValue]];
    strReqno = [pReqNo getReqnoValue];
    [sendvalue setTztObject:strReqno forKey:@"Reqno"];
    if (nReqLinkType == 2)//使用资讯通道
    {
        [[tztMoblieStockComm getSharezxInstance] addObj:self];
        bSendReq = [[tztMoblieStockComm getSharezxInstance] onSendDataAction:strAction withDictValue:sendvalue];
    }
    else //使用交易通道
    {
        [[tztMoblieStockComm getShareInstance] addObj:self];
        bSendReq = [[tztMoblieStockComm getShareInstance] onSendDataAction:strAction withDictValue:sendvalue];
    }
    DelObject(sendvalue);
    _bCancel = FALSE;
    [tztUIProgressView showWithMsg:@"正在下载文件数据..." withdelegate:self];
}

-(void)tztUIProgressViewCancel:(tztUIProgressView *)tztProgressView
{
    _bCancel = TRUE;
    [tztUIProgressView hidden];
}
@end
