/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:        首页-小分时界面
 * 文件标识:        
 * 摘要说明:        
 * 
 * 当前版本:        2.0
 * 作    者:       zhangxl
 * 更新日期:            
 * 整理修改:	
 *
 ***************************************************************/


@interface tztUIHomePageFenShiView : TZTUIBaseView<tztHqBaseViewDelegate>
{
    UIImageView *           _pImageBG;//背景图片
    UILabel *               _pTitle;//标题
    UISegmentedControl *    _pSegStock;//股票切换
    tztTrendView            *_pTrendView;//分时界面
    UILabel *               _pNew;//最新
    UILabel *               _pPriceData;//最新数据展示
}
-(void)OnChangeStock;
@end
