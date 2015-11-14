/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:        个股查询view(iphone)
 * 文件标识:        
 * 摘要说明:        
 * 
 * 当前版本:        2.0
 * 作    者:       yinjp
 * 更新日期:            
 * 整理修改:	
 *
 ***************************************************************/

#define tztTableCellCodeTag 0x1111
#define tztTableCellBtnTag  0x2222
#define tztTableCellUserStockTag 2048
@interface tztUISearchStockTableCell : UITableViewCell
{
    NSInteger _nBtnTag;
}
@property NSInteger nBtnTag;
@property NSInteger nRowIndex;

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier nTag_:(NSInteger)nTag target_:(id)target action_:(SEL)action;

-(void)SetContentText:(tztStockInfo*)pStock;

-(void)SetContentTextColor:(UIColor*)nFirstCL sceondColor:(UIColor*)nSecondCL;

@end

@interface tztUISearchStockView : tztHqBaseView<UITableViewDataSource, UITableViewDelegate>
{
    tztUIVCBaseView         *_searchView;
    UITableView             *_pContentView;
    NSMutableArray          *_pStockArray;
    
    UILabel                 *_pLabel;
    
    BOOL                    _bShowSearchView;
    NSString                *_nsURL;
    UIColor                 *_clBackColor;
}
@property(nonatomic, retain)tztUIVCBaseView     *searchView;
@property(nonatomic, retain)UITableView         *pContentView;
@property(nonatomic, retain)NSMutableArray      *pStockArray;
@property(nonatomic, retain)UILabel             *pLabel;
@property(nonatomic, retain)NSString            *nsURL;
@property(nonatomic)BOOL                        bShowSearchView;
@property(nonatomic, retain)UIColor             *clBackColor;

-(void)RequestStock:(NSString*)strCode;
@end
