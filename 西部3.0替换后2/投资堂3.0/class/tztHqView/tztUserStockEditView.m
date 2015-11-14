/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:        自选股设置
 * 文件标识:        
 * 摘要说明:        
 * 
 * 当前版本:        2.0
 * 作    者:       yinjp
 * 更新日期:            
 * 整理修改:	
 *
 ***************************************************************/

#import "tztUserStockEditView.h"

enum
{
    tztEditStockTableCellDel  = 997,
    tztEditStockTableCellTitle = 998,
    tztEditStockTableCellContent,
    tztEditStockTableCellTop,
    tztEditStockTableCellMove,
    tztEditStockTableCellImage,
};

@interface tztEditStockTableCell ()

@property(nonatomic)BOOL bSelected;
@property(nonatomic)int  nStockType;
@end

@implementation tztEditStockTableCell
@synthesize tztDelegate = _tztDelegate;
@synthesize nStockType = _nStockType;

-(BOOL)isChecked
{
    UIButton *btnDel = (UIButton*)[self viewWithTag:tztEditStockTableCellDel];
    return btnDel.selected;
}

-(void)setChecked:(BOOL)bCheck
{
    _bSelected = bCheck;
    UIButton *btnDel = (UIButton*)[self viewWithTag:tztEditStockTableCellDel];
    if (btnDel)
        btnDel.selected = bCheck;
}


-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier])
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        //删除按钮
        UIButton *btnDel = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnDel setImage:[UIImage imageTztNamed:@"tztUserStockUnSelect.png"] forState:UIControlStateNormal];
        [btnDel setImage:[UIImage imageTztNamed:@"tztUserStockSelected.png"] forState:UIControlStateSelected];
        btnDel.frame = CGRectMake(5, 6, 32, 32);
        btnDel.tag = tztEditStockTableCellDel;
        btnDel.showsTouchWhenHighlighted = YES;
        [btnDel addTarget:self
                   action:@selector(OnButtonClick:)
         forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btnDel];
        
        //代码信息
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(45, 4, 100, 24)];
        title.adjustsFontSizeToFitWidth = TRUE;
        title.textAlignment = UITextAlignmentLeft;
        title.textColor = [UIColor whiteColor];
        title.font = tztUIBaseViewTextFont(15.0f);
        title.backgroundColor = [UIColor clearColor];
        [title setTag:tztEditStockTableCellTitle];
        [self addSubview:title];
        [title release];
        
        UILabel *content = [[UILabel alloc] initWithFrame:CGRectMake(45, 24, 100, 12)];
        content.textAlignment = UITextAlignmentLeft;
        content.textColor = [UIColor whiteColor];
        content.font = tztUIBaseViewTextFont(10.0f);
        content.backgroundColor = [UIColor clearColor];
        [content setTag:tztEditStockTableCellContent];
        [self addSubview:content];
        [content release];
        
        UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(90, 28, 12, 9)];
        image.tag = tztEditStockTableCellImage;
        [self addSubview:image];
        [image release];
        
        //置顶
        UIButton *btnTop = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *imageTop = [UIImage imageTztNamed:@"TZTEditStockTop.png"];
        [btnTop setTztBackgroundImage:imageTop];
        
        btnTop.frame = CGRectMake(190, (self.frame.size.height - imageTop.size.height) / 2, imageTop.size.width, imageTop.size.height);
        btnTop.tag = tztEditStockTableCellTop;
        btnTop.showsTouchWhenHighlighted = YES;
        [btnTop addTarget:self
                   action:@selector(OnButtonClick:)
         forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btnTop];
        
//        //移动
//        UIButton *btnMove = [UIButton buttonWithType:UIButtonTypeCustom];
//        [btnMove setTztBackgroundImage:[UIImage imageTztNamed:@"TZTEditStockMove.png"]];
//        btnMove.frame = CGRectMake(270, 6, 32, 32);
//        btnMove.tag = tztEditStockTableCellMove;
//        [btnMove addTarget:self
//                   action:@selector(OnButtonClick:)
//         forControlEvents:UIControlEventTouchUpInside];
//        [self addSubview:btnMove];
        
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    CGRect rcFrame = self.bounds;
    float fWidth = rcFrame.size.width / 3;
    rcFrame = CGRectMake(5, 6, 32, 32);
    //删除按钮
    UIButton *btnDel = (UIButton*)[self viewWithTag:tztEditStockTableCellDel];
    if (btnDel)
    {
        btnDel.frame = rcFrame;
    }
    
    //代码信息
    rcFrame.origin.x = 45;
    rcFrame.origin.y = 4;
    rcFrame.size.width = 100;
    rcFrame.size.height = 24;
    UILabel *title = (UILabel*)[self viewWithTag:tztEditStockTableCellTitle];
    if (title)
        title.frame = rcFrame;
    
    rcFrame.origin.x = 45;
    rcFrame.origin.y = 24;
    rcFrame.size.height = 12;
    rcFrame.size.width = 100;
    
    UILabel *content = (UILabel*)[self viewWithTag:tztEditStockTableCellContent];
    if (content)
        content.frame = rcFrame;
    
    rcFrame.origin.x = 90;
    rcFrame.origin.y = 25;
    rcFrame.size.width = 12;
    rcFrame.size.height = 9;
    UIImageView *image = (UIImageView*)[self viewWithTag:tztEditStockTableCellImage];
    if (image)
        image.frame = rcFrame;
    
    rcFrame.origin.x = 190;
    if (IS_TZTIPAD)
    {
        rcFrame.origin.x += fWidth;
    }
    rcFrame.origin.y = 6;
    rcFrame.size = CGSizeMake(32, 32);
    //置顶
//    UIButton *btnTop = (UIButton*)[self viewWithTag:tztEditStockTableCellTop];
//    if (btnTop)
//        btnTop.frame = rcFrame;
}

-(void)SetLabel:(int)nPoint first:(int)nFirstWidth second:(int)nSecondWidth
{
    UILabel *firstText = (UILabel*)[self viewWithTag:tztEditStockTableCellTitle];
    CGRect frame = firstText.frame;
    frame.origin.x = nPoint;
    frame.size.width = nFirstWidth;
    firstText.frame = frame;
    
    UILabel *secondText = (UILabel*)[self viewWithTag:tztEditStockTableCellContent];
    frame = secondText.frame;
    frame.origin.x = firstText.frame.origin.x + nFirstWidth;
    secondText.frame = frame;
}

-(void)SetContentText:(NSString *)first secondTitle:(NSString *)second
{
    UILabel *firstText = (UILabel*)[self viewWithTag:tztEditStockTableCellTitle];
    firstText.text = first;
    
    UILabel *secondText = (UILabel*)[self viewWithTag:tztEditStockTableCellContent];
    secondText.text = second;
    
//    CGSize sz = [second sizeWithFont:secondText.font].width + 5;
    
}

-(void)SetContentTextColor:(UIColor *)clFirst secondColor:(UIColor *)clSecond
{
    UILabel *firstText = (UILabel*)[self viewWithTag:tztEditStockTableCellTitle];
    firstText.textColor = clFirst;
    
    UILabel *secondText = (UILabel*)[self viewWithTag:tztEditStockTableCellContent];
    secondText.textColor = clSecond;
}

-(void)OnButtonClick:(id)sender
{
    UIButton *btn = (UIButton*)sender;
    if (btn == NULL)
        return;
    
    int nTag = -1;
    if (btn.tag == tztEditStockTableCellDel)
    {
        btn.selected = !btn.selected;
        if (btn.selected)
            nTag = 0;
        else
            nTag = 0x11;
    }
    else if (btn.tag == tztEditStockTableCellTop)
        nTag = 1;
    
    if (nTag < 0)
        return;
    
    if (self.tztDelegate && [self.tztDelegate respondsToSelector:@selector(tztEditStockTableCell:WithType_:)])
    {
        [self.tztDelegate tztEditStockTableCell:self WithType_:nTag];
    }
}

-(void)setNStockType:(int)nType
{
    UIImageView *imageView = (UIImageView*)[self viewWithTag:tztEditStockTableCellImage];
    if (imageView == NULL)
        return;
    if (MakeUSMarket(nType))
        [imageView setImage:[UIImage imageTztNamed:@"TZTUSIcon@2x.png"]];
    else if (MakeHKMarket(nType))
        [imageView setImage:[UIImage imageTztNamed:@"TZTHKIcon@2x.png"]];
    else
        [imageView setImage:nil];
}

-(void)dealloc
{
    [super dealloc];
}
@end


@interface tztUserStockEditView ()<TZTUIMessageBoxDelegate>

//记录需要删除的自选股
@property(nonatomic,retain)NSMutableArray   *ayDelUserStock;

@end

@implementation tztUserStockEditView
@synthesize pTableView = _pTableView;
@synthesize pAyStockList = _pAyStockList;

-(id)init
{
    self = [super init];
    if (self)
    {
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(OnUserStockChanged:) name:tztUserStockNotificationName object:nil];
        [self LoadUserStock];
    }
    return self;
}

-(void)setFrame:(CGRect)frame
{
    if (CGRectIsNull(frame) || CGRectIsEmpty(frame))
        return;
    
    [super setFrame:frame];
    
    CGRect rcFrame = self.bounds;
    if (_pTableView == nil)
    {
        _pTableView = [[UITableView alloc] init];
        _pTableView.delegate = self;
        _pTableView.dataSource = self;
        _pTableView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
//        _pTableView.separatorColor = [UIColor colorWithRed:34/255.0 green:34/255.0 blue:34/255.0 alpha:1.0];
        _pTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _pTableView.backgroundColor = [UIColor clearColor];
        [_pTableView setEditing:YES animated:YES];
        if ([_pTableView respondsToSelector:@selector(setSeparatorInset:)]) {
            [_pTableView setSeparatorInset:UIEdgeInsetsZero];
        }
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

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_pAyStockList)
        return [_pAyStockList count];
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *pView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 30)];
    pView.backgroundColor = [UIColor tztThemeBackgroundColorSection];
    
    float fWidth = tableView.frame.size.width / 3;
    CGRect rcFrame = CGRectMake(45, 0, 100, 30);
    UILabel *pName = [[UILabel alloc] initWithFrame:rcFrame];
    pName.text = @"名称代码";
    pName.font = tztUIBaseViewTextFont(14.0f);
    pName.textColor = [UIColor tztThemeTextColorForSection];
    pName.backgroundColor = [UIColor clearColor];
    
    [pView addSubview:pName];
    [pName release];
    
    rcFrame.origin.x += rcFrame.size.width  + 45;
    if (IS_TZTIPAD)
    {
        rcFrame.origin.x += fWidth;
    }
    
    rcFrame.origin.x -= 5;
    rcFrame.size.width = 50;
        
    UILabel *labelTop = [[UILabel alloc] initWithFrame:rcFrame];
    labelTop.text = @"置顶";
    labelTop.font = tztUIBaseViewTextFont(14.0f);
    labelTop.textColor = [UIColor tztThemeTextColorForSection];
    labelTop.backgroundColor = [UIColor clearColor];
    [pView addSubview:labelTop];
    [labelTop release];
    
    rcFrame.origin.x += rcFrame.size.width + 30 + 5;
    if (IS_TZTIPAD)
    {
        rcFrame.origin.x += fWidth;
    }
    
    UILabel *labelMove = [[UILabel alloc] initWithFrame:rcFrame];
    labelMove.text = @"拖动";
    labelMove.font = tztUIBaseViewTextFont(14.0f);
    labelMove.textColor = [UIColor tztThemeTextColorForSection];
    labelMove.backgroundColor = [UIColor clearColor];
    labelMove.textAlignment = NSTextAlignmentCenter;
    [pView addSubview:labelMove];
    [labelMove release];
    
    return [pView autorelease];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    tztEditStockTableCell *cell = nil;
    static NSString* idt = @"cell";
    cell = (tztEditStockTableCell*)[tableView dequeueReusableCellWithIdentifier:idt];
    
    if (cell == nil)
    {
        cell = [[[tztEditStockTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:idt] autorelease];
        cell.tztDelegate = self;
//        [cell SetLabel:40 first:100 second:90];
    }
    
    cell.tag = 1024+indexPath.row;
//    cell.selectionStyle = UITableViewCellStateShowingEditControlMask;
    
    [cell SetContentTextColor:[UIColor tztThemeTextColorLabel] secondColor:[UIColor tztThemeTextColorLabel]];
//    if ([self.nsBackColor intValue])
//    {
//        [cell SetContentTextColor:[UIColor blackColor] secondColor:[UIColor darkGrayColor]];
//    }
    
    int nStockType = 0;
    if (indexPath.row >= [_pAyStockList count])
    {
        [cell SetContentText:@"" secondTitle:@""];
    }
    else
    {
        NSMutableDictionary *pStock = [_pAyStockList objectAtIndex:indexPath.row];
        if (pStock == NULL)
        {
            [cell SetContentText:@"" secondTitle:@""];
        }
        else
        {
            BOOL bExist = FALSE;
            for (NSDictionary* subStock in _ayDelUserStock)
            {
                NSString* strCode = [subStock tztObjectForKey:@"Code"];
                NSInteger nType = [[subStock tztObjectForKey:@"StockType"] intValue];
                if (strCode.length <= 0)
                    continue;
                if ([strCode caseInsensitiveCompare:[pStock tztObjectForKey:@"Code"]] == NSOrderedSame
                    && nType == [[pStock tztObjectForKey:@"StockType"] intValue])
                {
                    bExist = YES;
                    break;
                }
            }
            
            [cell setChecked:bExist];
            
            [cell SetContentText:[pStock tztObjectForKey:@"Name"] secondTitle:[pStock tztObjectForKey:@"Code"]];
        }
        nStockType = [[pStock tztObjectForKey:@"StockType"] intValue];
    }
    
    cell.nStockType = nStockType;
    return cell;
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)//删除
    {
        bUserStockChanged = TRUE;
        NSMutableDictionary *pDict = [_pAyStockList objectAtIndex:indexPath.row];
        tztStockInfo *pStock = NewObject(tztStockInfo);
        pStock.stockCode = [NSString stringWithFormat:@"%@", [pDict tztObjectForKey:@"Code"]];
        pStock.stockName = [NSString stringWithFormat:@"%@", [pDict tztObjectForKey:@"Name"]];
        pStock.stockType = [[pDict tztObjectForKey:@"Name"] intValue];
        [tztUserStock SendDelUserStockReq:pStock];
        DelObject(pStock);
        
        [_pAyStockList removeObjectAtIndex:indexPath.row];
        [tztUserStock SaveUserStockArray:_pAyStockList post:YES];
        [tableView reloadData];
    }
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleNone;
//    UITableViewCellEditingStyle style;
//    if (_pAyStockList && indexPath.row < [_pAyStockList count])
//        style = UITableViewCellEditingStyleDelete;
//    else
//        style = UITableViewCellEditingStyleInsert;
//    return style;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    return @"";
    return @"删除";
}
//移动
-(void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    if (_pAyStockList == NULL)
        return;
    
    NSInteger nToIndex = destinationIndexPath.row;
    NSInteger nFromIndex = sourceIndexPath.row;
    if (nToIndex >= [_pAyStockList count] || nFromIndex >= [_pAyStockList count])
        return;
    
    bUserStockChanged = TRUE;
    
    [_pAyStockList moveObjectFromIndex:sourceIndexPath.row toIndex:destinationIndexPath.row];
    
    NSMutableArray *dict = NewObject(NSMutableArray);
    for (NSInteger i = [_pAyStockList count] - 1; i >= 0; i--)
    {
        [dict addObject:[_pAyStockList objectAtIndex:i]];
    }
//    [dict addObject:stockInfo];
    [tztUserStock SaveUserStockArray:dict post:YES];
    
//    [tztUserStock SaveUserStockArray:_pAyStockList post:NO];
    [tableView reloadData];
//    if (sourceIndexPath.row > destinationIndexPath.row)
//    {
//        for (int i = sourceIndexPath.row ; i > destinationIndexPath.row ; i--)
//        {
//            [_pAyStockList exchangeObjectAtIndex:(i-1) withObjectAtIndex:i];
//        }
//    }
//    else
//    {
//        for (int i = sourceIndexPath.row; i < destinationIndexPath.row; i++)
//        {
//            [_pAyStockList exchangeObjectAtIndex:(i+1) withObjectAtIndex:i];
//        }
//    }
}

-(BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_pAyStockList == NULL || indexPath.row >= [_pAyStockList count])
        return NO;
    return YES;
}

-(void)dealloc
{
	[[NSNotificationCenter defaultCenter]removeObserver:self name:tztUserStockNotificationName object:nil];
    //保存自选
    [self SaveUserStock];
    DelObject(_pAyStockList);
    DelObject(_ayDelUserStock);
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
    bUserStockChanged = FALSE;
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


//事件响应
-(void)tztEditStockTableCell:(tztEditStockTableCell *)sender WithType_:(int)nType
{
    NSInteger nTag = sender.tag - 1024;
    if (nTag < 0 || nTag >= [_pAyStockList count])
        return;
    switch (nType)
    {
        case 0://删除
        {
            if (_ayDelUserStock == NULL)
                _ayDelUserStock = NewObject(NSMutableArray);
            NSMutableDictionary *pDict = [_pAyStockList objectAtIndex:nTag];
            if (pDict)
            {
                NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:pDict];
                [_ayDelUserStock addObject:dict];
            }
            
//            tztAfxMessageBlock(@"确定删除该股票？", nil, nil, TZTBoxTypeButtonBoth, ^(NSInteger nIndex)
//                               {
//                                   if (nIndex == 0)
//                                   {
//                                       bUserStockChanged = TRUE;
//                                       NSMutableDictionary *pDict = [_pAyStockList objectAtIndex:nTag];
//                                       tztStockInfo *pStock = NewObject(tztStockInfo);
//                                       pStock.stockCode = [NSString stringWithFormat:@"%@", [pDict tztObjectForKey:@"Code"]];
//                                       pStock.stockName = [NSString stringWithFormat:@"%@", [pDict tztObjectForKey:@"Name"]];
//                                       pStock.stockType = [[pDict tztObjectForKey:@"StockType"] intValue];
//#ifndef tzt_NotUploadWhenAddOrDel
//                                       [tztUserStock SendDelUserStockReq:pStock];
//#endif
//                                       DelObject(pStock);
//                                       
//                                       [_pAyStockList removeObjectAtIndex:nTag];
//                                       
//                                       NSMutableArray *dict = NewObject(NSMutableArray);
//                                       for (NSInteger i = [_pAyStockList count] - 1; i >= 0; i--)
//                                       {
//                                           [dict addObject:[_pAyStockList objectAtIndex:i]];
//                                       }
//                                       [tztUserStock SaveUserStockArray:dict post:YES];
////                                       [tztUserStock SaveUserStockArray:_pAyStockList post:YES];
//                                       [_pTableView reloadData];
//
//                                   }
//                               });
        }
            break;
        case 0x11://取消选择
        {
            NSMutableDictionary *pDict = [_pAyStockList objectAtIndex:nTag];
            if (pDict == NULL || [[pDict tztObjectForKey:@"Code"] length] <= 0)
                return;
            for (NSDictionary* subStock in _ayDelUserStock)
            {
                NSString* strCode = [subStock tztObjectForKey:@"Code"];
                NSInteger nType = [[subStock tztObjectForKey:@"StockType"] intValue];
                if (strCode.length <= 0)
                    continue;
                if ([strCode caseInsensitiveCompare:[pDict tztObjectForKey:@"Code"]] == NSOrderedSame
                    && nType == [[pDict tztObjectForKey:@"StockType"] intValue])
                {
                    [_ayDelUserStock removeObject:subStock];
                    break;
                }
            }
        }
            break;
        case 1:
        {
            bUserStockChanged = TRUE;
            NSMutableDictionary *pDict = [_pAyStockList objectAtIndex:nTag];
            tztStockInfo *pStock = NewObject(tztStockInfo);
            pStock.stockCode = [NSString stringWithFormat:@"%@", [pDict tztObjectForKey:@"Code"]];
            pStock.stockName = [NSString stringWithFormat:@"%@", [pDict tztObjectForKey:@"Name"]];
            pStock.stockType = [[pDict tztObjectForKey:@"StockType"] intValue];
            [_pAyStockList removeObjectAtIndex:nTag];
            
            NSMutableDictionary *stockInfo = NewObject(NSMutableDictionary);
            [stockInfo setTztObject:pStock.stockCode forKey:@"Code"];
            [stockInfo setTztObject:pStock.stockName forKey:@"Name"];
            [stockInfo setTztObject:[NSString stringWithFormat:@"%d", pStock.stockType] forKey:@"StockType"];
            
//            [_pAyStockList addObject:stockInfo];
//            [_pAyStockList insertObject:stockInfo atIndex:0];
            
            NSMutableArray *dict = NewObject(NSMutableArray);
            for (NSInteger i = [_pAyStockList count] - 1; i >= 0; i--)
            {
                [dict addObject:[_pAyStockList objectAtIndex:i]];
            }
            [dict addObject:stockInfo];
            [tztUserStock SaveUserStockArray:dict post:YES];
            DelObject(stockInfo);
            DelObject(pStock);
            [_pTableView reloadData];
        }
            break;
        default:
        break;
    }
}

-(void)DeleteUserStock
{
    if (_ayDelUserStock.count <= 0)
        return;
    tztAfxMessageBlockWithDelegate(@"确定删除所选自选股？", nil, nil, TZTBoxTypeButtonBoth, self, nil);
}

-(void)TZTUIMessageBox:(TZTUIMessageBox *)TZTUIMessageBox clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        if (self.ayDelUserStock.count <= 0)
            return;
        bUserStockChanged = TRUE;
        
        for (tztStockInfo * pStock in self.ayDelUserStock)
        {
            [self.pAyStockList removeObject:pStock];
        }
        
        NSMutableArray *dict = NewObject(NSMutableArray);
        for (NSInteger i = [_pAyStockList count] - 1; i >= 0; i--)
        {
            [dict addObject:[_pAyStockList objectAtIndex:i]];
        }
        [tztUserStock SaveUserStockArray:dict post:YES];
        [dict release];
        
#ifdef tzt_EditUserStockAuto_NoToolBar
        g_nsLogMobile = [tztKeyChain load:tztLogMobile];
        if (g_nsLogMobile.length > 0)
            [[tztUserStock getShareClass] Upload];
#endif
        //                                       [tztUserStock SaveUserStockArray:_pAyStockList post:YES];
        [_pTableView reloadData];
    }
}
@end













