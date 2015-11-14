/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:        个股详情界面中的底部最新要闻、大单监控、上证BBD、深圳BBD、资金流向 的一个集合
 * 文件标识:        
 * 摘要说明:        
 * 
 * 当前版本:        2.0
 * 作    者:       zhangxl
 * 更新日期:            
 * 整理修改:	
 *
 ***************************************************************/
#import "tztInfoTableView.h"
enum
{
    BottomViewType_ZXYW = 0,
    BottomViewType_SHZQBBD,
    BottomViewType_SZZQBBD,
    BottomViewType_ZJLS,
    BottomViewType_DDJK
};
@interface TZTUIBottomSetView : TZTUIBaseView<tztHqBaseViewDelegate,tztInfoDelegate>
{
    tztInfoTableView  *         _pInfoView;// 最新要闻界面
    TZTUIFundFlowsView *        _pFundFlowsView;//资金流向界面
    tztLargeMonitorView         *_pLargeView;   //大单监控界面
    tztStockInfo *              _pPreStock;//上个股票信息
    tztStockInfo *              _pStock;//当前股票信息
    UIImageView *               _uImageView;//按钮线面的背景
    int                         _nViewType;//当前界面的类型
    int                         _nMaxCount;//用于资金流向初始化的时候确定其 区域内的点的个数（和分时相同从分时界面获取）
    float                       _fLeftWidth;//用于资金流向初始化的时候确定其 左边坐标显示的宽度（和分时界面相同从分时界面获取）
}
@property(nonatomic, retain)tztInfoTableView  *pInfoView;
@property(nonatomic, retain)TZTUIFundFlowsView *pFundFlowsView;
@property(nonatomic, retain)tztLargeMonitorView *pLargeView;
@property(nonatomic, retain)UIImageView  *uImageView;
@property(nonatomic, retain)tztStockInfo *pStock;
@property int nViewtype;
@property int nMaxCount;
@property float fLeftWidth;
//设置请求
-(void)onSetViewRequest:(BOOL)bRequest;
//设置股票
-(void)SetStock:(tztStockInfo*)Stock;
//获取界面类型通过按钮的名称
-(int)GetViewTypeByBtnName:(NSString *)BtnName;
//创建按钮集合
-(void)GreatButtonArray;
//资金流向移动光标线的时候 分时界面也移动光标线
-(void)MoveFenshiCurLine:(CGPoint)point;
//资金流向界面光标线显示或者不显示控制分时界面的光标线
-(void)ShowFenshiCurLine:(BOOL)show Point:(CGPoint)point;
@end
