/*************************************************************
* Copyright (c)2009, 杭州中焯信息技术股份有限公司
* All rights reserved.
*
* 文件名称:		TZTInitReportMarketMenu
* 文件标识:
* 摘要说明:		从MobileStock初始化统一的排名市场列表菜单
* 
* 当前版本:	2.0
* 作    者:	yinjp
* 更新日期:	
* 整理修改:	
*
***************************************************************/

#import <Foundation/Foundation.h>

@interface TZTInitReportMarketMenu : TZTUIBaseView<tztSocketDataDelegate>
{
	NSMutableDictionary		*_pReportMenu;	//菜单字典
    
    NSArray                 *_pOutlineList;
    NSMutableDictionary     *_pOutlineCell;
    //add by xyt
	NSString            *_strVolume;	//保存读取的CRC,CRC用Volume字段
	NSString            *_strVersion;	//保存读取的Version
	NSString            *_strGridDate;  //写入文件内容.
	int					_nNewMenu;		//是否读取新的菜单 0 不读取,1读取
	int                 _nStockNum;
    //索引
	int					_nMenuIDIndex;     
	int					_nParentIDIndex;
	int					_nMenuNameIndex;
	int					_nMarketIndex;
	int					_nMenuType;
	int					_nMenuPaixu;	//添加排序字段
    int                 _nShowFlag;
    int                 _nSearchStockType;
}

@property(nonatomic,retain)NSArray                   *pOutlineList;
@property(nonatomic,retain)NSMutableDictionary       *pOutlineCell;
@property(nonatomic,retain)NSMutableDictionary       *pReportMenu;
@property(nonatomic,retain)NSString             *strFileName;
@property(nonatomic,retain)NSString             *strVolume;
@property(nonatomic,retain)NSString             *strVersion;
@property(nonatomic,retain)NSString             *strGridDate;
@property(nonatomic,retain)NSString             *strPushInfo;
-(int) RequestReportMarketMenu;
//暂时先将首页请求放到这里处理
-(int) RequestHomePageData;
//请求公告信息(东莞证券)
-(void) RequestInfoUrl;
//
-(void)RequestLocation;
//-(void) DealWithReportMenuData:(NSMutableArray*)ayData;
//-(void)ReadReportMenuData;
//add by xyt 用来判断是否是新的菜单.
-(BOOL) IsNewMenu;
-(NSMutableDictionary*)GetSubMenuById:(NSMutableDictionary*)pMenuDict  nsID_:(NSString*)nsID;
-(void)SetMenuData:(NSMutableArray*)pAyMenu _pDict:(NSDictionary*)pDict;
-(BOOL)GetMenuData:(NSDictionary**)pReturnDict _pDict:(NSDictionary*)pDict nsID_:(NSString*)nsID;
//请求用户自定义股票板块数据
-(void)RequestUserBlockStock:(int)nNum;
//
-(BOOL)RequestLogVolumeValid;
//
-(void)RequestTradeCCData;
@end

extern TZTInitReportMarketMenu* g_pReportMarket;
extern NSMutableArray         * g_pAvaliableMarket;
