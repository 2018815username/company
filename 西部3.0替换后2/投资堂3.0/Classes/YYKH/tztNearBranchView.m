//
//  tztNearBranchView.m
//  tztMobileApp_yyz
//
//  Created by 张 小龙 on 13-6-5.
//
//

#import "tztNearBranchView.h"
#import "TZTUIBaseVCMsg.h"
#import "tztUIGTJAYYKHViewController.h"
@implementation tztNearBranchView
@synthesize tztTableView = _tztTableView;
@synthesize ayBranch = _ayBranch;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)setFrame:(CGRect)frame
{
    if (CGRectIsEmpty(frame) || CGRectIsNull(frame))
        return;
    
    [super setFrame:frame];
    
    CGRect rcFrame = self.bounds;
    rcFrame.origin = CGPointZero;
    rcFrame.size.height = 30;
    if (_pLable == NULL)
    {
        _pLable = [[UILabel alloc] initWithFrame:rcFrame];
        _pLable.backgroundColor = [UIColor clearColor];
        _pLable.textColor = [UIColor whiteColor];
        _pLable.textAlignment = UITextAlignmentLeft;
        _pLable.text = @"距离您当前位置最近的三个营业部:";
        [self addSubview:_pLable];
        [_pLable release];
    }else
        _pLable.frame = rcFrame;
    
    rcFrame = frame;
    rcFrame.origin.x = 10;
    rcFrame.origin.y = _pLable.frame.origin.y + _pLable.frame.size.height;
    rcFrame.size.width -= 20;
    rcFrame.size.height = 300;
    if(_tztTableView == nil)
    {
        _tztTableView = [[[UITableView alloc] init] autorelease];
        _tztTableView.delegate = self;
        _tztTableView.dataSource = self;
        [_tztTableView flashScrollIndicators];
        _tztTableView.layer.cornerRadius = 10;//设置那个圆角的有多圆
		_tztTableView.layer.borderWidth = 0.5;//设置边框的宽度，当然可以不要
		_tztTableView.layer.masksToBounds = YES;
        _tztTableView.frame = rcFrame;
        [self addSubview:_tztTableView];
        [_tztTableView reloadData];
    }else
        _tztTableView.frame = rcFrame;
}
- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section
{
    if (self.ayBranch)
        return [self.ayBranch count];
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath

{
    return 100;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSString *str = @"idetify";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
    CGRect rcFram = cell.frame;
    rcFram.size.height = 100;
    cell.frame = rcFram;
    CGFloat cellWidth = self.frame.size.width;
	if(cell == NULL)
	{
		cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str]autorelease];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
		UILabel *labelbranch = [[UILabel alloc]initWithFrame:CGRectMake(5, 0, _tztTableView.frame.size.width - 80, 30)];
        
		labelbranch.backgroundColor = [UIColor clearColor];
		labelbranch.adjustsFontSizeToFitWidth = YES;
        labelbranch.textAlignment = UITextAlignmentLeft;
        labelbranch.tag = 999;
        labelbranch.textColor = [UIColor blackColor];
        labelbranch.font = [UIFont systemFontOfSize:17.f];
		[cell.contentView addSubview:labelbranch];
        [labelbranch release];
        
        UILabel *labeladdress = [[UILabel alloc]initWithFrame:CGRectMake(5,labelbranch.frame.origin.y + labelbranch.frame.size.height, _tztTableView.frame.size.width - 80, 40)];
        
		labeladdress.backgroundColor = [UIColor clearColor];
		labeladdress.adjustsFontSizeToFitWidth = YES;
        labeladdress.textAlignment = UITextAlignmentLeft;
        labeladdress.font = [UIFont systemFontOfSize:13.f];
        [labeladdress setNumberOfLines:0];
        labeladdress.lineBreakMode = UILineBreakModeWordWrap;
        labeladdress.tag = 998;
        labeladdress.textColor = [UIColor blackColor];
		[cell.contentView addSubview:labeladdress];
        [labeladdress release];
        
        UILabel *labelphone = [[UILabel alloc]initWithFrame:CGRectMake(5,labeladdress.frame.origin.y + labeladdress.frame.size.height, _tztTableView.frame.size.width - 80, 20)];
        
		labelphone.backgroundColor = [UIColor clearColor];
		labelphone.adjustsFontSizeToFitWidth = YES;
        labelphone.textAlignment = UITextAlignmentLeft;
        labelphone.font = [UIFont systemFontOfSize:13.f];
        labelphone.tag = 997;
        labelphone.textColor = [UIColor blackColor];
		[cell.contentView addSubview:labelphone];
        [labelphone release];
        
        UILabel *labelKM = [[UILabel alloc]initWithFrame:CGRectMake(cellWidth - 90,5, 80, 20)];
        
		labelKM.backgroundColor = [UIColor clearColor];
		labelKM.adjustsFontSizeToFitWidth = YES;
        labelKM.textAlignment = UITextAlignmentLeft;
        labelKM.font = [UIFont systemFontOfSize:13.f];
        labelKM.tag = 996;
        labelKM.textColor = [UIColor blackColor];
		[cell.contentView addSubview:labelKM];
        [labelKM release];
        
	}
    
    int btntag = indexPath.row;
    int count = [self.ayBranch count];
	if(count > indexPath.row)
    {
        
        NSMutableArray* branch = [self.ayBranch objectAtIndex:indexPath.row];
        
        UILabel *nowlabel = (UILabel*)[cell viewWithTag:999];
        NSString* labelText = @"";
        if (nowlabel)
        {
            labelText = [NSString stringWithFormat:@"%@",[branch objectAtIndex:1]];
            nowlabel.text = labelText;
        }
        nowlabel = (UILabel*)[cell viewWithTag:998];
        if (nowlabel)
        {
            labelText = [NSString stringWithFormat:@"地址:%@",[branch objectAtIndex:2]];
            nowlabel.text = labelText;
        }
        
        nowlabel = (UILabel*)[cell viewWithTag:997];
        if (nowlabel)
        {
            labelText = [NSString stringWithFormat:@"电话:%@",[branch objectAtIndex:3]];
            nowlabel.text = labelText;
        }
        
        nowlabel = (UILabel*)[cell viewWithTag:996];
        if (nowlabel)
        {
            double dKM = [[branch objectAtIndex:4] doubleValue];
            if (dKM * 1000 < 1000)
            {
                dKM = dKM * 1000;
                labelText = [NSString stringWithFormat:@"%0.1fM",dKM];
            }else
            {
                labelText = [NSString stringWithFormat:@"%0.1fKM",dKM];
            }
            
            nowlabel.text = labelText;
        }
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setBackgroundImage:[UIImage imageTztNamed:@"TZTBottomBtn.png"] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageTztNamed:@"TZTBottomBtn_on.png"] forState:UIControlStateHighlighted];
        [btn setFrame:CGRectMake(cellWidth - 70 ,40, 70, 30)];
        [btn addTarget:self action:@selector(OnButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.titleLabel.font = [UIFont systemFontOfSize:13.f];
        btn.tag = btntag;
        [btn setTztTitle:@"预约开户"];
        [btn setTztTitleColor:[UIColor whiteColor]];
        cell.accessoryView =  btn;
    }
    return cell;
}
-(void)OnButtonClick:(id)sender
{
    UIButton * button = (UIButton *)sender;
    int index = button.tag;
    if ([_ayBranch count] > 0 && [_ayBranch count] > index)
    {
        NSMutableArray * aybranchinfo = [_ayBranch objectAtIndex:index];
        [g_navigationController popViewControllerAnimated:NO];
        UIViewController* VC = [TZTUIBaseVCMsg CheckCurrentViewContrllers:[tztUIGTJAYYKHViewController class]];
        if (VC)
        {
            tztUIGTJAYYKHViewController *pVC = (tztUIGTJAYYKHViewController *)VC;
            [pVC.pView.ayDefaultBranch setArray:aybranchinfo];
            [pVC.pView setDefault];
        }else
        {
            tztUIGTJAYYKHViewController *pVC = NewObject(tztUIGTJAYYKHViewController);
            [pVC.ayBranchInfo setArray:aybranchinfo];
            [g_navigationController pushViewController:pVC animated:NO];
            [pVC release];
        }
    }
}
@end
