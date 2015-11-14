/*******************************************************************************
 * Copyright (c)2012, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称：tztUIPickerView.h
 * 文件标识：
 * 摘    要：投资堂选择器
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
@protocol tztPickerViewDelegate;

@interface tztUIPickerView: UIScrollView
@property(nonatomic,assign) id<tztPickerViewDelegate> pickerDelegate; 
//刷新数据
- (void)reloadAllComponents;
@end

@protocol tztPickerViewDelegate <NSObject>
@optional
//几种分类
- (NSInteger)numberOfComponentsIntztPickerView:(tztUIPickerView *)pickerView;
//分类对应数据数
- (NSInteger)tztPickerView:(tztUIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component;
//分类对应行数据
- (NSString *)tztPickerView:(tztUIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component;
//当前行是否选中
- (BOOL)tztPickerView:(tztUIPickerView *)pickerView isSelectForRow:(NSInteger)row forComponent:(NSInteger)component;
//选中行
- (void)tztPickerView:(tztUIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component;
@end
