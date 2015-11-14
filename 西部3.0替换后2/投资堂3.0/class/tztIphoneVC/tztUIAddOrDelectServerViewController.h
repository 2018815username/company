/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:        服务器设置vc
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
#import "tztAddOrDeletServerView.h"

@interface tztUIAddOrDelectServerViewController : TZTUIBaseViewController
{
    tztAddOrDeletServerView *_pAddView;
}
@property(nonatomic,retain)tztAddOrDeletServerView  *pAddView;

@end
