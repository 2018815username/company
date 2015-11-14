//
//  TZTUIBaseTabBarViewController.h
//  IPAD-Table
//
//  Created by Dai Shouwei on 10-12-17.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPRevealSideViewController.h"
#import "tzt_ht_zl_LeftViewController.h"

@interface TZTUIBaseTabBarViewController : UITabBarController<UITabBarControllerDelegate, UIPopoverControllerDelegate, TZTUIToolBarViewDelegate, PPRevealSideViewControllerDelegate, UIGestureRecognizerDelegate, UITabBarDelegate>
{
	int			maxDisplay;			//最大可显示的个数（配置文件可配置）
	int			moreItemIndex;		//更多按钮索引
    
    TZTUITabBarItem *moreItem;
	NSMutableArray *ayMoreItems;	//更多包含的item
	
	//Pop 管理类
	UIPopoverController *popoverVC;
	BOOL		m_bMoreItemVC;		//是否是更多
    
    TZTUIToolBarView    *m_pToolBarView;
    
    UIViewController *_CurrentVC;
    
    NSMutableArray  *_aySelectIndex;//
    
    int             _nDefaultIndex;
    
    tztUINavigationController          *_pLeftNav;
    tztUINavigationController          *_pRightNav;
    tzt_ht_zl_LeftViewController    *_leftVC;
    tzt_ht_zl_LeftViewController    *_rightVC;
    NSMutableArray                  *_ayViews;
}

@property	int			maxDisplay;
@property(nonatomic,retain)	TZTUITabBarItem *moreItem;
@property(nonatomic,retain)	NSMutableArray *ayMoreItems;
@property(nonatomic,retain) TZTUIToolBarView *m_pToolBarView;
@property(nonatomic,retain) UIViewController *CurrentVC;
@property(nonatomic,retain) NSMutableArray   *aySelectIndex;
@property int nDefaultIndex;
@property(nonatomic,retain) NSMutableArray               *ayViews;

@property(nonatomic,retain) tztUINavigationController       *pLeftNav;
@property(nonatomic,retain) tztUINavigationController       *pRightNav;
@property(nonatomic,retain) tzt_ht_zl_LeftViewController *leftVC;
@property(nonatomic,retain) tzt_ht_zl_LeftViewController *rightVC;

-(void)ShowLeftVC;
-(void)ShowRightVC;
-(void)RefreshAddCustomsViews;
-(void)LoadWebURL:(NSString*)strURL bLeft_:(BOOL)bleft;

-(void)LayoutTabBarItem;
-(void)OnSelectDefault;

-(void)didSelectItemByPageType:(int)nType options_:(NSDictionary*)options;
-(void)didSelectItemByIndex:(int)nIndex options_:(NSDictionary*)options;
-(UIViewController*)GetTopViewController;
-(void)initSideViewController;
@end

extern TZTUIBaseTabBarViewController *g_tabBar;
