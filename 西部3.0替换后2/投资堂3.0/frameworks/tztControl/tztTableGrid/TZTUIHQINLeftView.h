/*******************************************************************************
 * Copyright (c)2012, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称：TZTUIHQINLeftView.h
 * 文件标识：
 * 摘    要：自定义Grid左侧固定列View
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

// 左侧固定列
#import <UIKit/UIKit.h>

#import "TZTUIHQINCenterView.h"
#import "TZTGridDataObj.h"
@protocol tztGridViewDelegate;
@interface TZTUIHQINLeftView : UIView
{
    NSArray	*_ayFixGridData;
    TZTUIHQINCenterView     *_inScrollView;
    NSMutableArray* _ayUILabs;
    CGFloat _cellWidth;
    NSInteger _colCount;
    
    CGFloat _cellHeight;
    NSInteger _rowCount;
    
    NSInteger	_indexStarPos; //起始序号
    
    NSInteger _curIndexRow;  //当前选中行
    NSInteger _preIndexRow;  //前选中行

    NSInteger	_haveIndex; //显示序号
	NSInteger _haveCode;	//显示代码
    NSString* _nsBackBg;
}
@property(nonatomic,retain) NSArray	*ayFixGridData;
@property(nonatomic,retain) NSArray *ayStockType;
@property(nonatomic,retain)TZTUIHQINCenterView	*inScrollView;
@property(nonatomic,retain) NSString* nsBackBg;
@property CGFloat cellWidth;
@property NSInteger colCount;

@property CGFloat cellHeight;
@property NSInteger rowCount;

@property NSInteger indexStarPos;
@property NSInteger curIndexRow;
@property (nonatomic) NSInteger	haveIndex;
@property (nonatomic) NSInteger	haveCode;
@property (nonatomic) BOOL  bGridLines;
@property (nonatomic) NSInteger   nGridType;

- (void)doSelectAtRow:(NSInteger)nCurRow;
@end
