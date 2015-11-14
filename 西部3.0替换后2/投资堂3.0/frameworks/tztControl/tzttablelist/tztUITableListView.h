//
//  tztTableListView.h
//  tztMobileApp
//
//  Created by yangares on 13-4-25.
//
//

#import <UIKit/UIKit.h>
#import "tztUITableListCellView.h"
#import "TZTOutLineData.h"
//CellHeight=float tablecell高度
//SectionHeight=float tableSection高度
//IconRect=rect cell图标区域
//RightRect=rect cell右侧图区域
//TitleRect=rect cell标题区域
//GridLine=imagename cell分隔图
//Background=imagename cell底图

@protocol tztUITableListViewDelegate;

/**
 *    @author yinjp, 15-01-29 15:01:42
 *
 *    @brief  菜单列表控件view
 */
@interface tztUITableListView:UIView<UITableViewDelegate, UITableViewDataSource,tztUITableListSectionViewDelegate>
{
    UITableView* _tableview;
    NSMutableArray* _aylist;
    NSMutableDictionary* _tableproperty;
    id _tztdelegate;
    BOOL _bExpandALL;
    BOOL _bLocalTitle;
    TZTOutLineData *_tztOutlineData;           //对应数据接口
    NSString *_nsSelectedTitle;
    @private
    CGFloat _sectionheight;
    BOOL _bRound;
    NSString    *_nsHiddenMenuID;
    BOOL _isMarketMenu;
}
/**
 *    @author yinjp, 15-01-29 15:01:00
 *
 *    @brief  代理
 */
@property (nonatomic,assign) id<tztUITableListViewDelegate>tztdelegate;
/**
 *    @author yinjp, 15-01-29 15:01:08
 *
 *    @brief  表格属性，从配置文件中读取，字典形式
 */
@property (nonatomic,retain) NSMutableDictionary* tableproperty;
/**
 *    @author yinjp, 15-01-29 15:01:26
 *
 *    @brief  需要隐藏得菜单id
 */
@property (nonatomic,retain) NSString* nsHiddenMenuID;
/**
 *    @author yinjp, 15-01-29 15:01:36
 *
 *    @brief  选中得标题
 */
@property (nonatomic,retain) NSString* nsSelectedTitle;
/**
 *    @author yinjp, 15-01-29 15:01:46
 *
 *    @brief  显示得表格view
 */
@property (nonatomic,retain) UITableView* tableview;
/**
 *    @author yinjp, 15-01-29 15:01:53
 *
 *    @brief  是否圆角显示，默认TRUE
 */
@property (nonatomic,assign) BOOL bRound;
/**
 *    @author yinjp, 15-01-29 15:01:05
 *
 *    @brief  是否展开所有，默认TRUE
 */
@property BOOL bExpandALL;
/**
 *    @author yinjp, 15-01-29 15:01:14
 *
 *    @brief  是否使用本地化统一标题文字
 */
@property BOOL bLocalTitle;
/**
 *    @author yinjp, 15-01-29 15:01:29
 *
 *    @brief  是否是市场行情菜单
 */
@property BOOL isMarketMenu; // 是否是市场行情菜单
/**
 *    @author yinjp, 15-01-29 15:01:37
 *
 *    @brief  固定背景色
 */
@property (nonatomic)int nFixBackColor;
/**
 *    @author yinjp, 15-01-29 15:01:43
 *
 *    @brief  需要隐藏得菜单数据
 */
@property (nonatomic,retain) NSMutableArray *ayHiddenList;//需要隐藏的菜单数据

/**
 *    @author yinjp
 *
 *    @brief  设置表格圆角大小
 *
 *    @param cornerRadius 圆角大小
 */
- (void)setTableCornerRadius:(CGFloat)cornerRadius;

/**
 *    @author yinjp
 *
 *    @brief  重新刷新加载表格数据
 */
- (void)reloadData;

/**
 *    @author yinjp
 *
 *    @brief  设置表格数据
 *
 *    @param ayListInfo 数据数组
 */
- (void)setAyListInfo:(NSArray *)ayListInfo;

/**
 *    @author yinjp
 *
 *    @brief  设置配置文件数据
 *
 *    @param strfile  配置文件
 *    @param listname 需要制定显示得某段key值
 */
- (void)setPlistfile:(NSString*)strfile listname:(NSString*)listname;//配置文件 列表

/**
 *    @author yinjp
 *
 *    @brief  设置界面类型
 *
 *    @param MsgType 界面类型
 */
-(void)SetMsgType:(NSInteger)MsgType;
-(void)CancelSelectedWithID:(NSInteger)nMsgType;
/**
 *    @author yinjp
 *
 *    @brief  解析tztMarketMenu byDBQ20131017
 *
 *    @param nsName nsName
 */
- (void)setMarketMenu:(NSString*)nsName;

@end

/**
 *    @author yinjp
 *
 *    @brief  表格操作协议
 */
@protocol tztUITableListViewDelegate <NSObject>
@optional
-(BOOL)tztUITableListView:(tztUITableListView*)tableView withMsgType:(NSInteger)nMsgType withMsgValue:(NSString*)strMsgValue;
-(void)tztUITableListView:(tztUITableListView*)tableView didSelectCell:(tztUITableListInfo*)cellinfo;
-(void)tztUITableListView:(tztUITableListView*)tableView didSelectSection:(tztUITableListInfo*)sectioninfo;
// 点击行情列表委托
-(void)DealWithMenu:(NSInteger)nMsgType nsParam_:(NSString*)nsParam pAy_:(NSArray*)pAy;
@end