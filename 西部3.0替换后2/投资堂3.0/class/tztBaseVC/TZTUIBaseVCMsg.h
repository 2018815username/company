
#import <Foundation/Foundation.h>

extern NSTimer			*g_pJYLockTimer;

@interface TZTUIBaseVCMsg : NSObject 
{
 
}
+(void) OnMsg:(NSInteger)nMsgType wParam:(NSUInteger)wParam lParam:(NSUInteger)lParam;
+(BOOL) OnTradeFundMsg:(NSInteger)nMsgType wParam:(NSUInteger)wParam lParam:(NSUInteger)lParam;

+(void) StarProcess;
+(void) StopProcess;

//IPAD 需要回调
+(BOOL) SystermLogin:(NSInteger)nMsgType wParam:(NSUInteger)wParam lParam:(NSUInteger)lParam delegate:(id)delegate isServer:(BOOL)bServer;
+(BOOL) SystermLogin:(NSInteger)nMsgType wParam:(NSUInteger)wParam lParam:(NSUInteger)lParam;

+(BOOL) tztTradeLogin:(NSInteger)nMsgType wParam:(NSUInteger)wParam lParam:(NSUInteger)lParam lLoginType:(NSUInteger)lLoginType delegate:(id)delegate;
+(BOOL) tztTradeLogin:(NSInteger)nMsgType wParam:(NSUInteger)wParam lParam:(NSUInteger)lParam lLoginType:(NSUInteger)lLoginType;
+(BOOL) tztTradeLogin:(NSInteger)nMsgType wParam:(NSUInteger)wParam lParam:(NSUInteger)lParam;


+(void) SetLock;

+(void) IPadPushViewController:(UIViewController*)pBottomVC pop:(UIViewController*)pPop;
+(void) IPadPopViewController:(UIViewController*)pBottomVC bUseAnima_:(BOOL)animation;
+(void) IPadPopViewControllerEx:(UIViewController*)pBottomVC bUseAnima_:(BOOL)animation completion:(void (^)(void))completion;
+(void) IPadPopViewController:(UIViewController*)pBottomVC;
+(void) IPadPopViewController:(UIViewController*)pBottomVC completion:(void(^)(void))completion;

+(UIViewController*)CheckCurrentViewContrllers:(Class)vcClass;
//
/*
 根据页面获取显示标题
 nMsgType   - 页面ID
 bFullName  - 1-返回是全称
 */
@end


@interface NSDictionary (TZTPrivate)

+(NSDictionary*)GetDictFromParam:(NSString*)nsData;

@end