/*******************************************************************************
 * Copyright (c)2012, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称：    tztUIAlertView
 * 文件标识：
 * 摘    要：   自定义UIAlertView (可以根据自已需要的界面添加类型)
 *
 * 当前版本：
 * 作    者：   zxl
 * 完成日期：
 *
 * 备    注：
 *
 * 修改记录：
 *
 *******************************************************************************/

#import <UIKit/UIKit.h>
enum AlertType
{
    tztCloseType = 0,//关闭
};
@interface tztUIAlertView : UIAlertView
{
    int _nType;
}
-(id)initWithTitle:(NSString *)title message:(NSString *)message delegate:(id)delegate LeftBtnTitle:(NSString *)Letf
     RightBtnTitle:(NSString *)Right AlertType:(int)Type;
@end
