/*************************************************************
* Copyright (c)2009, 杭州中焯信息技术股份有限公司
* All rights reserved.
*
* 文件名称:		TZTUIBaseTableView
* 文件标识:
* 摘要说明:		表格控件
* 
* 当前版本:	2.0
* 作    者:	yinjp
* 更新日期:	
* 整理修改:	
*
***************************************************************/


#import <UIKit/UIKit.h>
#import "TZTUICheckBox.h"
@class TZTUITextField;

@interface TZTDatePicker : UIDatePicker
{
	id	m_pDelegate;
}
@property (nonatomic, retain) id m_pDelegate;
@end


@interface TZTMyTableView : UITableView
@end

@protocol TZTUICheckBoxDelegate;
@protocol tztUIDroplistViewDelegate;

@protocol TZTUIBaseTableViewDelegate <NSObject>
@optional
-(void)SetDefaultData;
-(void)DealWithMenu:(NSInteger)nMsgType nsParam_:(NSString*)nsParam pAy_:(NSArray*)pAy;
-(void)DealTradeExit;
-(void)sendActionFromId:(int)nMsgType;
-(void)DealWithSysTextField:(TZTUITextField*)inputField;
-(void)OpenSubMenuInNewWindow:(NSDictionary*)pDict;
@end


@interface TZTUIBaseTableView : UIView<UITableViewDelegate, UITableViewDataSource,
                                        TZTUICheckBoxDelegate,
									   UIGestureRecognizerDelegate,
                                       tztUIDroplistViewDelegate,UIActionSheetDelegate,
									   TZTUICheckBoxDelegate, UITextFieldDelegate, TZTUIBaseTableViewDelegate,tztUIBaseViewTextDelegate>
{
	id				m_pDelegate;        //对应代理
	TZTMyTableView		*m_pTableView;      //表格
	BOOL			m_bOnlyRead;		//是否只读 (表格点击不处理)
	SEL				m_Action;			//点击处理（m_bOnlyRead为FALSE有效）
	BOOL			m_bShowIcon;		//是否显示单元格图标
	BOOL			m_bShowImage;       //是否显示右侧图标
	BOOL			m_bScrollEnable;    //是否可以滚动
    BOOL            m_bRoundRect;       //是否圆角显示
	int				m_nTitleWidth;      //标题宽度
	int				m_nRowHeight;       //行高
	int				m_nCurHeight;       //当前的行高
	
	UIColor			*m_pBackColor;          //背景色
	int				m_nFirstControlWidth;   //第一个控件的宽度
	int				m_nCellMargin;			//间距
	int				m_nCellIconWidth;		//图标宽度
	
	int             keyboardHeight;            //当前输入框跟键盘之间的差距
    BOOL            keyboardIsShowing;         //当前的键盘是否是显示的
    
    NSInteger             m_nSectionNum;              //section总数
	int				m_nCurrentNum;
	TZTOutLineData *_tztOutlineData;           //对应数据接口
	TZTDatePicker	*m_tztDatePicker;
	int				m_nDatePickerHeight;
	
	UITableViewStyle	m_pViewStyle;//	表格类型
    int             m_nHideNum;
    int             m_nSectionHeight;
    int             m_nSliderCount;
    tztUIDroplistView *m_pFocuesSlider;
    NSInteger             m_nTableMaxHeight;  //当前view可显示的最大高度
    BOOL            m_bSeperatorLine;
    BOOL            m_bNeedSelected;
    
    TZTUITextField  *m_pCurrentTextField;
    BOOL            m_bShowSysKeybord;
    
    NSIndexPath     *m_pCurrentSelected;
    int             m_nCurrentSelected;
    //新建一个窗口显示子菜单
    BOOL            _bOpenSubMenuNew;
    
    //当前选中项
    NSMutableDictionary *m_pCurrentSelect;
}

@property(nonatomic, assign)id	m_pDelegate;
@property(nonatomic, retain)UITableView		*m_pTableView;
@property(nonatomic, retain)UIColor		 *m_pBackColor;
@property(nonatomic, retain)TZTDatePicker *m_tztDatePicker;
@property(nonatomic, retain)NSIndexPath     *m_pCurrentSelected;
@property int   m_nRowHeight;
@property BOOL	m_bOnlyRead;
@property BOOL  m_bShowIcon;
@property BOOL  m_bShowImage;
@property (nonatomic) BOOL	m_bScrollEnable;
@property BOOL  m_bRoundRect;
@property int	m_nTitleWidth;
@property int	m_nFirstControlWidth;
@property int	m_nCellMargin;
@property int	m_nCellIconWidth;
@property UITableViewStyle m_pViewStyle;
@property int   m_nSectionHeight;
@property NSInteger   m_nTableMaxHeight;
@property (nonatomic) BOOL  m_bSeperatorLine;
@property BOOL  m_bNeedSelected;
@property (nonatomic,retain)TZTUITextField  *m_pCurrentTextField;
@property (nonatomic,retain)NSMutableDictionary *m_pCurrentSelect;
@property BOOL bOpenSubMenuNew;
//收起子菜单
-(void)collapseBranchAtIndex:(NSDictionary*)pDict index_:(NSInteger)index nCount_:(int*)nCount;
//创建表格
-(id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style bRoundRect:(BOOL)bRoundRect delegate_:(id)pDelegate;
//设置边框
-(void)setBorderStyle:(int)nBorderWidth cColor_:(CGColorRef)cColor;
//读取表格数据
-(void)setTableData:(NSString *)nsName;
-(void)setTableDataEx:(NSMutableDictionary *)pDict;
//根据数组设置表格数据
-(void)setTableData:(NSMutableArray*)ayTitleData ayContent_:(NSMutableArray*)ayContent;
//服务器地址设置专用
-(void)setTableData:(NSMutableArray *)ayTitleData ayContent_:(NSMutableArray *)ayContent withButtonTag_:(int)nBeginTag;
//设置背景颜色
-(void)setTableBackgroundColor:(UIColor*)pColor;
//设置表格是否可滚动
-(void)setM_bScrollEnable:(BOOL)bEnable;
//
-(CGPoint)tztDroplistView:(tztUIDroplistView*)pSliderView point:(CGPoint)point;
//获取section个数
-(NSInteger)getSectionCount;
//设置指定行是否显示
-(void)setRowShow:(BOOL)bShow withRowNum_:(int)nRowNum;
//系统文本框设置
-(void)SetSysEditorText:(NSString*)nsValue withTag:(int)nTag;
//
-(NSString*)GetSysEditorTextWithTag:(int)nTag;
//设置系统编辑框是否可编辑
-(void)SetSysEditorEditable:(BOOL)bEdit withTag:(int)nTag;
//根据tag设置输入框文本
-(void)SetEditorText:(NSString*)nsValue withTag:(int)nTag;
//根据tag获取输入框文本
-(NSString*)GetEditorTextWithTag:(int)nTag;
//设置编辑框是否可编辑
-(void)SetEditorEditable:(BOOL)bEdit withTag:(int)nTag;
//设置label文本
-(void)SetLabelText:(NSString*)nsValue withTag:(int)nTag;
//获取label文本
-(NSString*)GetLabelTextWithTag:(int)nTag;
//bShow 是否直接显示下拉列表
-(void)SetComBoxDataWith:(int)nTag ayTitle_:(NSMutableArray *)ayTitle ayContent_:(NSMutableArray *)ayContent AndIndex_:(int)nIndex bShow_:(BOOL)bShow;
//设置下拉框内容，nIndex:默认选中位置
-(void)SetComBoxDataWith:(int)nTag ayTitle_:(NSMutableArray*)ayTitle ayContent_:(NSMutableArray*)ayContent AndIndex_:(int)nIndex;
//获取下拉框文本
-(NSString*)GetComBoxTextWithTag:(int)nTag nSelectIndex:(NSInteger*)nIndex;
//设置选中
-(void)SetComBoxSelectWithValue:(NSString*)nsValue nTag_:(int)nTag;
//设置标题（只对日期下拉控件生效）
-(void)SetComBoxTitleWithTag:(NSString*)nsTitle nTag:(int)nTag;
//
-(void)SetComBoxEditable:(BOOL)bEnabled withTag:(int)nTag;
//获取当前选中的行号
-(NSInteger) GetComBoxSelectedIndex:(int)nTag;

-(id)GetComBoxSelectedCellDataWithTag:(int)nTag;

-(void)SetCheckBoxValue:(BOOL)bChecked WithTag:(int)nTag;

-(BOOL)GetCheckBoxValueWithTag:(int)nTag;

-(void)reloadTableData;

//检查输入的数据有效性
-(BOOL)CheckInput:(UIView*)pView;

-(void)ShowData:(tztUIDroplistView *)pSlider _Title:(NSString *)title _Data:(NSMutableArray *)data;

+(BOOL) OnCloseKeybord:(UIView*)pView;

-(void)ResetTableStatus;

-(NSString*)GetCurrentCellTitle:(NSString*)nsID;
-(void)setCurrentSelected:(NSString*)nsMenuName;
-(NSString*)GetHQMenuFirstMarket:(NSString*)nsID;
-(NSString*)GetHQMenuParentMarket:(NSString*)nsID;
-(NSArray*)GetMenuDataByID:(NSString*)nsID;
@end



