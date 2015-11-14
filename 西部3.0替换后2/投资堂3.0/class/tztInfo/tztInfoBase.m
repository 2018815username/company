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

#import "tztInfoBase.h"
#define TZTInfoPath @"Library/Documents/Info"

@implementation tztInfoItem
@synthesize IndexID = _IndexID;
@synthesize InfoContent = _InfoContent;
@synthesize InfoSubCount = _InfoSubCount;
@synthesize nIsIndex = _nIsIndex;
@synthesize InfoTime = _InfoTime;
@synthesize InfoTitle = _InfoTitle;
@synthesize nLevel = _nLevel;

-(id)init
{
    if (self = [super init])
    {
        _IndexID = @"";
        _InfoContent = @"";
        _InfoSubCount = @"";
        _InfoTitle = @"";
        _InfoTime = @"";
        _nIsIndex = 1;
    }
    return self;
}

-(void)dealloc
{
    [super dealloc];
}

@end

@implementation tztInfoBase
@synthesize nStartPos = _nStartPos;
@synthesize nMaxCount = _nMaxCount;
@synthesize nHaveCur = _nHaveCur;
@synthesize menuID = _menuID;
@synthesize ayInfoData = _ayInfoData;
@synthesize hSString = _hSString;

@synthesize nIsMenu = _nIsMenu;
@synthesize nsOp_Type = _nsOp_Type;
@synthesize pDelegate = _pDelegate;
@synthesize nHaveMax = _nHaveMax;
@synthesize bRequestList = _bRequestList;
@synthesize menuKind = _menuKind;

-(id)init
{
    if (self = [super init])
    {
        _nStartPos = 1;
        _nMaxCount = 10;
        _nIsMenu = 1;
        
        _nHaveCur = 0;
        _nHaveMax = 0;
        
        _nsOp_Type = @"0";
        _bRequestList = FALSE;
        
        _bShowLocal = FALSE; //显示本地数据
        _hSString = @"";
        _menuID = @"";
        _ayInfoData = NewObject(NSMutableArray);
    }
    
    [[tztMoblieStockComm getSharehqInstance] addObj:self];
    return self;
}

-(void)dealloc
{
    NilObject(self.pDelegate);
    [[tztMoblieStockComm getSharehqInstance] removeObj:self];
    if (_ayInfoData)
    {
        [_ayInfoData removeAllObjects];
        [_ayInfoData release];
        _ayInfoData = nil;
    }
    if (_titleDate)
        [_titleDate release];
    [super dealloc];
}
-(void)acquireDate:(id)Date // 获取时间
{
    if (_titleDate)
        [_titleDate release];
    _titleDate= [Date retain];
}

-(void)ClearData
{
    [self.ayInfoData removeAllObjects];
    if (self.pDelegate && [self.pDelegate respondsToSelector:@selector(SetInfoData:)])
    {
        [self.pDelegate SetInfoData:self.ayInfoData];
    }
    _nStartPos = 1;
    _nHaveCur = 0;
    _nHaveMax = 0;
    _nsOp_Type = @"0";
    _bShowLocal = FALSE;
    _hSString = @"";
    _menuID = @"";
    _pDelegate = nil;
}
//xinlan 获取首页咨询二级标题
- (void)setMenu:(NSString *)title infoContetn:(NSString *)text
{
    _infoContent=text;
    _menuTitle=title;
}

//首页咨询在这里服务器发送请求 原40130 44151 80
-(NSInteger)GetMenu:(NSString *)nsMenuID retStr_:(NSMutableData *)retStr
{
    if (nsMenuID == nil)
    {
        nsMenuID = self.menuID;
    }
    else
    {
        self.MenuID = [NSString stringWithFormat:@"%@", nsMenuID];
    }
    
    int nAction = 0;
    //请求的是
    if (self.pStockInfo.stockCode != NULL && [self.pStockInfo.stockCode length] > 0)
    {
        if (nsMenuID == NULL || [nsMenuID length] <= 0)
        {
            nAction = 81;
        }
        else
        {
            nAction = 82;
        }
    }
    else
    {
#ifdef Old_Info_Fuction
        nAction = 80;
#else
//        xinlan 首页资讯 改成 44151 一创的
#ifdef kSUPPORT_FIRST
            nAction =  44151;
#else
//        源代码
            nAction = 40130;
#endif
        
#endif
    }
    
    _ntztReqNo++;
    if (_ntztReqNo >= UINT16_MAX)
        _ntztReqNo = 1;
    
    NSMutableDictionary *pDict = NewObject(NSMutableDictionary);
    
    NSString* strReqno = tztKeyReqno((long)self, _ntztReqNo);
    [pDict setTztValue:strReqno forKey:@"Reqno"];
    
    if (self.pStockInfo && self.pStockInfo.stockCode && [self.pStockInfo.stockCode length] > 0)
    {
        [pDict setTztValue:self.pStockInfo.stockCode forKey:@"StockCode"];
    }
    if (_hSString && [_hSString length] > 0)
    {
        [pDict setTztValue:_hSString forKey:@"HsString"];
    }
    
    if (_hSString && [_hSString length] > 0 && nAction == 82 && (_bRequestList || !IS_TZTIPAD))
    {
        NSArray* ayIndex = [_hSString componentsSeparatedByString:@"ID"];
        if(ayIndex && [ayIndex count] > 1 ) //信息地雷
        {
            NSString* strID = [NSString stringWithFormat:@"%@\r\niphoneKey=%ld\r\n",_hSString,(long)self];
            [pDict setTztValue:strID forKey:@"HsString"];
            
            NSString* strInfoID = [ayIndex objectAtIndex:1];
            NSString* strMenu = [ayIndex objectAtIndex:0];
            if([strMenu compare:@"000"] == NSOrderedSame)//信息地雷
                _nStartPos = [strInfoID intValue] + 1;
        }
        else
        {
            NSString* strID = [NSString stringWithFormat:@"%@\r\niphoneKey=%ld\r\n",_hSString,(long)self];
            [pDict setTztValue:strID forKey:@"HsString"];
        }
    }
    
    if (nAction == 44151||nAction == 40130 || nAction == 80||nAction == 44152) //一创新增加首页资讯的新功能号44151 44152
    {
         if (_hSString && [_hSString length] > 0)
         {
             [pDict setTztValue:_hSString forKey:@"menu_id"];
         }
        else
        {
            [pDict setTztValue:@"" forKey:@"menu_id"];
        }

        if (_nsOp_Type)
        {
            [pDict setTztValue:_nsOp_Type forKey:@"op_type"];
        }
        if (_menuKind && ![_menuKind isEqualToString:@"0"])
        {
            [pDict setTztValue:_menuKind forKey:@"menu_kind"];
        }
    }
    
    [pDict setTztValue:[NSString stringWithFormat:@"%d", (int)_nStartPos] forKey:@"StartPos"];
    [pDict setTztValue:[NSString stringWithFormat:@"%d", (int)_nMaxCount] forKey:@"MaxCount"];
    [pDict setTztValue:[NSString stringWithFormat:@"%d", (int)_nMaxCount] forKey:@"Volume"];
    
#ifdef kSUPPORT_FIRST
        if([_hSString isEqual:@"805632192"]) //根据_hSString判断 首页咨询哪个正标题
        {
            [pDict setTztValue:@"今日关注" forKey:@"Title"];
            if(_infoContent!=Nil) //是否打开咨询正文页面
            {
                nAction=44152;
                [pDict setTztValue:_infoContent forKey:@"str2title"];
            }
            [pDict setTztValue:@"0" forKey:@"StartPos"];
            [pDict setTztValue:@"2" forKey:@"zxfl"];
        }
        else if ([_hSString isEqual:@"2002"])
        {
            [pDict setTztValue:@"特别提示" forKey:@"Title"];
            if(_infoContent!=Nil)
            {
                nAction=44152;
                [pDict setTztValue:_infoContent forKey:@"str2title"];
            }
            [pDict setTztValue:@"0" forKey:@"StartPos"];
            [pDict setTztValue:@"2" forKey:@"zxfl"];

        }
        else if ([_hSString isEqual:@"2081"])
        {
            [pDict setTztValue:@"股评天地" forKey:@"Title"];
            if(_infoContent!=Nil) //是否打开咨询正文页面
            {
                nAction=44152;
                [pDict setTztValue:_infoContent forKey:@"str2title"];
        
            }
       
            [pDict setTztValue:@"0" forKey:@"StartPos"];
            [pDict setTztValue:@"2" forKey:@"zxfl"];
        }
#else
        [pDict setTztValue:[NSString stringWithFormat:@"%ld", (long)_nIsMenu] forKey:@"Title"];
#endif

    [pDict setTztValue:[NSString stringWithFormat:@"%@",_titleDate ] forKey:@"sDate"];
    [[tztMoblieStockComm getSharehqInstance] onSendDataAction:[NSString stringWithFormat:@"%d", nAction] withDictValue:pDict];

    DelObject(pDict);
    return 0;
}

-(NSInteger)GetInfo
{
    int nAction = 41011;
    _ntztReqNo++;
    if (_ntztReqNo >= UINT16_MAX)
        _ntztReqNo = 1;
    NSMutableDictionary *pDict = NewObject(NSMutableDictionary);
    
    NSString* strReqno = tztKeyReqno((long)self, _ntztReqNo);
    [pDict setTztValue:strReqno forKey:@"Reqno"];
    if (_hSString && [_hSString length] > 0)
        [pDict setTztValue:_hSString forKey:@"menu_id"];
    [pDict setTztValue:[NSString stringWithFormat:@"%d", (int)_nStartPos] forKey:@"StartPos"];
    [pDict setTztValue:[NSString stringWithFormat:@"%d", (int)_nMaxCount] forKey:@"MaxCount"];
    [pDict setTztValue:[NSString stringWithFormat:@"%d", (int)_nMaxCount] forKey:@"Volume"];
    [pDict setTztValue:[NSString stringWithFormat:@"%d", (int)_nIsMenu] forKey:@"Title"];
    [pDict setTztValue:@"1" forKey:@"NewMarketNo"];
    
    [[tztMoblieStockComm getSharehqInstance] onSendDataAction:[NSString stringWithFormat:@"%d", nAction] withDictValue:pDict];
    DelObject(pDict);
    return 0;
}

- (NSUInteger)dealParse:(tztNewMSParse*)pParse IsRead:(BOOL)bRead
{
    _bShowLocal = bRead;
    NSString* Datastocktype = [pParse GetValueData:@"NewMarketNo"];
    if (Datastocktype == NULL || Datastocktype.length < 1)
        Datastocktype = [pParse GetValueData:@"stocktype"];
    if(Datastocktype && [Datastocktype length] > 0)
    {
        self.pStockInfo.stockType = [Datastocktype intValue];
    }
    
    NSString* strData = [pParse GetByName:@"MaxCount"];
    _nHaveMax = [strData intValue];
    if(_nHaveCur >= _nHaveMax)
        _nHaveCur = 0;
    NSMutableArray *pAy = nil;
    
    if (_nIsMenu)
    {
        NSArray *pGridAy = [pParse GetArrayByName:@"Grid"];
        if ([pGridAy count] > _nMaxCount)//返回的条数比实际请求的条数多，则认为不需要做翻页处理
        {
            _nMaxCount = _nHaveMax;
        }
        
        BOOL bFlag = FALSE;
        NSString *strMask;
        if ([pParse IsAction:@"44151"]||[pParse IsAction:@"40130"]||[pParse IsAction:@"44152"])  //为了匹配新的 功能号 44151  44152首页资讯
        {
            bFlag = TRUE;
            strMask = [pParse GetByName:@"bMenu"];
        }
        
        if(_nStartPos <= 1) //从起始位置开始请求数据
            [self.ayInfoData removeAllObjects];
        
        if ((pGridAy == NULL || [pGridAy count] <= 0) && !bRead)/*读本地缓存的时候，不加无资讯显示，否则界面会先闪下再显示列表数据*/
        {
            tztInfoItem* pItem = NewObjectAutoD(tztInfoItem);
            pItem.nIsIndex = -1;
            pItem.IndexID = 0;
            NSString* szErrMsg = [pParse GetErrorMessage];
            pItem.InfoContent = szErrMsg;
            if (szErrMsg == NULL || [szErrMsg length] < 1)
            {
                szErrMsg = @"暂无资讯内容";
            }
            pItem.InfoContent = szErrMsg;
            [self.ayInfoData addObject:pItem];
        }
        else
        {
            if ([pParse IsAction:@"41011"])
            {
                [self.ayInfoData removeAllObjects];
                for (int i = 0;i < [pGridAy count] ; i++)
                {
                    pAy = [pGridAy objectAtIndex:i];
                    if (pAy == NULL || [pAy count] < 4)
                        continue;
                    
                    NSString * strIndex = [pAy objectAtIndex:0];
                    if (strIndex == NULL || [strIndex length] < 1)
                        continue;
                    
                    NSString * strDate = [pAy objectAtIndex:1];
//                    _titleDate=[pAy objectAtIndex:1];
                    if (strDate == NULL || [strDate length] < 1)
                        continue;
                    
                    NSString * strTitle  = [pAy objectAtIndex:2];
                    if (strTitle == NULL || [strTitle length] < 1)
                        continue;
                    
                    NSString * strConnten = [pAy objectAtIndex:3];
                    if (strConnten == NULL || [strConnten length] < 1)
                        continue;
                    
                    tztInfoItem* pItem = NewObjectAutoD(tztInfoItem);
                    pItem.IndexID = [NSString stringWithFormat:@"%@", strIndex];
                    pItem.InfoContent = [NSString stringWithFormat:@"%@", strConnten];
                    pItem.InfoSubCount = @"";
                    pItem.nIsIndex = 0;
                    pItem.InfoTitle = [NSString stringWithFormat:@"%@%@",strDate,strTitle];
                    pItem.InfoTime = [NSString stringWithFormat:@"%@", strDate];
                    [self.ayInfoData addObject:pItem];
                    
                }
            }
            else
            {
              
                for (int i = 0; i < [pGridAy count]; i++)
                {
                    pAy = [pGridAy objectAtIndex:i];
//                    源代码 过滤数据
                    NSString* strIndex = @"";
                    NSString* strData = @"";
                    NSString* strTime = @"";
                   
                    // xinlan 为了匹配新的功能号
                    if([pParse IsAction:@"44151"]||[pParse IsAction:@"44152"])
                    {
#ifdef kSUPPORT_FIRST
                            if ([pAy count]<=2) {
                                continue;
                            }
                            strIndex =[pAy objectAtIndex:1];
                            strData = [pAy objectAtIndex:2];
                            strTime =[pAy objectAtIndex:0];
#endif
                    }
                    else
                    {
                        if (pAy == NULL || [pAy count] < 5)
                        {
                        continue;
                        }
                        strIndex = [pAy objectAtIndex:0];
                        strData = [pAy objectAtIndex:1];
                        strTime = @"";

                    }
                    
                    if (bFlag)
                    {
                        if ([pAy count] > 6)
                            strTime = [pAy objectAtIndex:6];
                    }
                    else
                        strMask = [pAy objectAtIndex:4];
                    
                    //截取时间
                    if (strTime.length < 1 && [_hSString caseInsensitiveCompare:@"000"] == NSOrderedSame)
                    {
                        NSRange range = [strData rangeOfString:@" "];
                        if (range.length > 0 && (range.length + range.location) < [strData length])
                        {
                            strTime = [strData substringToIndex:range.location];
                            strData = [strData substringFromIndex:range.location + 1];
                        }
                    }
                    
                    if(strData == nil || [strData length] <= 0)
                        strData = [NSString stringWithFormat:@"说明 %@",strTime];
                    
                    tztInfoItem* pItem = NewObjectAutoD(tztInfoItem);
//                    源代码
                    pItem.nIsIndex = [strMask intValue];
                    pItem.IndexID = [NSString stringWithFormat:@"%@", strIndex];
                    pItem.InfoContent = [NSString stringWithFormat:@"%@", strData];
                    pItem.InfoSubCount = @"";
                    pItem.InfoTime = [NSString stringWithFormat:@"%@", strTime];
                    [self.ayInfoData addObject:pItem];
                }
            }
        }
        
        //存入本地
        if(_nStartPos <= 1 && self.pStockInfo == NULL && self.menuID && [pParse GetAction] > 0 && (!bRead))
        {
            dispatch_queue_t FileWriteQueue = dispatch_queue_create("filewrite", NULL);
            dispatch_async (FileWriteQueue,^
                            {
                                NSString* strPath = [NSString stringWithFormat:@"%@/%@/%@_%d.data",NSHomeDirectory(),TZTInfoPath,self.menuID,[pParse GetAction]];
                                [pParse WriteParse:strPath];
                            }
                            );
            dispatch_release(FileWriteQueue);
        }
    }
    else
    {
        [self.ayInfoData removeAllObjects];
        tztInfoItem* pItem = NewObjectAutoD(tztInfoItem);
        pItem.nIsIndex = -1;
        pItem.IndexID = 0;
        NSString *str = [pParse GetByNameUnicode:@"Grid"];
        if (str && [str length] > 0)
        {
            pItem.InfoContent = str;
        }
        else
        {
            pItem.InfoContent = @"暂无资讯内容";
            if ([pParse GetErrorNo] < 0)
            {
                NSString* szErrMsg = [pParse GetErrorMessage];
                pItem.InfoContent = szErrMsg;
            }
        }
//获取 咨询内容title
        str = [pParse GetByNameUnicode:@"Title"];
        pItem.InfoSubCount = @"";
        if (str && [str length] > 0)
        {
            pItem.InfoTitle = str;
        }
        else
        {
            pItem.InfoTitle = @"";
#ifdef kSUPPORT_FIRST
            pItem.InfoTitle=_infoContent;
#endif

        }
//        获取咨询时间
    
        str = [pParse GetByName:@"Date"];
        if (str && [str length] > 0)
        {
            pItem.InfoTime = str;
        }
        else
        {
            pItem.InfoTime = @"";
#ifdef kSUPPORT_FIRST
            pItem.InfoTime=self.titleDate;
#endif
        }
        //获取资讯来源
        str = [pParse GetByName:@"SOURCE"];
        if (str && [str length] > 0)
        {
            pItem.InfoSource = str;
        }
        else
        {
            pItem.InfoSource = @"";
        }

        
        [self.ayInfoData addObject:pItem];
    }
    
    if (self.pDelegate && [self.pDelegate respondsToSelector:@selector(SetInfoData:)])
    {
        [self.pDelegate SetInfoData:self.ayInfoData];
    }
    return 1;
}

//读取本地数据并刷新
- (void)readParse:(int)nAction
{
    if(self.pStockInfo == NULL && self.menuID && nAction > 0)
    {
        dispatch_queue_t FileWriteQueue = dispatch_queue_create("filewrite", NULL);
        dispatch_async (FileWriteQueue,^
                        {
                            NSString* strPath = [NSString stringWithFormat:@"%@/%@/%@_%d.data",NSHomeDirectory(),TZTInfoPath,self.menuID,nAction];
                            tztNewMSParse* parse = NewObject(tztNewMSParse);
                            [parse ReadParse:strPath];
                            dispatch_block_t block = ^{ @autoreleasepool {
                                [self dealParse:parse IsRead:TRUE];
                            }};
                            if (dispatch_get_current_queue() == dispatch_get_main_queue())
                                block();
                            else
                                dispatch_sync(dispatch_get_main_queue(), block);
                            [parse release];
                        }
                        );
        dispatch_release(FileWriteQueue);
    }
}

-(NSUInteger)OnCommNotify:(NSUInteger)wParam lParam_:(NSUInteger)lParam
{
    tztNewMSParse* pParse = (tztNewMSParse*)wParam;
    if (pParse == NULL)
        return 0;
    
    if (![pParse IsIphoneKey:(long)self reqno:_ntztReqNo]) 
        return 0;
    return [self dealParse:pParse IsRead:FALSE];
}

-(NSInteger) HaveBackPage
{
    if (_nStartPos <= 1)
        return 0;
    return 1;
}

-(NSInteger) HaveNextPage
{
    if (_nHaveMax >= _nStartPos + _nMaxCount)
        return 1;
    return 0;
}

-(BOOL) NextPage
{
    if(_bShowLocal)
        return FALSE;
    
    if (![self HaveNextPage])
        return FALSE;
    if(_nStartPos <= 1)
        _nStartPos = 1;
    _nStartPos += _nMaxCount;
    _nHaveCur = _nStartPos -1;
    [self GetMenu:nil retStr_:nil];
    return  TRUE;
}

-(BOOL) BackPage
{
    if(_bShowLocal)
        return FALSE;
    
    if (![self HaveBackPage])
        return FALSE;
    _nStartPos -= _nMaxCount;
    _nHaveCur = _nStartPos - 1;
    
    if (_nStartPos <= 1)
    {
        _nStartPos = 1;
        _nHaveCur = 0;
        _nHaveMax = 0;
    }
    
    if (_nHaveCur < 0)
        _nHaveCur = 0;
    return TRUE;
}

-(NSInteger) HaveBackContent
{
    if (_nHaveCur > 0)
        return 1;
    return 0;
}

-(NSInteger) HaveNextContent
{
    if (_nHaveCur < [self.ayInfoData count]-1)//还有数据
        return 1;
    return 0;
}

-(BOOL)NextContent
{
    if (![self HaveNextContent])
        return FALSE;
    
    _nHaveCur++;
    //得到下一条的menuID
    
    return TRUE;
}

-(BOOL)BackContent
{
    if (![self HaveBackContent])
        return FALSE;
    
    _nHaveCur--;
    //得到上一条的menuID
    
    return TRUE;
}

@end
