
#import <UIKit/UIKit.h>

 /**显示提示信息，定时隐藏控件*/
@interface tztMessageLabel : UIView


 /**
 *	@brief	外部通过字典形式设置显示属性
 *
 *	@param 	dictArr 	属性字典，具体key定义参照下方定义
 *
 *	@return	无
 */
-(void)setArrtibuteForShow:(NSDictionary*)dictArr;

@end

//属性字典key定义
 /**
 *	@brief	显示内容的字体（默认14号）
 */
#define tztLabelContentFont        @"tztLabelContentFont"

 /**
 *	@brief	字体对齐方式，默认（1行居中，多行左对齐）
 */
#define tztLabelTextAligment       @"tztLabelTextAligment"

 /**
 *	@brief	字体显示颜色，默认黑色
 */
#define tztLabelTextColor          @"tztLabelTextColor"

 /**
 *	@brief	显示的圆角，默认2
 */
#define tztLabelCornRadius         @"tztLabelCornRadius"

 /**
 *	@brief	背景色，默认灰色（graycolor）
 */
#define tztLabelBackgroundColor    @"tztLabelBackgroudnColor"

 /**
 *	@brief	显示位置 0-默认，居中显示 1-底部显示  2-顶部显示
 */
#define tztLabelShowPosition        @"tztLabelShowPosition"


 /**
 *	@brief	显示label
 *
 *	@param 	strMsg 	显示的文本信息
 *
 *	@return	tztMessageLabel对象
 */
FOUNDATION_EXPORT tztMessageLabel* tztAfxMessageLabel(NSString* strMsg);

 /**
 *	@brief	显示label
 *
 *	@param 	strMsg 	需要显示的内痛
 *	@param 	dictArr 	显示参数属性字典，具体参数参照上面的key定义
 *
 *	@return	tztMessageLabel对象
 */
FOUNDATION_EXPORT tztMessageLabel* tztAfxMessageLabelWithArrtibutes(NSString* strMsg, NSDictionary* dictArr);



