/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:        预设账号
 * 文件标识:        
 * 摘要说明:        
 * 
 * 当前版本:        2.0
 * 作    者:       yinjp
 * 更新日期:            
 * 整理修改:	
 *
 ***************************************************************/

#import "TZTUIBaseViewController.h"
#import "tztAddAccountView.h"
@interface tztUIAddAccountViewController : TZTUIBaseViewController
{
    tztAddAccountView       *_pAddAccountView;
    
    NSInteger                  _nMsgID;
    NSData*                 _pMsgInfo;
    NSUInteger                  _lParam;
    
    NSInteger                     _nLoginType; //0－普通登录 1－融资融券
}
@property(nonatomic, retain)tztAddAccountView   *pAddAccountView;
@property(nonatomic, retain)NSData              *pMsgInfo;
@property NSInteger   nLoginType;

-(void)setMsgID:(NSInteger)nID MsgInfo:(void*)pMsgInfo LPARAM:(NSUInteger)lParam;


@end
