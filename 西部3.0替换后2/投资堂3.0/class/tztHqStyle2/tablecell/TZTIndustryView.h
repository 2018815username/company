/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:
 * 文件标识:
 * 摘要说明:    热门行业Cell
 *
 * 当前版本:
 * 作    者:       DBQ
 * 更新日期:
 * 整理修改:
 *
 ***************************************************************/

#import <UIKit/UIKit.h>

@interface TZTIndustryCell : UITableViewCell

@property(nonatomic,retain)UIColor *clBackColor;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier andTotalCount_:(int)nTotal andGrid_:(BOOL)bGrid bHasTopStock:(BOOL)bHasTopStock;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier andTotalCount_:(int)nTotal;
-(void)setContentData:(NSMutableArray*)ayData;
@end
