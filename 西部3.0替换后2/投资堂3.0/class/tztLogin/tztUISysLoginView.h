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
#import "TZTUIBaseVCMsg.h"

@interface tztUISysLoginView : UIView<tztSocketDataDelegate,MFMessageComposeViewControllerDelegate>
{   
    tztUIVCBaseView             *_pLoginView;
    
    UIView                      *_pView;
    UISegmentedControl          *_segmentControl;
    
    UITextView                  *_pHelpInfo;
    UIImageView                 *_pImageView;
    NSString                    *_nsMobileCode;
    
    int     _ntztReqNo;
    id      _delegate;
    BOOL                        _bIsServiceVC;     //iPad服务中心用
    BOOL                        _bAutoLogin;
    NSString *  _nsEditMoblie;//zxl 20130729 登录错误的时候保留编辑手机号
}

@property(nonatomic, retain)tztUIVCBaseView     *pLoginView;
@property(nonatomic, retain)UIView              *pView;
@property(nonatomic, retain)UISegmentedControl  *segmentControl;
@property(nonatomic, retain)UITextView          *pHelpInfo;
@property(nonatomic, retain)UIImageView         *pImageView;
@property(nonatomic, retain)NSString            *nsMobileCode;
@property(nonatomic, assign)id delegate;
@property BOOL              bIsServiceVC;
@property(nonatomic,retain)NSString            *nsEditMoblie;

-(void)OnLogin;
-(void)setControlEnable:(BOOL)bEnable;
@end
#endif