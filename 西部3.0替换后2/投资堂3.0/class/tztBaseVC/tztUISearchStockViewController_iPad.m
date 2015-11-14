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

#import "tztUISearchStockViewController_iPad.h"
#import "tztUISearchStockView.h"
#import "TZTUIReportViewController.h"

#ifdef Support_HomePage
#import "tztUIHomePageViewController.h"
#endif

#ifndef Support_EXE_VERSION
#import "tztInterface.h"
#endif

#ifdef tzt_LocalStock
#import "tztInitStockCode.h"
#endif

@interface tztUISearchStockViewController_iPad (tztPrivate)
-(void)setKeyBordFrame;
-(UIButton*)CreateButtonWithTitle:(NSString*)nsTitle;
-(void)RequestStockCode:(NSString*)nsCode;
@end

@implementation tztUISearchStockViewController_iPad
@synthesize nKeyBordType;
@synthesize pAyKeyBord = _pAyKeyBord;
@synthesize pStockArray = _pStockArray;
@synthesize pContentView =  _pContentView;
@synthesize pSearchBar = _pSearchBar;
@synthesize nsInputValue = _nsInputValue;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(id)init
{
    if (self = [super init])
    {
        _nKeyBordType = -1;
        _pAyKeyBord = NewObject(NSMutableArray);
        _pStockArray = NewObject(NSMutableArray);
        self.nsInputValue = @"";
    }
    return self;
}

#pragma mark - View lifecycle
- (void)viewDidLoad
{
    self.contentSizeForViewInPopover = CGSizeMake(600, 300);
    [super viewDidLoad];
    self.contentSizeForViewInPopover = CGSizeMake(600, 300);
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return  NO;//(interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)dealloc
{
    DelObject(_pAyKeyBord);
    DelObject(_pStockArray);
    [super dealloc];
}

-(void)viewWillDisappear:(BOOL)animated
{
    if (_pSearchBar)
    {
        _pSearchBar.text = @"";
    }
    [[tztMoblieStockComm getSharehqInstance] removeObj:self];
    [super viewWillDisappear:animated];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[tztMoblieStockComm getSharehqInstance] addObj:self];
    [self LoadLayoutView];
}

-(void)LoadLayoutView
{
    if (_tztBaseView == nil)
        return;  // 防iOS6闪退byDBQ20130724
    CGRect rcFrame = _tztBounds;
    rcFrame.size = self.contentSizeForViewInPopover;
    _showRect = rcFrame;
    CGRect rcTable = rcFrame;
    rcTable.size.width = rcFrame.size.width / 2;
    _tztBaseView.backgroundColor = [UIColor lightGrayColor];
    if (_pContentView == NULL)
    {
        _pContentView = [[UITableView alloc] initWithFrame:rcTable style:UITableViewStylePlain];
        _pContentView.backgroundColor = [UIColor whiteColor];
        _pContentView.separatorColor = [UIColor lightGrayColor];
        _pContentView.dataSource = self;
        _pContentView.delegate =  self;
        [_tztBaseView addSubview:_pContentView];
        [_pContentView release];
    }
    else
    {
        self.pContentView.frame = rcTable;
    }
    [self setKeyBordFrame];
}

-(UIButton*)CreateButtonWithTitle:(NSString*)nsTitle
{
    UIButton* pBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [pBtn setTztTitle:nsTitle];
#ifdef __IPHONE_7_0
    [pBtn setTztBackgroundImage:[UIImage imageTztNamed:@"tztIPad_key.png"]];
#endif
    //添加此段的目地是因为显示不下了.."03\r\n上证指数"
    [pBtn.titleLabel setNumberOfLines:2];
    [pBtn.titleLabel setFont:tztUIBaseViewTextBoldFont(14.0f)];
    [pBtn.titleLabel setLineBreakMode:NSLineBreakByCharWrapping];
    [pBtn addTarget:self action:@selector(OnKeyBordButton:) forControlEvents:UIControlEventTouchUpInside];
    return pBtn;
}

//设置键盘类型
-(void)setNKeyBordType:(int)nType
{
    if (_nKeyBordType == nType)//
        return;
    
    if (_pAyKeyBord == NULL)
        _pAyKeyBord = NewObject(NSMutableArray);
    for (int i = 0; i < [_pAyKeyBord count]; i++)
    {
        UIButton *pBtn = [_pAyKeyBord objectAtIndex:i];
        if (pBtn && [pBtn isKindOfClass:[UIView class]])
        {
            [pBtn removeFromSuperview];
        }
    }
    [_pAyKeyBord removeAllObjects];
    
    _nKeyBordType = nType;
    switch (_nKeyBordType)
    {
        case TZTUserKeyBord_Number://数字键盘
        {
            [_pAyKeyBord addObject:[self CreateButtonWithTitle:@"     03\r\n上证指数"]];
            [_pAyKeyBord addObject:[self CreateButtonWithTitle:@"1"]];
            [_pAyKeyBord addObject:[self CreateButtonWithTitle:@"2"]];
            [_pAyKeyBord addObject:[self CreateButtonWithTitle:@"3"]];
            [_pAyKeyBord addObject:[self CreateButtonWithTitle:@"     04\r\n深证指数"]];
            [_pAyKeyBord addObject:[self CreateButtonWithTitle:@"4"]];
            [_pAyKeyBord addObject:[self CreateButtonWithTitle:@"5"]];
            [_pAyKeyBord addObject:[self CreateButtonWithTitle:@"6"]];
            [_pAyKeyBord addObject:[self CreateButtonWithTitle:@"600"]];
            [_pAyKeyBord addObject:[self CreateButtonWithTitle:@"7"]];
            [_pAyKeyBord addObject:[self CreateButtonWithTitle:@"8"]];
            [_pAyKeyBord addObject:[self CreateButtonWithTitle:@"9"]];
            [_pAyKeyBord addObject:[self CreateButtonWithTitle:@"000"]];
            [_pAyKeyBord addObject:[self CreateButtonWithTitle:@"0"]];
            [_pAyKeyBord addObject:[self CreateButtonWithTitle:@"."]];
            [_pAyKeyBord addObject:[self CreateButtonWithTitle:@"删除"]];
            [_pAyKeyBord addObject:[self CreateButtonWithTitle:@"300"]];
            [_pAyKeyBord addObject:[self CreateButtonWithTitle:@"隐藏"]];
            [_pAyKeyBord addObject:[self CreateButtonWithTitle:@"ABC"]];
            [_pAyKeyBord addObject:[self CreateButtonWithTitle:@"确定"]];
        }
            break;
        case TZTUserKeyBord_Character://字母键盘
        {
            [_pAyKeyBord addObject:[self CreateButtonWithTitle:@"A"]];
            [_pAyKeyBord addObject:[self CreateButtonWithTitle:@"B"]];
            [_pAyKeyBord addObject:[self CreateButtonWithTitle:@"C"]];
            [_pAyKeyBord addObject:[self CreateButtonWithTitle:@"D"]];
            [_pAyKeyBord addObject:[self CreateButtonWithTitle:@"E"]];
            [_pAyKeyBord addObject:[self CreateButtonWithTitle:@"F"]];
            [_pAyKeyBord addObject:[self CreateButtonWithTitle:@"G"]];
            [_pAyKeyBord addObject:[self CreateButtonWithTitle:@"H"]];
            [_pAyKeyBord addObject:[self CreateButtonWithTitle:@"I"]];
            [_pAyKeyBord addObject:[self CreateButtonWithTitle:@"J"]];
            [_pAyKeyBord addObject:[self CreateButtonWithTitle:@"K"]];
            [_pAyKeyBord addObject:[self CreateButtonWithTitle:@"L"]];
            [_pAyKeyBord addObject:[self CreateButtonWithTitle:@"M"]];
            [_pAyKeyBord addObject:[self CreateButtonWithTitle:@"N"]];
            [_pAyKeyBord addObject:[self CreateButtonWithTitle:@"O"]];
            [_pAyKeyBord addObject:[self CreateButtonWithTitle:@"P"]];
            [_pAyKeyBord addObject:[self CreateButtonWithTitle:@"Q"]];
            [_pAyKeyBord addObject:[self CreateButtonWithTitle:@"R"]];
            [_pAyKeyBord addObject:[self CreateButtonWithTitle:@"S"]];
            [_pAyKeyBord addObject:[self CreateButtonWithTitle:@"T"]];
            [_pAyKeyBord addObject:[self CreateButtonWithTitle:@"U"]];
            [_pAyKeyBord addObject:[self CreateButtonWithTitle:@"V"]];
            [_pAyKeyBord addObject:[self CreateButtonWithTitle:@"W"]];
            [_pAyKeyBord addObject:[self CreateButtonWithTitle:@"X"]];
            [_pAyKeyBord addObject:[self CreateButtonWithTitle:@"删除"]];
            [_pAyKeyBord addObject:[self CreateButtonWithTitle:@"Y"]];
            [_pAyKeyBord addObject:[self CreateButtonWithTitle:@"Z"]];
            [_pAyKeyBord addObject:[self CreateButtonWithTitle:@"隐藏"]];
            [_pAyKeyBord addObject:[self CreateButtonWithTitle:@"123"]];
            [_pAyKeyBord addObject:[self CreateButtonWithTitle:@"确定"]];
            
        }
            break;
        default:
            break;
    }
    if (self.tztBaseView)
    {
        [self setKeyBordFrame];
    }
}

-(void)setKeyBordFrame
{
    //设置背景
    CGRect rcKeybord = _showRect;
    rcKeybord.size.width = _showRect.size.width / 2;
    rcKeybord.origin.x += _showRect.size.width / 2;
    
    int nRow = 5;
    int nCol = 4;
    int nButtonWidth = 60;
    int nButtonHeight = 50;
    
    if (_nKeyBordType == TZTUserKeyBord_Character)
    {
        nRow = 6;
        nCol = 5;
        nButtonWidth = 50;
        nButtonHeight = 40;
    }
    
    if (_pAyKeyBord == NULL)
        return;
    
    int nYSpace = (rcKeybord.size.height -  nRow * nButtonHeight) / (nRow + 1);
    int nTop ; // Avoid potential leak.  byDBQ20131031
    
    int nXSpace = (rcKeybord.size.width - nCol * nButtonWidth) / (nCol + 1);
    int nLeft; // Avoid potential leak.  byDBQ20131031
    
    int nCount = 0;
    for (int i = 0; i < nRow; i++)
    {
        for (int j = 0; j < nCol; j++)
        {
            nTop = rcKeybord.origin.y + (i) * nButtonHeight + (i+1) * nYSpace;
            nLeft = rcKeybord.origin.x + (j) * nButtonWidth + (j + 1) * nXSpace;
            if (nCount >= [_pAyKeyBord count])
                break;
            UIButton *pBtn = [_pAyKeyBord objectAtIndex:nCount];
            nCount++;
            pBtn.frame = CGRectMake(nLeft, nTop, nButtonWidth, nButtonHeight);
            [_tztBaseView addSubview:pBtn];
        }
    }
}

-(void)OnKeyBordButton:(id)sender
{
    UIButton *pBtn = (UIButton*)sender;
    NSString* str = [pBtn titleForState:UIControlStateNormal];
    str = [str uppercaseString];
    if ([str compare:@"ABC"] == NSOrderedSame)
    {
        [self setNKeyBordType:TZTUserKeyBord_Character];
        return;
    }
    else if([str compare:@"123"] == NSOrderedSame)
    {
        [self setNKeyBordType:TZTUserKeyBord_Number];
        return;
    }
    else if([str compare:@"删除"] == NSOrderedSame)
    {
        if ([self.nsInputValue length] < 1)
            return;
        
        self.nsInputValue = [self.nsInputValue substringToIndex:[self.nsInputValue length] - 1];
        
        [self RequestStockCode:self.nsInputValue];
        //删除前一个
    }
    else if([str compare:@"隐藏"] == NSOrderedSame)
    {
        self.nsInputValue = @"";
        //需要清空数据
        if (self.pSearchBar)
        {
            self.pSearchBar.text = @"";
        }
        TZTUIBaseViewController *pTop = (TZTUIBaseViewController *)g_navigationController.topViewController;
        [(TZTUIBaseViewController*)pTop PopViewControllerDismiss];
        return;
    }
    //确定查询
    else if([str compare:@"确定"] == NSOrderedSame)
    {
        [self RequestStockCode:self.nsInputValue];
    }
    //此处还要处理上证，深证指数
    else if([str compare:@"     03\r\n上证指数"] == NSOrderedSame)
    {
        tztStockInfo *pStock = NewObject(tztStockInfo);
        pStock.stockCode = @"1A0001";
        pStock.stockName = @"上证指数";
        //        pStock.stockType = 16;
        if (pStock == NULL || pStock.stockCode == NULL || [pStock.stockCode length] <= 0)
        {
            DelObject(pStock);
            return;
        }
        
        TZTUIBaseViewController *pTop = (TZTUIBaseViewController*)g_navigationController.topViewController;
        if ([pTop isKindOfClass:[TZTUIReportViewController class]])
        {
            [((TZTUIReportViewController*)pTop) OnSelectHQData:pStock];
        }
#ifdef Support_HomePage
        else if([pTop isKindOfClass:[tztUIHomePageViewController class]])
        {
            [((tztUIHomePageViewController*)pTop) SelectStock:pStock];
        }
#endif
        //zxl 20131031 接口调用个股查询选择后跳转
#ifndef Support_EXE_VERSION
        if (IS_TZTIPAD)
        {
            [[tztInterface getShareInterface] OnSelectHQStock:pStock];
        }
        DelObject(pStock);
        return;
#endif
        
        [(TZTUIBaseViewController*)pTop PopViewControllerDismiss];
        DelObject(pStock);
    }
    else if([str compare:@"     04\r\n深证指数"] == NSOrderedSame)
    {
        tztStockInfo *pStock = NewObject(tztStockInfo);
        pStock.stockCode = @"2A01";
        pStock.stockName = @"深圳成指";
        //        pStock.stockType = 32;
        if (pStock == NULL || pStock.stockCode == NULL || [pStock.stockCode length] <= 0)
        {
            DelObject(pStock);
            return;
        }
        
        TZTUIBaseViewController *pTop = (TZTUIBaseViewController*)g_navigationController.topViewController;
        if ([pTop isKindOfClass:[TZTUIReportViewController class]])
        {
            [((TZTUIReportViewController*)pTop) OnSelectHQData:pStock];
        }
#ifdef Support_HomePage
        else if([pTop isKindOfClass:[tztUIHomePageViewController class]])
        {
            [((tztUIHomePageViewController*)pTop) SelectStock:pStock];
        }
#endif
        
        //zxl 20131031 接口调用个股查询选择后跳转
#ifndef Support_EXE_VERSION
        if (IS_TZTIPAD)
        {
            [[tztInterface getShareInterface] OnSelectHQStock:pStock];
        }
        DelObject(pStock);
        return;
#endif
        
        [(TZTUIBaseViewController*)pTop PopViewControllerDismiss];
        DelObject(pStock);
    }
    else
    {
        self.nsInputValue = [NSString stringWithFormat:@"%@%@", self.nsInputValue, str];
        
        if ([self.nsInputValue caseInsensitiveCompare:@".zztzt"] == NSOrderedSame)//打开地址设置界面
        {
            [TZTUIBaseVCMsg OnMsg:Sys_Menu_AddDelServer wParam:0 lParam:0];
            return;
        }
        else if([self.nsInputValue caseInsensitiveCompare:@"tztui0"] == NSOrderedSame
                || [self.nsInputValue caseInsensitiveCompare:@"tztui1"] == NSOrderedSame
                || [self.nsInputValue caseInsensitiveCompare:@"tztui2"] == NSOrderedSame)
        {
            //获取ui
            NSString *strUI = [self.nsInputValue substringFromIndex:[@"tztui" length]];
            int nType = [strUI intValue];
#ifdef tztRunSchemesURL
            NSString* str = [NSString stringWithFormat:@"%@://ui=%d",tztRunSchemesURL, nType];
            [[TZTAppObj getShareInstance] tztHandleOpenURL:[NSURL URLWithString:str]];
#endif
         
            return;
        }
        //查询
        [self RequestStockCode:self.nsInputValue];
    }
}


#pragma 数据收发处理
-(void)RequestStockCode:(NSString*)nsCode
{
    //清空界面
    if (self.pSearchBar)
    {
        self.pSearchBar.text = nsCode;
    }
    
    if (nsCode == NULL || [nsCode length] < 1)
    {
        [_pStockArray removeAllObjects];
        [_pContentView reloadData];
        return;
    }
    
#ifdef tzt_LocalStock
    if (g_pInitStockCode)
    {
        NSMutableArray *pAy = [g_pInitStockCode SearchStockLocal:nsCode];
        if ([pAy count] > 0)
        {
            //
            self.pStockArray = pAy;
            [_pContentView reloadData];
            return;
        }
    }
#endif
    
    NSMutableDictionary* pDict = NewObject(NSMutableDictionary);
    
    NSString* strReqno = tztKeyReqno((long)self, _ntztReqno);
    [pDict setTztValue:strReqno forKey:@"Reqno"];
    [pDict setTztValue:nsCode forKey:@"StockCode"];
    [pDict setTztValue:@"1" forKey:@"Account"];
    [pDict setTztObject:@"0" forKey:@"NewMarketNo"];
    [[tztMoblieStockComm getSharehqInstance] onSendDataAction:@"32" withDictValue:pDict];
    DelObject(pDict);
}

-(NSUInteger)OnCommNotify:(NSUInteger)wParam lParam_:(NSUInteger)lParam
{
    tztNewMSParse *pParse = (tztNewMSParse*)wParam;
    if (pParse == NULL)
        return 0;
    
    if (![pParse IsIphoneKey:(long)self reqno:_ntztReqno])
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
            
            NSString* strDeviceType = [pParse GetByName:@"DeviceType"];
            NSArray* ayInfo = [strStockInfo componentsSeparatedByString:@"|"];
            NSArray* ayType;
            NSUInteger nCount = (NSUInteger)([ayInfo count] / 2);
            if(nCount == 1)
            {
                if (strStockType && strStockType.length > 0)
                    ayType = [strStockType componentsSeparatedByString:@"|"];
                else
                    ayType = [strStockType componentsSeparatedByString:@"|"];
            }
            else
            {
                if (strStockType && strStockType.length > 0)
                    ayType = [strStockType componentsSeparatedByString:@"|"];
                else
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
        [_pContentView reloadData];
    }
    
    return 1;
}

#pragma 表格

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger nCount = 0;
    if (_pStockArray && [_pStockArray count] > 0)
    {
        nCount = [_pStockArray count];
    }
    return nCount;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
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
    
    tztStockInfo *pStock = [_pStockArray objectAtIndex:indexPath.row];
    
    [cell SetContentText:pStock];
    [cell SetContentTextColor:[UIColor blackColor] sceondColor:[UIColor blackColor]];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    tztStockInfo *pStock = [_pStockArray objectAtIndex:indexPath.row];
    if (pStock == NULL || pStock.stockCode == NULL || [pStock.stockCode length] <= 0)
        return;
    
    TZTUIBaseViewController *pTop = [TZTAppObj getTopViewController];
    if ([pTop isKindOfClass:[TZTUIReportViewController class]])
    {
        [((TZTUIReportViewController*)pTop) OnSelectHQData:pStock];
    }
#ifdef Support_HomePage
    else if([pTop isKindOfClass:[tztUIHomePageViewController class]])
    {
        [((tztUIHomePageViewController*)pTop) SelectStock:pStock];
    }
#endif
    
    //zxl 20131031 接口调用个股查询选择后跳转
#ifndef Support_EXE_VERSION
    if (IS_TZTIPAD)
    {
        //zxl 20131105 修改了国联行情查询股票后无法去掉查询界面
        UIViewController * pVC = g_navigationController.topViewController;
        if (pVC && [pVC isKindOfClass:[TZTUIBaseViewController class]])
        {
            [(TZTUIBaseViewController*)pTop PopViewControllerDismiss];
        }else
        {
           [[tztInterface getShareInterface] OnSelectHQStock:pStock]; 
        }
    }
    return;
#endif
    [(TZTUIBaseViewController*)pTop PopViewControllerDismiss];
}

//自选股操作
-(void)OnBtnAddOrDelStock:(id)sender
{
    NSInteger nTag = ((UIButton*)sender).tag - tztTableCellBtnTag;// - tztTableCellUserStockTag;
    
    if (nTag < 0 || nTag >= [_pStockArray count])
        return;
    
    tztStockInfo *pStock = [_pStockArray objectAtIndex:nTag];
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

-(void)CreateToolBar
{

}
@end
