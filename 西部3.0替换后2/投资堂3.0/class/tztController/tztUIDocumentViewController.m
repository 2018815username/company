/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:        tztUIDocumentViewCotroller
 * 文件标识:
 * 摘要说明:        文档打开显示vc
 *
 * 当前版本:        1.0
 * 作    者:       Yinjp
 * 更新日期:        20140603
 * 整理修改:
 *
 ***************************************************************/

#import "tztUIDocumentViewController.h"

@interface tztUIDocumentViewController ()<UIWebViewDelegate>

/**
 *	用于展示具体信息的webview
 */
@property(nonatomic,retain)UIWebView    *pWebView;

/**
 *	纪录打开的文件路径，查看完成后，需要删除该文件，避免本地堆积
 */
@property(nonatomic,retain)NSString     *nsFilePath;

@end

@implementation tztUIDocumentViewController
@synthesize pWebView = _pWebView;


/**
 *	单一实例处理，保证只有一个vc
 *
 *	@return	tztUIDocumentViewController对象
 */
+(tztUIDocumentViewController*)getShareInstance

{
    static dispatch_once_t once;
    static tztUIDocumentViewController *sharedView;
    dispatch_once(&once, ^{ sharedView = [[tztUIDocumentViewController alloc] init];
    });
    return sharedView;
}

-(void)freeShareInstance
{
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(OnOpenDocument:)
//                                                 name: TZTNotifi_OpenDocument
//                                               object: nil];
    
    [self LoadLayoutView];
}

-(void)LoadLayoutView
{
    CGRect rcFrame = self.view.frame;
    [self onSetTztTitleView:@"资讯详情" type:TZTTitleReturn];
    
    rcFrame.origin.y = self.tztTitleView.frame.origin.y + self.tztTitleView.frame.size.height + (IS_TZTIOS(7) ? 20 : 0);
    rcFrame.size.height -= (self.tztTitleView.frame.origin.y + self.tztTitleView.frame.size.height + (IS_TZTIOS(7) ? 20 : 0));
    
    if (_pWebView == NULL)
    {
        _pWebView = [[UIWebView alloc] initWithFrame:rcFrame];
        _pWebView.backgroundColor = [UIColor whiteColor];
        _pWebView.delegate = self;
        _pWebView.scalesPageToFit = TRUE;
        [self.view addSubview:_pWebView];
        [_pWebView release];
    }
    else
    {
        _pWebView.frame = rcFrame;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

/**
 *	删除指定路径名称的文件
 *
 *	@param 	strFileName 	完整路径的文件名称
 */
-(void)DeleteSavedFile:(NSString*)strFileName
{
    NSFileManager *defaultManager;
    defaultManager = [NSFileManager defaultManager];
    
    NSError *error = NULL;
    [defaultManager removeItemAtPath:strFileName error:&error];
}

-(void)OnReturnBack
{
    [self DeleteSavedFile:self.nsFilePath];
    [TZTUIBaseVCMsg IPadPopViewController:Nil];
}

-(void)OpenDocumentWithURL:(NSString *)nsURL
{
    CGRect rcFrame = self.view.frame;
    
    rcFrame.origin.y = self.tztTitleView.frame.origin.y + self.tztTitleView.frame.size.height + (IS_TZTIOS(7) ? 20 : 0);
    rcFrame.size.height -= (self.tztTitleView.frame.origin.y + self.tztTitleView.frame.size.height + (IS_TZTIOS(7) ? 20 : 0) );
    
    if (_pWebView)
    {
        [_pWebView removeFromSuperview];
        _pWebView = nil;
    }
    
    if (_pWebView == NULL)
    {
        self.pWebView = [[UIWebView alloc] initWithFrame:rcFrame];
        self.pWebView.delegate = self;
        self.pWebView.scalesPageToFit = TRUE;
        self.pWebView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:self.pWebView];
    }
    else
    {
        self.pWebView.frame = rcFrame;
    }
    
    NSURL* urlStr = [NSURL URLWithString:nsURL];
    
    [self.pWebView loadRequest:[NSURLRequest requestWithURL:urlStr]];
}

-(void)OpenDocument:(NSNotification *)notification
{
    if (notification && [notification.name compare:TZTNotifi_OpenDocument] == NSOrderedSame)
    {
        NSString* str = (NSString*)notification.object;
        
        self.nsFilePath = [NSString stringWithFormat:@"%@", str];
        CGRect rcFrame = self.view.frame;
        
        rcFrame.origin.y = self.tztTitleView.frame.origin.y + self.tztTitleView.frame.size.height + (IS_TZTIOS(7) ? 20 : 0);
        rcFrame.size.height -= (self.tztTitleView.frame.origin.y + self.tztTitleView.frame.size.height + (IS_TZTIOS(7) ? 20 : 0) );
        if (_pWebView == NULL)
        {
            self.pWebView = [[UIWebView alloc] initWithFrame:rcFrame];
            self.pWebView.delegate = self;
            self.pWebView.scalesPageToFit = TRUE;
            self.pWebView.backgroundColor = [UIColor redColor];
            [self.view addSubview:self.pWebView];
        }
        else
        {
            self.pWebView.frame = rcFrame;
        }
        
        NSURL* urlStr = [NSURL fileURLWithPath:self.nsFilePath];
        
        [self.pWebView loadRequest:[NSURLRequest requestWithURL:urlStr]];
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    
    [tztUIProgressView hidden];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSLog(@"%@",error);
    [tztUIProgressView hidden];
}

-(void)webViewDidStartLoad:(UIWebView *)webView
{
    [tztUIProgressView showWithMsg:@"正在打开文件..." withdelegate:self];
}


-(void)tztUIProgressViewCancel:(tztUIProgressView *)tztProgressView
{
    [tztUIProgressView hidden];
}
@end
