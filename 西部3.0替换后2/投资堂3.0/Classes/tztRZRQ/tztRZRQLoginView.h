/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:        融资融券登录
 * 文件标识:        
 * 摘要说明:        
 * 
 * 当前版本:        2.0
 * 作    者:       yinjp
 * 更新日期:            
 * 整理修改:	
 *
 ***************************************************************/

#import "tztTradeLoginView.h"

@interface tztRZRQLoginView : tztBaseTradeView
{
    UIView                  *_pView;
    //登录界面，预设界面 切换
    UISegmentedControl      *_segmentControl;
    //交易登录界面
    tztUIVCBaseView         *_tztTableView;
    //账号数据
    NSMutableArray          *_pickerData;
    
    NSMutableArray          *_pickPtData;//普通账号
    NSMutableArray          *_pickRZRQData;//融资融券账号
    NSInteger                     _nLoginType;
    
    BOOL                    _bNeedCommPass;
    //功能号及相关
    NSInteger                    _nMsgID;
    NSData                    *_pMsgInfo;
    NSUInteger                    _lParam;

}
@property(nonatomic,retain)UISegmentedControl   *segmentControl;
@property(nonatomic,retain)tztUIVCBaseView      *tztTableView;
@property(nonatomic,retain)NSMutableArray       *pickerData;
@property(nonatomic,assign)NSData               *pMsgInfo;

//获取用户预设账号信息
-(void)OnRefreshData;
//设置信息界面跳转
-(void)setMsgID:(NSInteger)nID MsgInfo:(void*)pMsgInfo LPARAM:(NSUInteger)lParam;
//用户登录
-(void)OnLogin;
-(void)setAccountWithType;
@end
