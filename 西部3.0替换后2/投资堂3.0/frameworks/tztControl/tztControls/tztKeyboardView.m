//
//  NumberKeyboard.m
//  medcalc
//
//  Created by Pascal Pfiffner on 03.09.08.
//	Copyright 2009 MedCalc. All rights reserved.
//  This sourcecode is released under the Apache License, Version 2.0
//  http://www.apache.org/licenses/LICENSE-2.0.html
//  
//  A custom keyboard that allows to input numerical values and change units
// 

#import "tztKeyboardView.h"
@interface tztKeyboardView ()<UITableViewDataSource, UITableViewDelegate>
- (void)onButtonShift;
@end

@implementation tztKeyboardView
@synthesize textView = _textView;
@synthesize keyboardViewType = _keyboardViewType;
@synthesize tztdotvalue = _tztdotvalue;
static tztKeyboardView* keyboardviewInstance = nil;
+(tztKeyboardView *)shareKeyboardView
{
    if(keyboardviewInstance == nil)
    {
        UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
        CGRect frame;
        if(UIDeviceOrientationIsLandscape(orientation))
            frame = CGRectMake(0, 0, 480, 162);
        else
            frame = CGRectMake(0, 0, 320, 216);
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"tztStockKeyboardView" owner:self options:nil];
        if(nib && [nib count] > 0 )
        {
            keyboardviewInstance = [[nib objectAtIndex:0] retain];
            keyboardviewInstance.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"TZTKeyBoardBg.png"]];
            [keyboardviewInstance setFrame:frame];
            keyboardviewInstance.keyboardViewType = tztKeyboardViewTypeNon;
            return keyboardviewInstance;
        }
        return nil;
    }
    return keyboardviewInstance;
}

- (void) dealloc			// will never be called anyway! (Singleton)
{
    [self removeCustomButton];
	[super dealloc];
}

-(id)awakeAfterUsingCoder:(NSCoder *)aDecoder
{
    self = [super awakeAfterUsingCoder:aDecoder];
    return self;
}

-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    self.backgroundColor = [UIColor tztThemeBackgroundColor];
    
    self.layer.borderColor = [UIColor colorWithTztRGBStr:@"137,137,137"].CGColor;
    self.layer.borderWidth = 1.f;
    
    if (self.tableView)
    {
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.clipsToBounds = YES;
        self.tableView.layer.borderWidth = 1.f;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableView.layer.borderColor = [UIColor colorWithTztRGBStr:@"137,137,137"].CGColor;
        self.tableView.layer.cornerRadius = 4.5;
    }
    
    for (UIView* subview in self.subviews)
    {
        NSString *className = NSStringFromClass([subview class]);
        if ([className isEqualToString:@"UIButton"])
        {
            UIButton *btn = (UIButton*)subview;
            btn.clipsToBounds = YES;
            if (btn.tag != 600 && btn.tag != 601 && btn.tag != 602 && btn.tag != 603)
            {
                btn.layer.cornerRadius = 6.5;
                btn.layer.borderWidth = 1.0f;
            }
            else
            {
                [btn.titleLabel setFont:tztUIBaseViewTextFont(14)];
                [btn setBackgroundImage:[UIImage tztCreateImageWithColor:[UIColor colorWithTztRGBStr:@"204,204,204"]] forState:UIControlStateNormal];
                [btn setBackgroundImage:[UIImage tztCreateImageWithColor:[UIColor whiteColor]] forState:UIControlStateHighlighted];
                btn.hidden = YES;
                continue;
            }
            CGRect rcFrame = btn.frame;
            btn.frame = rcFrame;
            rcFrame = CGRectInset(rcFrame, 0, 1);
            [btn setTztTitleColor:[UIColor blackColor]];
            btn.layer.borderColor = [UIColor colorWithTztRGBStr:@"137,137,137"].CGColor;
            if ((subview.tag >= 0 && subview.tag <= 9) || subview.tag == 901 )
            {
                [btn.titleLabel setFont:tztUIBaseViewTextFont(18)];
                [btn setBackgroundImage:[UIImage tztCreateImageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
                [btn setBackgroundImage:[UIImage tztCreateImageWithColor:[UIColor colorWithTztRGBStr:@"204,204,204"]] forState:UIControlStateHighlighted];
            }
            else
            {
                [btn.titleLabel setFont:tztUIBaseViewTextFont(14)];
                [btn setBackgroundImage:[UIImage tztCreateImageWithColor:[UIColor colorWithTztRGBStr:@"204,204,204"]] forState:UIControlStateNormal];
                [btn setBackgroundImage:[UIImage tztCreateImageWithColor:[UIColor whiteColor]] forState:UIControlStateHighlighted];
            }
        }
        else if (subview.tag == 1000)
        {
            subview.layer.borderWidth = 1.0f;
            subview.layer.cornerRadius = 4.5f;
            subview.layer.borderColor = [UIColor colorWithTztRGBStr:@"137,137,137"].CGColor;
            subview.hidden = YES;
        }
    }
}

#pragma mark -
- (BOOL)enableInputClicksWhenVisible
{
    return YES;
}

- (IBAction)onButtonPressed:(id)sender
{
    [[UIDevice currentDevice] playInputClick];
	if (!_textView)
    {
		return;
	}
    if ([self.textView isKindOfClass:[UITextView class]])
    {
    }
    else if ([self.textView isKindOfClass:[UITextField class]])
    {
    }
    else
    {
        TZTLogError(@"textView类型:%@%@",NSStringFromClass([_textView class]),@"不支持");
        return;
    }
    UIButton* preBtn = (UIButton *)sender;
    if(preBtn.tag < 900)//文本
    {
        if ([self CanInsert:sender])
        {
            [_textView insertText:[preBtn titleLabel].text];
        }
    }
    else
    {
        switch (preBtn.tag)//功能
        {
            case 901://. 数字是否需要判断
            {
                if ([self CanInsert:sender])
                {
                    NSString* strValue = @"";
                    if ([self.textView isKindOfClass:[UITextView class]])
                    {
                        strValue = ((UITextView*)self.textView).text;
                    }
                    else if ([self.textView isKindOfClass:[UITextField class]])
                    {
                        strValue = ((UITextField*)self.textView).text;
                    }
                    if (strValue.length <= 0 && (self.keyboardViewType & tztKeyboardViewIsNumber))
                    {
                        strValue = [NSString stringWithFormat:@"0%@",[preBtn titleLabel].text];
                    }
                    else
                        strValue = [preBtn titleLabel].text;
                    [_textView insertText:strValue];
                }
            }
                break;
            case 902: //确定
            case 903: //隐藏
            {
                if ([self.textView isKindOfClass:[UITextView class]])
                    [(UITextView *)self.textView resignFirstResponder];
                
                else if ([self.textView isKindOfClass:[UITextField class]])
                    [(UITextField *)self.textView resignFirstResponder];
            }
                break;
            case 904: //删除
                if(_textView && [_textView respondsToSelector:@selector(deleteBackward)])
                {
                    [_textView deleteBackward];
                }
                else
                {
                    id tempTextView = _textView;
                    if([[tempTextView text] length] <= 0)
                        return;
                    NSMutableString* strText = [[NSMutableString alloc] initWithString:[tempTextView text]];
                    NSRange theRange = NSMakeRange(strText.length-1, 1);
                    [strText deleteCharactersInRange:theRange];
                    [tempTextView setText:[NSString stringWithFormat:@"%@",strText]];
                    [strText release];
                    [tempTextView setNeedsDisplay];
                }
                break;
            case 905: //shift
                break;
            case 906: //123
                break;
            case 907: //system
            case 908: //ABC
            {
                id tempTextView = _textView;
                [tempTextView setInputView:nil];
                [tempTextView reloadInputViews];
                [self addCustomButton:@"More-Key" title:@"123"];
            }
                break;
            case 909://清空
            {
                id tempTextView = _textView;
                if([[tempTextView text] length] <= 0)
                    return;
                [tempTextView setText:[NSString stringWithFormat:@"%@",@""]];
                [tempTextView setNeedsDisplay];
            }
                break;
            default:
                break;
        }
    }
    
}

- (UIView *)findKeyView:(NSString *)name inView:(UIView *)view
{
	for (id subview in view.subviews)
	{
		NSString *className = NSStringFromClass([subview class]);
		if ([className isEqualToString:@"UIKBKeyView"])
		{
            if ([subview respondsToSelector:@selector(key)])
            {
                id subviewkey = [subview key];
                if([subviewkey respondsToSelector:@selector(name)])
                {
                    NSString* strKeyname = [NSString stringWithFormat:@"%@",[subviewkey name]];
                    if ((name == nil) || [name isEqualToString:strKeyname])
                    {
                        return subview;
                    }
                }
            }
		}
		else 
		{
            UIView *subview2 = [self findKeyView:name inView:subview];
            if(subview2)
                return subview2;
		}
	}
	return nil;
}


- (UIView *)findKeyView:(NSString *)name
{
	NSArray *windows = [[UIApplication sharedApplication] windows];
	if (windows.count < 2) return nil;
	return [self findKeyView:name inView:[windows objectAtIndex:1]];
}

- (void)onClick123:(id)sender
{
    if ([self.textView isKindOfClass:[UITextView class]])
    {
        UITextView * pActiveView = (UITextView *)self.textView;
        tztKeyboardView* ppKeyboard = [tztKeyboardView shareKeyboardView];
        if(ppKeyboard)
        {
            [self removeCustomButton];
            [pActiveView setInputView:ppKeyboard];
            [pActiveView reloadInputViews];
        }

    }
    else if ([self.textView isKindOfClass:[UITextField class]])
    {
        UITextField * pActiveView = (UITextField *)self.textView;
        tztKeyboardView* ppKeyboard = [tztKeyboardView shareKeyboardView];
        if(ppKeyboard)
        {
            [self removeCustomButton];
            [pActiveView setInputView:ppKeyboard];
            [pActiveView reloadInputViews];
        }
        
    }
}

- (void)removeCustomButton
{
    if(_customButton)
    {
        [_customButton removeFromSuperview];
        _customButton = nil;
    }
}

- (void)addCustomButton:(NSString *)name title:(NSString *)title
{
	UIView *view = [self findKeyView:name];
	if (view)
	{
        [self removeCustomButton];
        if (tztKeyBoardViewIsSys & _keyboardViewType)
            return;
        if(_customButton == nil)
        {
            CGFloat y = [view gettztwindowy:nil];
            CGFloat x = [view gettztwindowx:nil];
            _customButton = [[UIButton alloc] initWithFrame:CGRectMake(x, y, view.frame.size.width, view.frame.size.height)];
            [_customButton addTarget:self action:@selector(onClick123:) forControlEvents:UIControlEventTouchUpInside];
            [view.window addSubview:_customButton];
            [_customButton release];
        }
	}
}

-(void)setKeyboardViewType:(tztKeyboardViewType)keyboardViewType
{
    _keyboardViewType = keyboardViewType;
    UIButton* pBtnABC = (UIButton*)[self viewWithTag:908];
    if ((tztKeyboardViewNOABC & _keyboardViewType))
    {
        pBtnABC.enabled = FALSE;
    }
    else
    {
        pBtnABC.enabled = TRUE;
    }
    
    UIButton* pBtnDot = (UIButton*)[self viewWithTag:901];
    if ((tztKeyboardViewNODot & _keyboardViewType))
    {
        pBtnDot.enabled = FALSE;
    }
    else
    {
        pBtnDot.enabled = TRUE;
    }
}

//输入判断
-(BOOL)CanInsert:(id)sender
{
    if (!_textView)
    {
		return NO;
	}
    
    UIButton *pBtn = (UIButton*)sender;
    NSString* nsValue = nil;
    if ([self.textView isKindOfClass:[UITextView class]])
    {
        nsValue = ((UITextView*)self.textView).text;
    }
    else if ([self.textView isKindOfClass:[UITextField class]])
    {
        nsValue = ((UITextField*)self.textView).text;
    }
    else
    {
        TZTLogError(@"textView类型:%@%@",NSStringFromClass([_textView class]),@"不支持");
        return NO;
    }
    
    //纯数值判断比较
    if (tztKeyboardViewIsNumber & _keyboardViewType)
    {
        //输入(.)
        if (pBtn.tag == 901)//判断是否已经输入过(.)，输入过后，不可重复输入
        {
            return (0 == [nsValue rangeOfString:@"."].length);
        }
        if ([nsValue rangeOfString:@"."].length > 0)//已经输入过小数点
        {
//            NSInteger nCount = 10;
//            if (self.tztdotvalue < 1)//
//            {
//                nCount = 1;
//            }
//            else
//            {
//                for (int i = 1; i < self.tztdotvalue; i++)
//                {
//                    nCount *= 10;
//                }
//            }
            //格式化
//            NSString* nsFormat = @"";;
            //根据小数点跟个字符串，然后操作
            NSArray *ay = [nsValue componentsSeparatedByString:@"."];
            NSString *strFirst = [ay objectAtIndex:0];
//            NSInteger nNum = [[ay objectAtIndex:0] intValue];//小数点前的数值
            NSString* str = [ay objectAtIndex:1];
            if (str && [str length] > 0)//小数点后已经输入过值了
            {
                if ([str length] >= self.tztdotvalue)//超过了允许的小数点位数，不可输入
                    return NO;
                
                //字符串追加需要输入的数字
                str = [NSString stringWithFormat:@"%@%@", str, [pBtn titleLabel].text];
                if ([str length] >= self.tztdotvalue)//超过截断
                {
                    str = [str substringToIndex:self.tztdotvalue];
                }
//                int nsub = [str intValue];
//                //取当前的长度和小数点位数判断，取小的进行格式化
//                nsFormat = [NSString stringWithFormat:@"%%.%df",MIN(self.tztdotvalue, [str length])];
//                //重新计算当前的小数点位数
//                nCount = 10;
//                for (int i = 1; i < MIN(self.tztdotvalue, [str length]); i++)
//                {
//                    nCount *= 10;
//                }
//                //生成新的
//                nsValue = [NSString stringWithFormat:nsFormat, (float)(nNum + ((float)nsub/nCount))];
                nsValue = [NSString stringWithFormat:@"%@.%@", strFirst, str];
            }
            else
            {
                NSString* title = [pBtn titleLabel].text;
                if ([title length] >= self.tztdotvalue)
                {
                    title = [title substringToIndex:self.tztdotvalue];
                }
//                int nsub = [title intValue];
//                //没有输入过小数点后的数值，则认为是第一个
//                nCount = 10;
//                for (int i = 1; i < MIN(self.tztdotvalue, [title length]); i++)
//                {
//                    nCount *= 10;
//                }
//                nsFormat = [NSString stringWithFormat:@"%%.%df",MIN(self.tztdotvalue, [title length])];
//                nsValue = [NSString stringWithFormat:nsFormat, (float)(nNum + ((float)nsub/nCount))];
                nsValue = [NSString stringWithFormat:@"%@.%@", strFirst, title];
            }
        }
        else//没有小数点，则直接输入拼接，去掉开始的0
        {
            nsValue = [NSString stringWithFormat:@"%@%@", nsValue, [pBtn titleLabel].text];
            
            while ([nsValue hasPrefix:@"0"] && [nsValue length] > 1)
            {
                NSString* strValue = [nsValue substringFromIndex:1];
                if ([nsValue hasPrefix:@"."])
                {
                    
                }
                else
                    nsValue = [NSString stringWithFormat:@"%@", strValue];
            }
        }
        if ([self.textView isKindOfClass:[UITextView class]])
        {
            [(UITextView*)self.textView setText:nsValue];
            return NO;
        }
        else if ([self.textView isKindOfClass:[UITextField class]])
        {
            [(UITextField*)self.textView setText:nsValue];
            NSNotification* pNotifi = [NSNotification notificationWithName:UITextFieldTextDidChangeNotification object:self.textView];
            [[NSNotificationCenter defaultCenter] postNotification:pNotifi];
            return NO;
        }
    }
    return TRUE;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 39;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* CellIndenter = @"tztTableMenu";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIndenter];
    if (cell == nil)
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIndenter] autorelease];
        cell.textLabel.font = tztUIBaseViewTextFont(14);
        cell.backgroundColor = [UIColor colorWithTztRGBStr:@"204,204,204"];
        CGRect rcLine = cell.frame;
        
        rcLine.origin.y += 39 - 1;
        rcLine.size.height = .5f;
        UIView *pLine = [[UIView alloc] initWithFrame:rcLine];
        pLine.backgroundColor = [UIColor grayColor];
        [cell addSubview:pLine];
        [pLine release];
    }
    switch (indexPath.row)
    {
        case 0:
        {
            cell.textLabel.text = @"600";
        }
            break;
        case 1:
        {
            cell.textLabel.text = @"601";
        }
            break;
        case 2:
        {
            cell.textLabel.text = @"000";
        }
            break;
        case 3:
        {
            cell.textLabel.text = @"300";
        }
            break;
            
        default:
            break;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.selected = NO;
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.tag = [cell.textLabel.text intValue];
    [btn setTztTitle:cell.textLabel.text];
    [self onButtonPressed:btn];
}

@end