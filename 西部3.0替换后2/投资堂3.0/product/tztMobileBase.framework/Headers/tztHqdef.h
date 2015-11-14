
/*******************************************************************************
 * Copyright (c)2012, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称：tztHqdef.h
 * 文件标识：
 * 摘    要：功能号定义定义
 *
 * 当前版本：
 * 作    者：yangdl
 * 完成日期：2012.12.12
 *
 * 备    注：  该文档中，宏定义功能号部分，后续废弃使用，开发过程中请使用tztBaseVCMsgtypedef.h中定义的功能号
 *
 * 修改记录：
 *
 *******************************************************************************/
#import "tztBaseVCMsgtypedef.h"

#ifndef tztMobileBase_tztHqdef_h
#define tztMobileBase_tztHqdef_h

//页面类型 测试
#define ReportHomePage      0x00000014  //  首页
#define	ReportUserStPage    0x00000001	//	自选股
#define	ReportRecentPage    0x00000002	//	大盘指数
#define	ReportGPMarketPage  0x00000004	//	股票市场
#define	ReportQHMarketPage  0x00000008	//	期货市场

#define	ReportWPMarketPage	0x00000010	//	外盘市场
#define	ReportWHMarketPage	0x00000020	//	外汇市场
#define	ReportHKMarketPage	0x00000040	//	港股市场
#define	ReportOutFundPage	0x00000080	//	开放式基金


#define	ReportGPTradePage	0x00000100	//	股票交易
#define ReportRZRQTradePage 0x00000101  //  融资融券 add by xyt 201300930
#define	ReportJJTradePage	0x00000200	//	基金交易
#define	ReportQHTradePage	0x00000400	//	期货交易
#define	ReportHKTradePage	0x00000800	//	港股交易

#define	ReportNewInfoPage	0x00001000	//	资讯中心
#define ReportCFT           0x00001001  //  东莞iPad财富通 add by xyt  20130925
#define ReportTQ            0x00001010  //  TQ功能        add by xyt  20130925
#define	ReportHotInfoPage	0x00002000	//	热门关注
#define	ReportServicePage	0x00004000	//	服务中心
#define ReportWebInfo       0x00004001  //  公告信息
#define	ReportDPIndexPage	0x00008000	//	大盘指数

#define	ReportETHeper       0x00001002	//	ET助手 add by zxl 20131128
#define	ReportLCDT          0x00001003	//	理财大厅
#define	ReportGTZXInfo      0x00001004	//	国泰资讯
#define ReportWSTInfoPage   0x00001005	//  维赛特研究报告
#define ReportWSTZaoCan     0x00001006  //  维赛特早餐
#define ReportWSTGongl      0x00001007  //  维赛特攻略

#define	ReportTSInfoPage	0x00010000	//	财富泰山
#define ReportTZTMessage    0x00010008  //  投资快递
#define ReportTZTChaoGen    0x00010013  //  我的炒跟
#define YYTMapInfoPage		0x00020000	//	营业厅地图
#define ReportJJMarketPage	0x00040000	//	基金市场
#define ZXKFPage			0x00080000	//	在线客服


/*iphone版本底部显示*/
#define tztAllPage          0x00010000  //ALL 所有的列都可以添加
#define tztHomePage         0x00010001  //首页
#define tztMarketPage       0x00010002  //行情
#define tztInfoPage         0x00010003  //咨询
#define tztTradePage        0x00010004  //交易
#define tztMorePage         0x00010005  //更多
#define tztServicePage      0x00010006  //服务（网页）
#define tztServicePageLocal    0x00010016  //服务（本地）
#define tztServicePageEx    0x00010026
#define tztPopPage          0x00010007  //pop
//页面类别
typedef enum tztuivckind
{
    tztvckind_All = tztAllPage,           // 主页
    tztvckind_Main = tztHomePage,           // 主页
	tztvckind_HQ = tztMarketPage,           // 行情
	tztvckind_ZX = tztInfoPage,             // 资讯
	tztvckind_JY = tztTradePage,            // 交易
    tztvckind_Set = tztServicePage,         // 设置
    tztvckind_SetEx = tztServicePageLocal,
    tztvckind_Pop = tztPopPage,             // popvc
}tztuivckind;

#define AJAX_MENU_CloseCurWeb             (1964)//web 关闭当前页面  1964
#define AJAX_MENU_CloseAllWeb             (3413)//web 关闭页面  3413

#define menu_BEGIN						1600
//分时指标 1700===============================================
#define  IDM_MENU_TREND_BEGIN			(menu_BEGIN + 100)//分时指标起始 1700

//分时Level指标 1800===============================================
#define  IDM_MENU_TrendLevel			(IDM_MENU_TREND_BEGIN + 100)//分时Level2指标起始 1800
#define  IDM_MENU_TREND_END				(IDM_MENU_TrendLevel + 100)//分时指标结束 1900

//技术指标 1900===============================================
#define  IDM_MENU_TechZBBEGIN			(IDM_MENU_TREND_END)//技术指标起始 1900

#define  PKLINE                         (IDM_MENU_TechZBBEGIN + 0)
#define  VOL							(IDM_MENU_TechZBBEGIN + 1)
#define  MACD							(IDM_MENU_TechZBBEGIN + 2)
#define  DMI							(IDM_MENU_TechZBBEGIN + 3)
#define  DMA							(IDM_MENU_TechZBBEGIN + 4)
#define  TRIX							(IDM_MENU_TechZBBEGIN + 5)
#define  BRAR							(IDM_MENU_TechZBBEGIN + 6)
#define  VR								(IDM_MENU_TechZBBEGIN + 7)
#define  OBV							(IDM_MENU_TechZBBEGIN + 8)
#define  ASI							(IDM_MENU_TechZBBEGIN + 9)
#define  EMV							(IDM_MENU_TechZBBEGIN + 10)
#define  WVAD							(IDM_MENU_TechZBBEGIN + 11)
#define  RSI							(IDM_MENU_TechZBBEGIN + 12)
#define  WR								(IDM_MENU_TechZBBEGIN + 13)
#define  KDJ							(IDM_MENU_TechZBBEGIN + 14)
#define  CCI							(IDM_MENU_TechZBBEGIN + 15)
#define  ROC							(IDM_MENU_TechZBBEGIN + 16)
#define  BOLL							(IDM_MENU_TechZBBEGIN + 17)
#define  BIAS                           (IDM_MENU_TechZBBEGIN + 18)
#define  MACDEND						(IDM_MENU_TechZBBEGIN + 18) //结束
#define  EXPMA                          (IDM_MENU_TechZBBEGIN + 19)
#define  TZTCR                           (IDM_MENU_TechZBBEGIN + 20)
#define  SAR                            (IDM_MENU_TechZBBEGIN + 21)
#define  MIKE                           (IDM_MENU_TechZBBEGIN + 22)
#define  ZJZS                           (IDM_MENU_TechZBBEGIN + 23)
#define  YCWW                           (IDM_MENU_TechZBBEGIN + 24)

#define ID_MENU_ACTION                  menu_BEGIN + 1500   //3100
#define ID_MENU_AJAXTEST                (ID_MENU_ACTION + 1) //3101 Ajax测试
#define ID_MENU_ACTION_Trade            (ID_MENU_ACTION + 2) //3102 交易

#define ID_MENU_BEGIN                   menu_BEGIN + 1600   //3200

#define HQ_MENU_BEGIN                   ID_MENU_BEGIN
#define HQ_ROOT                         HQ_MENU_BEGIN       //首页

#define HQ_MENU_Report                  (HQ_MENU_BEGIN + 1)//排名
#define HQ_MENU_UserStock               (HQ_MENU_BEGIN + 2)//自选
#define HQ_MENU_IndexTrend              (HQ_MENU_BEGIN + 3)//大盘
#define HQ_MENU_RecentBrowse            (HQ_MENU_BEGIN + 4)//最近浏览
#define HQ_MENU_GlobalMarket            (HQ_MENU_BEGIN + 5)//国际指数
#define HQ_MENU_HotBlock                (HQ_MENU_BEGIN + 6)//热门关注
#define HQ_MENU_Online                  (HQ_MENU_BEGIN + 7)//在线客服
#define HQ_MENU_Hudong                  (HQ_MENU_BEGIN + 8)//互动社区
#define HQ_MENU_Message                 (HQ_MENU_BEGIN + 9)//投资快递
#define HQ_MENU_Inbox                   (HQ_MENU_BEGIN + 10)//收件箱
#define HQ_MENU_Collect                 (HQ_MENU_BEGIN + 11)//收藏
#define HQ_MENU_MarketMenu              (HQ_MENU_BEGIN + 12)//
#define HQ_MENU_HKMarket                (HQ_MENU_BEGIN + 13)//港股市场
#define HQ_MENU_QHMarket                (HQ_MENU_BEGIN + 14)//期货市场
#define HQ_MENU_HomePage                (HQ_MENU_BEGIN + 15)//返回首页（华西）
#define HQ_MENU_TztPushInfo             (HQ_MENU_BEGIN + 16)//推送详细信息
#define HQ_MENU_TztTelPhone             (HQ_MENU_BEGIN + 17)//拨打电话
#define HQ_MENU_CYBlock                 (HQ_MENU_BEGIN + 18)//创业板
#define HQ_MENU_JPInfo                  (HQ_MENU_BEGIN + 19)//精品资讯
#define HQ_MENU_HSMarket                (HQ_MENU_BEGIN + 20)//沪深市场
#define HQ_MENU_GTJAYYKH                (HQ_MENU_BEGIN + 21)//国泰预约开户
#define HQ_MENU_GTJAYYBDW               (HQ_MENU_BEGIN + 22)//国泰营业部定位
#define HQ_MENU_GTETHelper              (HQ_MENU_BEGIN + 23)//国泰ET助手
#define HQ_MENU_ChaoGen                 (HQ_MENU_BEGIN + 24)//自营炒跟
#define HQ_MENU_ChaoGenEx               (HQ_MENU_BEGIN + 25)
#define HQ_MENU_ChaoGenKLine            (HQ_MENU_BEGIN + 26)//炒跟K线界面
#define HQ_MENU_ChaoGenSet              (HQ_MENU_BEGIN + 27)
#define HQ_MENU_Personal                (HQ_MENU_BEGIN + 28)//个人中心
#define HQ_MENU_ChooseStock             (HQ_MENU_BEGIN + 29)//模型选股
#define HQ_MENU_OpenNewWebURL           (HQ_MENU_BEGIN + 30)//通用新接口


#define HQ_MENU_OutFund                 (HQ_MENU_BEGIN + 50)//场外基金行情

#define HQ_MENU_Trend                   (HQ_MENU_BEGIN + 100)//分时
#define HQ_MENU_KLine                   (HQ_MENU_BEGIN + 101)//K线
#define HQ_MENU_SearchStock             (HQ_MENU_BEGIN + 102)//个股查询
#define HQ_MENU_EditUserStock           (HQ_MENU_BEGIN + 103)//编辑自选
#define HQ_MENU_UploadUserStock         (HQ_MENU_BEGIN + 104)//上传自选
#define HQ_MENU_DownloadUserStock       (HQ_MENU_BEGIN + 105)//下载自选
#define HQ_MENU_MergeUserStock          (HQ_MENU_BEGIN + 106)//合并自选
#define HQ_MENU_Online_All              (HQ_MENU_BEGIN + 107)//全部提问
#define HQ_MENU_Online_My               (HQ_MENU_BEGIN + 108)//我的提问
#define HQ_MENU_Online_Hot              (HQ_MENU_BEGIN + 109)//客服热线
#define HQ_Menu_More                    (HQ_MENU_BEGIN + 110)//更多
#define HQ_MENU_HoriTrend               (HQ_MENU_BEGIN + 111)//横屏分时
#define HQ_MENU_HoriTech                (HQ_MENU_BEGIN + 112)//横屏K线
#define HQ_MENU_UserInfo                (HQ_MENU_BEGIN + 113)//用户信息
#define HQ_MENU_Online_CJWT              (HQ_MENU_BEGIN + 114)//常见问题


#define HQ_MENU_HisTrend                (HQ_MENU_BEGIN + 200)//历史分时

#define HQ_Return                       (HQ_MENU_BEGIN + 399)//返回
#define HQ_MENU_END                     (HQ_MENU_BEGIN + 400)

#define HQ_MENU_Info                    HQ_MENU_END//资讯

#define HQ_MENU_Info_Center             (HQ_MENU_Info + 1)//资讯中心
#define HQ_MENU_Info_Content            (HQ_MENU_Info + 2)//打开选中的资讯
#define HQ_MENU_Info_Pre                (HQ_MENU_Info + 3)//上一条
#define HQ_MENU_Info_Next               (HQ_MENU_Info + 4)//下一条
#define HQ_MENU_Info_TBF10              (HQ_MENU_Info + 5)//图表f10
#define HQ_MENU_Info_CJCenter           (HQ_MENU_Info + 6)//财经中心
#define HQ_MENU_Info_F10                (HQ_MENU_Info + 7)//f10
#define HQ_MENU_Info_F9                 (HQ_MENU_Info + 8)//f9
#define HQ_MENU_Info_MsgCenter          (HQ_MENU_Info + 9)//消息中心
#define HQ_MENU_Info_Url                (HQ_MENU_Info + 10)//公告信息


#define HQ_MENU_Info_End                (HQ_MENU_Info + 100)//3700

#define HQ_MENU_YUJING                  (HQ_MENU_Info_End + 1)//预警
#define HQ_MENU_MNJY                    (HQ_MENU_Info_End + 2)//模拟交易
//#define HQ_MENU_END                     (HQ_MENU_BEGIN + 600)

#define ID_MENU_Stock_TRADE             (HQ_MENU_BEGIN + 600) //3800
//	委托
#define	WT_LOGIN			(ID_MENU_Stock_TRADE + 1)	//	委托交易账号登录
#define	WT_OUT              (ID_MENU_Stock_TRADE + 2)	//	委托登出
#define	WT_BUY              (ID_MENU_Stock_TRADE + 3)	//	委托买入
#define	WT_SALE             (ID_MENU_Stock_TRADE + 4)	//	委托卖出
#define	WT_WITHDRAW         (ID_MENU_Stock_TRADE + 5)	//	委托撤单
#define	WT_QUERY			(ID_MENU_Stock_TRADE + 6)	//	委托查询
#define	WT_PWD              (ID_MENU_Stock_TRADE + 7)	//	委托密码维护  dsw 改用统一密码维护
#define WT_BANKTODEALER		(ID_MENU_Stock_TRADE + 8)   //  卡转证券
#define WT_DEALERTOBANK		(ID_MENU_Stock_TRADE + 9)	//	证券转卡
#define WT_TRANSHISTORY		(ID_MENU_Stock_TRADE + 10)	//	转账流水
#define WT_QUERYBALANCE		(ID_MENU_Stock_TRADE + 11)	//	查询余额
#define WT_TICKETBUY        (ID_MENU_Stock_TRADE + 12)	//	行权买入
#define WT_BUYSALE			(ID_MENU_Stock_TRADE + 13)	//	快速下单

#define WT_ZIJinAndStock    (ID_MENU_Stock_TRADE + 14)	//	资金股票
#define WT_YinZhenAndZhuanZ (ID_MENU_Stock_TRADE + 15)	//	银证转账，转账查询
#define WT_LiShiQuery       (ID_MENU_Stock_TRADE + 16)	//	历史查询：历史成交，交割单，对账单,配号查询
#define WT_XiuGaiInfo       (ID_MENU_Stock_TRADE + 17)	//	修改交易密码，修改资金密码，设置服务密码，查看/修改联系人信息
#define WT_JiaoYi           (ID_MENU_Stock_TRADE + 18)	//  列表 交易界面

#define HQ_QUERYMYChiCange  (ID_MENU_Stock_TRADE + 19) //查询持仓

#define	WT_FUNDSEARCH		(ID_MENU_Stock_TRADE + 20)	//	委托查询资金 WT_FUNDSEARCH
//	委托-查询
#define	WT_QUERYFUNE		(ID_MENU_Stock_TRADE + 21)	//	委托查询资金
#define	WT_QUERYGP			(ID_MENU_Stock_TRADE + 22)	//	委托查询股票
#define	WT_QUERYDRWT		(ID_MENU_Stock_TRADE + 23)	//	委托查询当日委托
#define	WT_QUERYDRCJ		(ID_MENU_Stock_TRADE + 24)	//	委托查询当日成交
#define	WT_QUERYGDZL		(ID_MENU_Stock_TRADE + 25)	//	委托查询股东资料
#define	WT_QUERYLSCJ		(ID_MENU_Stock_TRADE + 26)	//	委托查询历史成交
#define	WT_QUERYPH			(ID_MENU_Stock_TRADE + 27)	//	委托查询配号
#define	WT_QUERYLS			(ID_MENU_Stock_TRADE + 28)	//	委托查询流水
#define WT_QUERYJG			(ID_MENU_Stock_TRADE + 29)	//	委托查询交割
#define WT_CHANGESTOCK		(ID_MENU_Stock_TRADE + 30)	//	委托换股

#define WT_ChangeDealPW     (ID_MENU_Stock_TRADE + 31) //修改交易密码
#define WT_ChangeMoneyPW    (ID_MENU_Stock_TRADE + 32) //修改资金密码
#define WT_ServicePW        (ID_MENU_Stock_TRADE + 33) //修改服务密码
#define WT_ModifySelfInfo   (ID_MENU_Stock_TRADE + 34) //修改个人基本信息 185
#define WT_FundTrade        (ID_MENU_Stock_TRADE + 35) //修改基金交易

#define WT_RELOGIN          (ID_MENU_Stock_TRADE + 36) //退出后重新登录
#define WT_LOGINToken		(ID_MENU_Stock_TRADE + 37) //国泰令牌处理
#define WT_RZRQList         (ID_MENU_Stock_TRADE + 38)      //融资融券列表       3838

#define WT_DBPToXY			(ID_MENU_Stock_TRADE + 39)	//担保品转信用	3839
#define WT_UserInfo         (ID_MENU_Stock_TRADE + 40)  //个人信息查看
#define WT_YZZZList         (ID_MENU_Stock_TRADE + 41)  //银证转账列表 3841

#define WT_AddAccount       (ID_MENU_Stock_TRADE + 42)  //预设账号 3842
/*多方存管功能3814 － 3820*/
#define WT_DFBankTradeBegin		(ID_MENU_Stock_TRADE + 43)		//多账号交易功能开始

#define WT_DFCGList             (ID_MENU_Stock_TRADE + 43)      //多存管列表

#define WT_GuiJiResult          (ID_MENU_Stock_TRADE + 44)	    //	资金归集        3844
#define WT_NeiZhuan             (ID_MENU_Stock_TRADE + 45)	    //	内转数据        3845
#define WT_NeiZhuanResult       (ID_MENU_Stock_TRADE + 46)	    //	查询流水        3846
#define WT_DFBANKTODEALER		(ID_MENU_Stock_TRADE + 47)		//  卡转证券        3847
#define WT_DFDEALERTOBANK		(ID_MENU_Stock_TRADE + 48)		//	证券转卡        3848
#define WT_DFTRANSHISTORY		(ID_MENU_Stock_TRADE + 49)		//	转账流水        3849
#define WT_DFQUERYBALANCE		(ID_MENU_Stock_TRADE + 50)		//	查询余额        3850
#define WT_DFQUERYHISTORYEx     (ID_MENU_Stock_TRADE + 51)      //  计划转账流水     3851
#define WT_DFQUERYDRNZ          (ID_MENU_Stock_TRADE + 52)      //  当日资金划转查询  3852
#define WT_DFQUERYNZLS          (ID_MENU_Stock_TRADE + 53)      //  历史资金划转查询  3853

#define WT_DFBankTradeEnd		(ID_MENU_Stock_TRADE + 60)		//多账号交易功能结束

#define WT_TSProtocal           (ID_MENU_Stock_TRADE + 70)      //退市协议 3870
#define WT_DZHTQS           (ID_MENU_Stock_TRADE + 71)	//	电子合同签署    3871
#define WT_DZHTFXCP			(ID_MENU_Stock_TRADE + 72)	//	风险测评       3872
#define WT_QXSetting        (ID_MENU_Stock_TRADE + 73)  //  权限设置       3873

#define WT_LiShiDZD         (ID_MENU_Stock_TRADE + 80)//对账单
#define WT_ZiChanZZ         (ID_MENU_Stock_TRADE + 81)//资产总值

#define	ID_WT_SBJYBEGIN     (ID_MENU_Stock_TRADE +100)	//三板功能	3900
#define WT_SBList           (ID_MENU_Stock_TRADE +100)  //三板功能列表 3900
#define WT_SBYXBUY			(ID_WT_SBJYBEGIN + 1) //三板意向买入 3901
#define WT_SBYXSALE			(ID_WT_SBJYBEGIN + 2) //三板意向卖出 3902
#define WT_SBQRBUY			(ID_WT_SBJYBEGIN + 3) //三板确认买入 3903
#define WT_SBQRSALE			(ID_WT_SBJYBEGIN + 4) //三板确认卖出 3904
#define WT_SBDJBUY			(ID_WT_SBJYBEGIN + 5) //三板定价买入 3905
#define WT_SBDJSALE			(ID_WT_SBJYBEGIN + 6) //三板定价卖出 3906

#define WT_SBWITHDRAW		(ID_WT_SBJYBEGIN + 7) //三板查撤委托 3907
#define WT_QUERYSBDRWT		(ID_WT_SBJYBEGIN + 8) //三板当日委托 3908
#define WT_QUERYSBHQ		(ID_WT_SBJYBEGIN + 9) //三板行情 3909
#define WT_QUERYSBDRCJ      (ID_WT_SBJYBEGIN + 10)//三板报价转让成交查询 3910 347

#define	ID_WT_SBJYEND		(ID_WT_SBJYBEGIN + 20)	//三板功能结束	3920

#define	ID_WT_RZRQBEGIN     (ID_WT_SBJYEND )	//融资融券功能	3920
#define WT_JYRZRQ           (ID_WT_RZRQBEGIN + 1) //融资融券列表    3921
#define WT_RZRQBUY			(ID_WT_RZRQBEGIN + 2) //融资融券普通买入 3922   400
#define WT_RZRQSALE			(ID_WT_RZRQBEGIN + 3) //融资融券普通卖出 3923
#define WT_RZRQRZBUY		(ID_WT_RZRQBEGIN + 4) //融资融券融资买入 3924
#define WT_RZRQRQSALE		(ID_WT_RZRQBEGIN + 5) //融资融券融券卖出 3925
#define WT_RZRQBUYRETURN	(ID_WT_RZRQBEGIN + 6) //融资融券买券还券 3926
#define WT_RZRQSALERETURN	(ID_WT_RZRQBEGIN + 7) //融资融券卖券还款 3927
#define WT_RZRQFUNDRETURN	(ID_WT_RZRQBEGIN + 8) //直接还款 3928    421
#define WT_RZRQSTOCKRETURN	(ID_WT_RZRQBEGIN + 9) //直接还券 3929    422
#define WT_RZRQSTOCKHZ		(ID_WT_RZRQBEGIN + 10) //担保品划转 3930    430


#define WT_RZRQWITHDRAW			(ID_WT_RZRQBEGIN + 11) //融资融券查撤委托 3931   401
#define	WT_RZRQQUERYFUNE		(ID_WT_RZRQBEGIN + 12)	//	委托查询资金	3932	402
#define	WT_RZRQQUERYGP			(ID_WT_RZRQBEGIN + 13)	//	委托查询股票     3933 403
#define	WT_RZRQQUERYDRWT		(ID_WT_RZRQBEGIN + 14)	//	委托查询当日委托   3934 404
#define	WT_RZRQQUERYDRCJ		(ID_WT_RZRQBEGIN + 15)	//	委托查询当日成交  3935 405
#define	WT_RZRQQUERYZCFZ		(ID_WT_RZRQBEGIN + 16)	//	委托查询资产负债	3936 406
#define	WT_RZRQQUERYRZQK		(ID_WT_RZRQBEGIN + 17)	//	委托查询融资情况   3937   407
#define	WT_RZRQQUERYRQQK		(ID_WT_RZRQBEGIN + 18)	//	委托查询融券情况  3938 408
#define	WT_RZRQQUERYLS			(ID_WT_RZRQBEGIN + 19)	//	委托查询资金流水  3939 411
#define WT_RZRQQUERYJG			(ID_WT_RZRQBEGIN + 20)	//	委托查询交割     3940 412
#define WT_RZRQQUERYHZLS		(ID_WT_RZRQBEGIN + 21)	//	委托查询划转流水  3941   413
#define WT_RZRQQUERYDBP			(ID_WT_RZRQBEGIN + 22)	//	委托查询担保品     3942 414
#define WT_RZRQQUERYCANBUY	    (ID_WT_RZRQBEGIN + 23)	//	委托查询可融资买入标的券  3943    415
#define WT_RZRQQUERYCANSALE		(ID_WT_RZRQBEGIN + 24)	//	委托查询可融券卖出标的券   3944  416

#define WT_RZRQQUERYRZFZ		(ID_WT_RZRQBEGIN + 25)	//	委托查询融资负债   3945  417
#define WT_RZRQQUERYRQFZ		(ID_WT_RZRQBEGIN + 26)	//	委托查询融券负债    3946 418
#define WT_RZRQQUERYFZLS		(ID_WT_RZRQBEGIN + 27)	//	委托查询负债变动流水  3947   419
#define WT_RZRQQUERYNOJY		(ID_WT_RZRQBEGIN + 28)	//	委托查询非交易过户委托  3948   420
#define WT_RZRQSTOCKXQ			(ID_WT_RZRQBEGIN + 29)	//	行权  3949   431

#define WT_RZRQBANKTODEALER		(ID_WT_RZRQBEGIN + 30) //  卡转证券  3950  425
#define WT_RZRQDEALERTOBANK		(ID_WT_RZRQBEGIN + 31)	//	证券转卡  3951  425
#define WT_RZRQTRANSHISTORY		(ID_WT_RZRQBEGIN + 32)	//	转账流水  3952  426
#define WT_RZRQQUERYBALANCE		(ID_WT_RZRQBEGIN + 33)	//	查询余额  3953  427
#define WT_RZRQTICKETBUY        (ID_WT_RZRQBEGIN + 34)	//	行权买入  3954  424

#define WT_RZRQNOWSTOCKRETURN	(ID_WT_RZRQBEGIN + 35)	//	现券还券	 3955	 ［
#define WT_RZRQVOTING			(ID_WT_RZRQBEGIN + 36)	//	投票	     3956	440
#define WT_RZRQQUERYContract	(ID_WT_RZRQBEGIN + 37)	//	合同查询	 3957	455
#define WT_RZRQQUERYBZJ			(ID_WT_RZRQBEGIN + 38)	//	保证金查询 3958	456
#define WT_RZRQQUERYBDQ			(ID_WT_RZRQBEGIN + 39)	//	查询标的券 3959	448
#define WT_RZRQQUERYDRLS		(ID_WT_RZRQBEGIN + 40)	//	查询当日资金流水	3960 411
#define WT_RZRQQUERYDRFZLS		(ID_WT_RZRQBEGIN + 41)	//	查询当日负债流水  3961		454
#define WT_RZRQQUERYLSCJ		(ID_WT_RZRQBEGIN + 42)	//	查询历史成交		3962	433
#define WT_RZRQQUERYDZD			(ID_WT_RZRQBEGIN + 43)	//	查询对账单		3963	463
#define WT_RZRQChangePW			(ID_WT_RZRQBEGIN + 44)	//	修改密码			3964	432
#define WT_RZRQQUERYLSWT        (ID_WT_RZRQBEGIN + 45)  //历史委托           3965       446
#define WT_RZRQQUERYXYZC        (ID_WT_RZRQBEGIN + 46)  //信用资产           3966   437
#define WT_RZRQQUERYXYGF        (ID_WT_RZRQBEGIN + 47)  //信用股份           3967   438
#define WT_RZRQQUERYXYSX        (ID_WT_RZRQBEGIN + 48)  //信用上限           3968   442
#define WT_RZRQGDLB             (ID_WT_RZRQBEGIN + 49)  //股东列表           3969   441
#define WT_RZRQYPC              (ID_WT_RZRQBEGIN + 50)  //信用合约已平仓      3970     445
#define WT_RZRQWPC              (ID_WT_RZRQBEGIN + 51)  //信用合约未平仓      3971     444
#define WT_RZRQQUERYWITHDRAW    (ID_WT_RZRQBEGIN + 52)  //融资融券撤单查询    3972      404
#define WT_RZRQDBPBL            (ID_WT_RZRQBEGIN + 53)  //担保品比率查询       3973    472
#define WT_RZRQZJLSHis          (ID_WT_RZRQBEGIN + 54)  //资金流水历史       3974    434
#define WT_RZRQWITHDRAWHZ       (ID_WT_RZRQBEGIN + 55)  //划转撤单          3975    413

#define WT_RZRQLogin       (ID_WT_RZRQBEGIN + 78)   //融资融券登录 3998
#define WT_RZRQOut         (ID_WT_RZRQBEGIN + 79)   //融资融券退出 3999
#define	ID_WT_RZRQEND     (ID_WT_RZRQBEGIN + 80)	//融资融券功能	4000

#define	WT_FUND_TRADE           (ID_MENU_Stock_TRADE + 200)	//	基金交易        4000
#define	WT_JJRGFUND             (WT_FUND_TRADE +  1)	    //	基金认购(144):
#define	WT_JJAPPLYFUND          (WT_FUND_TRADE +  2)	    //	基金申购(139):
#define	WT_JJREDEEMFUND         (WT_FUND_TRADE +  3)	    //	基金赎回(140):
#define	WT_JJRGFUNDEX           (WT_FUND_TRADE +  4)	    //	场内基金认购(146):
#define	WT_JJAPPLYFUNDEX        (WT_FUND_TRADE +  5)	    //	场内基金申购(147):
#define	WT_JJREDEEMFUNDEX       (WT_FUND_TRADE +  6)	    //	场内基金赎回(148):
#define	WT_JJINQUIREENTRUST     (WT_FUND_TRADE +  7)	    //	当日委托(134):
#define	WT_JJWITHDRAW           (WT_FUND_TRADE +  8)	    //	撤销委托(141):
#define	WT_INQUIREFUNDEX        (WT_FUND_TRADE +  9)	    //	基金查询(145):
#define	WT_JJINQUIRECJ          (WT_FUND_TRADE + 10)	    //	历史成交(136):
#define	WT_JJINQUIREGUFEN       (WT_FUND_TRADE + 11)	    //	持仓基金(137):
#define	WT_JJINCHAXUNACCOUNT    (WT_FUND_TRADE + 12)	    //	已开户基金(149):
#define	WT_JJINZHUCEACCOUNT     (WT_FUND_TRADE + 13)	    //	基金开户(153): 新开户
#define	WT_JJINZHUCEACCOUNTEx   (WT_FUND_TRADE + 14)	    //	基金开户开户

#define	WT_JJFHTypeChange       (WT_FUND_TRADE + 15)	    //	基金分红方式设置 142
//#define	WT_JJFHTypeChangeEx     (WT_FUND_TRADE + 16)	    //	紫金理财分红方式设置
//#define	WT_JJZJLCMessage        (WT_FUND_TRADE + 17)	    //	紫金理财净值短信订阅
//#define	WT_JJZJLCChaXunAccount  (WT_FUND_TRADE + 18)	    //	紫金理财账号查询
//#define	WT_JJZJLCChangeFindPW   (WT_FUND_TRADE + 19)	    //	紫金理财查询密码修改
#define	WT_JJINQUIREWT          (WT_FUND_TRADE + 20)	    //	历史委托(135):

#define	WT_JJINQUIRETrans       (WT_FUND_TRADE + 21)	    //	基金转换(135):
#define WT_JJSplitAndMerge		(WT_FUND_TRADE + 22)		//	基金拆分合并
#define WT_JJINQUIREDT			(WT_FUND_TRADE + 23)		//	已定投基金查询
#define WT_JJZHUCEACCOUNTDT		(WT_FUND_TRADE + 24)		//	基金定投开户
#define WT_JJWWContactInquire	(WT_FUND_TRADE + 25)		//	外围电子合同查询
#define WT_JJWWContactSign		(WT_FUND_TRADE + 26)		//	外围电子合同签署
#define WT_JJWWCashProdAccInquire (WT_FUND_TRADE + 27)		//	外围基金现金产品账号查询
#define WT_JJWWCashProdAccSet	(WT_FUND_TRADE + 28)		//	外围基金现金产品账号设置
#define WT_JJWWPlansTransSign	(WT_FUND_TRADE + 29)		//	定时定额转让签约
#define WT_JJWWPlansTransQuery	(WT_FUND_TRADE + 30)		//	定式定额转让查询
#define WT_JJWWCashProdAccContarcted	(WT_FUND_TRADE + 31)	//	查询已签约茶品
#define WT_JJRiskSign			(WT_FUND_TRADE + 32)		//基金风险测评
#define WT_JJRevealsSign		(WT_FUND_TRADE + 33)		//基金风险揭示书签署
#define WT_JJRegist             (WT_FUND_TRADE + 34)        //基金开户（开户提示书显示确认）
#define	WT_JJFHTypeChangeD      (WT_FUND_TRADE + 35)	    //	进入基金分红方式设置 142
#define WT_JJZHSGFUND           (WT_FUND_TRADE + 36)        //  组合申购
#define WT_JJZHSHFUND           (WT_FUND_TRADE + 37)        //  组合赎回
#define WT_JJSEARCHDT           (WT_FUND_TRADE + 38)        //  查询可定投基金 616
#define WT_JJDTModify           (WT_FUND_TRADE + 39)        //  已定投基金编辑
#define WT_JJZHSGSearch         (WT_FUND_TRADE + 40)        //  组合基金查询
#define WT_JJZHSGCreate         (WT_FUND_TRADE + 41)        //  组合申购生成清单
#define WT_JJZHInfo             (WT_FUND_TRADE + 42)        //  组合说明
#define WT_JJGSINQUIRE          (WT_FUND_TRADE + 43)        //	基金公司查询 145

#define WT_JJPHInquireCJ        (WT_FUND_TRADE + 44)        //  基金盘后当日成交查询635 LOF当日成交查询
#define WT_JJPHInquireHisEntrust (WT_FUND_TRADE + 45)       //  基金盘后历史委托查询636LOF历史委托
#define WT_JJPHInquireEntrust   (WT_FUND_TRADE + 46)        //  基金盘后当日委托查询637 LOF当日委托
#define WT_JJPHWithDraw         (WT_FUND_TRADE + 47)        //  基金盘后业务撤单638 LOF撤单
#define WT_JJInquireLevel       (WT_FUND_TRADE + 48)        //  基金客户风险等级查询189

#define WT_JJLCRGFUND           (WT_FUND_TRADE + 49)        //理财认购
#define WT_JJLCAPPLYFUND        (WT_FUND_TRADE + 50)        //理财申购
#define WT_JJLCREDEEMFUND       (WT_FUND_TRADE + 51)        //理财赎回  理财退出
#define WT_JJLCWithDraw         (WT_FUND_TRADE + 52)        //理财撤单
#define WT_JJLCFEInquire        (WT_FUND_TRADE + 53)        //理财份额查询
#define WT_JJLCDRWTInquire      (WT_FUND_TRADE + 54)        //理财当日委托查询
#define WT_JJINQUIRETransCX     (WT_FUND_TRADE + 55)        //基金转换查询  新界面
#define WT_JJPCKM               (WT_FUND_TRADE + 56)        //评测可购买基金  基金客户可购买基金查询

//基金定投
#define WT_JJWWInquire          (WT_FUND_TRADE + 57)        //基金外围定投查询553
#define WT_JJWWOpen             (WT_FUND_TRADE + 58)        //基金外围定投开户551
#define WT_JJWWCancel           (WT_FUND_TRADE + 59)        //基金外围定投销户552
#define WT_JJWWModify           (WT_FUND_TRADE + 60)        //基金外围定投修改

#define WT_JJJYSSG              (WT_FUND_TRADE + 61)        //交易所申购
#define WT_JJJYSSH              (WT_FUND_TRADE + 62)        //交易所赎回

#define WT_JJLCCPDM             (WT_FUND_TRADE + 63)        //集合计划基金代码查询352 理财产品代码
#define WT_JJPHInquireHisCJ     (WT_FUND_TRADE + 64)        //基金盘后历史成交查询634  LOF历史成交查询
#define WT_JJDRCJ               (WT_FUND_TRADE + 65)        //基金当日成交639
#define WT_JJInquireRGFund      (WT_FUND_TRADE + 66)        //查询可认购基金信息664
#define WT_JJInquireSGFund      (WT_FUND_TRADE + 67)        //查询可申购基金信息665

#define WT_JJJingZhi            (WT_FUND_TRADE + 68)        //  基金净值

#define WT_JJINZHUCEACCOUNTExSpecial      (WT_FUND_TRADE + 69)        //  基金开户特殊处理(国泰基金开户要先给提示)


#define WT_JJList               (WT_FUND_TRADE + 199)       //基金交易列表    4199
#define WT_FUND_TRADE_End		   (WT_FUND_TRADE + 200)        //	基金交易        //4200

#define WT_ETF_TRADE_BEGIN      (WT_FUND_TRADE_End + 100)       //4300
#define WT_ETFList              (WT_FUND_TRADE_End + 100)       //etf列表 4300
#define WT_ETFCrashRG           (WT_ETF_TRADE_BEGIN + 1)        //网下现金认购
#define WT_ETFStockRG           (WT_ETF_TRADE_BEGIN + 2)        //网下股票认购
#define WT_ETFXJRGCD            (WT_ETF_TRADE_BEGIN + 3)        //网下现金认购撤单
#define WT_ETFGPRGCD            (WT_ETF_TRADE_BEGIN + 4)        //网下股票认购撤单
#define WT_ETFCrashRGQuery      (WT_ETF_TRADE_BEGIN + 5)        //网下现金认购查询
#define WT_ETFStockRGQuery      (WT_ETF_TRADE_BEGIN + 6)        //网下股票认购查询
#define WT_ETF_HS_CrashRG       (WT_ETF_TRADE_BEGIN + 7)        //沪市现金认购
#define WT_ETF_HS_StockRG       (WT_ETF_TRADE_BEGIN + 8)        //沪市股票认购
#define WT_ETF_SS_GFRG          (WT_ETF_TRADE_BEGIN + 9)        //深市股份认购
#define WT_ETF_HS_XJCD          (WT_ETF_TRADE_BEGIN + 10)       //沪市现金撤单
#define WT_ETF_HS_GPCD          (WT_ETF_TRADE_BEGIN + 11)       //沪市股票撤单
#define WT_ETF_HS_CrashQUery    (WT_ETF_TRADE_BEGIN + 12)       //沪市现金查询
#define WT_ETF_HS_StockQuery    (WT_ETF_TRADE_BEGIN + 13)       //沪市股票查询
#define WT_ETF_SS_RGCD          (WT_ETF_TRADE_BEGIN + 14)       //深市认购撤单
#define WT_ETF_SS_RGQuery       (WT_ETF_TRADE_BEGIN + 15)       //深市认购查询

//货币基金
#define WT_ETFApplyFundRG       (WT_ETF_TRADE_BEGIN + 16)       //货币基金认购
#define WT_ETFApplyFundSG       (WT_ETF_TRADE_BEGIN + 17)       //货币基金(ETF)申购641
#define WT_ETFApplyFundSH       (WT_ETF_TRADE_BEGIN + 18)       //货币基金(ETF)赎回642
#define WT_ETFInquireEntrust    (WT_ETF_TRADE_BEGIN + 19)       //货币基金(ETF)当日委托查询
#define WT_ETFInquireHisEntrust (WT_ETF_TRADE_BEGIN + 20)       //货币基金(ETF)历史委托查询652
#define WT_ETFWithDraw          (WT_ETF_TRADE_BEGIN + 48)       //etf查撤委托
#define WT_ETF_HBJJList         (WT_ETF_TRADE_BEGIN + 49)       //货币基金列表
#define WT_ETF_TRADE_End        (WT_ETF_TRADE_BEGIN + 50)       //4350

#define WT_TTY_TRADE_BEGIN     (WT_FUND_TRADE_End + 200)//天天盈 4400
#define WT_TTYQSDZHeYue        (WT_TTY_TRADE_BEGIN + 1)//签署电子合约
#define WT_TTYLSCX             (WT_TTY_TRADE_BEGIN + 2)//电子合约流水查询
#define WT_TTYZTCX             (WT_TTY_TRADE_BEGIN + 3)//电子合约状态查询
#define WT_TTYDengJi           (WT_TTY_TRADE_BEGIN + 4)//天天盈登记      //现金增值计划登记
#define WT_TTYZEDuSet          (WT_TTY_TRADE_BEGIN + 5)//资金保留额度设置
#define WT_TTYZCPZTBG          (WT_TTY_TRADE_BEGIN + 6)//天天盈产品状态变更
#define WT_TTYYYQK             (WT_TTY_TRADE_BEGIN + 7)//预约取款
#define WT_TTYYYCD             (WT_TTY_TRADE_BEGIN + 8)//预约取款撤单
#define WT_TTYDJCX             (WT_TTY_TRADE_BEGIN + 9)//登记查询
#define WT_TTYFECX             (WT_TTY_TRADE_BEGIN + 10)//份额查询
#define WT_TTYJieYue           (WT_TTY_TRADE_BEGIN + 11)//天天盈解约

#define WT_CrashZZQuxiao       (WT_TTY_TRADE_BEGIN + 12)//现金增值计划取消
#define WT_CrashZZModify       (WT_TTY_TRADE_BEGIN + 13)//现金增值计划修改
#define WT_CrashZZYYQKEX       (WT_TTY_TRADE_BEGIN + 14)//预约取款
#define WT_CrashZZYYCDEX       (WT_TTY_TRADE_BEGIN + 15)//预约取款撤单

#define WT_TTY_TRADE_END        (WT_TTY_TRADE_BEGIN + 100)//天天盈结束 4500

#define WT_THB_Begin            (WT_TTY_TRADE_END)//天汇宝开始4500
#define WT_THB_NEWKHG           (WT_THB_Begin + 1)//新开回购 4501
#define WT_THB_YWSearch         (WT_THB_Begin + 2)//业务查询
#define WT_THB_BZXZ             (WT_THB_Begin + 3)//不再续做
#define WT_THB_DLWT             (WT_THB_Begin + 4)//代理委托
#define WT_THB_HYSearch         (WT_THB_Begin + 5)//合约查询
#define WT_THB_TQGH             (WT_THB_Begin + 6)//提前购回
#define WT_THB_TQGHYY           (WT_THB_Begin + 7)//提前购回预约
#define WT_THB_ZYQSearch        (WT_THB_Begin + 8)//质押券查询
#define WT_THB_List             (WT_THB_Begin + 9)//天汇宝功能列表

#define WT_THB_End              (WT_THB_Begin + 50)//天汇宝结束 4550

#define WT_MoreAccount_Login       (ID_MENU_Stock_TRADE + 996)
#define WT_RZRQ_IPAD               (ID_MENU_Stock_TRADE + 997)  //融资融券iPad登录
#define WT_TQ_IPAD                 (ID_MENU_Stock_TRADE + 998)  //东莞ipad TQ登录 add by xyt 20130925
#define WT_Trade_IPAD              (ID_MENU_Stock_TRADE + 999)  //4799//iPad委托交易点击跳转
#define ID_MENU_Stock_TRADE_End    (ID_MENU_Stock_TRADE + 1000) //4800



/*系统设置功能*/
#define Sys_Menu_Begin              (ID_MENU_Stock_TRADE_End + 1000)//5800
#define Sys_Menu_ServiceCenter      (Sys_Menu_Begin + 1)//服务中心 5801
#define Sys_Menu_HQSet              (Sys_Menu_Begin + 2)//行情设置 5802
#define Sys_Menu_KLineSet           (Sys_Menu_Begin + 3)//k线设置 5803
#define Sys_Menu_SysLogin           (Sys_Menu_Begin + 4)//系统登录 5804
#define Sys_Menu_SoftVersion        (Sys_Menu_Begin + 5)//版本信息 5805
#define Sys_Menu_MZTK               (Sys_Menu_Begin + 6)//免责条款 5806
#define Sys_Menu_SendToFriend       (Sys_Menu_Begin + 7)//好友推荐 5807
#define Sys_Menu_QueryYXQ           (Sys_Menu_Begin + 8)//查询有效期 5808
#define Sys_Menu_SoftCZ             (Sys_Menu_Begin + 9)//软件充值 5809
#define Sys_Menu_SetServer          (Sys_Menu_Begin + 10)//服务器设置 5810
#define Sys_Menu_ReRegist           (Sys_Menu_Begin + 11)//重新激活 5811
#define Sys_Menu_AddDelServer       (Sys_Menu_Begin + 12)//添加删除服务器 5812
#define Sys_Menu_Contact            (Sys_Menu_Begin + 13)//联系方式 5813
#define Sys_Menu_SysSetting         (Sys_Menu_Begin + 14)//设置中心 5814
#define Sys_Menu_CheckServer        (Sys_Menu_Begin + 15)//服务器测速 5815
#define Sys_Menu_TZProtect          (Sys_Menu_Begin + 16)//投资保护(东莞)5816
#define Sys_Menu_TZKDSetting        (Sys_Menu_Begin + 17)//投资快递设置5817
#define Sys_Menu_SystemSetting      (Sys_Menu_Begin + 18)//投资快递设置5817
#define Sys_Menu_End                (Sys_Menu_Begin + 1000)//6800


/*工具条按钮定义*/
#define TZTToolbar_Fuction_Begin    (Sys_Menu_End)  //6800

#define TZTToolbar_Fuction_OK        (TZTToolbar_Fuction_Begin + 1)//确定(6801)
#define TZTToolbar_Fuction_Refresh   (TZTToolbar_Fuction_Begin + 2)//刷新 6802
#define TZTToolbar_Fuction_Clear     (TZTToolbar_Fuction_Begin + 3)//清空 6803
#define TZTToolbar_Fuction_Switch    (TZTToolbar_Fuction_Begin + 4)//切换 6804
#define TZTToolbar_Fuction_Add       (TZTToolbar_Fuction_Begin + 5)//添加账号 6805
#define TZTToolbar_Fuction_Del       (TZTToolbar_Fuction_Begin + 6)//删除账号 6806
#define TZTToolbar_Fuction_WithDraw  (TZTToolbar_Fuction_Begin + 7)//撤单    6807
#define TZTToolbar_Fuction_Detail    (TZTToolbar_Fuction_Begin + 8)//详细 6808
#define TZTToolbar_Fuction_Pre       (TZTToolbar_Fuction_Begin + 9)//上条 6809
#define TZTToolbar_Fuction_Next      (TZTToolbar_Fuction_Begin + 10)//下条 6810
#define TZTToolbar_Fuction_FundKH    (TZTToolbar_Fuction_Begin + 11)//基金开户 6811
#define TZTToolbar_Fuction_FundFH    (TZTToolbar_Fuction_Begin + 12)//基金分红设置 6812
#define TZTToolbar_Fuction_FundDTXH  (TZTToolbar_Fuction_Begin + 13)//基金定投销户 6813
#define TZTToolbar_Fuction_FundXJCPQY (TZTToolbar_Fuction_Begin + 14)//基金现金产品账号签约6814
#define TZTToolbar_Fuction_FundXJCPJY (TZTToolbar_Fuction_Begin + 15)//基金现金产品账号解约6815
#define TZTToolbar_Fuction_FundDSDEJY (TZTToolbar_Fuction_Begin + 16)//基金定时定额转账参与解约6816
#define TZTToolbar_Fuction_BankGuiJi  (TZTToolbar_Fuction_Begin + 17)//资金归集6817
#define TZTToolbar_Fuction_QianShu  (TZTToolbar_Fuction_Begin + 18)//WEB 签署协议6818
#define TZTToolbar_Fuction_QuXiao  (TZTToolbar_Fuction_Begin + 19)//取消6819
#define TZTToolbar_Fuction_THB_YLJE  (TZTToolbar_Fuction_Begin + 20)//预留金额 6820
#define TZTToolbar_Fuction_Ask       (TZTToolbar_Fuction_Begin + 21)//在线提问 6821
#define TZTToolbar_Fuction_LeaveMessage       (TZTToolbar_Fuction_Begin + 22)//在线留言 6822

#define TZTToolbar_Fuction_End      (TZTToolbar_Fuction_Begin + 2000)//8800

/*********东莞 财富通 begin*************/
#define HQ_MENU_DGCFT                   (TZTToolbar_Fuction_End + 1)//东莞财富通      8801
#define CFT_ChiCang                     (TZTToolbar_Fuction_End + 2)//持仓消息
#define CFT_ChiCangInfo                 (TZTToolbar_Fuction_End + 3)//  持仓对应资讯
#define CFT_DaoHang                     (TZTToolbar_Fuction_End + 4)//营业部导航
#define CFT_LCY                         (TZTToolbar_Fuction_End + 5)//理财易
#define CFT_CCCP                        (TZTToolbar_Fuction_End + 6)//  持仓产品
#define CFT_SHCP                        (TZTToolbar_Fuction_End + 7)//  适合产品
//理财产品
#define WT_CFTJJDWRMFUND                (TZTToolbar_Fuction_End + 8)//热卖基金
#define WT_CFTJJDWDZDX                  (TZTToolbar_Fuction_End + 9)//东证代销
#define WT_CFTJJDWDTFUND                (TZTToolbar_Fuction_End + 10)//东莞定投
#define WT_CFTJJJHCP                    (TZTToolbar_Fuction_End + 11)//集合产品
#define CFT_DGY                         (TZTToolbar_Fuction_End + 12)//多股易
#define CFT_TQ                          (TZTToolbar_Fuction_End + 13)//tq
#define CFT_ZXInfo                      (TZTToolbar_Fuction_End + 14)
#define CFT_Refush                      (TZTToolbar_Fuction_End + 15)
#define CFT_YYBList                     (TZTToolbar_Fuction_End + 41)//营业部列表
#define CFT_YYBMoreInfo                 (TZTToolbar_Fuction_End + 42)//营业部详细信息
/*********东莞 财富通 end*************/


//各券商特有功能 注意 只有特有功能放该处，其他放通用功能处
/***************券商特有功能 50000 BEGIN**********************/
#define  TZT_MENU_QS_BEGIN				(50000) //50000  券商特有功能

//特有交易功能
/*货币基金 50000 ～ 50020*/
#define WT_HBJJ_Begin                   (TZT_MENU_QS_BEGIN) //50000
#define WT_HBJJ_List                    (WT_HBJJ_Begin + 1)//货币基金列表
#define WT_HBJJ_RG                      (WT_HBJJ_Begin + 2)//货币基金认购
#define WT_HBJJ_SG                      (WT_HBJJ_Begin + 3)//货币基金申购
#define WT_HBJJ_SH                      (WT_HBJJ_Begin + 4)//货币基金赎回
#define WT_HBJJ_WT                      (WT_HBJJ_Begin + 5)//货币基金查撤委托

#define WT_HBJJ_End                     (WT_HBJJ_Begin + 20)

/*报价回购 50020～50040*/
#define WT_BJHG_Begin                   (WT_HBJJ_End)       //50020
#define WT_BJHG_List                    (WT_BJHG_Begin + 1) //报价回购列表
#define WT_BJHG_Buy                     (WT_BJHG_Begin + 2) //报价回购买入(新开回购)
#define WT_BJHG_WTCX                    (WT_BJHG_Begin + 3) //报价回购委托查询
#define WT_BJHG_XXZZ                    (WT_BJHG_Begin + 4) //报价回购续作终止
#define WT_BJHG_TQGH                    (WT_BJHG_Begin + 5) //报价回购提前购回
#define WT_BJHG_YYTG                    (WT_BJHG_Begin + 6) //报价回购预约提前购回
#define WT_BJHG_WDQ                     (WT_BJHG_Begin + 7) //未到期查询
#define WT_BJHG_ZYMX                    (WT_BJHG_Begin + 8) //质押明晰
#define WT_BJHG_End                     (WT_BJHG_Begin + 20)//报价回购功能结束

/*质押回购 50040 ～ 50060*/
#define WT_ZYHG_Begin                   (WT_BJHG_End)   //50040
#define WT_ZYHG_List                    (WT_ZYHG_Begin + 1) //质押回购列表
#define WT_ZYHG_ZQRK                    (WT_ZYHG_Begin + 2) //债券入库
#define WT_ZYHG_ZQCK                    (WT_ZYHG_Begin + 3) //债券出库
#define WT_ZYHG_ZYMX                    (WT_ZYHG_Begin + 4) //质押明细查询
#define WT_ZYHG_RZHG                    (WT_ZYHG_Begin + 5) //融资回购
#define WT_ZYHG_RQHG                    (WT_ZYHG_Begin + 6) //融券回购
#define WT_ZYHG_WDQHG                   (WT_ZYHG_Begin + 7) //未到期回购查询
#define WT_ZYHG_BZQMX                   (WT_ZYHG_Begin + 8) //标准券明细查询
#define WT_ZYHG_End                     (WT_ZYHG_Begin + 20)//


/*多空如弈 50060～50080*/
#define WT_DKRY_Begin           (WT_ZYHG_End)   //50060
#define WT_DKRYList             (WT_DKRY_Begin + 1) //多空如弈列表
#define WT_DKRY_SG              (WT_DKRY_Begin + 2) //申购
#define WT_DKRY_SH              (WT_DKRY_Begin + 3) //赎回
#define WT_DKRY_MZKZ            (WT_DKRY_Begin + 4) //母转看涨
#define WT_DKRY_MZKD            (WT_DKRY_Begin + 5) //母转看跌
#define WT_DKRY_KZZM            (WT_DKRY_Begin + 6) //看涨转母
#define WT_DKRY_KDZM            (WT_DKRY_Begin + 7) //看跌转母
#define WT_DKRY_WTCD            (WT_DKRY_Begin + 8) //委托撤单
#define WT_DKRY_CXCC            (WT_DKRY_Begin + 9) //查询持仓
#define WT_DKRY_ZCJB            (WT_DKRY_Begin + 10) //资产净比
#define WT_DKRY_DRWT            (WT_DKRY_Begin + 11)//当日委托
#define WT_DKRY_LSWT            (WT_DKRY_Begin + 12)//历史委托
#define WT_DKRY_WTQR            (WT_DKRY_Begin + 13)//委托确认
#define WT_DKRY_End             (WT_DKRY_Begin + 20)//50080

/*大宗交易 50080～50100*/
#define WT_DZJY_Begin           (WT_DKRY_End)   //50080
#define WT_DZJYList             (WT_DZJY_Begin + 1) //大宗交易
#define WT_DZJY_YXMR            (WT_DZJY_Begin + 2) //意向买入
#define WT_DZJY_YXMC            (WT_DZJY_Begin + 3) //意向卖出
#define WT_DZJY_DJMR            (WT_DZJY_Begin + 4) //定价买入
#define WT_DZJY_DJMC            (WT_DZJY_Begin + 5) //定价卖出
#define WT_DZJY_QRMR            (WT_DZJY_Begin + 6) //确认买入
#define WT_DZJY_QRMC            (WT_DZJY_Begin + 7) //确认卖出
#define WT_DZJY_HQCX            (WT_DZJY_Begin + 8) //行情查询
#define WT_DZJY_End             (WT_DZJY_Begin + 20)//50100

/*基金盘后业务 50100~50120*/
#define WT_FundPH_Begin         (WT_DZJY_End)//50100
#define WT_FundPHList           (WT_FundPH_Begin + 1)   //基金盘后业务列表
#define WT_FundPH_JJFC          (WT_FundPH_Begin + 2)   //基金分拆
#define WT_FundPH_JJHB          (WT_FundPH_Begin + 3)   //基金合并
#define WT_FundPH_JJZH          (WT_FundPH_Begin + 4)   //基金转换
#define WT_FundPH_JJCD          (WT_FundPH_Begin + 5)   //基金撤单
#define WT_FundPH_CXWT          (WT_FundPH_Begin + 6)   //查询委托
#define WT_FundPH_CXCJ          (WT_FundPH_Begin + 7)   //查询成交
#define WT_FundPH_End           (WT_FundPH_Begin + 20)  //50120

/*紫金理财 50120~50170*/

/*转融通 50170~50200*/
#define WT_ZRT_Begin                    (MENU_QS_HTSC_ZJLC_END)//50170
#define WT_ZRT_List                     (WT_ZRT_Begin + 1)      //列表
#define WT_ZRT_RZMR                     (WT_ZRT_Begin + 2)      //融资买入
#define WT_ZRT_RQMC                     (WT_ZRT_Begin + 3)      //融券卖出
#define WT_ZRT_MQHK                     (WT_ZRT_Begin + 4)      //卖券还款
#define WT_ZRT_MQHQ                     (WT_ZRT_Begin + 5)      //买券还券
#define WT_ZRT_ZJHK                     (WT_ZRT_Begin + 6)      //直接还款
#define WT_ZRT_ZJHQ                     (WT_ZRT_Begin + 7)      //直接还券
#define WT_ZRT_GPTC                     (WT_ZRT_Begin + 8)      //股票头寸
#define WT_ZRT_ZJTC                     (WT_ZRT_Begin + 9)      //资金头寸

#define WT_ZRT_End                      (WT_ZRT_Begin + 30)

#define WT_XJLC_Begin                   (WT_ZRT_End)    // 50200
#define WT_XJLC_List                    (WT_XJLC_Begin +  1)

#define WT_XJLC_KTXJLC                  (WT_XJLC_Begin +  2)   // 开通现金理财
#define WT_XJLC_QXXJLC                  (WT_XJLC_Begin +  3)   // 取消现金理财
#define WT_XJLC_FWCL                    (WT_XJLC_Begin +  4)   // 服务策略
#define WT_XJLC_BLJE                    (WT_XJLC_Begin +  5)   // 保留金额
#define WT_XJLC_CXZT                    (WT_XJLC_Begin +  6)   // 查询状态
#define WT_XJLC_SZYYQK                  (WT_XJLC_Begin +  7)   // 设置预约取款
#define WT_XJLC_CXYYQK                  (WT_XJLC_Begin +  8)   // 查询预约取款
#define WT_XJLC_QXYYQK                  (WT_XJLC_Begin +  9)   // 取消预约取款
#define WT_XJLC_SG                      (WT_XJLC_Begin +  10)   //申购
#define WT_XJLC_SH                      (WT_XJLC_Begin +  11)   //赎回
#define WT_XJLC_Set                     (WT_XJLC_Begin +  12)   //设置
#define WT_XJLC_End                     (WT_XJLC_Begin + 20)   // 50220

//特有普通功能(55000起)

#define WT_OtherFunction                55000
#define WT_HTSC_Special                 (WT_OtherFunction + 1)//华泰特色业务 55001
#define WT_HTSC_YWBL                    (WT_OtherFunction + 2)//华泰业务办理 55002
#define WT_HTSC_ZJLX                    (WT_OtherFunction + 3)//华泰资金流向 55003
#define WT_HTSC_Other                   (WT_OtherFunction + 4)//华泰其他业务 55004
#define WT_HTSC_ResetComPass            (WT_OtherFunction + 5)//华泰重置通讯密码 55005
#define WT_HTSC_YWBLGrid                (WT_OtherFunction + 6)//业务办理宫格显示 55006
#define WT_HTSC_MyCC                    (WT_OtherFunction + 7)//我的持仓        55007

#define  TZT_MENU_QS_END				(TZT_MENU_QS_BEGIN +10000) //60000  券商特有功能结束
/***************券商特有功能 60000 END**********************/


#endif

#pragma mark -判断是否时查撤委托功能
CG_INLINE BOOL IsWITHDRAW(NSUInteger nMsgType)//是查撤委托
{
    return (nMsgType == WT_RZRQWITHDRAW || nMsgType == WT_SBWITHDRAW ||  nMsgType == WT_WITHDRAW )
    ||(nMsgType == MENU_JY_RZRQ_Withdraw || nMsgType == MENU_JY_SB_Withdraw || nMsgType == MENU_JY_PT_Withdraw);
}
#pragma mark -判断是否是融资融券业务
CG_INLINE BOOL IsRZRQMsgType(NSUInteger nMsgType)//是融资融券业务
{
    return (nMsgType == MENU_SYS_RZRQOut) ||
    (nMsgType >= ID_WT_RZRQBEGIN && nMsgType < ID_WT_RZRQEND) ||
    ( (nMsgType >= TZT_MENU_JY_RZRQ_BEGIN && nMsgType < TZT_MENU_JY_RZRQ_END) /*&& (nMsgType != MENU_JY_RZRQ_List)*/);
}

#pragma mark -判断是否属于三板(股转)业务
CG_INLINE BOOL IsSBJYMsgType(NSUInteger nMsgType)//是三板交易业务
{
    return (nMsgType > ID_WT_SBJYBEGIN && nMsgType < ID_WT_SBJYEND) ||
    (nMsgType > TZT_MENU_JY_SB_BEGIN && nMsgType < TZT_MENU_JY_SB_END);
}

#pragma mark -判断是否属于基金业务
CG_INLINE BOOL IsFundMsgType(NSUInteger nMsgType)//基金
{
    return (nMsgType >= WT_FUND_TRADE && nMsgType < WT_FUND_TRADE_End)
    ||
    (nMsgType > TZT_MENU_JY_FUND_BEGIN && nMsgType < TZT_MENU_JY_FUND_END);
}

#pragma mark -判断是否属于ETF业务
CG_INLINE BOOL IsETFMsgType(NSUInteger nMsgType)//是ETF交易
{
    return (nMsgType >= WT_ETF_TRADE_BEGIN && nMsgType <= WT_ETF_TRADE_End)
    ||
    (nMsgType > TZT_MENU_JY_ETFWX_BEGIN && nMsgType < TZT_MENU_JY_ETFWX_END);
}

#pragma mark -判断是否属于交易类
CG_INLINE BOOL IsTradeType(NSUInteger nMsgType)
{
    return (nMsgType >= ID_MENU_Stock_TRADE && nMsgType <= ID_MENU_Stock_TRADE_End && nMsgType != WT_OUT)
    ||
    (nMsgType > TZT_MENU_JY_BEGIN && nMsgType < TZT_MENU_JY_END);
}

#pragma mark -判断是否多存管交易功能
CG_INLINE BOOL IsDFBankJYMsgType(NSUInteger nMsgType)
{
    return (nMsgType >= WT_DFBankTradeBegin && nMsgType <= WT_DFBankTradeEnd)
    ||
    (nMsgType > TZT_MENU_JY_DFBANK_BEGIN && nMsgType < TZT_MENU_JY_DFBANK_END);
}

#pragma mark -判断是否需要验证基金登记
CG_INLINE BOOL IsCheckFundFxdj(NSUInteger nMsgType)
{
    return (/*WT_JJINZHUCEACCOUNT == nMsgType ||*/ WT_JJINQUIRETrans == nMsgType || WT_JJAPPLYFUND == nMsgType ||  WT_JJRGFUND == nMsgType)
    ||
    (MENU_JY_FUND_Change == nMsgType || MENU_JY_FUND_ShenGou == nMsgType ||  MENU_JY_FUND_RenGou == nMsgType)
    ;
}

#pragma mark -判断是否属于天汇宝(国泰)
CG_INLINE BOOL IsTHBMsgType(NSUInteger nMsgType)//天汇宝，报价回购
{
    return (nMsgType >= WT_THB_Begin && nMsgType <= WT_THB_End);
}

#pragma mark -判断是否港股交易
CG_INLINE BOOL IsHKTradeMsgType(NSUInteger nMsgType)
{
    return (nMsgType > TZT_MENU_JY_HK_BEGIN && nMsgType < TZT_MENU_JY_HK_END);
}

#pragma mark -判断是否个股期权
CG_INLINE BOOL IsOptionMsgType(NSUInteger nMsgType)//个股期权
{
    return (nMsgType > TZT_MENU_JY_GGQQ_BEGIN && nMsgType < TZT_MENU_JY_GGQQ_END);
}

#pragma mark -判断是否属于质押回购
CG_INLINE BOOL IsZYHGMsgType(NSUInteger nMsgType)//质押回购
{
    return (nMsgType > TZT_MENU_JY_ZYHG_BEGIN && nMsgType < TZT_MENU_JY_ZYHG_END);
}

#pragma mark -判断是否属于报价回购
CG_INLINE BOOL IsBJHGMsgType(NSUInteger nMsgType)//报价回购
{
    return (nMsgType > TZT_MENU_JY_BJHG_BEGIN && nMsgType < TZT_MENU_JY_BJHG_END);
}

#pragma mark -判断是佛属于大宗交易
CG_INLINE BOOL IsDZJYMsgType(NSUInteger nMsgType)//大宗交易
{
    return (nMsgType > TZT_MENU_JY_DZJY_BEGIN && nMsgType < TZT_MENU_JY_DZJY_END);
}

#pragma mark -判断是否需要过滤数据（华泰紫金理财）
CG_INLINE BOOL IsNeedFilterQuest(NSUInteger nMsgType)//是否需要过滤返回数据
{
    switch (nMsgType)
    {
        case MENU_QS_HTSC_ZJLC_FenHongSet:      //紫金理财分红方式
        case MENU_QS_HTSC_ZJLC_QueryDraw:    //紫金理财当日委托
        case MENU_QS_HTSC_ZJLC_Withdraw:          //紫金理财撤销委托
        case MENU_QS_HTSC_ZJLC_QueryVerifyHis:         //紫金理财历史成交
        case MENU_QS_HTSC_ZJLC_QueryStock:      //紫金理财持仓产品
        case MENU_QS_HTSC_ZJLC_QueryWTHis:         //紫金理财历史委托
        case MENU_QS_HTSC_ZJLC_Kaihu:    //紫金理财紫金开户
        case MENU_QS_HTSC_ZJLC_RenGou:  //
        case MENU_QS_HTSC_ZJLC_ShenGou:
        case MENU_QS_HTSC_ZJLC_ShuHui:
            return TRUE;
        default:
            return FALSE;
    }
}

#pragma mark -判断是否需要用户登录(手机号校验)
CG_INLINE BOOL IsUserLogin(NSUInteger nMsgType) //需用户登录功能
{
    BOOL bTrade = IsTradeType(nMsgType);
    if(bTrade)
        return bTrade;
    switch (nMsgType) {
            //        case HQ_MENU_EditUserStock: //编辑自选
        case HQ_MENU_UploadUserStock://上传自选
        case TZT_MENU_UpUserStock:
        case HQ_MENU_DownloadUserStock://下载自选
        case TZT_MENU_DownUserStock:
        case HQ_MENU_MergeUserStock://合并自选
        case TZT_MENU_MergeUserStock:
        case Sys_Menu_SendToFriend: //推荐好友
        case HQ_MENU_Info_CJCenter: //财经中心
        case Sys_Menu_QueryYXQ: //有效期查询
        case HQ_MENU_Message: //投资快递
        case HQ_MENU_Inbox: //收件箱
        case HQ_MENU_Online_My://我的提问
        case HQ_MENU_Collect: //收藏夹
            //        case HQ_MENU_Online_All://全部提问
            //        case HQ_MENU_UserStock: //我的自选
            //        case HQ_MENU_Online: //在线客服
        case HQ_MENU_YUJING: //预警
        case Sys_Menu_TZKDSetting://投资快递设置
        case HQ_MENU_ChaoGen:
        case HQ_MENU_ChaoGenEx:
        case HQ_MENU_Personal://个人中心
            return TRUE;
        default:
            break;
    }
    return FALSE;
}

