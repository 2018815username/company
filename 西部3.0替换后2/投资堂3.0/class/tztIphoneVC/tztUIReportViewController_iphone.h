/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:        排名列表
 * 文件标识:        
 * 摘要说明:        
 * 
 * 当前版本:        2.0
 * 作    者:       yinjp
 * 更新日期:            
 * 整理修改:	
 *
 ***************************************************************/

#import "TZTUIBaseViewController.h"
#import "tztUIMarketView.h"
#import "TZTUIStockDetailHeaderView.h"
#import "tztBlockHeaderView.h"


enum tztReportShowType
{
    tztReportShowStockList = 1, //股票列表
    tztReportShowBlockList,  //指数列表
    tztReportShowBlockInfo,  //指数信息
};

@interface tztUIReportViewController_iphone : TZTUIBaseViewController<tztHqBaseViewDelegate,tztUIMarketDelegate>
{
    tztReportListView   *_pReportGrid;
    tztUIMarketView     *_pMarketView;
    TZTUIStockDetailHeaderView *_pBlockHeader;
    tztBlockIndexInfo        *_pQuoteView;
    NSString            *_nsReqAction;
    NSString            *_nsReqParam;
    
    int                 _nReportType;
    NSString            *_nsMenuID;//当前菜单索引id
    NSMutableDictionary        *_pMenuDict;
    NSString            *_nsOrdered;
    NSString*           _nsCurrentID;
    BOOL                _bFirst;
    NSString            *_nsDirection;
    
    int                 _nMarketPosition;
}
@property(nonatomic, retain)tztReportListView *pReportGrid;
@property(nonatomic, retain)TZTUIStockDetailHeaderView *pBlockHeader;
@property(nonatomic, retain)tztBlockIndexInfo      *pQuoteView;
@property(nonatomic, retain)tztUIMarketView  *pMarketView;
@property(nonatomic, retain)NSString            *nsReqAction;
@property(nonatomic, retain)NSString            *nsReqParam;
@property int       nReportType;
@property(nonatomic, retain)NSString            *nsMenuID;
@property(nonatomic, retain)NSString            *nsOrdered;
@property(nonatomic, retain)NSMutableDictionary        *pMenuDict;
@property(nonatomic, retain)NSString*           nsCurrentID;
@property(nonatomic, retain)NSString*           nsDirection;
@property(nonatomic)int nMarketPosition;

-(void)RequestData:(int)nAction nsParam_:(NSString*)nsParam;
-(void)setTitle:(NSString *)title;
-(void)SetMenuID:(NSString *)nsID;

//根据设置的nsMenuID得到菜单列表字典，然后取字典第一个作为默认显示
-(void)RequestDefaultMenuData:(NSString*)nsID;
 /**
 *	@brief	根据设置的nsMarket得到菜单列表，并打开制定的nsID子项作为默认现实
 *
 *	@param 	nsMarket 市场
 *	@param 	nsID 	 默认打开
 *
 *	@return	无
 */
-(void)RequestDefaultMenuData:(NSString*)nsMarket andShowID:(NSString*)nsID;

@end
