//
//  NSObject+UIColor_TZTColor.m
//  tztControl
//
//  Created by King on 15-1-19.
//  Copyright (c) 2015年 tzt. All rights reserved.
//


#import "UIColor_TZTColor.h"

/**
 *	@brief	颜色，字体管理类
 */
@interface tztColorFontManager : NSObject

@property(nonatomic,retain)NSMutableDictionary *dictData;
@property(nonatomic,retain)NSMutableDictionary *dictData1;
+(tztColorFontManager*)getShareInstance;
+(id)tztValueForKey:(NSString*)key;

@end

@implementation tztColorFontManager
@synthesize dictData = _dictData;
@synthesize dictData1 = _dictData1;

+(tztColorFontManager*)getShareInstance
{
    static dispatch_once_t once;
    static tztColorFontManager *sharedView;
    dispatch_once(&once, ^{ sharedView = [[tztColorFontManager alloc] init];
    });
    return sharedView;
}

-(id)init
{
    if (self = [super init])
    {
        [self LoadInitData];
    }
    return self;
}

-(void)LoadInitData
{
    NSString* strFileBlack = GetTztBundlePlistPath(tztColorFontFileBlack);
    self.dictData = [[NSMutableDictionary alloc] initWithContentsOfFile:strFileBlack];
    
    NSString* strFileWhite = GetTztBundlePlistPath(tztColorFontFileWhite);
    self.dictData1 = [[NSMutableDictionary alloc] initWithContentsOfFile:strFileWhite];
    
}

+(id)tztValueForKey:(NSString *)key
{
    if (key == nil || key.length <= 0)
        return nil;
    
    if (g_nSkinType ==1 || g_nSkinType == 2)
    {
        return [[tztColorFontManager getShareInstance].dictData1 objectForKey:key];
    }
    else
        return [[tztColorFontManager getShareInstance].dictData objectForKey:key];
}

+(UIColor*)tztColorWithKey:(NSString*)key andDefault:(NSString*)nsDefaultBlack defaultWihte:(NSString*)nsDefaultWhite
{
    NSString* str = [tztColorFontManager tztValueForKey:key];
    if (str.length <= 0)
    {
        if (g_nSkinType == 1 || g_nSkinType == 2)
        {
            return [UIColor colorWithTztRGBStr:nsDefaultWhite];
        }
        else
            return [UIColor colorWithTztRGBStr:nsDefaultBlack];
    }
    else
        return [UIColor colorWithTztRGBStr:str];
}

@end


@implementation UIFont (tztThemeFont)
+(UIFont*)tztThemeHQWudangFont
{
    int nFontSize = 0;
    
    nFontSize = [[tztColorFontManager tztValueForKey:tztHQWuDangFont] intValue];
    if (nFontSize <= 0 )
        return [tztTechSetting getInstance].drawTxtFont;
    
    return tztUIBaseViewTextFont(nFontSize);
}
@end

@implementation UIColor (tztThemeColor)

/*
 g_nSkinType
 0-黑色主题
 1－蓝色主题
 2-红色主题
 */

/*!
 颜色先根据当前主题进行判断，然后读取对应配置文件，若文件中不存在，则使用固定颜色
 */

+(UIColor*)tztThemeBackgroundColor
{
    return [tztColorFontManager tztColorWithKey:tztViewBGColor
                                     andDefault:@"48,48,48"
                                   defaultWihte:@"249,249,249"];
}

+(UIColor*)tztThemeBackgroundColorHQ
{
    return [tztColorFontManager tztColorWithKey:tztViewBGColorHQ
                                     andDefault:@"48,48,48"
                                   defaultWihte:@"249,249,249"];
}

+(UIColor*)tztThemeBackgroundColorJY
{
    return [tztColorFontManager tztColorWithKey:tztViewBGColorJY
                                     andDefault:@"48,48,48"
                                   defaultWihte:@"249,249,249"];
}

+(UIColor*)tztThemeBackgroundColorZX
{
    return [tztColorFontManager tztColorWithKey:tztViewBGColorZX
                                     andDefault:@"48,48,48"
                                   defaultWihte:@"249,249,249"];
}

+(UIColor*)tztThemeBackgroundColorTitle
{
    UIImage *image = nil;
    if (IS_TZTIOS(7))
    {
        image = [UIImage imageTztNamed:@"TZTnavbarbg.png"];
    }
    else
    {
        image = [UIImage imageTztNamed:@"TZTnavbarbg_Old@2x.png"];
    }
    if (image != NULL)
        return [UIColor colorWithPatternImage:image];
    
    return [tztColorFontManager tztColorWithKey:tztViewBGColorTitle
                                     andDefault:@"34,35,36"
                                   defaultWihte:@"35,38,52"];
}

+(UIColor*)tztThemeBackgroundColorTitleTrend
{
    NSString* str = [tztColorFontManager tztValueForKey:tztViewBGColorTitle_Trend];
    if (str.length <= 0)
        return [UIColor tztThemeBackgroundColorTitle];
    return [tztColorFontManager tztColorWithKey:tztViewBGColorTitle_Trend
                                     andDefault:@"34,35,36"
                                   defaultWihte:@"35,38,52"];
}

+(UIColor*)tztThemeBackgroundColorToolBarTrend
{
    NSString* str = [tztColorFontManager tztValueForKey:tztViewBGColorToolbar_Trend];
    if (str.length <= 0)
        return [UIColor tztThemeBackgroundColorTitleTrend];
    return [tztColorFontManager tztColorWithKey:tztViewBGColorToolbar_Trend
                                     andDefault:@"34,35,36"
                                   defaultWihte:@"35,38,52"];
}

+(UIColor*)tztThemeBackgroundColorToolBar
{
    UIImage *image = nil;
    image = [UIImage imageTztNamed:@"TZTTabBarBG.png"];
    if (image != NULL)
        return [UIColor colorWithPatternImage:image];
    
    return [tztColorFontManager tztColorWithKey:tztViewBGColorToolbar
                                     andDefault:@"34,35,36"
                                   defaultWihte:@"35,38,52"];
}

+(UIColor*)tztThemeBackgroundColorEditor
{
    return [tztColorFontManager tztColorWithKey:tztViewBGColorEdit
                                     andDefault:@"255,255,255"
                                   defaultWihte:@"255,255,255"];
}

+(UIColor*)tztThemeBackgroundColorTableJY
{
    return [tztColorFontManager tztColorWithKey:tztViewBGColorTableJY
                                     andDefault:@"14,16,20"
                                   defaultWihte:@"249,249,249"];
}

+(UIColor*)tztThemeBackgroundColorHQBlock
{
    return [tztColorFontManager tztColorWithKey:tztViewBGColorHQBlock
                                     andDefault:@"48,48,48"
                                   defaultWihte:@"249,249,249"];
}

+(UIColor*)tztThemeBackgroundColorSection
{
    return [tztColorFontManager tztColorWithKey:tztViewBGColorSection
                                     andDefault:@"41,41,41"
                                   defaultWihte:@"241,241,241"];
}

+(UIColor*)tztThemeBackgroundColorSectionSel
{
    return [tztColorFontManager tztColorWithKey:tztViewBGColorSectionSel
                                     andDefault:@"60,60,60"
                                   defaultWihte:@"245,245,245"];
}

+(UIColor*)tztThemeTextColorForSection
{
    return [tztColorFontManager tztColorWithKey:tztTextColorSection
                                     andDefault:@"220,220,220"
                                   defaultWihte:@"41,41,41"];
}

+(UIColor*)tztThemeTextColorForSectionSel
{
    return [tztColorFontManager tztColorWithKey:tztTextColorSectionSel
                                     andDefault:@"220,220,220"
                                   defaultWihte:@"0,140,220"];
}

+(UIColor*)tztThemeTextColorNormal
{
    return [tztColorFontManager tztColorWithKey:tztTextColorNormal
                                     andDefault:@"255,255,255"
                                   defaultWihte:@"0,0,0"];
}

+(UIColor*)tztThemeTextColorLabel
{
    return [tztColorFontManager tztColorWithKey:tztTextColorLabel
                                     andDefault:@"255,255,255"
                                   defaultWihte:@"34,34,34"];
}

+(UIColor*)tztThemeTextColorReportTitle
{
    return [tztColorFontManager tztColorWithKey:tztTextColorReportTitle
                                     andDefault:@"34,34,34"
                                   defaultWihte:@"255,255,255"];
}

+(UIColor*)tztThemeTextColorButton
{
    return [tztColorFontManager tztColorWithKey:tztTextColorButton
                                     andDefault:@"255,255,255"
                                   defaultWihte:@"81,81,81"];
}

+(UIColor*)tztThemeTextColorButtonSel
{
    return [tztColorFontManager tztColorWithKey:tztTextColorButtonSel
                                     andDefault:@"56,117,197"
                                   defaultWihte:@"0,0,0"];
}

+(UIColor*)tztThemeTextColorEditor
{
    return [tztColorFontManager tztColorWithKey:tztTextColorEditor
                                     andDefault:@"0,0,0"
                                   defaultWihte:@"0,0,0"];
}

+(UIColor*)tztThemeTextColorTag
{
    return [tztColorFontManager tztColorWithKey:tztTextColorTag
                                     andDefault:@"255,255,255"
                                   defaultWihte:@"81,81,81"];
}

+(UIColor*)tztThemeTextColorTagSel
{
    return [tztColorFontManager tztColorWithKey:tztTextColorTagSel
                                     andDefault:@"255,255,255"
                                   defaultWihte:@"81,81,81"];
}

////view边框
+(UIColor*)tztThemeBorderColor
{
    return [tztColorFontManager tztColorWithKey:tztBorderColor
                                     andDefault:@"48,48,48"
                                   defaultWihte:@"232,232,232"];
}

+(UIColor*)tztThemeBorderColorLabel
{
    return [tztColorFontManager tztColorWithKey:tztBorderColorLabel
                                     andDefault:@"48,48,48"
                                   defaultWihte:@"232,232,232"];
}

+(UIColor*)tztThemeBorderColorEditor
{
    return [tztColorFontManager tztColorWithKey:tztBorderColorEditor
                                     andDefault:@"48,48,48"
                                   defaultWihte:@"232,232,232"];
}

+(UIColor*)tztThemeBorderColorGrid
{
    return [tztColorFontManager tztColorWithKey:tztBorderColorGrid
                                     andDefault:@"43,43,43"
                                   defaultWihte:@"204,204,204"];
}

//分割线颜色string
+(NSString*)tztThemeGridColorString
{
    NSString* str = [tztColorFontManager tztValueForKey:tztGridColor];
    if (str.length > 0)
        return str;
    if((g_nSkinType==1) || (g_nSkinType==2))
    {
        return @"242,242,242";
    }
    else
    {
        return @"43,43,43";
    }
}
//
//根据主题统一增加后缀处理
-(NSString*)tztStringWithThemeSubFix:(NSString*)strName
{
    return nil;
}

+(UIColor*)tztThemeBackgroundColorTagView
{
    return [tztColorFontManager tztColorWithKey:tztViewBGColorTag
                                     andDefault:@"34,35,36"
                                   defaultWihte:@"46,52,67"];
}

//==========行情颜色处理===================
+(NSArray*)tztThemeHQParamColors
{
    NSArray *ay = [tztColorFontManager tztValueForKey:tztHQParamsColors];
    if (ay.count > 0)
    {
        NSMutableArray *ayColors = [[NSMutableArray alloc] init];
        for (NSString* strData in ay)
        {
            [ayColors addObject:[UIColor colorWithTztRGBStr:strData]];
        }
        return [ayColors autorelease];
    }
    else
    {
#ifdef tztCanChangeHQColor
        if (g_nSkinType >= 1)
        {
            NSMutableArray *ayColors = [[NSMutableArray alloc] init];
            [ayColors addObject:[UIColor colorWithTztRGBStr:@"255,180,21"]];
            [ayColors addObject:[UIColor colorWithTztRGBStr:@"248,136,166"]];
            [ayColors addObject:[UIColor colorWithTztRGBStr:@"76,208,247"]];
            [ayColors addObject:[UIColor colorWithRGBULong:0x00FF00]];
            [ayColors addObject:[UIColor colorWithRGBULong:0x0000FF]];
            [ayColors addObject:[UIColor colorWithRGBULong:0xFF8400]];
            [ayColors addObject:[UIColor colorWithRGBULong:0x00E600]];
            return [ayColors autorelease];
        }
        else
#endif
            return [tztTechSetting getInstance].ayParamColors;
    }
}
//隐藏表格线色
+(UIColor*)tztThemeHQHideGridColor
{
    return [tztColorFontManager tztColorWithKey:tztHQHideGridColor
                                     andDefault:@"96,96,96"
                                   defaultWihte:@"220,220,220"];
}

//表格线颜色
+(UIColor*)tztThemeHQGridColor
{
    return [tztColorFontManager tztColorWithKey:tztHQGridColor
                                     andDefault:@"43,43,43"
                                   defaultWihte:@"220,220,220"];
}

//相等颜色
+(UIColor*)tztThemeHQBalanceColor
{
    return [tztColorFontManager tztColorWithKey:tztHQBalanceColor
                                     andDefault:@"255,255,255"
                                   defaultWihte:@"0,0,0"];
}

//上涨颜色
+(UIColor*)tztThemeHQUpColor
{
    return [tztColorFontManager tztColorWithKey:tztHQUpColor
                                     andDefault:@"255,0,0"
                                   defaultWihte:@"255,54,49"];
}

//下跌颜色
+(UIColor*)tztThemeHQDownColor
{
    return [tztColorFontManager tztColorWithKey:tztHQDownColor
                                     andDefault:@"0,255,0"
                                   defaultWihte:@"75,179,40"];
}

//k线上涨颜色
+(UIColor*)tztThemeHQKLineUpColor
{
    return [tztColorFontManager tztColorWithKey:tztHQKLineUpColor
                                     andDefault:@"255,60,60"
                                   defaultWihte:@"255,54,49"];
}

//k线下跌颜色
+(UIColor*)tztThemeHQKLineDownColor
{
    return [tztColorFontManager tztColorWithKey:tztHQKLineDownColor
                                     andDefault:@"0,228,255"
                                   defaultWihte:@"75,179,40"];
}

//十字光标色
+(UIColor*)tztThemeHQCursorColor
{
    return [tztColorFontManager tztColorWithKey:tztHQCursorColor
                                     andDefault:@"255,255,255"
                                   defaultWihte:@"85,85,85"];
}

//行情固定字体颜色
+(UIColor*)tztThemeHQFixTextColor
{
    return [tztColorFontManager tztColorWithKey:tztHQFixTextColor
                                     andDefault:@"204,204,204"
                                   defaultWihte:@"85,85,85"];
}

//坐标字体颜色
+(UIColor*)tztThemeHQAxisTextColor
{
    return [tztColorFontManager tztColorWithKey:tztHQAxisTextColor
                                     andDefault:@"255,255,0"
                                   defaultWihte:@"85,85,85"];
}

//提示框底色
+(UIColor*)tztThemeHQTipBackColor
{
    return [tztColorFontManager tztColorWithKey:tztHQTipBackColor
                                     andDefault:@"0,0,0"
                                   defaultWihte:@"241,241,241"];
}

+(UIColor*)tztThemeHQTitleBackColor
{
    return [tztColorFontManager tztColorWithKey:tztHQTitleBackColor
                                     andDefault:@"41,41,41"
                                   defaultWihte:@"241,241,241"];
}

+(UIColor*) tztThemeHQTitleUpColor
{
    NSString* str = [tztColorFontManager tztValueForKey:tztHQTitleUpColor];
    if (str.length < 1)
        return nil;
    return [UIColor colorWithTztRGBStr:str];
    
}

+(UIColor*) tztThemeHQTitleDownColor
{
    NSString* str = [tztColorFontManager tztValueForKey:tztHQTitleDownColor];
    if (str.length < 1)
        return nil;
    return [UIColor colorWithTztRGBStr:str];
}


+(UIColor*)tztThemeHQTableSelectColor
{
    return [tztColorFontManager tztColorWithKey:tztTableSelectColor
                                     andDefault:@"56,56,56"
                                   defaultWihte:@"215,215,215"];
}

+(UIColor*)tztThemeHQCursorBackColor
{
    
    return [tztColorFontManager tztColorWithKey:tztHQCursorBackColor
                                     andDefault:@"48,48,48"
                                   defaultWihte:@"35,120,220"];
}

+(UIColor*)tztThemeHQCursorTextColor
{
    return [tztColorFontManager tztColorWithKey:tztHQCursorTextColor
                                     andDefault:@"255,255,0"
                                   defaultWihte:@"255,255,255"];
}

+(UIColor*)tztThemeHQReportCellColor
{
    return [tztColorFontManager tztColorWithKey:tztHQReportCellColor
                                     andDefault:@"48,48,48"
                                   defaultWihte:@"255,255,255"];
}

+(UIColor*)tztThemeHQReportCellColorEx
{
    return [tztColorFontManager tztColorWithKey:tztHQReportCellColorEx
                                     andDefault:@"44,44,44"
                                   defaultWihte:@"249,249,249"];
}

+(UIColor*)tztThemeHQFixYAxiColor
{
    NSString* str = [tztColorFontManager tztValueForKey:tztHQFixYAxiColor];
    if (str.length < 1)
        return nil;
    return [UIColor colorWithTztRGBStr:str];
}

+(UIColor*)tztThemeTrendLineColor
{
    NSString* str = [tztColorFontManager tztValueForKey:tztTrendLineColor];
    if (str.length < 1)
        return nil;
    return [UIColor colorWithTztRGBStr:str];
}

+(UIColor*)tztThemeTrendGradientColor
{
    NSString* str = [tztColorFontManager tztValueForKey:tztTrendGradientColor];
    if (str.length < 1)
        return nil;
    return [UIColor colorWithTztRGBStr:str];
}

+(UIColor*)tztThemeTrendGradientColorEx
{
    NSString* str = [tztColorFontManager tztValueForKey:tztTrendGradientColorEx];
    if (str.length < 1)
        return nil;
    return [UIColor colorWithTztRGBStr:str];
}

+(UIColor*)tztThemeJYReportCellColor
{
    return [tztColorFontManager tztColorWithKey:tztJYReportCellColor
                                     andDefault:@"48,48,48"
                                   defaultWihte:@"255,255,255"];
    
}

+(UIColor*)tztThemeJYReportCellColorEx
{
    return [tztColorFontManager tztColorWithKey:tztJYReportCellColorEx
                                     andDefault:@"46,46,46"
                                   defaultWihte:@"249,249,249"];
    
}

+(UIColor*)tztThemeJYGridColor
{
    return [tztColorFontManager tztColorWithKey:tztJYGridColor
                                     andDefault:@"43,43,43"
                                   defaultWihte:@"220,220,220"];
}

+(UIColor*)tztThemeJYToolbarBgColor
{
    return [tztColorFontManager tztColorWithKey:tztJYToolbarBgColor
                                     andDefault:@"58,58,58"
                                   defaultWihte:@"157,157,157"];
}

+(UIColor*)tztThemeJYTitleBackColor
{
    return [tztColorFontManager tztColorWithKey:tztJYTitleBackColor
                                     andDefault:@"41,41,41"
                                   defaultWihte:@"220,220,220"];
}

+(UIColor*)tztJYTableSelectColor
{
    return [tztColorFontManager tztColorWithKey:tztJYTableSelectColor
                                     andDefault:@"56,56,56"
                                   defaultWihte:@"215,215,215"];
}
@end
