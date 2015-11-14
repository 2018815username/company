/*******************************************************************************
 * Copyright (c)2012, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称：TZTUIHQINTopView.h
 * 文件标识：
 * 摘    要：自定义Grid标题列View
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

// 标题
#import <UIKit/UIKit.h>
#import "TZTGridDataObj.h"
#import "TZTUIBaseGridView.h"

@interface TZTUIHQINTopView : UIView 
{
    id<tztGridViewDelegate> delegate;
    CGFloat     _cellWidth;
    CGFloat     _cellHeight;
    NSInteger     _colCount;
    NSInteger     _rowCount;
    NSArray *_ayTitle;//标题
    NSMutableArray* _ayUILabs;
    NSInteger _haveCode;	//显示代码
    NSString* _nsBlackBg;//0-黑色背景 1-白色背景
}
@property (nonatomic,assign) id<tztGridViewDelegate> delegate; //接口
@property (nonatomic,retain) NSString* nsBlackBg;
@property NSInteger haveCode; //显示代码
@property CGFloat cellWidth; //宽度
@property CGFloat cellHeight; //cell高度
@property NSInteger colCount;  //列数
@property NSInteger rowCount;  //行数
@property (nonatomic, retain) NSArray *ayTitle; //标题数据列
@property (nonatomic)BOOL bGridLines;
@property (nonatomic) NSInteger  nGridType;
@property (nonatomic,retain)UIFont *pDrawFont;
@property (nonatomic, assign)BOOL bLeftTop;
@end
