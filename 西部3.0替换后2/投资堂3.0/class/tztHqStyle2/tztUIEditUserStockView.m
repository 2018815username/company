/*******************************************************************************
 * Copyright (c)2012, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称：    tztUIEditUserStockView
 * 文件标识：
 * 摘    要：   自选股编辑界面
 *
 * 当前版本：    1.0
 * 作    者：   yinjp
 * 完成日期：    2012-12-05
 *
 * 备    注：
 *
 * 修改记录：
 *
 *******************************************************************************/

#import "tztUIEditUserStockView.h"

enum
{
    tztUIEditUserStockCellName = 998,
    tztUIEditUserStockCellCode,
    
    tztUIEditUserStockCellWarn  = 1000,
    tztUIEditUserStockCellDel,
    
    tztUIEditUserStockCellIcon = 2000,
};

#define tztUIEditUserStockBtnTag 0x3333
#define tztUIEditUserStockCellTag 0x4444

@implementation tztUIEditUserStockCell
@synthesize nBtnTag = _nBtnTag;
@synthesize nDelBtnTag = _nDelBtnTag;
@synthesize bSort = _bSort;
@synthesize nStockType = _nStockType;

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier nTag_:(NSInteger)nTag target_:(id)target action_:(SEL)action actionDel_:(SEL)actionDel sort_:(BOOL)sort
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        UILabel *name = [[UILabel alloc] init];
        name.adjustsFontSizeToFitWidth = YES;
        name.textAlignment = NSTextAlignmentLeft;
        name.textColor = [UIColor whiteColor];
        name.font = tztUIBaseViewTextFont(16.0f);
        name.tag = tztUIEditUserStockCellName;
        name.backgroundColor = [UIColor clearColor];
        [self addSubview:name];
        [name release];
        
        
        UILabel *code = [[UILabel alloc] init];
        code.adjustsFontSizeToFitWidth = YES;
        code.textAlignment = NSTextAlignmentLeft;
        code.textColor = [UIColor darkGrayColor];
        code.font = tztUIBaseViewTextFont(11.0f);
        code.tag = tztUIEditUserStockCellCode;
        code.backgroundColor = [UIColor clearColor];
        [self addSubview:code];
        [code release];
        
        _bSort = sort;
        UIButton *btnWarn = [UIButton buttonWithType:UIButtonTypeCustom];
        btnWarn.tag = nTag + tztUIEditUserStockCellTag;
        _nBtnTag = nTag + tztUIEditUserStockCellTag;
        [btnWarn addTarget:target
                    action:action
          forControlEvents:UIControlEventTouchUpInside];
        [btnWarn setContentMode:UIViewContentModeCenter];
        [self addSubview:btnWarn];
        
        UIButton *btnDel = [UIButton buttonWithType:UIButtonTypeCustom];
        btnDel.tag = nTag + tztUIEditUserStockCellTag * 2;
        _nDelBtnTag = nTag + tztUIEditUserStockCellTag * 2;
        [btnDel addTarget:target
                   action:actionDel
         forControlEvents:UIControlEventTouchUpInside];
        [btnDel setContentMode:UIViewContentModeCenter];
        [self addSubview:btnDel];
        
        btnWarn.hidden = _bSort;
        btnDel.hidden = _bSort;
    }
    return self;
}

-(void)SetContentText:(NSString *)first second_:(NSString *)second andStockType:(int)nStockType
{
    UILabel *name = (UILabel*)[self viewWithTag:tztUIEditUserStockCellName];
    if (name)
        name.text = first;
    
    UILabel *code = (UILabel*)[self viewWithTag:tztUIEditUserStockCellCode];
    if (code)
        code.text = second;
    
    UIButton *btnWarn = (UIButton*)[self viewWithTag:_nBtnTag];
    if (btnWarn)
    {
        btnWarn.hidden = MakeHKMarket(nStockType);
    }
    _nStockType = nStockType;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    self.backgroundColor = [UIColor clearColor];
    CGRect bounds = self.bounds;
    
    int nHeight = (bounds.size.height - 4) / 3;
    
    CGRect rcName = bounds;
    rcName.origin.x += 15;
    rcName.origin.y += 2;
    rcName.size.width = 200;
    rcName.size.height = nHeight * 2;
    UILabel *name = (UILabel*)[self viewWithTag:tztUIEditUserStockCellName];
    if (name == NULL)
    {
        name = [[UILabel alloc] initWithFrame:rcName];
        name.adjustsFontSizeToFitWidth = YES;
        name.textAlignment = NSTextAlignmentLeft;
        name.textColor = [UIColor colorWithRGBULong:0xdddddd];
        name.font = tztUIBaseViewTextFont(16.0f);
        name.tag = tztUIEditUserStockCellName;
        name.backgroundColor = [UIColor clearColor];
        [self addSubview:name];
        [name release];
    }
    else
    {
        name.frame = rcName;
    }
    
    CGRect rcCode = rcName;
    rcCode.origin.y += rcName.size.height - 4;
    rcCode.size.height = nHeight;
    
    UILabel *code = (UILabel*)[self viewWithTag:tztUIEditUserStockCellCode];
    if (code == nil)
    {
        code = [[UILabel alloc] initWithFrame:CGRectMake(15, 28, 200, 12)];
        code.adjustsFontSizeToFitWidth = YES;
        code.textAlignment = NSTextAlignmentLeft;
        code.textColor = [UIColor darkGrayColor];
        code.font = tztUIBaseViewTextFont(11.0f);
        code.tag = tztUIEditUserStockCellCode;
        code.backgroundColor = [UIColor clearColor];
        [self addSubview:code];
        [code release];
    }
    else
    {
        code.frame = rcCode;
    }
    
//    CGRect rcIcon = rcCode;
//    rcIcon.origin.x += 90;
//    rcIcon.origin.y += (rcCode.size.height - 9)/2;
//    rcIcon.size.width = 12;
//    rcIcon.size.height = 9;
//    UIImageView *iconView = (UIImageView*)[self viewWithTag:tztUIEditUserStockCellIcon];
//    if (iconView == NULL)
//    {
//        iconView = [[UIImageView alloc] initWithFrame:CGRectMake(100, 30, 12, 9)];
//        iconView.hidden = YES;
//        [self addSubview:iconView];
//        [iconView release];
//    }
//    else
//    {
//        iconView.frame = rcIcon;
//    }
    
    CGRect rcWarn = bounds;
    rcWarn.origin.x = rcWarn.size.width - 130;
    rcWarn.size = CGSizeMake(25, 25);
    rcWarn.origin.y += (bounds.size.height - rcWarn.size.height) / 2;
    
    UIButton *btnWarn = (UIButton*)[self viewWithTag:_nBtnTag];
    btnWarn.frame = rcWarn;
    [btnWarn setBackgroundImage:[UIImage imageTztNamed:@"tztManageWarning.png"] forState:UIControlStateNormal];
    
    CGRect rcDel = bounds;
    rcDel.origin.x = rcDel.size.width - 82;
    rcDel.size = CGSizeMake(25, 25);
    rcDel.origin.y += (bounds.size.height - rcDel.size.height) / 2;
    UIButton *btnDel = (UIButton*)[self viewWithTag:_nDelBtnTag];
    btnDel.frame = rcDel;
    [btnDel setBackgroundImage:[UIImage imageTztNamed:@"tztManagerDel.png"] forState:UIControlStateNormal];
    
    
    btnWarn.hidden = (_bSort || MakeHKMarket(_nStockType));
    btnDel.hidden = _bSort;
}

@end

@implementation tztUIEditUserStockView
@synthesize pTableView = _pTableView;
@synthesize pAyStockList = _pAyStockList;
@synthesize bSort = _bSort;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self initdata];
    }
    return self;
}

-(id)init
{
    if (self = [super init])
    {
        [self initdata];
    }
    return self;
}

-(void)initdata
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:tztUserStockNotificationName object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(OnUserStockChanged:) name:tztUserStockNotificationName object:nil];
    [self LoadUserStock];
    _bSort = FALSE;
}

-(void)setFrame:(CGRect)frame
{
    if (CGRectIsEmpty(frame) || CGRectIsNull(frame))
        return;
    [super setFrame:frame];
    
    self.backgroundColor = [UIColor colorWithTztRGBStr:@"48,48,48"];
    CGRect rcFrame = self.bounds;
    if (_pTableView == nil)
    {
        _pTableView = [[UITableView alloc] init];
        _pTableView.delegate = self;
        _pTableView.dataSource = self;
//        _pTableView.indicatorStyle = UIScrollViewIndicatorStyleDefault;
        _pTableView.separatorColor = [UIColor colorWithRed:55.f/255.0f green:55.f/255.0f blue:55.f/255.0f alpha:1.0f];
        _pTableView.backgroundColor = [UIColor clearColor];
        [_pTableView setEditing:YES animated:YES];
//        _pTableView.allowsSelectionDuringEditing = YES;
        _pTableView.frame = rcFrame;
        [self addSubview:_pTableView];
        [_pTableView release];
    }
    else
    {
        _pTableView.frame = rcFrame;
    }
}

-(void)setBSort:(BOOL)sortFlag
{
    if (_pTableView)
    {
        _bSort = sortFlag;
        [_pTableView setEditing:sortFlag animated:YES];
        [_pTableView reloadData];
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_pAyStockList)
        return [_pAyStockList count];
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleNone;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    tztUIEditUserStockCell *cell = nil;
    static NSString* idt = @"cell";
    cell = (tztUIEditUserStockCell*)[tableView dequeueReusableCellWithIdentifier:idt];
    
    if (cell)
        cell = nil;
    
    cell = [[[tztUIEditUserStockCell alloc] initWithStyle:UITableViewCellStyleDefault
                                         reuseIdentifier:idt
                                                   nTag_:indexPath.row
                                                 target_:self
                                                 action_:@selector(OnBtnWarning:)
                                               actionDel_:@selector(OnBtnDelete:)
                                                    sort_:_bSort] autorelease];
    
    cell.nBtnTag = indexPath.row + tztUIEditUserStockCellTag;
    cell.nDelBtnTag = indexPath.row + tztUIEditUserStockCellTag * 2;
    if (indexPath.row >= [_pAyStockList count])
    {
        [cell SetContentText:@"" second_:@"" andStockType:0];
    }
    else
    {
        NSMutableDictionary *pStock = [_pAyStockList objectAtIndex:indexPath.row];
        if (pStock == NULL)
        {
            [cell SetContentText:@"" second_:@"" andStockType:0];
        }
        else
        {
            [cell SetContentText:[pStock tztObjectForKey:@"Name"] second_:[pStock tztObjectForKey:@"Code"] andStockType:[[pStock tztObjectForKey:@"StockType"] intValue]];
        }
    }
    return cell;
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

-(void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    if (_pAyStockList == NULL)
        return;
    
    NSInteger nToIndex = destinationIndexPath.row;
    NSInteger nFromIndex = sourceIndexPath.row;
    
    if (nToIndex >= [_pAyStockList count]
        || nFromIndex >= [_pAyStockList count])
        return;
    
    _bUserStockChanged = TRUE;
    [_pAyStockList moveObjectFromIndex:nFromIndex toIndex:nToIndex];
    
    NSMutableArray *dict = NewObject(NSMutableArray);
    for (NSInteger i = [_pAyStockList count] - 1; i >= 0; i--)
    {
        [dict addObject:[_pAyStockList objectAtIndex:i]];
    }
    //    [dict addObject:stockInfo];
    [tztUserStock SaveUserStockArray:dict post:YES];
//    [tztUserStock SaveUserStockArray:_pAyStockList post:NO];
    [tableView reloadData];
}

-(BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_pAyStockList == NULL || indexPath.row >= [_pAyStockList count])
    {
        return NO;
    }
    return YES;
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:tztUserStockNotificationName
                                                  object:nil];
    [self SaveUserStock];
    DelObject(_pAyStockList);
    [super dealloc];
}


-(void)OnUserStockChanged:(NSNotification*)notification
{
    if(notification && [notification.name compare:tztUserStockNotificationName]==NSOrderedSame)
    {
        [self LoadUserStock];
    }
}

-(void)LoadUserStock
{
    _bUserStockChanged = FALSE;
    NSMutableArray* ayUserStock = [tztUserStock GetUserStockArray];
    if (_pAyStockList == NULL)
    {
        _pAyStockList = [[NSMutableArray alloc] initWithArray:ayUserStock];
    }
    else
    {
        [_pAyStockList removeAllObjects];
        [_pAyStockList setArray:ayUserStock];
    }
    if (_pTableView)
        [_pTableView reloadData];
}

-(void)SaveUserStock
{
    //保存自选
    //    if(bUserStockChanged)
    //    {
    //        [tztUserStock UploadUserStock];
    //    }
}


-(void)OnBtnWarning:(id)sender
{
    UIButton *pBtn = (UIButton*)sender;
    NSInteger nTag = pBtn.tag - tztUIEditUserStockCellTag;
    
    if (nTag < 0 || nTag >= [self.pAyStockList count])
        return;
    
    NSMutableDictionary *dictStock = [self.pAyStockList objectAtIndex:nTag];
    if (dictStock == NULL)
        return;
    NSString* strCode = [dictStock tztObjectForKey:@"Code"];
    if (strCode.length <= 0)
        return;
    
    NSString* strName = [dictStock tztObjectForKey:@"Name"];
    int nStockType = [[dictStock tztObjectForKey:@"StockType"] intValue];
    tztStockInfo *pStockInfo = NewObjectAutoD(tztStockInfo);
    pStockInfo.stockCode = [NSString stringWithFormat:@"%@", strCode];
    if (strName)
        pStockInfo.stockName = [NSString stringWithFormat:@"%@", strName];
    pStockInfo.stockType = nStockType;
    //
    NSMutableDictionary *pDict = NewObjectAutoD(NSMutableDictionary);
    [pDict setTztObject:pStockInfo forKey:@"tztStockInfo"];
    [TZTUIBaseVCMsg OnMsg:HQ_MENU_YUJING wParam:(NSUInteger)pDict lParam:0];
}

-(void)OnBtnDelete:(id)sender
{
    UIButton *pBtn = (UIButton*)sender;
    NSInteger nTag = pBtn.tag - tztUIEditUserStockCellTag * 2;
    
    if (nTag < 0 || nTag >= [self.pAyStockList count])
        return;
    
    NSMutableDictionary *dictStock = [self.pAyStockList objectAtIndex:nTag];
    if (dictStock == NULL)
        return;
    NSString* strCode = [dictStock tztObjectForKey:@"Code"];
    if (strCode.length <= 0)
        return;
    
    NSString* strName = [dictStock tztObjectForKey:@"Name"];
    int nStockType = [[dictStock tztObjectForKey:@"StockType"] intValue];
    tztStockInfo *pStockInfo = NewObject(tztStockInfo);
    pStockInfo.stockCode = [NSString stringWithFormat:@"%@", strCode];
    if (strName)
        pStockInfo.stockName = [NSString stringWithFormat:@"%@", strName];
    pStockInfo.stockType = nStockType;
    
    if ([tztUserStock IndexUserStock:pStockInfo] >= 0)
    {
        [tztUserStock DelUserStock:pStockInfo];
    }
    DelObject(pStockInfo);
    [_pTableView reloadData];
}

@end
