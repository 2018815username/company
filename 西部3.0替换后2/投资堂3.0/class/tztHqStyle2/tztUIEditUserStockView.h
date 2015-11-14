/*******************************************************************************
 * Copyright (c)2012, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称：    tztUIEditUserStockView
 * 文件标识：
 * 摘    要：   自选股编辑界面
 *
 * 当前版本：    1.0
 * 作    者：   yinjp
 * 完成日期：    2012-12-05
 *
 * 备    注：
 *
 * 修改记录：
 *
 *******************************************************************************/

@interface tztUIEditUserStockCell : UITableViewCell
{
    BOOL    _bSort;
    NSInteger     _nBtnTag;
    NSInteger     _nDelBtnTag;
}
@property(nonatomic)NSInteger nBtnTag;
@property(nonatomic)NSInteger nDelBtnTag;
@property(nonatomic)BOOL bSort;
@property(nonatomic)int nStockType;
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier nTag_:(NSInteger)nTag target_:(id)target action_:(SEL)action actionDel_:(SEL)actionDel sort_:(BOOL)sort;
-(void)SetContentText:(NSString*)first second_:(NSString*)second andStockType:(int)nStockType;
@end

@interface tztUIEditUserStockView : tztHqBaseView<UITableViewDataSource,UITableViewDelegate>
{
    UITableView     *_pTableView;
    NSMutableArray  *_pAyStockList;
    BOOL            _bUserStockChanged;
    BOOL            _bSort;
}

@property(nonatomic, retain)UITableView     *pTableView;
@property(nonatomic, retain)NSMutableArray  *pAyStockList;
@property(nonatomic)BOOL                    bSort;

-(void)LoadUserStock;
-(void)SaveUserStock;
@end
