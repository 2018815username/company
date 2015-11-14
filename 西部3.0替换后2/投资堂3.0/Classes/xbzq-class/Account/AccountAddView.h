//
//  AccountAddView.h
//  tzt_xbzq_3.0
//
//  Created by wry on 15/6/12.
//  Copyright (c) 2015年 ZZTZT. All rights reserved.
//

#import "tztBaseTradeView.h"

@interface AccountAddView : tztBaseTradeView<UITableViewDataSource,UITableViewDelegate>

 @property (nonatomic,strong) UITableView* tableView;
@end
