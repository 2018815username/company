/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:        个股查询界面
 * 文件标识:        
 * 摘要说明:        
 * 
 * 当前版本:        2.0
 * 作    者:       yinjp
 * 更新日期:            
 * 整理修改:	
 *
 ***************************************************************/

#import "tztUISearchStockView.h"
#import "TZTUIBaseVCMsg.h"
#import "tztWebViewController.h"

#ifdef tzt_LocalStock
#import "tztInitStockCode.h"
#endif

@implementation tztUISearchStockTableCell
@synthesize nBtnTag = _nBtnTag;
@synthesize nRowIndex = _nRowIndex;

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier nTag_:(NSInteger)nTag target_:(id)target action_:(SEL)action
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        UILabel *pTitle = [[UILabel alloc] init];
        pTitle.tag = tztTableCellCodeTag;
        pTitle.backgroundColor = [UIColor clearColor];
        if (g_nThemeColor == 1 || g_nSkinType == 1 || g_nHQBackBlackColor == 0)
        {
            pTitle.textColor = [UIColor blackColor];
        }
        else
        {
            pTitle.textColor = [UIColor whiteColor];
        }
        pTitle.textAlignment = UITextAlignmentLeft;
        [self addSubview:pTitle];
        [pTitle release];
        
        UILabel *pContent = [[UILabel alloc] init];
        if (g_nThemeColor == 1 || g_nSkinType == 1 || g_nHQBackBlackColor == 0)
        {
            pContent.textColor = [UIColor blackColor];
        }
        else
        {
            pContent.textColor = [UIColor whiteColor];
        }
        pContent.tag = tztTableCellCodeTag + 1;
        pContent.backgroundColor = [UIColor clearColor];
        pContent.textAlignment = UITextAlignmentCenter;
        pContent.adjustsFontSizeToFitWidth = YES;
        [self addSubview:pContent];
        [pContent release];

        UIButton*  pBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [pBtn setTag:nTag+tztTableCellBtnTag];
        _nBtnTag = nTag+tztTableCellBtnTag;
        
        [pBtn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
        [pBtn setContentMode:UIViewContentModeCenter];
        [self addSubview:pBtn];
        
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

-(void)SetContentText:(tztStockInfo*)pStock
{
    CGRect rcFrame = self.bounds;
    rcFrame.size.width = rcFrame.size.width / 3;
    rcFrame.origin.x += 15;
    UILabel *title = (UILabel*)[self viewWithTag:tztTableCellCodeTag];
    title.frame = rcFrame;
    title.text = pStock.stockCode;
    
    //名称
    CGRect rcName = self.bounds;
    if (IS_TZTIPAD)
    {
        rcName.origin.x += rcFrame.size.width - 15;   
    }
    else
    {
        rcName.origin.x += rcFrame.size.width + 15;
    }
    rcName.size.width = (rcName.size.width - rcFrame.size.width - 30) / 4 * 3;
    UILabel *content = (UILabel*)[self viewWithTag:tztTableCellCodeTag + 1];
    content.frame = rcName;
    content.text = pStock.stockName;
    
    
    CGRect rcAdd = self.bounds;
    rcAdd.origin.x += rcFrame.size.width + 15 + rcName.size.width;
    rcAdd.origin.y = rcFrame.origin.y + (rcFrame.size.height - 30) / 2;
    rcAdd.size.width = 30;
    rcAdd.size.height = 30;
    UIButton *pBtn = (UIButton*)[self viewWithTag:_nBtnTag];
    if (pBtn == NULL)
    {
        pBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        pBtn.tag = _nBtnTag;
    }
    pBtn.frame = rcAdd;
    if ([tztUserStock IndexUserStock:pStock] >= 0)
    {
        [pBtn setBackgroundImage:[UIImage imageTztNamed:@"TZTNavDelStock.png"] forState:UIControlStateNormal];
        [pBtn setBackgroundImage:[UIImage imageTztNamed:@"TZTNavDelStock.png"] forState:UIControlStateHighlighted];
    }
    else
    {
        [pBtn setBackgroundImage:[UIImage imageTztNamed:@"TZTNavAddStock.png"] forState:UIControlStateNormal];
        [pBtn setBackgroundImage:[UIImage imageTztNamed:@"TZTNavAddStock.png"] forState:UIControlStateHighlighted];
    }
}

-(void)SetContentTextColor:(UIColor*)nFirstCL sceondColor:(UIColor*)nSecondCL
{
    UILabel *title = (UILabel*)[self viewWithTag:tztTableCellCodeTag];
    title.textColor = nFirstCL;
    
    UILabel *content = (UILabel*)[self viewWithTag:tztTableCellCodeTag + 1];
    content.textColor = nSecondCL;
}
@end

@implementation tztUISearchStockView
@synthesize searchView = _searchView;
@synthesize pContentView = _pContentView;
@synthesize pStockArray = _pStockArray;
@synthesize pLabel      = _pLabel;
@synthesize nsURL = _nsURL;
@synthesize bShowSearchView = _bShowSearchView;
@synthesize clBackColor = _clBackColor;

-(id)init
{
    if (self = [super init])
    {
        [[tztMoblieStockComm getSharehqInstance] addObj:self];
    }
    return self;
}

-(void)dealloc
{
    DelObject(_pStockArray);
    [[tztMoblieStockComm getSharehqInstance] removeObj:self];
    [super dealloc];
}


-(void)setFrame:(CGRect)frame
{
    if (CGRectIsEmpty(frame) || CGRectIsNull(frame))
        return;
    [super setFrame:frame];
    
    if (self.clBackColor)
    {
        self.backgroundColor = self.clBackColor;
    }
    else
    {
        self.backgroundColor = [UIColor tztThemeBackgroundColorHQ];
    }
    CGRect rcFrame = self.bounds;
    if (_bShowSearchView)
    {
        rcFrame.size.height = 50;
        
        if (_searchView == nil)
        {
            _searchView = [[tztUIVCBaseView alloc] initWithFrame:rcFrame];
            _searchView.tztDelegate = self;
            [_searchView setTableConfig:@"tztUIStockSearch"];
            [self addSubview:_searchView];
            [_searchView release];
            
            [_searchView setEditorBecomeFirstResponder:2000];
        }
        else
        {
            _searchView.frame = rcFrame;
        }
    }
    else
    {
        rcFrame.size.height = 0;
    }
    
    CGRect rcLabel = rcFrame;
    rcLabel.origin.x = 10;
    rcLabel.size.height = 25;
    rcLabel.origin.y += rcFrame.size.height + 10;
    rcLabel.size.width = rcFrame.size.width - 20;
    if (_pLabel == nil)
    {
        _pLabel = [[UILabel alloc] initWithFrame:rcLabel];
        [self addSubview:_pLabel];
        [_pLabel release];
        
        _pLabel.layer.cornerRadius = 6.f;
        _pLabel.text = @"    股票代码不存在";
        _pLabel.textColor = [UIColor orangeColor];
        _pLabel.font = tztUIBaseViewTextFont(15.f);
        _pLabel.hidden = YES;
    }
    else
    {
        _pLabel.frame = rcLabel;
    }
    _pLabel.backgroundColor = self.backgroundColor;// [UIColor colorWithTztRGBStr:@"26,26,26"];
    
    rcFrame.origin.y += rcFrame.size.height;
    rcFrame.size.height = self.bounds.size.height - rcFrame.origin.y;
    if (_pContentView == nil)
    {
        _pContentView = [[UITableView alloc] initWithFrame:rcFrame style:UITableViewStylePlain];
        _pContentView.backgroundColor = self.backgroundColor;
        
        if ([_pContentView respondsToSelector:@selector(setSeparatorInset:)])
        {
            [_pContentView setSeparatorInset:UIEdgeInsetsZero];
        }
        
        _pContentView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _pContentView.separatorColor = [UIColor darkGrayColor];
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
    
    [self bringSubviewToFront:_pLabel];
}

-(NSUInteger)OnRequestData:(NSUInteger)wParam lParam_:(NSUInteger)lParam
{
    return 0;
}

-(void)RequestStock:(NSString*)strCode
{
    if (strCode == NULL || [strCode length] <= 0 )
    {
        [self refreshUI:nil];
        return;
    }
#ifdef tzt_LocalStock
    if (g_pInitStockCode)
    {
        NSMutableArray *pAy = [g_pInitStockCode SearchStockLocal:strCode];
        if ([pAy count] > 0)
        {
            [self refreshUI:pAy];
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
        self.pStockArray = pAy;
    else
        [self.pStockArray removeAllObjects];
    [_pContentView reloadData];
    
    NSString* strCode = @"";
    if (_searchView)
        strCode = [_searchView GetEidtorText:2000];
    if (strCode.length > 0)
    {
        _pLabel.hidden = [self.pStockArray count] > 0 ? YES : NO;
        _pContentView.hidden = [self.pStockArray count] > 0 ? NO : YES;
    }
    else
    {
        _pLabel.hidden = YES;
        _pContentView.hidden = NO;
    }
}

-(NSUInteger)OnCommNotify:(NSUInteger)wParam lParam_:(NSUInteger)lParam
{
    tztNewMSParse *pParse = (tztNewMSParse*)wParam;
    if (pParse == NULL)
        return 0;
    if (![pParse IsIphoneKey:(long)self reqno:_ntztHqReq])
        return 0;
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
            
            for (int i = 0; i < MIN(nCount,[ayType count]); i++)
            {
                tztStockInfo *pStock = NewObjectAutoD(tztStockInfo);
                pStock.stockCode = [[[NSString alloc] initWithString:[ayInfo objectAtIndex:(i*2+0)]] autorelease];
                pStock.stockName = [[[NSString alloc] initWithString:[ayInfo objectAtIndex:(i*2+1)]] autorelease];
                pStock.stockType = [[ayType objectAtIndex:i] intValue];
                
                [_pStockArray addObject:pStock];
            }
        }
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
            //读取用户信息
            [TZTUserInfoDeal SaveAndLoadLogin:TRUE nFlag_:1];
            return;
        }
        else if([text caseInsensitiveCompare:@"tztui0"] == NSOrderedSame
                || [text caseInsensitiveCompare:@"tztui1"] == NSOrderedSame
                || [text caseInsensitiveCompare:@"tztui2"] == NSOrderedSame)
        {
            //获取ui
            NSString *strUI = [text substringFromIndex:[@"tztui" length]];
            int nType = [strUI intValue];
#ifdef tztRunSchemesURL
            NSString* str = [NSString stringWithFormat:@"%@://ui=%d",tztRunSchemesURL, nType];
            [[TZTAppObj getShareInstance] tztHandleOpenURL:[NSURL URLWithString:str]];
#endif
            
        }
        [self RequestStock:text];
        return;
    }
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
    return 40;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* CellIndentifier = @"StockCell";
    
    tztUISearchStockTableCell* cell = (tztUISearchStockTableCell*)[tableView dequeueReusableCellWithIdentifier:CellIndentifier];
    
    if (cell)//???????
        cell = nil;
    if (cell == nil)
    {
        cell = [[[tztUISearchStockTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIndentifier nTag_:indexPath.row target_:self action_:@selector(OnBtnAddOrDelStock:)] autorelease];
    }
    cell.nBtnTag = indexPath.row + tztTableCellBtnTag;
    
    tztStockInfo *pStock = [self.pStockArray objectAtIndex:indexPath.row];

    if (self.clBackColor)
    {
        [cell SetContentTextColor:[UIColor darkTextColor] sceondColor:[UIColor darkTextColor]];
    }
    cell.nRowIndex = indexPath.row;
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
    
    [cell SetContentText:pStock];
    return cell;
}

//选中
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    tztStockInfo *pStock = [self.pStockArray objectAtIndex:indexPath.row];
    if (pStock == NULL || pStock.stockCode == NULL || [pStock.stockCode length] <= 0)
        return;
    [pStock retain];
    if (_tztdelegate && [_tztdelegate respondsToSelector:@selector(tzthqView:setStockCode:)])
    {
        [_tztdelegate tzthqView:self setStockCode:pStock];
        [TZTUIBaseVCMsg IPadPopViewController:nil];
    }
    else
    {
        [TZTUIBaseVCMsg IPadPopViewController:nil];
        [TZTUIBaseVCMsg OnMsg:HQ_MENU_Trend wParam:(NSUInteger)pStock lParam:0];
    }
    [pStock release];
}

//自选股操作
-(void)OnBtnAddOrDelStock:(id)sender
{
    [_searchView keyboardDidHide];
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
@end
