//
//  tztUITableListCellView.h
//  tztMobileApp
//
//  Created by yangares on 13-4-25.
//
//

#import <UIKit/UIKit.h>
#import "tztUITableListInfo.h"

@protocol tztUITableListSectionViewDelegate;
//Indentation=float 偏移量
//CellMargin=float 间隔量
//IconRect=x,y,w,h Icon区域
//RightRect=x,y,w,h Right区域
//TitleRect=x,y,w,h Title区域
//GridLine=imagename LineImage 为空 则为默认间隔色 不配置 则无间隔。
//Background=imagename backgroundImage 为空 则为默认底色
//BackBlackColor=底色是否黑色 默认为1
/**
 *  自定义cell， tztUITableListCellView对象
 */
@interface tztUITableListCellView :UITableViewCell
{
    UIImageView* _iconimageview;
    UILabel* _titleLabel;
    UIImageView* _rightimageview;
    UIImageView* _backgroundimageview;
    UIView *_gridLine;
    NSMutableDictionary* _cellproperty;
    NSMutableDictionary* _cellinfo;
    
    BOOL _bBackBlackColor;
    BOOL _opened;
}
/**
 *  属性字典
 */
@property (nonatomic, retain) NSMutableDictionary* cellproperty;
/**
 *  黑色背景
 */
@property  BOOL bBackBlackColor;
/**
 * 是否展开
 */
@property  BOOL opened;
/**
 *  1-行情 other＝交易
 */
@property  int  nType;

/**
 *  设置cell数据显示
 *
 *  @param strTitle 显示文字
 *  @param strIcon  左侧图片
 *  @param strRight 右侧图片
 *  @param info     具体信息，见tztUITableListInfo定义
 */
- (void)setCellInfo:(NSString*)strTitle Icon:(NSString*)strIcon Right:(NSString*)strRight Info:(tztUITableListInfo*)info;
@end

/**
 *  自定义section tztUITableListSectionView对象
 */
@interface tztUITableListSectionView : UIView
{
    tztUITableListCellView* _cellview;
    NSInteger _section;
    BOOL _opened;
    id _tztdelegate;
    tztUITableListInfo* _tableinfo;
}
/**
 *  对应section索引
 */
@property (nonatomic, assign) NSInteger section;
/**
 *  数否展开
 */
@property (nonatomic, assign) BOOL opened;
/**
 *  代理
 */
@property (nonatomic, assign) id <tztUITableListSectionViewDelegate> tztdelegate;
/**
 *  cell数据信息对象，见tztUITableListInfo说明
 */
@property (nonatomic, retain) tztUITableListInfo* tableinfo;
/**
 *  cellview
 */
@property (nonatomic, retain) tztUITableListCellView* cellview;

/**
 *  1-行情 other＝交易
 */
@property int nType;

/**
 *  初始化创建sectonview
 *
 *  @param frame 显示区域
 *  @param nType 类型，见上面nType定义
 *
 *  @return tztUITableListSectionView对象
 */
- (id)initWithFrame:(CGRect)frame andType:(int)nType;

/**
 *  初始化创建sectionview
 *
 *  @param frame 显示区域
 *
 *  @return tztUITableListSectionView对象
 */
- (id)initWithFrame:(CGRect)frame;

/**
 *  设置sectionview对应属性
 *
 *  @param property 属性字典
 */
- (void)setSectionProperty:(NSMutableDictionary*)property;

/**
 *  设置数据
 *
 *  @param listinfo      数据对象
 *  @param sectionNumber section索引
 *  @param tztdelegate   代理
 */
- (void)setListInfo:(tztUITableListInfo*)listinfo section:(NSInteger)sectionNumber delegate:(id<tztUITableListSectionViewDelegate>)tztdelegate;
@end

/**
 *  tztUITableListSectionView协议声明
 */
@protocol tztUITableListSectionViewDelegate <NSObject>
@optional
/**
 *  关闭section显示
 *
 *  @param sectionHeaderView tztUITableListSectionView对象
 *  @param section           对应section索引
 */
-(void)sectionHeaderView:(tztUITableListSectionView*)sectionHeaderView sectionClosed:(NSInteger)section;

/**
 *  打开section显示
 *
 *  @param sectionHeaderView tztUITableListSectionView对象
 *  @param section           对应section索引
 */
-(void)sectionHeaderView:(tztUITableListSectionView*)sectionHeaderView sectionOpened:(NSInteger)section;
@end
