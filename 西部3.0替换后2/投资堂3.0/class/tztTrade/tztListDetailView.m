/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:        交易详情显示
 * 文件标识:        
 * 摘要说明:        
 * 
 * 当前版本:        2.0
 * 作    者:       yinjp
 * 更新日期:            
 * 整理修改:	
 *
 ***************************************************************/
#import "tztListDetailView.h"

@implementation tztListDetailView
//@synthesize pDetailTableView = _pDetailTableView;
@synthesize pAyTitle = _pAyTitle;
@synthesize pAyContent = _pAyContent;
@synthesize tztdelegate = _tztdelegate;

-(id)init
{
    if (self = [super init])
    {
        if(!g_nHQBackBlackColor)
        {
//            self.backgroundColor = [UIColor colorWithRed:250.0/255.0 green:250.0/255.0 blue:250.0/255.0 alpha:1.0];
        }   
    }
    return self;
}

-(void)dealloc
{
    DelObject(_pAyTitle);
    DelObject(_pAyContent);
    [super dealloc];
}


-(void)setFrame:(CGRect)frame
{
    if (CGRectIsEmpty(frame) || CGRectIsNull(frame))
        return;
    
    [super setFrame:frame];
    
    self.backgroundColor = [UIColor tztThemeBackgroundColorJY];
    CGRect rcFrame = self.bounds;
    if(_detailview == nil)
    {
        _detailview = NewObject(tztUIBaseControlsView);
        _detailview.backgroundColor = [UIColor tztThemeBackgroundColorJY];
        _detailview.layer.borderWidth = 0;
        _detailview.bDetailShow = TRUE;
        [_detailview setNRadius:0];
        _detailview.bAutoCalcul = 0;
        [self addSubview:_detailview];
        [_detailview release];
    }
//    rcFrame.origin.x = 10;
//    rcFrame.origin.y = 5;
//    rcFrame.size.width -= 20;
//    rcFrame.size.height -= 20;
    _detailview.frame = rcFrame;
    
    if (!g_nJYBackBlackColor)
    {
        [_detailview setClBackground:[UIColor whiteColor]];
    }
}

-(void)SetDetailData:(NSArray *)ayTitle ayContent_:(NSArray *)ayContent
{
    if (_pAyTitle == NULL)
        _pAyTitle = NewObject(NSMutableArray);
    if (_pAyContent == NULL)
        _pAyContent = NewObject(NSMutableArray);
    
    [_pAyTitle removeAllObjects];
    [_pAyContent removeAllObjects];
    
    
    for (int i = 0; i < [ayTitle count]; i++)
    {
        TZTGridDataTitle *pTitle = [ayTitle objectAtIndex:i];
        if (pTitle && pTitle.text)
        {
            [_pAyTitle addObject:pTitle.text];
        }
        else
            [_pAyTitle addObject:@""];
    }
    for (int i = 0; i < [ayContent count]; i++)
    {
        TZTGridData *pData = [ayContent objectAtIndex:i];
        if (pData && pData.text)
        {
            [_pAyContent addObject:pData.text];
        }
        else
            [_pAyContent addObject:@""];
    }
    
    self.contentOffset = CGPointMake(0, 0);
    if(_detailview)
        [_detailview setListViewData:_pAyTitle withdata:_pAyContent];

    CGRect rcFrame = _detailview.frame;
    rcFrame.size.height = self.bounds.size.height - 20;
    if (_detailview.frame.size.height != rcFrame.size.height)
    {
        self.contentSize = _detailview.frame.size;
    }
}

-(void)SetDetailData:(NSArray *)ayContent
{
    if (_pAyContent == NULL)
        _pAyContent = NewObject(NSMutableArray);
    
    [_pAyContent removeAllObjects];
    for (int i = 0; i < [ayContent count]; i++)
    {
        TZTGridData *pData = [ayContent objectAtIndex:i];
        if (pData && pData.text)
        {
            [_pAyContent addObject:pData.text];
        }
        else
            [_pAyContent addObject:@""];
    }
    
    self.contentOffset = CGPointMake(0, 0);
    //需要重新创建，因为高度可能不一样，会调整
    if(_detailview)
        [_detailview setListViewData:_pAyTitle withdata:_pAyContent];
//        [_detailview setListViewData:_pAyContent];
    
    CGRect rcFrame = _detailview.frame;
    rcFrame.size.height = self.bounds.size.height - 20;
    if (_detailview.frame.size.height != rcFrame.size.height)
    {
        self.contentSize = _detailview.frame.size;
    }
    self.contentOffset = CGPointMake(0, 0);
}

-(BOOL)OnToolbarMenuClick:(id)sender
{
//    UIButton *pBtn = (UIButton*)sender;
    return FALSE;
}

-(void)OnReturnBack
{
    [_tztdelegate tztperformSelector:@"setToolBarBtn"];
    [self removeFromSuperview];
}
@end
