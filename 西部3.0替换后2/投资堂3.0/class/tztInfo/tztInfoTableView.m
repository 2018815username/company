/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:        资讯列表显示类
 * 文件标识:        
 * 摘要说明:        
 * 
 * 当前版本:        2.0
 * 作    者:       yinjp
 * 更新日期:            
 * 整理修改:	
 *
 ***************************************************************/

#import "tztInfoTableView.h"
#import "tztInfoContentView.h"
#import "tztZXCenterViewController.h"
#import "tztStockF10ViewController.h"

@interface tztInfoTableView(TZTPrivate)
-(void)LoadPageInfo:(CGRect)rcFrame;
-(void)setStockCode:(tztStockInfo *)pStockInfo Request:(int)nRequest;
-(void)SetCellBackGroundColor:(UITableViewCell*)cell frontImage:(NSString*)frontName backImage:(NSString*)backImage;
-(void)DeleteSubMenu:(tztInfoItem*)item;
@end

//#define tztInfoString @"◼"
#define tztInfoString @"•"
#define tztInfoCellTag 0x1111

enum tztInfoTableCellTag
{
	ktztInfoCell_Icon = 0x110000,	//icon图片
	ktztInfoCell_Title,			//标题文字
	ktztInfoCell_Time,			//时间
};

@implementation tztInfoTableViewCell
@synthesize nsTime = _nsTime;
@synthesize nsTitle = _nsTitle;
@synthesize pTimeColor = _pTimeColor;
@synthesize pTitleColor = _pTitleColor;
@synthesize pTimeFont = _pTimeFont;
@synthesize pTitleFont = _pTitleFont;
@synthesize pBackColor = _pBackColor;
@synthesize nCellRow = _nCellRow;

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.indentationWidth = 20;
//        if (g_nSkinType == 0)
//        {
//            self.pTitleColor = [UIColor tztThemeTextColorLabel];// [UIColor whiteColor];
//        }
//        else
//        {
//            self.pTitleColor = [UIColor blackColor];
//            self.pTimeColor = [UIColor darkGrayColor];
//        }
        self.pTitleColor = [UIColor tztThemeTextColorLabel];
        self.pTimeColor = [UIColor darkGrayColor];
        self.pTimeFont = tztUIBaseViewTextFont(12.0f);
        self.pTitleFont = tztUIBaseViewTextFont(15.0f);
        _nCellRow = 0;
    }
    return self;
}


-(void)dealloc
{
    [super dealloc];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    if (!IS_TZTIPAD)
        self.backgroundColor = [UIColor tztThemeBackgroundColorZX];
    self.pTitleColor = [UIColor tztThemeTextColorLabel];
    self.pTimeColor = [UIColor darkGrayColor];
    UILabel *pIcon = (UILabel*)[self viewWithTag:ktztInfoCell_Icon];
    pIcon.backgroundColor = [UIColor clearColor];
    UILabel *pLabel = (UILabel*)[self viewWithTag:ktztInfoCell_Title];
    pLabel.backgroundColor = [UIColor clearColor];
    pLabel.textColor = self.pTitleColor;
    pLabel = (UILabel*)[self viewWithTag:ktztInfoCell_Time];
    pLabel.backgroundColor = [UIColor clearColor];
    pLabel.textColor = self.pTimeColor;
}

-(void)SetContent:(NSString *)strTitle strTime:(NSString *)strTime
{
    if (strTitle && [strTitle length] > 0)
    {
        if([strTitle hasPrefix:tztInfoString] || self.bNewStyle)
            self.nsTitle = strTitle;
        else
            self.nsTitle = [NSString stringWithFormat:@"%@ %@", tztInfoString, strTitle];
    }
    else 
        self.nsTitle = @"";
    
    if (strTime && [strTime length] > 0)
        self.nsTime = [NSString stringWithFormat:@"%@",strTime];
    else
        self.nsTime = @"";

    float nHeight = self.bounds.size.height;
    float width = self.bounds.size.width;
    //当前view的缩进距离
    float indentation = self.indentationWidth * self.indentationLevel;
    int nIconWidth = 20;
    UILabel *pIcon = (UILabel*)[self viewWithTag:ktztInfoCell_Icon];
    CGRect rc = CGRectMake(indentation, 0, nIconWidth, nHeight);
    if (_nCellRow > 1 || self.nsTime.length > 0)
    {
        rc = CGRectMake(indentation, 0, nIconWidth, nHeight/2);
    }
    if (pIcon == NULL)
    {
        pIcon = [[UILabel alloc] initWithFrame:rc];
        pIcon.tag = ktztInfoCell_Icon;
        pIcon.backgroundColor = [UIColor clearColor];
        pIcon.textAlignment = NSTextAlignmentCenter;
        pIcon.font = tztUIBaseViewTextBoldFont(20);
        pIcon.textColor = [UIColor colorWithTztRGBStr:@"64,64,64"];
        pIcon.adjustsFontSizeToFitWidth = YES;
        pIcon.baselineAdjustment = UIBaselineAdjustmentAlignBaselines;
        [self.contentView addSubview:pIcon];
        [pIcon release];
    }
    else
        pIcon.frame = rc;
    
    if (self.nsTitle.length > 0)
        pIcon.text = tztInfoString;
    else
        pIcon.text = @"";
    UILabel *pLabel = (UILabel*)[self viewWithTag:ktztInfoCell_Title];
    //创建label显示标题文字
    if (pLabel == NULL)
    {
        pLabel = [[UILabel alloc] initWithFrame:CGRectMake(indentation+nIconWidth, 0, width-indentation-nIconWidth, nHeight)];
        pLabel.tag = ktztInfoCell_Title;
        pLabel.backgroundColor = [UIColor clearColor];
        pLabel.textAlignment = NSTextAlignmentLeft;
        pLabel.font = _pTitleFont;
        pLabel.textColor = _pTitleColor;
        pLabel.adjustsFontSizeToFitWidth = YES;
        pLabel.baselineAdjustment = UIBaselineAdjustmentAlignBaselines;
        [self.contentView addSubview:pLabel];
        [pLabel release];
    }
    if(_nCellRow > 1)
    {
        pLabel.numberOfLines = _nCellRow;
        pLabel.frame = CGRectMake(indentation+nIconWidth, 0, width-indentation-nIconWidth, nHeight);
    }
    else
    {
        pLabel.numberOfLines = 0;
        pLabel.frame = CGRectMake(indentation+nIconWidth, 0, width-indentation-nIconWidth, nHeight);
    }
//    if(_nCellRow > 1)
//        pLabel.text = [self.nsTitle stringByAppendingString:@"\n "];
//    else
    pLabel.textColor = [UIColor tztThemeTextColorLabel];
    pLabel.text = self.nsTitle;
    if(_nCellRow > 1)
    {
        [pLabel alignTop];
        float orgx = width - indentation - 100;
        float orgy = nHeight - nHeight / _nCellRow;
        pLabel = (UILabel*)[self viewWithTag:ktztInfoCell_Time];
        if (pLabel == NULL)
        {
            pLabel = [[UILabel alloc] initWithFrame:CGRectMake(orgx, orgy, 100, nHeight / _nCellRow)];
            pLabel.tag = ktztInfoCell_Time;
            pLabel.backgroundColor = [UIColor clearColor];
            pLabel.textAlignment = NSTextAlignmentRight;
            pLabel.font = _pTimeFont;
            pLabel.textColor = _pTimeColor;
            pLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
            [self.contentView addSubview:pLabel];
            [pLabel release];
        }
        pLabel.frame = CGRectMake(orgx, orgy, 100, nHeight / _nCellRow);
        pLabel.text = self.nsTime;
    }
    [self setNeedsDisplay];
}

-(void)SetContentColor:(UIColor *)clTitle clTime_:(UIColor *)clTime
{
    if (clTitle)
    {
        UILabel *pLabel = (UILabel*)[self viewWithTag:ktztInfoCell_Title];
        if(pLabel)
        {
            pLabel.textColor = clTitle;
        }
        self.pTitleColor = clTitle;
    }
    if (clTime)
    {
        UILabel *pLabel = (UILabel*)[self viewWithTag:ktztInfoCell_Time];
        if(pLabel)
        {
            pLabel.textColor = clTime;
        }
        self.pTimeColor = clTime;
    }
}

-(void)SetContentFont:(UIFont *)pTitle pTime_:(UIFont *)pTime
{
    if (pTitle)
    {
        UILabel *pLabel = (UILabel*)[self viewWithTag:ktztInfoCell_Title];
        if(pLabel)
        {
            pLabel.font = pTitle;
        }
        self.pTitleFont = pTitle;
    }
    if (pTime)
    {
        UILabel *pLabel = (UILabel*)[self viewWithTag:ktztInfoCell_Time];
        if(pLabel)
        {
            pLabel.font = pTime;
        }
        self.pTimeFont = pTime;
    }
    
}

-(void)SetBackgroundColor:(UIColor *)backgroundColor
{
    self.pBackColor = backgroundColor;
    [self setBackgroundColor:_pBackColor];
}

-(void)drawRect:(CGRect)rect
{
    if (IS_TZTIPAD)
        return;
    self.pBackColor = [UIColor tztThemeBackgroundColorZX];
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetAlpha(context, 1);
    CGContextSetLineWidth(context, 3.0);
    
    CGContextSetStrokeColorWithColor(context, self.pBackColor.CGColor);
    CGContextSetFillColorWithColor(context, self.pBackColor.CGColor);
    
    CGContextFillRect(context, rect);
    
    CGContextSetStrokeColorWithColor(context, self.pBackColor.CGColor);
    CGContextSetFillColorWithColor(context, self.pBackColor.CGColor);
}

@end


@implementation tztInfoTableView
@synthesize tztinfodelegate = _tztinfodelegate;
@synthesize tableView = _tableView;
@synthesize ayInfoData = _ayInfoData;
@synthesize infoBase = _infoBase;
@synthesize hsString = _hsString;
@synthesize nMinShowRow = _nMinShowRow;
@synthesize nsBackImage = _nsBackImage;
@synthesize nTableRowHeight = _nTableRowHeight;
@synthesize nCellRow = _nCellRow;
@synthesize nMaxCount = _nMaxCount;
@synthesize pFont = _pFont;
@synthesize nsOp_Type = _nsOp_Type;
@synthesize nSelectRow = _nSelectRow;
@synthesize aySubMenuData = _aySubMenuData;
@synthesize pSelItem = _pSelItem;
@synthesize bRequestList = _bRequestList;
@synthesize bShowSelect = _bShowSelect;
@synthesize menuKind = _menuKind;
-(id)init
{
    if (self = [super init]) 
    {
        self.tztinfodelegate = nil;
        self.ayInfoData = NewObjectAutoD(NSMutableArray);
        _nMinShowRow = 11;
        _nSelectRow = -1;
        _nMaxCount = 10;
        _bShowSelect = TRUE;
        _nTableRowHeight = 44;
        _nCellRow = 2;//默认带时间
        if (IS_TZTIPAD)
        {
            _nsBackImage = @"TZTReportContentBG.png";
            self.pFont = tztUIBaseViewTextFont(15.0f);
        }
        else
        {
            _nsBackImage = nil;
            self.pFont = tztUIBaseViewTextFont(14.0f);
        }
        _nsOp_Type = @"0";
        _menuKind = @"0";
        _aySubMenuData = NewObject(NSMutableArray);
        _bIsSubMenu = NO;
        _bRequestList = TRUE;
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.tztinfodelegate = nil;
        self.ayInfoData = NewObjectAutoD(NSMutableArray);
        _nMinShowRow = 11;
        _nSelectRow = -1;   
        _nMaxCount = 10;
        _bShowSelect = TRUE;
        _nTableRowHeight = 44;
        _nCellRow = 0;
        if (IS_TZTIPAD)
        {
            _nsBackImage = @"TZTReportContentBG.png";
            self.pFont = tztUIBaseViewTextFont(15.0f);
        }
        else
        {
            _nsBackImage = nil;
            self.pFont = tztUIBaseViewTextFont(14.0f);
        }
//        
        _nsOp_Type = @"0";
        _menuKind = @"0";
        _aySubMenuData = NewObject(NSMutableArray);
        _bIsSubMenu = NO;
    }
    return self;
}

-(void)dealloc
{
    NilObject(self.tztinfodelegate);
    if (_infoBase)
    {
        [[tztMoblieStockComm getSharehqInstance] removeObj:_infoBase];
    }
    DelObject(_infoBase);
    if (_aySubMenuData) 
    {
        [_aySubMenuData removeAllObjects];
        DelObject(_aySubMenuData);
    }
    [super dealloc];
}

-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    CGRect tableframe = self.bounds;
    tableframe.origin = CGPointZero;
    [self LoadPageInfo:tableframe];
}

-(void)LoadPageInfo:(CGRect)rcFrame
{
    if (_tableView == nil)
    {
        _tableView = [[UITableView alloc] initWithFrame:rcFrame style:UITableViewStylePlain];
        if (g_nHQBackBlackColor)
        {
            _tableView.backgroundColor = [UIColor blackColor];
        }
        else
        {
            _tableView.backgroundColor = [UIColor whiteColor];
        }
        if (g_nSkinType == 1)
            [_tableView setSeparatorColor:[UIColor colorWithTztRGBStr:@"200,200,200"]];
        else
            [_tableView setSeparatorColor:[UIColor colorWithRGBULong:0x2f2f2f]];
        if (!IS_TZTIPAD)
            _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        else
            _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
            [_tableView setSeparatorInset:UIEdgeInsetsZero];
        }
        _tableView.bounces = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [self addSubview:_tableView];
        [_tableView release];
    }
    else
    {
        _tableView.frame = rcFrame;
    }
    if(_nTableRowHeight <= 0.f)
        _nTableRowHeight = 44.f;
}

-(void)setStockInfo:(tztStockInfo*)pStockInfo Request:(int)nRequest
{
    self.pStockInfo = pStockInfo;
    if (nRequest)
    {
        if (_infoBase == nil)
            _infoBase = NewObject(tztInfoBase);
        
        if (_infoBase.hSString && [_infoBase.hSString compare:_hsString] != NSOrderedSame)
        {
//            [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
            [_infoBase ClearData];
        }
        else
        {
            _infoBase.nStartPos = 1;
            _nMaxCount = MAX(_ayInfoData.count,_nMaxCount);
        }
        _infoBase.pDelegate = self;
        _infoBase.hSString = _hsString;
        _infoBase.nMaxCount = _nMaxCount;
        _infoBase.nsOp_Type = _nsOp_Type;
        _infoBase.bRequestList = _bRequestList;
        _infoBase.pStockInfo = pStockInfo;
        _infoBase.menuKind = _menuKind;
        [_infoBase GetMenu:_hsString retStr_:nil];

#ifdef kSUPPORT_FIRST
            [_infoBase readParse:44151];
#else
            [_infoBase readParse:40130];
#endif

    }
}

//-(void)setStockCode:(NSString*)nsStockCode AndName:(NSString*)nsStockName HsString_:(NSString*)HsString
-(void)setStockInfo:(tztStockInfo *)pStockInfo HsString_:(NSString *)HsString
{
    self.pStockInfo = pStockInfo;
    if (HsString && [HsString length] > 0)
        self.HsString = [NSString stringWithFormat:@"%@", HsString];
 
    if (self.tableView && [self.ayInfoData count] > 0)
    {
        [self.tableView reloadData];
    }
}

-(tztStockInfo*)GetCurrentStock
{
    if (_infoBase)
        return [_infoBase GetCurrentStock];
    return NULL;
}

-(void)SetInfoData:(NSMutableArray*)ayData
{
    [self.ayInfoData removeAllObjects];
    if (ayData && [ayData count] > 0)
    {
        [self.ayInfoData setArray:ayData];
    }
    
    if ([self.ayInfoData count] > 0)
    {
        tztInfoItem* pItem = [self.ayInfoData objectAtIndex:0];
        if (pItem.InfoTime && pItem.InfoTime.length > 0)
        {
            _nCellRow = 2;
        }
        else
        {
            _nCellRow = 0;
        }
    }
    
    [self.tableView reloadData];
    
    if (IS_TZTIPAD && _tztdelegate && ([_tztdelegate isKindOfClass:[tztZXCenterViewController class]] || [_tztdelegate isKindOfClass:[tztStockF10ViewController class]]) && [_tztdelegate respondsToSelector:@selector(SetInfoItem:pItem_:)] && _infoBase.nStartPos <= 1)
    {
        [self tableView:self.tableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
//        [_delegate SetInfoItem:self pItem_:[self.ayInfoData objectAtIndex:0]];
    }
}

-(void)InsertSubMenu:(NSMutableArray*)ayData leven_:(int)nLevel
{
    NSMutableArray *ayNewData = NewObject(NSMutableArray);
    for (int i = 0; i <= _nSelectRow; i++)
    {
        [ayNewData addObject:[_ayInfoData objectAtIndex:i]];
    }
    for (int i = 0; i < [ayData count]; i++)
    {
        tztInfoItem *pItem = [ayData objectAtIndex:i];
        pItem.nLevel = nLevel + 1;
        [ayNewData addObject:[ayData objectAtIndex:i]];
    }
    for (NSInteger i = _nSelectRow + 1; i < [_ayInfoData count] ; i++)
    {
        [ayNewData addObject:[_ayInfoData objectAtIndex:i]];
    }
    
//    [self SetInfoData:ayNewData];
    
    [self.ayInfoData removeAllObjects];
    if (ayNewData && [ayNewData count] > 0)
    {
        [self.ayInfoData setArray:ayNewData];
    }
    [self.tableView reloadData];
    
    if (IS_TZTIPAD && _tztdelegate && [_tztdelegate isKindOfClass:[tztZXCenterViewController class]] && [_tztdelegate respondsToSelector:@selector(SetInfoItem:pItem_:)])
    {
        [self tableView:self.tableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:_nSelectRow+1 inSection:0]];
    }
    DelObject(ayNewData);
}

-(void)SetInfoItem:(id)delegate pItem_:(tztInfoItem*)pItem
{
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
//缩进值
- (NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    if (self.ayInfoData && indexPath.row < [self.ayInfoData count])
    {
        tztInfoItem *pItem = [self.ayInfoData objectAtIndex:indexPath.row];
        if (pItem)
        {
            return pItem.nLevel;
        }
    }
    return 0;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag == 11)
    {
        return 5;
    }
    else
    {
        
        CGFloat fHeight = CGRectGetHeight(self.frame);
        NSInteger nRow = fHeight / _nTableRowHeight;
        
        NSInteger nMax = MAX(nRow, _nMinShowRow);
        return ([self.ayInfoData count] > nMax ? [self.ayInfoData count] : nMax) + 1;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if(_nTableRowHeight <= 0.f)
        _nTableRowHeight = 44.f;
    return _nTableRowHeight;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(cell && [cell isKindOfClass:[tztInfoTableViewCell class]])
    {
        tztInfoTableViewCell* infocell = (tztInfoTableViewCell*)cell;
        infocell.nCellRow = _nCellRow;
        [infocell SetContentFont:_pFont pTime_:nil];
        [infocell SetContent:infocell.nsTitle strTime:infocell.nsTime];
    }
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* CellIndentifier = @"InfoCell";
    tztInfoTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:CellIndentifier];
    if (cell == nil) 
    {
        cell = [[[tztInfoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIndentifier ] autorelease];
        cell.bNewStyle = YES;
        if (IS_TZTIPAD)
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        else
        {
            UIView *pView = [[[UIView alloc] initWithFrame:cell.frame] autorelease];
            pView.backgroundColor = [UIColor colorWithTztRGBStr:@"156,156,156"];
            [cell setSelectedBackgroundView:pView];
        }
        cell.nCellRow = _nCellRow;
        [cell SetContentFont:_pFont pTime_:nil];
        [cell SetContent:nil strTime:nil];
    }
    else
    {
    }
    if (indexPath.row >= ([self.ayInfoData count]) && self.ayInfoData.count > 0)
    {
        if ( [_infoBase HaveNextPage])
        {
            if (indexPath.row == [self.ayInfoData count])
            {
                if (cell.nCellRow > 1)
                    [cell SetContent:@"正在加载" strTime:@""];
                else
                    [cell SetContent:@"正在加载..." strTime:@""];
                //[UIColor colorWithPatternImage:[UIImage imageTztNamed:_nsBackImage]]
                [cell SetBackgroundColor:[UIColor tztThemeBackgroundColorZX]];
//                if (g_nSkinType == 0) {
//                    [cell SetBackgroundColor:[UIColor colorWithTztRGBStr:@"27,27,27"]];;
//                }
//                else
//                {
//                    [cell SetBackgroundColor:[UIColor colorWithTztRGBStr:@"247, 247, 247"]];
//                }
                [_infoBase NextPage];
            }
        }
        else
        {
            [cell SetContent:@"" strTime:@""];
            
            [cell SetBackgroundColor:[UIColor tztThemeBackgroundColorZX]];
//            if (g_nSkinType == 0) {
//                [cell SetBackgroundColor:[UIColor colorWithTztRGBStr:@"27,27,27"]];;
//            }
//            else
//            {
//                [cell SetBackgroundColor:[UIColor colorWithTztRGBStr:@"247, 247, 247"]];
//            }
        }
        return cell;
    }
    
    if (indexPath.row == _nSelectRow && _bShowSelect && IS_TZTIPAD)
    {
        //选中行
        [cell SetBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageTztNamed:@"TZTReportContentSelect.png"]]];
    }
    else
    {
        //[UIColor colorWithPatternImage:[UIImage imageTztNamed:_nsBackImage]]
        
        [cell SetBackgroundColor:[UIColor tztThemeBackgroundColorZX]];
        
//        if (g_nSkinType == 0) {
//            [cell SetBackgroundColor:[UIColor colorWithTztRGBStr:@"27,27,27"]];;
//        }
//        else
//        {
//            [cell SetBackgroundColor:[UIColor colorWithTztRGBStr:@"247, 247, 247"]];
//        }
    }
    
    if ([self.ayInfoData count] > 0 && indexPath.row < [self.ayInfoData count])
    {
        tztInfoItem *pItem = [self.ayInfoData objectAtIndex:indexPath.row];
        if (pItem)
        {
            [cell SetContent:pItem.InfoContent strTime:pItem.InfoTime];
        }
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.ayInfoData == NULL || [self.ayInfoData count] <= indexPath.row) 
        return;
    _nSelectRow = indexPath.row;
    
    tztInfoItem *pItem = [self.ayInfoData objectAtIndex:indexPath.row];
    if (pItem == NULL || ![pItem isKindOfClass:[tztInfoItem class]]) 
        return;
    
    //判断选中一级菜单时候
    if (pItem.nIsIndex == 1) 
    {
        [self DeleteSubMenu:pItem];
        if (_bIsSubMenu ) 
        {
            _bIsSubMenu = NO;
            [tableView reloadData];
            return;
        }
    }
    
    if (pItem.IndexID && [pItem.IndexID length] > 0 && [pItem.IndexID compare:@"000"] == NSOrderedSame) //信息地雷特殊处理
    {
        pItem.nIsIndex = 1;
    }
    
    if (pItem.nIsIndex == -1)
        return;
    
    if (pItem.nIsIndex == 2)//彩拓(cfrom=caituo)接口
    {
//        NSArray *titleAry = [NSArray arrayWithObjects:@"返回", nil];
//        ShowMessageBox("《财经快讯》手机报——全新生活类财经杂志。以大众化视角+专业化评论、时尚生活+轻松理财等内容为核心，涉及时下财经热点，提供个人理财攻略，引领时尚消费。每周二、四、六上午九点发送。订购方式：发送3811到10086开通，发送3810到10086取消。资费标准：3元/月。详询可咨询10086。",self,(NSMutableArray*)titleAry);
    }
    //下级还是列表
    else if(pItem.nIsIndex == 1)
    {
        if (_tztinfodelegate && [_tztinfodelegate respondsToSelector:@selector(SetInfoItem:pItem_:)])
        {
            [_tztinfodelegate SetInfoItem:self pItem_:pItem];
        }
    }
    //下级是内容
    else if(pItem.nIsIndex == 0)
    {
        if (_tztinfodelegate && [_tztinfodelegate respondsToSelector:@selector(SetInfoItem:pItem_:)])
        {
            [_tztinfodelegate SetInfoItem:self pItem_:pItem];
        }
    }
    
       [tableView reloadData];
}


-(void)SetCellBackGroundColor:(UITableViewCell*)cell frontImage:(NSString*)frontName backImage:(NSString*)backImage
{
    return;
    if (frontName == nil || [frontName length] < 1)
        return;
    UIImageView *frontView = [[[UIImageView alloc] initWithImage:[UIImage imageTztNamed:frontName]] autorelease];
    cell.backgroundView = frontView;
    
    UIImageView *backView = [[[UIImageView alloc] initWithImage:[UIImage imageTztNamed:backImage]] autorelease];
    cell.selectedBackgroundView = backView;
}


-(void)DeleteSubMenu:(tztInfoItem*)item
{
    if (item == nil || _aySubMenuData == nil || [_aySubMenuData count] < 1) 
        return;
    
    //查找对应Item的子菜单
    NSMutableArray* aySubArray = NewObject(NSMutableArray);
    for (int i = 0; i < [_aySubMenuData count]; ++i) 
    {
        NSMutableArray* ayTempArray = [_aySubMenuData objectAtIndex:i];
        if (ayTempArray == nil)
            continue;
        if ([ayTempArray count] > 1)
        {
            tztInfoItem* pItem = [ayTempArray objectAtIndex:0];
            if (pItem && [item.InfoContent compare:pItem.InfoContent] == 0) 
            {
                //找到当前选择的Item,已经打开,获取当前的子菜单
                _bIsSubMenu = YES;
                [aySubArray setArray:[ayTempArray objectAtIndex:1]];
                [ayTempArray removeAllObjects];
                [_aySubMenuData removeObjectAtIndex:i];
                break;
            }
        }
    }
    
    //从ayInfoData中删除aySubArray
    if (_bIsSubMenu) 
    {
        for (int i = 0; i < [aySubArray count]; ++i) 
        {
            tztInfoItem* pItem = [aySubArray objectAtIndex:i];
            for (int j = 0; j < [self.ayInfoData count]; ++j) 
            {
                tztInfoItem* pItem2 = [self.ayInfoData objectAtIndex:j];
                if ([pItem.InfoContent compare:pItem2.InfoContent] == 0) 
                {
                    [self.ayInfoData removeObjectAtIndex:j];
                    break;
                }
            }
        }
    }
    [aySubArray removeAllObjects];
    DelObject(aySubArray);
}
@end
