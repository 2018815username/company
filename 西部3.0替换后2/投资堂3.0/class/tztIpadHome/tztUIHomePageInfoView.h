/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:        首页-资讯界面
 * 文件标识:        
 * 摘要说明:        
 * 
 * 当前版本:        2.0
 * 作    者:       zhangxl
 * 更新日期:            
 * 整理修改:	
 *
 ***************************************************************/
#import "tztInfoBase.h"
@interface tztUIInfoView :UIView
{
    UILabel		*_pTitle;
	UILabel		*_pContent;
	UIButton	*_pBtContent;
    tztInfoItem *_pItem;
}
@end

typedef enum
{
	InfoEGOOPullRefreshLoadingUp = 0,
	InfoEGOOPullRefreshPullingUp,
	InfoEGOOPullRefreshNormalUp,
	InfoEGOOPullRefreshNormalDown,
	InfoEGOOPullRefreshPullingDown,
	InfoEGOOPullRefreshLoadingDown,
} InfoEGOPullRefreshState;

@interface tztUIHomePageInfoView : TZTUIBaseView<tztInfoDelegate>
{
     UIImageView *           _pImageBG;//背景图片
    
    UILabel			*_pTitle;	//标题
	NSMutableArray	*_pInfoArray;		//内容存放
	NSMutableArray  *_pViewArray;	//界面存放
	UIView			*_pContentView;//数据显示View
	
	float	_fContentHeight;//界面总高度
	float	_fContentWidth; //界面总宽度
	float	_fCellHeigth;	 //单个view高度
	float   _fCellWidth;	 //单个view宽度
	
	UIScrollView		*_pScorllInfoView;
	UILabel				*_pBackPage;
	UILabel				*_pNextPage;
	CALayer				*_pArrowImageUP;
	CALayer				*_pArrowImageDown;
	
    tztInfoBase         *_pInfoBase;
	InfoEGOPullRefreshState _nState;
}
-(void) setState:(int)aState;
-(void) SetInfoViewValue;
-(void) OnReflush;
@end
