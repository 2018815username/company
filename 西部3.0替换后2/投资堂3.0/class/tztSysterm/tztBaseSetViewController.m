//
//  tztBaseSetViewController.m
//  tztMobileApp
//
//  Created by yangares on 13-5-19.
//
//

#import "tztBaseSetViewController.h"
#import "tztSendToFriendView.h"
#import "tztServerSettingView.h"
#import "tztHQSetView.h"
#import "tztKLineSetView.h"
#import "tztCheckServerListView.h"
#import "tztSystemSettingView.h"
@implementation tztUIBaseSetView
@synthesize tztTableView = _tztTableView;
@synthesize tableConfig = _tableConfig;
-(id)init
{
    if (self = [super init])
    {
    }
    return self;
}

-(void)dealloc
{
    [self onReadWriteSettingValue:FALSE];
    [super dealloc];
}

-(void)setFrame:(CGRect)frame
{
    if (CGRectIsNull(frame) || CGRectIsEmpty(frame))
        return;
    [super setFrame:frame];
    
    CGRect rcFrame = self.bounds;
    if (g_nSkinType == 0) {
        rcFrame = CGRectInset(rcFrame,10,5);
    }
    
    if (IS_TZTIPAD) //调整iPad版本的宽度
        rcFrame.size.width = CGRectGetWidth(rcFrame) / 2;
    
    if (_tztTableView == nil)
    {
        _tztTableView = [[tztUIVCBaseView alloc] initWithFrame:rcFrame];
        _tztTableView.tztDelegate = self;
        [self addSubview:_tztTableView];
        [_tztTableView release];
    }
    else
    {
        _tztTableView.frame = rcFrame;
    }
    [_tztTableView setTableConfig:self.tableConfig];
    [self onReadWriteSettingValue:YES];
    self.backgroundColor = [UIColor tztThemeBackgroundColor];//
}

- (void)onSetTableConfig:(NSString*)strConfig
{
    self.tableConfig = strConfig;
    if(self.tableConfig && [self.tableConfig length] > 0 && _tztTableView)
    {
        [_tztTableView setTableConfig:self.tableConfig];
        [self onReadWriteSettingValue:YES];
    }
}

- (void)onReadWriteSettingValue:(BOOL)bRead
{
    
}

@end

@implementation tztBaseSetViewController
@synthesize tztSetView = _tztSetView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        tztSetViewClass = [tztUIBaseSetView class];
    }
    return self;
}

- (id)init
{
    self = [super init];
    if (self)
    {
        tztSetViewClass = [tztUIBaseSetView class];
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self LoadLayoutView];
    [self setNMsgType:_nMsgType];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

-(void)dealloc
{
    [super dealloc];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (_tztSetView)
    {
        [_tztSetView onReadWriteSettingValue:YES];
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (_tztSetView)
    {
        [_tztSetView onReadWriteSettingValue:NO];
    }
}

- (void)setNMsgType:(NSInteger)nMsgType
{
    _nMsgType = nMsgType;
    
    NSString* strTitle = GetTitleByID(nMsgType);
    switch (_nMsgType) {
        case Sys_Menu_SendToFriend:
        {
            [self setTztSetViewClass:[tztSendToFriendView class]];
            if (ISNSStringValid(strTitle))
                [self setTitle:strTitle];
            else
                [self setTitle:@"好友推荐"];
        }
            break;
        case Sys_Menu_SetServer:
        case MENU_SYS_SerAddSet:
        {
           [self setTztSetViewClass:[tztServerSettingView class]];
            if (ISNSStringValid(strTitle))
                [self setTitle:strTitle];
            else
                [self setTitle:@"服务器设置"];
        }
            break;
        case Sys_Menu_HQSet:
        {
            [self setTztSetViewClass:[tztHQSetView class]];
            if (ISNSStringValid(strTitle))
                [self setTitle:strTitle];
            else
                [self setTitle:@"行情设置"];
        }
            break;
        case Sys_Menu_KLineSet:
        {
            [self setTztSetViewClass:[tztKLineSetView class]];
            if (ISNSStringValid(strTitle))
                [self setTitle:strTitle];
            else
                [self setTitle:@"K线设置"];
        }
            break;
        case Sys_Menu_CheckServer:
        case MENU_SYS_SerAddCheck:
        {
            [self setTztSetViewClass:[tztCheckServerListView class]];
            if (ISNSStringValid(strTitle))
                [self setTitle:strTitle];
            else
                [self setTitle:@"服务器测速"];
        }
            break;
        case Sys_Menu_SystemSetting:
        case MENU_SYS_System:
        {
            [self setTztSetViewClass:[tztSystemSettingView class]];
            if (ISNSStringValid(strTitle))
                [self setTitle:strTitle];
            else
                [self setTitle:@"行情设置"];
        }
        default:
            break;
    }
}

-(void)OnBtnAddStock:(id)sender
{
    if(_nMsgType == Sys_Menu_SetServer || _nMsgType == MENU_SYS_SerAddSet)
    {
        [TZTUIBaseVCMsg OnMsg:Sys_Menu_CheckServer wParam:0 lParam:0];
    }
}

- (void)setTztSetViewClass:(Class)viewClass
{
    tztSetViewClass = viewClass; 
}

- (void)LoadLayoutView
{
    CGRect rcFrame = _tztBounds;

    if(_nMsgType == Sys_Menu_SetServer || _nMsgType == MENU_SYS_SerAddSet)
    {
        [self onSetTztTitleView:self.nsTitle type:TZTTitleAdd];
    }
    else
    {
        [self onSetTztTitleView:self.nsTitle type:TZTTitleName];
#ifdef TZT_JYSC
        [self onSetTztTitleView:self.nsTitle type:TZTTitleReturn];
#endif
    }
    
    CGRect rcServer = rcFrame;
    rcServer.origin.y += _tztTitleView.frame.size.height;
    rcServer.size.height -= _tztTitleView.frame.size.height;
    if (_tztSetView == NULL)
    {
        _tztSetView = (tztUIBaseSetView *)[[tztSetViewClass alloc] init];
        _tztSetView.frame = rcServer;
        [_tztBaseView addSubview:_tztSetView];
#ifdef Support_HTSC
        _tztSetView.backgroundColor = [UIColor colorWithTztRGBStr:@"121,121,121"];
#endif
        [_tztSetView release];
    }
    else
        _tztSetView.frame = rcServer;
    
    [_tztBaseView bringSubviewToFront:_tztTitleView];
}

-(void)CreateToolBar
{
    
}

@end
