/*******************************************************************************
 * Copyright (c)2012, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称：tztTechObjBase.h
 * 文件标识：
 * 摘    要：行情基础定义
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
#ifndef __TZTTECHOBJBASE_H__
#define __TZTTECHOBJBASE_H__
#define tztParamHeight ([tztTechSetting getInstance].chinaTxtSize.height + 15) //参数高度

#pragma	pack(1)
//byte	1	1字节无符号整数，表达范围0..255   unsigned char
//Word	2	2字节无符号整数，表达范围0..65535 unsigned short
//Longword	4	4字节无符号整数，表达范围0..4294967295 unsigned int
//Cardinal	4	与Longword相同 unsigned int
//integer	4	4字节有符号整数，表达范围-2147483648..2147483647 int32_t
//Longint	4	与integer相同 int32_t
//Single	4	4字节浮点数，表达范围1.5 x 10^-45..3.4 x 10^38，有效数据位数7-8 float
//char	1	1个字节的字符 char
//K线数据头 结构
typedef struct TNewKLineHead
{
    char cStockName[16];//股票名称
    unsigned char nDecimal; //小数点位数
    unsigned char nUnit;     //单位
    int32_t nMaxPrice; //最大值
    int32_t nMinPrice;  //最小值
    int64_t lCirculate;      //流通盘
    
    int32_t nWeekUp;//周涨幅(放大100倍，即258表示2.58%)
    int32_t nMonthUp;//月涨幅(放大100倍，即258表示2.58%)
    int32_t nWFSY;//万份收益，单位：元?
    int32_t nQRNH;//七日年化收益(放大10000倍，即25800表示2.58%)
}TNewKLineHead;

//typedef struct TNewKLineHead
//{
//    TNewKLineHead newKLineHead;
//    char cStockName[18];
//}TNewKLineHead;

// base编码转结构体
FOUNDATION_EXPORT void setTNewKLineHead(TNewKLineHead* pTNewKLineHead, NSString* strBaseData);
//获取股票名称
FOUNDATION_EXPORT NSString* getcStockName_TNewKLineHead(TNewKLineHead* pTNewKLineHead);

//TKLineHead = packed record
//StockName: array[0..15] of char;
//total_size: byte; //小数点位数
//Units: byte; //单位   10的倍数 1表示需要乘10 2表示要乘100
//HighPrice: longint;
//LowPrice:longint;
//m: int64;//流通盘
//end;
//K线数据 结构
typedef struct TNewKLineData
{
    unsigned int ulTime;              //时间：分钟K线时为MMDDHHNN，其他K线为YYYYMMDD
    int32_t nOpenPrice;      //开盘价，单位：厘
    int32_t nHighPrice;      //最高价，单位：厘
    int32_t nLowPrice;       //最低价，单位：厘
    union
	{
		int32_t nClosePrice;     //收盘价，单位：厘
        struct
		{
			unsigned int m_lClosePriceValue:28;
			unsigned int m_lClosePriceFlag:4;
		}a;
	}a;
    union
	{
		unsigned int ulTotal_h;           //成交量，单位：手，1手=100股
		struct
		{
			unsigned int m_lTotalValue:28;
			unsigned int m_lTotalFlag:4;
		}a;
	}c;
}TNewKLineData;
//TNewKLineData = packed record
//Time: LongWord; //时间：分钟K线时为MMDDHHNN，其他K线为YYYYMMDD
//OpenPrice: integer; //开盘价，单位：厘
//HighPrice: integer; //最高价，单位：厘
//LowPrice: integer;  //最低价，单位：厘
//ClosePrice: integer;//收盘价，单位：厘
//Total_h: Cardinal;  //成交量，单位：手，1手=100股
//end;


//Grid
//分时数据 结构
typedef struct TNewTrendData
{
    unsigned int nClosePrice;      //最新价，单位：厘
    unsigned int nAvgPrice;      //均价，单位：厘
    int32_t nTotal_h;     //分钟成交量
}TNewTrendData;

//TFSZS = packed record
//Last_p: word; //最新价
//averprice: word; //均价
//total_h: integer; //分钟成交量
//end;


//BinData
//分时数据头 结构
typedef struct TNewTrendHead
{
    char StockName[16];//股票名称
    int32_t nPreClosePrice; //昨收盘价
    int32_t nOpenPrice;  //开盘价
    unsigned char nDecimal; //小数点位数
    unsigned char nUnit;     //单位
    int32_t nMinPrice;  //参考值  取最小值
    int64_t lCirculate;      //流通盘
    int32_t nMaxPrice; //最大值
    char   nClear; //是否重置分时图 第二天开盘需重置
    int32_t nCurTotal_h; //现手
}TNewTrendHead;

//typedef struct TNewTrendHead
//{
//    TNewTrendHead newTrendHead;
//    char StockName[18];
//}TNewTrendHead;

// base编码转结构体
FOUNDATION_EXPORT void setTNewTrendHead(TNewTrendHead* pTNewTrendHead, NSString* strBaseData);
//获取股票名称
FOUNDATION_EXPORT NSString* getStockName_TNewTrendHead(TNewTrendHead* pTNewTrendHead);

//TFSZSHead = packed record
//StockName: array[0..15] of char; //股票名称
//Close_p: longint; //昨收盘价
//Open_p: longint; //开盘价
//total_size: byte; //小数点位数
//Units: byte; //单位   10的倍数 1表示需要乘10 2表示要乘100
//Consult: longint; //参考值  取最小值
//end;

//十档行情数据流
typedef struct TNewPriceDataTen
{
    int32_t         SellPrice10;
    unsigned int    SellCount10;
    int32_t         SellPrice9;
    unsigned int    SellCount9;
    int32_t         SellPrice8;
    unsigned int    SellCount8;
    int32_t         SellPrice7;
    unsigned int    SellCount7;
    int32_t         SellPrice6;
    unsigned int    SellCount6;
    int32_t         SellPrice5;
    unsigned int    SellCount5;
    int32_t         SellPrice4;
    unsigned int    SellCount4;
    int32_t         SellPrice3;
    unsigned int    SellCount3;
    int32_t         SellPrice2;
    unsigned int    SellCount2;
    int32_t         SellPrice1;
    unsigned int    SellCount1;
    
    int32_t         BuyPrice1;
    unsigned int    BuyCount1;
    int32_t         BuyPrice2;
    unsigned int    BuyCount2;
    int32_t         BuyPrice3;
    unsigned int    BuyCount3;
    int32_t         BuyPrice4;
    unsigned int    BuyCount4;
    int32_t         BuyPrice5;
    unsigned int    BuyCount5;
    int32_t         BuyPrice6;
    unsigned int    BuyCount6;
    int32_t         BuyPrice7;
    unsigned int    BuyCount7;
    int32_t         BuyPrice8;
    unsigned int    BuyCount8;
    int32_t         BuyPrice9;
    unsigned int    BuyCount9;
    int32_t         BuyPrice10;
    unsigned int    BuyCount10;
}TNewPriceDataTen;

//股票数据
typedef struct TNewStockData
{                 //股票          //期货、外盘
    int32_t p1;  //买一价          //买价    		，单位：厘
    unsigned int Q1; //买一量      //买量			，单位：股               
    int32_t p2;  //买二价          //总持仓量           
    unsigned int Q2; //买二量	
    int32_t  p3;  //买三价         //前持仓量(昨持仓量)
    unsigned int Q3; //买三量
    int32_t p4;  //卖一价          //卖价               
    unsigned int Q4; //卖一量      //卖量
    int32_t P5;  //卖二价          //内盘
    unsigned int Q5; //卖二量
    int32_t P6;  //卖三价          //外盘
    unsigned int Q6; //卖三量
    
    int32_t p7;  //买四价          //日增
    unsigned int Q7; //买四量
    int32_t p8;  //买五价          //昨收盘价
    unsigned int Q8; //买五量      //涨停板
    int32_t p9;  //卖四价          //多头开(单位:合约单位)
    unsigned int Q9; //卖四量
    int32_t p10; //卖五价          //空头开(单位:合约单位)
    unsigned int Q10;//卖五量
    
    unsigned short new_kind; //新类型
    
    unsigned short Reserve; //暂用为国债利息。
    int32_t Last_h; //现手，单位：股  
}TNewStockData;

//数据扩展，6-10档
typedef struct TNewPriceDataEx
{
    int32_t         pBuy1;//买1价
    unsigned int    QBuy1;//买1量
    
    int32_t         pBuy2;//买2价
    unsigned int    QBuy2;//买2量
    
    int32_t         pBuy3;//买3价
    unsigned int    QBuy3;//买3量
    
    int32_t         pBuy4;//买4价
    unsigned int    QBuy4;//买4量
    
    int32_t         pBuy5;//买5价
    unsigned int    QBuy5;//买5量
    
    int32_t         pSell1;//卖1价
    unsigned int    QSell1;//卖1量
    
    int32_t         pSell2;//卖2价
    unsigned int    QSell2;//卖2量
    
    int32_t         pSell3;//卖3价
    unsigned int    QSell3;//卖3量
    
    int32_t         pSell4;//卖4价
    unsigned int    QSell4;//卖4量
    
    int32_t         pSell5;//卖5价
    unsigned int    QSell5;//卖5量
    
    float    totalBuy;//委托买入总量
    unsigned int    WeightedAvgBidPx;//加权平均委买价格
    unsigned int    AltWeightedAvgBidPx;
    
    unsigned int    totalSell;//委托卖出总量
    unsigned int    WeightedAvgOfferPx;//加权平均委卖价格
    unsigned int    AltWeightedAvgOfferPx;
    
    unsigned int    totalhands;// 成交笔数
    
}TNewPriceDataEx;

//指数数据
typedef struct TNewIndexData
{
    unsigned short ups; //上涨股票数
    unsigned short downs; //下跌股票数
    unsigned short x0;
    int32_t buy_h; //总申买量
    int32_t sale_h; //总申卖量
    unsigned short lnAHEAD; //领先指标
    unsigned short lnDKZB; //多空指标
    unsigned short lnQRD; //强弱度
    short BuyGasMain; //买气总
    int32_t BuyGasTop; //买气
    short SaleGasMain; //卖气总
    short SaleGasTop; //卖气
    
    unsigned short totals; //总股票数
    int32_t lnADL; //ADL指标
    
    short q5a; //未用
    int32_t p6a; //未用
    int32_t q6a; //未用
    int32_t x2; //未用
    int32_t x3; //未用
    
    int32_t p7a; //未用
    int32_t Q7a; //未用
    int32_t p8a; //未用
    int32_t Q8a; //未用
    int32_t p9a; //未用
    int32_t Q9a; //未用
    int32_t p10a; //未用
    int32_t Q10a; //未用
    unsigned short new_kinda; //未用
}TNewIndexData;

//报价数据 结构
typedef struct TNewPriceData
{
    char XFlag[1]; //停盘标志;' '即空格-停,'0'-开  |
    char Name[16]; //股票名称，16个字节的字符串，注意：客户端转成ANSI字符串后才是16字节 |
    int32_t nameLength;
    unsigned char Kind; //类型  上指16,上A17,上B18,上债19;深指32,深A33,深B34,深债35 |
    char Code[6]; //股票代码 |
    int32_t Close_p; //昨收盘价 //期货时放昨结算价
    int32_t Open_p; //今开盘价
    int32_t High_p; //最高价
    int32_t Low_p; //最低价
    int32_t Last_p; //最新价
    unsigned int Total_h; //总成交量 //指数单位：手，其他单位：股
    float Total_m; //总成交金额 (3.08), 指数单位：百元，其他单位：元；期货或外盘：总持仓量
    union
    {
        TNewStockData StockData;
        TNewIndexData indexData;
    }a;
    unsigned char nDecimal; //小数位数，股票、外汇、期货、基金的小数位可能不同
    unsigned char nHour;    //时间中的时
    unsigned char nMin; //时间中的分
    int32_t  nHuanshoulv; 	//换手率，是实际换手率的100倍，如：5表示换手率0.05%     
    //    指数时无换手率，为0
    int32_t  m_lInside;     // 内盘
    int32_t  m_lOutside;    // 外盘
    int32_t  m_lAvgPrice;  //股票均价，期货就是结算价。单位和其他价格相同：厘。
//    注意：开盘时这个结算价是按公式计算出来的，用于参考，实际结算价在收盘后由交易所发布。
    //AccountIndex > 0时
    int32_t  m_lUpPrice;//	涨跌，即：最新价-昨收盘价
    int32_t  m_lUpIndex;//	涨跌幅(%)，是实际涨跌幅的100倍，如：528表示5.28%
//    当昨收盘价=0时此字段设为0
    int32_t  m_lMaxUpIndex; //振幅(%)，是实际振幅的100倍，如：528表示5.28%
//    当昨收盘价=0时此字段设为0
    int32_t  m_lLiangbi;//	量比。量比=现成交总手/过去5个交易日平均每分钟成交量×当日累计开市时间(分)
    char     c_userstock;//	自选股标记：减号'-' 是自选股；加号'+' 不是自选股；空格' '未知；
    char 	BlockName[16];//	隶属板块名称，注意：解码为Ansi字符串后才是16字节
    int     nBlockNameLength;
//    隶属板块是指该股票所在行业板块，如：600600青岛啤酒隶属于“酿酒食品”板块
//    未找到隶属板块则此字段全设为空格
    char   BlockCode[6]; //隶属板块指数代码，如“酿酒食品”板块为991020。
//    未找到隶属板块则此字段全设为空格
    int32_t m_lBlockUpIndex;//	隶属板块指数涨跌幅%，是实际涨跌幅的100倍，如：-528表示-5.28%
    int32_t	m_ldtsyl;// 动态市盈率，放大了1000倍，如：52800表示52.8
    int32_t m_ljzc;//	每股净资产(元／股)。因为需精确到小数点后4位，所以放大了10000倍，如：52800表示5.28元。显示时有些界面可能只显示2位小数
    int32_t m_zgb;//	总股本(万股)
    int32_t m_ltb;//	流通盘(万股)
    
    int32_t m_blockUps;     //对应BlockCode板块上涨数
    int32_t m_blockDowns;   //对应BlockCode板块下跌数
    int32_t m_blockFlats;   //对应BlockCode板块平盘数
    
    //0-否，1-是，x-无此属性
    char    c_IsGgt;
    char    c_CanBuy;
    char    c_CanSell;
    
    //融资标的
    char    c_RZBD;
    //融券标的
    char    c_RQBD;
    
    //增加委比委差
    int32_t m_nWB;  //委比
    int32_t m_nWC;  //委差
    
    int32_t m_nUnit;//每手股数，美股、港股为1，债券为10，其他100。2014-12-10国金首先使用
    
    int32_t m_mgsy; //每股收益 单位：十分之一厘 元后保留4位小数
    int32_t m_jtsyl; //静态市盈率 放大1000倍
    int32_t m_jb;    //季报年报 3=一季报 6=半年报 9=三季报 12=年报
    int32_t m_zt;    //涨停价 厘
    int32_t m_dt;    //跌停价 厘
    
}TNewPriceData;

//个股队列单个数据
typedef struct TNewOrderQueueItem
{
    int32_t     m_nPrice;   //委托价格
    int32_t     m_nNumber;  //委托笔数
    
    //具体笔数数据，最多50
    int32_t     m_DataStatus[50];
}TNewOrderQueueItem;

typedef struct TNewLevelOrderQueue
{
    int32_t     m_Time;// 163025 stands for 16:30:25.
    int32_t     m_DataStatus;//总量
    char        m_Side; //买卖方向  '1'买  '2'卖
    int32_t     m_nSize;
    TNewOrderQueueItem m_Data[10];
}TNewLevelOrderQueue;

//个股买卖队列
typedef struct TNewOrderQueue
{
    TNewLevelOrderQueue  m_Buy;
    TNewLevelOrderQueue  m_Sell;
    
    int32_t             m_BuyTotal;     //委托买入总量
    int32_t             m_BuyWeightAvg; //委托买入加权平均委买价格
    
    int32_t             m_SellTotal;    //委托卖出总量
    int32_t             m_SellWeightAvg;//委托卖出价格平均委卖价格
}TNewOrderQueue;

//typedef struct TNewPriceData
//{
//    TNewPriceData newPriceData;
//    char Name[18];
//    char BlockName[18];
//}TNewPriceData;

// base编码转结构体
FOUNDATION_EXPORT void setTNewPriceData(TNewPriceData* pTNewPriceData, NSString* strBaseData);
//
FOUNDATION_EXPORT void setTNewPriceDataEx(TNewPriceDataEx* pTNewPriceData, NSString* strBaseData);
// 获取股票名称
FOUNDATION_EXPORT NSString* getName_TNewPriceData(TNewPriceData* pTNewPriceData);
// 获取板块名称
FOUNDATION_EXPORT NSString* getBlockName_TNewPriceData(TNewPriceData* pTNewPriceData);
// 获取板块代码
FOUNDATION_EXPORT NSString* getBlockCode_TNewPriceData(TNewPriceData* pTNewPriceData);

//成交明细头
typedef struct TNewDetailHead
{
    char    Name[16];   //16字节股票名称
    int32_t Last_p;     //4位昨收价
    unsigned char    cDemical;   //1位小数精度
    
}TNewDetailHead;
//
//typedef struct TNewDetailHead
//{
//    TNewDetailHead newDetailHead;
//    char Name[18];
//}TNewDetailHead;

// base编码转结构体
FOUNDATION_EXPORT void setTNewDetailHead(TNewDetailHead* pTNewDetailHead, NSString* strBaseData);
// 获取股票名称
FOUNDATION_EXPORT NSString* getName_TNewDetailHead(TNewDetailHead* pTNewDetailHead);

//成交明细结构
typedef struct TNewDetailData
{
    unsigned char    nHour;     //  1位时间中的时
    unsigned char    nMin;      //  1位时间中的分
    int32_t          nPrice;    //  成交价，单位：（厘），即8130表示8.13元
    int32_t          nVolume;   //  成交量，单位：（股）
    unsigned char    nFlag;     //  内外盘标识 2-内盘('↓')=卖入价成交    1-外盘('↑')=卖出价成交    0-未知（'→'）(应该不会出现，分笔数据应该都是成交的)
    
}TNewDetailData;

//分价结构
typedef struct TFenJiaData
{
    unsigned int     nPrice;//价格
    unsigned int     nCount;//数量
}TFenJiaData;

//炒跟数据
typedef struct TShareData
{
    unsigned int nday;//委托日期 20130618
    unsigned int ntime;//委托时分 1415
    unsigned char ndir;//委托方向(1买2卖)
    unsigned char nreal;//是否实盘(1实盘 2模拟炒股)
    unsigned char npos;//小数点位数 根据发的数据计算
    unsigned int nprice;//价格*10000
}TShareData;

//资金指数
typedef struct 
{
    unsigned int ulTime;              //时间：YYYYMMDD
    unsigned int m_ZLline;             //主力资金线
    unsigned int m_SHline;             //散户资金线
}TZJZS;

//运筹帷幄
typedef struct 
{
    unsigned int ulTime;              //时间：YYYYMMDD
    unsigned int m_line1;             //☆下趋势,双线持币
    unsigned int m_line2;             //☆上趋势,单线持股线
    unsigned int m_buy;               //☆参考介入价
    //画图标
    unsigned int m_Con1;             //图标 上箭头图标
    unsigned int m_Con2;             //图标  下箭头图标
    
    //在图上输出的数字
    unsigned int m_NewPr1;             //☆大于0打印text1
    unsigned int m_NewPr2;             //☆
    unsigned int m_NewPr3;             //☆
    unsigned int m_NewPr4;             //☆
    unsigned int m_NewPr6;             //☆大于0大于,0表示没有
    unsigned int m_NewPr7;             //☆
    //要画出来的数字
    unsigned int m_lNum1;               //☆,text1,RGB(255,25,0)
    unsigned int m_lNum2;
    unsigned int m_lNum3;
    unsigned int m_lNum4;
    
    //画柱线
    unsigned int m_A1;                 //☆柱线line1a：宽8,RGB(255,51,0),实心:
    unsigned int m_A2;
    unsigned int m_A3;
    unsigned int m_A4;
    unsigned int m_A5;
    unsigned int m_A6;
    unsigned int m_A7;
    unsigned int m_A8;
    unsigned int m_A9;
    unsigned int m_A10;
    unsigned int m_A11;
    unsigned int m_A12;
    unsigned int m_A13;
    unsigned int m_A14;
    unsigned int m_A15;
    unsigned int m_A16;
    unsigned int m_A17;
    unsigned int m_A18;
}TYCWW;

#pragma	pack()

//K线数据
@interface tztTechValue:NSObject
{
    unsigned short   _uYear;
    unsigned int    _ulTime;              //时间
    int32_t _nOpenPrice;      //开
    int32_t _nHighPrice;      //高
    int32_t _nLowPrice;       //低
    int32_t _nClosePrice;     //收
    double _ulTotal_h;           //成交量
    int32_t _nVolume;//单位
}
@property unsigned short uYear;
@property unsigned int ulTime;
@property int32_t nOpenPrice;
@property int32_t nHighPrice;
@property int32_t nLowPrice;
@property int32_t nClosePrice;
@property double ulTotal_h;
@property int32_t nVolume;
- initwithdata:(TNewKLineData*)klinedata;
- (void)setdata:(TNewKLineData*)klinedata;
- (BOOL)isVaild;
@end

//资金指数
@interface tztZJZS : NSObject
{
    unsigned int _ulTime;  //时间
    unsigned int _ZLline; //主力资金线
    unsigned int _SHline; //散户资金线
}

@property unsigned int m_ulTime;
@property unsigned int m_ZLline;
@property unsigned int m_SHline;

- (void)setdata:(TZJZS*)klinedata;
//数据有效性判断
- (BOOL)isVaild;
@end

//运筹帷幄
@interface tztYCWW : NSObject
{
    unsigned int _ulTime;  //时间
    unsigned int _line1;   //☆下趋势,双线持币
    unsigned int _line2;   //☆上趋势,单线持股线
    
    unsigned int _buy;     //☆参考介入价
    unsigned int _Con1;    //图标 上箭头图标
    unsigned int _Con2;   //图标  下箭头图标
    
    //在图上输出的数字
    unsigned int _NewPr1;   //☆大于0打印text1
    unsigned int _NewPr2;
    unsigned int _NewPr3;
    unsigned int _NewPr4;
    unsigned int _NewPr6;
    unsigned int _NewPr7;
    
    //要画出来的数字
    unsigned int _lNum1;
    unsigned int _lNum2;
    unsigned int _lNum3;
    unsigned int _lNum4;
    
    //画柱线
    unsigned int _A1;  //☆柱线line1a：宽8,RGB(255,51,0),实心:
    unsigned int _A2;
    unsigned int _A3;
    unsigned int _A4;
    unsigned int _A5;
    unsigned int _A6;
    unsigned int _A7;
    unsigned int _A8;
    unsigned int _A9;
    unsigned int _A10;
    unsigned int _A11;
    unsigned int _A12;
    unsigned int _A13;
    unsigned int _A14;
    unsigned int _A15;
    unsigned int _A16;
    unsigned int _A17;
    unsigned int _A18;
}

@property unsigned int m_ulTime;
@property unsigned int m_line1;
@property unsigned int m_line2;
@property unsigned int m_buy;
@property unsigned int m_Con1;
@property unsigned int m_Con2;
@property unsigned int m_NewPr1;
@property unsigned int m_NewPr2;
@property unsigned int m_NewPr3;
@property unsigned int m_NewPr4;
@property unsigned int m_NewPr6;
@property unsigned int m_NewPr7;
@property unsigned int m_lNum1;
@property unsigned int m_lNum2;
@property unsigned int m_lNum3;
@property unsigned int m_lNum4;
@property unsigned int m_A1;
@property unsigned int m_A2;
@property unsigned int m_A3;
@property unsigned int m_A4;
@property unsigned int m_A5;
@property unsigned int m_A6;
@property unsigned int m_A7;
@property unsigned int m_A8;
@property unsigned int m_A9;
@property unsigned int m_A10;
@property unsigned int m_A11;
@property unsigned int m_A12;
@property unsigned int m_A13;
@property unsigned int m_A14;
@property unsigned int m_A15;
@property unsigned int m_A16;
@property unsigned int m_A17;
@property unsigned int m_A18;

- (void)setdata:(TYCWW*)tycww;
//数据有效性判断
- (BOOL)isVaild;
@end

//炒跟
@interface tztShareData : NSObject
{
    NSString * _nsTime;//买卖时间
    NSString * _nsDate;//日期
    NSString * _nsWTType;//委托类型
    NSString * _nsPrice; //委托价格
    UIColor * _Color;
}
@property (nonatomic,retain)NSString *nsTime;
@property(nonatomic,retain)NSString *nsWTType;
@property(nonatomic,retain)NSString *nsPrice;
@property(nonatomic,retain)NSString *nsDate;
@property(nonatomic,retain)UIColor *Color;
- (void)setdata:(TShareData*)sharedata;
- (BOOL)isVaild;
@end

@interface tztFundFlowsValue:NSObject
{
    NSString * _pTime;//时间
    NSString * _PJing;//净额
    NSString * _pZhuLi;//主力
    NSString * _pDaHu;//大户
    NSString * _pZhongHu;//中户
    NSString * _pSanHu;//散户
    
}
@property (nonatomic, retain) NSString * pTime;
@property (nonatomic, retain) NSString * pJing;
@property (nonatomic, retain) NSString * pZhuLi;
@property (nonatomic, retain) NSString * pDaHu;
@property (nonatomic, retain) NSString * pZhongHu;
@property (nonatomic, retain) NSString * pSanHu;
@end

@interface tztTrendFundFlows : NSObject
{
    NSString* _nsKind;  //类别
    int       _nKind;   //对应_nsKind, 1-机构 2-大户 3－散户 4-主力
    NSString* _nsFundIn;    //流入(万元)
    NSString* _nsFundOut;   //流出(万元)
    NSString* _nsFundJE;  //净额(万元)
}
@property(nonatomic, retain)NSString* nsKind;
@property(nonatomic, retain)NSString* nsFundIn;
@property(nonatomic, retain)NSString* nsFundOut;
@property(nonatomic, retain)NSString* nsFundJE;
@property int nKind;
@end

@interface tztUpdate : NSObject<UIAlertViewDelegate>
{
    int      _nUpdateSign;
    NSString *_nsTips;
    NSString *_nsUpdateURL;
}
@property(nonatomic, retain)NSString* nsTips;
@property(nonatomic, retain)NSString* nsUpdateURL;
@property int nUpdateSin;

-(void)CheckUpdate;
@end

extern tztUpdate *g_pTztUpdate;

typedef enum 
{
    KLineAxisNon = 0, //不绘制坐标
    KLineXAxis = 1<< 0,   //绘制X坐标
    KLineYAxis = 1<< 1,   //绘制Y坐标
    KLineXYAxis = KLineXAxis | KLineYAxis,  //绘制XY坐标
}tztKLineAxisStyle;

typedef enum
{
    KLineMapPKLine = 1, //K线图
    KLineMapVOL = 1 << 1, //量图
    KLineMapMACD = 1 << 2,//指标图
}tztKLineObj; //K线图型

typedef enum 
{
    KLineMapOne = KLineMapPKLine, //一图 K线图
    KLineMapTwo = KLineMapPKLine | KLineMapMACD, //二图 K线图 指标图
    KLineMapThree = KLineMapPKLine | KLineMapVOL | KLineMapMACD,//三图 K线图 量图 指标图
    KLineMapOnly = KLineMapMACD, //指标图
}tztKLineMapNum; //绘制数量

typedef enum 
{
    KLineCycleDay = 0, //日线
    KLineCycle5Min = 1, //5分钟
    KLineCycle15Min = 2,//15分钟
    KLineCycle30Min = 3,//30分钟
    KLineCycle60Min = 4,//60分钟
    KLineCycleWeek = 5,//周线
    KLineCycleMonth = 6,//月线
    KLineCycleCustomDay = 7,//自定义
    KLineCycleCustomMin = 8,//自定义
    KLineCycle1Min = 90,
    KLineChuQuan = 200, //复权
    KLineCycleDayYCWW,//运筹帷幄
}tztKLineCycle;//周期


typedef enum 
{
    KLineDrawKLine = 0, //K线
    KLineDrawBaota = 1, //宝塔线
    KLineDrawGaoying = 2,//高英K线
    KLineDrawRongwei = 3,//容维
    KLineDrawSFLD = 4,//四方力道
    KLineDrawJGW = 5,//机构王
}tztKLineDrawStyle; //K线线型


typedef enum 
{
    TrendPriceNon = 0, //无报价
    TrendPriceOne = 1<< 0,   //报价（盘口切换）
    TrendPriceTwo = 1<< 1,   //报价和盘口
    TrendPricePriceOnly = 1<<2, //只有盘口
}tztTrendPriceStyle;

//    StockIndex	Int	Y	K线(0日线,1五分钟线,2十五分钟线,3三十分钟线,4六十分钟线,5周线,6月线,7自定义日线等)
//    MaxCount	Int	Y	结束位置
//    Volume	Int	N	用户自定义K线周期参数
//    2=2分钟或者2日
//    Direction	Int	Y	线类型（0K线  1宝塔线  2高英K线  3容维  4四方道力  5机构王）

//获取周期名称
FOUNDATION_EXPORT NSString* getCycleName(tztKLineCycle nKLineCycleStyle);
//获取指标名称
FOUNDATION_EXPORT NSString* getZhiBiaoName(NSInteger nKLineZhiBiao);
//获取最大差值
FOUNDATION_EXPORT long GetMaxDiff(long lReference,long lMaxValue,long lMinValue);
//long转字符串 *亿 *万
FOUNDATION_EXPORT NSString* NStringOfLong(long lValue);
//ulong 转字符串
FOUNDATION_EXPORT NSString* NStringOfULong(unsigned long ulValue);
//float 转字符串
FOUNDATION_EXPORT NSString* NStringOfFloat(float fValue);
//ulong long 转字符串
FOUNDATION_EXPORT NSString* NStringOfULongLong(unsigned long long ullValue);
//数据转字符串 数据 比对值 小数位 除数
FOUNDATION_EXPORT NSString* NSStringOfVal_Ref_Dec_Div( long lValue, long lReference, NSInteger nDecimal,NSInteger nDiv);
#endif