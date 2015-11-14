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

#define tztTableCellMarketTag 0x1110
#define tztTableCellCodeTag 0x1111
#define tztTableCellBtnTag  0x2222
#define tztTableCellUserStockTag 2048
@interface tztUISearchStockTableCellEx : UITableViewCell
{
    NSInteger     _nBtnTag;
    BOOL    _bHidenAddBtn;
}
@property NSInteger nBtnTag;
@property BOOL bHidenAddBtn;
@property NSInteger nRowIndex;

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier nTag_:(NSInteger)nTag target_:(id)target action_:(SEL)action bHideAddBtn_:(BOOL)bHide;

-(void)SetContentText:(tztStockInfo*)pStock;

-(void)SetContentTextColor:(UIColor*)nFirstCL sceondColor:(UIColor*)nSecondCL;

@end

@interface tztUISearchStockViewEx : tztHqBaseView<UITableViewDataSource, UITableViewDelegate>
{
    tztUISwitch             *_pBtnHotSearch;
    tztUISwitch             *_pBtnHisSearch;
    UITableView             *_pContentView;
    NSMutableArray          *_pStockArray;
    
    NSMutableArray          *_pStockInfoData;
    
    NSString                *_nsURL;
    BOOL                    _bHidenAddBtn;
    BOOL                    _bHidenSwitch;
    
}

@property(nonatomic, retain)tztUISwitch         *pBtnHotSearch;
@property(nonatomic, retain)tztUISwitch         *pBtnHisSearch;
@property(nonatomic, retain)UITableView         *pContentView;
@property(nonatomic, retain)NSMutableArray      *pStockArray;
@property(nonatomic, retain)NSMutableArray      *pStockInfoData;
@property(nonatomic, retain)NSString            *nsURL;
@property(nonatomic)BOOL                        bHidenAddBtn;

-(void)RequestStock:(NSString*)strCode;
@end
