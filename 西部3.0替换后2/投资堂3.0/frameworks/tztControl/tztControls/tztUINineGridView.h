/*******************************************************************************
 * Copyright (c)2012, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称：tztUINineGridView.h
 * 文件标识：
 * 摘    要：九宫格
 *          tztNineCellData 宫格对象
 *          tztNineCellView 宫格视图
 *          tztUINineGridView 九宫格视图
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

/**
 *  交易权限
 */
extern NSMutableArray   *g_ayTradeRights;

/**
 *  单个宫格数据对象
 */
@interface tztNineCellData : NSObject
{
    NSString* _image;//图片名称
    NSString* _highimage;//高亮
    NSString* _text; //标题
    NSInteger _cmdid;//功能ID
    NSString* _cmdparam;//功能参数
}
/**
 *  图片名称
 */
@property (nonatomic,retain) NSString* image;
/**
 *  选中图片名称
 */
@property (nonatomic,retain) NSString* highimage;
/**
 *  标题文字
 */
@property (nonatomic,retain) NSString* text;
/**
 *  对应功能id
 */
@property NSInteger cmdid;
/**
 *  对应功能参数
 */
@property (nonatomic,retain) NSString* cmdparam;

/**
 *  初始化创建NineCellData对象
 *
 *  @param celldata 属性字符串
 *
 *  @return NineCellData对象
 */
- (id)initwithCellData:(NSString*)celldata;

/**
 *  设置NineCellData对象数据
 *
 *  @param celldata 属性字符串
 */
- (void)setCellData:(NSString*)celldata;
@end

/**
 *  tztNineGridView协议
 */
@protocol tztNineGridViewDelegate <NSObject>
@optional
/**
 *  宫格点击事件处理
 *
 *  @param ninegridview tztNineCellView
 *  @param cellData     tztNineCellData对象
 */
- (void)tztNineGridView:(id)ninegridview clickCellData:(tztNineCellData *)cellData;
@end

/**
 *  单个宫格显示view
 */
@interface tztNineCellView : UIView
{
    UIButton* _cellbtn;
    UILabel*  _celllab;
    tztNineCellData* _cellData;
    id<tztNineGridViewDelegate> _tztdelegate;
    UIColor  *_clText;
    CGFloat _fCellSize;
}
/**
 *  代理
 */
@property (nonatomic,assign) id<tztNineGridViewDelegate> tztdelegate;
/**
 *  宫格数据对象
 */
@property (nonatomic,retain) tztNineCellData* cellData;
/**
 *  字体显示颜色
 */
@property (nonatomic,retain) UIColor *clText;
/**
 *  显示宫格大小
 */
@property CGFloat fCellSize;
@end

/**
 *  九宫格显示view
 */
@interface tztUINineGridView : UIView<tztNineGridViewDelegate, UIScrollViewDelegate>
{
    UIScrollView    *_pScrollView;
    NSMutableArray* _aycelldata;//数据列表
    NSMutableArray* _aycell;
    NSInteger       _rowCount;//行数
    NSInteger       _colCount;//列数
    id<tztNineGridViewDelegate> _tztdelegate;
    UIColor     *_clText;//标题文字颜色
    NSString*   _nsBackImage;
    BOOL        _bIsMoreView;
    CGFloat     _fCellSize;
    NSInteger         _nFixCol;
    
    UIPageControl   *_pageControl;
    NSMutableArray* _aycelldataAll;
}
/**
 *  定义scrollview，用于多个时可以滚动显示
 */
@property (nonatomic,retain)UIScrollView    *pScrollView;
/**
 *  协议
 */
@property (nonatomic,assign) id<tztNineGridViewDelegate> tztdelegate;
@property (nonatomic,retain)UIColor         *bgColor;
/**
 *  宫格行数
 */
@property (nonatomic) NSInteger rowCount;
/**
 *  宫格列数
 */
@property (nonatomic) NSInteger colCount;
/**
 *  字体颜色
 */
@property (nonatomic,retain)UIColor *clText;
/**
 *  背景图片
 */
@property (nonatomic,retain)NSString* nsBackImage;
/**
 *
 */
@property BOOL bIsMoreView;
/**
 *  宫格大小
 */
@property CGFloat fCellSize;
/**
 *  列数
 */
@property NSInteger nFixCol;
/**
 *  pagecontrol控件
 */
@property (nonatomic,retain)UIPageControl *pageControl;

- (void)setAyCellData:(NSArray*)ayCellData;
- (void)setAyCellDataAll:(NSArray*)ayCellData;
@end



