/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:
 * 文件标识:
 * 摘要说明:    自选股表Cell
 *
 * 当前版本:
 * 作    者:       DBQ
 * 更新日期:
 * 整理修改:
 *
 ***************************************************************/

#import <UIKit/UIKit.h>

@class TZTUserStockTableViewCell;

typedef enum {
    kCellStateCenter,
    kCellStateLeft,
    kCellStateRight
} SWCellState;

@protocol SWTableViewCellDelegate <NSObject>

@optional
- (void)swippableTableViewCell:(TZTUserStockTableViewCell *)cell didTriggerLeftUtilityButtonWithIndex:(NSInteger)index;
- (void)swippableTableViewCell:(TZTUserStockTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index;
- (void)swippableTableViewCell:(TZTUserStockTableViewCell *)cell scrollingToState:(SWCellState)state;
- (void)HiddenQuickSell:(TZTUserStockTableViewCell *)cell;
@end

@interface TZTUserStockTableViewCell : UITableViewCell
{
    SWCellState _cellState; // The state of the cell within the scroll view, can be left, right or middle
}

@property (nonatomic, assign)id     tztDelegate;
@property (nonatomic, assign)BOOL     bRank;
@property (nonatomic, assign)NSString*    nsSection;
@property (nonatomic, assign)BOOL     bUserStock;

@property (nonatomic, assign)SWCellState cellState;;

@property (nonatomic, strong) NSArray *leftUtilityButtons;
@property (nonatomic, strong) NSArray *rightUtilityButtons;
@property (nonatomic, assign) id <SWTableViewCellDelegate> delegate;
@property (nonatomic)NSInteger nRowIndex;
@property (nonatomic)NSInteger nColCount;

-(void)setShowColKeys:(NSArray*)ayKeys;
-(void)setCellContent:(NSDictionary*)dict nsKey_:(NSString*)nsKey;
-(void)setContent:(NSMutableDictionary *)pData;
//-(void)setContentEx:(NSMutableDictionary *)pData WithKeys:(NSArray*)ayKeys;

//- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier containingTableView:(UITableView *)containingTableView leftUtilityButtons:(NSArray *)leftUtilityButtons rightUtilityButtons:(NSArray *)rightUtilityButtons nColCount_:(NSInteger)nCount;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier containingTableView:(UITableView *)containingTableView leftUtilityButtons:(NSArray *)leftUtilityButtons rightUtilityButtons:(NSArray *)rightUtilityButtons ayColKeys_:(NSMutableArray*)ayColKeys bUseSep_:(BOOL)bUseSep;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier containingTableView:(UITableView *)containingTableView leftUtilityButtons:(NSArray *)leftUtilityButtons rightUtilityButtons:(NSArray *)rightUtilityButtons ayColKeys_:(NSMutableArray*)ayColKeys;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier containingTableView:(UITableView *)containingTableView leftUtilityButtons:(NSArray *)leftUtilityButtons rightUtilityButtons:(NSArray *)rightUtilityButtons;

- (void)setBackgroundColor:(UIColor *)backgroundColor;
- (void)hideUtilityButtonsAnimated:(BOOL)animated;
- (void)HiddenQuickSell:(TZTUserStockTableViewCell *)cell;
- (BOOL)CancelQuickSellShow;
- (void)CancelSelected;
@end

@interface NSMutableArray(SWUtilityButtonView)
//@property(nonatomic,retain)NSString* nsImageName;
- (void)addUtilityButtonWithColor:(UIColor *)color title:(NSString *)title;
- (void)addUtilityButtonWithColor:(UIColor *)color icon:(NSString*)imageName;

@end
