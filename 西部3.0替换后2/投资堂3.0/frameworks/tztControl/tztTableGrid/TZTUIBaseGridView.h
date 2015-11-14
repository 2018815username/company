/*******************************************************************************
 * Copyright (c)2012, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称：TZTUIBaseGridView.h
 * 文件标识：
 * 摘    要：自定义Grid基础功能 表格基本组成、表格基本功能
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

#define TZTTABLECELLHEIGHT 45
#define TZTTABLECELLMINHEIGHT 20 //最小显示高度
#define TZTTABLECELLWIDTH  80

#import <UIKit/UIKit.h>
#import "TZTGridDataObj.h"

/**
 *  行情表格类型
 */
typedef NS_ENUM(NSInteger, tztReportType){
    /**
     *  自选表格
     */
    tztReportUserStock = 1,
    /**
     *  最新浏览
     */
    tztReportRecentBrowse,
    /**
     *  用户自定义
     */
    tztReportUserDefine,
    /**
     *  大盘指数
     */
    tztReportDAPANIndex,
    /**
     *  板块指数
     */
    tztReportBlockIndex,
    /**
     *  资金流向
     */
    tztReportFlowsBlockIndex,
};

@protocol tztUIScrollViewDelegate <NSObject>

@optional
-(BOOL)tztGestureRecognizerShouldBegin:(UIGestureRecognizer*)gestureRecognizer;

@end

@interface TZTUIScrollView : UIScrollView<UIGestureRecognizerDelegate>

@property(nonatomic,assign)id<tztUIScrollViewDelegate> tztDelegate;
@end

// 实现多滚动View联动滑动
/**
 *  自定义表格，支持view联动滑动，并可固定指定行数
 */
@interface TZTUIBaseGridView : UIView <UIScrollViewDelegate, tztUIScrollViewDelegate>
{
    CGSize  _szCenterViewSize;               //中间view大小
    NSInteger _nPageRow;  //每页显示行数
    NSInteger _nPageCount;   //总页数
    NSInteger _nReportType;
}
/**
 *  左上角view
 */
@property (nonatomic, retain) UIView            *topleftview;
/**
 *  标题view
 */
@property (nonatomic, retain) TZTUIScrollView   *topview;
/**
 *  左侧一列
 */
@property (nonatomic, retain) TZTUIScrollView   *leftview;
/**
 *  剩余内容
 */
@property (nonatomic, retain) TZTUIScrollView   *centerview;

/**
 *  滚动新增请求数
 */
@property NSInteger     reqAdd;
/**
 *  显示页数
 */
@property NSInteger     nReqPage;

/**
 *  上部标题view高度
 */
@property CGFloat     nTopViewHeight;

/**
 *  左侧leftview宽度
 */
@property CGFloat     nLeftCellWidth;

/**
 *  默认cell显示高度
 */
@property (nonatomic) CGFloat     nDefaultCellHeight;

/**
 *  默认cell显示宽度
 */
@property CGFloat     nDefaultCellWidth;

/**
 *  中间view显示大小
 */
@property (nonatomic) CGSize  szCenterViewSize;

/**
 *  显示列数 (如没有数据 显示空白列)
 */
@property (nonatomic) NSInteger colCount;

/**
 *  显示行数 通过高度计算而得
 */
@property (nonatomic) NSInteger rowCount;

/**
 *  左侧固定列数
 */
@property (nonatomic) NSInteger fixColCount;

/**
 *  顶部固定行数
 */
@property (nonatomic) NSInteger fixRowCount;

/**
 *  是否有代码列（行情排名用到）
 */
@property BOOL haveCode;

/**
 *  起始序号
 */
@property NSInteger indexStarPos;

/**
 *  总记录数
 */
@property NSInteger nValueCount;

/**
 *  当前页
 */
@property NSInteger nCurPage;

/**
 *  总页数
 */
@property (nonatomic) NSInteger nPageCount;

/**
 *  页面类型
 */
@property NSInteger nReportType;

/**
 *    @author yinjp
 *
 *    @brief  是否允许滚动
 */
@property(nonatomic)BOOL bScrollEnable;

/**
 *  初始化数据
 */
- (void)initdata;

/**
 *  设置view区域
 *
 *  @param frame 显示区域
 */
- (void)onSetSubViewFrame:(CGRect)frame;

/**
 *  设置显示区域大小
 *
 *  @param szSize 显示大小
 *
 *  @return TRUE设置成功，FALSE无需设置
 */
- (BOOL)SetCenterViewSize:(CGSize)szSize;

/**
 *  向上翻页
 *
 *  @return 成功返回>0
 */
- (NSInteger)OnPageBack;

/**
 *  向下翻页
 *
 *  @return 成功返回>0
 */
- (NSInteger)OnPageNext;

/**
 *  刷新数据
 *
 *  @return 成功返回 > 0
 */
- (NSInteger)OnPageRefresh;

/**
 *  数据偏移
 *
 *  @param nChangeRow 行号
 */
- (void)dataupdataOffset:(NSInteger)nChangeRow;

/**
 *  是否最后一页
 *
 *  @return TRUE＝最后一页
 */
-(BOOL)IsLastPage;

@end

/**
 *  自定义表格事件协议
 */
@protocol tztGridViewDelegate<NSObject>
@optional

-(void)tztGridView:(TZTUIBaseGridView*)gridView shouldSelectRowAtIndex:(NSInteger)index;
/**
 *  选中行事件
 *
 *  @param gridView tztUIBaseGridView对象
 *  @param index    选中位置
 *  @param num      点击次数
 *  @param gridData 选中行数据
 */
- (void)tztGridView:(TZTUIBaseGridView *)gridView didSelectRowAtIndex:(NSInteger)index clicknum:(NSInteger)num gridData:(NSArray*)gridData;

/**
 *  刷新页面
 *
 *  @param gridView tztUIBaseGridView对象
 *  @param page     页码
 *
 *  @return 成功 > 0
 */
- (NSInteger)tztGridView:(TZTUIBaseGridView *)gridView pageRefreshAtPage:(NSInteger)page;

/**
 *  后翻页
 *
 *  @param gridView TZTUIBaseGridView对象
 *  @param page     页码
 *
 *  @return 成功 > 0
 */
- (NSInteger)tztGridView:(TZTUIBaseGridView *)gridView pageBackAtPage:(NSInteger)page;

/**
 *  前翻页
 *
 *  @param gridView TZTUIBaseGridView对象
 *  @param page     页码
 *
 *  @return 成功 > 0
 */
- (NSInteger)tztGridView:(TZTUIBaseGridView *)gridView pageNextAtPage:(NSInteger)page;

/**
 *  点击标题头事件
 *
 *  @param gridView      TZTUIBaseGridView对象
 *  @param index         点击位置
 *  @param gridDataTitle 点击选择的标题数据对象
 */
- (void)tztGridView:(TZTUIBaseGridView *)gridView didClickTitle:(NSInteger)index gridDataTitle:(TZTGridDataTitle*)gridDataTitle;

/**
 *  获取上一个记录数据
 *
 *  @return 返回记录的数组数据
 */
-(NSArray*)tztGetPreStock;

/**
 *  获取下一个记录数据
 *
 *  @return 返回记录数组数据
 */
-(NSArray*)tztGetNextStock;

/**
 *  获取当前记录数据
 *
 *  @return 返回记录数组数据
 */
-(NSArray*)tztGetCurrent;

//
-(BOOL)tztGestureRecognizerShouldBegin:(UIGestureRecognizer*)gestureRecognizer;
//
-(void)tztGridViewAddUserAddSynsView:(int)nType;//0-不显示，1-顶部，2-底部

@end