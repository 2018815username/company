/*******************************************************************************
 * Copyright (c)2012, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称：tztStockType.h
 * 文件标识：
 * 摘    要：行情市场分类
 *
 * 当前版本：
 * 作    者：yangdl
 * 完成日期：2012.12.12
 *
 * 备    注：
 *
 * 修改记录：
 * 
 *******************************************************************************/

#ifndef tztMobileApp_tztStockType_h
#define tztMobileApp_tztStockType_h

#define SH_KIND_INDEX 16 //国内股票-上证证券: 上证指数16	$1100, 	上证指数
#define SH_KIND_STOCKA 17 //上证A股17,	$1101, 	上证Ａ股
#define SH_KIND_STOCKB 18 //上证B股18	$1102, 	上证Ｂ股
#define SH_KIND_BOND 19 //上证债券19	$1103,	上证债券

#define SH_KIND_FUND 20 //沪基金20	$1104,	上证基金
#define SH_KIND_QuanZhen 21 //沪权证21	$110A,	上证权证
#define SH_KIND_SMALLSTOCK 22 //沪中小盘股22	$1106,	
#define SH_KIND_OPENFUND 23 //沪开放式基金23	$1104,	上证基金
#define SH_KIND_LOF 24 //沪LOF24	$110D,	
#define SH_KIND_ETF 25 //沪ETF25	$1109,	上证ETF
#define SH_KIND_THREEBOAD 26 //沪三板26	$1105,	
#define SH_KIND_TUISHI 27 // //沪退市整理板	$110C,	


#define SZ_KIND_INDEX 32 //国内股票-深证证券：深证指数32	$1200, 	深证指数
#define SZ_KIND_STOCKA 33 //深证A股33	$1201,	深证Ａ股
#define SZ_KIND_STOCKB 34 //深证B股34	$1202,	深证Ｂ股
#define SZ_KIND_BOND 35 //深证债券35	$1203,	深证债券

#define SZ_KIND_FUND 36 //深基金36	$1204,	深证基金
#define SZ_KIND_QuanZhen 37 //深三板37 李烁权20060608权证放在这里	$120A,	深证权证
#define SZ_KIND_SMALLSTOCK 38 //深中小板38 李烁权中小企业版三板	$1206,	中小盘股
#define SZ_KIND_OPENFUND 39 //深开放式基金39	$1204,	深证基金
#define SZ_KIND_LOF 40 //深LOF40	$120D,	lofs
#define SZ_KIND_ETF 41 //深ETF41	$1209,	深证ETF
#define SZ_KIND_THREEBOAD 42 //深三板42	$1205,	三板
#define SZ_KIND_TUISHI 43 // //深退市整理板	$120C	
#define SZ_KIND_CYBLOCK 42 // //(深证)创业板42	$120B,	创业板


#define BLOCK_INDEX_HY 51 // //板块指数-行业	$4661,	
#define BLOCK_INDEX_GN 52  //板块指数-概念	$4662,	

#define HS_KIND_STOCKA 210 //沪深A股210	$1101,	上证Ａ股
#define HS_KIND_STOCKB 211 //沪深B股211	$1102,	上证Ｂ股

#define QH_FUTURES_MARKET 70 //期货开始

#define QH_DL_BOURSE 71 //期货：大连期货71	$4100,	大连其他
#define QH_SH_BOURSE 72 //上海期货72	$4200,	上海其他
#define QH_ZZ_BOURSE 73 //郑州期货73	$4300,	郑州其他
#define QH_GZ_BOURSE 75 //股指期货75	$4500,	

#define QH_SELF_BOURSE 76 // //期货-自定义76	$4600,	
#define QH_YSJS_BOURSE 77 // //期货-有色金属77,	$4630,	
#define QH_GL_OutFund 78 // //国联-开放式基金78	$4650,	开放式基金

#define WH_FOREIGN_MARKET 80 //外汇开始

#define WH_BASE_RATE 81 //外汇：基本汇率81	$8100,	基本汇率
#define WH_ACROSS_RATE 82 //交叉汇率82	$8200,	交叉汇率
#define WH_FUTURES_RATE 83 //期汇83	$8300,	期汇

/*外盘大类*/
#define WP_MARKET 90 //外盘开始
#define WP_INDEX 90 //国际指数90	$5100,	
#define WP_LME 91 //外盘: LME91	$5200,	
#define WP_CBOT 92 //CBOT92	$5300,	CBOT
#define WP_NYMEX 93 //NYMEX93 	$5400,	原油
#define WP_COMEX 94 //COMEX94	$5500,	COMEX
#define WP_TOCOM 95 //TOCOM95	$5600,	TOCOM
#define WP_IPE 96 //IPE96,	$5700,	IPE
#define WP_NYBOT 97 //NYBOT97	$5800,	NYBOT
#define WP_NOBLE_METAL 98 //NOBLE_METAL98	$5900,	贵金属
#define WP_SICOM 99 //SICOM99 	$5B00,	SICOM
#define WP_NOBLE_METAL_HJ 100 //外盘-黄金期货-贵金属100	$5F14,	

#define HK_MARKET 110 //港股开始
#define HK_KIND_BOND 110 //港股-债券110	$2100,	债券
#define HK_GE_BOURSE 111 //港股-创业版（所有）111	$2200,	创业板
#define HK_INDEX_BOURSE 112 //港股-指数（所有）112 	$2300,	港股期指

#define USERSTOCK_BOURSE 0 //自选股0?  李烁权用于标识自选股 	$0800,	

#define HK_KIND_MulFund 110 //港股主板市场小类，没用	$2101,	一揽子认股证
#define HK_KIND_FUND 110	//$2102,	基金
#define HK_KIND_WARRANTS 110 //	$2103,	认股证
#define HK_KIND_JR 110 //	$2104,	金融
#define HK_KIND_ZH 110 //	$2105,	综合
#define HK_KIND_DC 110 //	$2106,	地产
#define HK_KIND_LY 110 //	$2107,	旅游
#define HK_KIND_GY 110 //	$2108,	工业
#define HK_KIND_GG 110 //	$2109,	公用
#define HK_KIND_QT 110 //	$210A,	其它
#define HK_BOURSE 110// //Start:65  //港股-主版（所有）牛熊权证110($210B), ,,,,基金112($2302)	$210B,	牛熊权证

//#define  110 // 	$210C,	
//#define  110 // 	$210D,	
//#define  111 //	$2201,	
#define HK_KIND_FUTURES_INDEX 112 //	$2301,	港股指数
#define HK_KIND_Option 112 //	$2302,	所有指数

#define QH_HT_STOCKFUND 113 // //华泰股票型基金113	$4601,	
#define QH_HT_BONDFUND  114 // //华泰债券型型基金114	$4602,	
#define QH_HT_HUNHEFUND 115 // //华泰混合型基金115	$4603,	
#define QH_HT_MONEYFUND 116 // //华泰货币型基金116	$4604,



/*
 市场类别定义：
 各位含义表示如下：
 15		   12		8					0
 |			|	  	  |					|
 | 金融分类	|市场分类 |	交易品种分类	|
 */
/*金融大类*/
typedef unsigned short HSMarketDataType;			  // 市场分类数据类型
#define HQ_STOCK_MARKET			 0X1000   // 股票
#	define HQ_SH_BOURSE			 0x0100   // 上海
#	define HQ_SZ_BOURSE			 0x0200   // 深圳
#	define HQ_SYSBK_BOURSE              0x0400   // 系统板块
#	define HQ_USERDEF_BOURSE            0x0800   // 自定义（自选股或者自定义板块）
#			define HQ_KIND_INDEX		0x0000   // 指数
#			define HQ_KIND_STOCKA		0x0001   // A股
#			define HQ_KIND_STOCKB		0x0002   // B股
#			define HQ_KIND_BOND         0x0003   // 债券
#			define HQ_KIND_FUND         0x0004   // 基金
#			define HQ_KIND_THREEBOAD	0x0005   // 三板
#			define HQ_KIND_SMALLSTOCK	0x0006   // 中小盘股
#			define HQ_KIND_PLACE		0x0007	  // 配售
#			define HQ_KIND_LOF			0x0008	  // LOF
#			define HQ_KIND_ETF			0x0009   // ETF
#			define HQ_KIND_QuanZhen     0x000A   // 权证
#			define HQ_KIND_CYBLOCK      0x000B   // 创业板
#           define HQ_KIND_FXBlock      0x000C   // 风险警示板
#			define HQ_KIND_OtherIndex	0x000E   // 第三方行情分类，如:中信指数
//#			define SC_Others		 0x000F   // 其他 0x09	//dsw 2009.07.20 不使用相关定义
#			define HQ_KIND_USERDEFINE	0x0010   // 自定义指数

// 港股市场
#define HQ_HK_MARKET				 0x2000 // 港股分类
#	define HQ_HK_BOURSE			 0x0100 // 主板市场
#	define	HQ_GE_BOURSE			 0x0200 // 创业板市场(Growth Enterprise Market)
#	define	HQ_INDEX_BOURSE		 0x0300	// 指数市场
#		define HQ_HK_KIND_INDEX			 0x0000   // 港指
#		define HQ_HK_KIND_FUTURES_INDEX	 0x0001   // 期指
//#		define	KIND_Option				 0x0002	  // 港股期权

#	define HQ_SYSBK_BOURSE			 0x0400 // 港股板块(H股指数成份股，恒生指数成份股）。
#	define HQ_USERDEF_BOURSE		 0x0800 // 自定义（自选股或者自定义板块）
#			define HQ_HK_KIND_BOND		 0x0000   // 债券
#			define HQ_HK_KIND_MulFund	 0x0001   // 一揽子认股证
#			define HQ_HK_KIND_FUND		 0x0002   // 基金
#			define HQ_KIND_WARRANTS	 0x0003   // 认股证
#			define HQ_KIND_JR			 0x0004   // 金融
#			define HQ_KIND_ZH			 0x0005   // 综合
#			define HQ_KIND_DC			 0x0006   // 地产
#			define HQ_KIND_LY			 0x0007   // 旅游
#			define HQ_KIND_GY			 0x0008   // 工业
#			define HQ_KIND_GG			 0x0009   // 公用
#			define HQ_KIND_QT			 0x000A   // 其它

/*期货大类*/
#define HQ_FUTURES_MARKET			 0x4000 // 期货
#		define HQ_DALIAN_BOURSE		 0x0100	// 大连
#				define HQ_KIND_BEAN		 0x0001	// 大连豆类
#				define HQ_KIND_YUMI		 0x0002	// 大连玉米
#				define HQ_KIND_SHIT		 0x0003	// 大宗食糖
#				define HQ_KIND_DZGY		 0x0004	// 大宗工业1
#				define HQ_KIND_DZGY2		 0x0005	// 大宗工业2
#				define HQ_KIND_DOUYOU		 0x0006	// 大连豆油
#				define HQ_KIND_ZLYOU		 0x0007	// 棕榈油
#				define HQ_KIND_JYX			 0x0008	// 聚乙烯
#				define HQ_KIND_JLYX		 0x0009	// 聚氯乙烯


#		define HQ_SHANGHAI_BOURSE		 0x0200	// 上海
#				define HQ_KIND_METAL		 0x0001	// 上海金属
#				define HQ_KIND_RUBBER		 0x0002	// 上海橡胶
#				define HQ_KIND_FUEL		 0x0003	// 上海燃油
//#				define HQ_KIND_GUZHI		 0x0004	// 股指期货
#				define HQ_KIND_HUANGJIN	 0x0005	// 上海黄金
#				define HQ_KIND_QHGOLD		 KIND_HUANGJIN	// …œ∫£ª∆Ω
#				define HQ_KIND_GANGCAI		 0x0006	// 钢材期货

#		define HQ_ZHENGZHOU_BOURSE	 0x0300	// 郑州
#				define HQ_KIND_XIAOM		 0x0001	// 郑州小麦
#				define HQ_KIND_MIANH		 0x0002	// 郑州棉花
#				define HQ_KIND_BAITANG      0x0003	// 郑州白糖
#				define HQ_KIND_PTA			 0x0004	// PTA
#				define HQ_KIND_CZY			 0x0005	// 菜子油
#				define HQ_KIND_ZXD			 0x0006	// 早籼稻
#				define HQ_KIND_OTHERS		 0x0000	// 其他


#		define HQ_HUANGJIN_BOURSE	  0x0400		// 黄金交易所
#				define HQ_KIND_GOLD		 0x0001	// 上海黄金

#		define HQ_LME_BOURSE		   0x0410		// lme盘
#		define HQ_LME_electron_BOURSE 0x0420		// lme电子盘

#		define HQ_GUZHI_BOURSE		  0x0500		// 股指期货
#				define HQ_KIND_GUZHI		 0x0001	// 股指期货

#		define HQ_SELF_BOURSE		  0x0600	// 自定义数据

#	define HQ_KIND_OutFund          0x0600   // 开放式基金
#			define HQ_KIND_OutFund_GP   0x0001   // 开放式基金 股票型
#			define HQ_KIND_OutFund_ZQ   0x0002   // 开放式基金 债券型
#			define HQ_KIND_OutFund_HH   0x0003   // 开放式基金 混合型
#			define HQ_KIND_OutFund_HB   0x0004   // 开放式基金 货币型
#			define HQ_KIND_OutFund_All  0x000F   // 开放式基金 全部

#		define HQ_DZGT_BOURSE		  0x0610	// 大宗钢铁数据
#		define HQ_DLTL_BOURSE		  0x0620	// 大连套利
#		define HQ_YSJS_BOURSE		  0x0630	// 有色金属

#		define HQ_DynamicSelf_BOURSE 0x0700	// 动态数据类型自定义数据

/*外盘大类*/
#define HQ_WP_MARKET				 ((HSMarketDataType)0x5000) // 外盘
#		define HQ_WP_INDEX				0x0100	// 国际指数 // 不用了
#		define HQ_WP_LME				0x0200	// LME		// 不用了
#			define HQ_WP_LME_CLT			0x0210 //"场内铜";
#			define HQ_WP_LME_CLL			0x0220 //"场内铝";
#			define HQ_WP_LME_CLM			0x0230 //"场内镍";
#			define HQ_WP_LME_CLQ			0x0240 //"场内铅";
#			define HQ_WP_LME_CLX			0x0250 //"场内锌";
#			define HQ_WP_LME_CWT			0x0260 //"场外铝";
#			define HQ_WP_LME_CW			0x0270 //"场外";
#			    define HQ_WP_LME_Market		0x000F //"LME市场";
#			define HQ_WP_LME_SUB			0x0000

#			define HQ_WP_CBOT				0x0300	// CBOT
#			define HQ_WP_NYMEX	 			0x0400	// NYMEX
#			define HQ_WP_NYMEX_YY			0x0000	//"原油";
#			define HQ_WP_NYMEX_RY			0x0001	//"燃油";
#			define HQ_WP_NYMEX_QY			0x0002	//"汽油";

#			define HQ_WP_COMEX	 			0x0500	// COMEX
#			define HQ_WP_TOCOM	 			0x0600	// TOCOM
#			define HQ_WP_IPE				0x0700	// IPE
#			define HQ_WP_NYBOT				0x0800	// NYBOT
#			define HQ_WP_NOBLE_METAL		0x0900	// 贵金属
#				define HQ_WP_NOBLE_METAL_XH	0x0000  //"现货";
#				define HQ_WP_NOBLE_METAL_HJ	0x0001  //"黄金";
#				define HQ_WP_NOBLE_METAL_BY	0x0002  //"白银";

#			define HQ_WP_FUTURES_INDEX		0x0a00	// 期指
#			define HQ_WP_SICOM				0x0b00	// SICOM
#			define HQ_WP_LIBOR				0x0c00	// LIBOR
#			define HQ_WP_NYSE				0x0d00	// NYSE
#			define HQ_WP_CEC				0x0e00	// CEC

#			define HQ_WP_Self_1			0x0E10	// ICE1
#			define HQ_WP_Self_2			0x0E20	// ICE2
#			define HQ_WP_Self_3			0x0E30	// CME
#			define HQ_WP_Self_4			0x0E40	// ƒ…Àπ¥ÔøÀΩª“◊À˘
#			define HQ_WP_Self_5			0x0E50	// ◊‘∂®“Â5
#			define HQ_WP_Self_6			0x0E60	// ◊‘∂®“Â6
#			define HQ_WP_Self_7			0x0E70	// ◊‘∂®“Â7
#			define HQ_WP_Self_8			0x0E80	// ◊‘∂®“Â8
#			define HQ_WP_Self_9			0x0E90	// ◊‘∂®“Â9
#			define HQ_WP_Self_A			0x0EA0	// ◊‘∂®“Â10
#			define HQ_WP_Self_Begin        HQ_WP_Self_1
#			define HQ_WP_Self_End          HQ_WP_Self_A


#			define HQ_WP_Other_TZTHuanjin	0x0F10	// ª∆Ω∆⁄ªı ˝æ›…˙≥…,µ⁄»˝∑Ω ˝æ›
#			define HQ_WP_Other_JinKaiXun	0x0F20	// Ωø≠—∂µƒ ˝æ›
#			define HQ_WP_JKX               HQ_WP_Other_JinKaiXun
#			define HQ_WP_XJP               0x0F30	// –¬º”∆¬ ˝æ›
#			define HQ_WP_LYSEE 			0x0F40  // ≈¶‘ºΩª“◊À˘

#			define HQ_WP_INDEX_AZ	 		0x0110 //"澳洲";
#			define HQ_WP_INDEX_OZ	 		0x0120 //"欧洲";
#			define HQ_WP_INDEX_MZ	 		0x0130 //"美洲";
#			define HQ_WP_INDEX_TG	 		0x0140 //"泰国";
#			define HQ_WP_INDEX_YL	 		0x0150 //"印尼";
#			define HQ_WP_INDEX_RH	 		0x0160 //"日韩";
#			define HQ_WP_INDEX_XHP 		0x0170 //"新加坡";
#			define HQ_WP_INDEX_FLB 		0x0180 //"菲律宾";
#			define HQ_WP_INDEX_CCN 		0x0190 //"中国大陆";
#			define HQ_WP_INDEX_TW  		0x01a0 //"中国台湾";
#			define HQ_WP_INDEX_MLX 		0x01b0 //"马来西亚";
#			define HQ_WP_INDEX_SUB 		0x0000


/*外汇大类*/
#define HQ_FOREIGN_MARKET			 ((HSMarketDataType)0x8000) // 外汇
#	define HQ_WH_BASE_RATE			0x0100	// 基本汇率
#	define HQ_WH_ACROSS_RATE		0x0200	// 交叉汇率
#		define HQ_FX_TYPE_AU 			0x0000 // AU	澳元
#		define HQ_FX_TYPE_CA 			0x0001 // CA	加元
#		define HQ_FX_TYPE_CN 			0x0002 // CN	人民币
#		define HQ_FX_TYPE_DM 			0x0003 // DM	马克
#		define HQ_FX_TYPE_ER 			0x0004 // ER	欧元
#		define HQ_FX_TYPE_HK 			0x0005 // HK	港币
#		define HQ_FX_TYPE_SF 			0x0006 // SF	瑞士
#		define HQ_FX_TYPE_UK 			0x0007 // UK	英镑
#		define HQ_FX_TYPE_YN 			0x0008 // YN	日元

#	define HQ_WH_FUTURES_RATE			0x0300  // 期汇

// ƒ⁄≤ø∑÷¿‡£¨∏¯π…∆±‘¯”√√˚”√
#define HQ_STOCK_WHILOM_NAME_MARKET ((HSMarketDataType)0xF000)


static int	MakeMarket(HSMarketDataType x)
{
	return ((HSMarketDataType)((x) & 0xF000));
}
static int  MakeMainMarket(HSMarketDataType x)
{
	return ((HSMarketDataType)((x) & 0xFFF0));
}
static int	MakeMidMarket(HSMarketDataType x)
{
	return ((HSMarketDataType)((x) & 0x0F00)); // ∑÷¿‡µ⁄∂˛Œª
}

static int MakeSubMarket(HSMarketDataType x)
{
	return ((HSMarketDataType)((x) & 0x000F));
}

static int MakeHexSubMarket(HSMarketDataType x)
{
	return ( (HSMarketDataType)((x) & 0x000F) );
}

static int MakeSubMarketPos(HSMarketDataType x)
{
	return ( ((MakeHexSubMarket(x) / 16) * 10) + (MakeHexSubMarket(x) % 16) );
}

static int MakeIndexMarketHQ(HSMarketDataType x)
{
	return ( (MakeMarket(x) == HQ_STOCK_MARKET) &&
            (MakeMidMarket(x) != 0) &&
            ((MakeSubMarket(x) == HQ_KIND_INDEX) ||
			 (MakeSubMarket(x) == HQ_KIND_OtherIndex)));
}

CG_INLINE BOOL MakeUSMarket(int x)
{
    return (MakeMainMarket(x) == (HQ_WP_MARKET|HQ_WP_LYSEE));
}


CG_INLINE BOOL MakeIndexMarket(int x)
{
    return ( x == SH_KIND_INDEX ||
             x == SZ_KIND_INDEX ||
             x == WP_INDEX ||
            MakeIndexMarketHQ(x));
}

CG_INLINE BOOL MakeStockMarket(int x)
{
    return (( x >= 0 &&
            x < QH_FUTURES_MARKET) ||
            x == HS_KIND_STOCKA ||
            x == HS_KIND_STOCKB ||
            (MakeMarket(x) == HQ_STOCK_MARKET)
            );
}

CG_INLINE BOOL MakeStockMarketStock(int x)
{
    return (MakeStockMarket(x)
            && x != SH_KIND_INDEX
            && x != SZ_KIND_INDEX
            && x != BLOCK_INDEX_HY
            && x != BLOCK_INDEX_GN
            && (MakeSubMarket(x) != HQ_KIND_INDEX)
            && (MakeSubMarket(x) != HQ_KIND_USERDEFINE)
            && (MakeSubMarket(x) != HQ_KIND_OtherIndex)
            );
//    return ( x == HS_KIND_STOCKA || x == HS_KIND_STOCKB
//            || (MakeMarket(x) == HQ_STOCK_MARKET && (MakeSubMarket(x) == HQ_KIND_STOCKA || MakeSubMarket(x) == HQ_KIND_STOCKB)));
}

CG_INLINE BOOL MakeBlockIndex(int x)
{
    return (MakeMainMarket(x) == (HQ_FUTURES_MARKET|HQ_SELF_BOURSE|0x0060));
}


CG_INLINE BOOL MakeStockBlock(int x)
{
    return ((x >= 0 &&
             (x == BLOCK_INDEX_HY ||
             x == BLOCK_INDEX_GN)
             ));
}

CG_INLINE BOOL MakeQHMarket(int x)
{
    return ( (x >= QH_FUTURES_MARKET && x < WH_FOREIGN_MARKET) ||
            (MakeMarket(x) == HQ_FUTURES_MARKET));
}

CG_INLINE BOOL MakeWHMarket(int x)
{
    return ( (x >= WH_FOREIGN_MARKET && x < WP_MARKET) ||
            (MakeMarket(x) == HQ_FOREIGN_MARKET));
}

CG_INLINE BOOL MakeWPMarket(int x)
{
    return ( (x >= WP_MARKET && x < HK_MARKET) ||
            (MakeMarket(x) == HQ_WP_MARKET));
}

CG_INLINE BOOL MakeHKMarket(int x)
{
    return ( (x >= HK_MARKET && x < 113) ||
            MakeMarket(x) == HQ_HK_MARKET);
}

CG_INLINE BOOL MakeHKMarketStock(int x)
{
    return (MakeHKMarket(x)
            && MakeMidMarket(x) != HQ_INDEX_BOURSE);
}

CG_INLINE BOOL MakeHTFundMarket(int x)
{
    return (( x >= QH_HT_STOCKFUND && x <= QH_HT_MONEYFUND)
            ||(MakeMainMarket(x) == (HQ_FUTURES_MARKET|HQ_KIND_OutFund)
               )
            );
}

CG_INLINE BOOL MakeHTFundHBMarket(int x)
{
    return( (x== QH_HT_MONEYFUND)
           || (MakeHTFundMarket(x) && MakeSubMarket(x) == HQ_KIND_OutFund_HB));
}

//是否有资金流向
CG_INLINE BOOL MakeFundFlowsMarket(int x)
{
    int nMarket = MakeMarket(x);
    int nMainMarket = MakeMidMarket(x);
    int nSubMarket = MakeSubMarket(x);
    
    return ( (x == SH_KIND_STOCKA
              || x == SH_KIND_SMALLSTOCK
              || x == SH_KIND_THREEBOAD
              || x == SH_KIND_TUISHI
              || x == SZ_KIND_STOCKA
              || x == SZ_KIND_QuanZhen
              || x == SZ_KIND_SMALLSTOCK
              || x == SZ_KIND_THREEBOAD
              || x == SZ_KIND_TUISHI)
            || ((nMarket == HQ_STOCK_MARKET) && ((nMainMarket == HQ_SH_BOURSE) || (nMainMarket == HQ_SZ_BOURSE))
                && ((nSubMarket == HQ_KIND_STOCKA) || (nSubMarket == HQ_KIND_THREEBOAD)
                    || (nSubMarket == HQ_KIND_SMALLSTOCK) || (nSubMarket == HQ_KIND_CYBLOCK) || (nSubMarket == HQ_KIND_FXBlock)))
    );
}


#endif
