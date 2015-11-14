/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:        增删服务器端口地址view
 * 文件标识:        
 * 摘要说明:        
 * 
 * 当前版本:        2.0
 * 作    者:       yinjp
 * 更新日期:            
 * 整理修改:	
 *
 ***************************************************************/

@protocol tztTouchTableViewDelegate <NSObject>
@optional
- (void)tableView:(UITableView *)tableView touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)tableView:(UITableView *)tableView touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)tableView:(UITableView *)tableView touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)tableView:(UITableView *)tableView touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event;
@end


@interface  tztTouchTableView : UITableView
{
@private
    id _touchDelegate;
}
@property (nonatomic,assign) id<tztTouchTableViewDelegate> touchDelegate;
@end

@interface tztAddOrDeletServerView : TZTUIBaseView<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,tztTouchTableViewDelegate>
{
    tztTouchTableView* _tableView;
    int _nBeginTag;
    CGFloat keyboardHeight;
}

@property(nonatomic,retain)tztTouchTableView   *tableView;
@end
