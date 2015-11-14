/************************************************************
 功能号原则：
 1、符合相应分段
 2、功能标识 标识相应功能以英文翻译、拼音简称为基准。
 
 ***************************************************************/


#ifndef tztbase_tztBaseVCMsgtypedef_h
#define tztbase_tztBaseVCMsgtypedef_h

/***************操作功能 10000 BEGIN**********************/
#define  TZT_MENU_BEGIN                 10000
#define  TZT_MENU_Root					(TZT_MENU_BEGIN+1)    // 首页: 返回到首页
#define  TZT_MENU_Return				(TZT_MENU_BEGIN+2)    //10002 返回:返回前一页
#define  TZT_MENU_Refresh				(TZT_MENU_BEGIN+3)    //10003 刷新:刷新当前界面
#define  TZT_MENU_OnPrev				(TZT_MENU_BEGIN+4)    //10004 前一个(条):前一个股票、前一条资讯、前一条记录 ？
#define  TZT_MENU_OnNext				(TZT_MENU_BEGIN+5)    //10005 后一个(条):后一个股票、后一条资讯、后一条记录 ？
#define  TZT_MENU_OnLeft				(TZT_MENU_BEGIN+6)    //10006 向左划动
#define  TZT_MENU_OnRight				(TZT_MENU_BEGIN+7)    //10007 向右划动

#define  TZT_MENU_ExpFavoriteClear		(TZT_MENU_BEGIN+10)    //10010 清空快递收藏夹
#define  TZT_MENU_HQRecentClear			(TZT_MENU_BEGIN+11)    //10011 清空行情最近浏览列表

#define  TZT_MENU_SendMsg               (TZT_MENU_BEGIN+20)     //10020 调用客户端发送短信
#define  TZT_MENU_SignProtcol           (TZT_MENU_BEGIN+21)     //10021 签署各种协议（e.g.:国金定投协议签署后返回调用功能号，并携带成功与否标识参数）

#define  TZT_MENU_StartOpen             (TZT_MENU_BEGIN+48)    //10048  立即开户
#define  TZT_MENU_UIActivity            (TZT_MENU_BEGIN+49)    //10049  进度条显示、关闭
#define  TZT_MENU_Vedio                 (TZT_MENU_BEGIN+50)    //10050  视频
#define  TZT_MENU_Photo                 (TZT_MENU_BEGIN+51)    //10051  拍照
#define  TZT_MENU_CreateP10             (TZT_MENU_BEGIN+52)    //10052  生成p10
#define  TZT_MENU_RequestCER            (TZT_MENU_BEGIN+53)    //10053  请求证书
#define  TZT_MENU_DownloadFile          (TZT_MENU_BEGIN+54)    //10054  下载文件
#define  TZT_MENU_Share                 (TZT_MENU_BEGIN+55)    //10055  分享
#define  TZT_MENU_MobileCheck           (TZT_MENU_BEGIN+56)    //10056  开户手机号码校验（华泰）
#define  TZT_MENU_UserInfo              (TZT_MENU_BEGIN+57)    //10057  开户手机号校验后下一步（华泰三期）


#define  TZT_MENU_SetShortCut           (TZT_MENU_BEGIN+60)    //10060  设置快捷方式
/*
 e.g:
 http://action:1901/?tab1=1&&tab2=1&&tab3=0&&
 * Prompt
 * tab1 对应百宝箱
 * tab2 对应行情
 * tab3 对应交易
 * tab4 对应热点
 * tab5 对应掌厅
 * tab1里面可能对应多个点taglist1=1111 意思是tab里面有四个要显示的点如果没有taglist说明没有多个点
 * 保存的数据 tab1=0&tab2=0&tab3=0&tab4=0&tab5=0&
 *
 */
#define  TZT_TabBar_Status              (1901)
/*
 e.g:
 http://action:1902/?tab1=1|&&tab2=1|&&tab3=0|&&
 * Prompt
 * sysbadge 系统软件
 * tab1 对应百宝箱
 * tab2 对应行情
 * tab3 对应交易
 * tab4 对应热点
 * tab5 对应掌厅
 *
 */
#define  TZT_TabBar_Property            (1902)

/**< 打开跳转到第三方对应外部功能 可传参，客户端不处理，直接回调第三方功能，并且把参数一并返回，用于sdk提供使用，不和自己内部的tabbar跳转冲突*/
#define  TZT_JumpOut_SDK                (1903)
/*
 Action:10061
 功能:重新打开一个指定的URL
 e.g:http://action:10061/?type=1&&fullscreen=1&&url=xxxxxxxxx&&secondurl=xxxxxxxxxxxx
 注：参数使用两个(&)进行分割，因为url中可能会带有(&)
 参数:
 type:       类型，主要用于修改客户端的标题栏显示
 0、右侧没有按钮
 1、修改字体     (客户端处理)
 2、订阅         (后面需要带上订阅点击打开的地址）
 3、修改         (需要带上修改所要打开的地址）
 4、我要开户      (需要带上开户地址）
 5、在线客服     (需要带上在线客服地址）
 6、筛选 （文字）(需要带上筛选链接地址）
 7、筛选1（图片）(需要带上筛选链接地址）
 fullScreen: 是否全屏展示 0-否，1-是  在展示资讯内容的时候有需要全屏展示
 url:        当前需要打开的url地址
 secondurl:  根据type不同，返回的链接地址，用于type对应按钮点击的界面跳转
 */
#define  TZT_MENU_OpenWebInfoContent    (TZT_MENU_BEGIN+61)    //10061  打开web资讯内容（全屏展示）

/*
 Action:10062
 功能:获取GPS位置，打开指定的URL
 e.g:http://action:10062/?url=zt/yybxx.html?a=va&b=vb&gpsx=($tztgpsx)&gpsy=($tztgpsy)
 参数:
 url:    需打开的URL，URL可设置GPS参数
 */

#define TZT_MENU_GetGPSLocation                    (TZT_MENU_BEGIN+62)

/*
 Action:10063
 功能:调用个股搜索功能，获取查询股票结果
 e.g:http://action:10063/?url
 */
#define  TZT_MENU_GetStockCode          (TZT_MENU_BEGIN+63)    //10063  打开本地个股搜索，并获取结果反馈

/*
 Action:10064
 功能:调用个人中心
 e.g:http://action:10064/?
 */
#define  TZT_MENU_GotoPersonalCenter    (TZT_MENU_BEGIN+64) //10064 调用个人中心

/*
 Action:10065
 功能：调用商城首页
 e.g:http://action:10065/?
 */
#define  TZT_MENU_MALL                  (TZT_MENU_BEGIN+65) //10065 调用商城

/*
 Action:10066
 功能：添加账号
 e.g:http://action:10066/?url=xxxxxxxxx
 参数:
 url 添加成功后回调的url或者是JSFuncName，用于页面刷新显示
 */
#define  TZT_MENU_SysAddAccount         (TZT_MENU_BEGIN+66) //10066 添加账号

/*
 Action:10067
 功能：账号切换
 e.g: http://action:10067/?account=56809019&&url=xxxxxxxxx 或者 http://action:10067/?account=56809019&&jsfuncname=xxxxxxxxx
 参数：
 account 要切换登录的账号
 url     切换后回调的url或者是jsfuncname，用于界面刷新
 */
#define  TZT_MENU_SysChangeAccount      (TZT_MENU_BEGIN+67) //10067 账户切换

/*
 Action:10068
 功能：打开专题界面
 e.g:http://action:10068/?url=xxxxxxxxxxx
 参数：
 url:要打开的专题url
 */
#define  TZT_MENU_OpenBannerInfo        (TZT_MENU_BEGIN+68) //10068 打开banner专题详情界面


/*Action:10069
 功能:PK一下首页（华西理财）
 */
#define TZT_MENU_PK                     (TZT_MENU_BEGIN+69)//10069 华西pK一下首页

/*
 Action:10070
 功能:调用本地银联支付功能，需要携带相关参数：
 （商户号）  merchantId
 （订单号）  merOrderId
 （订单时间）merOrderTime
 （CP特征码）orderKey
 （签名）   mersign
 (成功调用url) url
 e.g：http://action:10070/?merchantId=xxxx&&merOrderId=xxxxx&&merOrderTime=xxxxxx&&orderKey=xxxxxx&&sign=xxxxxx&&url=xxxxxx
 */
#define TZT_MENU_UPayControl            (TZT_MENU_BEGIN+70)//10070银联支付

#define TZT_MENU_ClearBadgeNumber       (TZT_MENU_BEGIN+71)//10071清除badgeNumber

#define TZT_MENU_ClearPushInfo          (TZT_MENU_BEGIN+72)//10072一键清除功能


 /**
 *	@brief	本地打开第三方应用
  Action:10073
  appurl:       直接打开第三方应用的url
  downloadur:   没有需要去下载的url
  e.g:http://action:10073/?appurl=xzxzxzxxxzx&&downloadurl=xsxxxxxxxxxx
 */
#define TZT_MENU_OpenOtherApp           (TZT_MENU_BEGIN+73)//10073打开其他第三方应用

/**
 *    @author yinjp
 *
 clearAll：删除本地web缓存页面，若clearall＝1则直接删除本地所有web页面；若clearall不传或者＝0，则通过服务器判断并删除需要更新的页面
 *    @brief  http://action:10074/?clearAll=1
 */
#define TZT_MENU_ClearCache             (TZT_MENU_BEGIN+74)//10074删除本地缓存功能

/**
 *    @author yinjp
 *
 Action:10075
 hqmenuitem:行情菜单中的菜单号
 isblock：是否板块显示 0-否1-是（安卓）
 subitemspos：二级菜单是否显示（0-不显示 1-显示上面 2-显示下面, 不传默认2）
 *    @brief http://action:10075/?hqmenuitem=3&&isblock=0&&subitemspos=1
 */
#define TZT_MENU_HQMarket               (TZT_MENU_BEGIN+75)//10075网页调用行情列表

/**
 *    @author yinjp
 *
 Action:10076
 调用本地密码控件，完成输入后，执行对应js函数
length:输入长度
 
jsfucname:需要执行的js函数,js函数以输入密码控件获取到的数据作为入參
 *    @brief http://action:10076/?jsfucname=jsname('xxxxx')
 */
#define TZT_MENU_PassCtrl               (TZT_MENU_BEGIN+76)//10076页面调用客户端密码控件

#define TZT_MENU_WebTimer               (TZT_MENU_BEGIN+77)//10077调用网页定时器

/**
 *    @author yinjp
 *
 *    @brief  调用二维码扫描，并将扫描结果通过js返回给页面  js固定tztqrcodescanresult('result');
 */
#define TZT_MENU_QRCodeScan             (TZT_MENU_BEGIN+78)//10078调用二维码扫描

/**
    accounttype：    要切换的账号类型，同10090登录时的登录类型（0-系统登录 1-交易登录 2-融资融券登录 8-个股期权登录 9-担保品划转普通登录）
    该功能配合10090使用，切换账号前，先调用10090 判断是否已经登录，登录成功后使用切换，并传入需要切换的账号类型，同10090的登录类型
    客户端处理时，可兼容处理下登录状态，以免出现直接调用该功能的情况
 */
#define TZT_MENU_ChangeLoginAccount     (TZT_MENU_BEGIN+79)//10079调用切换账户功能

/*
 功能号
 Action：10090
 功能：
 网页发起登录，登录成功后跳转到指定url地址或执行制定js函数
 若url和jsfuncname同时返回，则只处理url，对jsfuncname不做处理
 e.g:http://action:10090/?loginType=1&&longinKind=0&&url=xxxxxxxxxxx&&urlfalse=
 参数说明：
 loginType  :登陆类型 0-系统 1-交易
 loginKind  :loginType＝1时，通知是强权限登陆或者是弱权限登陆 0-弱权限（通讯密码） 1－强权限（交易密码） 2-添加账号
 url        :登陆成功后调转的url页面地址
 jsfuncname :登录成功后调用的javascript函数
 urlfalse   :用户不登录或者登录失败后返回上层执行的操作
 */
#define  TZT_MENU_WebLogin              (TZT_MENU_BEGIN+90)

/**
 *    @author yinjp
 *
 Acton:10095
 serverip:视频服务器地址
 serverport:视频服务器端口
 roomid:房间号
 urltrue:成功回调
 urlfalse:失败回调
 *    @brief  新的视频处理，页面获取服务器地址、端口，房间号等信息，直接进入客户端的视频处理
 */
#define  TZT_MENU_VideoEx               (TZT_MENU_BEGIN+95)//10095 新的视频处理，页面获取服务器

//需用户登录
#define  TZT_MENU_EditUserStock			(TZT_MENU_BEGIN+100)    //10100 编辑自选股
#define  TZT_MENU_AddUserStock			(TZT_MENU_BEGIN+101)    //10101 添加自选股
#define  TZT_MENU_DelUserStock			(TZT_MENU_BEGIN+102)    //10102 删除自选股
#define  TZT_MENU_UpUserStock			(TZT_MENU_BEGIN+103)    //10103 上传自选股
#define  TZT_MENU_DownUserStock			(TZT_MENU_BEGIN+104)    //10104 下载自选股
#define  TZT_MENU_MergeUserStock		(TZT_MENU_BEGIN+105)    //10105 合并自选股

#define  TZT_MENU_END					(TZT_MENU_BEGIN+200)    //10200
/***************操作功能 10200  END**********************/

//预留100功能

/***************系统功能 10300 BEGIN**********************/
#define  TZT_MENU_SYS_BEGIN				(TZT_MENU_END+100)      //10300
#define  MENU_SYS_UserLogin				(TZT_MENU_SYS_BEGIN+1) //10301 用户登录
#define  MENU_SYS_UserLogout			(TZT_MENU_SYS_BEGIN+2) //10302 用户登出
#define  MENU_SYS_ResetCommPwd          (TZT_MENU_SYS_BEGIN+3) //10303 重置通讯密码

#define  MENU_SYS_ServerCenter			(TZT_MENU_SYS_BEGIN+10) //10310 服务中心
#define  MENU_SYS_SerAddSet				(TZT_MENU_SYS_BEGIN+11) //10311 服务器设置
#define  MENU_SYS_SerAddCheck			(TZT_MENU_SYS_BEGIN+12) //10312 服务器测速
#define  MENU_SYS_System				(TZT_MENU_SYS_BEGIN+13) //10313 系统设置(行情设置)
#define  MENU_SYS_ReLogin				(TZT_MENU_SYS_BEGIN+14) //10314 重新激活
#define  MENU_SYS_About                 (TZT_MENU_SYS_BEGIN+15) //10315 版本信息
#define  MENU_SYS_HotLine				(TZT_MENU_SYS_BEGIN+16) //10316 客服热线
#define  MENU_SYS_Disclaimer			(TZT_MENU_SYS_BEGIN+17) //10317 免责条款
#define  MENU_SYS_InfoCenter			(TZT_MENU_SYS_BEGIN+18) //10318 资讯中心
#define  MENU_SYS_InterActive			(TZT_MENU_SYS_BEGIN+19) //10319 互动社区

#define  MENU_SYS_OnlineServe			(TZT_MENU_SYS_BEGIN+20) //10320 在线客服
#define  MENU_SYS_AllQuestion			(TZT_MENU_SYS_BEGIN+21) //10321 全部提问
#define  MENU_SYS_FinanceCenter         (TZT_MENU_SYS_BEGIN+22) //10322 财经中心
#define  MENU_SYS_StockStudy			(TZT_MENU_SYS_BEGIN+23) //10323 投资者教育
#define  MENU_SYS_Showlog			    (TZT_MENU_SYS_BEGIN+24) //10324 显示日志
#define  MENU_SYS_Clearlog			    (TZT_MENU_SYS_BEGIN+25) //10325 清空日志
#define  MENU_SYS_ClearUserData         (TZT_MENU_SYS_BEGIN+26) //10326 清除用户数据
#define  MENU_SYS_SystemQA              (TZT_MENU_SYS_BEGIN+27) //10327 常见问题
#define  MENU_SYS_YuYueKaiHu            (TZT_MENU_SYS_BEGIN+28) //10328 预约开户

#define  MENU_SYS_UpdataVersion         (TZT_MENU_SYS_BEGIN+30) //10330 升级版本
#define  MENU_SYS_GongGao               (TZT_MENU_SYS_BEGIN+31) //10331 公告

#define  MENU_SYS_SetStartPage          (TZT_MENU_SYS_BEGIN+32) //10332 定制启动后默认显示的界面

#define  MENU_SYS_YYBNavigation         (TZT_MENU_SYS_BEGIN+49) //10349 营业部导航（东莞显示的是列表入口和三个营业部）
#define  MENU_SYS_YYBInfo               (TZT_MENU_SYS_BEGIN+50) //10350 营业部信息
#define  MENU_SYS_YYBLocation           (TZT_MENU_SYS_BEGIN+51) //10351 营业部定位
#define  MENU_SYS_YYBDetail				(TZT_MENU_SYS_BEGIN+52) //10352 营业部网点信息详情Dgzq_Cft_Grid_YYB_Detail
#define  MENU_SYS_YYBJiuJin				(TZT_MENU_SYS_BEGIN+53) //10353就近营业部Trade_Gtja_JiuJinYinYeBu

#define  MENU_SYS_SysSettingList        (TZT_MENU_SYS_BEGIN+60) //10360 系统设置列表

//需用户登录
#define  MENU_SYS_JYLogin				(TZT_MENU_SYS_BEGIN+101) //10401 交易登录
#define  MENU_SYS_JYLogout 				(TZT_MENU_SYS_BEGIN+102) //10402 交易登出
#define  MENU_SYS_JYAddAccount			(TZT_MENU_SYS_BEGIN+103) //10403 交易帐号预设
#define  MENU_SYS_JYMoreAccountLogin 	(TZT_MENU_SYS_BEGIN+104) //10404 多账号登录
#define  MENU_SYS_JYErrorLogout         (TZT_MENU_SYS_BEGIN+105) //10405 交易错误登出
#define  MENU_SYS_RZRQOut               (TZT_MENU_SYS_BEGIN+107) //10407 融资融券登出

#define  MENU_SYS_UserBuy				(TZT_MENU_SYS_BEGIN+110) //10410 软件充值
#define  MENU_SYS_RecomFriend			(TZT_MENU_SYS_BEGIN+111) //10411 好友推荐
#define  MENU_SYS_UserProduct			(TZT_MENU_SYS_BEGIN+112) //10412 查询有效期
#define  MENU_SYS_ExpreSet				(TZT_MENU_SYS_BEGIN+113) //10413 快递设置
#define  MENU_SYS_UserExpress			(TZT_MENU_SYS_BEGIN+114) //10414 投资快递
#define  MENU_SYS_ExpressInBox			(TZT_MENU_SYS_BEGIN+115) //10415 快递收件箱
#define  MENU_SYS_ExpressFavorite		(TZT_MENU_SYS_BEGIN+116) //10416 快递收藏夹
#define  MENU_SYS_FollowSet             (TZT_MENU_SYS_BEGIN+117) //10417 炒跟设置
#define  MENU_SYS_UserFollow			(TZT_MENU_SYS_BEGIN+118) //10418 炒跟逆袭
#define  MENU_SYS_UserWarning			(TZT_MENU_SYS_BEGIN+119) //10419 预警
#define  MENU_SYS_MyQuestion			(TZT_MENU_SYS_BEGIN+120) //10420 我的提问
#define  MENU_SYS_UserCenter			(TZT_MENU_SYS_BEGIN+121) //10421 个人中心
#define  MENU_SYS_UserWarningList       (TZT_MENU_SYS_BEGIN+122) //10422 预警列表

#define  MENU_SYS_OpenLeftSide          (TZT_MENU_SYS_BEGIN+130) //10430 打开左侧侧滑界面
#define  MENU_SYS_OpenRightSide         (TZT_MENU_SYS_BEGIN+131) //10431 打开右侧侧滑界面

#define  TZT_MENU_SYS_END				(TZT_MENU_SYS_BEGIN +200)
/***************系统功能 10500 END **********************/

//供页面调用制定模块，基础定义，各个券商略有不同，需要做相应调整，但功能号基本上应该就这5个。
#define  TZT_MENU_Main                  (TZT_MENU_SYS_BEGIN + 300)  //首页
#define  TZT_MENU_Market                (TZT_MENU_SYS_BEGIN + 301)  //行情    10601
#define  TZT_MENU_Info                  (TZT_MENU_SYS_BEGIN + 302)  //资讯
#define  TZT_MENU_Trade                 (TZT_MENU_SYS_BEGIN + 303)  //交易
#define  TZT_MENU_Set                   (TZT_MENU_SYS_BEGIN + 304)  //设置

//预留1500功能

/***************行情功能 12000 BEGIN**********************/
#define  TZT_MENU_HQ_BEGIN				(TZT_MENU_SYS_END +1500) //12000 行情功能 开始功能号

#define  MENU_HQ_Index                  (TZT_MENU_HQ_BEGIN+1) //12001 大盘指数
#define  MENU_HQ_Report                 (TZT_MENU_HQ_BEGIN+2) //12002 综合排名
#define  MENU_HQ_Recent                 (TZT_MENU_HQ_BEGIN+3) //12003 最近浏览
#define  MENU_HQ_HS                     (TZT_MENU_HQ_BEGIN+4) //12004 沪深股市
#define  MENU_HQ_HK                     (TZT_MENU_HQ_BEGIN+5) //12005 港股市场
#define  MENU_HQ_QH                     (TZT_MENU_HQ_BEGIN+6) //12006 国内期货
#define  MENU_HQ_Gold					(TZT_MENU_HQ_BEGIN+7) //12007 黄金白银
#define  MENU_HQ_WH                     (TZT_MENU_HQ_BEGIN+8) //12008 外汇市场
#define  MENU_HQ_Global                 (TZT_MENU_HQ_BEGIN+9) //12009 全球市场
#define  MENU_HQ_TopBlock				(TZT_MENU_HQ_BEGIN+10) //12010 热门关注
#define  MENU_HQ_Fund			     	(TZT_MENU_HQ_BEGIN+11) //12011 基金市场
#define  MENU_HQ_Xuangu                 (TZT_MENU_HQ_BEGIN+12) //12012 智能选股，模型选股
#define  MENU_HQ_BlockHq			    (TZT_MENU_HQ_BEGIN+13) //12013 板块行情 －板块指数及板块内容
#define  MENU_HQ_FundLiuxiang			(TZT_MENU_HQ_BEGIN+14) //12014 资金流向
#define  MENU_HQ_OutFund                (TZT_MENU_HQ_BEGIN+15) //12015 场外基金

#define  WT_QLSC_JJMarket               (TZT_MENU_HQ_BEGIN+16) //12016 基金超市页
#define  WT_QLSC_CFTS                   (TZT_MENU_HQ_BEGIN+17) //12017 首页财富泰山页

#define  MENU_HQ_HQMore                 (TZT_MENU_HQ_BEGIN+18) //12018 行情更多

#define  MENU_HQ_GGQQ                   (TZT_MENU_HQ_BEGIN+30) //12030 个股期权
#define  MENU_HQ_GGQQ_KindType          (TZT_MENU_HQ_BEGIN+31) //12031 个股期权－分类报价
#define  MENU_HQ_GGQQ_TType             (TZT_MENU_HQ_BEGIN+32) //12032 个股期权－T型报价

#define  MENU_HQ_MarketMenu             (TZT_MENU_HQ_BEGIN+50)  //12050 行情市场菜单

#define  MENU_HQ_Trend                  (TZT_MENU_HQ_BEGIN+51) //12051 分时走势
#define  MENU_HQ_HorizTrend             (TZT_MENU_HQ_BEGIN+52) //12052 横屏分时走势
#define  MENU_HQ_HisTrend			    (TZT_MENU_HQ_BEGIN+53) //12053 历史分时走势
#define  MENU_HQ_Tech					(TZT_MENU_HQ_BEGIN+54) //12054 K线图
#define  MENU_HQ_HorizTech				(TZT_MENU_HQ_BEGIN+55) //12055 横屏K线图
#define  MENU_HQ_FollowTech             (TZT_MENU_HQ_BEGIN+56) //12056 炒跟K线图
#define  MENU_HQ_SearchStock			(TZT_MENU_HQ_BEGIN+57) //12057 个股查询
#define  MENU_HQ_F10					(TZT_MENU_HQ_BEGIN+58) //12058 F10
#define  MENU_HQ_GraphF10				(TZT_MENU_HQ_BEGIN+59) //12059 图表F10
#define  MENU_HQ_GraphF9				(TZT_MENU_HQ_BEGIN+60) //12060 图表F9
#define  MENU_HQ_DiLei                  (TZT_MENU_HQ_BEGIN+61) //12061 信息地雷
#define  MENU_HQ_Finance				(TZT_MENU_HQ_BEGIN+62) //12062 财务数据
#define  MENU_HQ_Details				(TZT_MENU_HQ_BEGIN+63) //12063 明细
#define  MENU_HQ_FenJia                 (TZT_MENU_HQ_BEGIN+64) //12064 分价量表
#define  MENU_HQ_Price			     	(TZT_MENU_HQ_BEGIN+65) //12065 报价
#define  MENU_HQ_DaPangCangwei			(TZT_MENU_HQ_BEGIN+66) //12066 大盘仓位
#define  MENU_HQ_DaDanZijin             (TZT_MENU_HQ_BEGIN+67) //12067 大单资金
#define  MENU_HQ_PADF10					(TZT_MENU_HQ_BEGIN+68) //12068 PAD F10

//需用户登录
#define  MENU_HQ_UserStock				(TZT_MENU_HQ_BEGIN+100) //12100 自选排名
#define  MENU_HQ_Large                  (TZT_MENU_HQ_BEGIN+101) //12101 龙虎

#define  TZT_MENU_HQ_END				(TZT_MENU_HQ_BEGIN+200) //12200 行情功能 结束功能号
/***************行情功能 12200 END **********************/

//预留100功能


#define  TZT_MENU_JY_LIST               (TZT_MENU_HQ_END+50) //12250   交易列表、九宫格

/***************普通交易功能 12300 BEGIN**********************/
#define  TZT_MENU_JY_BEGIN              (TZT_MENU_HQ_END+100) //12300  交易开始
#define  TZT_MENU_JY_PT_BEGIN			(TZT_MENU_JY_BEGIN) //12300  普通交易功能
//列表或九宫格
#define  MENU_JY_PT_List				(TZT_MENU_JY_PT_BEGIN+1) //12301  普通交易列表、九宫格
#define  MENU_JY_PT_CardBank			(TZT_MENU_JY_PT_BEGIN+2) //12302  银证转账列表、九宫格
#define  MENU_JY_PT_More_List           (TZT_MENU_JY_PT_BEGIN+3) //12303  普通交易更多列表、九宫格
#define  MENU_JY_PT_NewStockList        (TZT_MENU_JY_PT_BEGIN+4) //12304  新股申购列表、九宫格

//功能
#define  MENU_JY_PT_Buy                 (TZT_MENU_JY_PT_BEGIN+10) //12310  委托买入
#define  MENU_JY_PT_Sell				(TZT_MENU_JY_PT_BEGIN+11) //12311  委托卖出
#define  MENU_JY_PT_Password			(TZT_MENU_JY_PT_BEGIN+12) //12312  修改密码
#define  MENU_JY_PT_UserInfo			(TZT_MENU_JY_PT_BEGIN+13) //12313  个人信息
#define  MENU_JY_PT_Quanzheng			(TZT_MENU_JY_PT_BEGIN+14) //12314  行权委托
#define  MENU_JY_PT_ZhaiZhuanGu         (TZT_MENU_JY_PT_BEGIN+15) //12315  债转股
#define  MENU_JY_PT_ZhaiQuanHuiShou     (TZT_MENU_JY_PT_BEGIN+16) //12316  债券回售
#define  MENU_JY_PT_XinGuShenGou        (TZT_MENU_JY_PT_BEGIN+18) //12318  新股申购
#define  MENU_JY_PT_NiHuiGou            (TZT_MENU_JY_PT_BEGIN+19) //12319  逆向回购

#define  MENU_JY_PT_Sign				(TZT_MENU_JY_PT_BEGIN+20) //12320  签署协议（各类协议通过参数传递）电子合同
#define  MENU_JY_PT_Review				(TZT_MENU_JY_PT_BEGIN+21) //12321  风险评测（各类评测通过参数传递）
#define  MENU_JY_PT_Power				(TZT_MENU_JY_PT_BEGIN+22) //12322  权限设置（各类权限通过参数传递）
#define  MENU_JY_PT_QueryDZHTHis        (TZT_MENU_JY_PT_BEGIN+23) //12323  电子合同流水查询
#define  MENU_JY_PT_QueryDZHTStatus     (TZT_MENU_JY_PT_BEGIN+24) //12324  电子合同状态查询


#define  MENU_JY_PT_Bank2Card			(TZT_MENU_JY_PT_BEGIN+30) //12330  资金转入
#define  MENU_JY_PT_Card2Bank			(TZT_MENU_JY_PT_BEGIN+31) //12331  资金转出
#define  MENU_JY_PT_BankYue				(TZT_MENU_JY_PT_BEGIN+32) //12332  银行余额

#define  MENU_JY_PT_DaiFaXinGu          (TZT_MENU_JY_PT_BEGIN+33) //12333  待发新股
#define  MENU_JY_PT_YiFaXinGu           (TZT_MENU_JY_PT_BEGIN+34) //12334  已发新股
#define  MENU_JY_PT_QueryWTXinGu        (TZT_MENU_JY_PT_BEGIN+35) //12335  新股委托查询
#define  MENU_JY_PT_QueryXinGu          (TZT_MENU_JY_PT_BEGIN+36) //12336  新股列表查询

//查询后有后续功能
#define  MENU_JY_PT_Withdraw			(TZT_MENU_JY_PT_BEGIN+40) //12340  委托撤单
#define  MENU_JY_PT_QueryDraw			(TZT_MENU_JY_PT_BEGIN+41) //12341  当日委托
#define  MENU_JY_PT_QueryStock			(TZT_MENU_JY_PT_BEGIN+42) //12342  查询股票


#define  MENU_JY_PT_QueryYLXX			(TZT_MENU_JY_PT_BEGIN+43) //12343  交易预留信息查询
#define  WT_QLSC_YLXXSet                (TZT_MENU_JY_PT_BEGIN+44) //12344  交易预留信息设置
#define  MENU_JY_PT_ZDTrade             (TZT_MENU_JY_PT_BEGIN+45) //12345  指定交易

#define  MENU_JY_PT_StockOut            (TZT_MENU_JY_PT_BEGIN+50) //12350  证券出借
#define  MENU_JY_PT_Voting              (TZT_MENU_JY_PT_BEGIN+51) //12351  投票

//通用查询
#define  MENU_JY_PT_QueryFunds			(TZT_MENU_JY_PT_BEGIN+60) //12360  查询资金
#define  MENU_JY_PT_QueryTradeDay		(TZT_MENU_JY_PT_BEGIN+61) //12361  当日成交
#define  MENU_JY_PT_QueryGdzl			(TZT_MENU_JY_PT_BEGIN+62) //12362  股东资料
#define  MENU_JY_PT_QueryBankHis		(TZT_MENU_JY_PT_BEGIN+63) //12363  转账流水

#define  MENU_JY_PT_QueryFundHis        (TZT_MENU_JY_PT_BEGIN+64) //12370  当日资金流水

#define  MENU_JY_PT_QueryStockOut 		(TZT_MENU_JY_PT_BEGIN+65) //12365  证券出借查询
#define  MENU_JY_PT_QueryNewStockED 	(TZT_MENU_JY_PT_BEGIN+66) //12366  新股申购额度查询
#define  MENU_JY_PT_QueryDeal           (TZT_MENU_JY_PT_BEGIN+67) //12367  成交汇总查询

//选择时间段
#define  MENU_JY_PT_QueryJG				(TZT_MENU_JY_PT_BEGIN+80) //12380  查询交割
#define  MENU_JY_PT_QueryPH				(TZT_MENU_JY_PT_BEGIN+81) //12381  查询配号
#define  MENU_JY_PT_QueryZJMX			(TZT_MENU_JY_PT_BEGIN+82) //12382  资金明细
#define  MENU_JY_PT_QueryTransHis		(TZT_MENU_JY_PT_BEGIN+83) //12383  历史成交
#define  MENU_JY_PT_QueryNewStockZQ 	(TZT_MENU_JY_PT_BEGIN+84) //12384  查询新股中签
#define  MENU_JY_PT_QueryHisTrade       (TZT_MENU_JY_PT_BEGIN+85) //12385  查询历史委托

#define  MENU_JY_PT_Power_SHFX			(TZT_MENU_JY_PT_BEGIN+95) //12395  上海风险警示权限设置（各类权限通过参数传递）
#define  MENU_JY_PT_Power_SHTS			(TZT_MENU_JY_PT_BEGIN+96) //12396  上海退市整理权限设置（各类权限通过参数传递）
#define  MENU_JY_PT_Power_SZTS			(TZT_MENU_JY_PT_BEGIN+97) //12397  深证退市权限设置（各类权限通过参数传递）

#define  TZT_MENU_JY_PT_END				(TZT_MENU_JY_PT_BEGIN +100) //12400  普通交易功能结束
/***************普通交易功能 12400 END**********************/
//预留100功能

/***************多存管交易功能 12500 BEGIN**********************/
#define  TZT_MENU_JY_DFBANK_BEGIN		(TZT_MENU_JY_PT_END +100) //12500  多存管交易功能
#define  MENU_JY_DFBANK_List			(TZT_MENU_JY_DFBANK_BEGIN +1) //12501  多存管列表、九宫格

#define  MENU_JY_DFBANK_Bank2Card		(TZT_MENU_JY_DFBANK_BEGIN +10)//12510 资金转入
#define  MENU_JY_DFBANK_Card2Bank		(TZT_MENU_JY_DFBANK_BEGIN +11) //12511  资金转出
#define  MENU_JY_DFBANK_BankYue			(TZT_MENU_JY_DFBANK_BEGIN +12) //12512  银行余额
#define  MENU_JY_DFBANK_Transit			(TZT_MENU_JY_DFBANK_BEGIN +13) //12513  资金调拨

#define  MENU_JY_DFBANK_Input			(TZT_MENU_JY_DFBANK_BEGIN +40)//12540 资金归集

#define  MENU_JY_DFBANK_QueryBankHis	(TZT_MENU_JY_DFBANK_BEGIN +60) //12560  转账流水
#define  MENU_JY_DFBANK_QueryTransitHis	(TZT_MENU_JY_DFBANK_BEGIN +61) //12561  调拨流水

#define  TZT_MENU_JY_DFBANK_END			(TZT_MENU_JY_DFBANK_BEGIN +100) //12600  多存管交易功能结束
/***************多存管交易功能 12600 END**********************/
//预留100功能


/***************基金交易功能 12700 BEGIN**********************/
#define  TZT_MENU_JY_FUND_BEGIN             (TZT_MENU_JY_DFBANK_END +100) //12700  基金交易功能
//列表或九宫格
#define  MENU_JY_FUND_List                  (TZT_MENU_JY_FUND_BEGIN+1) //12701 基金交易列表、九宫格
#define	 MENU_JY_FUNDIN_List				(TZT_MENU_JY_FUND_BEGIN+2) //12702 场内基金交易列表、九宫格
#define	 MENU_JY_FUND_QueryList             (TZT_MENU_JY_FUND_BEGIN+3) //12703 基金查询列表、九宫格
#define	 MENU_JY_FUND_DTList				(TZT_MENU_JY_FUND_BEGIN+4) //12704 基金定投列表、九宫格
#define  MENU_JY_FUND_PHList				(TZT_MENU_JY_FUND_BEGIN+5) //12705 基金盘后业务列表、九宫格（基金拆分合并）
#define	 MENU_JY_FUND_HBList				(TZT_MENU_JY_FUND_BEGIN+6) //12706 货币基金列表、九宫格

#define	 MENU_JY_FUND_RenGou				(TZT_MENU_JY_FUND_BEGIN+10) //12710 基金认购
#define	 MENU_JY_FUND_ShenGou               (TZT_MENU_JY_FUND_BEGIN+11) //12711 基金申购
#define	 MENU_JY_FUND_ShuHui				(TZT_MENU_JY_FUND_BEGIN+12) //12712 基金赎回
#define	 MENU_JY_FUND_FenHongSet			(TZT_MENU_JY_FUND_BEGIN+13) //12713 基金分红设置
#define	 MENU_JY_FUND_Change				(TZT_MENU_JY_FUND_BEGIN+14) //12714 基金转换
#define	 MENU_JY_FUND_Kaihu                 (TZT_MENU_JY_FUND_BEGIN +15) //12715  基金开户


#define	 MENU_JY_FUNDIN_RenGou				(TZT_MENU_JY_FUND_BEGIN+20) //12720 场内基金认购
#define	 MENU_JY_FUNDIN_ShenGou				(TZT_MENU_JY_FUND_BEGIN+21) //12721 场内基金申购
#define	 MENU_JY_FUNDIN_ShuHui				(TZT_MENU_JY_FUND_BEGIN+22) //12722 场内基金赎回

/*以下三个功能同上面场内三个功能，一创要求分开*/
#define	 MENU_JY_FUNDIN_HBJJRenGou				(TZT_MENU_JY_FUND_BEGIN+25) //12725 货币基金认购
#define	 MENU_JY_FUNDIN_HBJJShenGou				(TZT_MENU_JY_FUND_BEGIN+26) //12726 货币基金申购
#define	 MENU_JY_FUNDIN_HBJJShuHui				(TZT_MENU_JY_FUND_BEGIN+27) //12727 货币基金赎回


#define	 MENU_JY_FUND_ZhuheShenGou		     	(TZT_MENU_JY_FUND_BEGIN+30) //12730 组合基金申购
#define	 MENU_JY_FUND_ZhuheShuHui		     	(TZT_MENU_JY_FUND_BEGIN+31) //12731 组合基金赎回
#define	 MENU_JY_FUND_ZhuheShenGouInfo		    (TZT_MENU_JY_FUND_BEGIN+32) //12732 组合基金申购信息 // 组合基金信息
#define	 MENU_JY_FUND_ZhuheShenGouQingDan		(TZT_MENU_JY_FUND_BEGIN+33) //12733 组合基金申购生成清单 // 组合基金生成清单

#define	 MENU_JY_FUND_DTReq                 (TZT_MENU_JY_FUND_BEGIN+40) //12740 基金定投登记
#define	 MENU_JY_FUND_DTChange				(TZT_MENU_JY_FUND_BEGIN+41) //12741 基金定投变约
#define	 MENU_JY_FUND_DTCancel				(TZT_MENU_JY_FUND_BEGIN+42) //12742 基金定投取消

#define	 MENU_JY_FUND_PHSplit				(TZT_MENU_JY_FUND_BEGIN+50) //12750 基金分拆
#define	 MENU_JY_FUND_PHMerge				(TZT_MENU_JY_FUND_BEGIN+51) //12751 基金合并
#define	 MENU_JY_FUND_PHCancel				(TZT_MENU_JY_FUND_BEGIN+52) //12752 基金定投取消

#define	 MENU_JY_FUND_HBShenGou				(TZT_MENU_JY_FUND_BEGIN+60) //12760 货币基金申购
#define	 MENU_JY_FUND_HBShuHui				(TZT_MENU_JY_FUND_BEGIN+61) //12761 货币基金赎回
#define	 MENU_JY_FUND_HBRenGou				(TZT_MENU_JY_FUND_BEGIN+62) //12762 货币基金认购 wry

//查询后有后续功能
#define  MENU_JY_FUND_Withdraw				(TZT_MENU_JY_FUND_BEGIN +100) //12800  委托撤单
#define  MENU_JY_FUND_QueryDraw             (TZT_MENU_JY_FUND_BEGIN +101) //12801  当日委托
#define  MENU_JY_FUND_QueryStock			(TZT_MENU_JY_FUND_BEGIN +102) //12802  基金份额（持仓基金）
#define  MENU_JY_FUND_NoKaihu		    	(TZT_MENU_JY_FUND_BEGIN +103) //12803  未开户基金
#define  MENU_JY_FUND_PHWithdraw			(TZT_MENU_JY_FUND_BEGIN +104) //12804  基金盘后委托撤单
#define  MENU_JY_FUND_PHQueryDraw			(TZT_MENU_JY_FUND_BEGIN +105) //12805  基金盘后查询委托
#define  MENU_JY_FUND_HBWithdraw			(TZT_MENU_JY_FUND_BEGIN +106) //12806  货币基金委托撤单
#define  MENU_JY_FUND_HBQueryDraw           (TZT_MENU_JY_FUND_BEGIN +107) //12807  货币基金当日委托

//通用查询
#define  MENU_JY_FUND_QueryPrice			(TZT_MENU_JY_FUND_BEGIN +120) //12820  基金净值
#define  MENU_JY_FUND_QueryUserInfo			(TZT_MENU_JY_FUND_BEGIN +121) //12821  客户资料
#define  MENU_JY_FUND_PHQueryTrade			(TZT_MENU_JY_FUND_BEGIN +122) //12822  基金盘后查询成交
#define  MENU_JY_FUND_QueryKaihu			(TZT_MENU_JY_FUND_BEGIN +123) //12823  基金帐户（已开户基金）
#define  MENU_JY_FUND_QueryAllCode          (TZT_MENU_JY_FUND_BEGIN +124) //12824  基金代码查询（表格显示）
#define  MENU_JY_FUND_QueryAllCompany       (TZT_MENU_JY_FUND_BEGIN +125) //12825  基金公司查询 (表格显示)

#define  MENU_JY_FUND_FengXianDengJIQuery   (TZT_MENU_JY_FUND_BEGIN +128) //12828  基金风险等级查询
#define  MENU_JY_FUND_RecommandFund         (TZT_MENU_JY_FUND_BEGIN +130) //12830  推荐基金

//选择时间段
#define  MENU_JY_FUND_QueryWTHis			(TZT_MENU_JY_FUND_BEGIN +140) //12840  历史委托
#define  MENU_JY_FUND_QueryVerifyHis		(TZT_MENU_JY_FUND_BEGIN +141) //12841  历史确认(历史成交？)


#define  MENU_JY_FUND_XJBLEDSearch		    (TZT_MENU_JY_FUND_BEGIN +142) //12842  现金保留额度设置
#define  MENU_JY_FUND_KHCYZTSearch		    (TZT_MENU_JY_FUND_BEGIN +143) //12843  客户参与状态设置
#define  MENU_JY_FUND_XJBLEDSetting		    (TZT_MENU_JY_FUND_BEGIN +144) //12844  现金保留额度设置
#define  MENU_JY_FUND_KHCYZTSetting		    (TZT_MENU_JY_FUND_BEGIN +145) //12845  客户参与状态设置
#define  MENU_JY_FUND_HBQueryHis            (TZT_MENU_JY_FUND_BEGIN +146) //12846  货币基金历史委托
#define  MENU_JY_FUND_XJCPSign              (TZT_MENU_JY_FUND_BEGIN +147) //12847  现金产品协议签约

#define  MENU_JY_FUND_PHQueryHisWT          (TZT_MENU_JY_FUND_BEGIN +150) //12850   基金盘后历史委托
#define  MENU_JY_FUND_PHQuertHisCJ          (TZT_MENU_JY_FUND_BEGIN +151) //12851   基金盘后历史成交

#define  TZT_MENU_JY_FUND_END				(TZT_MENU_JY_FUND_BEGIN +200) //12900  基金交易功能结束
/***************基金交易功能 12900 END**********************/
//预留100功能

/***************三板交易功能 13000 BEGIN**********************/
#define  TZT_MENU_JY_SB_BEGIN			(TZT_MENU_JY_FUND_END +100) //13000  三板交易功能
//列表或九宫格
#define	 MENU_JY_SB_List				(TZT_MENU_JY_SB_BEGIN +1) //13001 三板交易列表、九宫格
//功能
#define  MENU_JY_SB_YXBuy				(TZT_MENU_JY_SB_BEGIN +10) //13010  意向买入//新三板－限价买入
#define  MENU_JY_SB_YXSell				(TZT_MENU_JY_SB_BEGIN +11) //13011  意向卖出//新三板－限价卖出
#define  MENU_JY_SB_QRBuy				(TZT_MENU_JY_SB_BEGIN +12) //13012  确认买入//新三板－成交确认买入
#define  MENU_JY_SB_QRSell				(TZT_MENU_JY_SB_BEGIN +13) //13013  确认卖出//新三板－成交确认卖出
#define  MENU_JY_SB_DJBuy				(TZT_MENU_JY_SB_BEGIN +14) //13014  定价买入
#define  MENU_JY_SB_DJSell				(TZT_MENU_JY_SB_BEGIN +15) //13015  定价卖出
#define  MENU_JY_SB_HBQRBuy             (TZT_MENU_JY_SB_BEGIN +16) //13016  互报成交确认买入
#define  MENU_JY_SB_HBQRSell            (TZT_MENU_JY_SB_BEGIN +17) //13017  互报成交确认卖出

#define  MENU_JY_SB_HQ					(TZT_MENU_JY_SB_BEGIN+20) //13020  三板行情

//查询后有后续功能
#define  MENU_JY_SB_Withdraw			(TZT_MENU_JY_SB_BEGIN+40) //13040  委托撤单
#define  MENU_JY_SB_QueryDraw			(TZT_MENU_JY_SB_BEGIN+41) //13041  当日委托
#define  MENU_JY_SB_QueryTrans			(TZT_MENU_JY_SB_BEGIN+42) //13042  当日成交
#define  MENU_JY_SB_QueryYXD            (TZT_MENU_JY_SB_BEGIN+43) //13043  意向单查询


#define  MENU_JY_SB_QRBuyEx             (TZT_MENU_JY_SB_BEGIN+90) //13090   成交确认买入（网页选择）
#define  MENU_JY_SB_QRSellEx            (TZT_MENU_JY_SB_BEGIN+91) //13091   成交确认卖出（网页选择）


#define  TZT_MENU_JY_SB_END				(TZT_MENU_JY_SB_BEGIN +100) //13100  三板交易功能结束
/***************三板交易功能 13100 END**********************/
//预留100功能

/***************大宗交易功能 13200 BEGIN**********************/
#define  TZT_MENU_JY_DZJY_BEGIN			(TZT_MENU_JY_SB_END +100) //13200  大宗交易功能
//列表或九宫格
#define	 MENU_JY_DZJY_List				(TZT_MENU_JY_DZJY_BEGIN +1) //13201 大宗交易列表、九宫格
//功能
#define  MENU_JY_DZJY_YXBuy				(TZT_MENU_JY_DZJY_BEGIN +10) //13210  意向买入
#define  MENU_JY_DZJY_YXSell			(TZT_MENU_JY_DZJY_BEGIN +11) //13211  意向卖出
#define  MENU_JY_DZJY_QRBuy				(TZT_MENU_JY_DZJY_BEGIN +12) //13212  确认买入
#define  MENU_JY_DZJY_QRSell			(TZT_MENU_JY_DZJY_BEGIN +13) //13213  确认卖出
#define  MENU_JY_DZJY_DJBuy				(TZT_MENU_JY_DZJY_BEGIN +14) //13214  定价买入
#define  MENU_JY_DZJY_DJSell			(TZT_MENU_JY_DZJY_BEGIN +15) //13215  定价卖出

#define  MENU_JY_DZJY_HQ				(TZT_MENU_JY_DZJY_BEGIN +20) //13220  行情查询

//查询后有后续功能
#define  MENU_JY_DZJY_Withdraw			(TZT_MENU_JY_DZJY_BEGIN +40) //13240  委托撤单
#define  MENU_JY_DZJY_QueryDraw			(TZT_MENU_JY_DZJY_BEGIN +41) //13241  当日委托
#define  MENU_JY_DZJY_QueryTrans		(TZT_MENU_JY_DZJY_BEGIN +42) //13242  当日成交

#define  TZT_MENU_JY_DZJY_END			(TZT_MENU_JY_DZJY_BEGIN +100) //13300  大宗交易功能结束
/***************大宗交易功能 13300 END**********************/
//预留100功能

/***************多空如弈 13400 BEGIN**********************/
#define  TZT_MENU_JY_DKRY_BEGIN			(TZT_MENU_JY_DZJY_END +100) //13400  多空如弈功能
//列表或九宫格
#define	 MENU_JY_DKRY_List				(TZT_MENU_JY_DKRY_BEGIN +1) //13401 多空如弈交易列表、九宫格
//功能
#define  MENU_JY_DKRY_ShenGou			(TZT_MENU_JY_DKRY_BEGIN +10) //13410  申购
#define  MENU_JY_DKRY_ShuHui			(TZT_MENU_JY_DKRY_BEGIN +11) //13411  赎回
#define  MENU_JY_DKRY_Up				(TZT_MENU_JY_DKRY_BEGIN +12) //13412  母转看涨
#define  MENU_JY_DKRY_Down				(TZT_MENU_JY_DKRY_BEGIN +13) //13413  母转看跌
#define  MENU_JY_DKRY_Index             (TZT_MENU_JY_DKRY_BEGIN +14) //13414  多空如弈首页
#define  MENU_JY_DKRY_Info              (TZT_MENU_JY_DKRY_BEGIN +15) //13415  使用说明和风险揭示

//查询后有后续功能
#define  MENU_JY_DKRY_Withdraw			(TZT_MENU_JY_DKRY_BEGIN +40) //13440  委托撤单
#define  MENU_JY_DKRY_QueryDraw			(TZT_MENU_JY_DKRY_BEGIN +41) //13441  当日委托
#define  MENU_JY_DKRY_QueryStock		(TZT_MENU_JY_DKRY_BEGIN +43) //13443  查询持仓

#define  MENU_JY_DKRY_DayQuery          (TZT_MENU_JY_DKRY_BEGIN +50) //13450  日版综合查询
#define  MENU_JY_DKRY_WeekQuery         (TZT_MENU_JY_DKRY_BEGIN +51) //13451  周版综合查询
#define  MENU_JY_DKRY_WeekWithDraw      (TZT_MENU_JY_DKRY_BEGIN +52) //13452  周版撤单查询
#define  MENU_JY_DKRY_DayWeiTuoQuery (TZT_MENU_JY_DKRY_BEGIN+53) //13453  日版委托查询

#define  MENU_JY_DKRY_QueryFundsRatio	(TZT_MENU_JY_DKRY_BEGIN +60) //13460  资产净比
#define  MENU_JY_DKRY_QuerySQDK         (TZT_MENU_JY_DKRY_BEGIN +61) //13461  查询本期多空比
#define  MENU_JY_DKRY_QuerySLWT         (TZT_MENU_JY_DKRY_BEGIN +62) //13462  查询受理委托
#define  MENU_JY_DKRY_QueryWSLWT        (TZT_MENU_JY_DKRY_BEGIN +63) //13463  查询未受理委托
#define  MENU_JY_DKRY_QueryYGYK         (TZT_MENU_JY_DKRY_BEGIN +64) //13464  查询预估盈亏

#define  MENU_JY_DKRY_QueryWTHis		(TZT_MENU_JY_DKRY_BEGIN +80) //13480  历史委托
#define  MENU_JY_DKRY_QueryVerifyHis	(TZT_MENU_JY_DKRY_BEGIN +81) //13481  委托确认

#define  TZT_MENU_JY_DKRY_END			(TZT_MENU_JY_DKRY_BEGIN +100) //13500  多空如弈功能结束
/***************多空如弈功能 13500 END**********************/
//预留100功能

/***************质押回购功能 13600 BEGIN**********************/
#define  TZT_MENU_JY_ZYHG_BEGIN			(TZT_MENU_JY_DKRY_END +100) //13600  质押回购功能
//列表或九宫格
#define	 MENU_JY_ZYHG_List				(TZT_MENU_JY_ZYHG_BEGIN +1) //13601 质押回购交易列表、九宫格
//功能
#define  MENU_JY_ZYHG_StockBuy			(TZT_MENU_JY_ZYHG_BEGIN +10) //13610  质押债券入库
#define  MENU_JY_ZYHG_StockSell			(TZT_MENU_JY_ZYHG_BEGIN +11) //13611  质押债券出库
#define  MENU_JY_ZYHG_RZBuy				(TZT_MENU_JY_ZYHG_BEGIN +12) //13612  融资回购
#define  MENU_JY_ZYHG_RQBuy				(TZT_MENU_JY_ZYHG_BEGIN +13) //13613  融券回购
#define  MENU_JY_ZYHG_ZQBuy             (TZT_MENU_JY_ZYHG_BEGIN +14) //13614  债券买入
#define  MENU_JY_ZYHG_ZQSell			(TZT_MENU_JY_ZYHG_BEGIN +15) //13615  债券卖出

#define  MENU_JY_ZYHG_QueryInfo			(TZT_MENU_JY_ZYHG_BEGIN +60) //13660  质押明细
#define  MENU_JY_ZYHG_QueryNoDue		(TZT_MENU_JY_ZYHG_BEGIN +61) //13661  未到期回购查询
#define  MENU_JY_ZYHG_QueryStanda		(TZT_MENU_JY_ZYHG_BEGIN +62) //13662  标准券明细查询
#define  MENU_JY_ZYHG_QuerySell         (TZT_MENU_JY_ZYHG_BEGIN +63) //13663  质押出库查询
#define  MENU_JY_ZYHG_QueryBuySell      (TZT_MENU_JY_ZYHG_BEGIN +64) //13664  质押出入库
#define  MENU_JY_ZYHG_Withdraw          (TZT_MENU_JY_ZYHG_BEGIN +65) //13665  债券撤单


#define  TZT_MENU_JY_ZYHG_END			(TZT_MENU_JY_ZYHG_BEGIN +100) //13700  质押回购功能结束
/***************质押回购功能 13700 END**********************/
//预留100功能

/***************报价回购功能 13800 BEGIN**********************/
#define  TZT_MENU_JY_BJHG_BEGIN			(TZT_MENU_JY_ZYHG_END +100) //13800  报价回购功能
//列表或九宫格
#define	 MENU_JY_BJHG_List				(TZT_MENU_JY_BJHG_BEGIN +1) //13801 报价回购交易列表、九宫格
//功能
#define  MENU_JY_BJHG_Buy				(TZT_MENU_JY_BJHG_BEGIN +10) //13810  委托买入

//查询后有后续功能
#define  MENU_JY_BJHG_QueryDraw			(TZT_MENU_JY_BJHG_BEGIN +40) //13840  当日委托387
#define  MENU_JY_BJHG_Stop				(TZT_MENU_JY_BJHG_BEGIN +41) //13841  终止续作387/390
#define  MENU_JY_BJHG_Ahead				(TZT_MENU_JY_BJHG_BEGIN +42) //13842  提前购回 388
#define  MENU_JY_BJHG_MakeAn			(TZT_MENU_JY_BJHG_BEGIN +43) //13843  预约提购 388
#define  MENU_JY_BJHG_AllInfo			(TZT_MENU_JY_BJHG_BEGIN +44) //13844  所有信息查询380
#define  MENU_JY_BJHG_DEYYZZ			(TZT_MENU_JY_BJHG_BEGIN +45) //13845  大额预约终止391
#define  MENU_JY_BJHG_Withdraw			(TZT_MENU_JY_BJHG_BEGIN +46) //13846  委托撤单393
#define  MENU_JY_BJHG_YYZZWithdraw		(TZT_MENU_JY_BJHG_BEGIN +47) //13847  预约终止撤单392
#define  MENU_JY_BJHG_HisQuery          (TZT_MENU_JY_BJHG_BEGIN +48) //13848  历史委托查询389
#define  MENU_JY_BJHG_DealQuery         (TZT_MENU_JY_BJHG_BEGIN +49) //13849  成交查询650
#define  MENU_JY_BJHG_QueryDue          (TZT_MENU_JY_BJHG_BEGIN +50) //13850  展期合约查询


#define  MENU_JY_BJHG_QueryNoDue		(TZT_MENU_JY_BJHG_BEGIN +60) //13860  未到期 388
#define  MENU_JY_BJHG_QueryInfo			(TZT_MENU_JY_BJHG_BEGIN +61) //13861  质押明细 394


#define  TZT_MENU_JY_BJHG_END			(TZT_MENU_JY_BJHG_BEGIN +100) //13900  报价回购功能结束
/***************报价回购功能 13900 END**********************/
//预留100功能

/***************ETF网下功能 14000 BEGIN**********************/
#define  TZT_MENU_JY_ETFWX_BEGIN		(TZT_MENU_JY_BJHG_END +100) //14000  ETF网下功能
//列表或九宫格
#define	 MENU_JY_ETFWX_List				(TZT_MENU_JY_ETFWX_BEGIN +1) //14001 ETF网下交易列表、九宫格
#define	 MENU_JY_ETFKS_List				(TZT_MENU_JY_ETFWX_BEGIN +2) //14002 ETF跨市交易列表、九宫格


//功能
#define  MENU_JY_ETFWX_FundBuy			(TZT_MENU_JY_ETFWX_BEGIN +10) //14010  现金认购
#define  MENU_JY_ETFWX_StockBuy			(TZT_MENU_JY_ETFWX_BEGIN +11) //14011  股票认购
#define  MENU_JY_ETFWX_FundWithdraw     (TZT_MENU_JY_ETFWX_BEGIN +12) //14012  现金认购撤单
#define  MENU_JY_ETFWX_StockWithdraw    (TZT_MENU_JY_ETFWX_BEGIN +13) //14013  股票认购撤单
#define  MENU_JY_ETFWX_ShenGou          (TZT_MENU_JY_ETFWX_BEGIN +14) //14014  ETF申购
#define  MENU_JY_ETFWX_ShuHui           (TZT_MENU_JY_ETFWX_BEGIN +15) //14015  ETF赎回


//查询后有后续功能
#define  MENU_JY_ETFWX_Withdraw			(TZT_MENU_JY_ETFWX_BEGIN +40) //14040  委托撤单
#define  MENU_JY_ETFWX_QueryFund		(TZT_MENU_JY_ETFWX_BEGIN +41) //14041  现金认购查询
#define  MENU_JY_ETFWX_QueryStock		(TZT_MENU_JY_ETFWX_BEGIN +42) //14042  股票认购查询

// ETF跨市
#define  MENU_JY_ETFKS_HSFundBuy        (TZT_MENU_JY_ETFWX_BEGIN +71) //14071  沪市现金认购
#define  MENU_JY_ETFKS_HSStockBuy 		(TZT_MENU_JY_ETFWX_BEGIN +72) //14072  沪市股票认购
#define  MENU_JY_ETFKS_SSStockBuy		(TZT_MENU_JY_ETFWX_BEGIN +73) //14073  深市股份认购
#define  MENU_JY_ETFKS_HSFundWithdraw	(TZT_MENU_JY_ETFWX_BEGIN +74) //14074  沪市现金撤单
#define  MENU_JY_ETFKS_HSStockWithdraw	(TZT_MENU_JY_ETFWX_BEGIN +75) //14075  沪市股票撤单
#define  MENU_JY_ETFKS_SSRGWithdraw     (TZT_MENU_JY_ETFWX_BEGIN +76) //14076  深市认购撤单
#define  MENU_JY_ETFKS_ShenGou          (TZT_MENU_JY_ETFWX_BEGIN +77) //14077  ETF跨市申购
#define  MENU_JY_ETFKS_ShuHui           (TZT_MENU_JY_ETFWX_BEGIN +78) //14078  ETF跨市赎回

// ETF跨市查询功能
#define  MENU_JY_ETFKS_HSQueryFund		(TZT_MENU_JY_ETFWX_BEGIN +81) //14081  沪市现金查询
#define  MENU_JY_ETFKS_HSQueryStock     (TZT_MENU_JY_ETFWX_BEGIN +82) //14082  沪市股票查询
#define  MENU_JY_ETFKS_SSRGQuery        (TZT_MENU_JY_ETFWX_BEGIN +83) //14083  深市认购查询



#define  TZT_MENU_JY_ETFWX_END			(TZT_MENU_JY_ETFWX_BEGIN +100) //14100  ETF网下功能结束
/***************ETF网下功能 14100 END**********************/
//预留900功能

/***************集合计划功能 14200 BEGIN**********************/
#define TZT_MENU_JY_JHJH_BEGIN          (TZT_MENU_JY_ETFWX_END + 100)   //14200  集合计划功能
#define MENU_JY_JHJH_List               (TZT_MENU_JY_JHJH_BEGIN + 1)    //14201 集合计划宫格Trade_Jhjh_Grid

#define MENU_JY_JHJH_RenGou             (TZT_MENU_JY_JHJH_BEGIN +10)    //14210 集合计划认购Trade_Jhjh_RenGou
#define MENU_JY_JHJH_ShenGou            (TZT_MENU_JY_JHJH_BEGIN+ 11)    //14211 集合计划申购Trade_Jhjh_ShenGou
#define MENU_JY_JHJH_ShuHui             (TZT_MENU_JY_JHJH_BEGIN +12)    //14212 集合计划赎回Trade_Jhjh_ShuHui
#define MENU_JY_JHJH_Transit            (TZT_MENU_JY_JHJH_BEGIN +13)    //14213 集合计划划转Trade_Jhjh_HuaZhuan

#define MENU_JY_JHJH_WithDraw           (TZT_MENU_JY_JHJH_BEGIN +20)    //14220 集合计划撤单Trade_Jhjh_WithDraw
#define MENU_JY_JHJH_QueryFenHong       (TZT_MENU_JY_JHJH_BEGIN +21)    //14221 集合计划分红查询Trade_Jhjh_FenHongQuery

#define MENU_JY_JHJH_QueryFenE          (TZT_MENU_JY_JHJH_BEGIN + 22) // 14222  集合计划份额查询
#define MENU_JY_JHJH_QueryWT            (TZT_MENU_JY_JHJH_BEGIN + 23) // 14223  集合计划委托查询
#define MENU_JY_JHJH_QueryDeal          (TZT_MENU_JY_JHJH_BEGIN + 24) // 14224  集合计划成交查询

#define TZT_MENU_JY_JHJH_END            (TZT_MENU_JY_JHJH_BEGIN + 100)  //14300  集合计划功能结束




/***************融资融券交易功能 15000 BEGIN**********************/
#define  TZT_MENU_JY_RZRQ_BEGIN			(TZT_MENU_JY_ETFWX_END +900) //15000  融资融券交易功能
//列表或九宫格
#define  MENU_JY_RZRQ_List				(TZT_MENU_JY_RZRQ_BEGIN+1) //15001  融资融券交易列表、九宫格
#define  MENU_JY_RZRQ_WTList			(TZT_MENU_JY_RZRQ_BEGIN+2) //15002  融资融券委托列表、九宫格
#define  MENU_JY_RZRQ_CardBankList		(TZT_MENU_JY_RZRQ_BEGIN+3) //15003  银证转账列表、九宫格
#define  MENU_JY_RZRQ_QueryList			(TZT_MENU_JY_RZRQ_BEGIN+4) //15004  融资融券查询列表、九宫格
#define  MENU_JY_RZRQ_ZXList			(TZT_MENU_JY_RZRQ_BEGIN+5) //15005  专项融资融券列表、九宫格
#define  MENU_JY_RZRQ_QueryMore_Grid    (TZT_MENU_JY_RZRQ_BEGIN+6) //15006  融资融券查询更多宫格
#define  MENU_JY_RZRQ_Other_Grid        (TZT_MENU_JY_RZRQ_BEGIN+7) //15007  融资融券其他宫格


//功能
#define  MENU_JY_RZRQ_PTBuy				(TZT_MENU_JY_RZRQ_BEGIN+10) //15010  普通买入（信用买入）
#define  MENU_JY_RZRQ_PTSell			(TZT_MENU_JY_RZRQ_BEGIN+11) //15011  普通卖出（信用卖出）
#define  MENU_JY_RZRQ_XYBuy				(TZT_MENU_JY_RZRQ_BEGIN+12) //15012  融资买入
#define  MENU_JY_RZRQ_XYSell			(TZT_MENU_JY_RZRQ_BEGIN+13) //15013  融券卖出
#define  MENU_JY_RZRQ_BuyReturn			(TZT_MENU_JY_RZRQ_BEGIN+14) //15014  买券还券
#define  MENU_JY_RZRQ_SellReturn		(TZT_MENU_JY_RZRQ_BEGIN+15) //15015  卖券还款
#define  MENU_JY_RZRQ_ReturnStock		(TZT_MENU_JY_RZRQ_BEGIN+16) //15016  现券还券（直接还券）
#define  MENU_JY_RZRQ_ReturnFunds		(TZT_MENU_JY_RZRQ_BEGIN+17) //15017  直接还款
#define  MENU_JY_RZRQ_Password			(TZT_MENU_JY_RZRQ_BEGIN+18) //15018  修改密码
#define  MENU_JY_RZRQ_Vote				(TZT_MENU_JY_RZRQ_BEGIN+19) //15019  客户投票
#define  MENU_JY_RZRQ_Transit			(TZT_MENU_JY_RZRQ_BEGIN+20) //15020  担保划转

#define  MENU_JY_RZRQ_YuQuanTransit         (TZT_MENU_JY_RZRQ_BEGIN+23) //15023 余券划转
#define  MENU_JY_RZRQ_XingQuan              (TZT_MENU_JY_RZRQ_BEGIN+24) //15024 行权委托

#define  MENU_JY_RZRQ_Power                 (TZT_MENU_JY_RZRQ_BEGIN+25) //15025 权限设置
#define  MENU_JY_RZRQ_Power_SHFX            (TZT_MENU_JY_RZRQ_BEGIN+26) //15026 上海风险警示权限设置
#define  MENU_JY_RZRQ_Power_SHTS            (TZT_MENU_JY_RZRQ_BEGIN+27) //15027 上海退市整理权限设置
#define  MENU_JY_RZRQ_Power_SZTS            (TZT_MENU_JY_RZRQ_BEGIN+28) //15028 深证退市整理权限设置

#define  MENU_JY_RZRQ_NewStockSG            (TZT_MENU_JY_RZRQ_BEGIN+30) //15030
#define  MENU_JY_RZRQ_DaiFaXinGu            (TZT_MENU_JY_RZRQ_BEGIN+31) //15031  待发新股
#define  MENU_JY_RZRQ_YiFaXinGu             (TZT_MENU_JY_RZRQ_BEGIN+32) //15032  已发新股
#define  MENU_JY_RZRQ_QueryWTXinGu          (TZT_MENU_JY_RZRQ_BEGIN+33) //15033  新股委托查询

#define  MENU_JY_RZRQZX_XYBuy				(TZT_MENU_JY_RZRQ_BEGIN+52) //15052  融资买入
#define  MENU_JY_RZRQZX_XYSell				(TZT_MENU_JY_RZRQ_BEGIN+53) //15053  融券卖出
#define  MENU_JY_RZRQZX_BuyReturn			(TZT_MENU_JY_RZRQ_BEGIN+54) //15054  买券还券
#define  MENU_JY_RZRQZX_SellReturn			(TZT_MENU_JY_RZRQ_BEGIN+55) //15055  卖券还款
#define  MENU_JY_RZRQZX_ReturnStock			(TZT_MENU_JY_RZRQ_BEGIN+56) //15056  现券还券（直接还券）
#define  MENU_JY_RZRQZX_ReturnFunds			(TZT_MENU_JY_RZRQ_BEGIN+57) //15057  直接还款



#define  MENU_JY_RZRQ_Bank2Card             (TZT_MENU_JY_RZRQ_BEGIN+100) //15100  资金转入
#define  MENU_JY_RZRQ_Card2Bank             (TZT_MENU_JY_RZRQ_BEGIN+101) //15101  资金转出
#define  MENU_JY_RZRQ_BankYue               (TZT_MENU_JY_RZRQ_BEGIN+102) //15102  银行余额

//查询后有后续功能
#define  MENU_JY_RZRQ_Withdraw              (TZT_MENU_JY_RZRQ_BEGIN+120) //15120  委托撤单
#define  MENU_JY_RZRQ_QueryDraw             (TZT_MENU_JY_RZRQ_BEGIN+121) //15121  当日委托
#define  MENU_JY_RZRQ_QueryStock			(TZT_MENU_JY_RZRQ_BEGIN+122) //15122  查询股票（查询持仓）
#define  MENU_JY_RZRQ_TransWithdraw			(TZT_MENU_JY_RZRQ_BEGIN+123) //15123  划转撤单
#define  MENU_JY_RZRQ_TransQueryDraw		(TZT_MENU_JY_RZRQ_BEGIN+124) //15124  划转流水
#define  MENU_JY_RZRQ_NoTradeQueryDraw		(TZT_MENU_JY_RZRQ_BEGIN+125) //15125  非交易过户委托


#define  MENU_JY_RZRQ_JYGL                  (TZT_MENU_JY_RZRQ_BEGIN+130) //15130  交易攻略
#define  MENU_JY_RZRQ_FXJS                  (TZT_MENU_JY_RZRQ_BEGIN+131) //15131  风险揭示

//通用查询
#define  MENU_JY_RZRQ_QueryFunds			(TZT_MENU_JY_RZRQ_BEGIN+200) //15200  查询资金
#define  MENU_JY_RZRQ_QUeryTransDay			(TZT_MENU_JY_RZRQ_BEGIN+201) //15201  当日成交
#define  MENU_JY_RZRQ_QueryBankHis			(TZT_MENU_JY_RZRQ_BEGIN+202) //15202  转账流水
#define  MENU_JY_RZRQ_QueryFundsDay			(TZT_MENU_JY_RZRQ_BEGIN+203) //15203  当日资金流水
#define  MENU_JY_RZRQ_QueryDebtDay			(TZT_MENU_JY_RZRQ_BEGIN+204) //15204  当日负债流水
#define  MENU_JY_RZRQ_QueryDBZQ             (TZT_MENU_JY_RZRQ_BEGIN+205) //15205  担保证券查询
#define  MENU_JY_RZRQ_QueryBDZQ             (TZT_MENU_JY_RZRQ_BEGIN+206) //15206  标的证券查询
#define  MENU_JY_RZRQ_QueryKRZQ             (TZT_MENU_JY_RZRQ_BEGIN+207) //15207  可融证券查询

#define  MENU_JY_RZRQ_QueryRZQK             (TZT_MENU_JY_RZRQ_BEGIN+208) //15208  融资情况查询  融资债细 融资明细
#define  MENU_JY_RZRQ_QueryRQQK             (TZT_MENU_JY_RZRQ_BEGIN+209) //15209  融券情况查询  融券债细 融券明细

#define  MENU_JY_RZRQ_QueryZCFZQK			(TZT_MENU_JY_RZRQ_BEGIN+210) //15210  资产负债查询 查询资产 信用负债
#define  MENU_JY_RZRQ_QueryRZFZQK			(TZT_MENU_JY_RZRQ_BEGIN+211) //15211  融资负债查询 融资合约
#define  MENU_JY_RZRQ_QueryRQFZQK			(TZT_MENU_JY_RZRQ_BEGIN+212) //15212  融券负债查询 融券合约
#define  MENU_JY_RZRQ_QueryContract			(TZT_MENU_JY_RZRQ_BEGIN+213) //15213  合同查询
#define  MENU_JY_RZRQ_QueryBail             (TZT_MENU_JY_RZRQ_BEGIN+214) //15214  保证金查询
#define  MENU_JY_RZRQ_QueryCANBUY           (TZT_MENU_JY_RZRQ_BEGIN+215) //15215  委托查询可融资买入标的券 //add
#define  MENU_JY_RZRQ_QueryCANSALE          (TZT_MENU_JY_RZRQ_BEGIN+216) //15216  委托查询可融券卖出标的券 //add

#define  MENU_JY_RZRQ_QueryXYShangXian      (TZT_MENU_JY_RZRQ_BEGIN+218) //15218  信用上限查询
#define  MENU_JY_RZRQ_QueryFundsDayHis		(TZT_MENU_JY_RZRQ_BEGIN+219) //15219  资金流水
#define  MENU_JY_RZRQ_QueryNewStockED       (TZT_MENU_JY_RZRQ_BEGIN+220) //15220  新股申购额度查询
#define  MENU_JY_RZRQ_QueryDealOver         (TZT_MENU_JY_RZRQ_BEGIN+221) //15221  已了结合约查询、已平仓


#define  MENU_JY_RZRQZX_QueryStockTC		(TZT_MENU_JY_RZRQ_BEGIN+250) //15250  股票头寸查询
#define  MENU_JY_RZRQZX_QueryFundsTC		(TZT_MENU_JY_RZRQ_BEGIN+251) //15251  资金头寸查询


#define  MENU_JY_RZRQ_QueryXYZC             (TZT_MENU_JY_RZRQ_BEGIN+260) //15260  信用资产（新定义统一页面使用）
#define  MENU_JY_RZRQ_QueryHeYue            (TZT_MENU_JY_RZRQ_BEGIN+261) //15261  合约查询
#define  MENU_JY_RZRQ_QueryRZBD             (TZT_MENU_JY_RZRQ_BEGIN+262) //15262  融资标的
#define  MENU_JY_RZRQ_QueryRQBD             (TZT_MENU_JY_RZRQ_BEGIN+263) //15263  融券标的

#define  MENU_JY_RZRQ_QueryVoteCount        (TZT_MENU_JY_RZRQ_BEGIN+264) //15264  投票统计查询
#define  MENU_JY_RZRQ_QueryVoteResult       (TZT_MENU_JY_RZRQ_BEGIN+265) //15265  投票结果查询

//选择时间段
#define  MENU_JY_RZRQ_QueryJG				(TZT_MENU_JY_RZRQ_BEGIN+300) //15300  交割单查询
#define  MENU_JY_RZRQ_QueryDZD				(TZT_MENU_JY_RZRQ_BEGIN+301) //15301  对账单查询
#define  MENU_JY_RZRQ_QueryTransHis			(TZT_MENU_JY_RZRQ_BEGIN+302) //15302  历史成交
#define  MENU_JY_RZRQ_QueryFZQKHis		    (TZT_MENU_JY_RZRQ_BEGIN+303) //15303  负债变动 负债变动流水
#define  MENU_JY_RZRQ_QueryFundsHis			(TZT_MENU_JY_RZRQ_BEGIN+304) //15304  资金流水历史
#define  MENU_JY_RZRQ_QueryWTHis            (TZT_MENU_JY_RZRQ_BEGIN+305) //15305  历史委托查询
#define  MENU_JY_RZRQ_RZFZHis               (TZT_MENU_JY_RZRQ_BEGIN+306) //15306  已偿还融资负债 474
#define  MENU_JY_RZRQ_RQFZHis               (TZT_MENU_JY_RZRQ_BEGIN+307) //15307  已偿还融券负债 475
#define  MENU_JY_RZRQ_NoTradeTransHis       (TZT_MENU_JY_RZRQ_BEGIN+308) //15308  历史非交易划转查询/历史非交易过户委托
#define  MENU_JY_RZRQ_NewStockPH            (TZT_MENU_JY_RZRQ_BEGIN+309) //15309  新股配号查询
#define  MENU_JY_RZRQ_NewStockZQ            (TZT_MENU_JY_RZRQ_BEGIN+310) //15310  新股中签查询

#define  MENU_JY_RZRQ_ZRT_Begin             (TZT_MENU_JY_RZRQ_BEGIN+400) //15400    转融通开始
#define  MENU_JY_RZRQ_ZRT_YYSQ              (TZT_MENU_JY_RZRQ_BEGIN+401) // 15401  转融券预约申请
#define  MENU_JY_RZRQ_ZRT_ZQSB              (TZT_MENU_JY_RZRQ_BEGIN+402) // 15402  专项头寸证券申报

#define  MENU_JY_RZRQ_ZRT_QueryFee          (TZT_MENU_JY_RZRQ_BEGIN+430) //15430    转融券预约期限费率查询
#define  MENU_JY_RZRQ_ZRT_YYBD              (TZT_MENU_JY_RZRQ_BEGIN+431) //15431    转融券预约标的信息查询
#define  MENU_JY_RZRQ_ZRT_QueryHY           (TZT_MENU_JY_RZRQ_BEGIN+432) //15432    转融券预约合约查询
#define  MENU_JY_RZRQ_ZRT_TCBD              (TZT_MENU_JY_RZRQ_BEGIN+433) //15433    查询专项头寸标的券
#define  MENU_JY_RZRQ_ZRT_SBWT              (TZT_MENU_JY_RZRQ_BEGIN+434) //15434    查询专项证券申报委托

#define  MENU_JY_RZRQ_ZRT_END               (TZT_MENU_JY_RZRQ_BEGIN+498) //15498  转融通结束

#define  MENU_JY_RZRQ_Out                   (TZT_MENU_JY_RZRQ_BEGIN+499) //融资融券退出
#define  TZT_MENU_JY_RZRQ_END				(TZT_MENU_JY_RZRQ_BEGIN +500) //15500  融资融券交易功能结束
/***************融资融券交易功能 15500 END**********************/
//预留500功能


/***************港股交易功能 16000 BEGIN**********************/
#define  TZT_MENU_JY_HK_BEGIN				(TZT_MENU_JY_RZRQ_END +500) //16000  港股交易功能
#define  MENU_JY_HK_QueryList               (TZT_MENU_JY_HK_BEGIN + 1)  //16001 港股查询列表

#define  MENU_JY_HK_Buy                     (TZT_MENU_JY_HK_BEGIN +10)  //16010 港股买入
#define  MENU_JY_HK_Sell                    (TZT_MENU_JY_HK_BEGIN +11)  //16011 港股卖出
#define  MENU_JY_HK_WithDraw                (TZT_MENU_JY_HK_BEGIN +12)  //16012 港股撤单
#define  MENU_JY_HK_Stock                   (TZT_MENU_JY_HK_BEGIN +15)  //16015 港股持仓


//
#define  MENU_JY_HK_QueryJG                 (TZT_MENU_JY_HK_BEGIN +100) //16100 查交割单

#define  TZT_MENU_JY_HK_END                 (TZT_MENU_JY_HK_BEGIN +500) //16500  港股交易功能结束
/***************港股交易功能 16500 END**********************/
//预留500功能

/***************期货交易功能 17000 BEGIN**********************/
#define  TZT_MENU_JY_QH_BEGIN				(TZT_MENU_JY_HK_END +500) //17000  期货交易功能

#define  TZT_MENU_JY_QH_END                 (TZT_MENU_JY_QH_BEGIN +500) //17500  期货交易功能结束
/***************期货交易功能 17500 END**********************/
//预留500功能
/***************个股期权功能 17600 BEGIN********************/
#define  TZT_MENU_JY_GGQQ_BEGIN             (TZT_MENU_JY_QH_END + 100)      //17600 个股期权功能
#define  MENU_JY_GGQQ_List              (TZT_MENU_JY_GGQQ_BEGIN + 1)    //17601 首页列表
#define  MENU_JY_GGQQ_WithDrawList      (TZT_MENU_JY_GGQQ_BEGIN + 2)    //17602 委托撤单列表
#define  MENU_JY_GGQQ_SearchList        (TZT_MENU_JY_GGQQ_BEGIN + 3)    //17603 综合查询列表
#define  MENU_JY_GGQQ_BankList          (TZT_MENU_JY_GGQQ_BEGIN + 4)    //17604 银衍转账列表
#define  MENU_JY_GGQQ_XQList            (TZT_MENU_JY_GGQQ_BEGIN + 5)    //17605 行权列表

#define  MENU_JY_GGQQ_BuyOpen           (TZT_MENU_JY_GGQQ_BEGIN + 10)   //17610 买入开仓
#define  MENU_JY_GGQQ_BuyPosition       (TZT_MENU_JY_GGQQ_BEGIN + 11)   //17611 买入平仓
#define  MENU_JY_GGQQ_SellOpen          (TZT_MENU_JY_GGQQ_BEGIN + 12)   //17612 卖出开仓
#define  MENU_JY_GGQQ_SellPosition      (TZT_MENU_JY_GGQQ_BEGIN + 13)   //17613 卖出平仓
#define  MENU_JY_GGQQ_CoveredLock       (TZT_MENU_JY_GGQQ_BEGIN + 14)   //17614 备兑券锁定
#define  MENU_JY_GGQQ_CoveredUnLock     (TZT_MENU_JY_GGQQ_BEGIN + 15)   //17615 备兑券解锁
#define  MENU_JY_GGQQ_CoveredOpen       (TZT_MENU_JY_GGQQ_BEGIN + 16)   //17616 备兑开仓
#define  MENU_JY_GGQQ_CoveredPosition   (TZT_MENU_JY_GGQQ_BEGIN + 17)   //17617 备兑平仓

#define  MENU_JY_GGQQ_XQ                (TZT_MENU_JY_GGQQ_BEGIN + 18)   //17618 行权
#define  MENU_JY_GGQQ_XQAuto            (TZT_MENU_JY_GGQQ_BEGIN + 19)   //17619 自动行权
#define  MENU_JY_GGQQ_QueryCanXQ        (TZT_MENU_JY_GGQQ_BEGIN + 20)   //17620 可行权持仓
#define  MENU_JY_GGQQ_QueryDRXQJGMX     (TZT_MENU_JY_GGQQ_BEGIN + 21)   //17621 当日行权交割明细
#define  MENU_JY_GGQQ_QueryDRYWCBZP     (TZT_MENU_JY_GGQQ_BEGIN + 22)   //17622 当日义务仓被指派
#define  MENU_JY_GGQQ_QueryXQZPQZCX     (TZT_MENU_JY_GGQQ_BEGIN + 23)   //17623 行权指派欠资查询
#define  MENU_JY_GGQQ_QueryXQZPQQCX     (TZT_MENU_JY_GGQQ_BEGIN + 24)   //17624 行权指派欠券查询
#define  MENU_JY_GGQQ_QueryLSXQCGMX     (TZT_MENU_JY_GGQQ_BEGIN + 25)   //17625 历史行权成功明细
#define  MENU_JY_GGQQ_QueryLSYWCBZP     (TZT_MENU_JY_GGQQ_BEGIN + 26)   //17626 历史义务仓被指派
#define  MENU_JY_GGQQ_QueryXQJGLS       (TZT_MENU_JY_GGQQ_BEGIN + 27)   //17627 行权交割流水

//查询类
#define  MENU_JY_GGQQ_QueryWithDraw     (TZT_MENU_JY_GGQQ_BEGIN + 50)   //17650 委托撤单(可撤委托)
#define  MENU_JY_GGQQ_QueryDRCJ         (TZT_MENU_JY_GGQQ_BEGIN + 51)   //17651 当日成交
#define  MENU_JY_GGQQ_QueryDRWT         (TZT_MENU_JY_GGQQ_BEGIN + 52)   //17652 当日委托
#define  MENU_JY_GGQQ_QueryCC           (TZT_MENU_JY_GGQQ_BEGIN + 53)   //17653 资金持仓
#define  MENU_JY_GGQQ_QueryCovered      (TZT_MENU_JY_GGQQ_BEGIN + 54)   //17654 可用备兑股份
#define  MENU_JY_GGQQ_QueryCJHis        (TZT_MENU_JY_GGQQ_BEGIN + 55)   //17655 历史成交
#define  MENU_JY_GGQQ_QueryJG           (TZT_MENU_JY_GGQQ_BEGIN + 56)   //17656 交割单
#define  MENU_JY_GGQQ_QueryDZD          (TZT_MENU_JY_GGQQ_BEGIN + 57)   //17657 对账单
#define  MENU_JY_GGQQ_QueryLock         (TZT_MENU_JY_GGQQ_BEGIN + 58)   //17658 查可锁定股票
#define  MENU_JY_GGQQ_QueryCoveredEx    (TZT_MENU_JY_GGQQ_BEGIN + 59)   //17659 备兑股份不足
#define  MENU_JY_GGQQ_QueryWTHis        (TZT_MENU_JY_GGQQ_BEGIN + 60)   //17660 历史委托
#define  MENU_JY_GGQQ_QueryDZDFund      (TZT_MENU_JY_GGQQ_BEGIN + 61)   //17661 对账单资金资产
#define  MENU_JY_GGQQ_QueryDZDHYFund    (TZT_MENU_JY_GGQQ_BEGIN + 62)   //17662 对账单合约资产
#define  MENU_JY_GGQQ_QueryDZDFundLS    (TZT_MENU_JY_GGQQ_BEGIN + 63)   //17663 对账单资金流水
#define  MENU_JY_GGQQ_QueryAccount      (TZT_MENU_JY_GGQQ_BEGIN + 64)   //17664 账号查询
#define  MENU_JY_GGQQ_QueryFundDetail   (TZT_MENU_JY_GGQQ_BEGIN + 65)   //17665 资金详情信息


//银衍转账
#define  MENU_JY_GGQQ_BankToOption      (TZT_MENU_JY_GGQQ_BEGIN + 80)   //17680 银行转期权
#define  MENU_JY_GGQQ_OptionToBank      (TZT_MENU_JY_GGQQ_BEGIN + 81)   //17681 期权转银行
#define  MENU_JY_GGQQ_BankYE            (TZT_MENU_JY_GGQQ_BEGIN + 82)   //17682 银行余额
#define  MENU_JY_GGQQ_BankFundDetail    (TZT_MENU_JY_GGQQ_BEGIN + 83)   //17683 资金明晰
#define  MENU_JY_GGQQ_BankHis           (TZT_MENU_JY_GGQQ_BEGIN + 84)   //17684 转账查询

#define  MENU_JY_GGQQ_Out               (TZT_MENU_JY_GGQQ_BEGIN + 398)   //17998 退出
#define  TZT_MENU_JY_GGQQ_END               (TZT_MENU_JY_GGQQ_BEGIN + 399)//17999 个股期权功能结束
/***************个股期权功能 17600 END********************/


/***************理财产品交易功能 18000 BEGIN**********************/
#define  TZT_MENU_JY_LCCP_BEGIN             (TZT_MENU_JY_QH_END +500) //18000  理财产品交易功能
#define  TZT_MENU_JY_LCCP_FH                (TZT_MENU_JY_LCCP_BEGIN + 1) //18001 理财产品分红
#define  TZT_MENU_JY_LCCP_GL_LIST           (TZT_MENU_JY_LCCP_BEGIN + 2) //18002 国联理财产品列表

#define  MENU_JY_LCCP_RenGou                (TZT_MENU_JY_LCCP_BEGIN + 10) //18010 理财认购
#define  MENU_JY_LCCP_ShenGou               (TZT_MENU_JY_LCCP_BEGIN + 11) //18011 理财申购
#define  MENU_JY_LCCP_Cancel                (TZT_MENU_JY_LCCP_BEGIN + 12) //18012 理财退出
#define  MENU_JY_LCCP_WithDraw              (TZT_MENU_JY_LCCP_BEGIN + 13) //18013 理财撤单
#define  MENU_JY_LCCP_QueryDRWT             (TZT_MENU_JY_LCCP_BEGIN + 14) //18014 理财当日委托
#define  MENU_JY_LCCP_QueryFenE             (TZT_MENU_JY_LCCP_BEGIN + 15) //18015 理财份额查询
#define  MENU_JY_LCCP_QueryCode             (TZT_MENU_JY_LCCP_BEGIN + 16) //18016 理财产品代码查询


#define  TZT_MENU_JY_LCCP_END				(TZT_MENU_JY_LCCP_BEGIN +500) //18500  理财产品交易功能结束
/***************理财产品交易功能 18500 END**********************/
//预留500功能

/***************现金理财交易功能 19000 BEGIN**********************/
#define  TZT_MENU_JY_XJB_BEGIN				(TZT_MENU_JY_LCCP_END +500) //19000  现金理财交易功能
//列表或九宫格
#define  MENU_JY_XJB_List                   (TZT_MENU_JY_XJB_BEGIN +1) //19001  现金理财交易列表、九宫格

#define  MENU_JY_XJB_Open                   (TZT_MENU_JY_XJB_BEGIN +10) //19010  开通理财
#define  MENU_JY_XJB_Cancel                 (TZT_MENU_JY_XJB_BEGIN +11) //19011  注销理财
#define  MENU_JY_XJB_Strategy				(TZT_MENU_JY_XJB_BEGIN +12) //19012  服务策略
#define  MENU_JY_XJB_KeepFunds				(TZT_MENU_JY_XJB_BEGIN +13) //19013  保留金额
#define  MENU_JY_XJB_MakeTake				(TZT_MENU_JY_XJB_BEGIN +14) //19014  预约取款
#define  MENU_JY_XJB_MakeCancel				(TZT_MENU_JY_XJB_BEGIN +15) //19015  预约取款取消
#define  MENU_JY_XJB_QueryMake				(TZT_MENU_JY_XJB_BEGIN +16) //19016  查询预约取款
#define  MENU_JY_XJB_ShuHui                 (TZT_MENU_JY_XJB_BEGIN +17) //19017  赎回
#define  MENU_JY_XJB_ShenGou                (TZT_MENU_JY_XJB_BEGIN +18) //19018  申购 （华泰天天发，网页使用该功能号）

#define  MENU_JY_XJB_FastCash               (TZT_MENU_JY_XJB_BEGIN +20) //19020  快速取现
#define  MENU_JY_XJB_QueryState				(TZT_MENU_JY_XJB_BEGIN +100) //19100  查询状态



#define  MENU_JY_TTY_Log                    (TZT_MENU_JY_XJB_BEGIN +150) //19150  天天盈登记
#define  MENU_JY_TTY_StateChange            (TZT_MENU_JY_XJB_BEGIN +151) //19151  天天盈产品状态变更
#define  MENU_JY_TTY_LogOut                 (TZT_MENU_JY_XJB_BEGIN +152) //19152  天天盈解约

#define  MENU_JY_TTY_QueryLog               (TZT_MENU_JY_XJB_BEGIN +101) //19101  天天盈登记查询
#define  MENU_JY_TTY_QueryFE                (TZT_MENU_JY_XJB_BEGIN +102) //19102  天天盈份额查询
#define  MENU_JY_TTY_MakeWithdraw           (TZT_MENU_JY_XJB_BEGIN +103) //19103  天天盈预约取款撤单


#define  MENU_JY_XJB_OpenContract           (TZT_MENU_JY_XJB_BEGIN +41)	//19041  合约开通(南京)
#define  MENU_JY_XJB_CloseContract          (TZT_MENU_JY_XJB_BEGIN +42)	//19042  合约取消(南京)
#define  MENU_JY_XJB_SetEDu                 (TZT_MENU_JY_XJB_BEGIN +43)	//19043  额度设置(南京)
#define  MENU_JY_XJB_SetStatus              (TZT_MENU_JY_XJB_BEGIN +44)	//19044  状态设置(南京)
#define  MENU_JY_XJB_YuYueQuKuan            (TZT_MENU_JY_XJB_BEGIN +45)	//19045  预约取款(南京)

#define  MENU_JY_XJB_Withdraw               (TZT_MENU_JY_XJB_BEGIN +51)	//19051  预约撤单(南京)
#define  MENU_JY_XJB_QueryContract          (TZT_MENU_JY_XJB_BEGIN +52)	//19052  合同查询(南京)
#define  MENU_JY_XJB_QueryDraw              (TZT_MENU_JY_XJB_BEGIN +53)	//19053  委托查询(南京)



#define  TZT_MENU_JY_XJB_END				(TZT_MENU_JY_XJB_BEGIN +500) //19500  现金理财交易功能结束

/***************现金理财交易功能 19500 END**********************/


/***************OTC交易功能 20000   BEGIN**********************/
#define  TZT_MENU_JY_OTC_BEGIN              (TZT_MENU_JY_XJB_END + 500) //20000 OTC交易功能开始

#define  MENU_JY_OTC_Grid                   (TZT_MENU_JY_OTC_BEGIN + 1) //20001 OTC九宫格、列表

#define  MENU_JY_OTC_ShenGou                (TZT_MENU_JY_OTC_BEGIN + 10)//20010 OTC申购
#define  MENU_JY_OTC_RenGou                 (TZT_MENU_JY_OTC_BEGIN + 11)//20011 OTC认购
#define  MENU_JY_OTC_ShuHui                 (TZT_MENU_JY_OTC_BEGIN + 12)//20012 OTC赎回
#define  MENU_JY_OTC_SignContact            (TZT_MENU_JY_OTC_BEGIN + 13)//20013 OTC签署电子合同

#define  MENU_JY_OTC_QueryChanPin           (TZT_MENU_JY_OTC_BEGIN + 50)//20050 OTC产品查询
#define  MENU_JY_OTC_QueryDraw              (TZT_MENU_JY_OTC_BEGIN + 51)//20051 OTC当日委托
#define  MENU_JY_OTC_WithDraw               (TZT_MENU_JY_OTC_BEGIN + 52)//20052 OTC委托撤单
#define  MENU_JY_OTC_QueryFE                (TZT_MENU_JY_OTC_BEGIN + 53)//20053 OTC份额查询

#define  TZT_MENU_JY_OTC_END                (TZT_MENU_JY_OTC_BEGIN +100)//20100 OTC交易功能结束
/***************OTC交易功能 20100   END**********************/

#define  TZT_MENU_JY_END                    TZT_MENU_JY_OTC_END
//预留功能 新增通用功能


//各券商特有功能 注意 只有特有功能放该处，其他放通用功能处
/***************券商特有功能 50000 BEGIN**********************/
#define  TZT_MENU_QS_BEGIN                  (50000) //50000  券商特有功能

/***************华泰券商特有功能 50000 BEGIN**********************/
#define  MENU_QS_HTSC_BEGIN			     	(TZT_MENU_QS_BEGIN) //50000 华泰特色功能

#define  MENU_QS_HTSC_ResetComPass          (MENU_QS_HTSC_BEGIN + 1000) //50001 重置通讯密码

/*紫金理财 50120~50170*/
#define MENU_QS_HTSC_ZJLC_BGEIN             (MENU_QS_HTSC_BEGIN + 120)     //50120
#define MENU_QS_HTSC_ZJLC_List              (MENU_QS_HTSC_ZJLC_BGEIN + 1) //50121    紫金理财功能列表或宫格
#define MENU_QS_HTSC_ZJLC_RenGou            (MENU_QS_HTSC_ZJLC_BGEIN + 2) //50122    基金认购(144):

#define	MENU_QS_HTSC_ZJLC_ShenGou           (MENU_QS_HTSC_ZJLC_BGEIN + 3) //50123	基金申购(139):
#define	MENU_QS_HTSC_ZJLC_ShuHui            (MENU_QS_HTSC_ZJLC_BGEIN + 4) //50124	基金赎回(140):

#define	MENU_QS_HTSC_ZJLC_QueryDraw         (MENU_QS_HTSC_ZJLC_BGEIN + 5) //50125	当日委托(134):
#define	MENU_QS_HTSC_ZJLC_Withdraw          (MENU_QS_HTSC_ZJLC_BGEIN + 6) //50126	撤销委托(141):
#define	MENU_QS_HTSC_ZJLC_QueryPrice        (MENU_QS_HTSC_ZJLC_BGEIN + 7) //50127	基金查询(145):
#define	MENU_QS_HTSC_ZJLC_QueryVerifyHis    (MENU_QS_HTSC_ZJLC_BGEIN + 8) //50128	历史成交(136):
#define	MENU_QS_HTSC_ZJLC_QueryStock        (MENU_QS_HTSC_ZJLC_BGEIN + 9) //50129	持仓基金(137):
#define	MENU_QS_HTSC_ZJLC_QueryKaihu        (MENU_QS_HTSC_ZJLC_BGEIN + 10)//50130	已开户基金(149):

#define	MENU_QS_HTSC_ZJLC_NewKaihu          (MENU_QS_HTSC_ZJLC_BGEIN + 11)//50131	基金开户(153): 新开户
#define	MENU_QS_HTSC_ZJLC_Kaihu             (MENU_QS_HTSC_ZJLC_BGEIN + 12)//50132	基金开户开户

#define	MENU_QS_HTSC_ZJLC_FenHongSet        (MENU_QS_HTSC_ZJLC_BGEIN + 13)//50133	基金分红方式设置 142
#define	MENU_QS_HTSC_ZJLC_PriceMsg          (MENU_QS_HTSC_ZJLC_BGEIN + 14)//50134	紫金理财净值短信订阅
#define	MENU_QS_HTSC_ZJLC_QueryAccount      (MENU_QS_HTSC_ZJLC_BGEIN + 15)//50135	紫金理财账户查询
#define	MENU_QS_HTSC_ZJLC_ChangeFindPW      (MENU_QS_HTSC_ZJLC_BGEIN + 16)//50136	紫金理财查询密码修改
#define	MENU_QS_HTSC_ZJLC_QueryWTHis        (MENU_QS_HTSC_ZJLC_BGEIN + 17)//50137	历史委托(135):
#define	MENU_QS_HTSC_ZJLC_YuYueShenGou      (MENU_QS_HTSC_ZJLC_BGEIN + 18)//50138	预约申购
#define	MENU_QS_HTSC_ZJLC_YuYueshuhui       (MENU_QS_HTSC_ZJLC_BGEIN + 20)//50140	预约赎回

#define MENU_QS_HTSC_ZJLC_END               (MENU_QS_HTSC_ZJLC_BGEIN + 50)//50170   紫金理财结束


#define  MENU_QS_HTSC_Tsyw			     	(MENU_QS_HTSC_BEGIN + 201) //50201 特色业务
#define  MENU_QS_HTSC_Ywbl			     	(MENU_QS_HTSC_BEGIN + 202) //50202 业务办理
#define  MENU_QS_HTSC_Qtyw			     	(MENU_QS_HTSC_BEGIN + 204) //50204 其他业务

#define  MENU_QS_HTSC_END			     	(TZT_MENU_QS_BEGIN + 1000) //51000 华泰特色功能结束

/***************华泰券商特有功能 51000 End**********************/

/***************齐鲁券商特有功能 52000 Begin**********************/
#define MENU_QS_QLSC_BEGIN                  (TZT_MENU_QS_BEGIN + 2000)// 52000 齐鲁特色功能

#define MENU_QS_QLSC_CFTS                   (MENU_QS_QLSC_BEGIN + 1)    // 52001 财富泰山
#define MENU_QS_QLSC_JJMarket               (MENU_QS_QLSC_BEGIN + 2)    // 52002 基金超市
#define MENU_QS_QLSC_YLXXSet                (MENU_QS_QLSC_BEGIN + 3)    // 52003 预留消息设置
#define MENU_QS_QLSC_QueryYLXX              (MENU_QS_QLSC_BEGIN + 4)    // 52004 预留消息查询
#define MENU_QS_QLSC_LXS                    (MENU_QS_QLSC_BEGIN + 5)    // 52005 连心锁
#define MENU_QS_QLSC_YYKH                   (MENU_QS_QLSC_BEGIN + 6)    //52006 齐鲁ipad预约开户
#define MENU_QS_QLSC_YYT                    (MENU_QS_QLSC_BEGIN + 7)    //52007 齐鲁ipad营业厅



#define MENU_QS_QLSC_END                    (TZT_MENU_QS_BEGIN + 5000)// 53000  齐鲁特色功能结束
/***************齐鲁券商特有功能 53000 End**********************/


/***************中原券商特有功能 53000 Begin**********************/
#define MENU_QS_ZYSC_BEGIN                  (TZT_MENU_QS_BEGIN + 3000) //53000 中原特色功能

#define MENU_QS_ZYSC_CFZY_List              (MENU_QS_ZYSC_BEGIN + 100)// 53100  财富中原列表
#define MENU_QS_ZYSC_MySpace                (MENU_QS_ZYSC_BEGIN + 101)// 53101  我的空间
#define MENU_QS_ZYSC_InvestorEDU            (MENU_QS_ZYSC_BEGIN + 102)// 53102  投资者教育
#define MENU_QS_ZYSC_ZYKC                   (MENU_QS_ZYSC_BEGIN + 103)// 53103  中原快车
#define MENU_QS_ZYSC_ZYBD                   (MENU_QS_ZYSC_BEGIN + 104)// 53104  中原宝典
#define MENU_QS_ZYSC_ZYGJ                   (MENU_QS_ZYSC_BEGIN + 105)// 53105  中原管家

#define MENU_QS_ZYSC_ClientManager_BEGIN    (MENU_QS_ZYSC_BEGIN + 200)// 53200  客户经理功能开始
#define MENU_QS_ZYSC_ClientManager          (MENU_QS_ZYSC_BEGIN + 201)// 53201  客户经理
#define MENU_QS_ZYSC_ClientManager_ASK      (MENU_QS_ZYSC_BEGIN + 202)// 53202  客户经理－在线提问
#define MENU_QS_ZYSC_ClientManager_MSG      (MENU_QS_ZYSC_BEGIN + 203)// 53203  客户经理－在线留言
#define MENU_QS_ZYSC_ClientManager_END      (MENU_QS_ZYSC_BEGIN + 220)// 53220  客户经理功能结束


#define MENU_QS_ZYSC_END                    (TZT_MENU_QS_BEGIN + 1000)// 54000  中原特色功能结束
/***************中原券商特有功能 54000 End**********************/


/***************国联券商特有功能 55000 End**********************/
#define MENU_QS_GLSC_BEGIN                  (TZT_MENU_QS_BEGIN +  5000) //55000

#define MENU_QS_GLSC_JY_JYSJJList           (MENU_QS_GLSC_BEGIN + 100)  //55100     国联交易所基金列表

#define MENU_QS_GLSC_JY_JYSJJShenGou        (MENU_QS_GLSC_BEGIN + 101)  //55101     交易所基金申购
#define MENU_QS_GLSC_JY_JYSJJShuHui         (MENU_QS_GLSC_BEGIN + 102)  //55102     交易所基金赎回

#define MENU_QS_GLSC_END                    (MENU_QS_GLSC_BEGIN + 1000) //
/***************国联券商特有功能 56000 End**********************/
/***************南京券商特有功能 58000 End**********************/

#define MENU_QS_NJSC_BEGIN                  (TZT_MENU_QS_BEGIN +  7000) //57000

#define MENU_QS_NJSC_JLP_HQ                 (MENU_QS_NJSC_BEGIN + 100) //57100
#define MENU_QS_NJSC_JLP_ZIXUN              (MENU_QS_NJSC_BEGIN + 200) //57200
#define MENU_QS_NJSC_JLP_DP                 (MENU_QS_NJSC_BEGIN + 300) //57300
#define MENU_QS_NJSC_JLP_ZT                 (MENU_QS_NJSC_BEGIN + 400) //57400
#define MENU_QS_NJSC_JLP_ZIXUAN             (MENU_QS_NJSC_BEGIN + 500) //57500
#define MENU_QS_NJSC_JLP_JY                 (MENU_QS_NJSC_BEGIN + 600) //57600
#define MENU_QS_NJSC_JLP_JPTJ               (MENU_QS_NJSC_BEGIN + 700) //57700

#define MENU_QS_NJSC_END                    (MENU_QS_NJSC_BEGIN + 1000) //

/***************南京券商特有功能 58000 End**********************/

/***************安信证券特有功能 57000*********************************/
/***************安信证券特有功能 58000 END*********************************/

/***************华林证券特有功能 58001**********************************/
/***************华林证券特有功能 58100**********************************/

/***************东北证券特有功能 58101**********************************/
#define MENU_QS_DBSC_BEGIN                  (TZT_MENU_QS_BEGIN + 8101)//58101
//东北证券－掌厅，调用第三方sdk开发功能
#define MENU_QS_DBSC_ZT                     (MENU_QS_DBSC_BEGIN + 110)//58110

#define MENU_QS_DBSC_END                    (TZT_MENU_QS_BEGIN + 8199)//58199
/***************东北证券特有功能 58200**********************************/
 

#define  TZT_MENU_QS_END                    (TZT_MENU_QS_BEGIN +10000) //60000  券商特有功能结束
/***************券商特有功能 60000 END**********************/


#define  TZT_NewHQ_More                     0x123456

#endif



