/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:        顶部报价显示view
 * 文件标识:        
 * 摘要说明:        
 * 
 * 当前版本:        2.0
 * 作    者:       yinjp
 * 更新日期:            
 * 整理修改:	
 *
 ***************************************************************/

#import <UIKit/UIKit.h>
#import "tztPriceView.h"

@interface tztQuoteView : tztPriceView

@property(nonatomic)BOOL hasNoAddBtn;
//更新界面数据
-(void)UpdateLabelData;
@end
