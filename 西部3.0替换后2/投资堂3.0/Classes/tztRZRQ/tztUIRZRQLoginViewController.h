/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:        融资融券登录
 * 文件标识:        
 * 摘要说明:        
 * 
 * 当前版本:        2.0
 * 作    者:       xyt
 * 更新日期:            
 * 整理修改:	
 *
 ***************************************************************/

#import "TZTUIBaseViewController.h"
#import "tztRZRQLoginView.h"

@interface tztUIRZRQLoginViewController : TZTUIBaseViewController
{
    tztRZRQLoginView        *_pLoginView;
    
    //功能号及相关
    NSInteger                    _nMsgID;
    NSData*                   _pMsgInfo;
    NSUInteger                    _lParam;
}

@property(nonatomic, retain)tztRZRQLoginView            *pLoginView;
@property(nonatomic, assign)NSData              *pMsgInfo;

-(void)setMsgID:(NSInteger)nID MsgInfo:(void*)pMsgInfo LPARAM:(NSUInteger)lParam;
@end
