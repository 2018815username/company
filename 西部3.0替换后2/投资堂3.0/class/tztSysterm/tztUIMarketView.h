/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:        分类市场显示view（iphone）
 * 文件标识:        
 * 摘要说明:        
 * 
 * 当前版本:        2.0
 * 作    者:       yinjp
 * 更新日期:            
 * 整理修改:	
 *
 ***************************************************************/
#define TZT_MarketView_SP 0// 1-竖屏右侧显示 0-底部横屏显示
@protocol tztUIMarketDelegate <NSObject>

//选中市场
-(void)tztUIMarket:(id)sender DidSelectMarket:(NSDictionary*)pDict marketMenu:(NSDictionary*)pMenu;

@end

@interface tztUIMarketView : TZTUIBaseView<UIScrollViewDelegate>
{
    //
    UIScrollView        *_pScrollView;
    //市场数据数组
    NSMutableArray      *_ayMarketData;
    //
    NSMutableArray      *_ayBtn;
    
    NSInteger                 perBtTag;
    
    NSInteger                 _nWidth;
}
@property(nonatomic,retain)UIScrollView     *pSrcollView;
@property(nonatomic,retain)NSMutableArray   *ayMarketData;
@property(nonatomic,retain)NSMutableArray   *ayBtn;
@property(nonatomic) NSInteger                     nWidth;
@property(nonatomic,retain)NSString *nsCurSel;

//设置数据
-(void)SetMarketData:(NSMutableDictionary*)ayData;
//设置选中按钮
-(int)setSelBtIndex:(NSString*)nsData;
//设置按钮背景
-(void)setBtHImage:(UIButton *)pBtn;
//
-(void)OnDefaultMenu:(NSInteger)nIndex;

-(CGSize) sizeToContent:(NSString *)theContent;
@end
