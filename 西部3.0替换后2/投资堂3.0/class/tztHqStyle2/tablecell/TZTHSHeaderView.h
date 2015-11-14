/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:
 * 文件标识:
 * 摘要说明:    沪深表中可打开的SectionView
 *
 * 当前版本:
 * 作    者:       DBQ
 * 更新日期:
 * 整理修改:
 *
 ***************************************************************/

#import <UIKit/UIKit.h>

@protocol HeadDelegate <NSObject>

- (void)open:(id)sender;
- (void)more:(id)sender;

@end

@interface TZTHSHeaderView : UIView

@property(nonatomic,retain) UIButton *btnTag;
@property(nonatomic,retain) UIButton *btnMore;
@property(nonatomic,retain) NSString *groupName;
@property(nonatomic,assign) BOOL open;
@property(nonatomic,assign) id<HeadDelegate> delegate;

@end
