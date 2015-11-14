//
//  tztReportListView.m
//  tztMobileApp
//
//  Created by yangdl on 12-12-21.
//  Copyright (c) 2012年 投资堂. All rights reserved.
//

#import "tztReportListView.h"
@class TZTUIReportViewController;
@interface tztReportListView ()
{
    TZTUIReportGridView* _reportView;
    BOOL _direction;   //排序方向
    NSInteger _accountIndex; //排序字段
    NSInteger _startindex;   //起始序号
    NSInteger _maxcount;     //请求行数
    NSInteger _pagecount;    //总页数
    NSInteger _valuecount;   //显示行数
    NSInteger _reqAdd;       //翻页显示增加行数
    NSInteger _reqchange;    //请求变更行数
    NSString* _reqAction; //请求功能号
    BOOL _bFlag;       //IPAD 自动设置当前选中行
    NSMutableArray  *_ayStockType; //排名数据市场类别列表
    BOOL _bMoveFirst;
}
@property (nonatomic,retain) NSMutableArray         *ayStockType;
@property (nonatomic)  NSInteger           maxcount;
@end


@implementation tztReportListView
@synthesize reqAction = _reqAction;
@synthesize reportView = _reportView;
@synthesize startindex = _startindex;
@synthesize reqchange = _reqchange;
@synthesize maxcount = _maxcount;
@synthesize ayStockType = _ayStockType;
@synthesize accountIndex = _accountIndex;
@synthesize direction = _direction;
@synthesize fixRowCount = _fixRowCount;
@synthesize bFlag = _bFlag;
@synthesize nReportType = _nReportType;
@synthesize ayStockData = _ayStockData;
@synthesize nsDefautlOrderType = _nsDefautlOrderType;
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
    NilObject(self.reqAction);
    [super dealloc];
}

//初始化数据
- (void)initdata
{
    [super initdata];
    if(_reportView == nil)
    {
        _reportView = [[TZTUIReportGridView alloc] init];
        [self addSubview:_reportView];
        [_reportView release];
    }
    CGRect reportframe = self.bounds;
    _reportView.frame = reportframe;
    _maxcount = _reportView.rowCount; //必须在设置排名fram后获取
    if(_maxcount == 0)
        _maxcount = 20;
    
    _reqAdd = _reportView.reqAdd;
    _reportView.delegate = self;
    _direction = TRUE;
    _accountIndex = 0;
    _reqchange = 0;
    _pagecount = 0;
    _startindex = 1;
    _bFlag = TRUE;

    _valuecount = 0;
    _reportView.fixColCount = 1;
    _reportView.haveCode = YES;
    _reqAction = nil;
    [[tztMoblieStockComm getSharehqInstance] addObj:self];
}

-(void)OnMoveUpOrDown:(UISwipeGestureRecognizer*)recognsizer
{
    if (_tztdelegate && [_tztdelegate respondsToSelector:@selector(OnMoveUpOrDown:)])
    {
        [_tztdelegate OnMoveUpOrDown:recognsizer];
    }
}

-(void)setNReportType:(NSInteger)nReportType
{
    if (_nReportType != nReportType)
    {
        _nReportType = nReportType;
        _reportView.rowCount = 0;
        _reportView.nReportType = nReportType;
    }
}

-(void)setFixRowCount:(int)nCount
{
    _fixRowCount = nCount;
    _reportView.fixRowCount = _fixRowCount;
    _maxcount = _reportView.rowCount; //必须在设置排名fram后获取
    if(_maxcount == 0)
        _maxcount = 20;
    _reqAdd = _reportView.reqAdd;
    [_reportView setNeedsDisplay];
}

-(void)setNsBackColor:(NSString *)nsBackColor
{
    _nsBackColor = [nsBackColor retain];
    
    if (_reportView)
        [_reportView setBackBg:nsBackColor];
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    if(_reportView)
    {
        _reportView.frame = CGRectMake(self.bounds.origin.x, self.bounds.origin.y, self.bounds.size.width, self.bounds.size.height);
        _reportView.bGridLines = ([[g_pSystermConfig.pDict tztObjectForKey:tztSystermConfig_HQTableUseGrid] intValue] > 0 );
        _maxcount = _reportView.rowCount; //必须在设置排名fram后获取
        if(_maxcount == 0)
            _maxcount = 20;
        _reqAdd = _reportView.reqAdd;
        [_reportView setNeedsDisplay];
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    [self OnMoveUpOrDown:(UISwipeGestureRecognizer*)gestureRecognizer];
    return YES;
}
// Only override drawRect: if you perform custom drawing.
- (void)drawRect:(CGRect)rect
{
    if (IS_TZTIPAD)
    {
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetAlpha(context, 1);
        CGContextSaveGState(context);
        UIColor* HideGridColor = [UIColor tztThemeHQHideGridColor];
        UIColor* BackgroundColor = [UIColor tztThemeBackgroundColorHQ];
        CGContextSetStrokeColorWithColor(context, HideGridColor.CGColor);
        CGContextSetFillColorWithColor(context, BackgroundColor.CGColor);
        CGContextAddRect(context, rect);
        CGContextDrawPath(context, kCGPathFillStroke);
        
        CGContextStrokePath(context);
        CGContextSetLineWidth(context,2.0f);
        
        //绘制竖线
        CGContextMoveToPoint(context,  rect.size.width, 0);
        CGContextAddLineToPoint(context, rect.size.width, rect.size.height);
    }
    
}

//清空数据
- (void)onClearData
{
    [super onClearData];
    _reqchange = 0;
    _pagecount = 0;
    _startindex = 1;
    _bFlag = TRUE;
    
    _valuecount = 0;

    if(_reportView)
    {
        [_reportView ClearGridData];
        [_reportView setNeedsDisplay];
    }
}

- (void)setReqAction:(NSString*)strAction
{
    if(_reqAction)
    {
        [_reqAction release];
        _reqAction = nil;
    }
    if(strAction && [strAction length] > 0)
    {
        _reqAction = [strAction retain];
//        if([_reqAction intValue] == 20192)
//        {
//            _accountIndex = 7;
//        }
//        else if([_reqAction intValue] == 60 || [_reqAction intValue] == 89 
//                || [_reqAction intValue] == 20198)
//        {
//            _accountIndex = 9;
//        }
//        else
//            _accountIndex = 0;
    }
}

-(void)tztShowNewType
{
    [self setFrame:self.frame];//通过重新设置显示区域 重新计算各类请求参数
}
//请求数据
- (void)onRequestData:(BOOL)bShowProcess
{
    TZTNSLog(@"%@",@"onRequestData");
    if(_bRequest)
    {
        if (_reqAction == nil || [_reqAction length] <= 0)
        {
            return;
        }
        NSMutableDictionary* sendvalue = NewObject(NSMutableDictionary);
        
        if ([_reqAction intValue] == 60 )//最近浏览
        {
            if (self.pStockInfo && self.pStockInfo.stockCode )
            {
                if([self.pStockInfo.stockCode length] <= 0)
                {
                    DelObject(sendvalue);
                    [self onClearData];
                    return;
                }
                [sendvalue setTztValue:self.pStockInfo.stockCode forKey:@"Grid"];
                [sendvalue setTztValue:@"1" forKey:@"StockIndex"];
            }
        }
        else
        {
            if (self.pStockInfo && self.pStockInfo.stockCode)
                [sendvalue setTztObject:self.pStockInfo.stockCode forKey:@"StockCode"];
        }

        [sendvalue setTztObject:[NSString stringWithFormat:@"%d", self.pStockInfo.stockType] forKey:@"NewMarketNo"];
        [sendvalue setTztObject:[NSString stringWithFormat:@"%ld",(long)_startindex] forKey:@"StartPos"];
//        if (_nReportType == tztReportUserStock)
//        {
//            int nCount = [[tztUserStock GetUserStockArray] count];
//            [sendvalue setTztObject:[NSString stringWithFormat:@"%d",MAX(nCount,_maxcount)] forKey:@"MaxCount"];
//            _maxcount = MAX(nCount, _maxcount);
//        }
//        else
            [sendvalue setTztObject:[NSString stringWithFormat:@"%ld",(long)_maxcount] forKey:@"MaxCount"];
        [sendvalue setTztObject:[NSString stringWithFormat:@"%ld",(long)_accountIndex] forKey:@"AccountIndex"];
        [sendvalue setTztObject:(_direction ? @"1":@"0") forKey:@"Direction"];
        [sendvalue setTztObject:_nsBackColor forKey:@"DeviceType"];
        
        //此处特殊处理了换手率，应该是不对的
        if (_nsDefautlOrderType.length > 0 && !_bMoveFirst && [_nsDefautlOrderType intValue] == 6)
        {
            if ([_nsDefautlOrderType intValue] == _accountIndex)
                [sendvalue setTztObject:@"0" forKey:@"Lead"];
            else
                [sendvalue setTztObject:@"1" forKey:@"Lead"];
        }
        else
            [sendvalue setTztObject:@"1" forKey:@"Lead"];
        _ntztHqReq++;
        if(_ntztHqReq >= UINT16_MAX)
            _ntztHqReq = 1;
        NSString* strReqno = tztKeyReqno((long)self, _ntztHqReq);
        [sendvalue setTztObject:strReqno forKey:@"Reqno"];
        [[tztMoblieStockComm getSharehqInstance] onSendDataAction:_reqAction withDictValue:sendvalue];
        DelObject(sendvalue);
    }
    [super onRequestData:bShowProcess];
    
}

#pragma tztSocketData Delegate
- (NSUInteger)OnCommNotify:(NSUInteger)wParam lParam_:(NSUInteger)lParam
{
    if( wParam == 0 )
        return 0;
    if(_reqAction == nil || [_reqAction length] <= 0)
        return 0;
    tztNewMSParse *parse = (tztNewMSParse*)wParam;
    if([parse GetAction] == [_reqAction intValue] && [parse IsIphoneKey:(long)self reqno:_ntztHqReq])
    {
        if ([parse GetErrorNo] < 0 && [parse GetErrorMessage].length > 0)
        {
            _reqAction = @"";
            if(_reportView)
            {
                NSMutableArray* ayGridData = NewObject(NSMutableArray);
                NSMutableArray* ayTitle = NewObject(NSMutableArray);
                [_reportView CreatePageData:ayGridData title:ayTitle type:_reqchange];
                _reqchange = 0;
                [ayGridData release];
                [ayTitle release];
            }
#ifdef tzt_ZFXF_LOGIN
            [self onSetViewRequest:NO];//发生错误，取消定时刷新
            [self showMessageBox:[parse GetErrorMessage] nType_:TZTBoxTypeButtonOK nTag_:0x1234 delegate_:self];
#else
            if (ISNSStringValid([parse GetErrorMessage]))
                tztAfxMessageBox([parse GetErrorMessage]);
            else
                [self showMessageBox:@"查无相应的排名数据!" nType_:TZTBoxTypeButtonOK nTag_:0x1234 delegate_:self];
#endif
            return 0;
        }
        NSArray* ayGridVol = [parse GetArrayByName:@"Grid"];
        if(ayGridVol == nil || [ayGridVol count] <= 0)
        {
            _reqAction = @"";
            if(_reportView)
            {
                NSMutableArray* ayGridData = NewObject(NSMutableArray);
                NSMutableArray* ayTitle = NewObject(NSMutableArray);
                [_reportView CreatePageData:ayGridData title:ayTitle type:_reqchange];
                _reqchange = 0;
                [ayGridData release];
                [ayTitle release];
            }
            [self onSetViewRequest:NO];//发生错误，取消定时刷新
            [self showMessageBox:@"查无相应的排名数据!" nType_:TZTBoxTypeButtonOK nTag_:0x1234 delegate_:self];
            return 0;
        }
        
        //
        NSInteger nCodeIndex = -1;
        NSInteger nNameIndex = -1;
        
        NSString *strIndex = [parse GetByName:@"stocknameindex"];
        TZTStringToIndex(strIndex, nNameIndex);
        
        strIndex = [parse GetByName:@"stockcodeindex"];
        TZTStringToIndex(strIndex, nCodeIndex);
        
        if (_ayStockData == NULL)
            _ayStockData = NewObject(NSMutableArray);
        [_ayStockData removeAllObjects];
        NSMutableArray* ayTitle = NewObject(NSMutableArray);
        NSMutableArray* ayGridData = NewObject(NSMutableArray);
        NSData* DataBinData = [parse GetNSData:@"BinData"];
        if(DataBinData && [DataBinData length] > 0)
        {
            NSArray* ayValue = [ayGridVol objectAtIndex:0];
            NSString* strBase = [parse GetByName:@"BinData"];
            DataBinData = [NSData tztdataFromBase64String:strBase];
            char *pColor = (char*)[DataBinData bytes];
            if(pColor)
                pColor = pColor + 2;//时间 2个字节
            for (int i = 0; i < [ayValue count]; i++)
            {
                TZTGridDataTitle* obj = NewObject(TZTGridDataTitle);
                NSString* str = [ayValue objectAtIndex:i];
                obj.text = str;
                if(pColor)
                {
#ifdef Support_HTSC
                    obj.textColor = [UIColor colorWithRed:123.f/255.f green:123.f/255.f blue:123.f/255.f alpha:1.0];
#else

                    obj.textColor = [UIColor colorWithChar:*pColor];
#ifdef kSUPPORT_FIRST
                    obj.textColor = [UIColor whiteColor];
#endif
#endif
                }
                [obj setTagValue];
                if(obj.tag == _accountIndex)
                {
                    obj.order = (_direction ? 1 : 2);
                    obj.text = [NSString stringWithFormat:@"%@%@",str,(_direction ? @"↓" : @"↑")];
                }
                else if(obj.enabled)
                {
                    obj.text = [NSString stringWithFormat:@"%@",str]; 
                }
                [ayTitle addObject:obj];
                if(pColor)
                    pColor++;
                [obj release];
            }
            NSString* strGridType = [parse GetByName:@"NewMarketNo"];
            if (strGridType == NULL || strGridType.length < 1)
                strGridType = [parse GetByName:@"DeviceType"];
            NSArray* ayGridType = [strGridType componentsSeparatedByString:@"|"];
            if(_ayStockType == NULL)
                _ayStockType = NewObject(NSMutableArray);
            [_ayStockType removeAllObjects];
            for (int i = 0; i < [ayGridType count]; i++) 
            {
                NSString* strtype = [ayGridType objectAtIndex:i];
                if (strtype)
                    [_ayStockType addObject:strtype];
                else
                    [_ayStockType addObject:@"0"];
            }
            
            
            for (int i = 1; i < [ayGridVol count]; i++)
            {
                NSArray* ayData = [ayGridVol objectAtIndex:i];
                NSMutableArray* ayGridValue = NewObject(NSMutableArray);
                
                if (nNameIndex < 0)
                    nNameIndex = 0;
                if (nCodeIndex < 0)
                    nCodeIndex = [ayData count] -1;
                NSMutableDictionary* pStockDict = NewObject(NSMutableDictionary);
                for (int j = 0; j < [ayData count]; j++) //最后一个竖线
                {
                    TZTGridData* GridData = NewObject(TZTGridData);
                    if (j == nNameIndex)
                    {
                        NSString* nsName = [NSString stringWithFormat:@"%@", [ayData objectAtIndex:j]];
                        NSArray* pAy = [nsName componentsSeparatedByString:@"."];
                        if ([pAy count] > 1)
                        {
                            nsName = [NSString stringWithFormat:@"%@", [pAy objectAtIndex:1]];
                        }
                        else
                        {
                            nsName = [NSString stringWithFormat:@"%@", nsName];
                        }
                        [pStockDict setTztValue:nsName forKey:@"Name"];
                        GridData.text = nsName;
                    }
                    else if (j == nCodeIndex)
                    {
                        NSString* strCode = [NSString stringWithFormat:@"%@", [ayData objectAtIndex:j]];
                        [pStockDict setTztValue:strCode forKey:@"Code"];
                        GridData.text = [ayData objectAtIndex:j];
                    }
                    else
                        GridData.text = [ayData objectAtIndex:j];
                    
                    if(pColor)
                        GridData.textColor = [UIColor colorWithChar:*pColor];
                    [ayGridValue addObject:GridData];
                    [GridData release];
                    if(pColor)
                        pColor++;
                }
                
                if (((_nReportType == tztReportBlockIndex) || (_nReportType == tztReportFlowsBlockIndex)) && i == 1)
                {
                    if (_tztdelegate && [_tztdelegate respondsToSelector:@selector(tztBlockIndexInfo:updateInfo_:)])
                    {
                        NSMutableArray *pAyTemp = NewObject(NSMutableArray);
                        [pAyTemp addObject:ayTitle];
                        [pAyTemp addObject:ayGridValue];
                        [pAyTemp addObject:[_ayStockType objectAtIndex:i-1]];
                        NSString* strUps = [parse GetByName:@"Price"];
                        NSString* strDowns = [parse GetByName:@"Volume"];
                        NSString* strDraws = [parse GetByName:@"ContactID"];
                        if (ISNSStringValid(strUps))
                            [pAyTemp addObject:strUps];
                        if (ISNSStringValid(strDowns))
                            [pAyTemp addObject:strDowns];
                        if (ISNSStringValid(strDraws))
                            [pAyTemp addObject:strDraws];
                        [_tztdelegate tztBlockIndexInfo:nil updateInfo_:pAyTemp];
                        DelObject(pAyTemp);
                    }
                    [pStockDict release];
                }
                else
                {
                    if (i-1 < _ayStockType.count)
                    {
                        [pStockDict setTztObject:[NSString stringWithFormat:@"%d", [[_ayStockType objectAtIndex:i-1] intValue]] forKey:@"StockType"];
                    }
                    else
                    {
                        [pStockDict setTztObject:[NSString stringWithFormat:@"%d", 0] forKey:@"StockType"];
                    }
                    [self.ayStockData addObject:pStockDict];
                    [pStockDict release];
                    
                    [ayGridData addObject:ayGridValue];
                    [ayGridValue release];
                }
                
            }
        }
//        [ayStockData release];
        
        if (_tztdelegate && [_tztdelegate respondsToSelector:@selector(tztGetAllGridData:ayData_:bFirst_:)])
        {
            [_tztdelegate tztGetAllGridData:self ayData_:ayGridData bFirst_:_bFlag];
        }
        
        if(_reportView)
        {
            NSString* strMaxCount = [parse GetByName:@"MaxCount"];
            _valuecount = [strMaxCount intValue];
            
            _pagecount = _valuecount * 3 / _maxcount + ((_valuecount * 3) % _maxcount ? 1 : 0);
            _reportView.nValueCount = _valuecount;
            _reportView.nPageCount = _pagecount;

            NSInteger nCount = _maxcount / 3;
            if(nCount <= 0)
                nCount = 1;
            _reportView.nCurPage = _startindex / nCount + (_startindex % nCount ? 1 : 0);
            _reportView.indexStarPos = _startindex;
            _reportView.ayStockType = self.ayStockType;
            [_reportView CreatePageData:ayGridData title:ayTitle type:_reqchange];
            
            if (_bFlag && IS_TZTIPAD)
            {
                if (_tztdelegate && [_tztdelegate isKindOfClass:[TZTUIReportViewController class]]
                    && [_tztdelegate respondsToSelector:@selector(isEqualType:)])
                {
                    //zxl  20131015 修改了调用当前TZTUIReportViewController 界面类型错误
                    if ([_tztdelegate isEqualType:1])
                    {
                        //zxl 20131017 修改了选择第一行的方式
                        [_reportView setSelectRow:0];
                    }
                }
                _bFlag = FALSE;
            }
            _reqchange = 0;
        }
        [ayGridData release];
        [ayTitle release];
	}
    return 0;
}

//选中行
- (void)tztGridView:(TZTUIBaseGridView *)gridView didSelectRowAtIndex:(NSInteger)index clicknum:(NSInteger)num gridData:(NSArray*)gridData
{
    NSInteger n = [gridData count];
    if(n > 0 && num == 1)
    {
        TZTGridData* valuedata = [gridData objectAtIndex:n-1];
        NSString* strCode = valuedata.text;
        TZTGridData* namedata = [gridData objectAtIndex:0];
        NSString* strName = namedata.text;
        
        NSArray* pAy = [strName componentsSeparatedByString:@"."];
        if ([pAy count] > 1)
        {
            strName = [NSString stringWithFormat:@"%@", [pAy objectAtIndex:1]];
        }
        
        tztStockInfo *pStock = NewObjectAutoD(tztStockInfo);
        pStock.stockName = [NSString stringWithFormat:@"%@", strName];
        pStock.stockCode = [NSString stringWithFormat:@"%@", strCode];
        
        if (_ayStockType && index < [_ayStockType count])
        {
            if ((_nReportType == tztReportBlockIndex) || (_nReportType == tztReportFlowsBlockIndex))
            {
                if (index+1 < [_ayStockType count])
                {
                    NSString *strType = [_ayStockType objectAtIndex:index+1];
                    if (strType && [strType length] > 0)
                    {
                        pStock.stockType = [strType intValue];
                    }
                }
            }
            else
            {
                NSString* strType = [_ayStockType objectAtIndex:index];
                if (strType && [strType length] > 0)
                {
                    pStock.stockType = [strType intValue];
                }
            }
        }
        
        if (_tztdelegate && [_tztdelegate respondsToSelector:@selector(tzthqView:setStockCode:)])
        {
            [_tztdelegate tzthqView:self setStockCode:pStock];
        }
    }
}

//刷新页面
- (NSInteger)tztGridView:(TZTUIBaseGridView *)gridView pageRefreshAtPage:(NSInteger)page
{
    _bFlag = TRUE;
    [self onRequestData:TRUE];
    return _startindex;
}


-(void)tztGridView:(TZTUIBaseGridView *)gridView showEditUserStockButton:(int)show
{
    if (self.tztdelegate && [self.tztdelegate respondsToSelector:@selector(tztGridView:showEditUserStockButton:)])
    {
        [self.tztdelegate tztGridView:gridView showEditUserStockButton:show];
    }
}

//前翻页
- (NSInteger)tztGridView:(TZTUIBaseGridView *)gridView pageBackAtPage:(NSInteger)page
{
    if(_reqchange == 0) //不累加翻页 返回请求数据后置为0后 翻页有效 yangdl 2013.03.15
    {
        NSInteger reqIndex  = _startindex - _reqAdd;
        if(reqIndex <= 0)
            reqIndex = 1;
        _reqchange = reqIndex - _startindex;
        _startindex = reqIndex;
    }
    if(_reqchange  != 0)
    {
        _bFlag = TRUE;
        [self onRequestData:TRUE];
    }
    return _startindex;
}

//后翻页
- (NSInteger)tztGridView:(TZTUIBaseGridView *)gridView pageNextAtPage:(NSInteger)page
{
    if(_reqchange == 0) //不累加翻页 返回请求数据后置为0后 翻页有效 yangdl 2013.03.15
    {
        NSInteger reqIndex  = _startindex + _reqAdd;
        if(reqIndex > _valuecount - _maxcount)
            reqIndex = _valuecount - _maxcount+1;
        if(reqIndex <= 0)
            reqIndex = 1;
        _reqchange = reqIndex - _startindex;
        _startindex = reqIndex;
    }
    if(_reqchange  != 0)
    {
        _bFlag = TRUE;
        [self onRequestData:TRUE];
    }
    return _startindex;
}

//点击标题头 排序
- (void)tztGridView:(TZTUIBaseGridView *)gridView didClickTitle:(NSInteger)index gridDataTitle:(TZTGridDataTitle*)gridDataTitle
{
    if(_accountIndex == gridDataTitle.tag)
    {
        _direction = !_direction;
    }
    else
    {
        _accountIndex = gridDataTitle.tag;
        _direction = TRUE;
    }
//    [_reportView.centerview setContentOffset:CGPointMake(0, 0)];
    _bFlag = TRUE;
    _bMoveFirst = TRUE;
    [self onRequestData:TRUE];
}

-(NSArray*)tztGetPreStock
{
    if (_reportView == NULL)
        return NULL;
    NSMutableArray *pAy = NewObjectAutoD(NSMutableArray);
    NSArray *pSubAy = [_reportView tztGetPreStock];
    
    for (int i = 0; i < [pSubAy count]; i++)
    {
        if ((i == 0) || (i == [pSubAy count] - 1))
        {
            [pAy addObject:[pSubAy objectAtIndex:i]];   
        }
    }
    
    NSInteger nIndex = _reportView.curIndexRow;
    if (nIndex >=0 && nIndex < [_ayStockType count])
    {
        TZTGridData *pData = NewObject(TZTGridData);
        if((_nReportType == tztReportBlockIndex) || (_nReportType == tztReportFlowsBlockIndex))
        {
            if (nIndex+1 < [_ayStockType count])
            {
                NSString *strType = [_ayStockType objectAtIndex:nIndex+1];
                if (strType && [strType length] > 0)
                {
                    pData.text = [_ayStockType objectAtIndex:nIndex+1];
                }
            }
            else
                pData.text = [_ayStockType objectAtIndex:nIndex];
        }
        else
        {
            pData.text = [_ayStockType objectAtIndex:nIndex];
        }
        [pAy insertObject:pData atIndex:1];
        DelObject(pData);
    }
    
    //设置左侧股票选中状态  add by xyt 20130731 添加左边按钮响应事件
    if (_reportView && IS_TZTIPAD)
    {
        [_reportView setSelectRow:nIndex];
    }
    //
    return pAy;
}

-(NSArray*)tztGetCurStock
{
    if (_reportView == NULL)
        return NULL;
    
    NSMutableArray *pAy = NewObjectAutoD(NSMutableArray);
    NSArray *pSubAy = [_reportView tztGetCurStock];
    
    for (int i = 0; i < [pSubAy count]; i++)
    {
        if ((i == 0) || (i == [pSubAy count] - 1))
        {
            [pAy addObject:[pSubAy objectAtIndex:i]];   
        }
    }
    
    NSInteger nIndex = _reportView.curIndexRow;
    if (nIndex >=0 && nIndex < [_ayStockType count])
    {
        TZTGridData *pData = NewObject(TZTGridData);
        if ((_nReportType == tztReportBlockIndex) || (_nReportType == tztReportFlowsBlockIndex))
        {
            if (nIndex+1 < [_ayStockType count])
            {
                NSString *strType = [_ayStockType objectAtIndex:nIndex+1];
                if (strType && [strType length] > 0)
                {
                    pData.text = [_ayStockType objectAtIndex:nIndex+1];
                }
            }
            else
                pData.text = [_ayStockType objectAtIndex:nIndex];
        }
        else
        {
            pData.text = [_ayStockType objectAtIndex:nIndex];
        }
        [pAy insertObject:pData atIndex:1];
        DelObject(pData);
    }
//    //设置左侧股票选中状态  modify by xyt 20130731 注释此段代码,没有用到
//    if (_reportView && IS_TZTIPAD)
//    {
//        [_reportView setSelectRow:nIndex];
//    }
    
    return pAy;
}

-(NSArray*)tztGetNextStock
{
    if (_reportView == NULL)
        return NULL;
    NSMutableArray *pAy = NewObjectAutoD(NSMutableArray);
    NSArray *pSubAy = [_reportView tztGetNextStock];
    //
    for (int i = 0; i < [pSubAy count]; i++)
    {
        if ((i == 0) || (i == [pSubAy count] - 1))
        {
            [pAy addObject:[pSubAy objectAtIndex:i]];   
        }
    }
    //获取市场类型
    NSInteger nIndex = _reportView.curIndexRow;
    if (nIndex >=0 && nIndex < [_ayStockType count])
    {
        TZTGridData *pData = NewObject(TZTGridData);
        if ((_nReportType == tztReportBlockIndex) || (_nReportType == tztReportFlowsBlockIndex))
        {
            if (nIndex+1 < [_ayStockType count])
            {
                NSString *strType = [_ayStockType objectAtIndex:nIndex+1];
                if (strType && [strType length] > 0)
                {
                    pData.text = [_ayStockType objectAtIndex:nIndex+1];
                }
            }
            else
                pData.text = [_ayStockType objectAtIndex:nIndex];
        }
        else
        {
            pData.text = [_ayStockType objectAtIndex:nIndex];
        }
        [pAy insertObject:pData atIndex:1];
        DelObject(pData);
    }
    
    //设置左侧股票选中状态
    if (_reportView && IS_TZTIPAD)
    {
        [_reportView setSelectRow:nIndex];
    }
    return pAy;
}

-(NSArray*)tztGetCurrent
{
    if (_reportView == NULL)
        return NULL;
    
    NSMutableArray *pAy = NewObjectAutoD(NSMutableArray);
    NSArray *pSubAy = [_reportView tztGetCurrent];
    for (int i = 0; i < [pSubAy count]; i++)
    {
        if ((i == 0) || (i == [pSubAy count] - 1))
        {
            [pAy addObject:[pSubAy objectAtIndex:i]];   
        }
    }
    
    NSInteger nIndex = _reportView.curIndexRow;
    if (nIndex >=0 && nIndex < [_ayStockType count])
    {
        TZTGridData *pData = NewObject(TZTGridData);
        if ((_nReportType == tztReportBlockIndex) || (_nReportType == tztReportFlowsBlockIndex))
        {
            if (nIndex+1 < [_ayStockType count])
            {
                NSString *strType = [_ayStockType objectAtIndex:nIndex+1];
                if (strType && [strType length] > 0)
                {
                    pData.text = [_ayStockType objectAtIndex:nIndex+1];
                }
            }
            else
                pData.text = [_ayStockType objectAtIndex:nIndex];
        }
        else
        {
            pData.text = [_ayStockType objectAtIndex:nIndex];
        }
        [pAy insertObject:pData atIndex:1];
        DelObject(pData);
    }
    return pAy;
//    return [_reportView tztGetCurrent];
}

-(BOOL)OnToolbarMenuClick:(id)sender
{
    BOOL bDeal = FALSE;
    UIButton *pBtn = (UIButton*)sender;
    if (pBtn.tag == HQ_MENU_YUJING)//预警
    {
        NSArray *pAy = [self tztGetCurrent];
        NSUInteger nCount = [pAy count];
        if(pAy && nCount > 0)
        {
            TZTGridData* valuedata = [pAy objectAtIndex:nCount-1];
            NSString* strCode = valuedata.text;
            TZTGridData* namedata = [pAy objectAtIndex:0];
            NSString* strName = namedata.text;
            NSString* strType = @"";
            if (nCount > 1)
            {
                TZTGridData* typedata = [pAy objectAtIndex:1];
                strType = typedata.text;
            }
            
            tztStockInfo *pStock = NewObjectAutoD(tztStockInfo);
            pStock.stockCode = strCode;
            pStock.stockName = strName;
            pStock.stockType = [strType intValue];
                    
//            [TZTUIBaseVCMsg OnMsg:HQ_MENU_YUJING wParam:(NSUInteger)pStock lParam:0];
            bDeal = TRUE;
        }
    }
    return  bDeal;
}

-(void) setCurrentIndex:(NSInteger)nIndex
{
    if (_reportView)
        [_reportView setCurIndexRow:nIndex];
}

-(CGRect)getLeftTopViewFrame
{
    if (_reportView)
        return [_reportView getLeftTopViewFrame];
    return CGRectZero;
}

- (void)TZTUIMessageBox:(TZTUIMessageBox *)TZTUIMessageBox clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        switch (TZTUIMessageBox.tag)
        {
            case 0x1234:
            {
//                if (!IS_TZTIPAD)
//                    [g_navigationController popViewControllerAnimated:UseAnimated];
            }
                break;
            default:
                break;
        }
    }
}

@end
