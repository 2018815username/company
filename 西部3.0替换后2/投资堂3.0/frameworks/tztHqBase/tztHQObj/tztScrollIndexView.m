/*******************************************************************************
 * Copyright (c)2012, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称：    tztScrollIndexView
 * 文件标识：
 * 摘    要：   指数跑马灯
 *
 * 当前版本：    1.0
 * 作    者：   yinjp
 * 完成日期：    2014－01-17
 *
 * 备    注：
 *
 * 修改记录：
 *
 *******************************************************************************/

#import "tztScrollIndexView.h"

#define _tagScrollIndex 0x2000
#define TZTScrollIndexPath @"Library/Documents/ScrollIndex"

@interface tztScrollCell : UIView
{
    UILabel     *_nameLabel;
    UILabel     *_dataLabel;
    
    UInt32      _nStockType;
}

-(void)initdata;
-(void)setData:(NSArray*)ayData andType:(UInt32)nStockType;
@end

@implementation tztScrollCell

-(void)initdata
{
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    self.backgroundColor = [UIColor tztThemeBackgroundColorHQ];
    CGRect rcFrame = self.bounds;
    UIColor* titleColor = [UIColor tztThemeHQBalanceColor];
    
    UIFont* labFont = tztUIBaseViewTextFont(11.0f);
    
    //名称
    CGRect rcName = rcFrame;
    rcName.size.width = rcFrame.size.width / 3;
    if (_nameLabel == NULL)
    {
        _nameLabel = [[UILabel alloc] initWithFrame:rcName];
        _nameLabel.backgroundColor = [UIColor clearColor];
        _nameLabel.textAlignment = NSTextAlignmentLeft;
        _nameLabel.font = labFont;
        _nameLabel.text = @"--";
        _nameLabel.adjustsFontSizeToFitWidth = YES;
        [self addSubview:_nameLabel];
        [_nameLabel release];
    }
    else
    {
        _nameLabel.frame = rcName;
    }
    _nameLabel.textColor = titleColor;
    
    
    //数据
    rcName.origin.x += rcName.size.width;
    rcName.size.width = rcFrame.size.width / 3 * 2;
    if (_dataLabel == NULL)
    {
        _dataLabel = [[UILabel alloc] initWithFrame:rcName];
        _dataLabel.backgroundColor = [UIColor clearColor];
        _dataLabel.textAlignment = NSTextAlignmentLeft;
        _dataLabel.font = labFont;
        _dataLabel.text = @"--";
        _dataLabel.textColor = titleColor;
        _dataLabel.adjustsFontSizeToFitWidth = YES;
        [self addSubview:_dataLabel];
        [_dataLabel release];
    }
    else
    {
        _dataLabel.frame = rcName;
    }
}

-(void)setData:(NSArray *)ayData andType:(UInt32)nStockType
{
    if (ayData == NULL || ayData.count < 5)
        return;
    
    TZTGridData *ObjName = [ayData objectAtIndex:0];
    TZTGridData *ObjNewPrice = [ayData objectAtIndex:3];
    TZTGridData *ObjRatio = [ayData objectAtIndex:1];
    TZTGridData *ObjRang = [ayData objectAtIndex:2];
    
    if (ObjName == nil || ObjNewPrice == nil || ObjRatio == nil || ObjRang == nil)
        return;
    
    if (_nameLabel)
        _nameLabel.text = ObjName.text;
    
    NSString* strData = [NSString stringWithFormat:@"%@  %@  %@",ObjNewPrice.text, ObjRatio.text, ObjRang.text];//ObjNewPrice.text;
    if (_dataLabel)
    {
        _dataLabel.text = strData;
        _dataLabel.textColor = ObjNewPrice.textColor;
    }
}

@end


@interface tztScrollIndexView ()
{
    int     _nCount;
}
@end

@implementation tztScrollIndexView
@synthesize nMarketType = _nMarketType;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(id)init
{
    if (self = [super init])
    {
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    self.backgroundColor = [UIColor tztThemeBackgroundColorHQ];
    CGRect rcFrame = self.bounds;
    rcFrame.origin.x += 2;
    rcFrame.size.width -= 6;
    
    tztScrollCell *pLabel = (tztScrollCell*)[self viewWithTag:_tagScrollIndex];
    CGRect rcFirst = rcFrame;
    rcFirst.size.width = rcFrame.size.width / 2;
    if (pLabel == NULL)
    {
        pLabel = [[tztScrollCell alloc] initWithFrame:rcFirst];
        pLabel.backgroundColor = [UIColor tztThemeBackgroundColorHQ];
        pLabel.tag = _tagScrollIndex;
        [self addSubview:pLabel];
        [pLabel release];
    }
    else
    {
        pLabel.frame = rcFirst;
    }
    
    rcFirst.origin.x += rcFirst.size.width + 2;
    tztScrollCell *pLabel1 = (tztScrollCell*)[self viewWithTag:_tagScrollIndex + 1];
    if (pLabel1 == NULL)
    {
        pLabel1 = [[tztScrollCell alloc] initWithFrame:rcFirst];
        pLabel1.backgroundColor = [UIColor tztThemeBackgroundColorHQ];
        pLabel1.tag = _tagScrollIndex+1;
        [self addSubview:pLabel1];
        [pLabel1 release];
    }
    else
    {
        pLabel1.frame = rcFirst;
    }
}

-(void)initdata
{
    self.backgroundColor = [UIColor tztThemeBackgroundColorHQ];
    [[tztMoblieStockComm getSharehqInstance] addObj:self];
}

-(void)dealloc
{
    [[tztMoblieStockComm getSharehqInstance] removeObj:self];
    [super dealloc];
}

//请求数据
-(void)onRequestData:(BOOL)bShowProcess
{
    if(_bRequest)
    {
        NSMutableDictionary* sendvalue = NewObject(NSMutableDictionary);
        [sendvalue setTztObject:@"0" forKey:@"StartPos"];
        [sendvalue setTztObject:@"2" forKey:@"MaxCount"];
        [sendvalue setTztObject:@"9" forKey:@"AccountIndex"];
        [sendvalue setTztObject:@"0" forKey:@"Direction"];
        [sendvalue setTztObject:@"1" forKey:@"DeviceType"];
        [sendvalue setTztObject:@"1" forKey:@"Lead"];
        [sendvalue setTztObject:@"1" forKey:@"NewMarketNo"];
        if (MakeMarket(_nMarketType) == HQ_HK_MARKET)
            [sendvalue setTztObject:@"1A0001,HSI" forKey:@"Grid"];
        else
            [sendvalue setTztObject:@"1A0001,2A01" forKey:@"Grid"];
#ifdef tzt_CheckUserLogin
        if (g_nLogVolume >= 0)
        {
            [sendvalue setTztObject:[NSString stringWithFormat:@"%d", g_nLogVolume] forKey:@"LogVolume"];
        }
#endif
        _ntztHqReq++;
        if(_ntztHqReq >= UINT16_MAX)
            _ntztHqReq = 1;
        NSString* strReqno = tztKeyReqno((long)self, _ntztHqReq);
        [sendvalue setTztObject:strReqno forKey:@"Reqno"];
        [[tztMoblieStockComm getSharehqInstance] onSendDataAction:@"20401" withDictValue:sendvalue];
        DelObject(sendvalue);
        
        [self readParse];
    }
    [super onRequestData:bShowProcess];
}


-(NSUInteger)OnCommNotify:(NSUInteger)wParam lParam_:(NSUInteger)lParam
{
    if (wParam == 0)
        return 0;
    
    tztNewMSParse *pParse = (tztNewMSParse*)wParam;
    if ([pParse IsIphoneKey:(long)self reqno:_ntztHqReq])
    {
        return [self dealParse:pParse IsRead:FALSE];
    }
    return 1;
}

-(NSUInteger)dealParse:(tztNewMSParse*)parse IsRead:(BOOL)bRead
{
    if([parse GetAction] == 20401)
    {
        NSMutableArray* ayTitle = NewObject(NSMutableArray);
        NSMutableArray* ayGridData = NewObject(NSMutableArray);
        
        NSData* DataGrid = [parse GetNSData:@"Grid"];
        if(DataGrid && [DataGrid length] > 0)
        {
//            _countindex = [parse GetIntByName:@"MaxCount"];
            
            NSData* DataBinData = [parse GetNSData:@"BinData"];
            if(DataBinData && [DataBinData length] > 0)
            {
                NSString* strValue = [parse GetByNameUnicode:@"Grid"];
                NSArray* ayData = [strValue componentsSeparatedByString:@"\r\n"];
                if(ayData == nil || [ayData count] <= 0)
                {
                    DelObject(ayTitle);
                    DelObject(ayGridData);
                    return 0;
                }
                NSString* strTitle = [ayData objectAtIndex:0];
                NSArray* ayValue = [strTitle componentsSeparatedByString:@"|"];
                
                NSString* strBase = [parse GetByName:@"BinData"];
                DataBinData = [NSData tztdataFromBase64String:strBase];
                char *pColor = (char*)[DataBinData bytes];
                
                if(pColor)
                    pColor = pColor + 2;//时间 2个字节
                for (int i = 0; i < [ayValue count] - 1; i++)
                {
                    TZTGridDataTitle* obj = NewObject(TZTGridDataTitle);
                    NSString* str = [ayValue objectAtIndex:i];
                    obj.text = str;
                    
                    if(pColor)
                        obj.textColor = [UIColor colorWithChar:*pColor];
                    [obj setTagValue];
                    [ayTitle addObject:obj];
                    
                    if(pColor)
                        pColor++;
                    [obj release];
                }
                
                //市场类型
                NSString* strGridType = [parse GetByName:@"NewMarketNo"];
                if (strGridType == NULL || strGridType.length < 1)
                    strGridType = [parse GetByName:@"DeviceType"];
                NSArray* ayGridType = [strGridType componentsSeparatedByString:@"|"];
                
                int StockNameIndex= [parse GetIntByName:@"StockNameIndex"]; //股票名称
                int UpDownPIndex=[parse GetIntByName:@"UpDownPIndex"]; //涨跌幅
                int NewPriceIndex=[parse GetIntByName:@"NewPriceIndex"]; //最新价
                int UpDownIndex=[parse GetIntByName:@"UpDownIndex"]; //涨跌
                //                int TotalMIndex=[parse GetIntByName:@"TotalMIndex"];
                int StockCodeIndex=[parse GetIntByName:@"StockCodeIndex"]; //股票代码
                BOOL bHaveIndex = (StockNameIndex >= 0 && UpDownPIndex >= 0 && NewPriceIndex >= 0
                                   && UpDownIndex >= 0 && StockCodeIndex >= 0); //带序号返回
                for (int i = 1; i < [ayData count]; i++)
                {
                    NSString* strData = [ayData objectAtIndex:i];
                    if(strData && [strData length] > 0)
                    {
                        NSArray* ayDataVal = [strData componentsSeparatedByString:@"|"];
                        NSMutableArray* ayGridValue = NewObject(NSMutableArray);
                        NSInteger nDataCount = [ayDataVal count]-1; //总数据数
                        if(bHaveIndex && StockNameIndex >= 0 && StockNameIndex < nDataCount)
                        {
                            TZTGridData* GridData = NewObject(TZTGridData);
                            NSString *strName = [ayDataVal objectAtIndex:StockNameIndex];
                            NSArray *ay = [strName componentsSeparatedByString:@"."];
                            if ([ay count] > 1)
                            {
                                GridData.text = [ay objectAtIndex:1];// [ayDataVal objectAtIndex:StockNameIndex];
                            }
                            else
                                GridData.text = strName;
                            if(pColor)
                            {
                                char* pColorData = pColor + StockNameIndex + (i-1) * nDataCount;
                                if(pColorData)
                                {
                                    if( *pColorData == -1)
                                        GridData.textColor = [UIColor blackColor];
                                    else
                                        GridData.textColor = [UIColor colorWithChar:*pColorData];
                                }
                            }
                            [ayGridValue addObject:GridData];
                            [GridData release];
                        }
                        else
                        {
                            bHaveIndex = FALSE;
                        }
                        
                        if(bHaveIndex && UpDownIndex >= 0 && UpDownIndex < nDataCount)
                        {
                            TZTGridData* GridData = NewObject(TZTGridData);
                            GridData.text = [ayDataVal objectAtIndex:UpDownIndex];
                            if(pColor)
                            {
                                char* pColorData = pColor + UpDownIndex + (i-1) * nDataCount;
                                if(pColorData)
                                {
                                    if(*pColorData == -1)
                                        GridData.textColor = [UIColor blackColor];
                                    else
                                        GridData.textColor = [UIColor colorWithChar:*pColorData];
                                }
                            }
                            [ayGridValue addObject:GridData];
                            [GridData release];
                        }
                        else
                        {
                            bHaveIndex = FALSE;
                        }
                        
                        if(bHaveIndex && UpDownPIndex >= 0 && UpDownPIndex < nDataCount)
                        {
                            TZTGridData* GridData = NewObject(TZTGridData);
                            GridData.text = [ayDataVal objectAtIndex:UpDownPIndex];
                            if (pColor)
                            {
                                char* pColorData = pColor + UpDownPIndex+ (i-1) * nDataCount;
                                if(pColorData)
                                {
                                    if(*pColorData == -1)
                                        GridData.textColor = [UIColor blackColor];
                                    else
                                        GridData.textColor = [UIColor colorWithChar:*pColorData];
                                }
                            }
                            [ayGridValue addObject:GridData];
                            [GridData release];
                        }
                        else
                        {
                            bHaveIndex = FALSE;
                        }
                        
                        if(bHaveIndex && NewPriceIndex >= 0 && NewPriceIndex < nDataCount)
                        {
                            TZTGridData* GridData = NewObject(TZTGridData);
                            GridData.text = [ayDataVal objectAtIndex:NewPriceIndex];
                            if(pColor)
                            {
                                char* pColorData = pColor + NewPriceIndex+ (i-1) * nDataCount;
                                if(pColorData)
                                {
                                    if(*pColorData == -1)
                                        GridData.textColor = [UIColor blackColor];
                                    else
                                        GridData.textColor = [UIColor colorWithChar:*pColorData];
                                }
                            }
                            [ayGridValue addObject:GridData];
                            [GridData release];
                        }
                        else
                        {
                            bHaveIndex = FALSE;
                        }
                        
                        if(bHaveIndex && StockCodeIndex >= 0 && StockCodeIndex < nDataCount)
                        {
                            TZTGridData* GridData = NewObject(TZTGridData);
                            GridData.text = [ayDataVal objectAtIndex:StockCodeIndex];
                            if(pColor)
                            {
                                char* pColorData = pColor + StockCodeIndex + (i-1) * nDataCount;
                                if(pColorData)
                                {
                                    if(*pColorData == -1)
                                        GridData.textColor = [UIColor blackColor];
                                    else
                                        GridData.textColor = [UIColor colorWithChar:*pColorData];
                                }
                            }
                            [ayGridValue addObject:GridData];
                            [GridData release];
                        }
                        else
                        {
                            bHaveIndex = FALSE;
                        }
                        
                        if(!bHaveIndex)
                        {
                            [ayGridValue removeAllObjects];
                            for (int j = 0; j < nDataCount; j++)
                            {
                                TZTGridData* GridData = NewObject(TZTGridData);
                                GridData.text = [ayDataVal objectAtIndex:j];
                                if(pColor)
                                {
                                    char* pColorData = pColor + j + (i-1) * nDataCount;
                                    if(pColorData)
                                    {
                                        if(*pColorData == -1)
                                            GridData.textColor = [UIColor blackColor];
                                        else
                                            GridData.textColor = [UIColor colorWithChar:*pColorData];
                                    }
                                }
                                [ayGridValue addObject:GridData];
                                [GridData release];
                            }
                        }
                        UInt32 nStockType = 0;
                        if ( (i-1) >= 0 && (i-1) < [ayGridType count])
                        {
                            nStockType = [[ayGridType objectAtIndex:(i-1)] intValue];
                        }
                        [ayGridData addObject:ayGridValue];
                        tztScrollCell* pageCell = (tztScrollCell*)[self viewWithTag:_tagScrollIndex+i-1];
                        
                        if(pageCell)
                        {
                            [pageCell setData:ayGridValue andType:nStockType];
                        }
                        [ayGridValue release];
                    }
                }
            }
        }
        [ayGridData release];
        [ayTitle release];
        
        //外汇每次都更新 所以不保存 保存本地数据 yangdl 20130812
        if ( !bRead )
        {
            dispatch_queue_t FileWriteQueue = dispatch_queue_create("filewrite", NULL);
            dispatch_async (FileWriteQueue,^
                            {
                                NSString* strPath = [NSString stringWithFormat:@"%@/%@/%d.data",NSHomeDirectory(),TZTScrollIndexPath,1];
                                [parse WriteParse:strPath];
                            }
                            );
            dispatch_release(FileWriteQueue);
        }
        
    }
    return 1;
}

-(void)readParse
{
    dispatch_queue_t FileWriteQueue = dispatch_queue_create("filewrite", NULL);
    dispatch_async(FileWriteQueue, ^
                   {
                       NSString *strPath = [NSString stringWithFormat:@"%@/%@/%d.data", NSHomeDirectory(), TZTScrollIndexPath,1];
                       tztNewMSParse *parse = NewObject(tztNewMSParse);
                       [parse ReadParse:strPath];
                       dispatch_block_t block = ^{ @autoreleasepool {
                           [self dealParse:parse IsRead:TRUE];
                       }};
                       if (dispatch_get_current_queue() == dispatch_get_main_queue())
                           block();
                       else
                           dispatch_sync(dispatch_get_main_queue(), block);
                       [parse release];
                   });
    dispatch_release(FileWriteQueue);
}
@end
