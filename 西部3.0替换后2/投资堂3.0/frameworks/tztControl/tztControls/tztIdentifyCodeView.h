

#import <UIKit/UIKit.h>
/**
 *    @author yinjp
 *
 *    @brief  验证码控件
 */
@interface tztIdentifyCodeView : UILabel

/**
 *    @author yinjp
 *
 *    @brief  背景色
 */
@property(nonatomic,retain)UIColor *clBackground;

/**
 *    @author yinjp
 *
 *    @brief  初始化创建验证码控件
 *
 *    @param frame 显示区域
 *    @param nLen  验证码长度
 *    @param bJustNumber 仅仅数字验证码
 *
 *    @return tztIdentifyCodeView
 */
-(id)initWithFrame:(CGRect)frame andLen:(NSInteger)nLen bJustNumber:(BOOL)bJustNumber;

/**
 *    @author yinjp
 *
 *    @brief  刷新显示，重新显示验证码
 */
-(void)tztRefresh;

/**
 *    @author yinjp
 *
 *    @brief  校验输入的验证码是否正确
 *
 *    @param nsData 输入的验证码
 *
 *    @return 正确=TRUE
 */
-(BOOL)isValid:(NSString*)nsData;
@end
