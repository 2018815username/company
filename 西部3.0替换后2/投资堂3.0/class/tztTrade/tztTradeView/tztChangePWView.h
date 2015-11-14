/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:        修改密码
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

typedef enum tztChangePWType
{
    PWT_Soft,       //软件密码
    PWT_Deal,       //交易密码
    PWT_Money,      //资金密码
    PWT_Server,     //服务密码(通讯密码)
}
tztChangePWType;

@interface tztChangePWView : tztBaseTradeView<tztUIBaseViewTextDelegate>
{
    tztUIVCBaseView         *_tztTableView;
    
    NSMutableArray          *_ayPWType;
    NSMutableArray          *_ayPWData;
    
    int                     _nPWType;
}

@property(nonatomic,retain)tztUIVCBaseView   *tztTableView;
@property(nonatomic,retain)NSMutableArray       *ayPWType;
@property(nonatomic,retain)NSMutableArray       *ayPWData;
@property int                                   nPWType;

-(void)SetDefaultData;
-(BOOL)CheckInputPW;
@end
