//
//  TZTTabBarProfile.m
//  IPAD-Table
//
//  Created by zz tzt on 12-4-18.
//  Copyright 2012 杭州中焯信息技术有限公司. All rights reserved.
//

#import "TZTTabBarProfile.h"
#import "TZTSystermConfig.h"
#import "TZTPageInfoItem.h"  

TZTTabBarProfile    *g_pTZTTabBarProfile = NULL;

@implementation TZTTabBarProfile
//tabBar项列表，包含顺序
@synthesize ayTabBarItem = _ayTabBarItem;

//不显示配置名称，由图片提供
@synthesize nDrawName = _nDrawName; 
@synthesize nDrawNameColor = _nDrawNameColor;
@synthesize nDrawNameColorSel = _nDrawNameColorSel;

//是否启用自动页面展示，显示不下的图标自动归集到列表中供用户选择
@synthesize nAutoLayout = _nAutoLayout;

//最大显示页面Item个数，默认-1不控制。
@synthesize nMaxDisplay = _nMaxDisplay;

//Item高亮图片名称
@synthesize imgHight = _imgHight;

//是否支持滑动
@synthesize nHandleMove = _nHandleMove;

//固定宽度绘制图片
@synthesize nFixedIconWidth = _nFixedIconWidth;

//图片绘制风格：0 居中；1 置顶；2 沉底；
@synthesize nDrawIconStyle = _nDrawIconStyle;
@synthesize nDrawSelectedStyle = _nDrawSelectedStyle;
@synthesize nDrawMiddleLine = _nDrawMiddleLine;

//两头留白
@synthesize nMarginHead = _nMarginHead;
@synthesize nMarginTail = _nMarginTail;

//两头留白竖屏方式
@synthesize nMarginHeadEx = _nMarginHeadEx;
@synthesize nMarginTailEx = _nMarginTailEx;
@synthesize nSeperator = _nSeperator;
@synthesize nSeperatorColor = _nSeperatorColor;

-(void) dealloc
{
    if (self.ayTabBarItem)
    {
        [self.ayTabBarItem removeAllObjects];
    }
    self.ayTabBarItem = NULL;
    self.imgHight = NULL;
    
    [super dealloc];
}

-(void) DefaultValue
{
    //tabBar项列表，包含顺序
    //m_ayTabBarItem;
    
    //不显示配置名称，由图片提供
    _nDrawName = 0;
    _nDrawNameColor = -1;
    _nDrawNameColorSel = -1;
    
    //是否启用自动页面展示，显示不下的图标自动归集到列表中供用户选择
    _nAutoLayout = 0;
    
    //最大显示页面Item个数，默认-1不控制。
    _nMaxDisplay = -1;
    
    //Item高亮图片名称
    //m_imgHight;
    
    //是否支持滑动
    _nHandleMove = 0;
    
    //固定宽度绘制图片
    _nFixedIconWidth = 0;
    
    //图片绘制风格：0 居中；1 置顶；2 沉底；
    _nDrawIconStyle = 0;
    _nDrawSelectedStyle = 0;
    _nDrawMiddleLine = 0;
    
    //两头留白
    _nMarginHead = 0;
    _nMarginTail = 0;
    
    //两头留白竖屏方式
    _nMarginHeadEx = 0;
    _nMarginTailEx = 0;
    
    _nSeperator = 0;
    _nSeperatorColor = 0;
}

-(BOOL) HaveTabBarItem
{
	if (self.ayTabBarItem == NULL || [self.ayTabBarItem count] < 1)
	{
		return FALSE;
	}
	return TRUE;
}

-(void) LoadTabBarItem
{
	if (_ayTabBarItem == NULL)
	{
		self.ayTabBarItem = NewObjectAutoD(NSMutableArray);
	}
	self.imgHight = NULL;
    
    if (self.ayTabBarItem)
    {
        [self.ayTabBarItem removeAllObjects];
    }
	
	[self DefaultValue];
	if (g_pSystermConfig == NULL)
		return;
	
    NSString* strName = @"";
    
    if (g_nSkinType == 0) {
        strName = @"tztTabBarProfile";
    }
    else if (g_nSkinType == 1) {
        strName = @"tztTabBarProfileForWhite";
    }
    
#ifdef tzt_ForAjaxDemo
    strName = @"tztTabBarProfile_ajax";
#endif
    
    NSMutableDictionary * dictconf = GetDictByListName(strName);
    if (dictconf == NULL)
        return;
    NSMutableArray *ayItem = [dictconf objectForKey:@"tztToolbar"];
    if (ayItem == NULL || [ayItem count] < 1)
        return;
    
    //读取上次保存的最新的状态数据
    NSString *strFilePath = [tztTabbarStatusFile tztHttpfilepath];
    NSDictionary *pDict = [NSDictionary dictionaryWithContentsOfFile:strFilePath];
    
    for (int i = 0; i < [ayItem count]; i++)
    {
        NSMutableDictionary* pSubDict = [ayItem objectAtIndex:i];
        if (pSubDict == NULL)
            continue;
        NSString* ns = [pSubDict objectForKey:@"tztToolbarItem"];
        TZTPageInfoItem *pPageItem = [TZTPageInfoItem CreateByString:ns];
        if (pPageItem)
        {
            //
            NSString *strKey = [NSString stringWithFormat:@"tab%d", (i+1)];
            NSString *strValue = [pDict objectForKey:strKey];
            pPageItem.nStatus = [strValue intValue];
            [_ayTabBarItem addObject:pPageItem];
        }
    }
    
    _nDrawName = [[dictconf objectForKey:@"DrawName"] intValue];
    _nDrawNameColor = [[dictconf objectForKey:@"DrawNameColor"] intValue];
    _nDrawNameColorSel = [[dictconf objectForKey:@"DrawNameColorSel"] intValue];
    _nAutoLayout = [[dictconf objectForKey:@"AutoLayout"] intValue];
    _nMaxDisplay = [[dictconf objectForKey:@"MaxDisplay"] intValue];
    
    _nSeperator = [[dictconf objectForKey:@"ShowSeperator"] intValue];
    NSString* strColor = [dictconf objectForKey:@"SeperatorColor"];
    if (strColor && strColor.length > 0)
    {
       UIColor *pColor = [UIColor colorWithTztRGBStr:strColor];
        _nSeperatorColor = [pColor colorToRGBULong];
    }
    
    NSString* str = [dictconf objectForKey:@"HightImage"];
    if (str && [str length] > 0)
    {
        self.imgHight = [UIImage imageTztNamed:str];
    }
    
    _nHandleMove = [[dictconf objectForKey:@"HandleMove"] intValue];
    _nFixedIconWidth = [[dictconf objectForKey:@"FixedIconWidth"] intValue];
    _nDrawIconStyle = [[dictconf objectForKey:@"DrawIconStyle"] intValue];
    _nDrawSelectedStyle = [[dictconf objectForKey:@"DrawSelectedStyle"] intValue];
    _nDrawMiddleLine = [[dictconf objectForKey:@"DrawMiddleLine"] intValue];
    _nMarginHead = [[dictconf objectForKey:@"MarginHead"] intValue];
    _nMarginTail = [[dictconf objectForKey:@"MarginTail"] intValue];
    _nMarginHeadEx = [[dictconf objectForKey:@"MarginHeadEx"] intValue];
    _nMarginTailEx = [[dictconf objectForKey:@"MarginTailEx"] intValue];
}

//根据配置的名称获取对应的索引，用于跳转
-(int)GetTabItemIndexByName:(NSString*)nsName
{
    int nReturn = -1;
    for ( int i = 0; i < [self.ayTabBarItem count]; i++)
    {
        TZTPageInfoItem* pItem = [self.ayTabBarItem objectAtIndex:i];
        if (pItem == NULL || pItem.nsPageName == NULL)
            continue;
        nsName = [nsName uppercaseString];
        NSString* nsPageName = [pItem.nsPageName uppercaseString];
        if ([nsName compare:nsPageName] == NSOrderedSame)
        {
            nReturn = i;
            break;
        }
    }
    return nReturn;
}

//根据配置的ID获取对应的索引，用于跳转
-(int)GetTabItemIndexByID:(unsigned int)nsID
{
    int nReturn = -1;
    for ( int i = 0; i < [self.ayTabBarItem count]; i++)
    {
        TZTPageInfoItem* pItem = [self.ayTabBarItem objectAtIndex:i];
        if (pItem == NULL || pItem.nsPageName == NULL)
            continue;
        
        unsigned int pageID = pItem.nPageID ;
        if (nsID == pageID)
        {
            nReturn = i;
            break;
        }
    }
    return nReturn;
}

@end
