
#import <UIKit/UIKit.h>
/**
 *  组合单选view协议
 */
@protocol tztGroupRadioViewDelegate <NSObject>

@optional
/**
 *  选中某一按钮
 *
 *  @param sender   groupradioview对象
 *  @param index    选中位置
 *  @param bChecked 是否选中
 */
-(void)tztGroupRadioView:(id)sender selectAtIndex:(NSUInteger)index forState:(BOOL)bChecked;
@end

/**
 *  单选组合按钮控件
 */
@interface tztGroupRadioView : UIView

/**
 *  代理
 */
@property(nonatomic,assign)id<tztGroupRadioViewDelegate> tztDelegate;

/**
 *  初始化创建控件
 *
 *  @param frame         显示区域
 *  @param ayItems       按钮数组   格式：文字|图片|
 *  @param selectedImage 选中图片
 *
 *  @return tztGroupRadioView对象
 */
-(id)initWithFrame:(CGRect)frame andItems:(NSArray*)ayItems withSelectedIamge:(UIImage*)selectedImage;
/**
 *  更新显示状态
 *
 *  @param index 当前选中位置
 */
-(void)updateStates:(NSUInteger)index;

@end
