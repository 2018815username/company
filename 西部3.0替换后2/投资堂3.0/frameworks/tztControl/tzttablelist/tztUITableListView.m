//
//  tztTableListView.m
//  tztMobileApp
//
//  Created by yangares on 13-4-25.
//
//

#import "tztUITableListView.h"
#import "tztUITableListCellView.h"

@implementation tztUITableListView
@synthesize tztdelegate = _tztdelegate;
@synthesize tableproperty = _tableproperty;
@synthesize bExpandALL = _bExpandALL;
@synthesize nsHiddenMenuID = _nsHiddenMenuID;
@synthesize nsSelectedTitle = _nsSelectedTitle;
@synthesize bLocalTitle = _bLocalTitle;
@synthesize isMarketMenu = _isMarketMenu;
@synthesize tableview = _tableview;
@synthesize bRound = _bRound;
@synthesize nFixBackColor = _nFixBackColor;
@synthesize ayHiddenList = _ayHiddenList;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.tztdelegate = nil;
        _aylist = NewObject(NSMutableArray);
        _ayHiddenList = NewObject(NSMutableArray);
        //圆角上下左右自动间距
        _bRound = TRUE;
        self.nsHiddenMenuID = @"";
        _bExpandALL = IS_TZTIPAD;
        _bLocalTitle = TRUE;
        self.isMarketMenu = NO;
        
		if (_bRound)
		{
			_tableview = [[UITableView alloc] initWithFrame:CGRectMake(10, 10, frame.size.width - 20, frame.size.height - 20) style:UITableViewStylePlain];
		}
		else
		{
			_tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height) style:UITableViewStylePlain];
		}
		//表格属性设置
		_tableview.dataSource = self;
		_tableview.delegate = self;
        self.backgroundColor = [UIColor tztThemeBackgroundColorJY];//[tztTechSetting getInstance].backgroundColor;
        _tableview.backgroundColor = [UIColor tztThemeBackgroundColorJY];
		_tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableview.bounces = FALSE;
		//圆角
		if (_bRound)
		{
			_tableview.layer.cornerRadius = 10;
			
		}
		[self addSubview:_tableview];
    }
    return self;
}

-(void)setNFixBackColor:(int)nFixColor
{
    _nFixBackColor = nFixColor;
    if (nFixColor)
    {
        self.backgroundColor = [tztTechSetting getInstance].backgroundColor;
        _tableview.backgroundColor = [tztTechSetting getInstance].backgroundColor;
    }
}

-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    if (_bRound)
    {
        _tableview.frame = CGRectMake(10, 10, frame.size.width - 20, frame.size.height - 20);
    }
    else
    {
        _tableview.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
    }
    [_tableview reloadData];
}

- (void)setTableCornerRadius:(CGFloat)cornerRadius
{
    if(_tableview)
        _tableview.layer.cornerRadius = cornerRadius;
    _bRound = (cornerRadius > 0);
}

- (void)setAyListInfo:(NSArray *)ayListInfo
{
    if(_aylist == nil)
        _aylist = NewObject(NSMutableArray);
    [_aylist removeAllObjects];
    
    NSArray * ayMenuID =[self.nsHiddenMenuID componentsSeparatedByString:@"|"];
    
    for(int i = 0; i < [ayListInfo count]; i++)
    {
        NSDictionary* tradeinfo = [ayListInfo objectAtIndex:i];
        tztUITableListInfo* info = [[tztUITableListInfo alloc] init];
        info.bLocalTitle = _bLocalTitle;
        
        [info setTztTableDictionary:tradeinfo];
        BOOL show = TRUE;
        for (int y = 0; y < [ayMenuID count]; y++)
        {
            NSString * menuid = [ayMenuID objectAtIndex:y];
            if ([info.cellImageName isEqualToString:menuid])
            {
                show = FALSE;
                break;
            }
        }
        if([info cellShow] && show)
            [_aylist addObject:info];
        [info release];
    }
    //问题 6  怎样 使用 reloadDate 的作用
    [self reloadData];
}

-(void)setAyHiddenList:(NSMutableArray *)ayHidden
{
    [_ayHiddenList removeAllObjects];
    for (id obj in ayHidden)
    {
        [_ayHiddenList addObject:obj];
    }
}

-(BOOL)menuShouldHidden:(NSString*)nsKey
{
    if (nsKey.length < 1 || self.ayHiddenList.count < 1)
        return NO;
    for(id obj in self.ayHiddenList)
    {
        if ([nsKey caseInsensitiveCompare:obj] == NSOrderedSame)
            return TRUE;
    }
    return FALSE;
}

//在这里解析配置文件
- (void)setPlistfile:(NSString*)strfile listname:(NSString*)listname
{
    NSString* strPath = GetPathWithListName(strfile,NO);
    NSDictionary* listvalue = [[[NSDictionary alloc] initWithContentsOfFile:strPath] autorelease];
    if (listvalue == NULL || [listvalue count] <= 0)
    {
        strPath = GetTztBundlePlistPath(strfile); //strfile=@"tztUIStockTradeListSetting"

        listvalue = [[[NSDictionary alloc] initWithContentsOfFile:strPath] autorelease];
    }
    if(_aylist == nil)
        _aylist = NewObject(NSMutableArray);
    [_aylist removeAllObjects];
    
    NSArray* arrayValue = (NSArray*)[listvalue objectForKey:listname];
    NSString* strPorperty = [listvalue objectForKey:@"tableproperty"];
    if(strPorperty && [strPorperty length] > 0)
    {
        self.tableproperty = [strPorperty tztNSMutableDictionarySeparatedByString:@"|"];
    }
    
    NSString* nsBorderColor = [self.tableproperty tztValueForKey:@"bordercolor"];
    if (nsBorderColor && nsBorderColor.length > 0)
    {
        UIColor *pColor = [UIColor colorWithTztRGBStr:nsBorderColor];
        if (pColor)
            _tableview.layer.borderColor = pColor.CGColor;
    }
//    tztJYLoginInfo *pJyLoginInfo = [tztJYLoginInfo GetCurJYLoginInfo:TZTAccountPTType]; //null
    for(int i = 0; i < [arrayValue count]; i++)
    {
        NSString* strtablelist = [arrayValue objectAtIndex:i];
        tztUITableListInfo* info = [[tztUITableListInfo alloc] init];
        info.bLocalTitle = _bLocalTitle;
        [info setPlistfile:strfile listValue:strtablelist];
        
        
//        if (pJyLoginInfo.haveZRTRight || !([info.cellImageName isEqualToString:@"TZTRZRQTrade_ZRT_TCSB.png"] || [info.cellImageName isEqualToString:@"TZTRZRQTrade_ZRT_Own.png"])) {
        if ([self menuShouldHidden:info.cellImageName])
        {
            [info release];
            continue;
        }
        if([info cellShow])
            [_aylist addObject:info]; //多个数组
//        }
        
        [info release];
    }
    [self reloadData];
}

// 解析tztMarketMenu byDBQ20131017
- (void)setMarketMenu:(NSString*)nsName
{
    if (nsName == NULL || [nsName length] < 1)
		return;
	
	_tztOutlineData = [[TZTOutLineData alloc] initWithFile:nsName];
    for (int i=0; i< [_tztOutlineData OutlineCount]; i++) {
        NSDictionary *pItem = [_tztOutlineData objectAtIndex:i];
        
        NSString* strCell = [pItem objectForKey:@"Image"];
        //标题
        NSString* strTitle = [_tztOutlineData titleForKey:strCell];
        if ([strCell isEqualToString:@"10"] && [strTitle isEqualToString:@"场内基金"])
        {
            continue;
        }
        tztUITableListInfo* info = [[tztUITableListInfo alloc] init];
        info.bLocalTitle = _bLocalTitle;
        info.cellImageName = [NSString stringWithFormat: @"tztimage_%@",strCell];
        [info setMarketMenu:pItem from:_tztOutlineData];
        if([info cellShow])
            [_aylist addObject:info];
        [info release];
    }
    [self reloadData];
}

-(CGFloat)getShowMaxHeight
{
    CGFloat fShowHeight = 0;
    if(_aylist && [_aylist count] > 0)
    {
        CGRect sectionRect = [_tableview rectForSection:[_aylist count] - 1];
        fShowHeight = sectionRect.origin.y + sectionRect.size.height;
    }
    return fShowHeight;
}

- (void)reloadData
{
    [_tableview reloadData];
    CGFloat fShowHeight = [self getShowMaxHeight];
    if(fShowHeight < self.bounds.size.height - 20)
    {
        CGRect tableframe = _tableview.frame;
        tableframe.size.height = fShowHeight;
        _tableview.frame = tableframe;
    }
    
    if (_bRound)
    {
        _tableview.frame = CGRectMake(10, 10, self.frame.size.width - 20, self.frame.size.height - 20);
        _tableview.layer.cornerRadius = 10;
    }
    else
    {
        _tableview.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        _tableview.layer.cornerRadius = 0;
    }
    
}

- (void)dealloc
{
    NilObject(self.tableproperty);
//    DelObject(_tableview);
    DelObject(_aylist);
    [super dealloc];
}

#pragma mark -
#pragma mark Table view data source
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    _sectionheight = 44;
    if(_tableproperty && [_tableproperty count] > 0)
    {
        NSString* strSectionHeight = [_tableproperty tztValueForKey:@"SectionHeight"];
        if(strSectionHeight && [strSectionHeight floatValue] > 0)
            _sectionheight =  [strSectionHeight floatValue];
    }
	return _sectionheight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat cellheight = 44;
    if(_tableproperty && [_tableproperty count] > 0)
    {
        NSString* strSectionHeight = [_tableproperty tztValueForKey:@"CellHeight"];
        if(strSectionHeight && [strSectionHeight floatValue] > 0)
            cellheight =  [strSectionHeight floatValue];
    }
    return cellheight;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_aylist count]; // 分组数
}

//配置的子项的level值，用于缩进距离计算
- (NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath
{
    tztUITableListInfo *listinfo = [_aylist objectAtIndex:indexPath.section];
    NSInteger nIndex = indexPath.row;
    tztUITableListInfo *cellinfo = [listinfo childAtIndex:&nIndex];
    if(cellinfo)
        return [cellinfo cellLevel];
	return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
	tztUITableListInfo *listinfo = [_aylist objectAtIndex:section];
	if ([listinfo cellExpand])
    {
		return [listinfo getShowChildCount:FALSE];
	}
    else
    {
		return 0;	// 不展开
	}
}

//问题 9 点击为什么在这里调用
-(UIView*)tableView:(UITableView*)tableView viewForHeaderInSection:(NSInteger)section
{
	tztUITableListInfo *listinfo = [_aylist objectAtIndex:section];
    CGRect sectionRect = CGRectMake(0, 0, self.bounds.size.width, _sectionheight);//[tableView rectForHeaderInSection:section];
	tztUITableListSectionView *sectionHeadView = [[tztUITableListSectionView alloc] initWithFrame:sectionRect andType:(self.isMarketMenu ? 1 : 0)];

    if(_tableproperty)
        [sectionHeadView setSectionProperty:_tableproperty];
    [sectionHeadView setListInfo:listinfo section:section delegate:self];
    
    sectionHeadView.cellview.backgroundColor = _tableview.backgroundColor;
	return [sectionHeadView autorelease];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"tztTablelistCell";
    tztUITableListCellView *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[tztUITableListCellView alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
        if(_tableproperty)
            cell.cellproperty = _tableproperty;
        cell.backgroundColor = [UIColor clearColor];
        cell.nType = (self.isMarketMenu ? 1 : 0);
    }
	tztUITableListInfo *listinfo = [_aylist objectAtIndex:indexPath.section];
    NSInteger nIndex = indexPath.row;
    tztUITableListInfo *cellinfo = [listinfo childAtIndex:&nIndex];
    if(cellinfo)
    {
        NSString* strIcon = [cellinfo cellImageName];
        NSString* strTitle = [cellinfo cellTitle];
        [cell setCellInfo:strTitle Icon:strIcon Right:nil Info:cellinfo];
    }
    else
    {
//        TZTLogError(@"表格列表出错%ld,%d",indexPath.section,indexPath.row);
    }
    return cell;
}

-(void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    tztUITableListInfo *listinfo = [_aylist objectAtIndex:indexPath.section];
    NSInteger nIndex = indexPath.row;
    tztUITableListInfo *cellinfo = [listinfo childAtIndex:&nIndex];
    // 读取选择title byDBQ20130821
    if(cellinfo)
    {
        self.nsSelectedTitle = nil;
        self.nsSelectedTitle = [NSString stringWithString:[cellinfo cellTitle]];
    }
    
    if(_bExpandALL)
    {
        BOOL bHaveChild = ([cellinfo getShowChildCount:FALSE] > 0);
        cellinfo.cellExpand = !cellinfo.cellExpand;
        if(bHaveChild || [cellinfo getShowChildCount:FALSE] > 0)
        {
            [self reloadData];
            return;
        }
    }
    
    if (self.isMarketMenu)
    {
        NSString* strCell = [[cellinfo cellInfo] objectForKey:@"Image"];
        //得到配置的该处的功能号
        int nMsgType = [_tztOutlineData msgTypeForKey:strCell];
        NSString* nsName = @"";
        nsName = [_tztOutlineData nsParamForKey:strCell];
        NSArray *pAyCell = [_tztOutlineData arrayForKey:strCell];
        if (_tztdelegate && [_tztdelegate respondsToSelector:@selector(DealWithMenu:nsParam_:pAy_:)])
        {
            [_tztdelegate DealWithMenu:nMsgType nsParam_:nsName pAy_:pAyCell];
            for (int i = 0; i < [_aylist count]; i++)
            {
                tztUITableListInfo *pListInfo = [_aylist objectAtIndex:i];
                [self CancelSelected:pListInfo];
            }
            //设置选中背景
            cellinfo.bSelected = TRUE;
            [self reloadData];
            return;
        }
    }
    
    if(_tztdelegate)
    {
        if([_tztdelegate respondsToSelector:@selector(tztUITableListView:withMsgType:withMsgValue:)])
        {
            if (cellinfo && [cellinfo cellInfo])
            {
                NSString* strMsg = [[cellinfo cellInfo] objectForKey:TZTICONMSGTYPE];
                NSString* strMsgValue = [[cellinfo cellInfo] objectForKey:TZTICONINIT];
                if(strMsg && strMsgValue && [_tztdelegate tztUITableListView:self withMsgType:[strMsg intValue] withMsgValue:strMsgValue])
                {
                    for (int i = 0; i < [_aylist count]; i++)
                    {
                        tztUITableListInfo *pListInfo = [_aylist objectAtIndex:i];
                        [self CancelSelected:pListInfo];
                    }
                    //设置选中背景
                    cellinfo.bSelected = TRUE;
                    [self reloadData];
                    return;
                }
            }
        }
        if (_tztdelegate && [_tztdelegate respondsToSelector:@selector(tztUITableListView:didSelectCell:)])
        {
            [_tztdelegate tztUITableListView:self didSelectCell:cellinfo];
        }
    }
}

-(void)sectionHeaderView:(tztUITableListCellView*)sectionHeaderView sectionClosed:(NSInteger)section
{
	tztUITableListInfo *listinfo = [_aylist objectAtIndex:section];
    if(_bExpandALL)
    {
        BOOL bHaveChild = ([listinfo getShowChildCount :FALSE] > 0);
        listinfo.cellExpand = !listinfo.cellExpand;
        if(bHaveChild || ([listinfo getShowChildCount :FALSE] > 0))
        {
            [self reloadData];
            return;
        }
    }
    
    if(_tztdelegate)
    {
        if([_tztdelegate respondsToSelector:@selector(tztUITableListView:withMsgType:withMsgValue:)])
        {
            NSString* strMsg = [listinfo.cellInfo objectForKey:TZTICONMSGTYPE];
            NSString* strMsgValue = [listinfo.cellInfo objectForKey:TZTICONINIT];
            if(strMsg && strMsgValue && [_tztdelegate tztUITableListView:self withMsgType:[strMsg intValue] withMsgValue:strMsgValue])
            {
                for (int i = 0; i < [_aylist count]; i++)
                {
                    tztUITableListInfo *plistinfo = [_aylist objectAtIndex:i];
                    [self CancelSelected:plistinfo];
                }
                listinfo.bSelected = TRUE;
                [self reloadData];
                return;
            }
        }
        if (_tztdelegate && [_tztdelegate respondsToSelector:@selector(tztUITableListView:didSelectSection:)])
        {
            [_tztdelegate tztUITableListView:self didSelectSection:listinfo];
        }
    }
}

-(void)CancelSelected:(tztUITableListInfo*)pListInfo
{
    if (pListInfo == NULL)
        return;
    
    NSArray *subListInfo = pListInfo.cellayChild;
    if (subListInfo && [subListInfo count] > 0)
    {
        for (int i = 0; i < [subListInfo count]; i++)
        {
            [self CancelSelected:[subListInfo objectAtIndex:i]];
        }
    }
    else
    {
        pListInfo.bSelected = FALSE;
    }
}

-(void)CancelSelectedWithID:(NSInteger)nMsgType
{
    tztUITableListInfo *cellinfo = nil;
    //找到当前设置的功能号所在的位置
    for (int i = 0; i < [_aylist count]; i++)
    {
        tztUITableListInfo *listinfo = [_aylist objectAtIndex:i];
        cellinfo = [self searchTableListInfo:listinfo withMsgType:nMsgType];
        if (cellinfo == nil)
            continue;
        else
            break;
    }
    
    if (cellinfo)
    {
        [self CancelSelected:cellinfo];
    }
}

/*函数功能：ipad 交易左侧的菜单栏目设置功能（目前只支持3级菜单的设置）
 入参：功能号
 出参：无
 */
//-(void)SetMsgType:(int)MsgType
//{
//    int sectionIndex = -1;
//    int CellIndex = -1;
//    int MinCellIndex = -1;
//    //找到当前设置的功能号所在的位置
//    for (int i = 0; i < [_aylist count]; i++)
//    {
//        tztUITableListInfo *listinfo = [_aylist objectAtIndex:i];
//        if (_bExpandALL && [listinfo.cellayChild count] > 0)
//        {
//            for (int j = 0;j < [listinfo.cellayChild count];j++ )
//            {
//                tztUITableListInfo *cellinfo = [listinfo.cellayChild objectAtIndex:j];
//                if (_bExpandALL && [cellinfo.cellayChild count] > 0)
//                {
//                    for (int k = 0; k < [cellinfo.cellayChild count]; k ++ )
//                    {
//                        tztUITableListInfo *Mincellinfo = [cellinfo.cellayChild objectAtIndex:k];
//                        NSString* strMsg = [Mincellinfo.cellInfo objectForKey:TZTICONMSGTYPE];
//                        if ([strMsg intValue] == MsgType)
//                        {
//                            sectionIndex = i;
//                            CellIndex = j;
//                            MinCellIndex = k;
//                            break;
//                        }
//                    }
//                }else
//                {
//                    NSString* strMsg = [cellinfo.cellInfo objectForKey:TZTICONMSGTYPE];
//                    if ([strMsg intValue] == MsgType)
//                    {
//                        sectionIndex = i;
//                        CellIndex = j;
//                        break;
//                    }
//                }
//            }
//        }else
//        {
//            NSString* strMsg = [listinfo.cellInfo objectForKey:TZTICONMSGTYPE];
//            if ([strMsg intValue] == MsgType)
//            {
//                sectionIndex = i;
//                break;
//            }
//        }
//    }
//    //设置选中状态
//    if (sectionIndex >= 0)
//    {
//        tztUITableListInfo *listinfo = [_aylist objectAtIndex:sectionIndex];
//        if (CellIndex >= 0)
//        {
//            tztUITableListInfo *cellinfo = [listinfo.cellayChild objectAtIndex:CellIndex];
//            listinfo.cellExpand = TRUE;
//            if (MinCellIndex >= 0)
//            {
//                tztUITableListInfo *Mincellinfo = [cellinfo.cellayChild objectAtIndex:MinCellIndex];
//                cellinfo.cellExpand = TRUE;
//                [self CancelSelected:Mincellinfo];
//                Mincellinfo.bSelected = TRUE;
//            }else
//            {
//                [self CancelSelected:cellinfo];
//                cellinfo.bSelected = TRUE;
//            }
//        }else
//        {
//            [self CancelSelected:listinfo];
//            listinfo.bSelected = TRUE;
//        }
//    }
//    
//    if([_tztdelegate respondsToSelector:@selector(tztUITableListView:withMsgType:withMsgValue:)])
//        [_tztdelegate tztUITableListView:self withMsgType:MsgType withMsgValue:NULL];
//    [self reloadData];
//}

// 函数功能：ipad 交易左侧的菜单栏目设置功能 byDBQ130830
-(void)SetMsgType:(NSInteger)MsgType
{
    tztUITableListInfo *cellinfo = nil;
    for (int i = 0; i < [_aylist count]; i++)
    {
        tztUITableListInfo *pListInfo = [_aylist objectAtIndex:i];
        [self CancelSelected:pListInfo];
    }
    //找到当前设置的功能号所在的位置
    for (int i = 0; i < [_aylist count]; i++)
    {
        tztUITableListInfo *listinfo = [_aylist objectAtIndex:i];
        cellinfo = [self searchTableListInfo:listinfo withMsgType:MsgType];
        if (cellinfo == nil)
            continue;
        else
            break;
    }
    
    if (cellinfo)
    {
        [self CancelSelected:cellinfo];
        cellinfo.bSelected = YES;
        self.nsSelectedTitle = [NSString stringWithString:[cellinfo cellTitle]];
    }
    
    if([_tztdelegate respondsToSelector:@selector(tztUITableListView:withMsgType:withMsgValue:)])
        [_tztdelegate tztUITableListView:self withMsgType:MsgType withMsgValue:NULL];
    
    if (self.isMarketMenu)
    {
        NSString* strCell = [[cellinfo cellInfo] objectForKey:@"Image"];
        //得到配置的该处的功能号
        int nMsgType = [_tztOutlineData msgTypeForKey:strCell];
        NSString* nsName = @"";
        nsName = [_tztOutlineData nsParamForKey:strCell];
        NSArray *pAyCell = [_tztOutlineData arrayForKey:strCell];
        if (_tztdelegate && [_tztdelegate respondsToSelector:@selector(DealWithMenu:nsParam_:pAy_:)])
        {
            [_tztdelegate DealWithMenu:nMsgType nsParam_:nsName pAy_:pAyCell];
            
        }
    }
    
    [self reloadData];
}

// 递归查找应该选中的行 byDBQ130830
-(tztUITableListInfo *)searchTableListInfo:(tztUITableListInfo *)listinfo withMsgType:(NSInteger)MsgType
{
    tztUITableListInfo *cellinfo = nil;
    if (_bExpandALL && [listinfo.cellayChild count] > 0)
    {
        tztUITableListInfo *Mincellinfo = nil;
        for (int j = 0;j < [listinfo.cellayChild count];j++ )
        {
            tztUITableListInfo *cellinfo = [listinfo.cellayChild objectAtIndex:j];
            
            if (_bExpandALL && [cellinfo.cellayChild count] > 0)
            {
                Mincellinfo = [self searchTableListInfo:cellinfo withMsgType:MsgType ];
                if (Mincellinfo == nil)
                    continue;
                else
                    break;
            }
            else
            {
                if (self.isMarketMenu) // 行情列表的选中
                {
                     NSString* imageName = [cellinfo.cellInfo objectForKey:@"Image"];
                    
                    if ([imageName intValue] == MsgType)
                    {
                        listinfo.cellExpand = YES;
                        return cellinfo;
                    }
                }
                else
                {
                    NSString* strMsg = [cellinfo.cellInfo objectForKey:TZTICONMSGTYPE];
                    if ([strMsg intValue] == MsgType)
                    {
                        listinfo.cellExpand = YES;
                        return cellinfo;
                    }
                }
                
                continue;
            }
        }
        if (Mincellinfo != nil)
        {
            listinfo.cellExpand = YES;
            cellinfo.cellExpand = YES;
            return Mincellinfo;
        }
        else
            return nil;
    }
    else
    {
        if (self.isMarketMenu) // 行情列表的选中
        {
            NSString* imageName = [listinfo.cellInfo objectForKey:@"Image"];
            
            if ([imageName intValue] == MsgType)
            {
                return listinfo;
            }
        }
        else
        {
            NSString* strMsg = [listinfo.cellInfo objectForKey:TZTICONMSGTYPE];
            if ([strMsg intValue] == MsgType)
            {
                return listinfo;
            }
        }
        
        return nil;
    }
}
//在这里获得table中section点击事件 点击15个获得对象 比如基金交易
-(void)sectionHeaderView:(tztUITableListCellView*)sectionHeaderView sectionOpened:(NSInteger)section
{
	tztUITableListInfo *listinfo = [_aylist objectAtIndex:section];
    
    if(listinfo) // 加了点击section时同样有标题的功能 byDBQ20131023
    {
        self.nsSelectedTitle = nil;
        self.nsSelectedTitle = [NSString stringWithString:[listinfo cellTitle]];
    }
    
    if( _bExpandALL )
    {
        BOOL bHaveChild = ([listinfo getShowChildCount :FALSE] > 0);
        listinfo.cellExpand = !listinfo.cellExpand;
        if(bHaveChild || ([listinfo getShowChildCount :FALSE] > 0))
        {
            [self reloadData];
            [_tableview scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:section] atScrollPosition:UITableViewScrollPositionMiddle animated:TRUE];
            return;
        }
    }
    if (self.isMarketMenu)
    {
        NSString* strCell = [[listinfo cellInfo] objectForKey:@"Image"];
        //得到配置的该处的功能号
        int nMsgType = [_tztOutlineData msgTypeForKey:strCell];
        NSString* nsName = @"";
        nsName = [_tztOutlineData nsParamForKey:strCell];
        NSArray *pAyCell = [_tztOutlineData arrayForKey:strCell];
        if (_tztdelegate && [_tztdelegate respondsToSelector:@selector(DealWithMenu:nsParam_:pAy_:)])
        {
            //设置选中背景
            for (int i = 0; i < [_aylist count]; i++)
            {
                tztUITableListInfo *pListInfo = [_aylist objectAtIndex:i];
                [self CancelSelected:pListInfo];
            }
            //设置选中背景
            listinfo.bSelected = TRUE;
            if (IS_TZTIPAD)
                [self reloadData];
            
            [_tztdelegate DealWithMenu:nMsgType nsParam_:nsName pAy_:pAyCell];
            return;
        }
    }
    
    if(_tztdelegate)
    {
        if([_tztdelegate respondsToSelector:@selector(tztUITableListView:withMsgType:withMsgValue:)])
        {
            NSString* strMsg = [listinfo.cellInfo objectForKey:TZTICONMSGTYPE];
            NSString* strMsgValue = [listinfo.cellInfo objectForKey:TZTICONINIT];
            if(strMsg && strMsgValue && [_tztdelegate tztUITableListView:self withMsgType:[strMsg intValue] withMsgValue:strMsgValue])
            {
                //设置选中背景
                for (int i = 0; i < [_aylist count]; i++)
                {
                    tztUITableListInfo *pListInfo = [_aylist objectAtIndex:i];
                    [self CancelSelected:pListInfo];
                }
                //设置选中背景
                listinfo.bSelected = TRUE;
                if (IS_TZTIPAD)
                    [self reloadData];
                return;
            }
        }
        if (_tztdelegate && [_tztdelegate respondsToSelector:@selector(tztUITableListView:didSelectSection:)])
        {
            [_tztdelegate tztUITableListView:self didSelectSection:listinfo];
        }
    }
}

@end
