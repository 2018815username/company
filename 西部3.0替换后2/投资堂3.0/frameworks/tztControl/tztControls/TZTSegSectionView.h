/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:
 * 文件标识:
 * 摘要说明:    带分段的SectionView
 *
 * 当前版本:
 * 作    者:       DBQ
 * 更新日期:
 * 整理修改:
 *
 ***************************************************************/

#import <UIKit/UIKit.h>
#import "TZTSegmentView.h"

@interface TZTSegSectionView : UIView<tztSegmentViewDelegate>

@property (nonatomic, retain)TZTSegmentView *segControl;
@property (nonatomic, assign)id<tztSegmentViewDelegate>tztDelegate;
@property (nonatomic, assign)BOOL bSepLine;
@property (nonatomic, retain)UIColor    *pBordColor;

- (id)initWithFrame:(CGRect)frame andItems:(NSArray *)items andDelegate:(id)delegate;
- (void)setCurrentSelect:(NSInteger)nIndex;

-(UIButton*)GetCurrentSelBtn;
-(NSInteger)getCurrentIndex;

-(void)SetSegmentViewItems:(NSArray*)ayItems;
@end
