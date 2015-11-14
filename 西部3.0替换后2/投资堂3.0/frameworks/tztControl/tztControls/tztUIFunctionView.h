/*******************************************************************************
 * Copyright (c)2012, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称：    tztUIFunctionView
 * 文件标识：
 * 摘    要：   功能btn展示view
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

@interface tztUIFunctionView : TZTUIBaseView
{
    //按钮数据
    NSMutableArray  *_ayBtnData;
    
    int             _nBtnWidth;
    
    tztUISwitch     *_fixBtn;//固定按钮
    tztUISwitch     *_fixArrow;//箭头
    int             _nFixBtnWidth;
    int             _nArrowWidth;
    BOOL            _bNeedSepLine;
}

@property(nonatomic,retain)NSMutableArray   *ayBtnData;
@property(nonatomic,retain)tztUISwitch      *fixBtn;
@property(nonatomic,retain)tztUISwitch      *fixArrow; 
@property(nonatomic)int                     nBtnWidth;
@property(nonatomic)int                     nFixBtnWidth;
@property(nonatomic)int                     nArrowWidth;
@property(nonatomic)BOOL                    bNeedSepLine;

//设置按钮显示，选中/不选中
-(void)setBtnState:(id)sender;
//根据功能号判断选中该账号
-(id)setBtnSelectWithFunctionID:(NSInteger)nFunctionID;
@end
