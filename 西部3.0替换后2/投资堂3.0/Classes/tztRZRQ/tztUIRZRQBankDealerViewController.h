/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:        
 * 文件标识:           融资融券银证业务
 * 摘要说明:        
 * 
 * 当前版本:        2.0
 * 作    者:       xyt
 * 更新日期:            
 * 整理修改:	
 *
 ***************************************************************/

#import "TZTUIBaseViewController.h"
#import "tztRZRQBankDealerView.h"

@interface tztUIRZRQBankDealerViewController : TZTUIBaseViewController
{
    tztRZRQBankDealerView       *_pBankDealerView;
}
@property(nonatomic,retain)tztRZRQBankDealerView    *pBankDealerView;

@end
