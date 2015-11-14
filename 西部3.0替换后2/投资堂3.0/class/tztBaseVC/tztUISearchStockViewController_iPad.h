/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:        个股搜索(iPad)
 * 文件标识:        
 * 摘要说明:        iPad个股搜索及自定义键盘
 * 
 * 当前版本:        2.0
 * 作    者:       yinjp
 * 更新日期:            
 * 整理修改:	
 *
 ***************************************************************/
#import "TZTUIBaseViewController.h"

enum
{
    TZTUserKeyBord_Number,      //数字键盘
    TZTUserKeyBord_Character,    //字母键盘
};


@interface tztUISearchStockViewController_iPad : TZTUIBaseViewController<tztSocketDataDelegate,UITableViewDataSource,UITableViewDelegate>
{
    int                 _nKeyBordType;  //键盘类型
    NSMutableArray      *_pAyKeyBord;   //按钮数组
    
    UITableView         *_pContentView; //查询结果表格显示
    NSMutableArray      *_pStockArray;  //数据保存
    CGRect              _showRect;      //显示区域
    UISearchBar         *_pSearchBar;   //搜索框
    NSString            *_nsInputValue; //输入数据记录
}

@property(nonatomic) int nKeyBordType;
@property(nonatomic,retain)NSMutableArray   *pAyKeyBord;
@property(nonatomic,retain)UITableView      *pContentView;
@property(nonatomic,retain)NSMutableArray   *pStockArray;
@property(nonatomic,assign)UISearchBar      *pSearchBar;
@property(nonatomic,retain)NSString         *nsInputValue;
@end
