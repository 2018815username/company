/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:        TZTUIBaseView
 * 文件标识:        
 * 摘要说明:        view基类
 * 
 * 当前版本:        2.0
 * 作    者:       yinjp
 * 更新日期:            
 * 整理修改:	
 *
 ***************************************************************/

#import <UIKit/UIKit.h>
#import <MobileCoreServices/UTCoreTypes.h>
#import "tztUIDroplistView.h"
#import "tztStockInfo.h"

@protocol tztSocketDataDelegate;
@protocol TZTUIMessageBoxDelegate;

/**
 *  基础view协议
 */
@protocol TZTUIBaseViewDelegate
@optional
/**
 *  返回事件
 */
-(void)OnReturnBack;
/**
 *
 */
-(void)OnOK;
/**
 *  获取当前view上工具条按钮
 *
 *  @return 按钮数组
 */
-(NSMutableArray*)GetAyToolBar;
/**
 *
 */
-(void)OnPopSelf;
/**
 *
 */
-(void)upDownBottomView;
@end

/**
 *  基础view
 */
@interface tztBaseViewUIView :UIView
{
    NSMutableArray* _ayToolBar;
}
/**
 *  添加按钮到toolbar
 *
 *  @param pView 按钮view
 */
- (void)addToolBar:(UIView *)pView;
/**
 *  移除toolbar上的所有按钮
 */
- (void)removeAllToolBar;
/**
 *  获取当前toolbar上的所有按钮，并数组返回
 *
 *  @return 按钮数组
 */
- (NSMutableArray*)GetAyToolBar;
@end

#define TZT_T_Margin 10
@class tztStockInfo;
/**
 *  基础view
 */
@interface TZTUIBaseView : UIView<UIScrollViewDelegate, tztSocketDataDelegate,TZTUIMessageBoxDelegate, tztUIDroplistViewDelegate>
{
    id              _pDelegate;            //回调句柄
    char            _cBeSending;           //是否可以发送数据
    NSString*       _nsStockCode;           //股票代码
    UInt16          _ntztReqNo;             //请求序号
    tztStockInfo    *_pStockInfo;
    NSInteger             _nMsgType;
}

/**
 *  代理
 */
@property(nonatomic,assign)id               pDelegate;
/**
 *  股票代码
 */
@property(nonatomic,retain)NSString         *nsStockCode;
/**
 *  是否发送数据
 */
@property char                              cBeSending;
/**
 *  请求序号
 */
@property UInt16                            ntztReqNo;
/**
 *  股票信息
 */
@property(nonatomic, retain)tztStockInfo    *pStockInfo;
/**
 *  页面类型号
 */
@property NSInteger nMsgType;

/**
 *  菜单点击,返回bool，标识内部是否已经处理过
 *
 *  @param sender 按钮
 *
 *  @return TRUE－内部已经处理过，外层直接跳过；FALSE－内部未处理，外层继续处理
 */
-(BOOL)OnToolbarMenuClick:(id)sender;
/**
 *  关闭键盘事件
 *
 *  @param pView view
 *
 *  @return
 */
-(BOOL) OnCloseKeybord:(UIView*)pView;
/**
 *  返回事件
 */
-(void) OnReturnBack;
@end


/**
 *表格中是否使用图片作为背景
 */
extern int g_nUsePNGInTableGrid;

/**
 *  通过界面类型号获取对应标题，相应数据在tztLocalize.string中进行配置
 *
 *  @param nMsgID 页面类型号
 *
 *  @return 标题文字，若没有，则返回NULL
 */
FOUNDATION_EXPORT NSString* GetTitleByID(NSInteger nMsgID);

/**
 *	@brief	通过界面获取对应发送的功能号
 *
 *	@param 	nMsgID 界面类型
 *
 *	@return	返回功能号，若无，则返回nil
 */
/**
 *  通过界面类型号获取对应发送的功能号，数据同上，在文件中进行配置，若无，则返回空
 *
 *  @param nMsgID 页面类型号
 *
 *  @return 发送的功能号
 */
FOUNDATION_EXPORT NSString* GetActionByID(NSInteger nMsgID);



