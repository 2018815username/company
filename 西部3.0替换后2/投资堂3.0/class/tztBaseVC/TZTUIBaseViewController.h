/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:        vc基类
 * 文件标识:
 * 摘要说明:
 *
 * 当前版本:        2.0
 * 作    者:       yinjp
 * 更新日期:
 * 整理修改:    增加_tztBaseView  在ios7系统下，界面会整体上移(statusbar高度变更)
 *
 ***************************************************************/

#ifndef __TZTUIBASEVIEWCONTROLLER_H__
#define __TZTUIBASEVIEWCONTROLLER_H__
#import <UIKit/UIKit.h>
#import "TZTUIBaseVCMsg.h"

#define tztBackWhiteImag [UIImage imageTztNamed:@"TZTnavWhitebackbg.png"]

//设定交易需要重新登录时，需要返回的层数，0保持当前页面，1弹出当前页面 N弹出N层页面
//此值设定返回层数，切记不可太多
#define TradeErrorReturnBack    1
@class TZTUIMessageBox;
@class tztStockInfo;
typedef enum : NSUInteger {
    tztTitleNew,//默认
    tztTitleOld,
} tztIndexTitleType;

@interface TZTUIBaseViewController : UIViewController<UIActionSheetDelegate,tztStockSearchDelegate,UIPopoverControllerDelegate, TZTUIToolBarViewDelegate,TZTUIBaseViewDelegate>
{
    tztBaseViewUIView              *_tztBaseView;//ios7适配使用 add by yinjp
	UIToolbar           *toolBar;   
	NSInteger                 _nMsgType;
	UIPopoverController *_popoverVC;
    tztStockInfo        *_pStockInfo;
    UInt16              _ntztReqno;
    //标题栏
    TZTUIBaseTitleView  *_tztTitleView;
    
    //增加标题字段，使用配置的标题进行显示，程序中不再通过_nMsgType进行判断
    NSString        *_nsTitle;
    BOOL                _bPopToRoot;
    UIViewController    *_pParentVC;
    
    CGRect              _tztFrame;//self.view.frame/_tztBaseView.frame
    CGRect              _tztBounds;//self.view.bounds/_tztBaseView.bounds
    
    BOOL transiting;
}
@property(nonatomic,retain) tztBaseViewUIView  *tztBaseView;
@property(nonatomic,retain) IBOutlet UIToolbar	*toolBar;
@property(nonatomic,retain) tztStockInfo        *pStockInfo;
@property(nonatomic) NSInteger   nMsgType;
@property(nonatomic, retain)TZTUIBaseTitleView  *tztTitleView;
@property(nonatomic,retain)NSString *nsTitle;
@property (nonatomic)BOOL bPopToRoot;
@property(nonatomic, retain)UIViewController    *pParentVC;
@property(nonatomic)BOOL shouldFixAnimation;
@property(nonatomic,assign)id tztDelegate;

@property(nonatomic,assign)tztIndexTitleType    tztTitleType;
@property(nonatomic,assign)BOOL                 bHiddenLeftIcon;//是否隐藏左上角的icon，默认NO

-(void)CreateToolBar;
-(void)LoadLayoutView;
-(void)LoadLayoutViewEx;
// 底部工具栏更多变服务项 byDBQ20130730
-(BOOL)toolBarItemForContainService;

- (void)onSetTztTitleView:(NSString*)strTitle type:(int)nType;

- (void)onSetTztTitleViewFrame:(CGRect)rcFrame;

-(void) OnBackMsg:(NSInteger)nMsgType wParam:(NSUInteger)wParam lParam:(NSUInteger)lParam;


- (void)OnMakePhoneCall:(NSString*)telePhoneNum;
- (void)OnShowPhoneList:(NSString*)telphone;

//返回上页
-(void) OnReturnBack;

-(void)OnMore;

-(void)ShowHelperImageView;

-(TZTUIMessageBox*) showMessageBox:(NSString *)nsString nType_:(int)nType delegate_:(id)delegate;
-(TZTUIMessageBox*) showMessageBox:(NSString *)nsString nType_:(int)nType nTag_:(int)nTag;
-(TZTUIMessageBox*) showMessageBox:(NSString*)nsString nType_:(int)nType nTag_:(int)nTag delegate_:(id)delegate;
-(TZTUIMessageBox*) showMessageBox:(NSString *)nsString nType_:(int)nType nTag_:(int)nTag delegate_:(id)delegate withTitle_:(NSString*)nsTitle;
-(TZTUIMessageBox*) showMessageBox:(NSString *)nsString nType_:(int)nType nTag_:(int)nTag delegate_:(id)delegate withTitle_:(NSString*)nsTitle nsOK_:(NSString*)nsOK nsCancel_:(NSString*)nsCacel;
//菜单点击
-(void)OnToolbarMenuClick:(id)sender;

-(UIPopoverController*) PopViewController;
-(void) PopViewControllerDismiss;
-(void) PopViewController:(UIViewController*)pVC rect:(CGRect)rect;
-(void) PopViewControllerWithoutArrow:(UIViewController*)pVC rect:(CGRect)rect;
-(void) onSetToolBarBtn:(NSMutableArray*)ayBtn bDetail_:(BOOL)bDetail;


- (void)reloadTheme;
- (void)OnChangeTheme;
@end
#endif