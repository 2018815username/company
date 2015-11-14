/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:        标题view
 * 文件标识:        100000 
 * 摘要说明:        
 * 
 * 当前版本:        2.0
 * 作    者:       yinjp
 * 更新日期:            
 * 整理修改:	
 *
 ***************************************************************/

#import "TZTUIBaseView.h"
#define TZTTitleBtnReturn 0x1110
#define TZTTitleLabelTag 0x1111
#define TZTTitleStockTag 0x1112
#define TZTTitleBtnFull  0x1113
#define TZTTitleBtnPre   0x1114
#define TZTTitleBtnNext  0x1115
#define TZTTitleBtnEdit  0x1116
#define TZTTitleBtnSearch 0x1117
#define TZTTitleBtnClose  0x1118
enum TZTUITitleItem
{
    TZTTitleReturn = 0x0001,  //返回
    TZTTitleLogo = 0x0002,    //图标
    TZTTitleEdit = 0x0004,    //编辑
    TZTTitleMarket = 0x0008,
//    TZTTitleFull = 0x0008,    //全屏
  
//    TZTTitleFull = 0x0040,     //全屏
    TZTTitleFull = 0x10000,    //全屏
    
    TZTTitlePreNext = 0x0010, //前 ＋ 后
    TZTTitleExpress = 0x0020, //快递 + 清空
    TZTTitleEditor = 0x0040,    //自选编辑按钮
    
    TZTTitleSearch  = 0x0100, //搜索
    TZTTitleAddBtn     = 0x0200, //增加
    TZTTitleUser  = 0x0300,//国泰使用又上角用户信息
    
    TZTTitleSetBtn     = 0x0400,//右侧设置按钮
    TZTTitleDKRYBtn    = 0x500, // 右侧多空如弈功能按钮
    TZTTitleClose    = 0x0800, //关闭
    TZTTitleBack = TZTTitleClose,//右侧返回
    
    TZTTitleNormal = 0x1000, //通用
    TZTTitleStock = 0x2000,  //股票
    TZTTitleImage = 0x4000, //使用背景图
};

enum TZTUITitleType 
{
    
    TZTTitleReportMarket = TZTTitleMarket | TZTTitleSearch,
    TZTTitleReport = TZTTitleReturn | TZTTitleSearch ,  //排名列表时标题
    TZTTitleDetail = TZTTitleReturn | TZTTitleStock | TZTTitlePreNext | TZTTitleSearch,      //个股详情时标题
    TZTTitleDetail_User = TZTTitleEdit | TZTTitleSearch, //自选带编辑按钮
    TZTTitleName = TZTTitleReturn | TZTTitleSearch,        //只是显示名称，如交易、资讯、服务中心等
    TZTTitleIcon = TZTTitleLogo  | TZTTitleSearch,        //首页左侧是图标
    TZTTitleAdd = TZTTitleReturn | TZTTitleAddBtn,         //右侧是增加服务器地址按钮
    TZTTitlePic = TZTTitleImage,
    TZTTitleHomePage = TZTTitleImage|TZTTitleSearch,
    TZTTitleSetButton  = TZTTitleReturn|TZTTitleSetBtn,//左侧返回，右边设置
    TZTTitleUserInfo = TZTTitleReturn|TZTTitleUser,//国泰使用又上角用户信息
    TZTTitleUserStock = TZTTitleReturn|TZTTitleEditor|TZTTitleSearch,
    
    TZTTitleDetail_iPad_User = TZTTitleEdit |TZTTitleStock | TZTTitleFull| TZTTitlePreNext| TZTTitleSearch,//iPad自选标题
    TZTTitleReport_iPad = /*TZTTitleLogo |*/ TZTTitleNormal| TZTTitleSearch,   // iPad排名标题
    TZTTitleDetail_iPad = /*TZTTitleLogo |*/ TZTTitleStock | TZTTitleFull| TZTTitlePreNext | TZTTitleSearch, //iPad个股详情标题
    TZTTitleNormalAndReturn_iPad = TZTTitleNormal | TZTTitleReturn, //iPad 有标题和返回
    TZTTitleDKRY = TZTTitleReturn | TZTTitleDKRYBtn ,// 多空如弈标题栏

    TZTTitleTrendNew = TZTTitleReturn|TZTTitleStock,
    
};

@protocol tztStockSearchDelegate <NSObject>
@optional
-(void)OnStockSearch;
@end

@interface TZTUIBaseTitleViewOld : TZTUIBaseView<UISearchBarDelegate>
{
    UIButton* _firstBtn;
    
    UIButton* _fullBtn;
    
    UILabel*  _leftTitlelabel;
    
    UIImageView *_imageView;
    
    UILabel*   _titlelabel;
    
    UIButton*  _secondBtn;
    UIButton*  _thirdBtn;
    
    UIButton*  _fourthBtn;
    //搜索框
    UISearchBar *_pSearchBar;
    //标题类型
    
    int         _nType;
    //标题文字
    NSString    *_nsTitle;

    //左侧view的宽度，用于详情标题显示时处理，默认为0
    int         _nLeftViewWidth;
    
    NSString    *_nsStockName;
    
    BOOL        _bShowSearchBar;
    
    //是否有关闭按钮
    BOOL        _bHasCloseBtn;
    
    NSString* _nsType;
}

@property(nonatomic) int   nType;
@property(nonatomic,retain)NSString*    nsTitle;
@property(nonatomic,retain)NSString*    nsStockName;
@property(nonatomic,retain)UISearchBar  *pSearchBar;
@property(nonatomic,retain)UIButton     *firstBtn;
@property(nonatomic,retain)UIButton     *fourthBtn;//外部获取按钮区域大小,东莞地图用到 modify by xyt 20130718
@property(nonatomic,retain)UILabel      *titlelabel;
@property int   nLeftViewWidth;
@property BOOL  bShowSearchBar;
@property BOOL  bHasCloseBtn;
@property (nonatomic,retain) NSString* nsType;

//详情显示时设置股票代码，名称
-(void)setCurrentStockInfo:(NSString*)nsCode nsName_:(NSString*)nsName;
-(void)setTitle:(NSString*)nsTitle;
-(void)setTitleType:(int)nType;
-(void)setTitleType_iPad:(int)nType;
-(void)setStockDetailInfo:(NSInteger)nStockType nStatus:(NSInteger)nStatus;

//-(void)OpenFolder;
@end

