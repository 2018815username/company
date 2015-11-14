/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:        预设账号界面
 * 文件标识:        
 * 摘要说明:        
 * 
 * 当前版本:        2.0
 * 作    者:       yinjp
 * 更新日期:            
 * 整理修改:	
 *
 ***************************************************************/

#import "tztBaseTradeView.h"

@interface tztAddAccountView : tztBaseTradeView
{
    UIView                  *_pView;
    //登录界面，预设界面 切换
    UISegmentedControl      *_segmentControl;
    //交易登录界面
    tztUIVCBaseView      *_tztTableView;
    
    //证券公司
    NSMutableArray          *_ayZQGS;
    //营业部
    NSMutableArray          *_ayYYB;
    //营业部代码
    NSMutableArray          *yyBCode;
    //营业部名称
    NSMutableArray          *yybCodeName;
    //账号类型
    NSMutableArray          *_ayType;
    
    //账号类型数据
    NSMutableArray          *_pickerTypeData;
    //账号数据
    NSMutableArray          *_pickerData;
    
    //索引位置
    NSInteger                     _nZQGSIndex;
    NSInteger                     _nYYBIndex;
    NSInteger                     _nTypeIndex;
    
    //资金账号类型
    NSMutableDictionary     *_ZJTypeDict;
    
    //是否需要通讯密码
    BOOL                    _bNeedComPass;
    
    
    //功能号及相关
    NSInteger                    _nMsgID;
    NSData*                   _pMsgInfo;
    NSUInteger                    _lParam;
    
    NSInteger                     _nLoginType;//登录类型 0－普通交易 1－融资融券
}

@property(nonatomic,retain)UISegmentedControl   *segmentControl;
@property(nonatomic,retain)tztUIVCBaseView      *tztTableView;
@property(nonatomic,retain)NSMutableArray       *ayZQGS;
@property(nonatomic,retain)NSMutableArray       *ayYYB;
@property(nonatomic,retain)NSMutableArray       *ayType;
@property(nonatomic,retain)NSData               *pMsgInfo;
@property NSInteger   nLoginType;

-(void)OnSetPicker:(int)nType pParse_:(tztNewMSParse*)pParse;
-(void)AddAccount;
-(void)OnLoadYYB;
-(void)OnRefreshData;
-(void)setMsgID:(NSInteger)nID MsgInfo:(void*)pMsgInfo LPARAM:(NSUInteger)lParam;

@end
