/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:        ipad三板行情选择界面
 * 文件标识:        
 * 摘要说明:        
 * 
 * 当前版本:        2.0
 * 作    者:       xyt
 * 更新日期:            
 * 整理修改:	
 *
 ***************************************************************/
#import "tztSBTradeTopHQSelectView.h"
enum
{
    kTagType = 1000,//选择类型
    kTagCode,       //输入代码
    kTagBtn = 2000,//查询按钮
};

@implementation tztSBTradeTopHQSelectView
@synthesize tztSBHQView = _tztSBHQView;
@synthesize pAySelectType = _pAySelectType;
@synthesize pAyType = _pAyType;
@synthesize pDelegate = _pDelegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _pAySelectType = NewObject(NSMutableArray);
        _pAyType = NewObject(NSMutableArray);
        [_pAySelectType addObject:@"查询全部"];
        [_pAyType addObject:@""];        
        [_pAySelectType addObject:@"定价买入"];
        [_pAyType addObject:@"OB"];
        [_pAySelectType addObject:@"定价卖出"];  
        [_pAyType addObject:@"OS"];
        [_pAySelectType addObject:@"意向买入"];
        [_pAyType addObject:@"HB"];
        [_pAySelectType addObject:@"意向卖出"];    
        [_pAyType addObject:@"HS"];   
        
        m_nSelectType = 0;
    }
    return self;
}


-(void)dealloc
{
    DelObject(_pAySelectType);
    DelObject(_pAyType);
    [super dealloc];
}

-(void)setFrame:(CGRect)frame
{
    if (CGRectIsNull(frame) || CGRectIsEmpty(frame))
        return;
    
    [super setFrame:frame];
    
    CGRect rcFrame = self.bounds;
    
    if (_tztSBHQView == NULL)
    {
        _tztSBHQView = NewObject(tztUIVCBaseView);
        _tztSBHQView.tztDelegate = self;
        _tztSBHQView.frame = rcFrame;
        [_tztSBHQView setTableConfig:@"tztUISBHQSelectSetting"];
        [self addSubview:_tztSBHQView];
        [_tztSBHQView release];
    }
    else
    {
        _tztSBHQView.frame = rcFrame;
    }
    
    [self SetDefaultData];
}

-(void)SetDefaultData
{
    if (_tztSBHQView == NULL)
        return;
    
    UIView* pView = [_tztSBHQView getViewWithTag:kTagType];
    CGRect rc = pView.frame;
    
    UIButton *pBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    pBtn.frame = rc;
    [pBtn addTarget:self action:@selector(OnSelectAccount) forControlEvents:UIControlEventTouchUpInside];
    [pBtn setBackgroundColor:[UIColor clearColor]];
    [self addSubview:pBtn];
    [self sendSubviewToBack:pView];
    
    [_tztSBHQView setEditorText:@"查询全部" nsPlaceholder_:nil withTag_:kTagType];
    
}

-(void)ShowComboxView:(int)nID nsTitle:(NSString*)nsTitle
{
    CGRect rect = [[UIScreen mainScreen] bounds];
    TZTCMyComboxView *pView = NULL;
    switch (nID) {
        case 0:
        {
            UIView* pViewBtn = [_tztSBHQView getViewWithTag:kTagType];
            CGRect rc = pViewBtn.frame;
            
            rc.origin.x = [pViewBtn gettztwindowx:nil] + pViewBtn.frame.size.width / 2;
            rc.origin.y = [pViewBtn gettztwindowy:nil] + pViewBtn.frame.size.height;
            
            pView =  [[TZTCMyComboxView alloc]initWithFrame:rect FromRect:rc];
            [pView SetCombox:0 ayData:_pAySelectType nDefault:m_nSelectType];
        }
            break;
        default:
            return;
    };
	
    if (pView)
    {
        [pView setDelegate:self];
        [pView setTitle:nsTitle];
        
        [self addSubview:pView];
        [pView release];
    }
    return;
}

-(void) OnSelectAccount
{
    [self ShowComboxView:0 nsTitle:@"选择查询类型"];
}

//TZTCMyComboxView 返回消息
-(void) OnComboxSel:(unsigned int)nID nSel:(int)nSelectIndex nsText:(NSString*)nsSelectText
{
    switch (nID) {
        case 0:
		{
			m_nSelectType = nSelectIndex;
            if (m_nSelectType >= 0 && m_nSelectType < [_pAySelectType count])
            {
                NSLog(@"%@",[_pAySelectType objectAtIndex:m_nSelectType]);
                [_tztSBHQView setEditorText:[_pAySelectType objectAtIndex:m_nSelectType] nsPlaceholder_:nil withTag_:kTagType];
            }
            
            break;
		}
        default:
            return ;
    };
    return;
}

-(void)OnButtonClick:(id)sender
{
    if(_tztSBHQView)
    {
        NSString* nsStock = [_tztSBHQView GetEidtorText:kTagCode];
        if (nsStock == NULL)
            nsStock = @"";
        NSString* nsType = [_pAyType objectAtIndex:m_nSelectType];
        
        if (_pDelegate && [_pDelegate respondsToSelector:@selector(SetSelectType:_nsType:)])
        {
            [_pDelegate tztperformSelector:@"SetSelectType:_nsType:" withObject:nsStock withObject:nsType];
//            [_pDelegate SetSelectType:nsStock _nsType:nsType];
        }
    }
}

@end
