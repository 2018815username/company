/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:        历史分时
 * 文件标识:        显示历史分时
 * 摘要说明:
 *
 * 当前版本:        2.0
 * 作    者:       yinjp
 * 更新日期:
 * 整理修改:
 *
 ***************************************************************/

#import "tztTrendView.h"


@interface tztHisTrendView : tztTrendView<UIGestureRecognizerDelegate>
/*请求历史分时
 nsDate:    请求历史分时的日期
 add by yinjp 20130712
 */
-(void)onRequestHisData:(NSString*)nsDate;
@end

