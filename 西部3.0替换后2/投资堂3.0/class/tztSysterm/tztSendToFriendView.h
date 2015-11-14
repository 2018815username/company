/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:        推荐好友
 * 文件标识:        
 * 摘要说明:        
 * 
 * 当前版本:        2.0
 * 作    者:       yinjp
 * 更新日期:            
 * 整理修改:	
 *
 ***************************************************************/

#import <AddressBook/AddressBook.h>
#import <MessageUI/MessageUI.h>
#import "tztBaseSetViewController.h"

@interface tztSendToFriendView : tztUIBaseSetView<MFMessageComposeViewControllerDelegate>
{
    NSMutableArray          *_ayPhoneAry;
}
@property(nonatomic,retain)NSMutableArray       *ayPhoneAy;
@end
