/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:        有效期查询
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
#import "tztTradeSearchView.h"

@interface tztCommRequstViewController : TZTUIBaseViewController
{
    tztTradeSearchView      *_pCommView;
}

@property(nonatomic,retain)tztTradeSearchView   *pCommView;


-(void)SetTitle:(NSString*)nsTitle;
//有效期查询
//-(void)OnRequestValidDate;

@end
