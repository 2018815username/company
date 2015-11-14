/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:    tztBaseSetViewController.h
 * 文件标识:    基础设置界面 tztUIBaseSetView tztBaseSetViewController 
 * 摘要说明:
 *
 * 当前版本:        2.0
 * 作    者:       yangdl
 * 更新日期:        2013.05.19
 * 整理修改:
 *
 ***************************************************************/


#import <UIKit/UIKit.h>

#import "TZTUIBaseViewController.h"

@interface tztUIBaseSetView : TZTUIBaseView
{
    tztUIVCBaseView      *_tztTableView;
    NSString* _tableConfig;
}
@property(nonatomic,retain) tztUIVCBaseView  *tztTableView;
@property(nonatomic,retain) NSString* tableConfig;

//配置文件
- (void)onSetTableConfig:(NSString*)strConfig;
//加载保存配置
- (void)onReadWriteSettingValue:(BOOL)bRead;
@end

@interface tztBaseSetViewController : TZTUIBaseViewController
{
    Class tztSetViewClass;
    tztUIBaseSetView    *_tztSetView;
}
@property(nonatomic,retain)tztUIBaseSetView     *tztSetView;
//设置界面类型
- (void)setTztSetViewClass:(Class)viewClass;
@end
