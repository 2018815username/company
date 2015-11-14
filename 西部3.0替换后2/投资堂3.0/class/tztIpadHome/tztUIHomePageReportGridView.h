/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:        首页-小的排名界面
 * 文件标识:        
 * 摘要说明:        
 * 
 * 当前版本:        2.0
 * 作    者:       zhangxl
 * 更新日期:            
 * 整理修改:	
 *
 ***************************************************************/
#import "tztUserStockEditView.h"
enum
{
    HomePage_UserStock = 1,//自选股
    HomePage_GuoJiIndex,//国际指数
    HomePage_HSAStock,//沪深A股
    HomePage_Edit//编辑界面
};
@interface tztUIHomePageReportGridView : TZTUIBaseView<tztHqBaseViewDelegate>
{
    UIImageView *           _pImageBG;//背景图片
    tztReportListView *     _pReportView;//排名界面
    tztUserStockEditView *  _pEditView;//自选股界面
    UILabel *               _pTitle;//标题
    UIButton *              _pBtEdit;//自选股按钮
    UIButton *              _pBtFullScreen;//全屏按钮
    int                     _pPageType;
    
}
@property(nonatomic,retain)tztReportListView *pReportView;
@property(nonatomic, retain)tztUserStockEditView *pEditView;
@property int   pPageType;
-(void)LoadPage;
@end
