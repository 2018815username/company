/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:        交易/融资融券登录
 * 文件标识:        
 * 摘要说明:        
 * 
 * 当前版本:        2.0
 * 作    者:       xyt
 * 更新日期:            
 * 整理修改:	
 *
 ***************************************************************/

#ifndef __TZTTRADELOGINVIEW_H__
#define __TZTTRADELOGINVIEW_H__
#import "tztBaseTradeView.h"

@interface TZTChooseView : tztBaseTradeView
{
    UIImageView *imageOpen;
    UIImageView *imageInfo;
    UIImageView *imageSeparate;
    UIButton *btnOpen;
    UIButton *btnInfo;
}

- (void)reloadTheme;

@end

@interface tztTradeLoginView : tztBaseTradeView<tztUIButtonDelegate, tztUIDroplistViewDelegate>
{
    UIView                  *_pView;
    //登录界面，预设界面 切换
    UISegmentedControl      *_segmentControl;
    //交易登录界面
    tztUIVCBaseView      *_tztTableView;
    //账号类型数据
    NSMutableArray          *_pickerTypeData;
    TZTChooseView           *chooseView; //选择开户、佣金界面
    //当前的资金账号信息
    tztZJAccountInfo        *_pCurZJAccount;
    CGRect                  dplRect; // For recording dplAccount's rect
    tztUIDroplistView           *dplAccount; // 账号
    tztUITextField              *tfpw; // 密码输入框
    tztUITextField              *tfCode;    // 验证码输入框
    tztUIDroplistView              *tfklType;    //通讯密码输入框

    UIButton                    *btnSend;   // 验证码按钮
    
    //add by ruyi
    UIImageView                 *zjAccountImage;
    UIImageView                 *zjAccountImage2;
    UIImageView                 *jyPassWoldImage;
    UIImageView                 *jyPassWoldImage2;
    UIImageView                 *txmmImage;
    UIImageView                 *txmmImage2;
//    UIButton                *btnRemember; //是否记住密码
    UIButton                *btnLbRemember;
    UIButton                *btnLogin;
    UIImageView             *bgImageV;
    TZTSevenSwitch          *_switchO2O;     // switch for remembering account
    
    //账号数据
    NSMutableArray          *_pickerData;
    
    NSMutableArray          *_pickPtData;//普通账号
    NSMutableArray          *_pickRZRQData;//融资融券账号
    
    BOOL                    _bNeedCommPass;
    //功能号及相关
    NSInteger                    _nMsgID;
    NSData                    *_pMsgInfo;
    NSUInteger                    _lParam;
    BOOL                    _bISHz;
    
    NSInteger                     _nLoginType; //0－普通登录 1－融资融券
    
    NSInteger                   _currentIndex;
}
@property(nonatomic,retain)UISegmentedControl   *segmentControl;
@property(nonatomic,retain)tztUIVCBaseView   *tztTableView;
@property(nonatomic,retain)tztZJAccountInfo     *pCurZJAccount;
@property(nonatomic,retain)NSMutableArray       *pickerData;
@property(nonatomic,assign)NSData               *pMsgInfo;
@property(nonatomic,retain)NSMutableArray       *ayAccountData;
@property(nonatomic,retain)TZTSevenSwitch       *switchO2O;
@property (nonatomic, assign) int colorIndex;
@property NSInteger   nLoginType;
@property BOOL  bISHz;
@property BOOL  bWithoutCode; // second time without Code

-(void)OnLogin;
//获取用户预设账号信息
-(void)OnRefreshData;
//设置信息界面跳转
-(void)setMsgID:(NSInteger)nID MsgInfo:(void*)pMsgInfo LPARAM:(NSUInteger)lParam;
//用户登录
-(void)OnLogin;
-(void)setAccountWithType;
-(NSMutableArray*)getCurrentAccountAy;
- (void)refreshWhenAppear;
- (void)reloadTheme;

@end

#endif