/*******************************************************************************
 * Copyright (c)2012, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称：NSObject+TZTPrivate.h
 * 文件标识：
 * 摘    要：自定义拓展函数
 *
 * 当前版本：
 * 作    者：yangdl
 * 完成日期：2012.12.12
 *
 * 备    注：
 *
 * 修改记录：
 * 
 *******************************************************************************/

#import <Foundation/Foundation.h>

#define tztLogMobile @"com.tzt.logmobile"
#define tztLogPass @"com.tzt.logpass"

#define tztUniqueID  @"com.tzt.uniqueid"
#define tztPID       @"com.tzt.pid"

#pragma mark -NSObject扩展
@interface NSObject (tztPrivate)
- (id)tztperformSelector:(NSString *)aSelectorName;
- (id)tztperformSelector:(NSString *)aSelectorName withObject:(id)object;
- (id)tztperformSelector:(NSString *)aSelectorName withObject:(id)object1 withObject:(id)object2;
@end

#pragma mark -NSData扩展
@interface NSData (tztPrivate)
/**加密，对data进行加密，并返回加密后数据*/
+ (NSData *)tztencodeddata:(NSData *)data;
/**解密，对data进行解密，并返回解密后数据*/
+ (NSData *)tztdecodeddata:(const char *)data length:(NSUInteger)nLength;
@end

#pragma mark -NSMutableDictionary扩展
@interface NSMutableDictionary (tztPrivate)
- (void)removeTztObjectForKey:(id)aKey;
- (void)setObject:(id)anObject forUpperKey:(id)aKey;
- (void)setValue:(id)anObject forUpperKey:(id)aKey;
- (void)setTztValue:(id)value forKey:(NSString *)key;
- (void)setTztObject:(id)anObject forKey:(id)aKey;
- (void)settztProperty:(NSString*)strproperty;
- (NSString*)gettztProperty;
@end

#pragma mark -NSDictionary扩展
@interface NSDictionary (tztPrivate)
- (id)tztObjectForKey:(id)aKey;
- (id)tztValueForKey:(NSString *)key;
- (id)tztValuedefault:(NSString*)value forKey:(NSString *)key;
@end

#pragma mark -NSMutableArray扩展
@interface NSMutableArray(tztPrivate)
- (void)appendstrArray:(NSArray *)otherArray;
- (void)moveObjectFromIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex;
@end

#pragma mark -NSDate扩展
@interface NSDate(tztPrivate)
+ (NSTimeInterval)timeIntervalSinceToday;
@end

#if TARGET_OS_IPHONE
extern NSMutableArray *g_ayPushedViewController;
#pragma mark -自定义tztUINavigationController
@interface tztUINavigationController : UINavigationController
{
    BOOL            transiting;
}
@property int nPageID;
- (id)initWithRootViewController:(UIViewController *)rootViewController;
- (NSArray*)popToRootViewControllerAnimated:(BOOL)animated;
- (UIViewController*)popViewControllerAnimated:(BOOL)animated;
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated;
@end

#define tztVcShowTypeRoot (-3) //是Root
#define tztVcShowTypeSame (-2) //所有都相同
#define tztVcShowTypeDif  (-1) //所有都不相同

#pragma mark -UIViewController扩展
@interface UIViewController(tztPrivate)
- (void)setVcShowType:(NSString*)nShowType;
- (void)setVcShowKind:(int)nShowKind;
- (NSString*)getVcShowType;
- (int)getVcShowKind;
- (BOOL)isKindofVcKind:(int)nVcKind VcType:(NSString*)nVcType;
/**获取交易登录标志*/
- (int)getTztTradeLoginSign;
/**设置交易登录标志，根据TradeAccountType＋1*/
- (void)setTztTradeLoginSign:(int)nNeedLogin;
-(void)SetToolbarHiddens:(BOOL)bHide;
-(void)SetHidesBottomBarWhenPushed:(BOOL)bHiden;
@end

#pragma mark -UIColor扩展
@interface UIColor (tztPrivate)
/**char数值转颜色*/
+ (UIColor *)colorWithChar:(char)RGB;
/**数值转颜色 如 0xFFFFFF*/
+ (UIColor *)colorWithRGBULong:(unsigned long)RGB;
/**取RGB对应值的反色*/
+ (UIColor *)colorXORWithTztRGBStr:(NSString *)RGB;
/**字符串转颜色 如"255,255,255,0.9",最后一位是透明度*/
+ (UIColor *)colorWithTztRGBStr:(NSString *)RGB;
/**获取UIColor的r，g，b*/
- (BOOL)getTztRed:(CGFloat *)red green:(CGFloat *)green blue:(CGFloat *)blue alpha:(CGFloat *)alpha;
/**取UIColor的反色*/
+ (UIColor *)colorXORUIColor:(UIColor*)color;
/**UIColor转换成unsigned long 颜色值转数值*/
- (unsigned long)colorToRGBULong;
/**UIColor转成NSString，颜色值转字符串*/
- (NSString*)colorToRGBStr;
@end

#pragma mark -UIImage扩展
@interface UIImage (tztPrivate)
/**读取name对应的图片，并可追加strAdd路径。
 读取规则：
 1、优先读取g_nsBundlename中image目录下的图片，
    若g_nsBundlename不存在，则读取通用tzt.bundle中image目录下的图片
    若还是读取不到，则直接读取mainBundle下的对应图片
 2、图片优先加载@2x的图，然后是.9的图，最后是.9@2x
 */
+ (UIImage *)imageTztNamed:(NSString *)name withAdd:(NSString*)strAdd;
/**读取name对应的图片，规则通商*/
+ (UIImage *)imageTztNamed:(NSString *)name;
/**根据颜色创建单色图片1*1 */
+ (UIImage *)tztCreateImageWithColor:(UIColor *)color;
@end

#pragma mark -UIView扩展
@interface UIView (tztPrivate)
- (void)setTztIndex:(NSInteger)nIndex;
- (void)setTztName:(NSString*)nsName;
-(NSString*)getTztName;
-(NSInteger)getTztIndex;

/**获取y*/
- (CGFloat)gettztwindowy:(UIView*)topView;
/**获取x*/
- (CGFloat)gettztwindowx:(UIView*)topView;

- (void)tztShowPhoneList:(NSString*)telphone;

/**获取当前view的屏幕截图*/
- (UIImage *)tztGetCurrentScreenImage:(CGRect)rect;
/**
 *    @author yinjp
 *
 *    @brief  需要模糊处理的区域
 *
 *    @param rect 需要生成模糊图片的view
 *    @param blur 模糊度
 *
 *    @return 模糊后的image
 */
/**生成模糊处理图片，rect需要生成的区域，blur模糊度*/
- (UIImage *)tztBurryImage:(CGRect)rect withBurryLevel_:(CGFloat)blur;
@end

#pragma mark -UIButton扩展
@interface UIButton (tztPrivate)
/**设置按钮标题文字*/
- (void)setTztTitle:(NSString*)title;
/**设置按钮标题文字,文字中带\r\n，可以换行显示*/
- (void)setTztTitleEx:(NSString*)title;
/**统一设置所有按钮状态的标题文字*/
- (void)setAllStateTitle:(NSString *)title;
/**统一设置按钮normal和highlighted状态的标题颜色*/
- (void)setTztTitleColor:(UIColor *)color;
/**统一设置所有按钮状态的标题颜色*/
- (void)setAllStateTitleColor:(UIColor *)color;
/**设置按钮normal状态底图*/
- (void)setTztBackgroundImage:(UIImage *)image;
/**设置按钮normal状态图片*/
- (void)setTztImage:(UIImage *)image;
@end

#pragma mark -UILabel扩展
@interface UILabel(tztPrivate)
/**文字居于顶部*/
- (void)alignTop;
/**文字居于底部*/
- (void)alignBottom;
@end

#pragma mark -UIImageView扩展
@interface UIImageView (tztPrivate)
//下载图片
- (void)loadImageFromURL:(NSString*)strURL completion:(void (^)(void))completion;
//不带crc
- (void)setImageFromUrlEx:(NSString*)urlString atFile:(NSString*)file;
- (void)setImageFromUrlEx:(NSString*)urlString atFile:(NSString*)file completion:(void(^)(void))completion;
//带crc
- (void)setImageFromUrl:(NSString*)urlString atFile:(NSString*)file;    
- (void)setImageFromUrl:(NSString*)urlString atFile:(NSString*)file
             completion:(void (^)(void))completion;
- (void)setImageFromUrlForHT:(NSString*)urlString atFile:(NSString*)file
             completion:(void (^)(void))completion;
@end

#pragma mark -UIWebView扩展
@interface UIWebView (tztPrivate)<UIAlertViewDelegate>
- (void)webView:(UIWebView *)sender runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(id)frame;
- (BOOL)webView:(UIWebView *)sender runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(id)frame;
@end
//#endif


#pragma mark -tztKeyChain钥匙串操作
@interface tztKeyChain : NSObject
/**获取钥匙串中service对应信息*/
+ (NSMutableDictionary *)getKeychainQuery:(NSString *)service;
/**保存数据data到钥匙串中service的key下，不写文件*/
+ (void)save:(NSString *)service data:(id)data;
/**保存数据data到钥匙串中的service的key下。bFile是否需要写文件，默认NO*/
+ (void)saveEx:(NSString*)service data:(id)data bFile_:(BOOL)bFile;
/**读取钥匙串中service对应的数据*/
+ (id)load:(NSString *)service;
/**读取钥匙串中service对应的数据， bFile默认NO*/
+ (id)loadEx:(NSString *)service bFile_:(BOOL)bFile;
/**删除钥匙串中service数据*/
+ (void)delete:(NSString *)service;
@end

#pragma mark -UIDevice扩展
@interface UIDevice(tztPrivate)
/**获取设备信息，并以字典返回
 信息包括：设备名称，modal，系统名称，系统版本，屏幕大小*/
+(NSMutableDictionary*)tztDeviceInfo;
@end

#endif
//消息传递类
#pragma mark -消息对象
@interface TZTUIMessage : NSObject
{
    NSUInteger    m_nMsgType;
    NSUInteger    m_wParam;
    NSUInteger    m_lParam;
    //保留字段
    NSUInteger    m_lRev1;
    NSUInteger    m_lRev2;
}
/**消息id*/
@property    NSUInteger    m_nMsgType;
/**参数1*/
@property    NSUInteger    m_wParam;
/**参数2*/
@property    NSUInteger    m_lParam;
/**保留参数1*/
@property    NSUInteger    m_lRev1;
/**保留参数2*/
@property    NSUInteger    m_lRev2;
@end