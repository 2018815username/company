/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:        九宫格显示vc
 * 文件标识:        
 * 摘要说明:        
 * 
 * 当前版本:        2.0
 * 作    者:       yinjp
 * 更新日期:            
 * 整理修改:	
 *
 ***************************************************************/

#import "tztNineCellViewController.h"

@implementation tztNineCellViewController
@synthesize pNineGridView = _pNineGridView;
@synthesize pAyNineCell = _pAyNineCell;
@synthesize nCol = _nCol;
@synthesize nRow = _nRow;
@synthesize fCellSize = _fCellSize;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
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
}

- (void)viewDidUnload
{
    NilObject(self.pNineGridView);
    NilObject(self.nsTitle);
    NilObject(self.pAyNineCell);
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)dealloc
{
    NilObject(self.pNineGridView);
    [super dealloc];
}

-(void)LoadLayoutView
{
    CGRect rcFrame = _tztBounds;
#ifdef Support_HXSC
    if (self.navigationController.viewControllers.count <= 1)
        [self onSetTztTitleView:self.nsTitle type:TZTTitleIcon];
    else
        [self onSetTztTitleView:self.nsTitle type:TZTTitleReport];
#else
    [self onSetTztTitleView:self.nsTitle type:TZTTitleReport];//设置标题
#endif
    rcFrame.size.height = _tztTitleView.frame.size.height;
    CGRect rcNine = _tztBounds;
    rcNine.origin = CGPointZero;
    rcNine.origin.y += rcFrame.size.height;
    rcNine.size.height -= rcFrame.size.height;
    if (self.pNineGridView == nil)
    {
        self.pNineGridView = [[[tztUINineGridView alloc] init] autorelease];
        self.pNineGridView.frame = rcNine;
        self.pNineGridView.rowCount = (_nRow > 0 ? _nRow : 4);
        self.pNineGridView.colCount = (_nCol > 0 ? _nCol : 4);
        self.pNineGridView.tztdelegate = self;
        if (_fCellSize > 0)
            self.pNineGridView.fCellSize = _fCellSize;
#ifdef Support_HXSC
        self.pNineGridView.nsBackImage = @"TZTNiceBack.png";
        self.pNineGridView.clText = [UIColor blackColor];
#endif
        [_tztBaseView addSubview:self.pNineGridView];
    }
    
    if (g_nJYBackBlackColor == 0) {
        self.pNineGridView.clText = [UIColor blackColor];
    }
    
    if (_pAyNineCell)
    {
        [self.pNineGridView setAyCellDataAll:_pAyNineCell];
        [self.pNineGridView setAyCellData:_pAyNineCell];
    }
    self.pNineGridView.frame = rcNine;
    
    if (g_nJYBackBlackColor == 0) {
        self.pNineGridView.backgroundColor = [UIColor whiteColor];
    }
}

-(void)CreateToolBar
{
    
}

-(void)tztNineGridView:(id)ninegridview clickCellData:(tztNineCellData *)cellData
{
    //通过cellData获取下级如果存在，则继续打开
    if (cellData == NULL)
        return;
    NSString *str = cellData.cmdparam;
    if (str && [str length] > 0)
    {
        NSArray *pAy = [str componentsSeparatedByString:@"|"];
        if (pAy == NULL || [pAy count] < 3)
            return;
        if ([pAy count] > 3)
        {
            NSString *strKey = [pAy objectAtIndex:3];
            if (strKey && [strKey length] > 0)
            {
                NSArray *pAyCell = [g_pSystermConfig.pDict objectForKey:strKey];
                if (pAyCell && [pAyCell count] > 0)
                {
                    tztNineCellViewController *pVC = [[tztNineCellViewController alloc] init];
                    int nCol = [[g_pSystermConfig.pDict objectForKey:@"tztNineCol"] intValue];
                    if (nCol <= 0)
                        nCol = 4;
                    
                    int nPerRow = [[g_pSystermConfig.pDict objectForKey:@"tztNineRow"] intValue];
                    if (nPerRow <= 0)
                        nPerRow = 4;
                    NSInteger nRow = [pAyCell count] / nCol;
                    if ([pAyCell count] % nCol != 0)
                        nRow++;
                    if (nRow < nPerRow)
                        nRow = nPerRow;
                    
                    pVC.nCol = nCol;
                    pVC.nRow = nRow;
                    pVC.nsTitle = [NSString stringWithFormat:@"%@",cellData.text];
                    pVC.pAyNineCell = pAyCell;
                    [g_navigationController pushViewController:pVC animated:UseAnimated];
                    [pVC release];
                    return;
                }
                
            }
        }
    }
    [TZTUIBaseVCMsg OnMsg:cellData.cmdid wParam:0 lParam:0];
}

@end
