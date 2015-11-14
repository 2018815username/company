/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:        ETF撤单vc
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
#import "tztETFWithDraw.h"

@interface tztUIETFWithDrawVC : TZTUIBaseViewController
{
    TZTUIBaseTitleView      *_pTitleView;
    
    tztETFWithDraw          *_pETFWithDraw;
}

@property(nonatomic, retain)TZTUIBaseTitleView     *pTitleView;
@property(nonatomic, retain)tztETFWithDraw        *pETFWithDraw;

@end
