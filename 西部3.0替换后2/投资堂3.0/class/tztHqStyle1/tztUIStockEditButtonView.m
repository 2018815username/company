//
//  tztUIStockEditButtonView.m
//  tztMobileApp_HTSC
//
//  Created by King on 14-2-19.
//
//

#import "tztUIStockEditButtonView.h"

@interface tztUIStockEditButtonView()
{
    UIButton        *_pBtnManager;//管理
    UIButton        *_pBtnSynch;  //同步
    UIButton        *_pBtnAdd;    //添加
}
@end

@implementation tztUIStockEditButtonView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(id)init
{
    if( self = [super init] )
    {
        
    }
    return self;
}

/*
 tztGrid_AddUserStock@2x.png
 tztGrid_ManagerUserStock@2x.png
 tztGrid_UpdateUserStock@2x.png
 */
-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageTztNamed:@"tztGrid_UserStockBg.png"]];
    CGRect rcFrame = self.bounds;
    
    CGFloat fWidth = rcFrame.size.width / 3;
    rcFrame.size.width = fWidth;
    
    UIImage *image = [UIImage imageTztNamed:@"tztGrid_ManagerUserStock.png"];
    
    CGRect rcManager = rcFrame;
    CGFloat fXOffset = 0;
    CGFloat fYOffset = 0;
    CGSize sz = CGSizeMake(fWidth, rcFrame.size.height);
    if (image.size.width > 0 && image.size.height > 0)
    {
        fXOffset = (rcFrame.size.width - image.size.width) / 2;
        fYOffset = (rcFrame.size.height - image.size.height) / 2;
        sz = image.size;
    }
    
    rcManager.origin.x += fXOffset;
    rcManager.origin.y += fYOffset;
    rcManager.size = sz;
    
    if (_pBtnManager == NULL)
    {
        _pBtnManager = [UIButton buttonWithType:UIButtonTypeCustom];
        _pBtnManager.frame = rcManager;
        [_pBtnManager setBackgroundImage:[UIImage imageTztNamed:@"tztGrid_ManagerUserStock.png"] forState:UIControlStateNormal];
        _pBtnManager.showsTouchWhenHighlighted = YES;
        _pBtnManager.tag = TZT_MENU_EditUserStock;
        [_pBtnManager addTarget:self action:@selector(OnClickButton:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_pBtnManager];
    }
    else
    {
        _pBtnManager.frame = rcManager;
    }
    
//    rcManager.origin.x += rcManager.size.width + 2 * fXOffset;
//    if (_pBtnSynch == NULL)
//    {
//        _pBtnSynch = [UIButton buttonWithType:UIButtonTypeCustom];
//        _pBtnSynch.frame = rcManager;
//        [_pBtnSynch setBackgroundImage:[UIImage imageTztNamed:@"tztGrid_UpdateUserStock.png"] forState:UIControlStateNormal];
//        _pBtnSynch.showsTouchWhenHighlighted = YES;
//        _pBtnSynch.tag = TZT_MENU_EditUserStock;
//        [_pBtnSynch addTarget:self action:@selector(OnClickButton:) forControlEvents:UIControlEventTouchUpInside];
//        [self addSubview:_pBtnSynch];
//    }
//    else
//    {
//        _pBtnSynch.frame = rcManager;
//    }
//    
    rcManager.origin.x += rcManager.size.width*2 + 4 * fXOffset;
    if (_pBtnAdd == NULL)
    {
        _pBtnAdd = [UIButton buttonWithType:UIButtonTypeCustom];
        _pBtnAdd.frame = rcManager;
        [_pBtnAdd setBackgroundImage:[UIImage imageTztNamed:@"tztGrid_AddUserStock.png"] forState:UIControlStateNormal];
        _pBtnAdd.showsTouchWhenHighlighted = YES;
        _pBtnAdd.tag = MENU_HQ_SearchStock;
        [_pBtnAdd addTarget:self action:@selector(OnClickButton:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_pBtnAdd];
    }
    else
    {
        _pBtnAdd.frame = rcManager;
    }
}

-(void)OnClickButton:(id)sender
{
    UIButton* pBtn = (UIButton*)sender;
    if (_tztDelegate && [_tztDelegate respondsToSelector:@selector(tztUIStockEditButtonViewClicked:)])
    {
        [_tztDelegate tztUIStockEditButtonViewClicked:sender];
    }
    else
    {
        [TZTUIBaseVCMsg OnMsg:pBtn.tag wParam:0 lParam:0];
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
