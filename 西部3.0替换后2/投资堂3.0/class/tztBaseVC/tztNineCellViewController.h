/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:        九宫格显示vc
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

@interface tztNineCellViewController : TZTUIBaseViewController<tztNineGridViewDelegate>
{
    //九宫格显示
    tztUINineGridView       *_pNineGridView;
    //九宫格数组
    NSArray                 *_pAyNineCell;
    
    NSInteger                     _nRow;
    NSInteger                     _nCol;
    NSInteger                     _fCellSize;
}
@property(nonatomic, retain)tztUINineGridView   *pNineGridView;
@property(nonatomic, retain)NSArray             *pAyNineCell;
@property NSInteger nRow;
@property NSInteger nCol;
@property NSInteger fCellSize;
@end
