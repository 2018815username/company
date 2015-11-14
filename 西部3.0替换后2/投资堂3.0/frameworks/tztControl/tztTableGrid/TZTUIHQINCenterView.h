/*******************************************************************************
 * Copyright (c)2012, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称：TZTUIHQINCenterView.h
 * 文件标识：
 * 摘    要：自定义Grid中间View
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

@protocol tztGridViewDelegate;
//中间数据view
@interface TZTUIHQINCenterView : UIView 
{
	NSMutableArray *_ayGridData; //数据列表
    
    CGFloat _cellWidth;              //宽度
    CGFloat _cellHeight;             //高度
    
    NSInteger _colCount;               //列数
    NSInteger _rowCount;               //行数
    
	NSInteger _curIndexRow;            //当前选中行
    NSInteger _preIndexRow;            //前选中行
	BOOL _zcDoubleClick;         //支持双击
	
	id<tztGridViewDelegate> _delegate; //接口
	
	BOOL	_haveButton;        //有按钮
	UIImage	*_btnImage;         //按钮底图
	
	UIImage *_btnImageUp;       //涨底图
	UIImage *_btnImageDown;     //跌底图
    CGPoint _preClickPoint;
    NSString    *_nsBackBg;
}

@property (nonatomic, retain) NSString *nsBackBg;
@property (nonatomic, assign) id<tztGridViewDelegate> delegate;
@property CGFloat cellWidth; //宽度
@property CGFloat cellHeight;//高度

@property NSInteger colCount;  //列数
@property NSInteger rowCount;  //行数
@property NSInteger curIndexRow;//当前选中行

@property (nonatomic,retain) NSMutableArray *ayGridData;//数据
@property BOOL haveButton; //按钮
@property (nonatomic, retain) UIImage	*btnImage;//图片
@property (nonatomic, retain) UIImage   *btnImageUp;//图片
@property (nonatomic, retain) UIImage   *btnImageDown;//图片
@property (nonatomic, retain) UIFont    *pDrawFont;
@property (nonatomic)BOOL bGridLines;
@property (nonatomic)NSInteger  nGridType;
@property (nonatomic)BOOL bFirstColLeft;
//设置选中行
- (void)doSelectAtRow:(NSInteger)nCurRow DoubleTap:(BOOL)bDouble;
@end
