
/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:        首页-右上交可以滑动的界面
 * 文件标识:        
 * 摘要说明:        
 * 
 * 当前版本:        2.0
 * 作    者:       zhangxl
 * 更新日期:            
 * 整理修改:	
 *
 ***************************************************************/
@interface tztUIHomePageScrollView : TZTUIBaseView<tztMutilScrollViewDelegate>
{
    tztMutilScrollView * _pScrollView;
}
-(void)LoadPage;
@end
