/*******************************************************************************
 * Copyright (c)2012, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称：tztUIEditValueView.h
 * 文件标识：
 * 摘    要：投资堂编辑器 编辑内容标题TitleTip 编辑内容数组 title(lable提示框) value(textfield 数据) key(数据标识)
 *
 * 当前版本：
 * 作    者：yangdl
 * 完成日期：2012.12.12
 *
 * 备    注：
 *
 * 修改记录：
 * 
 *******************************************************************************/

#import <UIKit/UIKit.h>
#import "tztTechObjBase.h"

@protocol tztEditViewDelegate;

@interface tztUIEditValueView : UIView<UITextFieldDelegate>
//内容数组
@property(nonatomic,retain) NSMutableArray	*arrayData;
//标题
@property(nonatomic,retain) NSString*   titleTip;
//接口
@property(nonatomic,assign) id<tztEditViewDelegate> delegate; 
//刷新数据
- (void)reloadAllComponents; 
@end

@protocol tztEditViewDelegate <NSObject>
@optional
//返回编辑结果
- (void)tztEditView:(tztUIEditValueView *)editView didEditValue:(NSArray *)ayValue;
- (void)tztEditView:(tztUIEditValueView *)editView shouldBeginEdit:(UITextField*)textField;
- (void)tztEditView:(tztUIEditValueView *)editView shouldEndEdit:(UITextField*)textField;
@end
