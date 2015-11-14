/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:        资讯表格显示类
 * 文件标识:        
 * 摘要说明:        
 * 
 * 当前版本:        2.0
 * 作    者:       yinjp
 * 更新日期:            
 * 整理修改:	
 *
 ***************************************************************/
#ifndef __TZTINFOTABLEVIEWCELL_H__
#define __TZTINFOTABLEVIEWCELL_H__
#import "tztInfoBase.h"

//资讯表格行
@interface tztInfoTableViewCell : UITableViewCell 
{
    NSString        *_nsTitle;
    NSString        *_nsTime;
    NSInteger             _nCellRow;
    UIFont          *_pTitleFont;
    UIFont          *_pTimeFont;
    UIColor         *_pTitleColor;
    UIColor         *_pTimeColor;
    UIColor         *_pBackColor;
}
@property(nonatomic, retain)NSString    *nsTitle;
@property(nonatomic, retain)NSString    *nsTime;
@property(nonatomic, retain)UIFont      *pTitleFont;
@property(nonatomic, retain)UIFont      *pTimeFont;
@property(nonatomic, retain)UIColor     *pTitleColor;
@property(nonatomic, retain)UIColor     *pTimeColor;
@property(nonatomic, retain)UIColor     *pBackColor;
@property (nonatomic) NSInteger  nCellRow;
@property (nonatomic) BOOL  bNewStyle; // 不要方块

-(void)SetContent:(NSString*)strTitle strTime:(NSString*)strTime;
-(void)SetContentColor:(UIColor*)clTitle clTime_:(UIColor*)clTime;
-(void)SetContentFont:(UIFont*)pTitle pTime_:(UIFont*)pTime;
-(void)SetBackgroundColor:(UIColor*)pColor;
@end

@interface tztInfoTableView : tztHqBaseView<UITableViewDelegate, UITableViewDataSource,tztInfoDelegate>
{
    //显示表格
    UITableView         *_tableView;
    //数据
    NSMutableArray      *_ayInfoData;
    //选中行记录
    NSInteger                 _nSelectRow;
    //资讯基类
    tztInfoBase         *_infoBase;
    NSString            *_hsString;
    
    //最小显示条数(填充界面显示，防止贴图时出现下面一片黑色空白)
    NSInteger                 _nMinShowRow;
    //底图开放设置(iPad下资讯中心里显示的底图是不一样的)
    NSString            *_nsBackImage;
    //可以设定表格行的高度
    CGFloat             _nTableRowHeight;
    //设定表格行数       
    NSInteger                 _nCellRow;
    //请求条数
    NSInteger                 _nMaxCount;
    //字体
    UIFont              *_pFont;
    //
    NSString            *_nsOp_Type;
    
    //保存已打开的一级菜单的Item和对应的子菜单
    NSMutableArray      *_aySubMenuData;
    //选中的Item
    tztInfoItem         *_pSelItem;
    BOOL                _bIsSubMenu;
    id <tztInfoDelegate>  _tztinfodelegate;
    BOOL                _bRequestList;
    BOOL                _bShowSelect;
}
@property (nonatomic, assign) id<tztInfoDelegate> tztinfodelegate;
@property(nonatomic,retain)UITableView      *tableView;
@property(nonatomic,retain)NSMutableArray   *ayInfoData;
@property(nonatomic,retain)tztInfoBase      *infoBase;
@property(nonatomic,retain)NSString         *hsString;
@property(nonatomic,retain)NSString         *nsBackImage;
@property(nonatomic,retain)UIFont           *pFont;
@property(nonatomic,retain)NSString         *nsOp_Type;
@property(nonatomic,retain)NSString         *menuKind;
@property(nonatomic,retain)NSMutableArray   *aySubMenuData;
@property(nonatomic,retain)tztInfoItem      *pSelItem;
@property(nonatomic,retain)NSString         *infoBtText;
@property NSInteger   nMinShowRow;
@property CGFloat   nTableRowHeight;
@property (nonatomic) NSInteger  nCellRow;
@property NSInteger   nMaxCount;
@property NSInteger   nSelectRow;
@property BOOL  bRequestList;
@property BOOL  bShowSelect;
//设置请求内容
//-(void)setStockCode:(NSString*)nsStockCode AndName:(NSString*)nsStockName HsString_:(NSString*)HsString;
-(void)setStockInfo:(tztStockInfo*)pStockInfo HsString_:(NSString *)HsString;
//
-(void)InsertSubMenu:(NSMutableArray*)ayData leven_:(int)nLevel;
@end
#endif