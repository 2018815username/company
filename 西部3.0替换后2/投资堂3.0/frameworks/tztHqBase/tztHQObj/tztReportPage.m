//
//  tztReportPage.m
//  tztMobileApp
//
//  Created by yangdl on 13-1-8.
//  Copyright (c) 2013年 投资堂. All rights reserved.
//

#import "tztReportPage.h"
#import <QuartzCore/QuartzCore.h>

#define _tagReportPage 0x100000
#define TZTReportPagePath @"Library/Documents/ReportPage"

@interface tztReportPageCell :UIView
{
    UILabel *_nameLabel;
    UILabel *_codeLabel;
    UILabel *_priceLabel;
    UILabel *_ratioLabel;
    UILabel *_rangeLabel;
    UInt32  _nStockType;
}
- (void)initdata;
- (void)setData:(NSArray*)ayData andType:(UInt32)nStockType;
- (NSString*)getStockCode;
- (NSString*)getStockName;
- (UInt32) getStockType;
@end

@implementation tztReportPageCell

- (void)initdata
{
}

-(void)layoutSubviews
{
    CGRect rcFrame = self.bounds;
    rcFrame.origin.x += 2;
    rcFrame.size.width -= 8;
    rcFrame.size.height -= 6;
    int nPerHeight = rcFrame.size.height;
    int nPerWidth = rcFrame.size.width  / 2;
    UIColor* titlecolor = [UIColor blackColor];
    CGFloat fontsize = 13.f;
    CGFloat namesize = 15.f;
    CGFloat pricesize = 17.f;
    if (IS_TZTIPAD)
    {
        fontsize = 18.f;
        namesize = 20.f;
        pricesize = 21.f;
    }
    UIFont* labfont = tztUIBaseViewTextFont(fontsize);
    UIFont* namefont = tztUIBaseViewTextBoldFont(namesize);
    //名称
    CGRect rcName = rcFrame;
    rcName.size.width = nPerWidth;
    rcName.size.height = nPerHeight * 2/3;
    if (_nameLabel == nil)
    {
        _nameLabel = [[UILabel alloc] initWithFrame:rcName];
        _nameLabel.backgroundColor = [UIColor clearColor];
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        _nameLabel.textColor = titlecolor;
        _nameLabel.font = namefont;
        _nameLabel.text = @"--";
        _nameLabel.adjustsFontSizeToFitWidth = TRUE;
        [self addSubview:_nameLabel];
        [_nameLabel release];
    }
    else
    {
        _nameLabel.frame = rcName;
    }
    
    //代码
    CGRect rcCode = rcName;
    rcCode.origin.y += rcCode.size.height+2;
    rcCode.size.width = nPerWidth * 2 / 3;
    rcCode.size.height = nPerHeight / 3;
    if (_codeLabel == nil)
    {
        _codeLabel = [[UILabel alloc] initWithFrame:rcCode];
        _codeLabel.backgroundColor = [UIColor clearColor];
        _codeLabel.textAlignment = NSTextAlignmentCenter;
        _codeLabel.font = labfont;
        _codeLabel.text = @"--";
        _codeLabel.textColor = titlecolor;
        _codeLabel.adjustsFontSizeToFitWidth = TRUE;
        [self addSubview:_codeLabel];
        [_codeLabel release];
    }
    else
        _codeLabel.frame = rcCode;
    
    //最新价
    CGRect rcNewPrice = rcName;
    rcNewPrice.origin.x += rcNewPrice.size.width+2;
    if (_priceLabel == nil)
    {
        _priceLabel = [[UILabel alloc] initWithFrame:rcNewPrice];
        _priceLabel.backgroundColor = [UIColor clearColor];
        _priceLabel.textAlignment = NSTextAlignmentCenter;
        _priceLabel.font = tztUIBaseViewTextBoldFont(pricesize);;
        _priceLabel.textColor = [UIColor blackColor];
        _priceLabel.text = @"-.-";
        _priceLabel.adjustsFontSizeToFitWidth = TRUE;
        [self addSubview:_priceLabel];
        [_priceLabel release];
    }
    else
        _priceLabel.frame = rcNewPrice;
    

    //涨跌
    CGRect rcratio = rcCode;
    rcratio.origin.x += rcratio.size.width+2;
    if (_ratioLabel == nil)
    {
        _ratioLabel = [[UILabel alloc] initWithFrame:rcratio];
        _ratioLabel.backgroundColor = [UIColor clearColor];
        _ratioLabel.textAlignment = NSTextAlignmentCenter;
        _ratioLabel.font = labfont;
        _ratioLabel.textColor = [UIColor blackColor];
        _ratioLabel.text = @"-.-";
        _ratioLabel.adjustsFontSizeToFitWidth = TRUE;
        [self addSubview:_ratioLabel];
        [_ratioLabel release];
    }
    else
        _ratioLabel.frame = rcratio;
    
    //涨跌幅
    CGRect rcRang = rcratio;
    rcRang.origin.x += rcRang.size.width+2;
    if (_rangeLabel == nil)
    {
        _rangeLabel = [[UILabel alloc] initWithFrame:rcRang];
        _rangeLabel.backgroundColor = [UIColor clearColor];
        _rangeLabel.textAlignment = NSTextAlignmentCenter;
        _rangeLabel.font = labfont;
        _rangeLabel.textColor = [UIColor blackColor];
        _rangeLabel.text = @"-.-%";
        _rangeLabel.adjustsFontSizeToFitWidth = TRUE;
        [self addSubview:_rangeLabel];
        [_rangeLabel release];
    }
    else
        _rangeLabel.frame = rcRang;

}

- (void)setData:(NSArray*)ayData andType:(UInt32)nStockType
{
    if(ayData == nil || [ayData count] < 5)
        return;
    _nStockType = nStockType;
    TZTGridData *ObjName = [ayData objectAtIndex:0];
    TZTGridData *ObjCode = [ayData objectAtIndex:[ayData count]-1];
    TZTGridData *ObjNewPrice = [ayData objectAtIndex:3];
    TZTGridData *ObjRatio  = [ayData objectAtIndex:1];
    TZTGridData *ObjRang = [ayData objectAtIndex:2];
    
    if (ObjName == nil || 
        ObjCode == nil ||
        ObjNewPrice == nil ||
        ObjRatio == nil ||
        ObjRang == nil )
        return;
    //名称
    if (_nameLabel)
    {
//        _nameLabel.textColor = ObjName.textColor;
        _nameLabel.text = ObjName.text;
    }
    
    //代码
    if (_codeLabel)
    {
//        _codeLabel.textColor = ObjCode.textColor;
        _codeLabel.text = ObjCode.text;
    }
    
    //最新
    if (_priceLabel)
    {
        _priceLabel.textColor = ObjNewPrice.textColor;
        _priceLabel.text = ObjNewPrice.text;
    }
    
    //涨跌
    if (_ratioLabel)
    {
        _ratioLabel.textColor = ObjRatio.textColor;
        _ratioLabel.text = ObjRatio.text;
    }
    
    //涨跌幅
    if (_rangeLabel)
    {
        _rangeLabel.textColor = ObjRang.textColor;
        _rangeLabel.text = ObjRang.text;
    }
}

- (NSString*)getStockCode
{
    if(_codeLabel)
    {
        NSString* strCode = _codeLabel.text;
        if(strCode && [strCode compare:@"--"] == NSOrderedSame)
            strCode = @"";
        return strCode;
    }
    return @"";
}

- (NSString*)getStockName
{
    if (_nameLabel)
    {
        return _nameLabel.text;
    }
    return @"";
}

- (UInt32)getStockType
{
    return _nStockType;
}

- (void)dealloc
{
    [super dealloc];
}

@end


@interface tztReportPage ()
{
    int _countindex;    //总数
    CGPoint _beginPoint;    //点击起始x位置
}
- (BOOL)checkData:(float)checkInt;

@end

@implementation tztReportPage
- (id)init
{
    self = [super init];
    if(self)
    {
        
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) 
    {
    }
    return self;
}

- (void)dealloc
{
    [[tztMoblieStockComm getSharehqInstance] removeObj:self];
    [super dealloc];
}

//初始化数据
- (void)initdata
{
//    [super initdata];
    if ([UIImage imageTztNamed:@"tztReportBG.png"]) {
        [self setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageTztNamed:@"tztReportBG.png"]]];
    }
    else
    {
        
        [self setBackgroundColor:[UIColor colorWithTztRGBStr:@"237, 237, 237"]];
        
    }
    _curindex = 0;
    _cellCount = 2;
    [[tztMoblieStockComm getSharehqInstance] addObj:self];
}

- (void)setCellCount:(int)cellCount
{
    _cellCount = cellCount;
    [self layoutSubviews];
    [self onRequestData:TRUE];
}

-(void)layoutSubviews
{
    CGRect rcFrame = self.bounds;
    if(_cellCount <= 0)
        _cellCount = 2;
//    rcFrame.size.height = MIN(44, rcFrame.size.height);
    rcFrame.origin.x += 2;
    int nPerHeight = rcFrame.size.height;
    int nPerWidth = rcFrame.size.width  / _cellCount;
    
    CGRect rcFirst = rcFrame;
    rcFirst.size.width = nPerWidth;
    rcFirst.size.height = nPerHeight;
    for (int i = 0; i < _cellCount; i++)
    {
        tztReportPageCell* pageCell = (tztReportPageCell*)[self viewWithTag:_tagReportPage + i];
        if (pageCell == nil)
        {
            pageCell = [[tztReportPageCell alloc] initWithFrame:rcFirst];
            pageCell.backgroundColor = [UIColor clearColor];
            pageCell.tag = _tagReportPage + i;
            [self addSubview:pageCell];
            [pageCell release];
        }
        else
        {
            pageCell.frame = rcFirst;
        }
        rcFirst.origin.x += nPerWidth;
    }
}

//清空数据
- (void)onClearData
{
    
}

//请求数据
- (void)onRequestData:(BOOL)bShowProcess
{
    if(_bRequest)
    {        
        NSMutableDictionary* sendvalue = NewObject(NSMutableDictionary);
        if(_curindex <= 0)
            _curindex = 1;
        [sendvalue setTztObject:[NSString stringWithFormat:@"%d",_curindex] forKey:@"StartPos"];
        [sendvalue setTztObject:[NSString stringWithFormat:@"%d",_cellCount] forKey:@"MaxCount"];
        [sendvalue setTztObject:@"9" forKey:@"AccountIndex"];
        [sendvalue setTztObject:@"0" forKey:@"Direction"];
        [sendvalue setTztObject:@"1" forKey:@"DeviceType"];
        [sendvalue setTztObject:@"1" forKey:@"Lead"];
        [sendvalue setTztObject:@"1" forKey:@"NewMarketNo"];
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

//获取文件路径
- (NSString *)getTrendPath
{
    return [NSString stringWithFormat:@"%@/%@/%@.data",NSHomeDirectory(),TZTReportPagePath,@"20401"];
}

//解析数据并刷新  parse:数据  bRead:是本地数据
- (NSUInteger)dealParse:(tztNewMSParse*)parse IsRead:(BOOL)bRead
{
    if([parse GetAction] == 20401)
    {
        NSMutableArray* ayTitle = NewObject(NSMutableArray);
        NSMutableArray* ayGridData = NewObject(NSMutableArray);
        
        NSData* DataGrid = [parse GetNSData:@"Grid"];
        if(DataGrid && [DataGrid length] > 0)
        {
            _countindex = [parse GetIntByName:@"MaxCount"];
            
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
                        NSUInteger nDataCount = [ayDataVal count]-1; //总数据数
                        if(bHaveIndex && StockNameIndex >= 0 && StockNameIndex < nDataCount)
                        {
                            TZTGridData* GridData = NewObject(TZTGridData);
                            GridData.text = [ayDataVal objectAtIndex:StockNameIndex];
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
                        tztReportPageCell* pageCell = (tztReportPageCell*)[self viewWithTag:_tagReportPage+i-1];
                        
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
                                NSString* strPath = [NSString stringWithFormat:@"%@/%@/%d.data",NSHomeDirectory(),TZTReportPagePath,_curindex];
                                [parse WriteParse:strPath];
                            }
                            );
            dispatch_release(FileWriteQueue);
        }

    }
    return 1;
}
//读取本地数据并刷新
- (void)readParse
{
    dispatch_queue_t FileWriteQueue = dispatch_queue_create("filewrite", NULL);
    dispatch_async (FileWriteQueue,^
                    {
                        NSString* strPath = [NSString stringWithFormat:@"%@/%@/%d.data",NSHomeDirectory(),TZTReportPagePath,_curindex];
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

#pragma tztSocketData Delegate
- (NSUInteger)OnCommNotify:(NSUInteger)wParam lParam_:(NSUInteger)lParam
{
    if( wParam == 0 )
        return 0;
    tztNewMSParse *parse = (tztNewMSParse*)wParam;
    if([parse IsIphoneKey:(long)self reqno:_ntztHqReq])
    {
        return [self dealParse:parse IsRead:FALSE];
    }
    return 0;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    _beginPoint = [touch locationInView:self];
}


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	UITouch *touch = [touches anyObject];
	NSUInteger numTaps = [touch tapCount];
	CGPoint ptEnd = [touch locationInView:self];
	float x = _beginPoint.x - ptEnd.x;
	if (numTaps >= 2) //双击
    {
        return;
    }
    else if (x > 10 || x < -10) 
	{
		if ([self checkData:x])
        {
			CATransition *animation = [CATransition animation];//初始化动画
			animation.duration = 0.5f;//间隔的时间
			animation.timingFunction = UIViewAnimationCurveEaseInOut;
			animation.type = kCATransitionPush;//设置上面4种动画效果
			animation.subtype = kCATransitionFromRight;//设置动画的方向，有四种，分别为kCATransitionFromRight、kCATransitionFromLeft、kCATransitionFromTop、kCATransitionFromBottom
			[self.layer addAnimation:animation forKey:@"animationID"];
		}
        else 
        {
			CATransition *animation = [CATransition animation];//初始化动画
			animation.duration = 0.5f;//间隔的时间
			animation.timingFunction = UIViewAnimationCurveEaseInOut;
			animation.type = kCATransitionPush;//设置上面4种动画效果
			animation.subtype = kCATransitionFromLeft;//设置动画的方向，有四种，分别为kCATransitionFromRight、kCATransitionFromLeft、kCATransitionFromTop、kCATransitionFromBottom
			[self.layer addAnimation:animation forKey:@"animationID"];
		}
        [self onRequestData:TRUE];
	}
    else
    {
        NSString* strCode = @"";
        NSString* strName = @"";
        UInt32    stockType = 0;
        for (int i = 0; i < _cellCount; i++)
        {
             tztReportPageCell* pageCell = (tztReportPageCell*)[self viewWithTag:_tagReportPage+i];
            if(pageCell && CGRectContainsPoint(pageCell.frame, ptEnd))
            {
                strCode = [pageCell getStockCode];
                strName = [pageCell getStockName];
                stockType = [pageCell getStockType];
                break;
            }
        }
        if (strCode && [strCode length] > 0 && _tztdelegate && [_tztdelegate respondsToSelector:@selector(tzthqView:setStockCode:)])
        {
            tztStockInfo *pStock = NewObjectAutoD(tztStockInfo);
            pStock.stockCode = [NSString stringWithFormat:@"%@", strCode];
            pStock.stockName = [NSString stringWithFormat:@"%@", strName];
            pStock.stockType = stockType;
            [_tztdelegate tzthqView:self setStockCode:pStock];
        }
	}
	
}

- (BOOL)checkData:(float)checkInt
{
    if(_cellCount <= 0)
        _cellCount = 2;
    
	if (checkInt > 0)
    {
		//向左滑动
		if (_curindex+_cellCount >= _countindex) 
        {
			_curindex = 1;
		}else 
        {
			_curindex += _cellCount;
		}
		return YES;
	}
    else
    {
		//向右滑动
		if (_curindex <= 1)
        {
			_curindex = _countindex - _cellCount + 1;
		}
        else 
        {
			_curindex -= _cellCount;
		}
		return NO;
	}
	
}


@end
