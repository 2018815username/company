/*******************************************************************************
 * Copyright (c)2012, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称：    tztUINewTitleView
 * 文件标识：
 * 摘    要：   新的标题栏
 *
 * 当前版本：    1.0
 * 作    者：   yinjp
 * 完成日期：    2013-12-03
 *
 * 备    注：
 *
 * 修改记录：    
 *
 *******************************************************************************/

#import "TZTUIBaseView.h"
#import "CUCustomSwitch.h"
#import "tztUISegment.h"

@protocol tztUINewTitleViewDelegate <NSObject>
@optional
-(void)tztNewTitleClick:(id)sender FuncionID_:(int)nFunctionID withParams_:(id)params;
@end

@interface tztUINewTitleView : TZTUIBaseView
{
    UIButton        *_pLeftBtn;     //左右按钮
    UIButton        *_pRightBtn;
    
    tztUISegment        *_pSwitch;//中间切换工具
    
    NSMutableArray      *_aySegItem;  //中间切换按钮数据
}

@property(nonatomic, retain)UIButton    *pLeftBtn;
@property(nonatomic, retain)UIButton    *pRightBtn;
@property(nonatomic, retain)tztUISegment  *pSwitch;
@property(nonatomic, retain)NSMutableArray      *aySegItem;


-(void)setSelectSegmentIndex:(NSInteger)nIndex;
-(int)getFunctionIDInSegControl;
-(void)setSegControlItems:(NSMutableArray*)ayItems;
@end
