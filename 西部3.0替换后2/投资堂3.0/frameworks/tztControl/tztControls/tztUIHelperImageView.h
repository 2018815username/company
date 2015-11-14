/*
 
 显示帮助引导图片
 
 */

#import <UIKit/UIKit.h>

/**显示界面上的帮助图片，只显示一次，用户点击后消失，下次不再显示*/
@interface tztUIHelperImageView : UIView

/**显示帮助图片在windows上，全屏显示， nsImageName－图片名称 nsClassName－对应的key*/
+(void)tztShowHelperView:(NSString*)nsImageName forClass_:(NSString*)nsClassName;
/**取消显示*/
+(void)tztHelperViewDismiss;
@end
