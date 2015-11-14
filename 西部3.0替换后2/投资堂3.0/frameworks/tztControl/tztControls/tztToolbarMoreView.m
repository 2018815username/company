

#import "tztToolbarMoreView.h"

@interface tztToolbarMoreView()
{
    UIView      *_pSelView;
    UILabel     *_labelTitle;
}

@end

@implementation tztToolbarMoreView
@synthesize pTableView  = _pTableView;
@synthesize pNineGridView = _pNineGridView;
@synthesize nPosition = _nPosition;
@synthesize fCellHeight = _fCellHeight;
@synthesize bgColor = _bgColor;
@synthesize nRowCount = _nRowCount;
@synthesize nColCount = _nColCount;
@synthesize fMenuWidth = _fMenuWidth;
@synthesize szOffset = _szOffset;
@synthesize nShowType = _nShowType;
@synthesize clSeporater = _clSeporater;
@synthesize clText = _clText;
@synthesize nFontSize = _nFontSize;
@synthesize fBorderWidth = _fBorderWidth;
@synthesize clBorderColor = _clBorderColor;

-(id)initWithShowType:(tztToolbarMoreViewShowType)showType
{
    _nShowType = showType;
    self = [super init];
    if (self)
    {
        [self initdata];
    }
    return self;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initdata];
    }
    return self;
}

-(void)initdata
{
    //设置列颜色和字体颜色
    self.clSeporater = [UIColor colorWithRGBULong:0x373737];
    self.clText = [UIColor colorWithRGBULong:0xC6C6C6];
    self.clBorderColor = [UIColor clearColor];
    self.fBorderWidth = 0.f;
}

-(void)dealloc
{
    if(_ayGrid)
    {
        [_ayGrid removeAllObjects];
        [_ayGrid release];
        _ayGrid = nil;
    }
    [super dealloc];
}

-(void)SetAyGridCell:(NSArray*)ayGridCell
{
    if (_ayGrid == NULL)
        _ayGrid = NewObject(NSMutableArray);
    
    [_ayGrid removeAllObjects];
    
    for (int i = 0; i < [ayGridCell count]; i++)
    {
        [_ayGrid addObject:[ayGridCell objectAtIndex:i]];
    }
}
//在这里面设置 
-(void)setFrame:(CGRect)frame
{
    if (CGRectIsEmpty(frame) || CGRectIsNull(frame))
        return;
    [super setFrame:frame];

    CGRect rcFrame = self.bounds;
    
    if (_ayGrid == nil || [_ayGrid count] <= 0)
        return;
   
    if (_fCellHeight <= 10)
    {
        _fCellHeight = TZTToolBarHeight + 20;
    }
    
    
    if (_nShowType == tztShowType_Grid)
    {
        if (_nColCount <= 0)
            _nColCount = 3;
    
        if (_nRowCount <= 0)
            _nRowCount = [_ayGrid count] / _nColCount + (([_ayGrid count]) % _nColCount == 0 ? 0 : 1);
    }
    
    rcFrame.origin.x = 0; //(0,0,320,431)
    if ((_nPosition & tztToolbarMoreViewPositionBottom))
    {
        if (_nShowType == tztShowType_List)
        {
            rcFrame.origin.y = rcFrame.size.height - ([_ayGrid count] > 5 ? (5 * _fCellHeight) : ([_ayGrid count] * _fCellHeight));;
        }
        else
        {
            rcFrame.origin.y = rcFrame.size.height - _nRowCount * _fCellHeight;
        }
        rcFrame.origin.y -= _szOffset.height;
    }
    if(_nPosition & tztToolbarMoreViewPositionLeft)
    {
        rcFrame.origin.x = 0;
    }
    if(_nPosition & tztToolbarMoreViewPositionRight)
    {
        rcFrame.origin.x = rcFrame.size.width - _fMenuWidth; //在这里设置 坐标的的x
    }
    if(_nPosition & tztToolbarMoreViewPositionTop)
    {
        //这里面加坐标 y ＋1 了
        if (_szOffset.height <= 0)//
            rcFrame.origin.y = TZTToolBarHeight+1+(IS_TZTIOS(7) ? TZTStatuBarHeight : 0);
        else
            rcFrame.origin.y += _szOffset.height; //这边偏移量 加上 原来的坐标 难道不需要加上 toolbarheight
    }
    
    if (_szOffset.width > 0)
    {
        rcFrame.origin.x += _szOffset.width;
    }
    // 设置高度
    if (_nShowType == tztShowType_Grid)
        rcFrame.size.height = _nRowCount * _fCellHeight;
    else
    {
        if ([g_pSystermConfig.strMainTitle isEqual:@"易富通增强版"])
        {
            rcFrame.size.height = ([_ayGrid count] > 6 ? (6 * _fCellHeight) : ([_ayGrid count] * _fCellHeight));
        }
        else
        rcFrame.size.height = ([_ayGrid count] > 5 ? (5 * _fCellHeight) : ([_ayGrid count] * _fCellHeight));
    }
    
    
    if (_fMenuWidth > 0 )
    {
        rcFrame.size.width = _fMenuWidth;
    }
    
    CGRect rcTitle = rcFrame;
    rcTitle.size.height = 20;
    if (self.nsTitle.length > 0)
    {
        if (_labelTitle == nil)
        {
            _labelTitle = [[UILabel alloc] initWithFrame:rcTitle];
            _labelTitle.backgroundColor = [UIColor tztThemeBackgroundColorSection];
            _labelTitle.textColor = self.clText;
            _labelTitle.font = tztUIBaseViewTextFont(11);
            _labelTitle.adjustsFontSizeToFitWidth = YES;
            _labelTitle.textAlignment = NSTextAlignmentCenter;
            [self addSubview:_labelTitle];
            [_labelTitle release];
        }
        else
            _labelTitle.frame = rcTitle;
        
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
        _labelTitle.text = self.nsTitle;
    }
    else
    {
        rcTitle.size.height = 0;
    }
    
    rcFrame.origin.y += rcTitle.size.height;
    rcFrame.size.height -= rcTitle.size.height;
    
    if (_nShowType == tztShowType_Grid)
        [self setFrame_Grid:rcFrame];
    else if(_nShowType == tztShowType_List)
        [self setFrame_List:rcFrame];
}

-(void)setFrame_List:(CGRect)rcFrame
{
    if (_pSelView == NULL)
    {
        _pSelView = [[UIView alloc] init];
        _pSelView.backgroundColor = [UIColor colorWithRGBULong:0x008cdc];
    }
    if (_pTableView == NULL)
    {
        _pTableView = [[UITableView alloc] init];
        _pTableView.delegate = self;
        _pTableView.dataSource = self;
        _pTableView.alpha = 0.95f;
        _pTableView.backgroundColor = self.bgColor;// [UIColor colorWithRGBULong:0x434343];
        _pTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _pTableView.separatorColor = self.clSeporater;//[UIColor colorWithRGBULong:0x373737];
        
        if ((_nPosition & tztToolbarMoreViewPositionTop) == tztToolbarMoreViewPositionTop)
        {
            CGRect rc = rcFrame;
            rc.size.height = 0;
            [self addSubview:_pTableView];
            _pTableView.frame = rc;
            [UIView beginAnimations:@"hideSelectionView" context:nil];
            [UIView setAnimationDuration:0.2f];
            [UIView setAnimationDelegate:self];
            _pTableView.frame = rcFrame;
            [_pTableView release];
            [UIView commitAnimations];
        }
        else
        {
            CGRect rc = rcFrame;
            int nHeight = rcFrame.size.height;
            rc.origin.y += nHeight;
            rc.size.height = 0;
            _pTableView.frame = rc;
            [UIView beginAnimations:@"hideSelectionView" context:nil];
            _pTableView.frame = rcFrame;
            [self addSubview:_pTableView];
            [_pTableView release];
            [UIView commitAnimations];
        }
    }
    else
    {
        _pTableView.frame = rcFrame;
    }
    
    if (self.fBorderWidth > 0)
    {
        _pTableView.layer.borderWidth = self.fBorderWidth;
        _pTableView.layer.borderColor = self.clBorderColor.CGColor;
    }
}

-(void)setFrame_Grid:(CGRect)rcFrame
{
    if (_pNineGridView == Nil)
    {
        _pNineGridView = [[tztUINineGridView alloc] init];
        _pNineGridView.clText = [UIColor blackColor];
        _pNineGridView.alpha = 0.9f;
        if (self.bgColor)
        {
            _pNineGridView.bgColor = self.bgColor;
            _pNineGridView.backgroundColor = self.bgColor;
        }
        else
            _pNineGridView.backgroundColor = [UIColor whiteColor];
        _pNineGridView.bIsMoreView = YES;
        _pNineGridView.tztdelegate = self;
        _pNineGridView.fCellSize = _fCellHeight;
        _pNineGridView.rowCount = _nRowCount;
        _pNineGridView.colCount = _nColCount;
        [_pNineGridView setAyCellDataAll:_ayGrid];
        [_pNineGridView setAyCellData:_ayGrid];
        
        if (_nPosition == tztToolbarMoreViewPositionTop)
        {
            CGRect rc = rcFrame;
            rc.size.height = 0;
            [self addSubview:_pNineGridView];
            _pNineGridView.frame = rc;
            [UIView beginAnimations:@"hideSelectionView" context:nil];
            [UIView setAnimationDuration:0.2f];
            [UIView setAnimationDelegate:self];
            _pNineGridView.frame = rcFrame;
            [_pNineGridView release];
            [UIView commitAnimations];
        }
        else
        {
            CGRect rc = rcFrame;
            int nHeight = rcFrame.size.height;
            rc.origin.y += nHeight;
            rc.size.height = 0;
            _pNineGridView.frame = rc;
            [UIView beginAnimations:@"hideSelectionView" context:nil];
            _pNineGridView.frame = rcFrame;
            [self addSubview:_pNineGridView];
            [_pNineGridView release];
            [UIView commitAnimations];
        }
    }
    else
    {
        _pNineGridView.backgroundColor = self.bgColor;
        _pNineGridView.frame = rcFrame;
    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    
//    [UIView beginAnimations:@"View Flip" context:nil];
//    //动画持续时间
//    [UIView setAnimationDuration:1.25];
//    //设置动画的回调函数，设置后可以使用回调方法
//    [UIView setAnimationDelegate:self];
//    //设置动画曲线，控制动画速度
//    [UIView  setAnimationCurve: UIViewAnimationCurveEaseInOut];
//    //设置动画方式，并指出动画发生的位置
//    [UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:self  cache:YES];
//    //提交UIView动画
//    [UIView commitAnimations];
    //移除当前view
    
	UITouch *touch = [touches anyObject];
	CGPoint ptEnd = [touch locationInView:self];
    
    if ((_nShowType == tztShowType_Grid) && CGRectContainsPoint(_pNineGridView.frame, ptEnd))
        return;
    if ((_nShowType == tztShowType_List) && CGRectContainsPoint(_pTableView.frame, ptEnd))
        return;
    
	[self hideMoreBar];
}

-(void)RemoveView
{
    [self removeFromSuperview];
}

-(void)tztNineGridView:(id)ninegridview clickCellData:(tztNineCellData *)cellData
{
    [self hideMoreBar];
    
    if (_pDelegate && [_pDelegate respondsToSelector:@selector(tztNineGridView:clickCellData:)])
    {
        [_pDelegate tztNineGridView:ninegridview clickCellData:cellData];
    }
}


-(void)hideMoreBar
{
    [UIView beginAnimations:@"hideSelectionView" context:nil];
	[UIView setAnimationDuration:0.2f];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(RemoveView)];
	
    UIView *pView = nil;
    if (_nShowType == tztShowType_List)
        pView = _pTableView;
    else
        pView = _pNineGridView;
    
    CGRect rcFrame = CGRectZero;
    rcFrame = pView.frame;
    
    int nHeight = rcFrame.size.height;
    rcFrame.size.height = 0;
    if (_nPosition & tztToolbarMoreViewPositionBottom)
    {
        rcFrame.origin.y += nHeight;
    }
    
    pView.frame = rcFrame; //通过设置高度 消失弹出框 xinlan
    //问题 7需要查查commitAnimations
	[UIView commitAnimations];
    //点击取消，返回上个选中的tabbar，发送消息通知处理
    NSNotification* pNotifi = [NSNotification notificationWithName:TZTNotifi_HiddenMoreView object:self];
    [[NSNotificationCenter defaultCenter] postNotification:pNotifi];
}


#pragma tableviewlist

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_ayGrid count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return _fCellHeight;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* CellIndenter = @"tztTableMenu";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIndenter];
    if (cell == nil)
    {
        // reuseIdentifier:CellIndenter  这个有什么作用 9.2
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIndenter] autorelease];
        cell.backgroundColor = self.bgColor;// [UIColor colorWithRGBULong:0x434343];
        cell.selectedBackgroundView = _pSelView;
//        cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageTztNamed:@"tztButtonRed"]];
    }
    NSString *str = [_ayGrid objectAtIndex:indexPath.row];
    NSArray *ay = [str componentsSeparatedByString:@"|"];
    if ([ay count] > 1)
    {
        NSString* strTitle = [ay objectAtIndex:1];
        cell.textLabel.textColor = self.clText;// [UIColor colorWithRGBULong:0xC6C6C6];
        cell.textLabel.text = [NSString stringWithFormat:@"%@", strTitle];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        NSInteger nSize = _nFontSize;
        if (nSize <= 0)
            nSize = 17.f;
        cell.textLabel.font = tztUIBaseViewTextFont(nSize);
        cell.frame=CGRectMake(0, 0, 80, 40);
    }
    CGFloat r = 0.f;
    CGFloat g = 0.f;
    CGFloat b = 0.f;
    CGFloat a = 0.f;
    if([self.bgColor getTztRed:&r green:&g blue:&b alpha:&a])
    {
        r = (255 * r - 5) / 255.f;
        g = (255 * g - 5) / 255.f;
        b = (255 * b - 5) / 255.f;
    }
    
    if (indexPath.row % 2 == 0)
    {
        cell.backgroundColor = self.bgColor;
    }
    else
        cell.backgroundColor = [UIColor colorWithRed:r green:g blue:b alpha:a];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger nIndex = indexPath.row; //列出选择第几行
    if (nIndex >= [_ayGrid count])
        return;
    NSString *str = [_ayGrid objectAtIndex:nIndex]; //把这一行的数据取出来
    NSArray *ay = [str componentsSeparatedByString:@"|"]; //把这一行的数据分开
    if ([ay count] > 2)
    {
        NSString* strFuncID = [ay objectAtIndex:2]; //选出功能号
        if (_pDelegate && [_pDelegate respondsToSelector:@selector(tztNineGridView:clickCellData:)])
        {
            tztNineCellData *cellData = NewObjectAutoD(tztNineCellData);
            //这边 75 第三个参数有什么作用
            cellData.cmdid = [strFuncID intValue]; //设置功能id
            cellData.text = [NSString stringWithFormat:@"%@", [ay objectAtIndex:1]];
            
            cellData.cmdparam = [NSString stringWithFormat:@"%@", str];
            [_pDelegate tztNineGridView:nil clickCellData:cellData];
        }
    }
    [self hideMoreBar];
}
@end
