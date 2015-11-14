/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:        交易详情显示界面
 * 文件标识:        
 * 摘要说明:        
 * 
 * 当前版本:        2.0
 * 作    者:       yinjp
 * 更新日期:            
 * 整理修改:	
 *
 ***************************************************************/
@interface tztListDetailView : UIScrollView
{
    tztUIBaseControlsView   *_detailview;
    NSMutableArray          *_pAyTitle;
    NSMutableArray          *_pAyContent;
    id                      _tztdelegate;
}
@property(nonatomic,retain)NSMutableArray       *pAyTitle;
@property(nonatomic,retain)NSMutableArray       *pAyContent;
@property(nonatomic,assign)id                   tztdelegate;


//设置详情显示信息内容
-(void)SetDetailData:(NSArray*)ayTitle ayContent_:(NSArray*)ayContent;
-(void)SetDetailData:(NSArray *)ayContent;
//菜单点击 减少调用警告 得声明 byDBQ20130718
-(BOOL)OnToolbarMenuClick:(id)sender;
-(void)OnReturnBack;
@end


