/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:        系统登录界面
 * 文件标识:        
 * 摘要说明:        
 * 
 * 当前版本:        2.0
 * 作    者:       yinjp
 * 更新日期:            
 * 整理修改:	
 *
 ***************************************************************/

#import "tztGJBaseViewController.h"
#import "tztUISysLoginView.h"

@protocol tztUISysLoginViewControllerDelegate
@optional
//登录成功
-(void)OnDealLoginSucc:(NSInteger)nMsgType wParam_:(NSUInteger)wParam lParam_:(NSUInteger)lParam;
//取消了登录
-(void)OnDealLoginCancel:(NSInteger)nMsgType wParam_:(NSUInteger)wParam lParam_:(NSUInteger)lParam;
-(void)OnDealLoginSuccChangeToNine;//zxl 20130718 国泰君安先手机注册成功以后跳转功能九宫格界面
@end

@interface tztUISysLoginViewController : tztGJBaseViewController<tztSocketDataDelegate>
{
    tztUISysLoginView           *_pLoginView;
    //功能号及相关
    NSInteger                    _nMsgID;
    NSData*                   _pMsgInfo;
    NSUInteger                    _lParam;
    id                        _delegate;
    BOOL                      _bIsServer;
}
@property(nonatomic, retain)tztUISysLoginView   *pLoginView;
@property(nonatomic, retain)NSData              *pMsgInfo;
@property(nonatomic, assign)id                  delegate;
@property BOOL  bIsServer;
//记录页面功能，用于页面跳转
-(void)setMsgID:(NSInteger)nID MsgInfo:(void*)pMsgInfo LPARAM:(NSUInteger)lParam;
@end
