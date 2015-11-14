

#import "tztGroupRadioView.h"

@interface tztGroupRadioView()<tztUIBaseViewCheckDelegate>

 /**
 *	@brief	选中位置
 */
@property(nonatomic)NSUInteger      selectedIndex;

 /**
 *	@brief	选中图
 */
@property(nonatomic,copy)UIImage  *selectedImage;

 /**
 *	@brief	数据记录
 */
@property(nonatomic,retain)NSMutableArray *ayItems;

@property(nonatomic,retain)NSMutableArray *ayControls;

@end
 /**
 *	@brief	单选组合按钮控件
 */
#define tztGroupRadioTitle @"tztGroupRadioTitle"
#define tztGroupRadioImage @"tztGroupRadioImage"
#define tztGroupRadioTag    0x1234

@implementation tztGroupRadioView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame andItems:(NSArray *)ayItems withSelectedIamge:(UIImage *)selectedImage
{
    self = [self initWithFrame:frame];
    if (self)
    {
        if (_ayItems == NULL)
            _ayItems = NewObject(NSMutableArray);
        if (_ayControls == NULL)
            _ayControls = NewObject(NSMutableArray);
        for (NSUInteger i = 0; i < ayItems.count; i++)
        {
            //创建多个button
            NSString * strData = [ayItems objectAtIndex:i];
            if (strData.length <= 0)
                continue;
            NSArray *ay = [strData componentsSeparatedByString:@"|"];
            if (ay.count <= 0)
                continue;
            NSString* strTitle = [ay objectAtIndex:0];
            NSString* strImage = @"";
            if (ay.count > 1)
                strImage = [ay objectAtIndex:1];
            
            NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
            [dict setObject:strTitle forKey:tztGroupRadioTitle];
            [dict setObject:strImage forKey:tztGroupRadioImage];
            
            [self.ayItems addObject:dict];
            [dict release];
        }
        self.selectedImage = selectedImage;
    }
    return self;
}

-(void)dealloc
{
    if (self.selectedImage)
        [self.selectedImage release];
    [_ayItems removeAllObjects];
    DelObject(_ayItems);
    [_ayControls removeAllObjects];
    DelObject(_ayControls);
    [super dealloc];
}

-(void)layoutSubviews
{
    //显示
    [super layoutSubviews];
    CGRect rcFrame = self.bounds;
    NSUInteger nCount = self.ayItems.count;
    if (nCount <= 0)
        return;
    
    CGFloat fWidth = rcFrame.size.width / nCount;
    
    for (NSUInteger i = 0; i < nCount; i++)
    {
        NSDictionary *pDict = [self.ayItems objectAtIndex:i];
        if (pDict == NULL)
            continue;
        
        CGRect rcFrame = CGRectMake(i * fWidth, 0, fWidth, self.bounds.size.height);
        tztUICheckButton* pBtn = (tztUICheckButton*)[self viewWithTag:tztGroupRadioTag + i];
        if (pBtn == NULL)
        {
            NSString* strType = [NSString stringWithFormat:@"tag=%d|type=left|title=%@|textalignment=left|font=12|", (int)(tztGroupRadioTag+i),[pDict objectForKey:tztGroupRadioTitle]];
            pBtn = [[tztUICheckButton alloc] initWithProperty:strType];
            [pBtn setCheckButtonImage:[UIImage imageTztNamed:[pDict objectForKey:tztGroupRadioImage]] forState:UIControlStateNormal];
            [pBtn setCheckButtonImage:nil forState:UIControlStateHighlighted];
            [pBtn setCheckButtonImage:self.selectedImage forState:UIControlStateSelected];
            pBtn.tztdelegate = self;
            pBtn.frame = rcFrame;
            pBtn.tag = tztGroupRadioTag + i;
            [self addSubview:pBtn];
            [pBtn release];
        }
        else
            pBtn.frame = rcFrame;
    }
}

-(void)OnButtonClick:(id)sender
{
    
}


-(void)updateStates:(NSUInteger)index
{
    for (NSUInteger i = 0; i < self.ayItems.count; i++)
    {
        if (i == index)
            continue;
        UIView *pBtn = [self viewWithTag:tztGroupRadioTag + i];
        if (pBtn && [pBtn isKindOfClass:[tztUICheckButton class]])
        {
            [(tztUICheckButton*)pBtn setCheckButtonState:NO];
        }
    }
}
 /**
 *	@brief	更新按钮显示状态
 *
 *	@return	NULL
 */
-(void)updateStates
{
    [self updateStates:_selectedIndex];
}

- (void)tztUIBaseView:(UIView *)tztUIBaseView checked:(BOOL)checked
{
    NSInteger nTag = tztUIBaseView.tag;
    nTag -= tztGroupRadioTag;
    if (nTag == _selectedIndex)//选择的还是当前的，取消选择
    {
        
    }
//    else
    {
        _selectedIndex = nTag;
        [self updateStates];
    }
    _selectedIndex = nTag;
    if (self.tztDelegate && [self.tztDelegate respondsToSelector:@selector(tztGroupRadioView:selectAtIndex:forState:)])
    {
        [self.tztDelegate tztGroupRadioView:self selectAtIndex:_selectedIndex forState:checked];
    }
}

@end
