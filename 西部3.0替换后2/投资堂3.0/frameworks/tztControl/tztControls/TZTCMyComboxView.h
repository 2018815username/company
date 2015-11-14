//
//  TZTCMyComboxView.h
//  TZT
//
//  Created by dai shouwei on 09-9-27.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  下拉控件显示协议
 */
@protocol TZTMyComboxSelect
/**
 *  选中处理，iOS8下对actionsheet已经不再支持
 *
 *  @param nID          控件tag
 *  @param nSelectIndex 选中位置
 *  @param nsSelectText 选中文字
 */
-(void) OnComboxSel:(unsigned int)nID nSel:(NSInteger)nSelectIndex nsText:(NSString*)nsSelectText;

@end

/**
 *  自定义下拉控件展示，foriPad
 */
@interface TZTCMyComboxView : UIView<UIActionSheetDelegate,UIPickerViewDelegate,UIPickerViewDataSource,TZTMyComboxSelect> {
    unsigned int        m_nComboxID;
    
    NSInteger           m_nSelectIndex;
    NSString            *m_nsSelectText;
    UIPickerView        *m_PickerView;
    NSMutableArray      *m_pickerData;
    
    UIActionSheet       *m_baseSheet;
    //UIToolbar           *toolBar;
    
    id                  m_delegate;
	
	CGRect              m_rcShowRect;
}
/**
 *  MyComboxView id
 */
@property unsigned int          m_nComboxID;
/**
 *  选中位置
 */
@property NSInteger                         m_nSelectIndex;
/**
 *  选中文字
 */
@property(nonatomic,retain) NSString        *m_nsSelectText;
/**
 *  UIPickerView,用于列表选择
 */
@property(nonatomic,retain) UIPickerView    *m_PickerView;
/**
 *  UIPickerView显示数据
 */
@property(nonatomic,retain) NSMutableArray  *m_pickerData;
/**
 *  代理
 */
@property(nonatomic,assign) id              m_delegate;
/**
 *  UIActionSheet iOS8已经废弃，兼容iOS8以下处理
 */
@property(nonatomic,retain) UIActionSheet   *m_baseSheet;
/**
 *  显示区域
 */
@property CGRect              m_rcShowRect;
/**
 *  初始化view
 *
 *  @param frame  显示区域
 *  @param rcFrom 显示位置区域
 *
 *  @return MyComboxView对象
 */
-(id)initWithFrame:(CGRect)frame FromRect:(CGRect)rcFrom;
/**
 *  创建ActionSheet和Picker显示
 *
 *  @param frame 显示区域
 */
-(void) CreateSheetAndPicker:(CGRect)frame;
/**
 *  获取代理
 *
 *  @return m_delegate
 */
-(id)delegate;
/**
 *  设置代理
 *
 *  @param delegate m_delegate = delegate;
 */
-(void) setDelegate:(id)delegate;
/**
 *  设置标题文字显示
 *
 *  @param nsTitle 要显示的标题
 */
-(void) setTitle:(NSString*)nsTitle;
/**
 *  设置ComBox数据
 *
 *  @param nID      view id
 *  @param ayData   数据
 *  @param nDefault 默认选中位置
 */
-(void) SetCombox:(unsigned int)nID ayData:(NSMutableArray*)ayData nDefault:(int)nDefault;
/**
 *  确定按钮点击事件
 */
-(void) OnOK;
/**
 *  取消按钮点击事件
 */
-(void) OnCancel;
@end
