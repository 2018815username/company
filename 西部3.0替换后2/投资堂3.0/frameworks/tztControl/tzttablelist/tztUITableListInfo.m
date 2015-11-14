//
//  tztUITableListInfo.m
//  tztMobileApp
//
//  Created by yangares on 13-4-25.
//
//

#import "tztUITableListInfo.h"
@implementation tztUITableListInfo

@synthesize cellShow = _cellShow;
@synthesize cellExpand = _cellExpand;
@synthesize cellLevel  = _cellLevel;
@synthesize cellImageName = _cellImageName;
@synthesize cellTitle = _cellTitle;
@synthesize cellInfo = _cellInfo;
@synthesize cellayChild = _cellayChild;
@synthesize bSelected = _bSelected;
@synthesize bLocalTitle = _bLocalTitle;

- (id)init
{
    self = [super init];
    if(self)
    {
        _cellLevel = 1;
        _bSelected = FALSE;
        _bLocalTitle = TRUE;
    }
    return self;
}

- (void)setTztTableDictionary:(NSDictionary *)tableDictionary
{
    _cellShow = FALSE;
    NSString* strShow = [tableDictionary objectForKey:@"Show"];
    if(strShow && [strShow length] > 0)
        _cellShow = [strShow boolValue];
    
    _cellExpand = FALSE;
    NSString* strExpand = [tableDictionary objectForKey:@"Expanded"];
    if(strExpand && [strExpand length] > 0)
        _cellExpand = [strExpand boolValue];

    self.cellImageName = [tableDictionary objectForKey:@"Image"];
    NSString* cellData = [tableDictionary objectForKey:@"MenuData"];
    self.cellTitle = [tableDictionary objectForKey:@"MenuTitle"];
    if(cellData && [cellData length] > 0)
    {
        self.cellInfo = [cellData tztPropertySeparatedByString:@"|"];
        self.cellTitle = [self.cellInfo objectForKey:TZTICONTITLE];
        
        NSArray *ay = [cellData componentsSeparatedByString:@"|"];
        strShow = [ay lastObject];
#ifdef tzt_ShowAllMenu
        _cellShow = TRUE;
#else
        if (strShow && [strShow caseInsensitiveCompare:@"F"] == NSOrderedSame)
            _cellShow = FALSE;
#endif
    }
    NSString* strCell = [tableDictionary objectForKey:@"Level"];
    if(strCell && [strCell length] > 0)
    {
        self.cellLevel = [strCell intValue];
    }
    else
    {
        self.cellLevel = 0;
    }
    NSMutableArray* ayChild = [tableDictionary objectForKey:@"children"];
    [self setAyNSDictionaryChild:ayChild];
}

- (void)setPlistfile:(NSString*)strfile listValue:(NSString*)strValue
{
    if(_cellayChild == nil)
        _cellayChild = NewObject(NSMutableArray);
    self.cellInfo = [strValue tztPropertySeparatedByString:@"|"];
    [_cellayChild removeAllObjects];
    
    if(self.cellInfo == nil || [self.cellInfo count] <= 0)
    {
        self.cellShow = FALSE;
        self.cellExpand = FALSE;
        self.cellImageName = @"";
        self.cellTitle = @"";
    }
    else
    {
        self.cellShow = TRUE;
        self.cellExpand = FALSE;
        self.cellImageName = [_cellInfo objectForKey:TZTICONNAME];
        self.cellTitle = [_cellInfo objectForKey:TZTICONTITLE];
        NSString* strChild = [_cellInfo objectForKey:TZTICONCHILD];
        if(strfile && [strfile length] > 0)
        {
            NSString* strPath = GetPathWithListName(strfile,NO);
            NSDictionary* listvalue = [[[NSDictionary alloc] initWithContentsOfFile:strPath] autorelease];
            if (listvalue == NULL || [listvalue count] <= 0)
            {
                strPath = GetTztBundlePlistPath(strfile);
                listvalue = [[[NSDictionary alloc] initWithContentsOfFile:strPath] autorelease];
            }
            if(listvalue && [listvalue count] > 0)
            {
                NSArray* arrayValue = (NSArray*)[listvalue objectForKey:strChild];
                for (int i = 0 ; i < [arrayValue count]; i++)
                {
                    NSString* strValue = [arrayValue objectAtIndex:i];
                    tztUITableListInfo* listinfo = [[tztUITableListInfo alloc] init];
                    listinfo.cellLevel = _cellLevel + 1;
                    [listinfo setPlistfile:strfile listValue:strValue];
                    if([listinfo cellShow])
                    {
                        [_cellayChild addObject:listinfo];
                    }
                    [listinfo release];
                }
            }
        }
    }
}

// 处理MarketMenu配置文件数据 byDBQ20131017
- (void)setMarketMenu:(NSDictionary*)pItem from:(TZTOutLineData*)outData
{
    if(_cellayChild == nil)
        _cellayChild = NewObject(NSMutableArray);
    self.cellInfo = pItem;
    [_cellayChild removeAllObjects];
    
    if(self.cellInfo == nil || [self.cellInfo count] <= 0)
    {
        self.cellShow = FALSE;
        self.cellExpand = FALSE;
        self.cellImageName = @"";
        self.cellTitle = @"";
    }
    else
    {
        BOOL bShow = [[pItem objectForKey:@"Show"] boolValue];
        self.cellShow = bShow;
        
        //当前是否是展开的
        BOOL bExpanded = [[pItem objectForKey:@"Expanded"] boolValue];
        self.cellExpand = bExpanded;
        
        NSString* strCell = [pItem objectForKey:@"Image"];
        //标题
        NSString* strTitle = [outData titleForKey:strCell];
        self.cellTitle = strTitle;
        
        //子项数组
        NSArray *pAy = [pItem objectForKey:@"children"];
        
        for (int i = 0 ; i < [pAy count]; i++)
        {
            NSDictionary *childDic = [pAy objectAtIndex:i];
            tztUITableListInfo* listinfo = [[tztUITableListInfo alloc] init];
            listinfo.cellLevel = [[childDic objectForKey:@"Level"] intValue];
            
            [listinfo setMarketMenu:childDic from:outData];
            
            if([listinfo cellShow])
            {
                [_cellayChild addObject:listinfo];
            }
            [listinfo release];
            
        }
    }
}

- (void)setAyValueChild:(NSMutableArray*)ayChild
{
    if(_cellayChild == nil)
        _cellayChild = NewObject(NSMutableArray);
    [_cellayChild removeAllObjects];
    
    for (int i = 0; i < [ayChild count]; i++)
    {
        NSString* strValue = [ayChild objectAtIndex:i];
        tztUITableListInfo* listinfo = [[tztUITableListInfo alloc] init];
        listinfo.cellLevel = _cellLevel + 1;
        [listinfo setPlistfile:nil listValue:strValue];
        if([listinfo cellShow])
        {
            [_cellayChild addObject:listinfo];
        }
        [listinfo release];
    }
}


- (void)setAyNSDictionaryChild:(NSMutableArray*)ayChild
{
    if(_cellayChild == nil)
        _cellayChild = NewObject(NSMutableArray);
    [_cellayChild removeAllObjects];
    if(ayChild == nil || [ayChild count] <= 0)
        return;
    for (int i = 0; i < [ayChild count]; i++)
    {
        NSDictionary* childValue = [ayChild objectAtIndex:i];
        tztUITableListInfo* listinfo = [[tztUITableListInfo alloc] init];
        listinfo.cellLevel = _cellLevel+1;
        [listinfo setTztTableDictionary:childValue];
        if([listinfo cellShow])
        {
            [_cellayChild addObject:listinfo];
        }
        [listinfo release];
    }
}

//获取第index个子节点
- (id)childAtIndex:(NSInteger *)index
{
    NSInteger nIndex = *index;
    if(!self.cellExpand)
        return NULL;
    if(!self.cellShow)
        return NULL;
    if(self.cellayChild == nil || [self.cellayChild count] <= 0)
        return NULL;
    if (nIndex < [self getShowChildCount:FALSE])
    {
        for (int i = 0; i < [self.cellayChild count]; i++)
        {
            tztUITableListInfo* CellInfo = (tztUITableListInfo*)[self.cellayChild objectAtIndex:i];
            if(CellInfo && [CellInfo cellShow])
            {
                nIndex--;
                if(nIndex < 0)
                    return CellInfo;
                tztUITableListInfo* info = (tztUITableListInfo*)[CellInfo childAtIndex:&nIndex];
                if(info)
                {
                    return info;
                }            
            }
        }
    }
    else
    {
        nIndex -= [self getShowChildCount:FALSE];
        *index = nIndex;
    }
    return NULL;
}

- (int)getShowChildCount:(BOOL)bSelf
{
    if(!self.cellShow)
        return 0;

    int nCount = (bSelf ? 1 : 0);
    if(!self.cellExpand)
        return nCount;

    for (int i = 0; i < [self.cellayChild count]; i++)
    {
        tztUITableListInfo* listInfo = (tztUITableListInfo *)[self.cellayChild objectAtIndex:i];
        nCount += [listInfo getShowChildCount:TRUE];
    }
    return nCount;
}

- (void)dealloc
{
    NilObject(self.cellImageName);
	NilObject(self.cellInfo);
    NilObject(self.cellTitle);
    DelObject(_cellayChild);
    [super dealloc];
}

-(NSString*)cellTitle
{
    NSString* nsTitle = _cellTitle;
    if (self.cellInfo && _bLocalTitle)
    {
        int nMsgType = [[self.cellInfo objectForKey:TZTICONMSGTYPE] intValue];
        nsTitle = GetTitleByID(nMsgType);
        if (!ISNSStringValid(nsTitle))
        {
            return _cellTitle;
        }
    }
    return [NSString stringWithFormat:@"%@", nsTitle];
}
@end
