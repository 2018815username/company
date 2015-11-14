
#import "tztWebTradeWithDrawViewController.h"

@interface tztWebTradeWithDrawViewController ()

@end

@implementation tztWebTradeWithDrawViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)LoadLayoutView
{
    [super LoadLayoutView];
    [self.tztTitleView.fourthBtn setTztBackgroundImage:nil];
    [self.tztTitleView.fourthBtn setTztImage:nil];
//    CGRect rcFrame = self.tztTitleView.fourthBtn.frame;
//    rcFrame.size.width = 90;
//    rcFrame.origin.x = self.tztTitleView.frame.size.width - rcFrame.size.width;
//    self.tztTitleView.fourthBtn.frame = rcFrame;
//    if (_nMsgType == MENU_JY_PT_Withdraw || _nMsgType == WT_WITHDRAW)
//    {
//        [self.tztTitleView.fourthBtn setTztTitle:@"今日委托"];
//    }
//    else if (_nMsgType == MENU_JY_PT_QueryDraw || _nMsgType == WT_QUERYDRWT)
//    {
//        [self.tztTitleView.fourthBtn setTztTitle:@"成交记录"];
//    }
//    else
    {
        self.tztTitleView.fourthBtn.hidden = YES;
    }
    self.tztTitleView.fourthBtn.titleLabel.font = tztUIBaseViewTextFont(13.0f);
}

-(void)OnToolbarMenuClick:(id)sender
{
    UIButton *pBtn = (UIButton*)sender;
    
    NSInteger nTag = pBtn.tag;
    if (nTag == HQ_MENU_SearchStock)//
    {
        switch (_nMsgType)
        {
            case MENU_JY_PT_Withdraw:
            case WT_WITHDRAW:
            {
                //跳转到今日委托界面
                [TZTUIBaseVCMsg OnMsg:MENU_JY_PT_QueryDraw wParam:0 lParam:0];
            }
                break;
            case MENU_JY_PT_QueryDraw:
            case WT_QUERYDRWT:
            {
                //跳转到历史交易界面
                //MENU_JY_PT_QueryTransHis//
                [TZTUIBaseVCMsg OnMsg:MENU_JY_PT_QueryTransHis wParam:0 lParam:0];
            }
                break;
            default:
                break;
        }
    }
    else
        [super OnToolbarMenuClick:sender];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(void)OnChangeTheme
{
    [self.pWebView RefreshWebView:-1];
    [super OnChangeTheme];
}

-(void)tztRefreshData
{
    [self.pWebView RefreshWebView:-1];
}

@end
