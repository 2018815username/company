//
//  tztManagerUserStock.m
//  tztMobileApp_HTSC
//
//  Created by King on 14-9-16.
//
//

#import "tztManagerUserStock.h"
#import "tztUIEditUserStockView.h"

#define tztSearchHotStockTag    0x1234
#define tztSearchHisStockTag    0x1235

@interface tztManagerUserStock()<tztUIButtonDelegate, UIGestureRecognizerDelegate, tztUIBaseViewCheckDelegate>

@property(nonatomic,retain) tztUISwitch             *pBtnHotSearch;
@property(nonatomic,retain) tztUISwitch             *pBtnHisSearch;
@property(nonatomic,retain) tztUIEditUserStockView  *pEditUserStock;

@property(nonatomic,retain) tztUIButton             *pBtnAddStock;
@property(nonatomic,retain) tztUIButton             *pBtnTbStock;
@property(nonatomic,retain) UIImageView             *imageViewAdd;
@property(nonatomic,retain) UIImageView             *imageViewTB;
@property(nonatomic,retain) UIView                  *pViewSep;
@property(nonatomic,retain) UIView                  *pViewBack;
@property(nonatomic,retain) tztUICheckButton        *pCheckBtn;
@property(nonatomic)BOOL bDefault;

@property(nonatomic,retain)UISwipeGestureRecognizer *swipeLeft;
@property(nonatomic,retain)UISwipeGestureRecognizer *swipeRight;
@end

@implementation tztManagerUserStock
@synthesize pBtnHisSearch = _pBtnHisSearch;
@synthesize pBtnHotSearch = _pBtnHotSearch;
@synthesize pBtnAddStock = _pBtnAddStock;
@synthesize pBtnTbStock = _pBtnTbStock;
@synthesize imageViewAdd = _imageViewAdd;
@synthesize imageViewTB = _imageViewTB;
@synthesize pViewSep = _pViewSep;
@synthesize tztDelegate = _tztDelegate;
@synthesize swipeLeft = _swipeLeft;
@synthesize swipeRight = _swipeRight;
@synthesize pViewBack = _pViewBack;
@synthesize pCheckBtn = _pCheckBtn;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initData];
    }
    return self;
}

-(id)init
{
    if (self = [super init])
    {
        [self initData];
    }
    return self;
}

-(void)initData
{
    _bDefault = FALSE;
    NSMutableDictionary* pDict = GetDictByListName(@"tztstartpageset");
    //0-默认 1-热点，2-自选，3-市场，4-精品推荐，5-理财宝库
    if (pDict && [[pDict tztObjectForKey:@"tztstartpage"] intValue] == 2)
    {
        _bDefault = YES;
    }
}

-(void)setFrame:(CGRect)frame
{
    if (CGRectIsEmpty(frame) || CGRectIsNull(frame))
        return;
    [super setFrame:frame];
    self.backgroundColor = [UIColor tztThemeBackgroundColorHQ];
    CGRect rcFrame = self.bounds;
    //    rcFrame.size.height = 0;
    
    CGRect rcLabel = rcFrame;
    rcLabel.origin.x = 0;
    rcLabel.size.height = 72;
    rcLabel.size.width = rcFrame.size.width / 2;
    
    
    if (_swipeLeft == NULL)
    {
        _swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                               action:@selector(SwipeLeftOrRight:)];
        _swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
        _swipeLeft.delegate = self;
        [self addGestureRecognizer:_swipeLeft];
        [_swipeLeft release];
    }
    if (_swipeRight == NULL)
    {
        _swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                                action:@selector(SwipeLeftOrRight:)];
        _swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
        _swipeRight.delegate = self;
        [self addGestureRecognizer:_swipeRight];
        [_swipeRight release];
    }
    
    
    if (_pBtnAddStock == NULL)
    {
        _pBtnAddStock = [[tztUIButton alloc] initWithProperty:@"tag=5000|backcolor=60,60,60|type=custom|title=    添加|font=24|valueimage=tztUserStockAddIcon.png|"];
        _pBtnAddStock.frame = rcLabel;
        [_pBtnAddStock setTztTitleColor:[UIColor colorWithRGBULong:0xdddddd]];
        _pBtnAddStock.tztdelegate = self;
        [self addSubview:_pBtnAddStock];
        [_pBtnAddStock release];
    }
    else
    {
        _pBtnAddStock.frame = rcLabel;
    }
    
    CGRect rcImage = rcLabel;
    rcImage.origin.x = rcLabel.size.width / 2 - 40;
    rcImage.size = CGSizeMake(18,18);
    rcImage.origin.y += (rcLabel.size.height - rcImage.size.height) / 2;
    if (_imageViewAdd == NULL)
    {
        _imageViewAdd = [[UIImageView alloc] initWithImage:[UIImage imageTztNamed:@"tztUserStockAddIcon.png"]];
        _imageViewAdd.backgroundColor = [UIColor clearColor];
        _imageViewAdd.userInteractionEnabled = NO;
        _imageViewAdd.frame = rcImage;
        [_pBtnAddStock addSubview:_imageViewAdd];
        [_imageViewAdd release];
    }
    else
    {
        _imageViewAdd.frame = rcImage;
    }
    
    CGRect rcSep = rcLabel;
    rcSep.origin.x += rcLabel.size.width - 1;
    rcSep.origin.y += 10;
    rcSep.size.height -= 20;
    rcSep.size.width = 1;
    if (_pViewSep == NULL)
    {
        _pViewSep = [[UIView alloc] initWithFrame:rcSep];
        _pViewSep.backgroundColor = [UIColor colorWithTztRGBStr:@"72,72,72"];
        [self addSubview:_pViewSep];
        [_pViewSep release];
    }
    else
        _pViewSep.frame = rcSep;
    
    rcLabel.origin.x += rcLabel.size.width;
    
    if (_pBtnTbStock == NULL)
    {
        _pBtnTbStock = [[tztUIButton alloc] initWithProperty:@"tag=5001|backcolor=60,60,60|type=custom|title=    同步|font=24|valueimage=tztUserStockTB.png|"];
        [_pBtnTbStock setTztTitleColor:[UIColor colorWithRGBULong:0xdddddd]];
        _pBtnTbStock.frame = rcLabel;
        _pBtnTbStock.tztdelegate = self;
        [self addSubview:_pBtnTbStock];
        [_pBtnTbStock release];
    }
    else
    {
        _pBtnTbStock.frame = rcLabel;
    }
    
    rcImage = rcLabel;
    rcImage.origin.x = rcLabel.size.width / 2 - 40;
    rcImage.size = CGSizeMake(18,18);
    rcImage.origin.y += (rcLabel.size.height - rcImage.size.height) / 2;
    if (_imageViewTB == NULL)
    {
        _imageViewTB = [[UIImageView alloc] initWithImage:[UIImage imageTztNamed:@"tztUserStockTB.png"]];
        _imageViewTB.backgroundColor = [UIColor clearColor];
        _imageViewTB.userInteractionEnabled = NO;
        _imageViewTB.frame = rcImage;
        [_pBtnTbStock addSubview:_imageViewTB];
        [_imageViewTB release];
    }
    else
    {
        _imageViewTB.frame = rcImage;
    }
    
//    
//    if (_pBtnHotSearch == NULL)
//    {
//        _pBtnHotSearch = [[tztUISwitch alloc] initWithProperty:@"tag=4660|notitle=自选股管理|yestitle=自选股管理|textalignment=center|font=17|"];
//        _pBtnHotSearch.bUnderLine = TRUE;
////        _pBtnHisSearch.backgroundColor = [UIColor redColor];
//        _pBtnHotSearch.nsUnderLineColor = @"255,0,0";
//        [_pBtnHotSearch setTztTitleColor:[UIColor tztThemeTextColorLabel]];
//        _pBtnHotSearch.frame = rcLabel;
//        [_pBtnHotSearch addTarget:self
//                           action:@selector(OnSwitchBtn:) forControlEvents:UIControlEventTouchUpInside];
//        [self addSubview:_pBtnHotSearch];
//        [_pBtnHotSearch release];
//    }
//    else
//    {
//        _pBtnHotSearch.frame = rcLabel;
//    }
//    
//    rcLabel.origin.x += rcLabel.size.width;
//    if (_pBtnHisSearch == NULL)
//    {
//        _pBtnHisSearch = [[tztUISwitch alloc] initWithProperty:@"tag=4661|notitle=指数管理|yestitle=指数管理|textalignment=center|font=17|"];
//        _pBtnHisSearch.bUnderLine = TRUE;
//        _pBtnHisSearch.checked = FALSE;
//        _pBtnHisSearch.nsUnderLineColor = @"255,0,0";
//        [_pBtnHisSearch setTztTitleColor:[UIColor tztThemeTextColorLabel]];
//        _pBtnHisSearch.frame = rcLabel;
//        [_pBtnHisSearch addTarget:self
//                           action:@selector(OnSwitchBtn:) forControlEvents:UIControlEventTouchUpInside];
//        [self addSubview:_pBtnHisSearch];
//        [_pBtnHisSearch release];
//    }
//    else
//    {
//        _pBtnHisSearch.frame = rcLabel;
//    }

    BOOL bHasViewBack = FALSE;
    
    CGRect rc = rcFrame;
    rc.origin.y += rcLabel.origin.y + rcLabel.size.height;
    rc.size.height -= ((rcLabel.origin.y + rcLabel.size.height) + (bHasViewBack ? 44 : 0));
    if (_pEditUserStock == NULL)
    {
        _pEditUserStock = [[tztUIEditUserStockView alloc] init];
        _pEditUserStock.frame = rc;
        [self addSubview:_pEditUserStock];
        [_pEditUserStock release];
    }
    else
    {
        _pEditUserStock.frame = rc;
    }
    
    CGRect rcCheck = rc;
    rcCheck.origin.y += rc.size.height;
    rcCheck.size.height = (bHasViewBack ? 44 : 0);
    if (_pViewBack == NULL)
    {
        _pViewBack = [[UIView alloc] initWithFrame:rcCheck];
        [self addSubview:_pViewBack];
        [_pViewBack release];
    }
    else
    {
        _pViewBack.frame = rcCheck;
    }
    
    rcCheck.origin.x += 10;
    rcCheck.size.width -= 10;
    if (_pCheckBtn == NULL)
    {
        NSString* str = [NSString stringWithFormat:@"rect=20,,,|tag=7000|type=left|textAlignment=left|title=    将市场设置为首页|text=%@|messageinfo=服务器配置|textcolor=218,43,41|seltextcolor=137,137,137|imagenormal=tztCheckBoxNormal.png|imageselected=tztCheckBoxSelected.png", (_bDefault ? @"1" : @"0")];
        _pCheckBtn = [[tztUICheckButton alloc] initWithProperty:str];
        _pCheckBtn.tztdelegate = self;
        [self addSubview:_pCheckBtn];
        _pCheckBtn.frame = rcCheck;
        [_pCheckBtn release];
    }
    else
    {
        _pCheckBtn.frame = rcCheck;
    }
    _pCheckBtn.hidden = !bHasViewBack;
    _pViewBack.backgroundColor = [UIColor colorWithTztRGBStr:@"48,48,48"];
    _pCheckBtn.backgroundColor = [UIColor colorWithTztRGBStr:@"48,48,48"];
}


- (void)tztUIBaseView:(UIView *)tztUIBaseView checked:(BOOL)checked
{
    //0-默认 1-热点，2-自选，3-市场，4-精品推荐，5-理财宝库
    NSMutableDictionary *pDict = NewObject(NSMutableDictionary);
    [pDict setTztObject:[NSString stringWithFormat:@"%d",(checked?3:0)] forKey:@"tztstartpage"];
    SetDictByListName(pDict, @"tztstartpageset");
    DelObject(pDict);
    if (checked)
    {
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
                              [[UIColor colorWithTztRGBStr:@"191,44,42"] colorWithAlphaComponent:0.95], tztLabelBackgroundColor,
                              [UIColor whiteColor],tztLabelTextColor,
                              [UIFont boldSystemFontOfSize:19.f], tztLabelContentFont,
                              @"10", tztLabelCornRadius,
                              @"0",  tztLabelShowPosition,
                              nil];
        tztAfxMessageLabelWithArrtibutes(@"首页设置成功", dict);
//        tztAfxMessageBox(@"首页设置成功!");
    }
}

-(void)OnButtonClick:(id)sender
{
    tztUIButton* pButton = (tztUIButton*)sender;
    switch ([pButton.tzttagcode intValue])
    {
        case 5000:
        {
            [TZTUIBaseVCMsg OnMsg:MENU_HQ_SearchStock wParam:0 lParam:0];
        }
            break;
        case 5001:
        {
            if (_tztDelegate && [_tztDelegate respondsToSelector:@selector(OnUserStockTB:)])
            {
                [_tztDelegate OnUserStockTB:_pBtnTbStock];
            }
        }
        default:
            break;
    }
        
}

-(void)SwipeLeftOrRight:(UISwipeGestureRecognizer*)recognsizer
{
    if (self.tztDelegate && [self.tztDelegate respondsToSelector:@selector(tztOnSwipe:andView_:)])
    {
        [self.tztDelegate tztOnSwipe:recognsizer andView_:self];
    }
    
}

-(void)OnSwitchBtn:(id)sender
{
    tztUISwitch *pBtn = (tztUISwitch*)sender;
    if (pBtn && [pBtn isKindOfClass:[tztUISwitch class]])
    {
        [pBtn setChecked:YES];
        [pBtn setBackgroundColor:[UIColor tztThemeBackgroundColorSection]];
    }
    if (pBtn == _pBtnHisSearch)
    {
        [_pBtnHotSearch setChecked:NO];
        [_pBtnHotSearch setBackgroundColor:[UIColor tztThemeBackgroundColorHQ]];
    }
    else if (pBtn == _pBtnHotSearch)
    {
        [_pBtnHisSearch setChecked:NO];
        [_pBtnHisSearch setBackgroundColor:[UIColor tztThemeBackgroundColorHQ]];
    }
    switch ([pBtn.tzttagcode intValue])
    {
        case tztSearchHotStockTag://自选股管理
        {
            //自选股编辑界面
            
        }
            break;
        case tztSearchHisStockTag://指数管理
        {
            //指数编辑界面
        }
            break;
        default:
            break;
    }
}

-(void)setSelectIndex:(int)nIndex
{
    if (nIndex == 0)
    {
        [self OnSwitchBtn:_pBtnHotSearch];
    }
    else if (nIndex == 1)
    {
        [self OnSwitchBtn:_pBtnHisSearch];
    }
}
@end
