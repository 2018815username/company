/*******************************************************************************
 * Copyright (c)2012, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称：    InitStockCode
 * 文件标识：
 * 摘    要：   下载本地代码表
 *
 * 当前版本：
 * 作    者：   yinjp
 * 完成日期：    20130829
 *
 * 备    注：
 *
 * 修改记录：
 *
 *******************************************************************************/

#import "tztInitStockCode.h"
#import "TZTInitReportMarketMenu.h"

tztInitStockCode    *g_pInitStockCode;

#define tztDataBaseName   @"tztInitStockInfo.db"
#define tztStockTable   @"tztStockTable"
#define tztMarketTable  @"tztMarketTable"
#define tztUpDateTable  @"tztUpDateTable"
#define tztQueryView    @"tztQueryView"
@interface tztInitStockCode()
{
    NSMutableArray      *_aySearchResult;
}
NSComparisonResult compareStock(tztStockInfo *firstStock, tztStockInfo *secondStock, void *context);
@end

@implementation tztInitStockCode
-(id)init
{
    self = [super init];
    if (self)
    {
        [self initdata];
    }
    return self;
}

-(void)dealloc
{
    [[tztMoblieStockComm getSharehqInstance] removeObj:self];
    DelObject(_tztDB);
    [super dealloc];
}

-(void)initdata
{
    if(_tztDB == nil)
    {
        _tztDB = NewObject(tztDataBase);
        _tztDB.nsDataBaseName = tztDataBaseName;
    }
    [[tztMoblieStockComm getSharehqInstance] addObj:self];
    [self RequestInitStockCode];
}

//取初始化代码表数据
-(void)RequestInitStockCode
{
    BOOL bReq = FALSE;
    if(!bReq)
    {
        NSString* strSQL = [NSString stringWithFormat:@"SELECT * FROM %@", tztUpDateTable];
        NSMutableArray *ay = [_tztDB tztSearchRecord:strSQL];
        NSString* strBeginDate = @"";
        if (ay && [ay count] > 0)
        {
            NSArray *aySub = [ay objectAtIndex:0];
            if (aySub && [aySub count] > 0)
            strBeginDate = [aySub objectAtIndex:0];
        }
        [_tztDB tztCloseDataBase];
        //需要读取数据库判断
        
        //当前已经存在文件了，则不全部请求，只请求增量数据
        if ([strBeginDate length] > 0)
        {
            [self RequestInitChanged:strBeginDate];
            return;
        }
        NSMutableDictionary *pDict = NewObject(NSMutableDictionary);
        
        _ntztReqNo++;
        if (_ntztReqNo >= UINT16_MAX)
            _ntztReqNo = 1;
        
        NSString *strReqno = tztKeyReqno((long)self, _ntztReqNo);
        [pDict setTztValue:strReqno forKey:@"Reqno"];
        [pDict setTztObject:@"1" forKey:tztIphoneReSend];//重发
        [[tztMoblieStockComm getSharehqInstance] onSendDataAction:@"41059" withDictValue:pDict];
        DelObject(pDict);
    }
}

//请求增量信息
-(void)RequestInitChanged:(NSString *)strBeginDate
{
    NSMutableDictionary *pDict = NewObject(NSMutableDictionary);
    
    _ntztReqNo++;
    if (_ntztReqNo >= UINT16_MAX)
        _ntztReqNo = 1;
    
    NSString *strReqno = tztKeyReqno((long)self, _ntztReqNo);
    [pDict setTztValue:strReqno forKey:@"Reqno"];
    [pDict setTztValue:strBeginDate forKey:@"BeginDate"];
    [pDict setTztObject:@"1" forKey:tztIphoneReSend];//重发
    [[tztMoblieStockComm getSharehqInstance] onSendDataAction:@"41056" withDictValue:pDict];
    DelObject(pDict);
}


-(NSUInteger)OnCommNotify:(NSUInteger)wParam lParam_:(NSUInteger)lParam
{
    tztNewMSParse *pParse = (tztNewMSParse*)wParam;
    if (pParse == NULL)
        return 0;
    if (![pParse IsIphoneKey:(long)self reqno:_ntztReqNo])
        return 0;
    
    
    NSString* strErrMsg = [pParse GetErrorMessage];
    if (strErrMsg)
        TZTNSLog(@"%@", strErrMsg);
    
    
    if ([pParse GetErrorNo] < 0)
    {
        return 0;
    }
    if ([pParse IsAction:@"41059"] || [pParse IsAction:@"41056"])
    {
        [pParse retain];
        dispatch_queue_t downloadQueue = dispatch_queue_create("downloadcode", NULL);
        dispatch_async(downloadQueue,^
                       {
                           if ([pParse IsAction:@"41059"])
                           {
                               NSMutableArray *ayGrid = (NSMutableArray*)[pParse GetArrayByName:@"Grid"];
                               NSMutableArray *ayMarket = (NSMutableArray*)[pParse GetArrayByName:@"BinData"];
                               NSString* nsDate = [pParse GetByName:@"ENDDATE"];
                               if (nsDate == NULL || nsDate.length < 1)
                                   nsDate = @"20130829";
                               
                               if (ayGrid == NULL || [ayGrid count] < 1)
                               {
                                   [pParse release];
                                   return;
                               }
                               [self DealIniteStockInfo:nsDate CodeList:ayGrid MarketList:ayMarket];
                           }
                           else if([pParse IsAction:@"41056"])
                           {
                               /*
                                <GRID0>内容</GRID0>：市场|股票代码|股票名称|拼音1|拼音2|状态|
                                状态：1新增 2修改 3删除
                                */
                               NSMutableArray *ayGrid = (NSMutableArray*)[pParse GetArrayByName:@"Grid"];
                               if (ayGrid == NULL || [ayGrid count] < 1)
                               {
                                   [pParse release];
                                   return;
                               }
                               NSString* nsDate = [pParse GetByName:@"ENDDATE"];
                               NSMutableArray *ayMarket = (NSMutableArray*)[pParse GetArrayByName:@"BINDATA"];
                               [self DealChangeStockInfo:nsDate CodeList:ayGrid MarketList:ayMarket];
                           }
                           [pParse release];
               dispatch_async(dispatch_get_main_queue(),^
                              {
                                  
                              }
                              );
                           
        });
        dispatch_release(downloadQueue);
    }
    return 1;
}

- (void)DealChangeStockInfo:(NSString *)strEndDate CodeList:(NSMutableArray *)ayCode MarketList:(NSMutableArray *)aymarket
{
    [_tztDB tztOpenDataBase];
    @try
    {
        NSString* nsSQL = @"BEGIN";
        BOOL bSucess = FALSE;
        bSucess = [_tztDB tztExecSQL:nsSQL];
        if(bSucess)
        {
            for (int i = 0; i < [aymarket count] && bSucess; i++)
            {
                NSArray *ay = [aymarket objectAtIndex:i];
                if (ay == NULL || [ay count] < 3)
                    continue;
                NSString* nsState = [ay objectAtIndex:2];
                NSString* strMarkType = [ay objectAtIndex:0];
                NSString* strOrder = [ay objectAtIndex:1];
                nsSQL = [NSString stringWithFormat:@"delete from %@ where Market = %@",tztMarketTable,strMarkType];
                bSucess = [_tztDB tztExecSQL:nsSQL];
                if(bSucess)
                {
                    if([nsState intValue] == 2)
                    {
                        nsSQL = [NSString stringWithFormat:@"delete from %@ where Market = %@",tztStockTable,strMarkType];
                        bSucess = [_tztDB tztExecSQL:nsSQL];
                    }
                    else
                    {
                        nsSQL = [NSString stringWithFormat:@"insert into %@ values (%@,%@)",tztMarketTable,strMarkType,strOrder];
                        bSucess = [_tztDB tztExecSQL:nsSQL];
                    }
                }
            }
            
            for (int i = 0; i < [ayCode count] && bSucess ; i++)
            {
                NSArray *ay = [ayCode objectAtIndex:i];
                if (ay == NULL || [ay count] < 5)
                    continue;
                NSString* nsState = [ay objectAtIndex:4];
                NSString* strMarkType = [ay objectAtIndex:0];
                NSString* strCode  = [ay objectAtIndex:1];
                NSString* strName  = [ay objectAtIndex:2];
                NSString* strPy  = [ay objectAtIndex:3];
                //市场类型,代码,名称,拼音,状态
                nsSQL = [NSString stringWithFormat:@"delete from %@ where Code = \"%@\" and Market = %@",tztStockTable,strCode,strMarkType];
                bSucess = [_tztDB tztExecSQL:nsSQL];
                if(bSucess && [nsState intValue] != 3)
                {
                    nsSQL = [NSString stringWithFormat:@"insert into %@ values (%@,\"%@\",\"%@\",\"%@\")",tztStockTable,strMarkType,strCode,strName,strPy];
                    bSucess = [_tztDB tztExecSQL:nsSQL];
                }
            }
            
            if(bSucess)
            {
                NSString* nsSQL = [NSString stringWithFormat:@"update %@ set tztDate = '%@'", tztUpDateTable,strEndDate];
                bSucess = [_tztDB tztExecSQL:nsSQL];
            }
            if(bSucess)
            {
                nsSQL = @"COMMIT";
                [_tztDB tztExecSQL:nsSQL];
            }
            else
            {
                nsSQL = @"ROLLBACK";
                [_tztDB tztExecSQL:nsSQL];
            }
        }
    }
    @catch (NSException *exception)
    {
        NSString* nsSQL = @"ROLLBACK";
        [_tztDB tztExecSQL:nsSQL];
    }
    @finally
    {
    }
}

-(void)DealIniteStockInfo:(NSString *)strEndDate CodeList:(NSMutableArray *)ayCode MarketList:(NSMutableArray *)aymarket
{
    //打开创建数据库
    [_tztDB tztOpenDataBase];
    BOOL bSucess = FALSE;
    NSMutableArray *pAyKeyAndType = NewObject(NSMutableArray);
    
    NSMutableDictionary *pDict = NewObject(NSMutableDictionary);
    [pDict setTztObject:@"SHORT" forKey:@"Market"];
    [pAyKeyAndType addObject:pDict];
    DelObject(pDict);
    
    pDict = NewObject(NSMutableDictionary);
    [pDict setTztObject:@"TEXT" forKey:@"Code"];
    [pAyKeyAndType addObject:pDict];
    DelObject(pDict);
    
    pDict = NewObject(NSMutableDictionary);
    [pDict setTztObject:@"TEXT" forKey:@"NAME"];
    [pAyKeyAndType addObject:pDict];
    DelObject(pDict);
    
    pDict = NewObject(NSMutableDictionary);
    [pDict setTztObject:@"TEXT" forKey:@"PYJC"];
    [pAyKeyAndType addObject:pDict];
    DelObject(pDict);
    
    NSMutableArray *pAyIndex = NewObjectAutoD(NSMutableArray);
    [pAyIndex addObject:@"Market"];
    [pAyIndex addObject:@"Code"];
    [pAyIndex addObject:@"PYJC"];
    [_tztDB tztCreateTable:tztStockTable withKey_:pAyKeyAndType andIndexKey_:pAyIndex];
    bSucess = [_tztDB tztInserRecord:ayCode ayColumn_:pAyKeyAndType withTableName_:tztStockTable];
    
//    NSString* nsSQL = [NSString stringWithFormat:@"create view %@ as SELECT  b.Market,a.CODE ,a.NAME, a.PYJC,b.OrderID FROM tztStockTable as a left outer join tztMarketTable as b on a.Market = b.Market WHERE  b.Market > 0 ", tztQueryView];
//    [_tztDB tztExecSQL:nsSQL];
    
    if(bSucess)
    {
        //创建Market表格
        [pAyKeyAndType removeAllObjects];
        pDict = NewObject(NSMutableDictionary);
        [pDict setTztObject:@"SHORT" forKey:@"Market"];
        [pAyKeyAndType addObject:pDict];
        DelObject(pDict);
        
        pDict = NewObject(NSMutableDictionary);
        [pDict setTztObject:@"SHORT" forKey:@"OrderID"];
        [pAyKeyAndType addObject:pDict];
        DelObject(pDict);
        [_tztDB tztCreateTable:tztMarketTable withKey_:pAyKeyAndType andIndexKey_:(NSMutableArray*)[NSArray arrayWithObjects:@"Market", nil]];
        bSucess = [_tztDB tztInserRecord:aymarket ayColumn_:pAyKeyAndType withTableName_:tztMarketTable];
    }
    
    if(bSucess)
    {
        [pAyKeyAndType removeAllObjects];
        pDict = NewObject(NSMutableDictionary);
        [pDict setTztObject:@"TEXT" forKey:@"tztDate"];
        [pAyKeyAndType addObject:pDict];
        DelObject(pDict);
        [_tztDB tztCreateTable:tztUpDateTable withKey_:pAyKeyAndType andIndexKey_:nil];
        
        NSString* nsSQL = [NSString stringWithFormat:@"INSERT INTO %@(tztDate) VALUES('%@')", tztUpDateTable,strEndDate];
        [_tztDB tztExecSQL:nsSQL];
    }
    DelObject(pAyKeyAndType);
    return;
}


//本地查询
/*1、上证、深证其中有股票、债券、基金等等，要按：
 上证股票、深证股票、上证其他市场、深证其他市场顺序
 2、输入600之类就将上证的排前面，输入001之类的就将深证的排前面
 */
-(NSMutableArray*)SearchStockLocal:(NSString*)nsText
{
    if (nsText == NULL || nsText.length < 1)
    {
        return NULL;
    }
    //distinct
    NSString* strSQL = [NSString stringWithFormat:@"SELECT Market,Code,NAME FROM %@ WHERE Code like '%%%@%%' or NAME like '%%%@%%' or PYJC like '%%%@%%'  order by OrderID,Code ASC limit 100", tztQueryView, nsText,nsText, nsText];
    NSMutableArray *ay = [_tztDB tztSearchRecord:strSQL];// [_tztDB tztSearchRecord:pDict withTableName_:@"tztStockTable"];
    
    NSMutableArray *pAyReturn = NewObjectAutoD(NSMutableArray);
    //    [_aySearchResult removeAllObjects];
    for (int i = 0; i < [ay count]; i++)
    {
        NSMutableArray *pAy = [ay objectAtIndex:i];
        if (pAy == NULL || [pAy count] < 3)
            continue;
        
        NSString* strCode = [pAy objectAtIndex:1];
        NSString* strName = [pAy objectAtIndex:2];
        NSString* strMarket = [pAy objectAtIndex:0];
        
        tztStockInfo *pStock = NewObject(tztStockInfo);
        pStock.stockCode = [NSString stringWithFormat:@"%@", strCode];
        pStock.stockName = [NSString stringWithFormat:@"%@", strName];
        pStock.stockType = [strMarket intValue];
        [pAyReturn addObject:pStock];
        [pStock release];
    }
    return pAyReturn;
}
@end
