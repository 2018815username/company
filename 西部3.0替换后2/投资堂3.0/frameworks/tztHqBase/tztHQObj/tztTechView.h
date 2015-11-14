/*******************************************************************************
 * Copyright (c)2012, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称：tztTechView.h
 * 文件标识：
 * 摘    要：K线视图
 *
 * 当前版本：
 * 作    者：yangdl
 * 完成日期：2012.12.12
 *
 * 备    注：
 *
 * 修改记录：
 * // zxl  20131206 修改了炒跟K线界面现实方式
 *******************************************************************************/

#import <UIKit/UIKit.h>
#import "tztTechObj.h"
#import "tztUIPickerView.h"
#import "tztUIEditValueView.h"

@interface tztTechView : tztHqBaseView <tztPickerViewDelegate,tztEditViewDelegate,tztTechObjDelegate,tztHqBaseViewDelegate>
{
    tztTechObj*   _TechObjPKLine; //K线图
    tztTechObj*   _TechObjVol; //量图
    tztTechObj*   _TechObjMACD;    //指标图
    
    NSInteger            _KLineZhibiao;//指标 PKLine VOL MACD
    
    UIButton* _btnCycle;
    UIButton* _btnZhiBiao;
    CGRect      _KLineDrawRect;//绘制区域
    BOOL        _TechCursorDraw;//是否绘制光标线
    BOOL        _bTechMoved;    //是否可拖动
    CGPoint     _TechCursorPoint;//光标点
    UIButton* _btnZoomIn;
    UIButton* _btnZoomOut;
}

@property (nonatomic, retain) NSMutableArray*     ayTechValue;
@property (nonatomic, readonly) NSInteger  KLineZhibiao;//指标 PKLine VOL MACD
@property tztKLineCycle KLineCycleStyle;//周期类型
@property CGFloat       YAxisWidth; //Y轴宽
@property BOOL TechCursorDraw;//是否绘制光标线
@property (nonatomic, retain) UIButton* btnCycle;
@property (nonatomic, retain) UIButton* btnZhiBiao;
@property (nonatomic, assign)BOOL needPickerView; // 是否需要指标数据
@property (nonatomic, assign)BOOL bSupportTechCursor;
@property (nonatomic, assign)BOOL bTechMoved;
@property (nonatomic, assign)BOOL bTouchParams;//点击触发设置参数
@property (nonatomic, retain)UIButton *btnZoomIn;
@property (nonatomic, retain)UIButton *btnZoomOut;
@property (nonatomic)BOOL   bShowTechParams;
@property (nonatomic)BOOL   bShowLeftInSide;
@property (nonatomic)BOOL   bShowMaxMin;
@property (nonatomic)BOOL   bHiddenCycle;
@property (nonatomic)BOOL   bHiddenObj;
//显示除权
@property (nonatomic)BOOL   bShowChuQuan;
@property (nonatomic)BOOL   bShowObj;
@property (nonatomic)BOOL   bIgnorTouch;
@property (nonatomic)tztKLineAxisStyle PKLineAxisStyle;
@property (nonatomic)tztKLineAxisStyle ObjAxisStyle;
/**
 *  支持历史分时 默认支持
 */
@property (nonatomic)BOOL   bSupportHisTrend;
//设置K线图数（最多支持三图）
- (void)setTechMapNum:(tztKLineMapNum)num;
- (TNewPriceData*)GetNewPriceData;
- (TNewKLineHead*)GetNewKLineHead;

//控制Tips的显示和隐藏
-(void)setTipsShow:(BOOL)bShow;
//设置按钮位置
- (void)setBtnFrame:(CGRect)rect;

-(void)setHisBtnShow:(BOOL)bShow;

//获取当前光标线所在位置的当天的tztTechValue
- (tztTechValue *)GetCurIndexTechValue;

- (NSInteger)CalculateDrawIndex:(NSInteger)nKind; //nKind 0 初始  1 move  2 放大缩小 3-右move
-(void)tztChangeCycle:(int)nKLineCycleStyle picker_:(tztUIPickerView *)pickerView;
-(void)tztChangeZhiBiao:(NSInteger)nKLineZhiBiao;

-(void)trendTouchMoved:(CGPoint)point bShowCursor_:(BOOL)bShowCursor;
@end