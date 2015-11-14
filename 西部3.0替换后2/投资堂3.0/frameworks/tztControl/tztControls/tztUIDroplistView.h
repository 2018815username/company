/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:		tztUIDroplistView
 * 文件标识:
 * 摘要说明:		自定义下拉框控件
 * 
 * 当前版本:	2.0
 * 作    者:	
 * 更新日期:	
 * 整理修改:	yinjp
 *
 ***************************************************************/


#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "tztUIBaseViewDelegate.h"
/**
 *  下拉控件类型
 */
typedef NS_ENUM(NSInteger, tztDroplistViewType){
    /**
     *  默认
     */
    tztDroplistNon = 0,
    /**
     *  可编辑
     */
    tztDroplistEdit = 0x0001,
    /**
     *  加密显示
     */
    tztDroplistSecure = 0x0010,
    /**
     *  日期选择
     */
    tztDroplistDate = 0x0100,
    /**
     *  时间选择
     */
    tztDroplistHour = 0x1000,
};

@protocol tztSysKeyboardDelegate <NSObject>
@optional
- (void)showSysKeyboard:(id)keyboardview Show:(BOOL)bShow;
- (void)keyboardWillShow:(id)keyboardview;
- (void)keyboardWillHide;
- (void)keyboardDidHide;
@end

@class tztUITextField;
@protocol tztUIDroplistViewDelegate;
@protocol tztUIBaseViewDelegate;
@protocol tztUIBaseViewTextDelegate;

/**
 *  自定义下拉选择控件，支持下拉选择、可编辑下拉选择、日期选择，时间选择，加密显示
 */
@interface tztUIDroplistView : UIView<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate,UITextFieldDelegate,tztSysKeyboardDelegate,tztUIBaseViewDelegate,tztUIBaseViewTextDelegate>
{
    UIView          *_pBackView;
	//上方的按钮
	tztUITextField* _textfield; //输入框
	UIButton *_textbtn;     //输入框按钮
    
	UIButton *_dropbtn;      //列表按钮
	UITableView *_listView;  //列表
	
	NSMutableArray *_ayData; //列表数据
	NSMutableArray *_ayValue; //列表显示数据
    
    NSString *_title;
    
    NSString *_placeholder;    //提示信息
    NSString *_text;           //显示数据
    NSString *_nsData;          
    
    
    UIColor  *_textColor;      //字体颜色
    
    NSInteger _selectindex;          //选中行
    
    id _tztdelegate;//接口回调
    CGFloat _listviewwidth;    //列表宽度
    
    BOOL    _dropbtnMode;//是否显示dropbtn
    BOOL    _droplistdel; //列表支持删除
    BOOL    _tztcheckdate; //检测数据是否为空
	tztDroplistViewType		_droplistViewType;	//类型
    int     _nTextMaxLen;//可输入时d最大输入长度
    BOOL        _enabled;
    NSString* _tzttagcode;
    BOOL _nShowSuper; //显示在superview
   @private

    NSInteger  _nShowListRow;
    CGFloat _fCellHeight;
    NSInteger _deleteindex;
    BOOL _bShowList;
    CGSize szDropImg;
}
/**
 *  背景图片
 */
@property (nonatomic, retain)UIView    *pBackView;
/**
 *  自定义控件tag值
 */
@property (nonatomic,retain) NSString* tzttagcode;
/**
 *  显示再superview中
 */
@property (nonatomic) BOOL nShowSuper;
/**
 *  是否enable
 */
@property (nonatomic) BOOL enabled;
/**
 *  文本输入框，在type=tztDroplistEdit时使用
 */
@property (nonatomic, retain) tztUITextField *textfield;
/**
 *  button,当type!=tztDroplistEdit时显示
 */
@property (nonatomic, retain) UIButton *textbtn;
/**
 *  右侧下拉箭头按钮
 */
@property (nonatomic, retain) UIButton *dropbtn;
/**
 *  下拉显示的列表
 */
@property(nonatomic,retain) UITableView *listView;
/**
 *  列表数据
 */
@property(nonatomic,retain) NSMutableArray *ayData;
/**
 *  列表数据
 */
@property(nonatomic,retain) NSMutableArray *ayValue;
/**
 *  标题
 */
@property(nonatomic,retain) NSString *title;
/**
 *  placeholder文字
 */
@property(nonatomic,retain) NSString *placeholder;
/**
 *  当前显示文本
 */
@property(nonatomic,retain) NSString *text;
/**
 *  当前选择的具体数据
 */
@property(nonatomic,retain) NSString *nsData;
/**
 *  文本颜色
 */
@property(nonatomic,retain) UIColor *textColor;
/**
 *  代理
 */
@property(nonatomic,assign) id<tztUIDroplistViewDelegate> tztdelegate;

/**
 *  选中位置
 */
@property (nonatomic) NSInteger selectindex; //

/**
 *  下拉显示宽度
 */
@property CGFloat listviewwidth;

/**
 *  是否显示下拉显示按钮
 */
@property BOOL dropbtnMode;

/**
 *  下拉显示是否带删除按钮
 */
@property BOOL droplistdel;

/**
 *  是否检测数据
 */
@property BOOL tztcheckdate;

/**
 *  显示类型
 */
@property tztDroplistViewType droplistViewType;

/**
 *  初始化创建tztUIDropListView对象
 *
 *  @param strProperty 属性字符串
 *
 *  @return tztUIDropListView对象
 */
- (id)initWithProperty:(NSString*)strProperty;

/**
 *  设置属性
 *
 *  @param strProperty 属性字符串
 */
- (void)setProperty:(NSString*)strProperty;

/**
 *  检测数据
 *
 *  @return 成功＝TRUE
 */
- (BOOL)onCheckdata;

/**
 *  设置placeholder文字
 */
- (void)onSetPlaceholder;

/**
 *  nShow = 0 隐藏 1 显示 其他 切换(隐藏则显示 ，显示则隐藏)
 *
 *  @param nShow nShow = 0 隐藏 1 显示 其他 切换(隐藏则显示 ，显示则隐藏)
 */
- (void)doShowList:(int)nShow;

/**
 *  隐藏下拉显示
 */
- (void)doHideList;

/**
 *  隐藏下拉显示扩展
 */
- (void)doHideListEx;

/**
 *  设置_text为空
 */
-(void)setTextFieldText;
@end

/**
 *  tztUIDroplistView协议
 */
@protocol tztUIDroplistViewDelegate <tztSysKeyboardDelegate>
@optional
/**
 *  获取列表显示位置
 *
 *  @param droplistview tztUIDroplistView对象
 *  @param listpoint    列表位置
 *
 *  @return  列表显示位置
 */
- (CGPoint)tztDroplistView:(tztUIDroplistView*)droplistview point:(CGPoint)listpoint;

/**
 *  显示列表视图
 *
 *  @param droplistview tztUIDroplistView对象
 *  @param listview     要显示的listview
 *
 *  @return TRUE＝成功
 */
- (BOOL)tztDroplistView:(tztUIDroplistView*)droplistview showlistview:(UITableView*)listview;

/**
 *  显示时间选择器
 *
 *  @param droplistview tztUIDroplistView对象
 */
- (void)tztDroplistViewWithDataview:(tztUIDroplistView*)droplistview;

/**
 *  开始显示数据前处理，从服务器请求数据或者其他处理
 *
 *  @param droplistview tztUIDroplistView对象
 */
- (void)tztDroplistViewBeginShowData:(tztUIDroplistView*)droplistview;

/**
 *  刷新数据
 *
 *  @param droplistview tztUIDroplistView对象
 */
- (void)tztDroplistViewGetData:(tztUIDroplistView*)droplistview;

/**
 *  删除列表数据
 *
 *  @param droplistview tztUIDroplistView对象
 *  @param index        删除数据位置索引
 *
 *  @return TRUE＝成功
 */
- (BOOL)tztDroplistView:(tztUIDroplistView *)droplistview didDeleteIndex:(NSInteger)index;

/**
 *  选中列表数据
 *
 *  @param droplistview tztUIDroplistView对象
 *  @param index        选中位置索引
 */
- (void)tztDroplistView:(tztUIDroplistView *)droplistview didSelectIndex:(NSInteger)index;

/**
 *  隐藏时间选择器
 *
 *  @param droplistview tztUIDroplistView对象
 */
- (void)tztDroplistViewWithDataviewHide:(tztUIDroplistView*)droplistview;
@end
