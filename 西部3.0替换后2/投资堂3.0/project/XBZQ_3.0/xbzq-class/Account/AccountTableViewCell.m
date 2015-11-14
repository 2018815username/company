
//
//  AccountTableViewCell.m
//  Test
//
//  Created by wry on 15/6/11.
//  Copyright (c) 2015年 wry. All rights reserved.
//

#define  leftWidth 50
#define  rightWidth 116
#define  centerWidth    TZTScreenWidth- rightWidth-80

#define  allHeight 40
#import "AccountTableViewCell.h"
#import <tztHqBase/tztJYLoginInfo.h>

@implementation AccountTableViewCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self =   [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.backgroundColor =  [UIColor  colorWithRed:250/255.0 green:252/255.0 blue:254/255.0 alpha:1];
        self.backgroundView = [[UIView alloc] init];
        [self initSubView];
    }
    return  self;
 
}

-(void)initSubView{
    self.left = [UIButton buttonWithType:UIButtonTypeCustom];
    [self setButtonImage:self.left nomalImage:@"man_unlogin" SelectImage:@"man_login"];
    [self.contentView addSubview:self.left];
    
    self.centerLable= [[UILabel alloc] init];
    [self.contentView addSubview: self.centerLable];
    
    self.right = [UIButton buttonWithType:UIButtonTypeCustom];
    [self setButtonImage:self.right nomalImage:@"noLogin" SelectImage:@"hasLogin"];
    [self.contentView addSubview: self.right];
}

-(void)setButtonImage:(UIButton*)bnt nomalImage:(NSString*)nomal SelectImage:(NSString*)select{
    [bnt setImage:[UIImage imageNamed:nomal] forState:UIControlStateNormal];
    [bnt setImage:[UIImage imageNamed:select] forState:UIControlStateSelected];
}
-(void)layoutSubviews{
    [super layoutSubviews];
    
    self.left.frame =CGRectMake(leftWidht+5, 2, leftWidth, allHeight);
    self.centerLable.frame = CGRectMake(leftWidht+5+leftWidth, 2, centerWidth, allHeight);
    self.right.frame = CGRectMake( leftWidht+5+leftWidth+centerWidth, 2, rightWidth, allHeight+4);
    
}
-(void)isLogin:(BOOL)logined{

    self.left.selected= logined;
    self.right.selected = logined;
    self.centerLable.textColor =logined? [UIColor orangeColor]:[UIColor colorWithRed:174.0/255.0 green:182.0/255.0 blue:195.0/255.0 alpha:1];
}

-(void)setLoginOrNologin:(tztJYLoginInfo*)ptLogin RzrqLoin:(tztJYLoginInfo*)rzrqLogin andCurrentCellData:(tztJYLoginInfo*)current{
    
    self.centerLable.text = current.nsAccount;

    BOOL isSelect =[current.nsAccount isEqualToString:ptLogin.nsAccount]|| [current.nsAccount isEqualToString:rzrqLogin.nsAccount];
    [self isLogin:isSelect];

}

-(void)setAccountTitle:(NSString*)title{
    self.centerLable.text = title;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
//    if (self.selectAccount) {
//    self.selectAccount(g_ZJAccountArray[self.tag-11]);
//    }
//    
}

@end
