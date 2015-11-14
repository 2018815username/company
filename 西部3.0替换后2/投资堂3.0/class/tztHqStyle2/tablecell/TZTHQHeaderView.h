/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:
 * 文件标识:
 * 摘要说明:    沪深表中最顶端的HeaderView
 *
 * 当前版本:
 * 作    者:       DBQ
 * 更新日期:
 * 整理修改:
 *
 ***************************************************************/

#import <UIKit/UIKit.h>

@interface TZTHQHeaderButton : UIButton

@property (nonatomic)BOOL   bUseBackColor;//使用整体背景色，默认不使用，只是对价格进行颜色处理
@property (nonatomic)BOOL   bShowArrow;//是否显示涨跌箭头，默认显示
-(tztStockInfo*)GetStockInfo;

@end

@interface TZTHQHeaderView : UITableViewCell

@property (nonatomic)NSInteger nTotalCount;
@property (nonatomic, retain)NSMutableArray *sendStockArray;
@property (nonatomic)BOOL   bUseBackColor;//使用整体背景色，默认不使用，只是对价格进行颜色处理
@property (nonatomic)BOOL   bShowArrow;//是否显示涨跌箭头，默认显示


-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier andTotalCol:(NSInteger)nCol bUseBackColor_:(BOOL)bUseBackColor bShowArrow_:(BOOL)bShowArrow;
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier andTotalCol:(NSInteger)nCol;
-(void)setContent:(NSMutableArray*)ayData;


@end
