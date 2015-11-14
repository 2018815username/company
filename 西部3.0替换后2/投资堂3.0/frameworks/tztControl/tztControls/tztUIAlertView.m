/*******************************************************************************
 * Copyright (c)2012, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称：    tztUIAlertView
 * 文件标识：
 * 摘    要：   自定义UIAlertView
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
#import "tztUIAlertView.h"

@implementation tztUIAlertView

-(id)initWithTitle:(NSString *)title message:(NSString *)message delegate:(id)delegate LeftBtnTitle:(NSString *)Letf
     RightBtnTitle:(NSString *)Right AlertType:(int)Type
{
    self = [self initWithTitle:title message:message delegate:delegate cancelButtonTitle:Letf otherButtonTitles:Right, nil];
    if (self)
    {
        _nType = Type;
    }
    return self;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    switch (_nType)
    {
        case tztCloseType:
        {
            UIButton *closeBtn = (UIButton *)[self viewWithTag:0x2222];
            CGRect rect = CGRectMake(254, 4, 20, 20);
            if (closeBtn == nil)
            {
                closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                [closeBtn setBackgroundImage:[UIImage imageTztNamed:@"TZTButtonClose.png"] forState:UIControlStateNormal];
                [closeBtn addTarget:self action:@selector(OnBtn:) forControlEvents:UIControlEventTouchUpInside];
                closeBtn.tag = 0x2222;
                [self addSubview:closeBtn];
                closeBtn.frame = rect;
            }else
            {
                closeBtn.frame = rect;
            }
            [self bringSubviewToFront:closeBtn];
        }
            break;
        default:
            break;
    }
}
-(void)OnBtn:(id)sender
{
    UIButton *button = (UIButton *)sender;
    if (button.tag == 0x2222)
    {
        [self dismissWithClickedButtonIndex:0 animated:YES];
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
