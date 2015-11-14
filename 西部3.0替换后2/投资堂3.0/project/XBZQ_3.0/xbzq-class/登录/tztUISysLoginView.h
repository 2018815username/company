/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:        登录view
 * 文件标识:        
 * 摘要说明:        
 * 
 * 当前版本:        2.0
 * 作    者:       yinjp
 * 更新日期:            
 * 整理修改:	
 *
 ***************************************************************/

#ifndef __TZTUISYSLOGINVIEW_H__
#define __TZTUISYSLOGINVIEW_H__
#import <MessageUI/MessageUI.h>
#import <UIKit/UIKit.h>
#import <tztMobileBase/tztMoblieStockComm.h>

#import "TZTUIBaseVCMsg.h"

@interface tztUISysLoginView : UIView<tztSocketDataDelegate,MFMessageComposeViewControllerDelegate>
{   
    tztUIVCBaseView             *_pLoginView;
    UILabel                     *_pRegistInfo;
    UITextView                  *_pHelpInfo;
    UIImageView                 *_pImageView;
    NSString                    *_nsMobileCode;
    UIImageView                 *bgImageV;  // 背景
    tztUITextField              *tfPhoneNo; // 手机号输入框
    tztUITextField              *tfCode;    // 验证码输入框w
    UIButton                    *btnSend;   // 发验证码按钮
    UIButton                    *btnLogin;  // 登录按钮
 
    
    int     _ntztReqNo;
    id      _delegate;
    BOOL                        _bIsServiceVC;     //iPad服务中心用
}

@property(nonatomic, retain)tztUIVCBaseView  *pLoginView;
@property(nonatomic, retain)UITextView          *pHelpInfo;
@property(nonatomic, retain)UILabel             *pRegistInfo;
@property(nonatomic, retain)UIImageView         *pImageView;
@property(nonatomic, retain)NSString            *nsMobileCode;
@property(nonatomic, retain)NSString            *checkkey;
@property(nonatomic,strong)UILabel              *tipLable;
@property(nonatomic, assign)id delegate;
@property BOOL              bIsServiceVC;
-(void)OnLogin;
-(void)setControlEnable:(BOOL)bEnable;
//自动登录
-(void)OnAutoLogin;
@property (nonatomic, strong) NSTimer *currTimer;
@end
#endif