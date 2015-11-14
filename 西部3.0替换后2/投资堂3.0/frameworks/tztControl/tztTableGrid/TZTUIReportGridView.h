/*******************************************************************************
 * Copyright (c)2012, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称：TZTUIReportGridView.h
 * 文件标识：
 * 摘    要：自定义Grid
 *
 * 当前版本：
 * 作    者：yangdl
 * 完成日期：2012.12.12
 *
 * 备    注：
 *
 * 修改记录：
 *
 *******************************************************************************/

#import <UIKit/UIKit.h>
#import "TZTUIBaseGridView.h"
#import "TZTUIHQINTopView.h"
#import "TZTUIHQINLeftView.h"
#import "TZTUIHQINCenterView.h"

@interface TZTUIReportGridView : TZTUIBaseGridView <tztGridViewDelegate>
{
    id<tztGridViewDelegate> _delegate;
    NSMutableArray  *_ayFixTitle;
    NSMutableArray  *_ayFixData;
    NSMutableArray  *_ayGridTitle;
    NSMutableArray  *_ayGriddata;
    NSMutableArray  *_ayData;
    
    TZTUIHQINTopView    *_inLeftTopView;
    TZTUIHQINTopView    *_inTopView;
    TZTUIHQINLeftView   *_inLeftView;
    TZTUIHQINCenterView *_inCenterView;
    
	BOOL	_reportType;

	NSInteger     _curIndexRow;  //当前选中行
    NSInteger     _preIndexRow;  //前选中行

    NSInteger         _nMaxColNum;//当前界面显示的列数
    NSString*   _nsBackBg;
}
//接口
@property(nonatomic,assign) id<tztGridViewDelegate>  delegate;
//固定列标题
@property(nonatomic,retain) NSMutableArray  *ayFixTitle;
//固定列数据
@property(nonatomic,retain) NSMutableArray  *ayFixData;
//标题
@property(nonatomic,retain) NSMutableArray  *ayGridTitle;
//数据
@property(nonatomic,retain) NSMutableArray  *ayGriddata;
//数据
@property(nonatomic,retain) NSMutableArray  *ayData;
//
@property(nonatomic,retain) NSMutableArray  *ayStockType;
//
@property(nonatomic,retain) NSString        *nsBackBg;
//
@property(nonatomic,retain) UIFont          *pDrawFont;
//类型
@property BOOL	reportType;
//当前选中行
@property (nonatomic)NSInteger	curIndexRow;
//
@property NSInteger   nMaxColNum;
//
@property (nonatomic) BOOL bGridLines;
//制定类型，0-行情表格 1-交易表格
@property (nonatomic) NSInteger  nGridType;

@property(nonatomic)BOOL bLeftTop;

//pGridData 数据 ayTitle 标题 nType 数据偏移量
-(void)CreatePageData:(NSMutableArray*)pGridData title:(NSMutableArray*)ayTitle type:(NSInteger)nType;
-(void)ClearGridData;
//前一股票
-(NSArray*)tztGetPreStock;
//当前股票
-(NSArray*)tztGetCurStock;
//后一股票
-(NSArray*)tztGetNextStock;

-(void)setBackBg:(NSString*)nsBackBg;
-(void)setSelectRow:(NSInteger)nSel;
-(void)setCurIndexRow:(NSInteger)curIndexRow;

-(CGRect)getLeftTopViewFrame;
- (void)setShowColNum:(NSInteger)nColNum;
@end


