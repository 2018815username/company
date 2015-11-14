
#import <Foundation/Foundation.h>

/**
 *    @author yinjp
 *
 *    @brief  黑色主题对应颜色配置文件
 */
static NSString* tztColorFontFileBlack  = @"tztColorFontFileBlack";
/**
 *    @author yinjp
 *
 *    @brief  白色主题对应颜色配置文件
 */
static NSString* tztColorFontFileWhite  = @"tztColorFontFileWhite";

/**
 *    @author yinjp
 *
 *    @brief  五档字体大小
 */
static NSString* tztHQWuDangFont     =        @"tztHQWuDangFont";

/**
 *    @author yinjp
 *
 *    @brief  通用view背景
 */
static NSString* tztViewBGColor       =       @"tztBackgroundColor";

/**
 *    @author yinjp
 *
 *    @brief  交易view背景
 */
static NSString* tztViewBGColorJY     =       @"tztBackgroundColorJY";

/**
 *    @author yinjp
 *
 *    @brief  行情view背景
 */
static NSString* tztViewBGColorHQ     =       @"tztBackgroundColorHQ";

/**
 *    @author yinjp
 *
 *    @brief  资讯view背景
 */
static NSString* tztViewBGColorZX     =       @"tztBackgroundColorZX";

/**
 *    @author yinjp
 *
 *    @brief  标题view背景
 */
static NSString* tztViewBGColorTitle  =       @"tztBackgroundColorTitle";

/**
 *    @author yinjp
 *
 *    @brief  个股详情标题view背景
 */
static NSString* tztViewBGColorTitle_Trend =  @"tztViewBGColorTitle_Trend";

static NSString* tztViewBGColorToolbar_Trend = @"tztViewBGColorToolbarTrend";
/**
 *    @author yinjp
 *
 *    @brief  输入框背景色
 */
static NSString* tztViewBGColorEdit   =       @"tztBackgroundColorEdit";

static NSString* tztViewBGColorSection  =     @"tztViewBGColorSection";
static NSString* tztViewBGColorSectionSel  =     @"tztViewBGColorSectionSel";
static NSString* tztViewBGColorTableJY  =     @"tztViewBGColorTableJY";
static NSString* tztViewBGColorTag      =     @"tztViewBGColorTag";
static NSString* tztViewBGColorToolbar  =     @"tztViewBGColorToolbar";
static NSString* tztViewBGColorHQBlock  =     @"tztViewBGColorHQBlock";

//字体颜色
static NSString* tztTextColorNormal     =     @"tztTextColorNormal";
static NSString* tztTextColorLabel      =     @"tztTextColorLabel";
static NSString* tztTextColorButton     =     @"tztTextColorButton";
static NSString* tztTextColorButtonSel  =     @"tztTextColorButtonSel";
static NSString* tztTextColorEditor     =     @"tztTextColorEditor";
static NSString* tztTextColorSection    =     @"tztTextColorSection";
static NSString* tztTextColorSectionSel =     @"tztTextColorSectionSel";
static NSString* tztTextColorTag        =     @"tztTextColorTag";
static NSString* tztTextColorTagSel     =     @"tztTextColorTagSel";
static NSString* tztTextColorReportTitle =    @"tztTextColorReportTitle";

//边框颜色
static NSString* tztBorderColor         =   @"tztBorderColor";
static NSString* tztBorderColorLabel    =   @"tztBorderColorLabel";
static NSString* tztBorderColorEditor   =   @"tztBorderColorEditor";
static NSString* tztBorderColorGrid     =   @"tztBorderColorGrid";

//分割线颜色
static NSString* tztGridColor           =   @"tztGridColor";

//行情相关颜色
static NSString* tztHQParamsColors      =   @"tztHQParamsColors";
static NSString* tztHQHideGridColor     =   @"tztHQHideGridColor";
static NSString* tztHQGridColor         =   @"tztHQGridColor";
static NSString* tztHQBalanceColor      =   @"tztHQBalanceColor";
static NSString* tztHQUpColor           =   @"tztHQUpColor";
static NSString* tztHQDownColor         =   @"tztHQDownColor";
static NSString* tztHQKLineUpColor      =   @"tztHQKLineUpColor";
static NSString* tztHQKLineDownColor    =   @"tztHQKLineDownColor";
static NSString* tztHQCursorColor       =   @"tztHQCursorColor";
static NSString* tztHQFixTextColor      =   @"tztHQFixTextColor";
static NSString* tztHQAxisTextColor     =   @"tztHQAxisTextColor";
static NSString* tztHQTipBackColor      =   @"tztHQTipBackColor";
static NSString* tztHQTitleBackColor    =   @"tztHQTitleBackColor";
static NSString* tztHQTitleUpColor      =   @"tztHQTitleUpColor";
static NSString* tztHQTitleDownColor    =   @"tztHQTItleDownColor";
static NSString* tztTableSelectColor    =   @"tztTableSelectColor";
static NSString* tztHQCursorBackColor   =   @"tztHQCursorBackColor";
static NSString* tztHQCursorTextColor   =   @"tztHQCursorTextColor";
static NSString* tztHQReportCellColor   =   @"tztHQReportCellColor";
static NSString* tztHQReportCellColorEx =   @"tztHQReportCellColorEx";
static NSString* tztHQFixYAxiColor      =   @"tztHQFixYAxiColor";
static NSString* tztJYReportCellColor   =   @"tztJYReportCellColor";
static NSString* tztJYReportCellColorEx =   @"tztJYReportCellColorEx";
static NSString* tztJYTitleBackColor    =   @"tztJYTitleBackColor";
static NSString* tztJYGridColor         =   @"tztJYGridColor";
static NSString* tztJYToolbarBgColor    =   @"tztJYToolbarBgColor";
static NSString* tztJYTableSelectColor  =   @"tztJYTableSelectColor";

static NSString* tztTrendLineColor      =   @"tztTrendLineColor";
static NSString* tztTrendGradientColor  =   @"tztTrendGradientColor";
static NSString* tztTrendGradientColorEx  =   @"tztTrendGradientColorEx";

@interface UIFont (tztThemeFont)
/**
 *	@brief	五档绘制字体
 *
 *	@return	字体
 */
+(UIFont*)tztThemeHQWudangFont;

@end

 /**
 *	@brief	颜色主题处理
 *
 *	@param
 *
 *	@return
 */
@interface UIColor (tztThemeColor)

 /**
 *	@brief	通用背景颜色
 *
 *	@return	配置后的颜色
 */
+(UIColor*)tztThemeBackgroundColor;

/**
 *	@brief	交易View背景色
 *
 *	@return	UIColor
 */
+(UIColor*)tztThemeBackgroundColorJY;

/**
 *	@brief	行情View背景色
 *
 *	@return	UIColor
 */
+(UIColor*)tztThemeBackgroundColorHQ;

/**
 *	@brief	资讯view背景色
 *
 *	@return	UIColor
 */
+(UIColor*)tztThemeBackgroundColorZX;

/**
 *	@brief	标题view背景色
 *
 *	@return	UIColor
 */
+(UIColor*)tztThemeBackgroundColorTitle;

+(UIColor*)tztThemeBackgroundColorToolBar;

/**
 *    @author yinjp
 *
 *    @brief  个股详情界面标题色
 *
 *    @return UIColor
 */
+(UIColor*)tztThemeBackgroundColorTitleTrend;

/**
 *    @author yinjp
 *
 *    @brief  个股详情界面工具条颜色
 *
 *    @return UIColor
 */
+(UIColor*)tztThemeBackgroundColorToolBarTrend;
/**
 *	@brief	编辑框背景色
 *
 *	@return	UIColor
 */
+(UIColor*)tztThemeBackgroundColorEditor;

/**
 *	@brief	表格section view的背景色
 *
 *	@return	UIColor
 */
+(UIColor*)tztThemeBackgroundColorSection;

/**
 *    @author yinjp
 *
 *    @brief  表格section view得选中背景色
 *
 *    @return UIColor
 */
+(UIColor*)tztThemeBackgroundColorSectionSel;

/**
 *	@brief	交易表格配置的背景色
 *
 *	@return	颜色
 */
+(UIColor*)tztThemeBackgroundColorTableJY;

/**
 *    @author yinjp
 *
 *    @brief  行情首页板块背景色
 *
 *    @return 颜色
 */
+(UIColor*)tztThemeBackgroundColorHQBlock;

/**
 *	@brief	表格section view字体颜色
 *
 *	@return	UIColor
 */
+(UIColor*)tztThemeTextColorForSection;

/**
 *    @author yinjp
 *
 *    @brief  表格section 选中字体色
 *
 *    @return UIColor
 */
+(UIColor*)tztThemeTextColorForSectionSel;

//=================字体颜色（通用）================
/**
 *	@brief	普通通用字体颜色
 *
 *	@return	UIColor
 */
+(UIColor*)tztThemeTextColorNormal;

/**
 *	@brief	Label字体颜色
 *
 *	@return	UIColor
 */
+(UIColor*)tztThemeTextColorLabel;

/**
 *	@brief	按钮字体颜色
 *
 *	@return	UIColor
 */
+(UIColor*)tztThemeTextColorButton;

/**
 *	@brief	选中时的button颜色
 *
 *	@return	UIColor
 */
+(UIColor*)tztThemeTextColorButtonSel;

/**
 *	@brief	编辑框输入文本颜色
 *
 *	@return	UIColor
 */
+(UIColor*)tztThemeTextColorEditor;

/**
 *    @author yinjp
 *
 *    @brief  tag标签字体颜色
 *
 *    @return UIColor
 */
+(UIColor*)tztThemeTextColorTag;

/**
 *    @author yinjp
 *
 *    @brief  tag标签字体选中颜色
 *
 *    @return UIColor
 */
+(UIColor*)tztThemeTextColorTagSel;

//=================边框颜色（通用）
/**
 *	@brief	通用view边框颜色
 *
 *	@return	UIColor
 */
+(UIColor*)tztThemeBorderColor;

/**
 *	@brief	文本Label边框色
 *
 *	@return	UIColor
 */
+(UIColor*)tztThemeBorderColorLabel;

/**
 *	@brief	编辑框边框色
 *
 *	@return	UIColor
 */
+(UIColor*)tztThemeBorderColorEditor;

/**
 *	@brief	通用分割线颜色
 *
 *	@return	UIColor
 */
+(UIColor*)tztThemeBorderColorGrid;

//分割线颜色string
+(NSString*)tztThemeGridColorString;
//根据主题统一增加后缀处理
-(NSString*)tztStringWithThemeSubFix:(NSString*)strName;

/**
 *	@brief	TagView的背景颜色（原则上是和标题颜色一致，考虑到后续可以通用，所以可以进行单独配置）
 *
 *	@return	UIColor
 */
+(UIColor*)tztThemeBackgroundColorTagView;






/*行情相关*/
/**
 *	@brief	参数颜色数组
 *
 *	@return	颜色数组
 */
+(NSArray*)tztThemeHQParamColors;
/**
 *	@brief	隐藏视图表格色
 *
 *	@return	UIColor
 */
+(UIColor*) tztThemeHQHideGridColor;

/**
 *	@brief	表格线颜色
 *
 *	@return	UIColor
 */
+(UIColor*) tztThemeHQGridColor;
/**
 *	@brief	相等颜色
 *
 *	@return	UIColor
 */
+(UIColor*) tztThemeHQBalanceColor;

/**
 *	@brief	上涨颜色
 *
 *	@return UIColor
 */
+(UIColor*) tztThemeHQUpColor;

/**
 *	@brief	下跌颜色
 *
 *	@return	UIColor
 */
+(UIColor*) tztThemeHQDownColor;

/**
 *	@brief	K线上涨颜色
 *
 *	@return	UIColor
 */
+(UIColor*) tztThemeHQKLineUpColor;

/**
 *	@brief	K线下跌颜色
 *
 *	@return	UIColor
 */
+(UIColor*) tztThemeHQKLineDownColor;

/**
 *	@brief	十字光标线颜色
 *
 *	@return	UIColor
 */
+(UIColor*) tztThemeHQCursorColor;

/**
 *	@brief	行情固定字体颜色
 *
 *	@return	UIColor
 */
+(UIColor*) tztThemeHQFixTextColor;

/**
 *	@brief	坐标字颜色
 *
 *	@return	UIColor
 */
+(UIColor*) tztThemeHQAxisTextColor;

/**
 *	@brief	提示框底色
 *
 *	@return	UIColor
 */
+(UIColor*) tztThemeHQTipBackColor;

/**
 *	@brief	行情表格头背景色
 *
 *	@return	UIColor
 */
+(UIColor*) tztThemeHQTitleBackColor;

+(UIColor*) tztThemeHQTitleUpColor;

+(UIColor*) tztThemeHQTitleDownColor;

/**
 *	@brief	行情表格选中色
 *
 *	@return	UIColor
 */
+(UIColor*)tztThemeHQTableSelectColor;

/**
 *	@brief	分时、k线时，光标绘制，跟随光标的价格和下面的时间背景色
 *
 *	@return	UIColor
 */
+(UIColor*)tztThemeHQCursorBackColor;
/**
 *    @author yinjp
 *
 *    @brief  分时、k线时，光标绘制，跟随光标的价格和下面的时间文字色
 *
 *    @return UIColor
 */
+(UIColor*)tztThemeHQCursorTextColor;

/**
 *	@brief	行情表格背景色
 *
 *	@return
 */
+(UIColor*)tztThemeHQReportCellColor;

/**
 *	@brief	行情表格背景色2
 *
 *	@return
 */
+(UIColor*)tztThemeHQReportCellColorEx;

/**
 *    @author yinjp
 *
 *    @brief  分时、k线固定坐标文字颜色，不使用得话，使用默认得行情颜色
 *
 *    @return UIColor
 */
+(UIColor*)tztThemeHQFixYAxiColor;

+(UIColor*)tztThemeTrendLineColor;
+(UIColor*)tztThemeTrendGradientColor;
+(UIColor*)tztThemeTrendGradientColorEx;

/**
 *    @author yinjp
 *
 *    @brief  交易表格cell背景色
 *
 *    @return UIColor
 */
+(UIColor*)tztThemeJYReportCellColor;

/**
 *    @author yinjp
 *
 *    @brief  交易表格cell背景色2
 *
 *    @return UIColor
 */
+(UIColor*)tztThemeJYReportCellColorEx;

/**
 *    @author yinjp
 *
 *    @brief  交易表格分割线
 *
 *    @return UIColor
 */
+(UIColor*)tztThemeJYGridColor;
/**
 *    @author yinjp
 *
 *    @brief  交易表头颜色
 *
 *    @return UIColor
 */
+(UIColor*)tztThemeJYTitleBackColor;
+(UIColor*)tztThemeJYToolbarBgColor;

+(UIColor*)tztJYTableSelectColor;

@end
