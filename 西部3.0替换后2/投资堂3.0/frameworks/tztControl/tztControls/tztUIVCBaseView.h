//
//  tztUIVCBaseView.h
//  tztMobileApp
//
//  Created by yangdl on 13-2-23.
//  Copyright (c) 2013年 投资堂. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "tztUIBaseControlsView.h"
#import "tztUIControlsInfo.h"
#import "TZTUIDatePicker.h"

/**
 *  基础控件布局显示view
 */
@interface tztUIVCBaseView : UIScrollView<tztSysKeyboardDelegate, tztUIButtonDelegate , UIActionSheetDelegate>
{
    NSString* _strAction;//当前请求功能号
    NSString* _tableConfig;//配置文件名
    NSMutableArray* _tablelist;
    id        _tztDelegate;
    CGSize    _tableShowSize;
    NSMutableDictionary* _tableControls;
    UIDatePicker       *tztDatePicker;
    NSInteger     _nXMargin;
    NSInteger     _nYMargin;
@private
    CGFloat keyboardHeight;//键盘显示偏移高度
}

/**
 *  配置文件名称
 */
@property (nonatomic,retain)NSString* tableConfig;
/**
 *  代理
 */
@property (nonatomic,assign)id        tztDelegate;
/**
 *  DatePicker控件，用于日期选择
 */
@property (nonatomic,retain)UIDatePicker       *tztDatePicker;
/**
 *  是否把开始时间提前一个月
 */
@property (nonatomic,assign)BOOL      isAMonthAgo;
/**
 *  是否从明天开始
 */
@property (nonatomic,assign)BOOL      isTomorrowBegin;
/**
 *  是否今天结束
 */
@property (nonatomic,assign)BOOL      isTodayEnd;
/**
 *  左右间距
 */
@property (nonatomic)NSInteger nXMargin;
/**
 *  上下间距
 */
@property (nonatomic)NSInteger nYMargin;
/**
 *  获取数据显示区域
 *
 *  @return 显示区域
 */
- (CGSize)getTableShowSize;

/**
 *  关闭系统键盘
 *
 *  @param pView view
 *
 *  @return TRUE
 */
+(BOOL)OnCloseKeybord:(UIView*)pView;

/**
 *  输入数据校验
 *
 *  @return TRUE＝成功
 */
-(BOOL)CheckInput;

/**
 *  刷新界面显示
 */
-(void)OnRefreshTableView;

/**
 *  根据某行的Image来设置是否隐藏
 *
 *  @param ImageStr ImageStr，对应配置文件中的image字段，需要唯一标示
 *  @param Show     TRUE显示， FALSE隐藏
 */
-(void)SetImageHidenFlag:(NSString *)ImageStr bShow_:(BOOL)Show;

/**
 *  根据配置文件中某行的Image来获取对应的view
 *
 *  @param imageStr  ImageStr，对应配置文件中的image字段，需要唯一标示
 *
 *  @return 该行对应的view
 */
-(UIView*)getCellWithFlag:(NSString *)imageStr;

/**
 *  通过配置文件名称获取对应配置文件数据，并以数组返回
 *
 *  @param nsConfig 配置文件名称
 *
 *  @return 对应配置文件数据
 */
-(NSMutableArray*)getBaseControlsWithtableConfig:(NSString *)nsConfig;

/**
 *  通过tag获取对应的view
 *
 *  @param nTag 要获取的view的tag值
 *
 *  @return 对应tag值的view
 */
-(UIView*)getViewWithTag:(int)nTag;

/**
 *  清空界面控件的数据
 */
-(void)clearControlData;

/**
 *  设置label文本
 *
 *  @param nsLabel 需要显示的文本
 *  @param nTag    label对应的tag
 */
-(void)setLabelText:(NSString*)nsLabel withTag_:(int)nTag;

/**
 *  获取label文本
 *
 *  @param nTag label对应的tag
 *
 *  @return tag所对应label的文字
 */
-(NSString*)GetLabelText:(int)nTag;

/**
 *  设置自定义编辑框小数点位数
 *
 *  @param nDotValue 小数点位数
 *  @param nTag      自定义输入框的tag值
 */
-(void)setEditorDotValue:(NSInteger)nDotValue withTag_:(int)nTag;

/**
 *  设置自定义输入框是否可以编辑
 *
 *  @param bEnable TRUE＝可编辑
 *  @param nTag    自定义输入框的tag值
 */
-(void)setEditorEnable:(BOOL)bEnable withTag_:(int)nTag;

/**
 *  设置自定义输入框的文本数据，设置完成后自动发送UITextFieldTextDidChangeNotification消息
 *
 *  @param nsText        自定义输入框的文本
 *  @param nsPlaceholder 自定义输入框提示信息文本
 *  @param nTag          自定义输入框的tag值
 */
-(void)setEditorText:(NSString*)nsText nsPlaceholder_:(NSString*)nsPlaceholder withTag_:(int)nTag;

/**
 *  设置自定义输入框的文本数据
 *
 *  @param nsText        自定义输入框的文本
 *  @param nsPlaceholder 自定义输入框提示信息文本
 *  @param nTag          自定义输入框的tag值
 *  @param bNotify       所否需要发送UITextFieldTextDidChangeNotification消息
 */
-(void)setEditorText:(NSString*)nsText nsPlaceholder_:(NSString*)nsPlaceholder withTag_:(int)nTag andNotifi:(BOOL)bNotify;

/**
 *  获取自定义输入框的文本
 *
 *  @param nTag 自定义输入框的tag
 *
 *  @return 输入框内文本
 */
-(NSString*)GetEidtorText:(int)nTag;

/**
 *  设置输入框为当前焦点
 *
 *  @param nTag 自定义输入框的tag
 */
-(void)setEditorBecomeFirstResponder:(int)nTag;

/**
 *  取消输入框的焦点
 *
 *  @param nTag 自定义输入框的tag
 */
-(void)setEditorResignFirstResponder:(int)nTag;

/**
 *  设置tztUICheckButton状态
 *
 *  @param bChecked 是否选中1-选中
 *  @param nTag     对应tag值
 */
-(void)setCheckBoxValue:(BOOL)bChecked withTag_:(int)nTag;

/**
 *  获取指定tztUICheckButton的状态
 *
 *  @param nTag 对应tag值
 *
 *  @return TRUE＝选中
 */
-(BOOL)getCheckBoxValue:(int)nTag;

/**
 *  设置指定ntag的自定义按钮数据
 *
 *  @param nsTitle 按钮文字
 *  @param clText  文字颜色
 *  @param nState  按钮状态
 *  @param nTag    指定tag
 */
-(void)setButtonTitle:(NSString*)nsTitle clText_:(UIColor*)clText forState_:(UIControlState)nState withTag_:(int)nTag;

/**
 *  获取指定ntag的自定义按钮对应状态的文本
 *
 *  @param nTag   指定tag
 *  @param nState 状态
 *
 *  @return 自定义按钮本文
 */
-(NSString*)getButtonTitle:(int)nTag forState_:(UIControlState)nState;

/**
 *  设置tztUIButton背景图片
 *
 *  @param Image 背景图
 *  @param nTag  对应tag
 */
-(void)setButtonBGImage:(UIImage *)Image withTag_:(int)nTag;

//下拉
/**
 *  清空tztUIDroplistView的编辑框文本，只有当tztUIDroplistView类型为可编辑时才有效
 *
 *  @param nTag 对应tag
 */
-(void)setComBoxTextField:(int)nTag;

/**
 *  设置下拉控件tztUIDroplistView的数据
 *
 *  @param ayTitle   显示内容
 *  @param ayContent 对应实际内容
 *  @param nIndex    默认选中位置
 *  @param nTag      tag值
 */
-(void)setComBoxData:(NSMutableArray*)ayTitle ayContent_:(NSMutableArray*)ayContent AndIndex_:(NSInteger)nIndex withTag_:(int)nTag;

/**
 *  设置下拉控件tztUIDroplistView的数据
 *
 *  @param ayTitle   显示标题内容
 *  @param ayContent 对应实际内容
 *  @param nIndex    默认选中位置
 *  @param nTag      tag值
 *  @param bDrop     是否自动下拉展开
 */
-(void)setComBoxData:(NSMutableArray*)ayTitle ayContent_:(NSMutableArray*)ayContent AndIndex_:(NSInteger)nIndex withTag_:(int)nTag bDrop_:(BOOL)bDrop;

/**
 *  下拉控件tztUIDroplistView当前显示文本
 *
 *  @param nsTitle 需要显示的文本
 *  @param nTag    对应tag
 */
-(void)setComBoxText:(NSString*)nsTitle withTag_:(int)nTag;

/**
 *  获取下拉控件tztUIDroplistView当前选中位置
 *
 *  @param nTag 对应tag
 *
 *  @return 当前选中位置
 */
-(NSInteger)getComBoxSelctedIndex:(int)nTag;

/**
 *  获取下拉控件tztUIDroplistView
 *
 *  @param nTag 对应tag
 *
 *  @return tztUIDroplistView对象
 */
-(UIView*)getComBoxViewWith:(int)nTag;

/**
 *  获取下拉控件tztUIDroplistView当前text
 *
 *  @param nTag 对应tag
 *
 *  @return 显示text
 */
-(NSString*)getComBoxText:(int)nTag;

/**
 *  设置tztUIDroplistView提示文字
 *
 *  @param nsInfo 提示文字
 *  @param nTag   对应tag
 */
-(void)setComBoxPlaceholder:(NSString*)nsInfo withTag_:(int)nTag;

/**
 *  设置下拉控件tztUIDroplistView类型
 *
 *  @param type 类型
 *  @param nTag 对应tag
 */
-(void)setComBoxShowType:(tztDroplistViewType)type withTag_:(int)nTag;
@end
