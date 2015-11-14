/*************************************************************
 *	Copyright (c)2009, 杭州中焯信息技术有限公司
 *	All rights reserved.
 *
 *	文件名称：	TZTCSystermConfig.h
 *	文件标识：	
 *	摘	  要：	系统配置
 *
 *	当前版本：	2.0
 *	作	  者：	
 *	更新日期：	
 *
 ***************************************************************/

#import <Foundation/Foundation.h>
/**
 *  系统配置，单例模式使用，读取配置文件tztSysterm.plist文件，并以字典形式存储于内存中
    以下给出了部分属性说明，若后续增加，请直接从字典中通过key获取，不再新增其他字段
 */

/**
 *  配置文件参数字段key＝基金参数，返回是字典
 */
static NSString* tztSystermConfig_FundParams = @"tztFundParams";
/**
 *  配置参数字段key＝基金定投是否需要检查风险，若需要检查需要配置下面得RiskURL参数
 */
static NSString* tztSystermConfig_FundDTNeedRiskCheck = @"tztDTNeedRiskCheck";
/**
 *  配置参数字段key＝基金风险url，返回是NSString
 */
static NSString* tztSystermConfig_FundRiskURL = @"tztFundRiskURL";

/**
 *    @author yinjp
 *
 *    @brief  是否支持预警，默认不支持
 */
static NSString* tztSystermConfig_SupportWarning = @"tztSupportWarning";

/**
 *    @author yinjp
 *
 *    @brief  分时底部快买快买是否支持融资融券切换，默认不支持
 */
static NSString* tztSystermConfig_FenShiSupportRZRQ = @"tztFenShiSupportRZRQ";

/**
 *    @author yinjp
 *
 *    @brief  行情表格是否使用分割线
 */
static NSString* tztSystermConfig_HQTableUseGrid = @"tztHQTableUseGrid";

/**
 *    @author yinjp
 *
 *    @brief  板块排名显示，默认0，类似华泰，1-和国金一致
 */
static NSString* tztSystermConfig_ReportBlockType = @"tztReportBlockType";

@interface TZTCSystermConfig : NSObject {
    NSString    *_strMainTitle;        // 标题文本(与公司有关的，比如：投资堂)
    NSString    *_strCompanyName;      // 显示公司名字
	NSString    *_strSysFrom;		   // 合作商from
    //dsw 九宫格背景色
    unsigned int 	_clNineCellBG;
    
    char        _bAddJYAccount;        // 添加交易用户是否提示风险提示
    char        _bShowDuty;            // 是否显示免责条款

    char        _bJYLoadMaskCode;      // 交易登录使用校验码
    char        _bAddLoginJY;          // 添加交易账号成功就登录
    int         _nFlashSubmit;         // 闪电下单

    //dsw 合并m_nFixedYYB，华泰采用固定营业部，南京虽然也是集中交易，营业部是需要下载的。
    char        _cJiZhongJY;           //如华泰一样集中交易，不分营业部 
    NSString    *_sYYBCode;    //营业部号码
    NSString    *_sRZRQYYBCode;//融资融券营业部号

    NSString    *_strRegAction;  //注册功能号 
	NSString    *_strLoginAction;  //登录功能号 
    
    NSString    *_strDefWAPURL;         //默认wap连接地址
    NSString    *_strDefURLSTR;         //默认开始地址
    NSString    *_strKHURL;             //默认开户地址
    int         _nJYServerPort;      //默认交易端口"7778"
    int         _nHQServerPort;      //默认行情端口"8001"
    int         _nZXServerPort;      //默认资讯端口“7778”(华西7779)
    int         _KHServerPort;       //默认开户地址
    
    char        _cLocalPhoneInfo;      //默认客户服务电话号码和提示，南京从服务器读取
    NSMutableArray  *_pPhoneArray;
    
    NSString    *_strAboutSoftName;     //关于中软件名称
    NSString    *_strAboutCopyright;    //关于中软件版权说明
    NSString    *_strfxts;// 风险提示
    
    char        _bNeedRegist;         //是否需要手机号激活登录（华西特殊，无需激活，直接资金账号登录）
    char        _bOpenAutoRegist;     // 用户登录界面方式 0 通讯密码登录 1激活登录 2 湘财体验登录 
								  // 3 手机号 获取激活码 4 手机号 获取激活码 激活码 激活  
								  // 5 手机号 获取激活码 激活码(密码) 激活 如：东莞证券
    
    NSString        *_strRegistTips;
    NSString        *_strRegistHelp;
    NSString        *_strMZTK;
    
    int             _nOpenReportSplit; //是否开启分屏展示报价
    
	
	int             _nJycreditfund; //融资融券功能 0 关闭 1 开启 
    int             _nShowSysBlock; //系统板块
    
	NSString        *_tztiniturl; //初始化底图
    NSString        *_tztiniturl5;//
	NSString        *_tztJHServer;//均衡服务器
	int             _tztJHPort;  //均衡服务器端口
	int				_bJHOpen;	 //启用均衡 0 不启用 1 启用
    
    BOOL            _bRZRQHZLogin;//融资融券划转是是否需要普通登录
    
    BOOL            _bSupportTBF10;//是否支持图表f10
    BOOL            _bNSupportInfoMine; // 是否不支持信息地雷 byDBQ20130805
    NSMutableDictionary *_pDict;
    BOOL            _bShowbottomTool;//是否显示交易里面底部工具条
    BOOL            _bHiddenOtherTool;//是否隐藏其他界面的底部工具条
    BOOL            _bOldDFCGPWShow;//是否支持老的多存管银行密码，资金密码显示判断方式
    BOOL            _bJJDTWithoutModify; //基金定投没修改功能 byDBQ20130923
    
    NSString        *_nsFundGSDM;   //默认的基金公司代码
    NSString        *_nsFundCode;   //默认的基金代码
    
    char            _bUserStockNeedLogin;     // 自选股是否需要登录 0 不需要, 1需要 add by xyt 20130917
    char            _bRegistSucToDownload; // 激活成功后是否去下载自选股  0不下载,1下载 add by xyt 201301008
    char            _bSupportChangeFundPW;  //资金密码修改
    char            _bSupportChangeTXPW;    //通讯密码修改
    
    int             _nToolBarHeight;//底部ToolBarView 高度,没有配置用默认的 //modify by xyt 20131119
    int             _nDefaultIndex;//程序启动时默认选中底部按钮位置索引
    
    char            _bFenShiSupportTrade;//分时界面是否支持快速买卖
    NSString        *_nsHelpTipsUrl;//帮助引导页url
    char            _bSelectFirstRow;//查询是否选中第一行
    
    char            _bSelectJYTabbar;//选择交易tabbar，是否需要弹出登录界面 0 不需要, 1需要
}
/**
 *  读取到的文件内容，字典形式，可通过key直接获取
 */
@property (nonatomic, retain) NSMutableDictionary *pDict;
/**
 *  标题文本
 */
@property (nonatomic, retain) NSString  *strMainTitle;
/**
 *  公司名字
 */
@property (nonatomic, retain) NSString  *strCompanyName;
/**
 *  合作商
 */
@property (nonatomic, retain) NSString  *strSysFrom;
/**
 *  九宫格背景（已不再使用）
 */
@property unsigned int  clNineCellBG;
/**
 *  添加交易用户是否提示风险提示
 */
@property char      bAddJYAccount;
/**
 *  是否显示免责条款（已不再使用）
 */
@property char      bShowDuty;
/**
 *  交易登录使用校验码（已不再使用）
 */
@property char      bJYLoadMaskCode;
/**
 *  是否支持快速下单（已不在使用）
 */
@property int       nFlashSubmit;
/**
 *  是否集中交易，不区分营业部（已不再使用）
 */
@property char      cJiZhongJY;
/**
 *  普通交易营业部号
 */
@property (nonatomic, retain) NSString  *sYYBCode;
/**
 *  融资融券营业部号
 */
@property (nonatomic, retain) NSString  *sRZRQYYBCode;
/**
 *  系统注册使用功能号
 */
@property (nonatomic, retain) NSString  *strRegAction;
/**
 *  系统登录使用功能号
 */
@property (nonatomic, retain) NSString  *strLoginAction;
/**
 *  hasServiceTool
 */
@property (nonatomic, retain) NSString  *hasServiceTool;

/**
 * 默认服务器地址列表，可以是多个服务器地址，中间用&进行分割
 */
@property (nonatomic, retain) NSString  *strDefWAPURL;
/**
 *  默认连接的服务器地址，只能指定一个
 */
@property (nonatomic, retain) NSString  *strDefURLSTR;
/**
 *  开户服务器地址（目前不使用）
 */
@property (nonatomic, retain) NSString  *strKHURL;
/**
 *  交易端口，默认7778
 */
@property int   nJYServerPort;
/**
 *  行情端口，默认7778
 */
@property int   nHQServerPort;
/**
 *  资讯端口，默认7778
 */
@property int   nZXServerPort;
/**
 *  开户端口，默认7778（目前不使用）
 */
@property int   nKHServerPort;
/**
 *  默认客户服务电话号码和提示，南京从服务器读取
 */
@property char    cLocalPhoneInfo;
/**
 *  pPhoneArray
 */
@property (nonatomic, retain) NSMutableArray    *pPhoneArray;
/**
 *  关于中软件名称
 */
@property (nonatomic, retain) NSString          *strAboutSoftName;
/**
 *  关于中软件版权说明
 */
@property (nonatomic, retain) NSString          *strAboutCopyright;
/**
 *  免责条款内容
 */
@property (nonatomic, retain) NSString          *strMZTK;
/**
 *  ETF 撤单有特殊功能号（暂未确认哪个使用到该配置）
 */
@property (nonatomic, retain) NSString          *etfWithdrawAction;
/**
 *  风险提示信息
 */
@property (nonatomic, retain) NSString          *strfxts;
/**
 *  九宫格背景颜色
 */
@property (nonatomic, retain) NSString          *nineBackColor;
/**
 *  Defined down color(未确认该字段用途)
 */
@property (nonatomic, retain) NSString          *defDownColor;
/**
 *  Special action code for selling trade(未确认该字段用途)
 */
@property (nonatomic, retain) NSString          *sellAction;
/**
 *  是否需要手机号码注册激活
 */
@property char              bNeedRegist;
/**
 *  用户登录界面方式 0 通讯密码登录 1激活登录 2 湘财体验登录 3 手机号 获取激活码 4 手机号 获取激活码 激活码 激活,（目前已经未使用）
 */
@property char              bOpenAutoRegist;

/**
 *  注册提示信息
 */
@property (nonatomic, retain) NSString    *strRegistTips;
/**
 *  注册帮助信息
 */
@property (nonatomic, retain) NSString    *strRegistHelp;
/**
 *  是否开启分屏展示报价,目前已经不再使用
 */
@property int       nOpenReportSplit;
/**
 *  是否开启融资融券功能，目前已经不再使用
 */
@property int       nJycreditfund;
/**
 *  系统板块
 */
@property int       nShowSysBlock;
/**
 *  均衡服务器,可以多个地址，用&分割
 */
@property (nonatomic, retain) NSString    *tztJHServer;
/**
 *  均衡服务器端口
 */
@property int                               tztJHPort;
/**
 *  是否启用均衡,若不开启，上面关于均衡的配置失效
 */
@property int                               bJHOpen;
/**
 *  初始化底图
 */
@property (nonatomic, retain) NSString      *tztiniturl;
/**
 *  初始化底图 大屏幕
 */
@property (nonatomic, retain) NSString      *tztiniturl5;
/**
 *  最新要闻网页URL
 */
@property (nonatomic, retain) NSString      *tztZXYWWebURL;
/**
 *  主题色
 */
@property (nonatomic, retain) NSString      *themeColor;
/**
 *  iPad的TabView的背景如果是纯色的话 byDBQ20131210
 */
@property BOOL biPadPureBg;
/**
 *  融资融券划转是否需要登录
 */
@property BOOL bRZRQHZLogin;
/**
 *  是否支持图标F10
 */
@property BOOL bSupportTBF10;
/**
 *  是否不支持信息地雷
 */
@property BOOL bNSupportInfoMine;
/**
 *  是否显示底部工具条
 */
@property BOOL bShowbottomTool;
/**
 *  是否支持老的多存管银行密码，资金密码显示判断方式
 */
@property BOOL bOldDFCGPWShow;
/**
 *  基金定投没有修改功能
 */
@property BOOL bJJDTWithoutModify;
/**
 *  买卖界面有分时
 */
@property BOOL bBuySellWithTrend;
/**
 *  分时下可买可买和融买融卖切换显示
 */
@property BOOL bKMKMNormal;
/**
 *  是否吧股东账号显示成市场类型中文
 */
@property BOOL bTransType2Content;
/**
 *  不要右侧搜索按钮
 */
@property BOOL bNSearchFunc;
/**
 *  交易不要右侧搜索按钮
 */
@property BOOL bNSearchFuncJY;
@property BOOL b;
/**
 *  最新要闻是否是网页
 */
@property BOOL bZXYWisWeb;
/**
 *  是否合并查询股票和查询资金 byDBQ20131204
 */
@property BOOL bGPAndZJ;
/**
 *  三板priceType字段特殊发送
 */
@property BOOL bSBSpecialPriceType;
/**
 *  持仓界面没有行情
 */
@property (nonatomic, assign) BOOL bNStockNeedHQ;
/**
 *  基金公司代码
 */
@property (nonatomic, retain) NSString    *nsFundGSDM;
/**
 *  基金代码
 */
@property (nonatomic, retain) NSString    *nsFundCode;
/**
 *  当日流水功能号
 */
@property (nonatomic, retain) NSString    *rzrqDRLS; // 融资融券当日资金流水特殊功能号
/**
 *  个股报价图只有5档
 */
@property (nonatomic, assign) BOOL    bWudangOnly; // 个股报价图只有五档
/**
 *  自选股是否需要登录 0 不需要, 1需要
 */
@property char            bUserStockNeedLogin;
/**
 *  登录成功自动下载自选
 */
@property char            bRegistSucToDownload;
/**
 *  支持资金密码修改
 */
@property char            bSupportChangeFundPW;
/**
 *  支持通讯密码修改
 */
@property char            bSupportChangeTXPW;
/**
 *  底部toolbar高度
 */
@property int             nToolBarHeight;
/**
 *  默认选中底部toolbar位置索引
 */
@property int             nDefaultIndex;
/**
 *  分时界面是否支持买卖
 */
@property char            bFenShiSupportTrade;
/**
 *  helptipsurl
 */
@property (nonatomic, retain) NSString   *nsHelpTipsUrl;
/**
 *
 */
@property char            bSelectFirstRow;
@property char            bSelectJYTabbar;
/**
 *  是否隐藏其他界面的底部工具条
 */
@property BOOL            bHiddenOtherTool;
/**
 *  需要加密现实的长度，用于交易账户等中间进行加密，不配置使用默认
 */
@property int             nSecLength;
/**
 *  排序文字
 */
@property (nonatomic,retain)NSString*            nsOrderIconString;

 /**
 *	@brief	初始化
 *
 *	@return	无
 */
+(void)initShareClass;

 /**
 *	@brief	释放
 *
 *	@return	无
 */
+(void)freeShareClass;

 /**
 *	@brief	获取单例
 *
 *	@return	TZTCSystermConfig对象
 */
+(TZTCSystermConfig*)getShareClass;

-(void) CSystermConfig_;
-(void) _CSystermConfig;

-(void) InitPath:(NSString*)strFileName;//(CString sPath,CString strCfgFile);
/**
 *  获取默认自选股列表
 *
 *  @return 股票数组
 */
- (NSArray*)ayDefaultUserStock;//获取默认股票列

/**
 *  判断过滤相应基金公司
 *
 *  @param nsGSDM 公司代码
 *
 *  @return
 */
-(BOOL)IsFundCompany:(NSString*)nsGSDM;
/**
 *  判断过滤相应基金代码
 *
 *  @param nsCode 基金代码
 *
 *  @return
 */
-(BOOL)IsFundCode:(NSString*)nsCode;

/**
 *  检查有效性
 *
 *  @param ayRowData  检查数据
 *  @param nRowIndex  行号
 *  @param nComIndex  列号
 *  @param nMsgType   类型
 *  @param bCodeCheck 是否代码检查
 *
 *  @return 
 */
-(NSInteger)CheckValidRow:(NSMutableArray*)ayRowData nRowIndex_:(NSInteger)nRowIndex nComIndex_:(NSInteger)nComIndex nMsgType_:(NSInteger)nMsgType bCodeCheck_:(BOOL)bCodeCheck;

@end
extern TZTCSystermConfig* g_pSystermConfig;
extern NSString *         g_nsInnVer;