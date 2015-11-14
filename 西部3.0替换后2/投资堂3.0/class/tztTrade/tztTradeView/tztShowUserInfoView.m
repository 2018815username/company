//
//  tztShowUserInfoView.m
//  tztMobileApp_yyz
//
//  Created by 张 小龙 on 13-5-29.
//
//

#import "tztShowUserInfoView.h"
@implementation tztShowUserInfoView

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
    
    CGRect rcFrame = frame;
    rcFrame.origin = CGPointMake(10, 10);
    rcFrame.size.height -= 20;
    rcFrame.size.width -= 20;
    if (_pDetailView == NULL)
    {
        _pDetailView = [[tztListDetailView alloc] init];
        _pDetailView.delegate = self;
        _pDetailView.frame = rcFrame;
        [self SetDefaultData];
        [self addSubview:_pDetailView];
        [_pDetailView release];
    }else
        _pDetailView.frame = rcFrame;
}
-(void)SetDefaultData
{
    if ([g_ayJYLoginInfo count] < 1)
    {
        return;
    }
    
    tztJYLoginInfo *pCurjy = [tztJYLoginInfo GetCurJYLoginInfo:TZTAccountPTType];
    
    if (pCurjy == NULL)
    {
        return;
    }
    NSMutableArray* ayTitle = NewObject(NSMutableArray);
    NSMutableArray* ayContent = NewObject(NSMutableArray);
    if (pCurjy == NULL)
    {
        [ayTitle addObject:@"账户名称"];
        [ayContent addObject:@""];
        [ayTitle addObject:@"资金账号"];
        [ayContent addObject:@""];
        [ayTitle addObject:@"营业部"];
        [ayContent addObject:@""];
    }else
    {
        [ayTitle addObject:@"账户名称"];
        [ayContent addObject:pCurjy.nsUserName];
        
        [ayTitle addObject:@"资金账号"];
        [ayContent addObject:pCurjy.nsAccount];
        
        [ayTitle addObject:@"营业部"];
        [ayContent addObject:pCurjy.ZjAccountInfo.nsCellName];
    }
    [self SetDetail:ayTitle GridData:ayContent];
    [ayTitle release];
    [ayContent release];
}

-(void)SetDetail:(NSMutableArray *)title GridData:(NSMutableArray *)Data
{
    //    if (title == NULL || [title count] < 1 || Data == NULL || [Data count] < 1 || [title count] != [Data count])
    //        return;
    
    UIColor *color = [UIColor blackColor];
    if (g_nJYBackBlackColor)
    {
        color = [UIColor whiteColor];
    }
    
    NSMutableArray* ayTitle = NewObject(NSMutableArray);
    NSMutableArray* ayContent = NewObject(NSMutableArray);
    for (int i = 0; i < [title count]; i++)
    {
        TZTGridDataTitle *titledata = NewObject(TZTGridDataTitle);
        titledata.text = [title objectAtIndex:i];
        titledata.textColor = color;
        [ayTitle addObject:titledata];
        [titledata release];
        
        TZTGridData *Griddata = NewObject(TZTGridData);
        Griddata.text = [Data objectAtIndex:i];
        Griddata.textColor = color;
        [ayContent addObject:Griddata];
        [Griddata release];
    }
    [_pDetailView SetDetailData:ayTitle ayContent_:ayContent];
    DelObject(ayTitle);
    DelObject(ayContent);
}
@end
