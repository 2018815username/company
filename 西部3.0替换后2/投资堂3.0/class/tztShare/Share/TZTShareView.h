

#import <UIKit/UIKit.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import "WeiboApi.h"
#import "WXApi.h"


 /**
 *	@brief	分享按钮
 */
@class TZTShareButton;

typedef enum
{
	TZTShareTypeSinaWeibo = 1, /**< 新浪微博 */
	TZTShareTypeTencentWeibo = 2, /**< 腾讯微博 */
	
	TZTShareTypeQQSpace = 3, /**< QQ空间 */
	
    TZTShareTypeWeixiSession = 4, /**< 微信好友 */
	TZTShareTypeWeixiTimeline = 5, /**< 微信朋友圈 */
    TZTShareTypeQQ = 6, /**< QQ */
    
    SSCShareTypeAny = 99   /**< 任意平台 */
}
TZTShareType;

@protocol shareDelegate <NSObject>

@optional
- (void)share2TCWeiboPic;
- (void)share2QQZone;
- (void)share2Weibo;
- (void)sendWeixinAppContentwithScene:(int)scene;
- (void)sendQQNewsMessage;

@end

//typedef void(^ShareBtnHandler)(TZTShareButton *btnView);

@interface TZTShareButton : UIButton

@property (nonatomic, copy) NSString *text;
@property (nonatomic, retain) UIImage *image;
@property (nonatomic, assign) int tztShareType;
@property (nonatomic, assign) id<shareDelegate> shareDelegate;

- (id)initWithText:(NSString *)text image:(UIImage *)image;
- (void) setShareInfo:(NSMutableDictionary*)pDictInfo;
@end

@interface TZTShareView : UIView<TencentSessionDelegate, WXApiDelegate, shareDelegate>

@property (nonatomic, copy) NSString *title;
// 将要显示在该视图上
@property (nonatomic, retain) UIView *referView;
// 黑色背景
@property (nonatomic, retain) UIButton *blackBtn;
// 将要显示在该视图上
@property (nonatomic, retain) UIView *shareWhiteView;

@property (nonatomic, retain) NSMutableArray *btnArray;

@property (nonatomic, retain) NSMutableDictionary *pDictInfo;

@property (nonatomic , retain) WeiboApi                    *wbapi;//微博
@property (nonatomic , retain) TencentOAuth                *tencentOAuth;//腾讯
//初始化
- (id)initWithTitle:(NSString *)title referView:(UIView *)referView;
- (void)showShareView;
- (void)shareWhiteViewAdd:(UIButton *)btn;
- (void)initShareWhiteView;
- (void) setShareInfo:(NSMutableDictionary*)pDict;

@end
