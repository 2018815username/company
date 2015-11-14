//
//  RootViewController.m
//  tztMobileApp
//
//  Created by yangdl on 12-11-30.
//  Copyright 2012 投资堂. All rights reserved.
//

#import "TztViewController.h"

@implementation TztViewController

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CGRect rcTitle = self.view.bounds;
    rcTitle.size.height = TZTToolBarHeight;
    if(_tztTitleView == nil)
    {
        _tztTitleView = [[TZTUIBaseTitleView alloc] init];
        _tztTitleView.pDelegate = self;
        [self.view addSubview:_tztTitleView];
        [_tztTitleView release];
    }
    _tztTitleView.nType = TZTTitleSetButton;
    _tztTitleView.frame = rcTitle;
    
    rcTitle.origin.x += 5;
    rcTitle.size.width -= 10;
    rcTitle.origin.y += TZTToolBarHeight;
    if(_weblable == nil)
    {
        _weblable = [[UILabel alloc] init];
        _weblable.backgroundColor = [UIColor clearColor];
        _weblable.textColor = [UIColor whiteColor];
        [self.view addSubview:_weblable];
        [_weblable release];
    }
    _weblable.text = [NSString stringWithFormat:@"127.0.0.1:%d",[[tztlocalHTTPServer getShareInstance] port]];
    _weblable.frame = rcTitle;
    
    if(_textview == nil)
    {
        _textview = [[UITextField alloc] init];
        _textview.borderStyle = UITextBorderStyleRoundedRect;
        _textview.layer.borderColor = [UIColor whiteColor].CGColor;
        _textview.layer.borderWidth = 0.5;
        _textview.layer.cornerRadius = 5.0;
        _textview.backgroundColor = [UIColor whiteColor];
        _textview.keyboardType = UIKeyboardTypeURL;
        [self.view addSubview:_textview];
        [_textview release];
    }
    _textview.text = @"zllcajax/kh/kh_warmtip.htm";
    rcTitle.origin.y += TZTToolBarHeight + 5;
    rcTitle.size.height = TZTToolBarHeight * 3;
    rcTitle.size.width -= (rcTitle.origin.x + 50);
    _textview.frame = rcTitle;
    
    rcTitle.origin.x += rcTitle.size.width + 5;
    rcTitle.size.width = 40;
    rcTitle.size.height = 30;
    UIButton* btnSend = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btnSend.frame = rcTitle;
    [btnSend setTitle:@"确定" forState:UIControlStateNormal];
    [btnSend addTarget:self action:@selector(onClickUrl:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnSend];
    
    rcTitle.origin.y += rcTitle.size.height + 5;
    UIButton* btnBack = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btnBack.frame = rcTitle;
    [btnBack setTitle:@"返回" forState:UIControlStateNormal];
    [btnBack addTarget:self action:@selector(onClickBack:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnBack];
    
    rcTitle = self.view.bounds;
    
    _webView = [[tztBaseUIWebView alloc] init];
    rcTitle.origin.y += TZTToolBarHeight;
    rcTitle.size.height -= rcTitle.origin.y;
    _webView.frame = rcTitle;
    _webView.tztDelegate = self;
    _webView.hidden = YES;
    [_tztTitleView setTitle:@"设置地址"];
    [self.view addSubview:_webView];
    [_webView release];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)onClickBack:(id)sender
{
    [self OnReturnBack];
}

- (void)onClickUrl:(id)sender
{
    [_textview resignFirstResponder];
    NSString* strURL = [_textview text];
    NSString* strAdd = _weblable.text;
    if (strURL && [strURL length] > 0)
    {
        if(![strURL hasPrefix:@"http://"])
        {
            strURL = [NSString stringWithFormat:@"http://%@/%@",strAdd,strURL];
        }
        if (_webView)
        {
            _webView.hidden = NO;
            [_webView setWebURL:strURL];
        }
        
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)OnReturnBack
{
    if (_webView && [_webView OnReturnBack])
    {
        if(_tztTitleView)
            [_tztTitleView setTitle:[_webView getWebTitle]];
    }
    else if(!_webView.hidden)
    {
        _webView.hidden = YES;
        [_tztTitleView setTitle:@"设置地址"];
    }
    else
    {
        [TZTUIBaseVCMsg OnMsg:HQ_Return wParam:0 lParam:0];
    }
}

- (void)OnSetButton:(id)sender
{
    _webView.hidden = YES;
    [_tztTitleView setTitle:@"设置地址"];
}

-(void)tztWebView:(tztHTTPWebView *)webView withTitle:(NSString *)title
{
    if(_tztTitleView)
        [_tztTitleView setTitle:title];
}

@end

