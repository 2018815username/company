/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:         首页-小的排名界面
 * 文件标识:        
 * 摘要说明:        
 * 
 * 当前版本:        2.0
 * 作    者:       zhangxl
 * 更新日期:            
 * 整理修改:	
 *
 ***************************************************************/

#import "tztUIHomePageReportGridView.h"
#import "TZTUIReportViewController.h"

@implementation tztUIHomePageReportGridView
@synthesize pReportView = _pReportView;
@synthesize pEditView = _pEditView;
@synthesize pPageType = _pPageType;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) 
    {
        // Initialization code
    }
    return self;
}
-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    CGRect rcFrame = CGRectZero;
    rcFrame.size = frame.size;
    if (_pImageBG == NULL)
    {
        _pImageBG = [[UIImageView alloc] initWithImage:[UIImage imageTztNamed:@"TZTUIHomePageReport.png"]];
        _pImageBG.frame = rcFrame;
        [self addSubview:_pImageBG];
        [_pImageBG release];
    }else
        _pImageBG.frame = rcFrame;
    
    rcFrame = CGRectMake((frame.size.width - 80)/2, 10, 80, 20);
    
    if (_pTitle == NULL)
	{
		_pTitle = [[UILabel alloc]initWithFrame:rcFrame];
		_pTitle.font = [UIFont systemFontOfSize:20];
		_pTitle.textAlignment = UITextAlignmentLeft;
		_pTitle.adjustsFontSizeToFitWidth = YES;
		_pTitle.backgroundColor = [UIColor clearColor];
		_pTitle.textColor = [UIColor whiteColor];
		_pTitle.minimumFontSize = 14;
		[self addSubview:_pTitle];
        [_pTitle release];
	}else
	{
		_pTitle.frame = rcFrame;
	}
    
    UIImage *image = [UIImage imageTztNamed:@"TZTUIHomePageFullScreen.png"];
    rcFrame.size = CGSizeMake(30, 30);
	if (image)
		rcFrame.size = image.size;
    rcFrame.origin.x = frame.size.width - rcFrame.size.width - 5;
    rcFrame.origin.y = 5;
    if (_pBtFullScreen == NULL)
    {
        _pBtFullScreen = [UIButton buttonWithType:UIButtonTypeCustom];
		_pBtFullScreen.titleLabel.font = [UIFont systemFontOfSize:16.0f];
		[_pBtFullScreen setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
		[_pBtFullScreen addTarget:self action:@selector(OnButton:) forControlEvents:UIControlEventTouchUpInside];
        [_pBtFullScreen setTztBackgroundImage:image];
		_pBtFullScreen.frame = rcFrame;
		[self addSubview:_pBtFullScreen];
    }else
        _pBtFullScreen.frame = rcFrame;
    
    rcFrame = CGRectMake(2, 40, frame.size.width - 4, frame.size.height - 42);
    if (_pReportView == NULL)
    {
        _pReportView = [[tztReportListView alloc] init];
        _pReportView.tztdelegate = self;
        _pReportView.nsBackColor = @"1";
        _pReportView.frame = rcFrame;
        _pReportView.reportView.nMaxColNum = 3;
        [self addSubview:_pReportView];
        [_pReportView release];
    }else
    {
        _pReportView.frame = rcFrame;
    }
    
    if (_pPageType == HomePage_UserStock)
    {
        if (_pEditView == NULL)
        {
            _pEditView = [[tztUserStockEditView alloc] init];
            _pEditView.nsBackColor = @"1";
            _pEditView.frame = rcFrame;
            _pEditView.hidden = YES;
            [self addSubview:_pEditView];
            [_pEditView release];
        }else
            _pEditView.frame = rcFrame;
        
        UIImage *UserImage = [UIImage imageTztNamed:@"TZTUIHomePageButton.png"];
        rcFrame.size = CGSizeMake(30, 30);
        if (UserImage)
            rcFrame.size = UserImage.size;
        rcFrame.origin.x = 5;
        rcFrame.origin.y = 5;
        if (_pBtEdit == NULL)
        {
            _pBtEdit = [UIButton buttonWithType:UIButtonTypeCustom];
			_pBtEdit.titleLabel.font = [UIFont systemFontOfSize:16.0f];
			[_pBtEdit setTitle:@"编辑" forState:UIControlStateNormal];
			[_pBtEdit setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [_pBtEdit setTztBackgroundImage:UserImage];
			[_pBtEdit addTarget:self action:@selector(OnButton:) forControlEvents:UIControlEventTouchUpInside];
			_pBtEdit.frame = rcFrame;
			[self addSubview:_pBtEdit];
        }else
            _pBtEdit.frame = rcFrame;
    }
    
    if (_pPageType == HomePage_UserStock || _pPageType == HomePage_Edit)
    {
        _pTitle.text = @"我的自选";
    }else if(_pPageType == HomePage_HSAStock)
    {
        _pTitle.text = @"沪深A股";
    }else if(_pPageType == HomePage_GuoJiIndex)
    {
        _pTitle.text = @"关键指数";
        _pBtFullScreen.hidden = YES;
    }
    [self setBackgroundColor:[UIColor clearColor]];
}

-(void)OnButton:(id)sender
{
    UIButton *button = (UIButton *)sender;
    if (button == _pBtFullScreen)
    {
        if (_pPageType == HomePage_UserStock)
        {
            [g_pToolBarView OnDealToolBarAtIndex:1 options_:NULL];
        }
        else if(_pPageType == HomePage_HSAStock)
        {
            [g_pToolBarView OnDealToolBarAtIndex:3 options_:NULL];
            if ([g_navigationController.topViewController isKindOfClass:[TZTUIReportViewController class]])
            {
                TZTUIReportViewController * pVC = (TZTUIReportViewController *)g_navigationController.topViewController;
                pVC.pStrMenID = @"302";
            }
        }
        else if(_pPageType == HomePage_GuoJiIndex)
        {
//            [g_pToolBarView OnDealToolBarPaiMing:@"701"];
        }
    }
    else if(button == _pBtEdit)
    {
        if (_pPageType == HomePage_UserStock)
        {
            [_pBtEdit setTitle:@"完成" forState:UIControlStateNormal];
            _pPageType = HomePage_Edit;
            _pReportView.hidden = YES;
            _pEditView.hidden = NO;
            [self LoadPage];
        }
        else if(_pPageType == HomePage_Edit)
        {
            [_pBtEdit setTitle:@"编辑" forState:UIControlStateNormal];
            _pPageType = HomePage_UserStock;
            _pReportView.hidden = NO;
            _pEditView.hidden = YES;
            [_pEditView SaveUserStock];
            [self LoadPage];
        }
    }
}

-(void)LoadPage
{
     tztStockInfo *pStock = NewObjectAutoD(tztStockInfo);
    if (_pPageType == HomePage_UserStock)
    {
        _pReportView.reqAction = @"60";
        //modify by yinjp 20130711
        NSString* str = [tztUserStock GetNSUserStock];
        if (str.length <= 0)
        {
            //iPad取配置的默认自选，因为首页显示的时候，用户可能还没有进行过系统登陆，需要用户自己手动去下载
            [tztUserStock SaveUserStockArray:(NSMutableArray*)[g_pSystermConfig ayDefaultUserStock]];
            str = [tztUserStock GetNSUserStock];
        }
        //
        pStock.stockCode = str;
    }
    else if(_pPageType == HomePage_Edit)
    {
        [_pEditView LoadUserStock];
        return;
    }
    else if(_pPageType == HomePage_HSAStock)
    {
        _pReportView.reqAction = @"20191";
        pStock.stockCode = @"1101,1201,1206,120B"; 
    }else if(_pPageType == HomePage_GuoJiIndex)
    {
        _pReportView.reqAction = @"20400";
    }
    [_pReportView setStockInfo:pStock Request:1];
}

-(void)tzthqView:(id)hqView setStockCode:(tztStockInfo*)pStock
{
    tztReportListView * View = (tztReportListView *)hqView;
    if (View == _pReportView)
    {
        [g_pToolBarView OnDealToolBarAtIndex:1 options_:NULL];
        if ([g_navigationController.topViewController isKindOfClass:[TZTUIReportViewController class]])
        {
            TZTUIReportViewController * pVC = (TZTUIReportViewController *)g_navigationController.topViewController;
            pVC.bFlag = NO;
            pVC.pStockInfo = pStock;
            [pVC.pStockDetailView SetStockCode:pStock];
            [pVC.tztTitleView setCurrentStockInfo:pStock.stockCode nsName_:pStock.stockName];
        }
    }
}
@end
