//
//  AccountTableViewCell.h
//  Test
//
//  Created by wry on 15/6/11.
//  Copyright (c) 2015年 wry. All rights reserved.
//

#import <UIKit/UIKit.h>


#define  SectionHeight 65
#define  leftWidht 15
typedef void (^curentSelectAccount)(tztJYLoginInfo*);
@interface AccountTableViewCell : UITableViewCell

@property (nonatomic,strong) UIButton* left;
@property (nonatomic,strong) UILabel*  centerLable;
@property (nonatomic,strong) UIButton*    right;
-(void)setAccountTitle:(NSString*)title;

@property(nonatomic,copy)curentSelectAccount selectAccount;

-(void)setLoginOrNologin:(tztJYLoginInfo*)ptLogin RzrqLoin:(tztJYLoginInfo*)rzrqLogin andCurrentCellData:(tztJYLoginInfo*)current;
@end
