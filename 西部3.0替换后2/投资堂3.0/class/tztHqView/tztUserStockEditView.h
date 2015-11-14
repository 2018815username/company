/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:        自选股编辑
 * 文件标识:        
 * 摘要说明:        
 * 
 * 当前版本:        2.0
 * 作    者:       yinjp
 * 更新日期:            
 * 整理修改:	
 *
 ***************************************************************/
@class tztEditStockTableCell;

@protocol tztEditStockTableCellDelegate <NSObject>
@optional
 /**
 *	@brief	单元格事件相应回调
 *
 *	@param 	sender 	cell
 *	@param 	nType 	类型 0-删除 1-置顶
 *
 *	@return	无
 */
-(void)tztEditStockTableCell:(tztEditStockTableCell*)sender WithType_:(int)nType;

@end

@interface tztEditStockTableCell : UITableViewCell
{
}
@property(nonatomic, assign)id<tztEditStockTableCellDelegate> tztDelegate;
-(void)SetLabel:(int)nPoint first:(int)nFirstWidth second:(int)nSecondWidth;
-(void)SetContentText:(NSString*)first secondTitle:(NSString*)second;
-(void)SetContentTextColor:(UIColor*)clFirst secondColor:(UIColor*)clSecond;
@end

@interface tztUserStockEditView : tztHqBaseView<UITableViewDataSource, UITableViewDelegate, tztEditStockTableCellDelegate>
{
    UITableView     *_pTableView;
    
    NSMutableArray  *_pAyStockList;
    BOOL bUserStockChanged;
}

@property(nonatomic, retain)UITableView     *pTableView;
@property(nonatomic, retain)NSMutableArray  *pAyStockList;

-(void)LoadUserStock;
-(void)SaveUserStock;

-(void)DeleteUserStock;
@end
