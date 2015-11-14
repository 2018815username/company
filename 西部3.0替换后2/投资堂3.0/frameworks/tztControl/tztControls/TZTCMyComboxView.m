//
//  TZTCMyComboxView.m
//  TZT
//
//  Created by dai shouwei on 09-9-27.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "TZTCMyComboxView.h"

@implementation TZTCMyComboxView

@synthesize m_nComboxID;

@synthesize m_nSelectIndex;
@synthesize m_nsSelectText;
@synthesize m_PickerView;
@synthesize m_pickerData;

@synthesize m_baseSheet;
@synthesize m_rcShowRect;
@synthesize m_delegate;

-(id)initWithFrame:(CGRect)frame FromRect:(CGRect)rcFrom
{
    if (self = [super initWithFrame:frame]) {
        // Initialization code
        m_nComboxID = -1;
        
        self.m_pickerData = NULL;
        self.m_PickerView = NULL;
        m_nSelectIndex = -1;
        self.m_nsSelectText = NULL;
        
        self.m_baseSheet = NULL;
        
        m_delegate = NULL;
        m_rcShowRect = rcFrom;
        [self CreateSheetAndPicker:frame];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    
    return [self initWithFrame:frame FromRect:CGRectMake(0, 0, 0, 0)];
}


- (void)drawRect:(CGRect)rect {
    // Drawing code
}


- (void)dealloc {
	self.m_nsSelectText = NULL;
	self.m_pickerData = NULL;
	self.m_PickerView = NULL;
	self.m_baseSheet = NULL;
//	m_delegate = NULL;
    [super dealloc];
}

-(void) CreateSheetAndPicker:(CGRect)frame
{
    [self setAlpha:0.0f];
    
    
    if (IS_TZTIOS(8))
    {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"    " message:@"\n\n\n\n\n\n\n\n" preferredStyle:UIAlertControllerStyleActionSheet];
        
        CGRect pickerFrame = CGRectMake(0, 0, 305, 250);
        self.m_PickerView = [[[UIPickerView alloc] initWithFrame:pickerFrame] autorelease];
        if ([[UIDevice currentDevice].systemVersion intValue] >= 7)
        {
            m_PickerView.backgroundColor = [UIColor whiteColor];
        }
        
        m_PickerView.delegate = self;
        m_PickerView.dataSource = self;
        m_PickerView.showsSelectionIndicator = YES;
        [alert.view addSubview:m_PickerView];
        
        
        UIViewController* pBottomVC = g_navigationController.topViewController;
//        if (!pBottomVC)
//            pBottomVC = [TZTAppObj getTopViewController]; // 修复moreNavigationController时弹出框不能点击问题 byDBQ20130729
        CGRect rcFrom = m_rcShowRect;
//        if (button)
//        {
//            rcFrom.origin = button.center;
//        }
//        rcFrom.origin.y = [button gettztwindowy:nil] + button.frame.size.height;
//        rcFrom.origin.x = [button gettztwindowx:nil] + button.frame.size.width / 2;
        rcFrom.size = pickerFrame.size;
        if (pBottomVC && [pBottomVC isKindOfClass:[[NSBundle mainBundle] classNamed:@"TZTUIBaseViewController"]])
        {
            [pBottomVC PopViewController:alert rect:rcFrom];
        }
        
//        [g_navigationController presentViewController:alert animated:YES completion:nil];
    }
    else
    {
        
        if (!self.m_baseSheet)
        {
            self.m_baseSheet = [[[UIActionSheet alloc]
                                 initWithTitle:@"  "
                                 delegate:self
                                 cancelButtonTitle:nil
                                 destructiveButtonTitle:nil
                                 otherButtonTitles:nil] autorelease];
            //m_baseSheet.actionSheetStyle = UIBarStyleBlackTranslucent;
            [m_baseSheet addButtonWithTitle:@""];
            [m_baseSheet addButtonWithTitle:@""];
            [m_baseSheet addButtonWithTitle:@""];
            [m_baseSheet addButtonWithTitle:@""];
            [m_baseSheet addButtonWithTitle:@"确定"];
            [m_baseSheet addButtonWithTitle:@"取消"];
            [m_baseSheet setCancelButtonIndex:5];
            
            //[m_baseSheet setAlpha:0.8f];
            //[m_baseSheet setOpaque:NO];
            
            CGRect frame;
            //if (g_bIsIPhone4OS)
            {
                frame = CGRectMake(0, 22, 275, 220);
            }
            //        else
            //		{
            //			frame = CGRectMake(0, 25, 275, 210);
            //		}
            if (IS_TZTIOS(7))
            {
                frame = CGRectMake(0, 35, 275, 215);
            }
            
            self.m_PickerView = [[[UIPickerView alloc] initWithFrame:frame] autorelease];
            if ([[UIDevice currentDevice].systemVersion intValue] >= 7)
            {
                m_PickerView.backgroundColor = [UIColor whiteColor];
            }
            
            m_PickerView.delegate = self;
            m_PickerView.dataSource = self;
            m_PickerView.showsSelectionIndicator = YES;
            //[m_PickerView setAlpha:0.8f];
            //[m_PickerView setOpaque:YES];
            
            //m_baseSheet.frame = CGRectMake(0, 25, 275, 210);
            [m_baseSheet addSubview:m_PickerView];
            
            //
            [self performSelectorOnMainThread:@selector(ShowInView) withObject:nil waitUntilDone:NO];
            //[m_baseSheet showInView:self];
        }
    }
}

-(void) ShowInView
{
	if (CGRectIsEmpty(m_rcShowRect))
    {
        [m_baseSheet showInView:self];
    }
    else
    {
        [m_baseSheet showFromRect:m_rcShowRect inView:self animated:YES];
    }
}

-(id)delegate
{
    return m_delegate;
}

-(void) setDelegate:(id)delegate
{
    m_delegate = delegate;
}

-(void) SetCombox:(unsigned int)nID ayData:(NSMutableArray*)ayData nDefault:(int)nDefault
{
    m_nComboxID = nID;
    m_nSelectIndex = nDefault;
    self.m_pickerData = ayData;
    
    if (m_PickerView != NULL)
    {
        [m_PickerView reloadAllComponents];
        [m_PickerView selectRow:m_nSelectIndex inComponent:0 animated:NO/*YES*/];
    }
}

-(void) OnOK
{
    if (m_delegate == NULL)
        return;
    
    if (m_nSelectIndex < 0)
        return;
    
    if ([m_delegate respondsToSelector:@selector(OnComboxSel:nSel:nsText:)] == YES)
    {
        [m_delegate OnComboxSel:m_nComboxID nSel:m_nSelectIndex nsText:m_nsSelectText];
    }
//    [self removeFromSuperview];
}

-(void) OnCancel
{
//    [self removeFromSuperview];
}

-(void) setTitle:(NSString*)nsTitle
{
    if (m_baseSheet != NULL)
        m_baseSheet.title = nsTitle;
}

-(void) OnComboxSel:(unsigned int)nID nSel:(NSInteger)nSelectIndex nsText:(NSString*)nsSelectText
{
    ;
}

#pragma mark UIActionSheet delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 4)
    {
        if (m_PickerView != NULL)
        {
            m_nSelectIndex = [m_PickerView selectedRowInComponent:0];
            if (m_nSelectIndex >= 0)
                self.m_nsSelectText = [m_pickerData objectAtIndex:m_nSelectIndex];
            else
                self.m_nsSelectText = @"";
        }
        else
        {
            m_nSelectIndex = -1;
            self.m_nsSelectText = @"";
        }
        
        [NSTimer scheduledTimerWithTimeInterval:0.1
                                         target:self
                                       selector:@selector(OnOK)
                                       userInfo:nil
                                        repeats:NO];

        //[self removeFromSuperview];
    }
    else if (buttonIndex == 5)
    {
        [NSTimer scheduledTimerWithTimeInterval:0.1
                                         target:self
                                       selector:@selector(OnCancel)
                                       userInfo:nil
                                        repeats:NO];
    }
//
//    [self removeFromSuperview];
	return;
}

#pragma mark -
#pragma mark Picker Data Source Methods
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
	return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (m_pickerData != NULL)
        return [m_pickerData count];
    return 0;
}

/*
-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{ 
	//if (g_nPageType == WT_NeiZhuan ) 
	{
		UILabel *pickerLabel = (UILabel *)view;
		
		if ((pickerLabel == nil) || ([pickerView class] != [UILabel class])) {
			
			CGRect frame = CGRectMake(0, 0, 275, 32);
			pickerLabel = [[UILabel alloc] initWithFrame:frame];
			pickerLabel.textAlignment =NSTextAlignmentCenter;
			pickerLabel.backgroundColor = [UIColor clearColor];
			pickerLabel.font = [UIFont boldSystemFontOfSize:18];
			pickerLabel.textColor = [UIColor blackColor];
			pickerLabel.adjustsFontSizeToFitWidth = YES;
			pickerLabel.text = [m_pickerData objectAtIndex:row];
			return pickerLabel; 
		}
	}
	return 0;
}
*/

#pragma mark Picker Delegate Methods
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (m_pickerData != NULL && row >= 0 && row < [m_pickerData count])
        return [m_pickerData objectAtIndex:row];
    return @"";
}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    m_nSelectIndex = row;
	if (m_pickerData != NULL && row >= 0 && row < [m_pickerData count])
		 self.m_nsSelectText = [m_pickerData objectAtIndex:row];
    
    
    if (m_delegate == NULL)
        return;
    
    if (m_nSelectIndex < 0)
        return;
    
    if ([m_delegate respondsToSelector:@selector(OnComboxSel:nSel:nsText:)] == YES)
    {
        [m_delegate OnComboxSel:m_nComboxID nSel:m_nSelectIndex nsText:m_nsSelectText];
    }
}

@end
