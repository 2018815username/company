//
//  tztUISearchStockViewStyle3.m
//  tztMobileApp_ZSSC
//
//  Created by King on 15-3-14.
//  Copyright (c) 2015年 ZZTZT. All rights reserved.
//

#import "tztUISearchStockViewStyle3.h"

#define  tztTableCellMarketTag  0x1111
#define  tztTableCellCodeTag    0x2222
#define  tztTableCellBtnTag     0x3333
#define tztHisStockPlist   @"tztHisStockPlist"
@interface tztUISearchStockCellStyle3 : UITableViewCell

@property NSInteger nBtnTag;
@property BOOL      bHidenAddBtn;
@property NSInteger nRowIndex;
@property (nonatomic,assign)id tztTarget;
@property (nonatomic)SEL tztAction;

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier nTag_:(NSInteger)nTag target_:(id)target action_:(SEL)action bHideAddBtn_:(BOOL)bHide;
-(void)SetContentText:(tztStockInfo*)pStock;
-(void)SetContentTextColor:(UIColor*)nFirstCL sceondColor:(UIColor*)nSecondCL;

@end

@implementation tztUISearchStockCellStyle3
@synthesize nBtnTag = _nBtnTag;
@synthesize bHidenAddBtn = _bHidenAddBtn;
@synthesize nRowIndex = _nRowIndex;


-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier nTag_:(NSInteger)nTag target_:(id)target action_:(SEL)action bHideAddBtn_:(BOOL)bHide
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        UILabel *pTitle = [[UILabel alloc] init];
        pTitle.tag = tztTableCellCodeTag;
        pTitle.backgroundColor = [UIColor clearColor];
        pTitle.textAlignment = NSTextAlignmentLeft;
        pTitle.adjustsFontSizeToFitWidth = YES;
        pTitle.font = tztUIBaseViewTextFont(15.f);
        [self addSubview:pTitle];
        [pTitle release];
        
        UILabel *pName = [[UILabel alloc] init];
        pName.tag = tztTableCellCodeTag + 1;
        pName.backgroundColor = [UIColor clearColor];
        pName.textAlignment = UITextAlignmentLeft;
        pName.adjustsFontSizeToFitWidth = YES;
        pName.font = tztUIBaseViewTextFont(11.f);
        [self addSubview:pName];
        [pName release];
        
        _bHidenAddBtn = bHide;
        self.tztTarget = target;
        self.tztAction = action;
        if (!bHide)
        {
            UIImageView *pBtn = [[UIImageView alloc] init];
            [pBtn setTag:nTag+tztTableCellBtnTag];
            _nBtnTag = nTag+tztTableCellBtnTag;
            pBtn.userInteractionEnabled = YES;
            [pBtn setContentMode:UIViewContentModeCenter];
            [self addSubview:pBtn];
            [pBtn release];
        }
        
        self.backgroundColor = [UIColor tztThemeBackgroundColorHQ];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    self.backgroundColor = [UIColor tztThemeBackgroundColorHQ];
    
    UILabel *title = (UILabel*)[self viewWithTag:tztTableCellCodeTag];
    title.textColor = [UIColor tztThemeHQBalanceColor];
    UILabel *content = (UILabel*)[self viewWithTag:tztTableCellCodeTag + 1];
    content.textColor = [UIColor tztThemeHQFixTextColor];
}

-(void)SetContentText:(tztStockInfo*)pStock
{
    CGRect rcFrame = self.bounds;
    rcFrame.size.width = rcFrame.size.width / 3 * 2;
    
    CGRect rcMarket = rcFrame;
    rcMarket.size.height = 12;
    rcMarket.origin.x += 5;
    rcMarket.origin.y += (rcFrame.size.height - rcMarket.size.height) / 2;
    rcMarket.size.width = 20;
    UILabel *market = (UILabel*)[self viewWithTag:tztTableCellMarketTag];
    market.frame =  rcMarket;
    
    rcFrame.origin.x += 30;
    rcFrame.origin.y += 5;
    UILabel *title = (UILabel*)[self viewWithTag:tztTableCellCodeTag];
    rcFrame.size.width = 90;
    rcFrame.size.height = rcFrame.size.height - 10 - 15;
    title.frame = rcFrame;
    
    title.text = pStock.stockName;
    //    //名称
    CGRect rcName = rcFrame;
    rcName.origin.y += rcFrame.size.height;
    rcName.size.height = 15;
    UILabel *content = (UILabel*)[self viewWithTag:tztTableCellCodeTag + 1];
    content.frame = rcName;
    NSString *strData = @"";
    if (pStock.stockCode)
        strData = [NSString stringWithFormat:@"%@", pStock.stockCode];
    content.text = strData;
    
    if (_bHidenAddBtn)
        return;
    
    CGRect rcAdd = self.bounds;
    rcAdd.origin.x = self.bounds.size.width - 50 - 30;
    rcAdd.origin.y = (self.bounds.size.height - 30) / 2;
    rcAdd.size.width = 30*2;
    rcAdd.size.height = 30;
    UIImageView* imageView = (UIImageView*)[self viewWithTag:_nBtnTag];
    if (imageView == NULL)
    {
        imageView = [[UIImageView alloc] initWithFrame:rcAdd];
        imageView.tag = _nBtnTag;
    }
    imageView.frame = rcAdd;
    if ([tztUserStock IndexUserStock:pStock] >= 0)
    {
        imageView.image = [UIImage imageTztNamed:@"TZTNavDelStock.png"];
    }
    else
    {
        imageView.image = [UIImage imageTztNamed:@"TZTNavAddStock.png"];
    }
    return;
}

-(void)SetContentTextColor:(UIColor*)nFirstCL sceondColor:(UIColor*)nSecondCL
{
    UILabel *title = (UILabel*)[self viewWithTag:tztTableCellCodeTag];
    title.textColor = nFirstCL;
    
    UILabel *content = (UILabel*)[self viewWithTag:tztTableCellCodeTag + 1];
    content.textColor = nSecondCL;
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    UIView* pView = [self viewWithTag:_nBtnTag];
    CGPoint ptEnd = [touch locationInView:self];
    if (pView && CGRectContainsPoint(pView.frame, ptEnd))
    {
        if (self.tztTarget && self.tztAction &&
            [self.tztTarget respondsToSelector:self.tztAction])
        {
            UIButton *pBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            pBtn.tag = _nBtnTag;
            [self.tztTarget performSelector:self.tztAction
                                 withObject:pBtn
                                 afterDelay:0.001f];
        }
    }
    else
    {
        [super touchesEnded:touches withEvent:event];
    }
    
}

@end

@interface tztUISearchStockViewStyle3()<UITableViewDataSource, UITableViewDelegate>

@property(nonatomic,retain) UITableView     *pContentView;
@property(nonatomic,retain) NSMutableArray  *pStockArray;
@property(nonatomic,retain) NSMutableArray  *pStockInfoData;

@property(nonatomic,retain) UILabel          *pView;
@property BOOL bHidenSwitch;
@end

@implementation tztUISearchStockViewStyle3

-(id)init
{
    if (self = [super init])
    {
        [[tztMoblieStockComm getSharehqInstance] addObj:self];
        _bHidenSwitch = NO;
    }
    return self;
}

-(void)dealloc
{
    DelObject(_pStockArray);
    DelObject(_pStockInfoData);
    [[tztMoblieStockComm getSharehqInstance] removeObj:self];
    [super dealloc];
}

-(void)setFrame:(CGRect)frame
{
    if (CGRectIsEmpty(frame) || CGRectIsNull(frame))
        return;
    [super setFrame:frame];
    self.backgroundColor = [UIColor tztThemeBackgroundColorHQ];
    
    CGRect rcFrame = self.bounds;
    
    CGRect rcView = rcFrame;
    rcView.size.height = 20;
    if (_pView == nil)
    {
        _pView = [[UILabel alloc] initWithFrame:rcView];
        _pView.font = tztUIBaseViewTextFont(11);
        _pView.textAlignment = NSTextAlignmentLeft;
        _pView.textColor = [UIColor colorWithTztRGBStr:@"46,195,250"];
        _pView.backgroundColor = [UIColor colorWithTztRGBStr:@"238,250,254"];
        [self addSubview:_pView];
        [_pView release];
    }
    else
    {
        _pView.frame = rcView;
    }
    _pView.text = @"     搜索记录";
    
    rcFrame.origin.y += rcView.size.height;
    rcFrame.size.height -= rcView.size.height;
    if (_pContentView == nil)
    {
        _pContentView = [[UITableView alloc] initWithFrame:rcFrame style:UITableViewStylePlain];
        _pContentView.backgroundColor = self.backgroundColor;
        _pContentView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        
        _pContentView.dataSource = self;
        _pContentView.delegate = self;
        [self addSubview:_pContentView];
        [_pContentView release];
    }
    else
    {
        _pContentView.backgroundColor = self.backgroundColor;
        self.pContentView.frame = rcFrame;
    }
    
    [self OnGetHisStock];
    
//    if (_pStockInfoData.count <= 0)
//    {
//        _pContentView.frame = self.bounds;
//    }
}

/*历史搜索*/
-(void)OnGetHisStock
{
    if (_pStockInfoData == NULL)
        _pStockInfoData = NewObject(NSMutableArray);
    
    [_pStockInfoData removeAllObjects];
    
    NSMutableArray *ayStock = GetArrayByListName(tztHisStockPlist);
    for (int  i = 0; i < [ayStock count]; i++)
    {
        NSMutableDictionary *pDict = [ayStock objectAtIndex:i];
        NSString *strCode = [pDict tztObjectForKey:@"Code"];
        NSString *strName = [pDict tztObjectForKey:@"Name"];
        NSString *strType = [pDict tztObjectForKey:@"StockType"];
        
        tztStockInfo *pStock = NewObjectAutoD(tztStockInfo);
        pStock.stockCode = [NSString stringWithFormat:@"%@", strCode];
        pStock.stockName = [NSString stringWithFormat:@"%@", strName];
        pStock.stockType = [strType intValue];
        [_pStockInfoData addObject:pStock];
    }
    [self refreshUI:_pStockInfoData];
}

-(void)RequestStock:(NSString*)strCode
{
    if (strCode == NULL || [strCode length] <= 0 )
    {
        //显示热门搜索和历史搜索
        [self ShowOrHiddenSwitchBtn:0];
        [self OnGetHisStock];
        [self refreshUI:_pStockInfoData];
        return;
    }
#ifdef tzt_LocalStock
    if (g_pInitStockCode)
    {
        NSMutableArray *pAy = [g_pInitStockCode SearchStockLocal:strCode];
        if ([pAy count] > 0)
        {
            [self refreshUI:pAy];
            [self ShowOrHiddenSwitchBtn:1];
            return;
        }
    }
#endif
    
    NSMutableDictionary* pDict = NewObject(NSMutableDictionary);
    _ntztHqReq++;
    if (_ntztHqReq >= UINT16_MAX)
        _ntztHqReq = 1;
    
    NSString* strReqno = tztKeyReqno((long)self, _ntztHqReq);
    [pDict setTztValue:strReqno forKey:@"Reqno"];
    [pDict setTztValue:strCode forKey:@"StockCode"];
    [pDict setTztValue:@"1" forKey:@"Account"];
    [pDict setTztObject:@"0" forKey:@"NewMarketNo"];
    
    [[tztMoblieStockComm getSharehqInstance] onSendDataAction:@"32" withDictValue:pDict];
    DelObject(pDict);
    //                    });
}

-(void)refreshUI:(NSMutableArray*)pAy
{
    if (pAy)
    {
        self.pStockArray = pAy;
    }
    else
        [self.pStockArray removeAllObjects];
    [_pContentView reloadData];
}

-(NSUInteger)OnCommNotify:(NSUInteger)wParam lParam_:(NSUInteger)lParam
{
    tztNewMSParse *pParse = (tztNewMSParse*)wParam;
    if (pParse == NULL)
        return 0;
    if (![pParse IsIphoneKey:(long)self reqno:_ntztHqReq])
        return 0;
    if ([pParse IsAction:@"20191"])
    {
        if (_pStockInfoData == NULL)
            _pStockInfoData = NewObject(NSMutableArray);
        [_pStockInfoData removeAllObjects];
        
        NSInteger nNameIndex = 0;
        NSInteger nCodeIndex = 0;
        
        NSString* strIndex = [pParse GetByName:@"stockcodeindex"];
        TZTStringToIndex(strIndex, nCodeIndex);
        
        strIndex = [pParse GetByName:@"stocknameindex"];
        TZTStringToIndex(strIndex, nNameIndex);
        
        NSString* strGridType = [pParse GetByName:@"NewMarketNo"];
        if (strGridType == NULL || strGridType.length < 1)
            strGridType = [pParse GetByName:@"DeviceType"];
        NSArray *ayGridType = [strGridType componentsSeparatedByString:@"|"];
        
        NSArray* ayGridVol = [pParse GetArrayByName:@"Grid"];
        
        
        for (NSInteger i = 1; i < [ayGridVol count]; i++)
        {
            NSArray * ayData = [ayGridVol objectAtIndex:i];
            
            if (nNameIndex < 0)
                nNameIndex = 0;
            if (nCodeIndex < 0)
                nCodeIndex = [ayData count] - 1;
            
            NSString* strName = [ayData objectAtIndex:nNameIndex];
            NSArray *pAy = [strName componentsSeparatedByString:@"."];
            if (pAy && [pAy count] > 1)
                strName = [NSString stringWithFormat:@"%@", [pAy objectAtIndex:1]];
            NSString* strCode = [ayData objectAtIndex:nCodeIndex];
            NSString* strType = @"";
            if ((i-1) >= 0 && (i-1) < [ayGridType count])
                strType = [ayGridType objectAtIndex:i-1];
            
            tztStockInfo* pStockInfo = NewObjectAutoD(tztStockInfo);
            pStockInfo.stockCode = [NSString stringWithFormat:@"%@", strCode];
            pStockInfo.stockName = [NSString stringWithFormat:@"%@", strName];
            pStockInfo.stockType = [strType intValue];
            
            [_pStockInfoData addObject:pStockInfo];
        }
        [self refreshUI:_pStockInfoData];
    }
    if ([pParse IsAction:@"32"])
    {
        if (_pStockArray == NULL)
            _pStockArray = NewObject(NSMutableArray);
        
        [_pStockArray removeAllObjects];
        NSString* strStockInfo = [pParse GetByName:@"BinData"];
        if (strStockInfo && [strStockInfo length] > 0)
        {
            // 如果只有一个股票在stocktype里取市场类型，否则在DeviceType里取市场类型
            NSString *strStockType = [pParse GetByName:@"NewMarketNo"];
            if (strStockType == NULL || strStockType.length < 1)
                strStockType = [pParse GetByName:@"stockType"];
            NSString* strDeviceType = [pParse GetByName:@"NewMarketNo"];
            if (strDeviceType == NULL || strDeviceType.length < 1)
                strDeviceType = [pParse GetByName:@"DeviceType"];
            NSArray* ayInfo = [strStockInfo componentsSeparatedByString:@"|"];
            NSArray* ayType;
            NSInteger nCount = [ayInfo count] / 2;
            if(nCount == 1)
            {
                ayType = [strStockType componentsSeparatedByString:@"|"];
            }
            else
            {
                ayType = [strDeviceType componentsSeparatedByString:@"|"];
            }
            
            for (NSInteger i = 0; i < MIN(nCount,[ayType count]); i++)
            {
                tztStockInfo *pStock = NewObjectAutoD(tztStockInfo);
                pStock.stockCode = [[[NSString alloc] initWithString:[ayInfo objectAtIndex:(i*2+0)]] autorelease];
                NSString* strName = [[[NSString alloc] initWithString:[ayInfo objectAtIndex:(i*2+1)]] autorelease];
                if (strName.length <= 0)
                {
                    strName = [[[NSString alloc] initWithString:[ayInfo objectAtIndex:(i*2+0)]] autorelease];
                }
                
                pStock.stockName = strName;// [[[NSString alloc] initWithString:[ayInfo objectAtIndex:(i*2+1)]] autorelease];
                pStock.stockType = [[ayType objectAtIndex:i] intValue];
                
                [_pStockArray addObject:pStock];
            }
        }
        [self ShowOrHiddenSwitchBtn:1];
        [self refreshUI:_pStockArray];
    }
    return 1;
}

- (void)tztUIBaseView:(UIView *)tztUIBaseView textchange:(NSString *)text
{
    if(tztUIBaseView && [tztUIBaseView isKindOfClass:[tztUITextField class]])
    {
        tztUITextField *pTextField = (tztUITextField*)tztUIBaseView;
        NSString* nsString = pTextField.text;
        if (([nsString length] >= pTextField.maxlen))
        {
            [pTextField resignFirstResponder];
        }
        if ([text caseInsensitiveCompare:@".zztzt"] == NSOrderedSame)//打开地址设置界面
        {
            pTextField.text = @"";
            [TZTUIBaseVCMsg OnMsg:Sys_Menu_AddDelServer wParam:0 lParam:0];
            return;
        }
        else if([text caseInsensitiveCompare:@"..ajax"] == NSOrderedSame )
        {
            pTextField.text = @"";
            [TZTUIBaseVCMsg OnMsg:ID_MENU_AJAXTEST wParam:0 lParam:0];
            return;
        }
        else if ([text caseInsensitiveCompare:@".clear"] == NSOrderedSame)
        {
            NSMutableDictionary *pDict = NewObjectAutoD(NSMutableDictionary);
            [tztKeyChain save:tztLogMobile data:@""];
            [tztKeyChain save:@"com.tzt.userinfo" data:pDict];
            return;
        }
        [self RequestStock:text];
        return;
    }
}

-(void)ShowOrHiddenSwitchBtn:(BOOL)bHidden
{
    if (bHidden == _bHidenSwitch)
        return;
    CGRect rcFrame = _pView.frame;
    CGRect rcContent = _pContentView.frame;
    [UIView beginAnimations:@"hideSelectionView" context:nil];
    [UIView setAnimationDuration:0.2f];
    [UIView setAnimationDelegate:self];
    
    if (bHidden && !_bHidenSwitch)//显示
    {
        rcContent.origin.y -= rcFrame.size.height;
        rcContent.size.height += rcFrame.size.height;
    }
    else
    {
        rcContent.origin.y += rcFrame.size.height;
        rcContent.size.height -= rcFrame.size.height;
    }
    _pContentView.frame = rcContent;
    [UIView commitAnimations];
    _bHidenSwitch = bHidden;
}

#pragma tableDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger nCount = 0;
    if (self.pStockArray && [self.pStockArray count] >= 1)
    {
        nCount = [self.pStockArray count];
    }
    return nCount;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* CellIndentifier = @"StockCell";
    
    tztUISearchStockCellStyle3* cell = (tztUISearchStockCellStyle3*)[tableView dequeueReusableCellWithIdentifier:CellIndentifier];
    
    if (cell)//???????
        cell = nil;
    if (cell == nil)
    {
        cell = [[[tztUISearchStockCellStyle3 alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIndentifier nTag_:indexPath.row target_:self action_:@selector(OnBtnAddOrDelStock:) bHideAddBtn_:NO] autorelease];
    }
    cell.nBtnTag = indexPath.row + tztTableCellBtnTag;
    tztStockInfo *pStock = [self.pStockArray objectAtIndex:indexPath.row];
    
    [cell SetContentTextColor:[UIColor tztThemeTextColorLabel] sceondColor:[UIColor tztThemeTextColorLabel]];
    [cell SetContentText:pStock];
    if ((indexPath.row % 2) == 0)
    {
        cell.backgroundColor = [UIColor tztThemeHQReportCellColor];
        cell.contentView.backgroundColor = [UIColor tztThemeHQReportCellColor];
    }
    else
    {
        cell.backgroundColor = [UIColor tztThemeHQReportCellColorEx];
        cell.contentView.backgroundColor = [UIColor tztThemeHQReportCellColorEx];
    }
    
    return cell;
}

//选中
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    tztStockInfo *pStock = [self.pStockArray objectAtIndex:indexPath.row];
    if (pStock == NULL || pStock.stockCode == NULL || [pStock.stockCode length] <= 0)
        return;
    [pStock retain];
    //记录下历史搜索
    NSMutableArray *ayStock = GetArrayByListName(tztHisStockPlist);
    NSMutableDictionary *pStockDict = [pStock GetStockDict];
    
    NSInteger nIndex = [self IndexUserStock:pStock];
    
    NSInteger nCount = MIN([ayStock count], 10);
    if (ayStock == NULL)
    {
        ayStock = NewObjectAutoD(NSMutableArray);
        [ayStock addObject:pStockDict];
    }
    else
    {
        if (nCount < 10)
        {
            if (nIndex < 0)//不存在
                [ayStock insertObject:pStockDict atIndex:0];
            else
            {
                [ayStock removeObjectAtIndex:nIndex];
                [ayStock insertObject:pStockDict atIndex:0];
            }
        }
        else
        {
            if (nIndex > -1)
            {
                if (nIndex != [ayStock count] - 1)
                    [ayStock removeObjectAtIndex:nIndex];
                else
                    [ayStock removeLastObject];
            }
            [ayStock insertObject:pStockDict atIndex:0];
        }
    }
    SetArrayByListName(ayStock, tztHisStockPlist);
    /**/
    if (_tztdelegate && [_tztdelegate respondsToSelector:@selector(tzthqView:setStockCode:)])
    {
        [_tztdelegate tzthqView:self setStockCode:pStock];
    }
    else
    {
        [TZTUIBaseVCMsg OnMsg:HQ_MENU_Trend wParam:(NSUInteger)pStock lParam:0];
    }
    [pStock release];
}

-(int)IndexUserStock:(tztStockInfo*)pStock
{
    if(pStock == nil || ![pStock isVaildStock])
        return -1;
    NSArray *pStockAy = (NSArray*)GetArrayByListName(tztHisStockPlist);
    if (pStockAy == nil || [pStockAy count] <= 0)
        return -1;
    int iIndex = -1;
    for (int i = 0; i < [pStockAy count]; i++)
    {
        NSMutableDictionary* pSubDict = [pStockAy objectAtIndex:i];
        if (pSubDict == NULL || [pSubDict count] <= 0)
            continue;
        
        if ([tztUserStock getShareClass].bUseNewUserStock)
        {
            if (([pStock.stockCode compare:[pSubDict tztObjectForKey:@"Code"]] == NSOrderedSame)
                && (pStock.stockType == [[pSubDict tztObjectForKey:@"StockType"] intValue]
                    || [[pSubDict tztObjectForKey:@"StockType"] intValue] == 0) )
            {
                iIndex = i;
                break;
            }
        }
        else
        {
            if ([pStock.stockCode compare:[pSubDict tztObjectForKey:@"Code"]] == NSOrderedSame)
            {
                iIndex = i;
                break;
            }
        }
    }
    return iIndex;
}

//自选股操作
-(void)OnBtnAddOrDelStock:(id)sender
{
    NSInteger nTag = ((UIButton*)sender).tag - tztTableCellBtnTag;// - tztTableCellUserStockTag;
    
    if (nTag < 0 || nTag >= [self.pStockArray count])
        return;
    
    tztStockInfo *pStock = [self.pStockArray objectAtIndex:nTag];
    if(pStock == NULL || pStock.stockCode == NULL || [pStock.stockCode length] <= 0)
        return;
    
    if ([tztUserStock IndexUserStock:pStock] >= 0)
    {
        [tztUserStock DelUserStock:pStock];
    }
    else
    {
        [tztUserStock AddUserStock:pStock];
    }
    [_pContentView reloadData];
    
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (self.tztdelegate && [self.tztdelegate respondsToSelector:@selector(tztSearchStockBeginScroll)])
    {
        [self.tztdelegate tztSearchStockBeginScroll];
    }
}

@end
