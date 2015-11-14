//
//  tztNearBranchView.h
//  tztMobileApp_yyz
//
//  Created by 张 小龙 on 13-6-5.
//
//

#import "TZTUIBaseView.h"

@interface tztNearBranchView : TZTUIBaseView<UITableViewDelegate,UITableViewDataSource>
{
    UILabel * _pLable;
    UITableView * _tztTableView;
    NSMutableArray * _ayBranch;
}
@property(nonatomic,retain)UITableView   *tztTableView;
@property(nonatomic,retain)NSMutableArray  *ayBranch;
@end
