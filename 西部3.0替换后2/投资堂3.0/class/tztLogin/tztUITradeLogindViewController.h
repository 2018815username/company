/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:        交易登录vc
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
#import "tztTradeLoginView.h"
@interface tztUITradeLogindViewController : TZTUIBaseViewController
{
    tztTradeLoginView       *_pTradeLoginView;
    
    //功能号及相关
    NSInteger                    _nMsgID;
    NSData*                   _pMsgInfo;
    NSData*                   _lParam;
    
    BOOL                    _bISHz; //担保品划转使用
    NSInteger                     _nLoginType;//登录类型 0－普通交易 1－融资融券
    NSMutableDictionary     *_pDictLoginInfo;
}
@property(nonatomic, retain)tztTradeLoginView   *pTradeLoginView;
@property(nonatomic, retain)NSMutableDictionary *pDictLoginInfo;
@property(nonatomic, assign)NSData              *pMsgInfo;
@property(nonatomic, assign)NSData              *lParam;
@property BOOL  bISHz;
@property NSInteger   nLoginType;

-(void)setMsgID:(NSInteger)nID MsgInfo:(void*)pMsgInfo LPARAM:(void*)lParam;

@end
