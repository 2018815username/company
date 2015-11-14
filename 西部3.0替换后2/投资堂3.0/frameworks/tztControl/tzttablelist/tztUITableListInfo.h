//
//  tztUITableListInfo.h
//  tztMobileApp
//
//  Created by yangares on 13-4-25.
//
//

#import <Foundation/Foundation.h>
#import "TZTOutLineData.h"

/**
 *  TableListInfo数据对象
 */
@interface tztUITableListInfo:NSObject
{
    BOOL _cellShow;
    BOOL _cellExpand; //是否展开
    int _cellLevel;
    NSString* _cellImageName;
    NSString* _cellTitle;
    NSDictionary* _cellInfo;
    NSMutableArray *_cellayChild;
    BOOL _bSelected;//是否选中
    BOOL _bLocalTitle;//是否使用本地化标题
}
/**
 *  是否显示
 */
@property (assign) BOOL cellShow;

/**
 *  是否为展开
 */
@property (assign) BOOL cellExpand;

/**
 *  展开层级
 */
@property (assign) int  cellLevel;

/**
 *  是否选中
 */
@property (assign) BOOL bSelected;

/**
 *  是否使用本地统一配置的标题
 */
@property (assign) BOOL bLocalTitle;

/**
 *  imagename（此处imagename是图片也是唯一标示）
 */
@property (nonatomic,retain) NSString* cellImageName;
/**
 *  显示文本
 */
@property (nonatomic,retain) NSString* cellTitle;
/**
 *  具体cell信息字典
 */
@property (nonatomic,retain) NSDictionary* cellInfo;
/**
 *  子菜单信息
 */
@property (nonatomic,retain) NSMutableArray* cellayChild;

/**
 *  初始化
 *
 *  @return 返回tztUITableListInfo对象
 */
- (id)init;

- (void)setPlistfile:(NSString*)strfile listValue:(NSString*)strValue;

- (void)setTztTableDictionary:(NSDictionary *)listinfo;

- (void)setAyNSDictionaryChild:(NSMutableArray*)ayChild;
- (void)setAyValueChild:(NSMutableArray*)ayChild;
//获取第index个子节点
- (id)childAtIndex:(NSInteger *)index;
- (int)getShowChildCount:(BOOL)bSelf;
// 处理MarketMenu配置文件数据 byDBQ20131017
- (void)setMarketMenu:(NSDictionary*)pItem from:(TZTOutLineData*)outData;
@end
