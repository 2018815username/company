/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:        资讯中心（iphone）
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
#import "tztInfoTableView.h"

@interface tztZXCenterViewController_iphone : TZTUIBaseViewController<tztInfoDelegate,tztHqBaseViewDelegate>
{
    //一级菜单
    tztInfoTableView    *_tztInfoView;
    
    tztInfoItem         *_pInfoItem;
    
    NSString            *_stockCode;
}
@property(nonatomic, retain)tztInfoTableView    *tztInfoView;
@property(nonatomic, retain)tztInfoItem         *pInfoItem;
@property(nonatomic, retain)NSString            *stockCode;
@end
