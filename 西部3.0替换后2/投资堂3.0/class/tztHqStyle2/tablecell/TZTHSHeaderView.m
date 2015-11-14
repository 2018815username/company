/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:
 * 文件标识:
 * 摘要说明:    沪深表中可打开的SectionView
 *
 * 当前版本:
 * 作    者:       DBQ
 * 更新日期:
 * 整理修改:
 *
 ***************************************************************/

#import "TZTHSHeaderView.h"

#define BLUEColor

@interface TZTHSHeaderView()

@property(nonatomic,retain) UIButton *btnArrow;
@property(nonatomic,retain) UIImageView  *labelArrow;
@end

@implementation TZTHSHeaderView

@synthesize btnTag = _btnTag;
@synthesize open = _open;
@synthesize groupName = _groupName;
@synthesize btnMore = _btnMore;
@synthesize btnArrow = _btnArrow;
@synthesize labelArrow = _labelArrow;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
       
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    [_btnTag setTitleColor:[UIColor tztThemeTextColorButton] forState:UIControlStateNormal];
    [_btnTag setTitleColor:[UIColor tztThemeTextColorButtonSel] forState:UIControlStateSelected];
#ifdef tzt_ZSSC
    [_btnMore setTitleColor:[UIColor colorWithTztRGBStr:@"46,195,250"] forState:UIControlStateNormal];
#else
    [_btnMore setTitleColor:[UIColor tztThemeTextColorButtonSel] forState:UIControlStateNormal];
#endif

}

- (void)setFrame:(CGRect)frame
{
    if (CGRectIsEmpty(frame) || CGRectIsNull(frame))
        return;
    [super setFrame:frame];
    
    CGRect rcArrow = CGRectMake(10, (frame.size.height - 18) / 2, 10, 18);
    if (_btnArrow == NULL)
    {
        _btnArrow = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btnArrow setFrame:rcArrow];
        [_btnArrow setTztImage:[UIImage imageTztNamed:@"TZTArrow_RightSection.png"]];
        [_btnArrow addTarget:self action:@selector(btnTagClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_btnArrow];
    }
    else
    {
        _btnArrow.frame = rcArrow;
    }
    
    float width = frame.size.width/5*4;
    CGRect rcBtn = CGRectMake(10 + rcArrow.size.width + rcArrow.origin.x, 0, width - 10 - (rcArrow.size.width + rcArrow.origin.x), 35);
    if (_btnTag == nil) {
        _btnTag = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnTag.titleLabel.font = tztUIBaseViewTextFont(14);
        [_btnTag setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        _btnTag.frame = rcBtn;
        
        [_btnTag addTarget:self action:@selector(btnTagClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview: _btnTag];
    }
    else
    {
        _btnTag.frame = rcBtn;
    }
    
    [_btnTag setTitleColor:[UIColor tztThemeTextColorButton] forState:UIControlStateNormal];
    [_btnTag setTitleColor:[UIColor tztThemeTextColorButtonSel] forState:UIControlStateSelected];
//    if (g_nThemeColor == 0) {
//        [_btnTag setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        [_btnTag setTitleColor:BLUEColor forState:UIControlStateSelected];
//    }
//    else if (g_nThemeColor == 1) {
//        [_btnTag setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
//        [_btnTag setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
//    }
    
    float width2 = frame.size.width/5*1;
    if (_btnMore == nil) {
        _btnMore = [UIButton buttonWithType:UIButtonTypeCustom];;
        _btnMore.titleLabel.font = tztUIBaseViewTextFont(15);
        _btnMore.frame = CGRectMake(width - 10, 0, width2, 30);
#ifdef tzt_ZSSC
        [_btnMore setTitleColor:[UIColor colorWithTztRGBStr:@"46,195,250"] forState:UIControlStateNormal];
#else
        [_btnMore setTitleColor:[UIColor tztThemeTextColorButtonSel] forState:UIControlStateNormal];
#endif
        [_btnMore setTitle:@"     • • •    " forState:UIControlStateNormal];
        [_btnMore addTarget:self action:@selector(btnMoreClicked:) forControlEvents:UIControlEventTouchUpInside];
//        _btnMore.backgroundColor = [UIColor greenColor];
        [self addSubview: _btnMore];
    }
    else {
        _btnMore.frame = CGRectMake(width, 0, width2, 35);
    }
}

- (void)btnTagClicked:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(open:)]) {
        [self.delegate open:self];
    }
}

- (void)btnMoreClicked:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(more:)]) {
        [self.delegate more:sender];
    }
}

-(void)setGroupName:(NSString *)theName{
    [_groupName release];
    _groupName = [theName retain];
    [_btnTag setTitle:_groupName forState:UIControlStateNormal];
    [_btnTag setTitle:_groupName forState:UIControlStateSelected];
}

-(void)setOpen:(BOOL)theOpen{
    _open = theOpen;
    if (_open) {
        _btnTag.selected = YES;
//        _btnMore.hidden = NO;
    }
    else {
        _btnTag.selected = NO;
//        _btnMore.hidden = YES;
    }
    
    [UIView animateWithDuration:0.5f animations:^{
        
        if (self.open)
        {
            CGAffineTransform at = CGAffineTransformMakeRotation(M_PI / 2);
            [_btnArrow setTransform:at];
        }
        else
        {
            CGAffineTransform at = CGAffineTransformMakeRotation(0);
            [_btnArrow setTransform:at];
        }
    }];
}

@end
