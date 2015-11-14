/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:        
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
#import "tztListDetailView.h"

@interface tztUIListDetailViewController : TZTUIBaseViewController<UIScrollViewDelegate>
{
    //详情显示表格
    tztListDetailView       *_pDetailView;
    //表格数据
    NSMutableArray          *_pAyData;
    //标题数据
    NSMutableArray          *_pAyTitle;
    //标题对应数据内容
    NSMutableArray          *_pAyContent;
    //
    NSMutableArray          *_pAyToolBar;
    //
    NSMutableDictionary     *_pDictIndex;
    //表格中的当前索引位置
    NSInteger                     _nCurIndex;
}
@property(nonatomic,retain)tztListDetailView    *pDetailView;
@property(nonatomic,retain)NSMutableArray       *pAyData;
@property(nonatomic,retain)NSMutableArray       *pAyTitle;
@property(nonatomic,retain)NSMutableArray       *pAyContent;
@property(nonatomic,retain)NSMutableArray       *pAyToolBar;
@property(nonatomic,retain)NSMutableDictionary  *pDictIndex;
@property NSInteger   nCurIndex;
@property NSInteger   nMaxColNum;
-(void)OnBtnPreStock:(id)sender;
-(void)OnBtnNextStock:(id)sender;

@end
