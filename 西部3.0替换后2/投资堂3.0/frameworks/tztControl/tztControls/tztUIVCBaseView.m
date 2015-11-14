//
//  tztUIVCBaseView.m
//  tztMobileApp
//
//  Created by yangdl on 13-2-23.
//  Copyright (c) 2013年 投资堂. All rights reserved.
//

#define tztTableTagMultiple 10000
#import "tztUIVCBaseView.h"
@interface tztUIVCBaseView ()
- (void)initdata;
- (void)initsubframe;
- (void)onCreatetablelist;
- (void)freetablelist;
@end

@implementation tztUIVCBaseView
@synthesize tableConfig = _tableConfig;
@synthesize tztDelegate = _tztDelegate;
@synthesize tztDatePicker;
@synthesize isAMonthAgo;
@synthesize isTodayEnd;
@synthesize isTomorrowBegin;
@synthesize nXMargin = _nXMargin;
@synthesize nYMargin = _nYMargin;

- (id)init
{
    self = [super init];
    if(self)
    {
        [self initdata];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self initdata];
        [self initsubframe];
    }
    return self;
}

- (void)initdata
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:TZTUIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasHidden:)
                                                 name:TZTUIKeyboardDidHideNotification object:nil];
    
    self.nXMargin = 5;
    self.nYMargin = 5;
}

- (void)dealloc
{
    [self freetablelist];
    DelObject(_tableConfig);
    DelObject(_tablelist);
    if(_tableControls)
    {
        [_tableControls removeAllObjects];
        [_tableControls release];
        _tableControls = nil;
    }
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    [super dealloc];
}

-(void)OnTap:(UITapGestureRecognizer*)tapGesture
{
    [self.tztDelegate tztperformSelector:@"OnTap:" withObject:tapGesture];
}

- (void)initsubframe
{
    [self onCreatetablelist];
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [self initsubframe];
}

//获取数据显示区域
- (CGSize)getTableShowSize
{
    return _tableShowSize;
}

- (void)freetablelist
{
    if(_tablelist)
    {
        for (int i = 0; i < [_tablelist count]; i++)
        {
            tztUIBaseControlsView* tableview = (tztUIBaseControlsView*)[_tablelist objectAtIndex:i];
            if(tableview)
            {
                [tableview removeFromSuperview];
            }
        }
        [_tablelist removeAllObjects];
    }
}
- (void)setTableConfig:(NSString *)tableConfig
{
    if(tableConfig && [tableConfig length] > 0)
    {
        if(_tableConfig && [_tableConfig compare:tableConfig] != NSOrderedSame)
        {
            DelObject(_tableConfig);
            [self freetablelist];
        }
        _tableConfig = [tableConfig retain];
        [self onCreatetablelist];
    }
}

//关闭系统键盘
+(BOOL) OnCloseKeybord:(UIView*)pView
{
	if(pView && [pView isKindOfClass:[UIResponder class]])
	{
		[pView resignFirstResponder];
	}
	NSArray* pAyView = [pView subviews];
	for(int i = 0; i< [pAyView count]; i++)
	{
		UIView* pSubView = [pAyView objectAtIndex:i];
		if(pSubView)
		{
			[tztUIVCBaseView OnCloseKeybord:pSubView];
		}
	}
	return FALSE;
}

- (void)onCreatetablelist
{
    if ( CGRectIsNull(self.bounds) || CGRectIsEmpty(self.bounds) )
    {
        return;
    }
    _tableShowSize = CGSizeZero;
    if(_tableConfig && [_tableConfig length] > 0)
    {
        NSString* tztPath = GetTztBundlePlistPath(_tableConfig);
        NSArray* aytableinfo = [[[NSArray alloc] initWithContentsOfFile:tztPath] autorelease];
        if(_tablelist == nil)
        {
            _tablelist = NewObject(NSMutableArray);
        }
        if (_tableControls == nil)
        {
            _tableControls = NewObject(NSMutableDictionary);
        }
        
        NSInteger nXMargin = self.nXMargin;
        NSInteger nYMargin = self.nYMargin;
        
        if (IS_TZTIPAD)
        {
            //zxl 20131011 调整了界面显示的 x  和 Y的位子
            nXMargin *= 2;
            nYMargin *= 2;
        }
        /*预留上下左右间距 yinjp*/
        CGRect tableframe = self.bounds;
        CGFloat fWidth = self.bounds.size.width - nXMargin * 2;
        CGFloat hWidth = fWidth;
        CGFloat hHeight = self.bounds.size.height - nYMargin * 2;
        CGFloat fbeginy = nYMargin;
        CGFloat fbeginx = nXMargin;
        CGFloat fEndy = 0;
        int    NowRow = 0;
        int    nLayout = 0;
        
        BOOL  bClearColor = FALSE;
        
        for (int i = 0; i < [aytableinfo count]; i++)
        {
            NSDictionary* tableinfo = [aytableinfo objectAtIndex:i];
            if(tableinfo == nil || [tableinfo count] <= 0)
            {
                continue;
            }
            NSInteger nTag = (i+1)*tztTableTagMultiple;
            tztUIBaseControlsView* tableview = (tztUIBaseControlsView*)[self viewWithTag:nTag];
            if(tableview == nil)
            {
                tableview = NewObject(tztUIBaseControlsView);
                tableview.tag = nTag;
                [_tablelist addObject:tableview];
                [_tableControls setObject:_tablelist forKey:_tableConfig];
                tableview.tztdelegate = self;
                [self addSubview:tableview];
                [tableview release];
                
                NSString* strCellheight = @"";
                NSString* strRect = @",,,";
                //表格属性
                NSString* strtableproperty = [tableinfo objectForKey:@"tableproperty"];
                if(strtableproperty && [strtableproperty length] > 0)
                {
                    NSMutableDictionary* tableproperty = NewObject(NSMutableDictionary);
                    [tableproperty settztProperty:strtableproperty];
                    NSString* strValue = [tableproperty objectForKey:@"rect"];
                    if(strValue && [strValue length] > 0)
                        strRect = strValue;
                    
                    strValue = [tableproperty objectForKey:@"cellheight"];
                    if(strValue && [strValue length] > 0)
                        strCellheight = strValue;
                    
#ifdef tztNoRadius
                    tableview.nRadius = 0;
#else
                    strValue = [tableproperty objectForKey:@"radius"];
                    if(strValue && [strValue length] > 0)
                        tableview.nRadius = [strValue intValue];
#endif
                    
                    strValue = [tableproperty objectForKey:@"layout"];
                    if(strValue && [strValue length] > 0)
                        nLayout = [strValue intValue];
                    
                    
                    strValue = [tableproperty objectForKey:@"autocalcul"];
                    if(strValue && [strValue length] > 0)
                        tableview.bAutoCalcul = ([strValue intValue] != 0);
                    
                    strValue = [tableproperty objectForKey:@"gridcolor"];
                    if (strValue && [strValue length] > 0)
                        tableview.nsgridcolor = [NSString stringWithFormat:@"%@",strValue];
                    
                    strValue = [tableproperty objectForKey:@"gridline"];
                    if(strValue && [strValue length] > 0)
                        tableview.bGridLine = ([strValue intValue] != 0);
                    
                    strValue = [tableproperty objectForKey:@"bordercolor"];
                    if (strValue && [strValue length] > 0)
                        tableview.layer.borderColor = [UIColor colorWithTztRGBStr:strValue].CGColor;
                    
                    
#ifdef tztNoBorderWidth
                    tableview.layer.borderWidth = 0;
#else
                    strValue = [tableproperty objectForKey:@"borderwidth"];
                    if (strValue && [strValue length] > 0)
                        tableview.layer.borderWidth = [strValue floatValue];
#endif
                    
                    strValue = [tableproperty objectForKey:@"backgroundcolor"];
                    
                    if (strValue && [strValue length] > 0)
                    {
                        NSString* temp = [strValue lowercaseString];
                        if ([strValue hasSuffix:@".png"])
                        {
                            tableview.clBackground = [UIColor colorWithPatternImage:[UIImage imageTztNamed:strValue]];
                        }
                        else if([temp compare:@"clearcolor"] == NSOrderedSame)
                        {
                            tableview.clBackground = [UIColor clearColor];
                            bClearColor = TRUE;
                        }
                        else
                        {
                            NSString *alpha = [tableproperty objectForKey:@"coloralpha"];
                            if (alpha && [alpha length] > 0) {
                                NSArray *array = [strValue componentsSeparatedByString:@","];
                                float red = [[array objectAtIndex:0] floatValue]/255;
                                float green = [[array objectAtIndex:1] floatValue]/255;
                                float blue = [[array objectAtIndex:2] floatValue]/255;
                                tableview.clBackground = [UIColor colorWithRed:red green:green blue:blue alpha:[alpha floatValue]];
                            }
                            else
                            {
                                tableview.clBackground = [UIColor colorWithTztRGBStr:strValue];
                            }
                            
                        }
                    }
                    
                    strValue = [tableproperty objectForKey:@"row"];
                    if (strValue && [strValue length] > 0)
                    {
                        if (NowRow != [strValue intValue])
                        {
                            NowRow = [strValue intValue];
                            fbeginx = 0;
                            fbeginy = fEndy;
                            hWidth = self.bounds.size.width;
                        }
                    }
                    
                    DelObject(tableproperty);
                }
                
                if(strRect && [strRect length] > 0)
                {
                    if(nLayout != 1)
                        tableframe = CGRectMaketztNSString(strRect, 0, 0, hWidth, hHeight, hWidth, hHeight);
                    else
                        tableframe = CGRectMaketztNSString(strRect, 0, fEndy, hWidth, hHeight, hWidth, hHeight);
                    tableframe = CGRectOffset(tableframe,fbeginx,fbeginy);
                }
                if (strCellheight && [strCellheight length] > 0)
                {
                    if([strCellheight hasSuffix:@"%"])
                    {
                        tableview.cellheight = [[strCellheight substringToIndex:[strCellheight length] - 1]  floatValue] * tableframe.size.height / 100.f;
                    }
                    else
                        tableview.cellheight = [strCellheight floatValue];
                }
                [tableview setFrame:tableframe];
                [tableview setTableinfo:tableinfo];
            }
            
            if([aytableinfo count] <= 1)
                tableview.viewMaxheight = fWidth;//self.bounds.size.height;
            
            if (nLayout != 1)
                fbeginx = tableview.frame.origin.x + tableview.frame.size.width;//起始x
            
            fEndy = tableview.frame.origin.y + tableview.frame.size.height;//起始y
            hHeight = self.bounds.size.height - fbeginy;//剩余高度
            if (nLayout != 1)//=1是上下布局，这时候宽度保持不变
                hWidth = fWidth /*self.bounds.size.width*/ - fbeginx;
            _tableShowSize = CGSizeMake(fbeginx, fEndy);
            
            CGSize contentSize = CGSizeZero;
            if(fEndy - self.bounds.origin.y  > self.bounds.size.height)
            {
                contentSize.height = fEndy - self.bounds.origin.y;
            }else
            {
                contentSize.height = self.bounds.size.height;
            }
            self.contentSize = contentSize;
            
            if (tableview.clBackground != [UIColor clearColor])
            {
                tableview.backgroundColor = [UIColor tztThemeBackgroundColorTableJY];
                tableview.layer.borderColor = [UIColor tztThemeBorderColor].CGColor;
            }
            else
            {
                tableview.layer.borderWidth = 0.f;
            }
        }
    }
    
   
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self keyboardDidHide];
}

-(void) keyboardWasShown:(NSNotification*)notifaction
{
    //UIKeyboardDidShowNotification
    if (notifaction == nil || notifaction.name == nil ||  [notifaction.name compare:TZTUIKeyboardDidShowNotification] != NSOrderedSame)
    {
        return;
    }
    
    UIView *pView = notifaction.object;
    for (int i = 0; i < [_tablelist count]; i++)
    {
        tztUIBaseControlsView* tableview = (tztUIBaseControlsView*)[_tablelist objectAtIndex:i];
        if(tableview)
        {
            [tableview doHiddenDroplistEx:pView];
        }
    }
    
    CGFloat nHeight = 0;
    UIView* keyboardview = (UIView *)notifaction.object;
    if(keyboardview && [keyboardview isKindOfClass:[UIView class]])
    {
        UIView* textview = (UIView *)keyboardview;
        nHeight = [textview gettztwindowy:nil]+textview.frame.size.height;
    }
    else
    {
        return;
    }
    
    BOOL bShowKeyboard = FALSE;
    int nkeyboardHeight = 350;
    if (!IS_TZTIPAD)
        nkeyboardHeight = 216;
    
    if ([keyboardview isKindOfClass:[tztUITextField class]]
        || [keyboardview isKindOfClass:[tztUITextView class]])
    {
        bShowKeyboard = TRUE;
    }
    
    if(bShowKeyboard )
    {
        int nTemp = keyboardHeight;
        if (nHeight > TZTScreenHeight - nkeyboardHeight - TZTNavbarHeight)
        {
            keyboardHeight = nHeight - TZTScreenHeight + nkeyboardHeight+TZTNavbarHeight;
            int nScrollHeight = keyboardHeight;
            keyboardHeight += nTemp;
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationBeginsFromCurrentState:YES];
            [UIView setAnimationDuration:0.3f];
            CGRect rcSub = self.frame;
            CGRect rcTest = rcSub;
            rcTest.origin.y -= nScrollHeight;
            int nOffset = self.contentOffset.y;
            self.frame = rcTest;
            self.contentOffset = CGPointMake(0, nOffset);
            TZTNSLog(@"keyboardWillShow :%d",nScrollHeight);
            [UIView commitAnimations];
        }
    }
}

-(void)keyboardWasHidden:(NSNotification*)notifaction
{
    if (notifaction == nil || notifaction.name == nil ||  [notifaction.name compare:TZTUIKeyboardDidHideNotification] != NSOrderedSame)
    {
        return;
    }
    if (keyboardHeight > 0)
    {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationDuration:0.3f];
        CGRect rcSub = self.frame;
        CGRect rcTest = rcSub;
        rcTest.origin.y += keyboardHeight; //下移
        self.frame = rcTest;
        keyboardHeight = 0;
        [UIView commitAnimations];
        TZTNSLog(@"keyboardWillHideEx");
    }
}

- (void)keyboardDidHide
{
    [tztUIVCBaseView OnCloseKeybord:self];
}

-(BOOL)CheckInput
{
    BOOL bSucc = TRUE;
    NSMutableArray* pAy = [self getBaseControlsWithtableConfig:_tableConfig];
    if (pAy == NULL || [pAy count] < 1)
        return FALSE;
    for (int i = 0; i < [pAy count]; i++)
    {
        tztUIBaseControlsView* pView = [pAy objectAtIndex:i];
        if (pView == NULL)
            continue;
        if (![pView OnCheckData:pView])
            return FALSE;
    }
    
    return bSucc;
}

-(NSMutableArray*)getBaseControlsWithtableConfig:(NSString *)nsConfig
{
    if(_tableControls == nil)
        return nil;
    if(nsConfig && [nsConfig length] > 0)
        return [_tableControls objectForKey:nsConfig];
    return nil;
}

-(UIView*)getCellWithFlag:(NSString *)imageStr
{
    NSMutableArray *pAy = [self getBaseControlsWithtableConfig:_tableConfig];
    if (pAy == NULL || [pAy count] < 1)
        return NULL;
    
    UIView* pReturnView = NULL;
    //若多个表格中的tag值重复，只取第一个
    for (int i = 0; i < [pAy count]; i++)
    {
        tztUIBaseControlsView* pBaseView = [pAy objectAtIndex:i];
        if (pBaseView == NULL)
            continue;
        NSArray* ayCell = [pBaseView getAyCells];
        for (int j = 0; j < [ayCell count]; j++)
        {
            tztUIBaseControlsCell* ptztCell = [ayCell objectAtIndex:j];
            if([imageStr compare:ptztCell.cellname] == NSOrderedSame)
            {
                return ptztCell;
            }
        }
    }
    return pReturnView;
}

-(UIView*)getViewWithTag:(int)nTag
{
    NSMutableArray *pAy = [self getBaseControlsWithtableConfig:_tableConfig];
    if (pAy == NULL || [pAy count] < 1)
        return NULL;
    
    UIView* pReturnView = NULL;
    //若多个表格中的tag值重复，只取第一个
    for (int i = 0; i < [pAy count]; i++)
    {
        tztUIBaseControlsView* pBaseView = [pAy objectAtIndex:i];
        if (pBaseView == NULL)
            continue;
        pReturnView = [pBaseView gettztUIBaseViewWithTag:[NSString stringWithFormat:@"%d", nTag]];
        if (pReturnView != NULL)
            break;
    }
    return pReturnView;
}

-(void)clearControlData
{
    
}

-(void)setLabelText:(NSString *)nsLabel withTag_:(int)nTag
{
    UIView* pLabel = [self getViewWithTag:nTag];
    if (pLabel && [pLabel isKindOfClass:[tztUILabel class]])
    {
        ((tztUILabel*)pLabel).text = nsLabel;
    }
}

-(NSString*)GetLabelText:(int)nTag
{
    UIView* pLabel = [self getViewWithTag:nTag];
    if (pLabel && [pLabel isKindOfClass:[tztUILabel class]])
    {
        return ((tztUILabel*)pLabel).text;
    }
    
    return nil;
}

//编辑框
-(void)setEditorBecomeFirstResponder:(int)nTag
{
    UIView* pEditor = [self getViewWithTag:nTag];
    if (pEditor == NULL)
        return;
    if([pEditor isKindOfClass:[tztUITextField class]])
    {
        [((tztUITextField*)pEditor) becomeFirstResponder];
    }
}

-(void)setEditorResignFirstResponder:(int)nTag
{
    UIView* pEditor = [self getViewWithTag:nTag];
    if (pEditor == NULL)
        return;
    if([pEditor isKindOfClass:[tztUITextField class]])
    {
        [((tztUITextField*)pEditor) resignFirstResponder];
    }
}

-(void)setEditorDotValue:(NSInteger)nDotValue withTag_:(int)nTag
{
    if (nDotValue < 0)
        return;
    UIView* pEditor = [self getViewWithTag:nTag];
    if (pEditor == NULL)
        return;
    if([pEditor isKindOfClass:[tztUITextField class]])
    {
        ((tztUITextField*)pEditor).tztdotvalue = nDotValue;
    }
    
}

-(void)setEditorEnable:(BOOL)bEnable withTag_:(int)nTag
{
    UIView* pEditor = [self getViewWithTag:nTag];
    if (pEditor == NULL)
        return;
    if([pEditor isKindOfClass:[tztUITextField class]])
    {
        ((tztUITextField*)pEditor).enabled = bEnable;
    }
}


-(void)setEditorText:(NSString*)nsText nsPlaceholder_:(NSString*)nsPlaceholder withTag_:(int)nTag
{
    [self setEditorText:nsText nsPlaceholder_:nsPlaceholder withTag_:nTag andNotifi:YES];
}

-(void)setEditorText:(NSString*)nsText nsPlaceholder_:(NSString*)nsPlaceholder withTag_:(int)nTag andNotifi:(BOOL)bNotify
{
    UIView* pEditor = [self getViewWithTag:nTag];
    if (pEditor == NULL)
        return;
    
    if([pEditor isKindOfClass:[tztUITextField class]])
    {
        NSString* lastText = ((tztUITextField*)pEditor).text;
        if (lastText == NULL || (lastText && [lastText compare:nsText] != NSOrderedSame))
        {
            ((tztUITextField*)pEditor).text = nsText;
            
            if (bNotify)
            {
                NSNotification* pNotifi = [NSNotification notificationWithName:UITextFieldTextDidChangeNotification object:pEditor];
                [[NSNotificationCenter defaultCenter] postNotification:pNotifi];
            }
        }
        if (nsPlaceholder)
            ((tztUITextField*)pEditor).placeholder = nsPlaceholder;
    }
}

-(NSString*)GetEidtorText:(int)nTag
{
    UIView* pEditor = [self getViewWithTag:nTag];
    if (pEditor == NULL)
        return nil;
    if([pEditor isKindOfClass:[tztUITextField class]])
        return ((tztUITextField*)pEditor).text;
    else
        return nil;
}

//checkButton
-(void)setCheckBoxValue:(BOOL)bChecked withTag_:(int)nTag
{
    UIView* pCheck = [self getViewWithTag:nTag];
    if (pCheck == NULL)
        return;
    
    if ([pCheck isKindOfClass:[tztUICheckButton class]])
    {
        if (bChecked)
            [(tztUICheckButton*)pCheck settztUIBaseViewValue:@"1"];
        else
            [(tztUICheckButton*)pCheck settztUIBaseViewValue:@"0"];
    }
}

-(BOOL)getCheckBoxValue:(int)nTag
{
    UIView* pCheck = [self getViewWithTag:nTag];
    if (pCheck == NULL)
        return FALSE;
    
    if ([pCheck isKindOfClass:[tztUICheckButton class]])
    {
        return [[(tztUICheckButton*)pCheck gettztUIBaseViewValue] boolValue];
    }
    return FALSE;
}

//下拉
//combox控件可编辑的时候,调用
-(void)setComBoxTextField:(int)nTag
{
    UIView* pComBox = [self getViewWithTag:nTag];
    if (pComBox == NULL)
        return;
    if ([pComBox isKindOfClass:[tztUIDroplistView class]])
    {
        [(tztUIDroplistView*)pComBox setTextFieldText];
    }
}

-(void)setComBoxData:(NSMutableArray*)ayTitle ayContent_:(NSMutableArray*)ayContent AndIndex_:(NSInteger)nIndex withTag_:(int)nTag
{
    UIView* pComBox = [self getViewWithTag:nTag];
    if (pComBox == NULL)
        return;
    if ([pComBox isKindOfClass:[tztUIDroplistView class]])
    {
        if (ayTitle == NULL && ayContent == NULL)
        {
            [((tztUIDroplistView*)pComBox).ayValue removeAllObjects];
            [((tztUIDroplistView*)pComBox).ayData removeAllObjects];
            [((tztUIDroplistView*)pComBox) setText:@""];
            ((tztUIDroplistView*)pComBox).selectindex = -1;
        }
        else
        {
            ((tztUIDroplistView*)pComBox).ayData = ayContent;
            ((tztUIDroplistView*)pComBox).ayValue = ayTitle;
            [((tztUIDroplistView*)pComBox) setSelectindex:nIndex];
        }
    }
}

-(void)setComBoxData:(NSMutableArray*)ayTitle ayContent_:(NSMutableArray*)ayContent AndIndex_:(NSInteger)nIndex withTag_:(int)nTag bDrop_:(BOOL)bDrop
{
    UIView* pComBox = [self getViewWithTag:nTag];
    if (pComBox == NULL)
        return;
    [self setComBoxData:ayTitle ayContent_:ayContent AndIndex_:nIndex withTag_:nTag];
    if ([pComBox isKindOfClass:[tztUIDroplistView class]])
    {
        if (bDrop && ayContent && [ayContent count] > 0)
        {
            [(tztUIDroplistView*)pComBox doShowList:YES];
        }
    }
}

-(void)setComBoxText:(NSString*)nsTitle withTag_:(int)nTag
{
    UIView* pComBox = [self getViewWithTag:nTag];
    if (pComBox == NULL)
        return;
    if ([pComBox isKindOfClass:[tztUIDroplistView class]])
    {
        [(tztUIDroplistView*)pComBox setText:nsTitle];
    }
}

-(NSInteger)getComBoxSelctedIndex:(int)nTag
{
    UIView* pComBox = [self getViewWithTag:nTag];
    if (pComBox == NULL)
        return -1;
    if ([pComBox isKindOfClass:[tztUIDroplistView class]])
        return ((tztUIDroplistView*)pComBox).selectindex;
    
    return -1;
}

-(UIView*)getComBoxViewWith:(int)nTag
{
    return [self getViewWithTag:nTag];
}

-(NSString*)getComBoxText:(int)nTag
{
    UIView* pView = [self getViewWithTag:nTag];
    if (pView == NULL || ![pView isKindOfClass:[tztUIDroplistView class]])
        return @"";
    
    return ((tztUIDroplistView*)pView).text;
}

-(void)setComBoxPlaceholder:(NSString*)nsInfo withTag_:(int)nTag
{
    UIView *pList = [self getViewWithTag:nTag];
    if (pList && [pList isKindOfClass:[tztUIDroplistView class]])
    {
        ((tztUIDroplistView*)pList).placeholder = nsInfo;
    }
}


-(void)setButtonTitle:(NSString*)nsTitle clText_:(UIColor*)clText forState_:(UIControlState)nState withTag_:(int)nTag
{
    UIView* pView = [self getViewWithTag:nTag];
    if (pView == NULL || ![pView isKindOfClass:[tztUIButton class]])
        return;
    
    [(tztUIButton*)pView setTitle:nsTitle forState:nState];
    [(tztUIButton*)pView setTitleColor:clText forState:nState];
}

-(NSString*)getButtonTitle:(int)nTag forState_:(UIControlState)nState
{
    UIView* pView = [self getViewWithTag:nTag];
    if (pView == NULL || ![pView isKindOfClass:[tztUIButton class]])
        return NULL;
    
    return [(tztUIButton*)pView titleForState:nState];
}


//获取列表显示位置
- (CGPoint)tztDroplistView:(tztUIDroplistView*)droplistview point:(CGPoint)listpoint
{
    if (droplistview == NULL)
		return listpoint;
    
	int nMargin = 0;
    int nLeftMargin = 0;
    if( droplistview.frame.size.width < droplistview.listviewwidth)
        nLeftMargin = (droplistview.frame.size.width - droplistview.listviewwidth) / 2;
    
	if (droplistview.droplistViewType & tztDroplistEdit)
	{
		nMargin = droplistview.textfield.frame.size.height;
	}
	else
	{
		nMargin = droplistview.textbtn.frame.size.height;
	}
    int nLeft = nLeftMargin;
    int nHeight = nMargin;
    
    nLeft += [droplistview gettztwindowx:self];
    nHeight += [droplistview gettztwindowy:self] + self.contentOffset.y;
    listpoint.x = nLeft;
    listpoint.y = nHeight;
    
	int nWidth = MAX(droplistview.frame.size.width, droplistview.listviewwidth);
	//右侧无法全部显示
	if (listpoint.x + nWidth > TZTScreenWidth)
	{
		listpoint.x -= ((listpoint.x + nWidth) - TZTScreenWidth);
	}
    return listpoint;
}

//显示列表视图
- (BOOL)tztDroplistView:(tztUIDroplistView*)droplistview showlistview:(UITableView*)listview
{
    CGPoint point = listview.frame.origin;
    point = [self tztDroplistView:droplistview point:point];
    //设置弹出的frame
    listview.frame = CGRectMake(point.x, point.y, listview.frame.size.width, listview.frame.size.height);
    CGRect rcViewFrame = self.frame;
    //获取当前的位置,判断列表是否能显示 modify by xyt 20130822
    CGPoint CurcontentPoint = self.contentOffset;
    if (listview.frame.size.height >= (rcViewFrame.size.height + CurcontentPoint.y - listview.frame.origin.y ))
    {
        if (_tztDelegate)
        {
            float xx = [self gettztwindowy:nil] + droplistview.textfield.frame.size.height / 2;
            
            if ([_tztDelegate isKindOfClass:[UIView class]])
            {
                listview.frame = CGRectMake(point.x, xx, listview.frame.size.width, listview.frame.size.height);
                [_tztDelegate addSubview:listview];
            }
            else if([_tztDelegate isKindOfClass:[UIViewController class]])
            {
                listview.frame = CGRectMake(point.x, xx, listview.frame.size.width, listview.frame.size.height);
                [((UIViewController*)_tztDelegate).view addSubview:listview];
            }
        }
        else
            [self addSubview:listview];
    }
    else
        //    if (_tztDelegate && [_tztDelegate isKindOfClass:[UIViewController class]])
        //    {
        //        //    CGRect rcViewFrame = self.frame;
        //        //    if (listview.frame.size.height >= rcViewFrame.size.height - listview.frame.origin.y )
        //        float xx = [self gettztwindowy:nil] + droplistview.textfield.frame.size.height / 2;
        //        listview.frame = CGRectMake(point.x, xx, listview.frame.size.width, listview.frame.size.height);
        //        [((UIViewController*)_tztDelegate).view addSubview:listview];
        //    }
        //    else if(_tztDelegate && [_tztDelegate isKindOfClass:[UIView class]])
        //    {
        //        float xx = [self gettztwindowy:nil] + droplistview.textfield.frame.size.height / 2;
        //        listview.frame = CGRectMake(point.x, xx, listview.frame.size.width, listview.frame.size.height);
        //        [_tztDelegate addSubview:listview];
        //
        //    }
        //    else
        [self addSubview:listview];
    droplistview.nShowSuper = TRUE;
    [self bringSubviewToFront:listview];
    int nHeight = [listview gettztwindowy:nil] + listview.frame.size.height;
    int nTemp = keyboardHeight;
    if (nHeight > TZTScreenHeight - TZTNavbarHeight)
    {
        keyboardHeight = nHeight - TZTScreenHeight +TZTNavbarHeight;
        int nScrollHeight = keyboardHeight;
        keyboardHeight += nTemp;
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationDuration:0.3f];
        CGRect rcSub = self.frame;
        CGRect rcTest = rcSub;
        rcTest.origin.y -= nScrollHeight;
        if(listview.frame.origin.y + listview.frame.size.height > rcTest.size.height)
        {
            rcTest.size.height = listview.frame.origin.y + listview.frame.size.height;
        }
        self.frame = rcTest;
        TZTNSLog(@"keyboardWillShow :%d",nScrollHeight);
        [UIView commitAnimations];
    }
    
    
    if (_tztDelegate && [_tztDelegate respondsToSelector:@selector(tztDroplistView:showlistview:)])
	{
        [_tztDelegate tztDroplistView:droplistview showlistview:listview];
	}
    return TRUE;
}

// iPad 显示时间选择器的方式
- (void)tztDroplistViewWithDataview_Ipad:(tztUIDroplistView*)droplistview
{
    UIActionSheet* pActionSheet = [[UIActionSheet alloc]
                                   initWithTitle:@"  "
                                   delegate:self
                                   cancelButtonTitle:nil
                                   destructiveButtonTitle:nil
                                   otherButtonTitles:nil];
    
    [pActionSheet addButtonWithTitle:@""];
    [pActionSheet addButtonWithTitle:@""];
    [pActionSheet addButtonWithTitle:@""];
    
	UIDatePicker* picker = [[UIDatePicker alloc] init];
	picker.locale = [[[NSLocale alloc] initWithLocaleIdentifier:@"zh_Hans_CN"] autorelease];
	picker.timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    
    if (droplistview.text.length>0) {
        picker.date = [self NSStringToDate:droplistview.text];
    }
    else{
        picker.date = [NSDate date];
    }
    
    [self setMinAndMaxDatefor:picker];
    
    if (isTodayEnd)
    {
        NSDate *beginDate = [NSDate date]; // 今天
        tztDatePicker.maximumDate = beginDate;
    }
    //iOS8开始64位导致地址长度变更，会出现崩溃
//    long lDropListView = (long)droplistview;
    picker.tag = (NSInteger)droplistview;
//    objc_setAssociatedObject(picker, [NSString stringWithFormat:@"%ld",(long)picker.tag], [NSString stringWithFormat:@"%ld",(long)lDropListView], OBJC_ASSOCIATION_RETAIN);
    
	[picker addTarget:self action:@selector(shouldDatePickerChanged:) forControlEvents:UIControlEventValueChanged];
    
	[picker setFrame:CGRectMake(0, 0, 280,300)] ;
	picker.datePickerMode = UIDatePickerModeDate;
	
    [pActionSheet addSubview:picker];
    [picker release];
    CGRect rcFrame = picker.frame;
    rcFrame.origin.x = droplistview.frame.origin.x + droplistview.frame.size.width/2 - rcFrame.size.width/2;
    rcFrame.origin.y = [self tztDroplistView:droplistview point:droplistview.listView.frame.origin].y - 218;
    
    [pActionSheet showFromRect:rcFrame inView:self.tztDelegate animated:YES];
    [pActionSheet release];
}

-(NSDate *)NSStringToDate:(NSString *)StrDate
{
    NSDateFormatter* dateformatter = [[NSDateFormatter alloc] init];
    NSTimeZone *tz = [NSTimeZone timeZoneWithAbbreviation:@"Asia/Shanghai"];
    [dateformatter setTimeZone:tz];
    [dateformatter setDateFormat:@"yyyyMMdd"];
    NSDate* date = [dateformatter dateFromString:StrDate];
    [dateformatter release];
    return date;
}

// 设置datePicker的时间约束
- (void)setMinAndMaxDatefor:(UIDatePicker*)datePicker
{
    NSDate *today = [NSDate date];
    if (isAMonthAgo)
    {
        NSDate *aMonthAgo = [[NSDate date] dateByAddingTimeInterval:(-30 * 24 * 60 * 60)]; // 把时间提前一个月
        datePicker.minimumDate = aMonthAgo;
    }
    else if (isTomorrowBegin)
    {
        NSDate *tomorrow = [[NSDate date] dateByAddingTimeInterval:(1 * 24 * 60 * 60)]; // 明天
        datePicker.minimumDate = tomorrow;
    }
    else
    {
        datePicker.minimumDate = today;//[NSDate dateWithTimeIntervalSince1970:0];
    }
    
    if (isTodayEnd)
    {
        tztDatePicker.maximumDate = today;
    }
}

//显示时间选择器
- (void)tztDroplistViewWithDataview:(tztUIDroplistView*)droplistview
{
    if (IS_TZTIPAD)
    {
        [self tztDroplistViewWithDataview_Ipad:droplistview];
        return;
    }
    
    if (droplistview == nil)
		return;
	
	UIView *pView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, TZTScreenWidth, TZTScreenHeight)] autorelease];
	[pView setBackgroundColor:[UIColor clearColor]];
	//创建子控件 包括datepiker buttton dengwei
	NSString *strDate = droplistview.text;
	
	NSDateFormatter *dateformatter=nil;
	NSDate *date = nil;
    if(dateformatter==nil)
	{
        dateformatter = [[NSDateFormatter alloc] init];
        NSTimeZone *tz = [NSTimeZone timeZoneWithAbbreviation:@"Asia/Shanghai"];
        [dateformatter setTimeZone:tz];
        
        if (droplistview.droplistViewType & tztDroplistHour)
        {
            [dateformatter setDateFormat:@"HH:mm"];
            if ( strDate && [strDate length] == 5)
            {
                date = [dateformatter dateFromString:strDate];
            }
        }
        else
        {
            [dateformatter setDateFormat:@"yyyyMMdd"];
            if ( strDate && [strDate length] == 8)
            {
                date = [dateformatter dateFromString:strDate];
            }
        }
        
        [dateformatter release];
    }
	
	tztDatePicker = [[[UIDatePicker alloc] init] autorelease];
    //IOS7显示不明显，设置背景颜色
    if (IS_TZTIOS(7))
        [tztDatePicker setBackgroundColor:[UIColor whiteColor]];
	tztDatePicker.tag = (long)droplistview;
	tztDatePicker.locale = [[[NSLocale alloc] initWithLocaleIdentifier:@"zh_Hans_CN"] autorelease];
	tztDatePicker.timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
	if (date == nil)
	{
		tztDatePicker.date = [NSDate date];
        dateformatter = [[NSDateFormatter alloc] init];
        NSTimeZone *tz = [NSTimeZone timeZoneWithAbbreviation:@"Asia/Shanghai"];
        [dateformatter setTimeZone:tz];
        [dateformatter setDateFormat:@"yyyyMMdd"];
        strDate = [dateformatter stringFromDate:[NSDate date]];
        droplistview.text = strDate;
        [dateformatter release];
	}
	else
	{
		tztDatePicker.date = date;
	}
	//选择得最大日期为当天
	//m_tztDatePicker.maximumDate = [NSDate date];
	[tztDatePicker addTarget:self action:@selector(shouldDatePickerChanged:) forControlEvents:UIControlEventValueChanged];
	//UIDatePicker控件自身有个最小和最大高度值大约在150--250
	CGRect rcPicker = tztDatePicker.frame;
	[tztDatePicker setFrame:CGRectMake(0, 0, TZTScreenWidth,280)] ;
	
    if (droplistview.droplistViewType & tztDroplistHour)
    {
        tztDatePicker.datePickerMode = UIDatePickerModeTime;
    }
    else
    {
        tztDatePicker.datePickerMode = UIDatePickerModeDate;
        
        [self setMinAndMaxDatefor:tztDatePicker];
        
    }
	
	CGRect rcView = pView.frame;
#ifdef tzt_NewVersion
	tztDatePicker.frame = CGRectMake(0, rcView.size.height - rcPicker.size.height - g_pToolBarView.frame.size.height , TZTScreenWidth, rcPicker.size.height);
#else
	tztDatePicker.frame = CGRectMake(0, rcView.size.height - rcPicker.size.height, TZTScreenWidth, rcPicker.size.height);
#endif
	//添加按钮
    if([_tztDelegate isKindOfClass:[UIView class]])
        [_tztDelegate addSubview:tztDatePicker];
    else if([_tztDelegate isKindOfClass:[UIViewController class]])
        [((UIViewController*)_tztDelegate).view addSubview:tztDatePicker];
    else
        [self addSubview:tztDatePicker];
	
	//加上动画效果，从底部弹出来
	CATransition *animation = [CATransition animation];//初始化动画
	animation.duration = 0.2f;//间隔的时间
	animation.timingFunction = UIViewAnimationCurveEaseInOut;//过渡效果
	animation.type = kCATransitionPush;//设置上面4种动画效果
	animation.subtype = kCATransitionFromTop;//设置动画的方向，有四种，分别为kCATransitionFromRight、kCATransitionFromLeft、kCATransitionFromTop、kCATransitionFromBottom
	[tztDatePicker.layer addAnimation:animation forKey:@"animationID"];
}

//删除列表数据
- (BOOL)tztDroplistView:(tztUIDroplistView *)droplistview didDeleteIndex:(NSInteger)index
{
    if (_tztDelegate && [_tztDelegate respondsToSelector:@selector(tztDroplistView: didDeleteIndex:)])
    {
        return [_tztDelegate tztDroplistView:droplistview didDeleteIndex:index];
    }
    return TRUE;
}


-(void)OnButtonClick:(id)sender
{
    if (_tztDelegate && [_tztDelegate respondsToSelector:@selector(OnButtonClick:)])
    {
        [_tztDelegate OnButtonClick:sender];
    }
}

- (void)tztUIBaseView:(UIView *)tztUIBaseView checked:(BOOL)checked
{
    if (_tztDelegate && [_tztDelegate respondsToSelector:@selector(tztUIBaseView:checked:)])
    {
        [_tztDelegate tztUIBaseView:tztUIBaseView checked:checked];
    }
}

//日期发生变化
-(void)shouldDatePickerChanged:(UIDatePicker*)picker
{
	if (picker == nil)
		return;
    
//    NSString* strShowType = objc_getAssociatedObject(picker, &vcShowType);
//    if(strShowType)
    
	tztUIDroplistView *pSlider = (tztUIDroplistView*)picker.tag;
	if ([pSlider isKindOfClass:[tztUIDroplistView class]])
	{
		NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
		//设定时间格式,这里可以设置成自己需要的格式
        if (pSlider.droplistViewType & tztDroplistDate)
            [dateFormatter setDateFormat:@"yyyyMMdd"];
        else
            [dateFormatter setDateFormat:@"HH:mm"];
		NSString * nowDate = [dateFormatter stringFromDate:picker.date];
		if (pSlider)
			pSlider.text = nowDate;
		[dateFormatter release];
	}
}

- (void)tztDroplistViewWithDataviewHide:(tztUIDroplistView*)droplistview
{
    CATransition *animation = [CATransition animation];//初始化动画
	animation.duration = 0.2f;//间隔的时间
	animation.timingFunction = UIViewAnimationCurveEaseInOut;//过渡效果
	animation.type = kCATransitionPush;//设置上面4种动画效果
	animation.subtype = kCATransitionFromBottom;//设置动画的方向，有四种，分别为kCATransitionFromRight、kCATransitionFromLeft、kCATransitionFromTop、kCATransitionFromBottom
	[tztDatePicker.layer addAnimation:animation forKey:@"animationID"];
    tztDatePicker.hidden = YES;
}



//回调事件 tztEdit
- (void)tztUIBaseView:(UIView *)tztUIBaseView textchange:(NSString *)text
{
    if ([tztUIBaseView isKindOfClass:[tztUITextField class]])
    {
        if (_tztDelegate && [_tztDelegate respondsToSelector:@selector(tztUIBaseView:textchange:)])
        {
            [_tztDelegate tztUIBaseView:tztUIBaseView textchange:text];
        }
        
    }
    
}


-(void)tztUIBaseView:(UIView *)tztUIBaseView focuseChanged:(NSString *)text
{
    if ([tztUIBaseView isKindOfClass:[tztUITextField class]])
    {
        if (_tztDelegate && [_tztDelegate respondsToSelector:@selector(tztUIBaseView:focuseChanged:)])
        {
            [_tztDelegate tztUIBaseView:tztUIBaseView focuseChanged:text];
        }
    }
}

-(void)tztUIBaseView:(UIView *)tztUIBaseView beginEditText:(NSString *)text
{
    if ([tztUIBaseView isKindOfClass:[tztUITextField class]])
    {
        if (_tztDelegate && [_tztDelegate respondsToSelector:@selector(tztUIBaseView:beginEditText:)])
        {
            [_tztDelegate tztUIBaseView:tztUIBaseView beginEditText:text];
        }
    }
}


//选中列表数据
- (void)tztDroplistView:(tztUIDroplistView *)droplistview didSelectIndex:(NSInteger)index
{
    if(_tztDelegate && [_tztDelegate respondsToSelector:@selector(tztDroplistView: didSelectIndex:)])
        [_tztDelegate tztDroplistView:droplistview didSelectIndex:index];
    
}

//zxl 20131022 开始显示数据前处理
- (void)tztDroplistViewBeginShowData:(tztUIDroplistView*)droplistview
{
    if (_tztDelegate && [_tztDelegate respondsToSelector:@selector(tztDroplistViewBeginShowData:)])
    {
        [_tztDelegate tztDroplistViewBeginShowData:droplistview];
    }
}

-(void)tztDroplistViewGetData:(tztUIDroplistView*)droplistview
{
    if (_tztDelegate && [_tztDelegate respondsToSelector:@selector(tztDroplistViewGetData:)])
        [_tztDelegate tztDroplistViewGetData:droplistview];
}


-(void)OnRefreshTableView
{
    if(_tablelist)
    {
        for (int y = 0; y < [_tablelist count]; y++)
        {
            tztUIBaseControlsView* tableview = (tztUIBaseControlsView*)[_tablelist objectAtIndex:y];
            [tableview OnRefreshView];
        }
    }
}
//根据某行的Image来设置是否隐藏
-(void)SetImageHidenFlag:(NSString *)ImageStr bShow_:(BOOL)Show
{
    for (int i = 0; i < [_tablelist count]; i++)
    {
        UIView *view = [_tablelist objectAtIndex:i];
        if ([view isKindOfClass:[tztUIBaseControlsView class]])
        {
            tztUIBaseControlsView * tableview = (tztUIBaseControlsView *)view;
            NSArray* tablelist = [tableview.tableinfo objectForKey:@"tablelist"];
            for (int y = 0; y < [tablelist count]; y++)
            {
                NSDictionary* listdata = [tablelist objectAtIndex:y];
                if(listdata == nil)
                    continue;
                NSString* cellname = [listdata objectForKey:@"Image"];
                if ([cellname compare:ImageStr] == NSOrderedSame)
                {
                    if (Show)
                    {
                        [listdata setValue:@"1" forKey:@"Show"];
                    }
                    else
                    {
                        [listdata setValue:@"0" forKey:@"Show"];
                    }
                }
            }
        }
    }
}

-(void)setButtonBGImage:(UIImage *)Image withTag_:(int)nTag
{
    UIView* pView = [self getViewWithTag:nTag];
    if (pView == NULL || ![pView isKindOfClass:[tztUIButton class]])
        return;
    [(tztUIButton*)pView setTztBackgroundImage:Image];
}

-(void)setComBoxShowType:(tztDroplistViewType)type withTag_:(int)nTag
{
    UIView* pComBox = [self getViewWithTag:nTag];
    if (pComBox == NULL)
        return;
    if ([pComBox isKindOfClass:[tztUIDroplistView class]])
    {
        ((tztUIDroplistView*)pComBox).droplistViewType |= type;
    }
}
@end
