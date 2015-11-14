/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:        工具栏更多显示view
 * 文件标识:        
 * 摘要说明:        
 * 
 * 当前版本:        2.0
 * 作    者:       yinjp
 * 更新日期:            
 * 整理修改:	
 *
 ***************************************************************/

#import <UIKit/UIKit.h>
#import "TZTUIBaseView.h"
#import "tztUINineGridView.h"

/**
 显示位置类型
 */
typedef NS_ENUM(NSInteger, tztToolbarMoreViewPosition)
{
    /**
     *显示在底部 默认（default）
     */
    tztToolbarMoreViewPositionBottom    = 1 << 0,
    /**
     *  显示在顶部
     */
    tztToolbarMoreViewPositionTop       = 1 << 1,
    /**
     *  显示在左侧
     */
    tztToolbarMoreViewPositionLeft      = 1 << 2,
    /**
     *  显示在右侧
     */
    tztToolbarMoreViewPositionRight     = 1 << 3,
};


/**
 显示方式
 */
typedef NS_ENUM(NSInteger, tztToolbarMoreViewShowType)
{
    /**
     *  宫格显示（default）
     */
    tztShowType_Grid = 0,
    /**
     *     列表显示
     */
    tztShowType_List = 1,
};

/**
 *  更多view显示，以及弹出选择菜单view
 */
@interface tztToolbarMoreView : TZTUIBaseView<tztNineGridViewDelegate,UITableViewDelegate,UITableViewDataSource>
{
    UITableView             *_pTableView; //table
    tztUINineGridView       *_pNineGridView; //九宫格
    NSMutableArray          *_ayGrid;
    
    tztToolbarMoreViewPosition _nPosition;  //显示位置
    
    CGFloat                 _fCellHeight;   //单行高度
    CGSize                  _szOffset;       //偏移量
    CGFloat                 _fMenuWidth;    //显示宽度
    
    UIColor                 *_bgColor;      //背景色
    NSInteger                     _nRowCount;     //行数
    NSInteger                     _nColCount;     //列数
    tztToolbarMoreViewShowType _nShowType;
    UIColor                 *_clSeporater;
    UIColor                 *_clText;    //字体颜色
    NSInteger                     _nFontSize;
}

@property(nonatomic,assign)CGFloat        fBorderWidth;
@property(nonatomic,retain)UIColor        *clBorderColor;
/**
 *    @author yinjp
 *
 *    @brief  标题，若nsTitle.length>0则显示，否则不显示，默认不显示
 */
@property(nonatomic,retain)NSString*        nsTitle;
/**
 *  字体大小
 */
@property(nonatomic)NSInteger nFontSize;
/**
 *  表格显示
 */
@property(nonatomic, retain)UITableView         *pTableView;
/**
 *  宫格显示
 */
@property(nonatomic, retain)tztUINineGridView   *pNineGridView;
/**
 *  显示位置，查看tztToolbarMoreViewPosition定义
 */
@property(nonatomic) tztToolbarMoreViewPosition nPosition;
/**
 *  背景颜色
 */
@property(nonatomic, retain)UIColor             *bgColor;
/**
 *  显示高度
 */
@property(nonatomic) CGFloat                    fCellHeight;
/**
 *  偏移位置
 */
@property(nonatomic) CGSize                     szOffset;
/**
 *  菜单显示宽度
 */
@property(nonatomic) CGFloat                    fMenuWidth;
/**
 *  行数（宫格显示使用）
 */
@property(nonatomic) NSInteger                        nRowCount;
/**
 *  列数（宫格显示使用）
 */
@property(nonatomic) NSInteger                        nColCount;
/**
 *  显示方式，见tztToolbarMoreViewShowType定义
 */
@property(nonatomic) tztToolbarMoreViewShowType nShowType;
/**
 *  分割线颜色
 */
@property(nonatomic,retain)UIColor              *clSeporater;
/**
 *  文字颜色
 */
@property(nonatomic,retain)UIColor              *clText;

/**
 *  初始化创建，并传入显示方式
 *
 *  @param showType 显示方式，见tztToolbarMoreViewShowType定义
 *
 *  @return tztToolbarMoreView对象
 */
-(id)initWithShowType:(tztToolbarMoreViewShowType)showType; //以九宫格还是 table显示
/**
 *  设置显示数据
 *
 *  @param ayGridCell 需要显示的菜单数据
 */
-(void)SetAyGridCell:(NSArray*)ayGridCell;
/**
 *  隐藏当前显示
 */
-(void)hideMoreBar;
@end
