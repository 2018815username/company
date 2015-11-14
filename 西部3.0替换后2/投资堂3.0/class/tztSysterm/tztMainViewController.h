//
//  tztMainViewController.h
//  tztMobileApp_HTSC
//
//  Created by yangares on 13-8-21.
//
//

#import <UIKit/UIKit.h>

#import "tztUIBaseVCMsg.h"
//#import "tztUIBaseVCOtherMsg.h"

@interface tztMainViewController : UIViewController
{
    TZTPageInfoItem* _pPageInfoItem;
    int _nItemIndex;
}
@property (nonatomic,retain) TZTPageInfoItem* pPageInfoItem;
@property int nItemIndex;

//创建viewController
+ (NSMutableArray*)makeTabBarViewController;
+ (UIViewController*)GetTabBarViewController:(NSInteger)nType wParam_:(NSUInteger)wParam lParam_:(NSUInteger)lParam;
+ (void)addViewController:(TZTPageInfoItem *)pItem withNav:(UINavigationController *)viewController;

//设置选中NavController
+(void)didSelectNavController:(int)nVcKind options_:(NSMutableDictionary *)options;

+ (tztUINavigationController*)getNavController:(int)nVcKind;
@end
