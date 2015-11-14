//
//  tztUIRZRQCrashRetuenViewController.m
//  tztMobileApp_xcsc
//
//  Created by x yt on 13-4-19.
//  Copyright (c) 2013年 11111. All rights reserved.
//

#import "tztUIRZRQCrashRetuenViewController.h"

@implementation tztUIRZRQCrashRetuenViewController

@synthesize pCrashReturn = _pCrashReturn;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) 
    {
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle
-(void)viewDidLoad
{
    [super viewDidLoad];
    [self LoadLayoutView];
//    if (_pCrashReturn)
//        [_pCrashReturn OnRequestData];
}

-(void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)LoadLayoutView
{
    CGRect rcFrame = _tztBounds;
    //标题view
    NSString* strTitle = GetTitleByID(_nMsgType);
    if (!ISNSStringValid(strTitle))
        strTitle = @"直接还券";
    self.nsTitle = [NSString stringWithFormat:@"%@", strTitle];
    [self onSetTztTitleView:self.nsTitle type:TZTTitleReport];
    
    CGRect rcSearch = rcFrame;
    rcSearch.origin.y += _tztTitleView.frame.size.height;
    if (!g_pSystermConfig.bShowbottomTool)
    {
        rcSearch.size.height -= _tztTitleView.frame.size.height;
    }else
    {
        rcSearch.size.height -= (_tztTitleView.frame.size.height + TZTToolBarHeight);
    }
    
    if (_pCrashReturn == nil) 
    {
        _pCrashReturn = [[tztRZRQCrashRetuen alloc] init];
        _pCrashReturn.delegate = self;
        _pCrashReturn.nMsgType = _nMsgType;
        _pCrashReturn.frame = rcSearch;
        [_tztBaseView addSubview:_pCrashReturn];
        [_pCrashReturn release];
    }
    else
    {
        _pCrashReturn.frame = rcSearch;
    }
    
    if (g_pSystermConfig && g_pSystermConfig.bNSearchFuncJY)
        self.tztTitleView.fourthBtn.hidden = YES;
    [_tztBaseView bringSubviewToFront:_tztTitleView];
    [self CreateToolBar];
}

-(void)CreateToolBar
{
    if (!g_pSystermConfig.bShowbottomTool)
        return;
   
    [super CreateToolBar];
    NSMutableArray *pAy = NewObject(NSMutableArray);
    [pAy addObject:@"确定|6801"];
    [pAy addObject:@"刷新|6802"];
    [pAy addObject:@"返回|3599"];
    [tztUIBarButtonItem GetToolBarItemByArray:pAy delegate_:self forToolbar_:toolBar];
    DelObject(pAy);
}

-(void)OnToolbarMenuClick:(id)sender
{
    BOOL bDeal = FALSE;
    if (_pCrashReturn)
    {
        bDeal = [_pCrashReturn OnToolbarMenuClick:sender];
    }
    
    if (!bDeal)
        [super OnToolbarMenuClick:sender];
}

@end
