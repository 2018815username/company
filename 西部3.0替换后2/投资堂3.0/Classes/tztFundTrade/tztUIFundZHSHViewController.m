/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:        组合赎回vc
 * 文件标识:
 * 摘要说明:
 *
 * 当前版本:        2.0
 * 作    者:       yinjp
 * 更新日期:
 * 整理修改:
 *
 ***************************************************************/

#import "tztUIFundZHSHViewController.h"

@interface tztUIFundZHSHViewController ()

@end

@implementation tztUIFundZHSHViewController
@synthesize pZHSHView = _pZHSHView;
@synthesize pView  = _pView;
@synthesize ayFundCode = _ayFundCode;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self LoadLayoutView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)LoadLayoutView
{
    CGRect rcFrame = _tztBounds;
    //标题view
    NSString* strTitle = GetTitleByID(_nMsgType);
    if (!ISNSStringValid(strTitle))
        strTitle = @"组合赎回";
    self.nsTitle = [NSString stringWithFormat:@"%@", strTitle];
    [self onSetTztTitleView:@"组合赎回" type:TZTTitleReport];
    
    CGRect rcView = rcFrame;
    rcView.origin.y += _tztTitleView.frame.size.height;
    rcView.size.height = _tztTitleView.frame.size.height + 6;
    
    
    CGRect rcMain = rcFrame;
    rcMain.origin.y += _tztTitleView.frame.size.height + rcView.size.height;
    rcMain.size.height -= (_tztTitleView.frame.size.height + rcView.size.height + TZTToolBarHeight);
    
    if (_pZHSHView == NULL)
    {
        _pZHSHView = [[tztUIFundZHSHView alloc] init];
        _pZHSHView.nMsgType = _nMsgType;
        _pZHSHView.delegate = self;
        if (self.ayFundCode)
            _pZHSHView.ayFundCode = self.ayFundCode;
        _pZHSHView.frame = rcMain;
        [_tztBaseView addSubview:_pZHSHView];
        [_pZHSHView release];
    }
    else
    {
        _pZHSHView.frame = rcMain;
    }
    if (_pView == NULL)
    {
        _pView = [[tztUIVCBaseView alloc] initWithFrame:rcView];
        _pView.tztDelegate = self;
        [_pView setTableConfig:@"tztUITradeFundZHEX"];
        [_tztBaseView addSubview:_pView];
        [_pView release];
    }
    else
    {
        _pView.frame = rcView;
    }
    [self CreateToolBar];
    
    [_pZHSHView OnRequestData];
    if (g_pSystermConfig && g_pSystermConfig.bNSearchFuncJY)
        self.tztTitleView.fourthBtn.hidden = YES;
}

-(void)CreateToolBar
{   
    NSMutableArray  *pAy = NewObject(NSMutableArray);
    [pAy addObject:@"详细|6808"];
    [pAy addObject:@"刷新|6802"];
    [pAy addObject:@"赎回|6801"];
#ifdef tzt_NewVersion
    [tztUIBarButtonItem getTradeBottomItemByArray:pAy
                                           target:self
                                          withSEL:@selector(OnToolbarMenuClick:)
                                          forView:_tztBaseView];
#else
    [super CreateToolBar];
    [tztUIBarButtonItem GetToolBarItemByArray:pAy delegate_:self forToolbar_:toolBar];
#endif
    DelObject(pAy);
}

-(void)OnSetViewData:(tztNewMSParse *)pParse
{
    if (pParse == NULL)
        return;
    
    _nGroupCodeIndex = -1;
    _nGroupNameIndex = -1;
    _nGroupStockIndex = -1;
    _nGroupTypeIndex = -1;
    _nInitDateIndex = -1;
    _nLatestIndex = -1;
    _nProductIndex = -1;
    _nRiskWarningIndex = -1;
    _nUpdateDateIndex = -1;
    _nAmountIndex = -1;
    
    NSString* strIndex = [pParse GetByName:@"ProductIndex"];
    TZTStringToIndex(strIndex, _nProductIndex);
    
    strIndex = [pParse GetByName:@"GroupCodeIndex"];
    TZTStringToIndex(strIndex, _nGroupCodeIndex);
    
    strIndex = [pParse GetByName:@"GroupNameIndex"];
    TZTStringToIndex(strIndex, _nGroupNameIndex);
    
    strIndex = [pParse GetByName:@"GroupStockIndex"];
    TZTStringToIndex(strIndex, _nGroupStockIndex);
    
    strIndex = [pParse GetByName:@"LatestIndex"];
    TZTStringToIndex(strIndex, _nLatestIndex);
    
    strIndex = [pParse GetByName:@"GroupTypeIndex"];
    TZTStringToIndex(strIndex, _nGroupTypeIndex);
    
    strIndex = [pParse GetByName:@"InitDateIndex"];
    TZTStringToIndex(strIndex, _nInitDateIndex);
    
    strIndex = [pParse GetByName:@"UpdateDateIndex"];
    TZTStringToIndex(strIndex, _nUpdateDateIndex);
    
    strIndex = [pParse GetByName:@"RiskWarningIndex"];
    TZTStringToIndex(strIndex, _nRiskWarningIndex);
    
    strIndex = [pParse GetByName:@"AmountIndex"];
    TZTStringToIndex(strIndex, _nAmountIndex);
    
    NSArray* pGridAy = [pParse GetArrayByName:@"Grid"];
    
    if (_ayFundCode == NULL)
        _ayFundCode = NewObject(NSMutableArray);
    [_ayFundCode removeAllObjects];
    
    if (_nGroupNameIndex < 0)
        return;
    NSMutableArray* pAyTitle = NewObject(NSMutableArray);
    for (NSInteger i = 1; i < [pGridAy count]; i++)
    {
        NSArray *pAy = [pGridAy objectAtIndex:i];
        if (pAy == NULL)
            continue;
        NSInteger nCount = [pAy count];
        if (_nGroupNameIndex >= nCount)
            continue;
        
        NSString* strTitle = [pAy objectAtIndex:_nGroupNameIndex];
        if (strTitle == NULL)
            continue;
        
        [pAyTitle addObject:strTitle];
        [_ayFundCode addObject:pAy];
    }
    
    if (_nCurrentSelect < 0 || _nCurrentSelect >= [self.ayFundCode count])
        _nCurrentSelect = 0;
    if (_pView)
    {
        [_pView setComBoxData:pAyTitle ayContent_:pAyTitle AndIndex_:_nCurrentSelect withTag_:1000];
    }
    [self SetSelectData:_nCurrentSelect];
    DelObject(pAyTitle);
}

- (void)tztDroplistView:(tztUIDroplistView *)droplistview didSelectIndex:(int)index
{
    if ([droplistview.tzttagcode intValue] == 1000)
    {
        _nCurrentSelect = index;
        [self SetSelectData:index];
    }
}

-(NSMutableArray*)GetFundCode:(NSString*)strData
{
    NSMutableArray* ayReturn =  NewObjectAutoD(NSMutableArray);
    if (strData == NULL || [strData length] < 1)
        return ayReturn;
    
    NSArray* ayData = [strData componentsSeparatedByString:@","];
    for (int i = 0; i < [ayData count]; i++)
    {
        NSString* str = [ayData objectAtIndex:i];
        if (str == NULL || str.length < 1)
            continue;
        
        NSArray *pAy = [str componentsSeparatedByString:@"&"];
        if (pAy == NULL || [pAy count] < 3)
            continue;
        
        NSString* strCode = [pAy objectAtIndex:1];
        NSString* strQZ = [pAy objectAtIndex:2];
        
        NSMutableDictionary *pDict = NewObject(NSMutableDictionary);
        [pDict setTztObject:strCode forKey:@"tztCode"];
        [pDict setTztObject:strQZ forKey:@"tztQZ"];
        [ayReturn addObject:pDict];
        DelObject(pDict);
    }
    return ayReturn;
}

-(void)SetSelectData:(int)nIndex
{
    if (self.ayFundCode == NULL || [self.ayFundCode count] <= nIndex)
        return;
    
    if (_pView == NULL)
        return;
    _nCurrentSelect = nIndex;
    NSArray *pAy = [self.ayFundCode objectAtIndex:nIndex];
    
    if (_nGroupStockIndex < 0 || _nGroupStockIndex >= [pAy count])
        return;
    
    if (_nGroupCodeIndex < 0 || _nGroupCodeIndex >= [pAy count])
        return;
    
    NSString* strGroupCode = [pAy objectAtIndex:_nGroupCodeIndex];
    [_pZHSHView OnRequestFundListEx:strGroupCode];
}


-(void)OnRequestFundData
{
    NSArray *pAy = [self.ayFundCode objectAtIndex:_nCurrentSelect];
    
    if (_nGroupStockIndex < 0 || _nGroupStockIndex >= [pAy count])
        return;
    
    NSString* str = [pAy objectAtIndex:_nGroupStockIndex];
    NSMutableArray* pAyData = [self GetFundCode:str];
    
    if (pAyData)
        _pZHSHView.ayFundCode = pAyData;
    [_pZHSHView OnRequestFundList];
}

-(void)OnToolbarMenuClick:(id)sender
{
    BOOL bDeal = FALSE;
    UIButton* pBtn = (UIButton*)sender;
    switch (pBtn.tag)
    {
        case TZTToolbar_Fuction_Detail:
        {
            bDeal = TRUE;
            if (_pZHSHView)
            {
                [_pZHSHView OnDetail];
            }
        }
            break;
        case TZTToolbar_Fuction_OK:
        {
            bDeal = TRUE;
            if (_pZHSHView)
                [_pZHSHView OnZHSH];
//            //确定赎回
//            if (_nCurrentSelect  < 0 || _nCurrentSelect >= [self.ayFundCode count])
//                return;
//            NSArray *pAy = [self.ayFundCode objectAtIndex:_nCurrentSelect];
            
        }
            break;
        case TZTToolbar_Fuction_Refresh:
        {
            bDeal = TRUE;
            
            [self SetSelectData:_nCurrentSelect];
        }
            break;
            
        default:
            break;
    }
    if (!bDeal)
        [super OnToolbarMenuClick:sender];
}

@end
