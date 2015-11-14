//
//  TradeTabButtonView_iPad.m
//  tztMobileApp_HTSC
//
//  Created by 在琦中 on 13-8-21.
//
//

#import "TradeTabButtonView_iPad.h"

@implementation TradeTabButtonView_iPad

@synthesize btnTabButton = _btnTabButton;
@synthesize btnClose = _btnClose;
@synthesize isSelect = _isSelect;
@synthesize strTabName = _strTabName;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        if (_btnTabButton == nil)
        {
            _btnTabButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [_btnTabButton setBackgroundImage:[UIImage imageTztNamed:@"TZTBottomBtn.png"] forState:UIControlStateNormal];
            [_btnTabButton setBackgroundImage:[UIImage imageTztNamed:@"TZTBottomBtn_on.png"] forState:UIControlStateSelected];
            _btnTabButton.titleLabel.font = tztUIBaseViewTextFont(12.0f);
            _btnTabButton.titleLabel.textColor = [UIColor whiteColor];
            [_btnTabButton.titleLabel adjustsFontSizeToFitWidth];
            _btnTabButton.frame = CGRectMake(0, 5, frame.size.width - 8, frame.size.height-5);
            [self addSubview:_btnTabButton];
        }
        else
        {
            _btnTabButton.frame = CGRectMake(0, 5, frame.size.width - 8, frame.size.height-5);
        }
            
        if (_btnClose == nil)
        {
            _btnClose = [UIButton buttonWithType:UIButtonTypeCustom];
            [_btnClose setBackgroundImage:[UIImage imageTztNamed:@"TZTBaseTextFieldClear"] forState:UIControlStateNormal];
            [_btnClose setBackgroundImage:[UIImage imageTztNamed:@"TZTBaseTextFieldClearBG"] forState:UIControlStateHighlighted];
            _btnClose.frame = CGRectMake(frame.size.width-18, 0, 18, 18);
            [self addSubview:_btnClose];
        }
        else
        {
            _btnClose.frame = CGRectMake(frame.size.width-18, 0, 18, 18);
        }
    }
    return self;
}

- (void)dealloc
{
    [_btnTabButton release];
    [_btnClose release];
    [_strTabName release];
    
    [super dealloc];
}

- (void)setStrTabName:(NSString *)strTabName
{
    [_strTabName release];
    _strTabName = [strTabName retain];
    [_btnTabButton setTztTitle:strTabName];
    [_btnTabButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
}

- (void)setIsSelect:(BOOL)isSelect
{
    _isSelect = isSelect;
    if (_isSelect) {
        _btnTabButton.selected = YES;
    }
    else{
        _btnTabButton.selected = NO;
    }
}

@end
