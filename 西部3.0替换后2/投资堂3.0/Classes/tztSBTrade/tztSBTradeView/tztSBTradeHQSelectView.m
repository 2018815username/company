/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:		tztSBTradeHQSelectView
 * 文件标识:
 * 摘要说明:		股转系统行情选择界面
 *
 * 当前版本:	2.0
 * 作    者:	zhangxl
 * 更新日期:
 * 整理修改:
 *
 ***************************************************************/
#import "tztSBTradeHQSelectView.h"

@implementation tztSBTradeHQSelectView
@synthesize tztTradeView = _tztTradeView;
@synthesize ayType = _ayType;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _ayType = NewObject(NSMutableArray);

        
        [_ayType addObject:@"定价买入"];
        [_ayType addObject:@"定价卖出"];
        if ([g_pSystermConfig.strMainTitle isEqualToString:@"西部信天游"] ) {
            return self;
        }
        [_ayType addObject:@"查询全部"];
        [_ayType addObject:@"限价买入"];
        [_ayType addObject:@"限价卖出"];
        
    }
    return self;
}
-(void)dealloc
{
    [super dealloc];
//    DelObject(_ayType);
}
-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    if (CGRectIsEmpty(frame) || CGRectIsNull(frame))
        return;
    
    [super setFrame:frame];
    
    CGRect rcFrame = self.bounds;
    
    if (_tztTradeView == NULL)
    {
        _tztTradeView = NewObject(tztUIVCBaseView);
        _tztTradeView.tztDelegate = self;
        _tztTradeView.tableConfig = @"tztUISBTradeSelectHQ";
        _tztTradeView.frame = rcFrame;
        [self addSubview:_tztTradeView];
        [_tztTradeView release];
        [_tztTradeView setComBoxData:_ayType ayContent_:_ayType AndIndex_:0 withTag_:1000];
    }else
        _tztTradeView.frame = rcFrame;
}

-(BOOL)OnToolbarMenuClick:(id)sender
{
    UIButton* pBtn = (UIButton*)sender;
    if (pBtn == NULL)
        return FALSE;
    if (pBtn.tag == TZTToolbar_Fuction_Clear)
    {
        [_tztTradeView setEditorText:@"" nsPlaceholder_:NULL withTag_:2000];
        return TRUE;
    }
    return FALSE;
}

-(void)OnButtonClick:(id)sender
{
    tztUIButton* pBtn = (tztUIButton*)sender;
    switch ([pBtn.tzttagcode intValue])
    {
        case 6000:
        {
            if (_pDelegate && [_pDelegate respondsToSelector:@selector(OnOK)])
            {
                [_pDelegate OnOK];
            }
        }
            break;
        case 6001:
        {
            [g_navigationController popViewControllerAnimated:UseAnimated];
            //返回，取消风火轮显示
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            UIViewController* pTop = g_navigationController.topViewController;
            if (![pTop isKindOfClass:[TZTUIBaseViewController class]])
            {
                g_navigationController.navigationBar.hidden = NO;
                [[TZTAppObj getShareInstance] setMenuBarHidden:NO animated:YES];
            }
//            [g_navigationController popViewControllerAnimated:UseAnimated];
        }
            break;
            
        default:
            break;
    }
}
@end
