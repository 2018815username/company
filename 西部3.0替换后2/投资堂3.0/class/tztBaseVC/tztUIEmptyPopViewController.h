/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:        弹出式vc基类，设置对应的showView即可用于不同的弹出显示
 * 文件标识:        
 * 摘要说明:        
 * 
 * 当前版本:        2.0
 * 作    者:       yinjp
 * 更新日期:            
 * 整理修改:	
 *
 ***************************************************************/

#import "TZTUIBaseViewController.h"

@interface tztUIEmptyPopViewController : UIViewController
{
    //弹出显示大小
    CGSize      _szPopSize;
    //页面ID，与功能号对应
    int         _nPageID;
    //需要显示的view
    TZTUIBaseView   *_pShowView;
    //是否要全屏展示
    int         _nFullScreen;
}

@property (nonatomic) CGSize szPopSize;
@property (nonatomic) int    nPageID;
@property (nonatomic, retain) TZTUIBaseView *pShowView;
@property (nonatomic) int    nFullScreen;

@end
