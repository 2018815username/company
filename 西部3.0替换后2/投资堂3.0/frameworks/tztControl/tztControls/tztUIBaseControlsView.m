//
//  tztUIBaseControlsView.m
//  tztMobileApp
//
//  Created by yangdl on 13-2-23.
//  Copyright (c) 2013年 投资堂. All rights reserved.
//
#import "tztUIBaseControlsView.h"
#import "tztUIVCBaseView.h"

#define tztCellTagMultiple 100
#define tztControlsTagMultiple 1

#define tzttablelist @"tablelist"
#define tzttableproperty @"tableproperty"

#define tztcelllineimage @""

#define tztcellname @"Image"
#define tztcellcreate @"Create"
#define tztcellshow @"Show"
#define tztcellarray @"itemarray"

#define tztcontrolstype @"itemtype" 
#define tztcontrolsproperty @"itemproperty"

#define tztGrayWhite [UIColor colorWithRed:237.0/255 green:237.0/255 blue:237.0/255 alpha:1.0]
#define tztBorderColor [UIColor colorWithRed:211.0/255 green:211.0/255 blue:211.0/255 alpha:1.0]


int g_nJYBackBlackColor = 0;
@interface tztUIBaseControlsCell (tztPrivate)
- (void)initdata;
- (void)initsubframe;
@end

@implementation tztUIBaseControlsCell
@synthesize minHeight = _minHeight;
@synthesize maxHeight = _maxHeight;
@synthesize cellname = _cellname;//Cell名称
@synthesize bgridline = _bgridline;
@synthesize tztdelegate = _tztdelegate;
@synthesize nsgridcolor = _nsgridcolor;
@synthesize bDetailShow = _bDetailShow;
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
    if(self)
    {
        [self initdata];
        [self initsubframe];
    }
    return self;
}

- (void)initdata
{
    NilObject(self.cellname);
    NilObject(self.tztdelegate);
    self.minHeight = 0;
    self.bgridline = TRUE;
    self.maxHeight = CGFLOAT_MAX;
    self.nsgridcolor = [UIColor tztThemeGridColorString];
}

- (void)dealloc
{
    NilObject(self.cellname);
    NilObject(self.tztdelegate);
    [super dealloc];
}

- (void)initsubframe
{
    CGRect frame = self.frame;
    if(frame.size.height > 0 && frame.size.height > self.maxHeight)
    {
        frame.size.height = self.maxHeight;
        [super setFrame:frame];
    }
    [self setBgridline:_bgridline];
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [self initsubframe];
}
//设置分隔线
- (void)setBgridline:(BOOL)bgridline
{
    _bgridline = bgridline;
    if(_bgridline)
    {
        //分割线view
        if(_lineview == nil)
        {
            _lineview = [[UIView alloc]init];
            //设置为半透明
            [_lineview setAlpha:0.5];
            CGRect lineframe = CGRectMake(2,0, self.bounds.size.width-4, 0.5);
            _lineview.frame = lineframe;
            [self addSubview:_lineview];
            [_lineview release];
        }
        else
        {
            CGRect lineframe = CGRectMake(2,0, self.bounds.size.width-4, 0.5);
            _lineview.frame = lineframe;
        }
        UIImage * lineimage = [UIImage imageTztNamed:tztcelllineimage];
        if (lineimage)
        {
            _lineview.backgroundColor = [UIColor colorWithPatternImage:lineimage];
        }
        else
        {
            if (self.nsgridcolor.length > 0)
            {
                lineimage = [UIImage imageTztNamed:self.nsgridcolor];
                if (lineimage)
                    _lineview.backgroundColor = [UIColor colorWithPatternImage:lineimage];
                else
                    _lineview.backgroundColor = [UIColor colorWithTztRGBStr:self.nsgridcolor];//[UIColor darkGrayColor];
            }
            else
                _lineview.backgroundColor = [UIColor colorWithTztRGBStr:@"43,43,43"];
        }
//          }
//        CGRect lineframe = CGRectMake(2,0, self.bounds.size.width-4, 1);
//        _lineview.frame = lineframe;
    }
    if(_lineview)
        _lineview.hidden = (!_bgridline);
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (_tztdelegate && [_tztdelegate respondsToSelector:@selector(keyboardDidHide)]) 
	{
		[_tztdelegate keyboardDidHide];
	}
}

@end

@interface tztUIBaseControlsView (tztPrivate)
- (void)initdata;
- (void)initsubframe;
//创建table
- (void)onCreateTable:(BOOL)bReload;
//创建tablecell
- (void)onCreateTableCell:(tztUIBaseControlsCell*)tablecell data:(NSDictionary*)listdata reload:(BOOL)bReload;
//创建控件
- (CGSize)onCreateControlswithCell:(tztUIBaseControlsCell *)cell controls:(NSDictionary*)controls atIndex:(int)iIndex orgx:(CGFloat)orgx reload:(BOOL)bReload;
//设置控件位置 //zxl 20131009 修改了控件的设置位置
- (CGFloat)setControlsFrame:(UIView *)tztUIBaseView orgx:(CGFloat)orgx maxwidth:(CGFloat)maxwidth maxheight:(CGFloat)maxheight;
@end

@implementation tztUIBaseControlsView

@synthesize bGridLine = _bGridLine;
@synthesize nRadius = _nRadius;
@synthesize bAutoCalcul = _bAutoCalcul;
@synthesize tableinfo = _tableinfo;
@synthesize cellheight = _cellheight;
@synthesize viewMaxheight = _viewMaxheight;
@synthesize tztdelegate = _tztdelegate;
@synthesize clBackground = _clBackground;
@synthesize nsgridcolor = _nsgridcolor;
@synthesize bDetailShow = _bDetailShow;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) 
    {
        [self initdata];
    }
    return self;
}

-(NSArray*)getAyCells
{
    return _tablecells;
}

- (void)dealloc
{
    if(_tablecells)
    {
        for (int i = 0; i < [_tablecells count]; i++)
        {
            tztUIBaseControlsCell* pCell = (tztUIBaseControlsCell *)[_tablecells objectAtIndex:i];
            if(pCell)
            {
                [pCell removeFromSuperview];
            }
        }
        [_tablecells removeAllObjects];
        [_tablecells release];
        _tablecells = nil;
    }
    if(_tableControls)
    {
        [_tableControls removeAllObjects];
        [_tableControls release];
        _tableControls = nil;
    }
    NilObject(self.tztdelegate);
    NilObject(self.tableinfo);
    [super dealloc];
}

- (void)initdata
{
    self.layer.borderColor = [UIColor colorWithRGBULong:0x262626].CGColor;
    self.layer.borderWidth = .5f;
    self.nRadius = tztUIBaseViewTableRadius;
    self.bGridLine = TRUE;
    self.bAutoCalcul = TRUE;
//    self.bounces = FALSE;
    self.cellheight = tztUIBaseViewTableCellHeight;
    NilObject(self.tztdelegate);
    NilObject(self.tableinfo);
    if(_tablecells == nil)
        _tablecells = NewObject(NSMutableArray);
    self.clBackground = [UIColor colorWithRGBULong:0x262626];
    [_tablecells removeAllObjects];

}

- (void)setNRadius:(int)nRadius
{
    _nRadius = nRadius;
    if(_nRadius > 0 )
    {
        self.layer.borderWidth = .5f;
        self.layer.cornerRadius = _nRadius;
    }
    else
    {
        _nRadius = 0;
        self.layer.borderWidth = 0;
        self.layer.cornerRadius = _nRadius;
    }
}

- (void)initsubframe
{
    [self onCreateTable:FALSE];
}

- (void)setClBackground:(UIColor *)clColor
{
    _clBackground = [clColor retain];
    self.backgroundColor = _clBackground;
}

- (void)setFrame:(CGRect)frame
{
    CGRect oldbounds = self.bounds;
    [super setFrame:frame];
    CGRect newbounds = self.bounds;
    if(!CGRectEqualToRect(oldbounds, newbounds))
        [self initsubframe];
    _viewMaxheight = MAX(_viewMaxheight,self.bounds.size.height);
}

- (void)setListViewData:(NSArray*)aylist withdata:(NSArray *)aydata
{
    if ([aylist count] != [aydata count])
        return;
    
    NSArray *ayTitle = [aylist retain];
    NSArray *ayContent = [aydata retain];
    NSMutableDictionary* tableinfo = NewObject(NSMutableDictionary);
    NSMutableArray* tablelist = NewObject(NSMutableArray);
    for (int i = 0; i < [ayTitle count]; i++)
    {
        NSMutableDictionary* listdata = NewObject(NSMutableDictionary);
        NSString* strKey = [NSString stringWithFormat:@"tztlistdetail%d",i]; //cellname
        [listdata setValue:strKey forKey:tztcellname]; //
        
            NSMutableArray* itemarray = NewObject(NSMutableArray);
                NSMutableDictionary* arraylabel = NewObject(NSMutableDictionary);
                [arraylabel setObject:@"TZTLabel" forKey:tztcontrolstype];//controls type
                if (g_nJYBackBlackColor)
                {
                    [arraylabel setObject:[NSString stringWithFormat:@"text=  %@|textcolor=123,123,123|rect=,,120,|adjustsfontsizetofitwidth=1|",[ayTitle objectAtIndex:i]] forKey:tztcontrolsproperty];//controls property
                }else
                {
                    [arraylabel setObject:[NSString stringWithFormat:@"text=  %@|textcolor=0,0,0|rect=,,120,|adjustsfontsizetofitwidth=1|", [ayTitle objectAtIndex:i]] forKey:tztcontrolsproperty];//controls property
                }
                
                    [itemarray addObject:arraylabel];
            [arraylabel release];
        
                NSMutableDictionary* arraytextview = NewObject(NSMutableDictionary);
                [arraytextview setObject:@"TZTTextView" forKey:tztcontrolstype];//controls type
                NSString* strTextView = @"";
                if (g_nJYBackBlackColor)
                {
                    strTextView = [NSString stringWithFormat:@"text=%@|maxlines=100|enabled=0|textcolor=255,255,255|",[ayContent objectAtIndex:i]];
                }else
                {
                    strTextView = [NSString stringWithFormat:@"text= %@|maxlines=100|enabled=0|textcolor=0,0,0|", [ayContent objectAtIndex:i]];
                }
                [arraytextview setObject:strTextView forKey:tztcontrolsproperty];//controls property
            [itemarray addObject:arraytextview];
            [arraytextview release];
        
        [listdata setValue:itemarray forKey:tztcellarray];
        [tablelist addObject:listdata];
        [listdata release];
        [itemarray release];
    }
    [tableinfo setObject:tablelist forKey:tzttablelist];
    [tableinfo setObject:@"radius=0|autocalcul=0|gridline=1|gridcolor=255,0,0|backgroundcolor=48,48,48|bordercolor=48,48,48|cellheight=40|" forKey:tzttableproperty];
    [tablelist release];
    self.nsgridcolor = @"tztGridSeperoter.png";
    [self setTableinfo:tableinfo];
    [tableinfo release];
    [ayTitle release];
    [ayContent release];
}

- (void)setListViewData:(NSArray *)aydata
{
    NSArray *ayContent = [aydata retain];
    for (int i = 0; i < [aydata count]; i++)
    {
        UIView *plabel = [self viewWithTag:self.tag + (i+1) * tztCellTagMultiple];
        if (plabel && [plabel isKindOfClass:[tztUIBaseControlsCell class]])
        {
            UIView* pView = [plabel viewWithTag:plabel.tag + (1 + 1)*tztControlsTagMultiple];
            tztUITextView * textView = (tztUITextView *)pView;
            [textView setText:[ayContent objectAtIndex:i]];
        }
    }
    [ayContent release];
}

- (void)setTableinfo:(NSDictionary *)tableinfo
{
    if(tableinfo && [tableinfo count] > 0)
    {
        if(_tableinfo)
        {
            if([_tableinfo isEqualToDictionary:tableinfo])
                return;
            [_tableinfo release];
            _tableinfo = nil;
        }
        _tableinfo = [tableinfo retain];
        [self onCreateTable:TRUE];
    }
}

- (void)onCreateTable:(BOOL)bReload
{
    if ( CGRectIsNull(self.bounds) || CGRectIsEmpty(self.bounds) )
    {
        return;
    }
    if(_tableinfo && [_tableinfo count] > 0)
    {
        NSArray* tablelist = [_tableinfo objectForKey:tzttablelist];
        if(tablelist == nil || [tablelist count] <= 0)
            return;
        CGRect cellframe = self.bounds;
        cellframe.size.height = _cellheight;
        cellframe.origin.y = 0;
        if(_tablecells == nil)
            _tablecells = NewObject(NSMutableArray);
        for (int i = 0; i < [tablelist count]; i++)
        {
            NSDictionary* listdata = [tablelist objectAtIndex:i];
            if(listdata == nil)
                continue;
            
            NSString* cellname = [listdata objectForKey:tztcellname];
            if(cellname == nil || [cellname length] <=0)
                continue;
            
            NSString* cellcreate = [listdata objectForKey:tztcellcreate];//默认创建
            if(cellcreate && [cellcreate length] > 0 && [cellcreate intValue] == 0)
            {
                continue;
            }
            
            BOOL bcellhidden = FALSE;
            NSString* cellshow = [listdata objectForKey:tztcellshow]; //默认显示
            if(cellshow && [cellshow length] > 0 && [cellshow intValue] == 0)
            {
                bcellhidden = TRUE;
            }

            NSInteger nTag = self.tag + (i+1) * tztCellTagMultiple;            
            tztUIBaseControlsCell* tablecell = (tztUIBaseControlsCell*)[self viewWithTag:nTag];
            if(tablecell == nil)
            {
                tablecell = NewObject(tztUIBaseControlsCell);
                tablecell.tag = nTag;
                tablecell.bDetailShow = _bDetailShow;
                tablecell.tztdelegate = self;
                [_tablecells addObject:tablecell];
                [self addSubview:tablecell];
                [tablecell release];
            }
            tablecell.cellname = cellname;
//            if (i == 0)
//                tablecell.bgridline = 0;
//            else
            if (self.nsgridcolor && self.nsgridcolor.length > 0)
                tablecell.nsgridcolor = [NSString stringWithFormat:@"%@", self.nsgridcolor];
            if (i == 0) {
                tablecell.bgridline = 0;
            }
            else
            {
                tablecell.bgridline = _bGridLine;
            }
            
            tablecell.hidden = bcellhidden;
            tablecell.frame = cellframe;
            NSArray* cellinfo = [listdata objectForKey:tztcellarray];
            if(cellinfo == nil)
                continue;
            [self onCreateTableCell:tablecell data:listdata reload:bReload]; 
            cellframe.size.height = MAX(cellframe.size.height,tablecell.frame.size.height);
            NSString* strImage = [listdata objectForKey:tztcellname];
            strImage = [strImage lowercaseString];
            if ([strImage hasPrefix:@"tztline"])
            {
                NSArray* items = [listdata objectForKey:tztcellarray];
                CGFloat fHeight = 2;
                for (int i = 0; i < [items count]; i++)
                {
                    NSDictionary* controls = [items objectAtIndex:i];
                    NSString* strProperty = [controls objectForKey:tztcontrolsproperty];
                    
                    NSMutableDictionary* Property = NewObject(NSMutableDictionary);
                    [Property settztProperty:strProperty];
                    NSString* strHeight = [Property objectForKey:@"height"];
                    if (strHeight.length > 0)
                        fHeight = [strHeight floatValue];
                }
                cellframe.size.height = fHeight;
            }
            tablecell.frame = cellframe;
            
            if(!bcellhidden) //显示
                cellframe.origin.y += cellframe.size.height;
            
            cellframe.size.height = _cellheight;
            cellframe.origin.x = 0;
        }
        
        if(cellframe.origin.y != self.bounds.size.height)
        {
            CGRect frame = self.frame;
            frame.size.height = cellframe.origin.y;
            self.frame = frame;
        }
    }
}

//创建cell
- (void)onCreateTableCell:(tztUIBaseControlsCell*)tablecell data:(NSDictionary*)listdata reload:(BOOL)bReload
{
    CGRect frame = tablecell.frame;
    CGFloat cellheight = frame.size.height;
    NSArray* items = [listdata objectForKey:tztcellarray];
    CGFloat controlsorgx = 0;
    UIView *pBackView = nil;
    for (int i = 0; i < [items count]; i++)
    {
        NSDictionary* controls = [items objectAtIndex:i];
        if(controls && [controls count] > 0)
        {
            CGSize controlsize = [self onCreateControlswithCell:tablecell controls:controls atIndex:i orgx:controlsorgx reload:bReload];
            controlsorgx = controlsize.width;
            cellheight = MAX(controlsize.height,cellheight);
        }
        
        if (_bDetailShow && i == 0)//详情，左侧增加背景色view
        {
            pBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, controlsorgx, cellheight)];
            pBackView.backgroundColor = [UIColor colorWithTztRGBStr:@"41,41,41"];
            if (!g_nJYBackBlackColor) {
                pBackView.backgroundColor = [UIColor colorWithTztRGBStr:@"247, 247, 247"];
            }
            pBackView.tag = 0x8789;
            [tablecell addSubview:pBackView];
            [tablecell sendSubviewToBack:pBackView];
            [pBackView release];
        }
        
    }
    frame.size.height = cellheight;
    tablecell.frame = frame;
    
    if (_bDetailShow)
    {
        CGRect rcBack = pBackView.frame;
        rcBack.size.height = cellheight;
        pBackView.frame = rcBack;
    }
}

//调整控件位置
- (CGFloat)setControlsFrame:(UIView *)tztUIBaseView orgx:(CGFloat)orgx maxwidth:(CGFloat)maxwidth maxheight:(CGFloat)maxheight
{
    CGRect btnframe = tztUIBaseView.frame;
    CGFloat btnOrgx = MAX(orgx,btnframe.origin.x);
    CGFloat btnWidth = MIN(maxwidth - btnOrgx - (_bAutoCalcul ? tztUIBaseViewEndBlank : 0),btnframe.size.width);
    btnframe.origin.x = btnOrgx;
    //zxl 20131011 调整了空间在cell 的位置在cell 的中间
    if (maxheight > btnframe.size.height)
        btnframe.origin.y = (maxheight - btnframe.size.height)/2;
    
    btnframe.size.width = btnWidth;
    if(!CGRectEqualToRect(btnframe, tztUIBaseView.frame ))//区域有变更
        tztUIBaseView.frame = btnframe;
    return btnOrgx + btnWidth + (_bAutoCalcul ? tztUIBaseViewMidBlank : 0);
}
//创建控件
- (CGSize)onCreateControlswithCell:(tztUIBaseControlsCell *)cell controls:(NSDictionary*)controls atIndex:(int)iIndex orgx:(CGFloat)orgx reload:(BOOL)bReload
{
    CGSize controlsize = CGSizeZero;
    controlsize.width = orgx;
    NSString* controlstype = [controls objectForKey:tztcontrolstype];
    if(controlstype == nil || [controlstype length] <= 0)
        return controlsize;
    NSString* strProperty = [controls objectForKey:tztcontrolsproperty];
    if(strProperty == nil)
        strProperty = @"";
    NSString* strType = [controlstype lowercaseString];
    NSInteger nTag = cell.tag + (iIndex + 1)*tztControlsTagMultiple;
    
    if ([strType compare:@"tztedit"] == NSOrderedSame)
    {
        strType = @"tzttextfield";
    }
    if([strType compare:@"tztlabel"] == NSOrderedSame)
    {
        tztUILabel* btn = (tztUILabel*)[self viewWithTag:nTag];
        if(btn == nil)
        {
//            btn = [[tztUILabel alloc] initWithProperty:strProperty];
            btn = [[tztUILabel alloc] initWithProperty:strProperty withCellWidth_:cell.frame.size.width CellHeight_:_cellheight];
            btn.tag = nTag;
            [cell addSubview:btn];
            [btn release];
        }
        else if(bReload)
        {
            [btn setProperty:strProperty];
        }
        btn.hidden = cell.hidden;
        [self settztUIBaseViewControl:btn.tzttagcode withControl:btn];
        controlsize.width = [self setControlsFrame:btn orgx:orgx maxwidth:cell.frame.size.width maxheight: cell.frame.size.height];
        controlsize.height = 2*btn.frame.origin.y+btn.frame.size.height;
        if(cell.frame.size.height < controlsize.height)
        {
            CGRect btnframe = btn.frame;
            CGFloat orgY = (cell.frame.size.height - btn.frame.size.height)/2;
            
            btn.frame = CGRectMake(btnframe.origin.x, (orgY > 0 ? orgY : 0), btnframe.size.width, btnframe.size.height);
            controlsize.height = 2*btn.frame.origin.y+btn.frame.size.height;
        }
        
//        btn.textColor = [UIColor tztThemeTextColorLabel];
        
//        btn.backgroundColor = [UIColor tztThemeBackgroundColor];
    }
    else if([strType compare:@"tzttextview"] == NSOrderedSame)
    {
        tztUITextView* btn = (tztUITextView*)[self viewWithTag:nTag];
        if(btn == nil)
        {
            btn = [[tztUITextView alloc] initWithProperty:strProperty];
            btn.tztdelegate = self;
            btn.tag = nTag;
            CGRect btnframe = btn.frame;
            CGFloat btnOrgx = MAX(orgx,btnframe.origin.x);
            CGFloat btnWidth = MIN(cell.frame.size.width - btnOrgx - 5,btnframe.size.width);
            btnframe.origin.x = btnOrgx;
            btnframe.size.width = btnWidth;
            if(!CGRectEqualToRect(btnframe, btn.frame ))
                btn.frame = btnframe;
            controlsize.width = btnOrgx + btnWidth;
            [cell addSubview:btn];
            [btn release];
        }
        else if(bReload)
        {
            [btn setProperty:strProperty];
        }
        btn.hidden = cell.hidden;
        [self settztUIBaseViewControl:btn.tzttagcode withControl:btn];
        controlsize.width = [self setControlsFrame:btn orgx:orgx maxwidth:cell.frame.size.width maxheight:cell.frame.size.height];
        controlsize.height = 2*btn.frame.origin.y+btn.frame.size.height;
        //zxl 20131009 添加了tztUITextView 的frame 的改变
        if(cell.frame.size.height < controlsize.height)
        {
            CGRect btnframe = btn.frame;
            CGFloat orgY = (cell.frame.size.height - btn.frame.size.height)/2;
            
            btn.frame = CGRectMake(btnframe.origin.x, (orgY > 0 ? orgY : 0), btnframe.size.width, btnframe.size.height);
            controlsize.height = 2*btn.frame.origin.y+btn.frame.size.height;
        }
    }
    else if([strType compare:@"tzttextfield"] == NSOrderedSame)
    {
        tztUITextField* btn = (tztUITextField*)[self viewWithTag:nTag];
        if(btn == nil)
        {
            btn = [[tztUITextField alloc] initWithProperty:strProperty];
            btn.tag = nTag;
            btn.tztdelegate = self;
            [cell addSubview:btn];
            [btn release];
        }
        else if(bReload)
        {
            [btn setProperty:strProperty];
        }
        btn.hidden = cell.hidden;
        [self settztUIBaseViewControl:btn.tzttagcode withControl:btn];
        controlsize.width = [self setControlsFrame:btn orgx:orgx maxwidth:cell.frame.size.width maxheight:cell.frame.size.height];
        controlsize.height = 2*btn.frame.origin.y+btn.frame.size.height;
        if(cell.frame.size.height < controlsize.height)
        {
            CGRect btnframe = btn.frame;
            CGFloat orgY = (cell.frame.size.height - btn.frame.size.height)/2;
            
            btn.frame = CGRectMake(btnframe.origin.x, (orgY > 0 ? orgY : 0), btnframe.size.width, btnframe.size.height);
            controlsize.height = 2*btn.frame.origin.y+btn.frame.size.height;
        }
    }
    else if([strType compare:@"tztbutton"] == NSOrderedSame)
    {
        tztUIButton* btn = (tztUIButton*)[self viewWithTag:nTag];
        if(btn == nil)
        {
            btn = [[tztUIButton alloc] initWithProperty:strProperty withCellWidth_:cell.frame.size.width];
            btn.tag = nTag;
            btn.tztdelegate = self;
            [cell addSubview:btn];
            [btn release];
        }
        else if(bReload)
        {
            [btn setProperty:strProperty];
        }
        btn.hidden = cell.hidden;
        [self settztUIBaseViewControl:btn.tzttagcode withControl:btn];
        controlsize.width = [self setControlsFrame:btn orgx:orgx maxwidth:cell.frame.size.width maxheight:cell.frame.size.height];
        controlsize.height = 2*btn.frame.origin.y+btn.frame.size.height;
        if(cell.frame.size.height < controlsize.height)
        {
            CGRect btnframe = btn.frame;
            CGFloat orgY = (cell.frame.size.height - btn.frame.size.height)/2;
            
            btn.frame = CGRectMake(btnframe.origin.x, (orgY > 0 ? orgY : 0), btnframe.size.width, btnframe.size.height);
            controlsize.height = 2*btn.frame.origin.y+btn.frame.size.height;
        }
    }
    else if([strType compare:@"tztcheckbox"] == NSOrderedSame)
    {
        tztUICheckButton* btn = (tztUICheckButton*)[self viewWithTag:nTag];
        if(btn == nil)
        {
            btn = [[tztUICheckButton alloc] initWithProperty:strProperty];
            btn.tag = nTag;
//            [btn addTarget:self action:@selector(onSwitch:) forControlEvents:UIControlEventValueChanged];
            btn.tztdelegate = self;
            [cell addSubview:btn];
            [btn release];
        }
        else if(bReload)
        {
            [btn setProperty:strProperty];
        }
        btn.hidden = cell.hidden;
        [self settztUIBaseViewControl:btn.tzttagcode withControl:btn];
        controlsize.width = [self setControlsFrame:btn orgx:orgx maxwidth:cell.frame.size.width maxheight:cell.frame.size.height];
        controlsize.height = 2*btn.frame.origin.y+btn.frame.size.height;
        if(cell.frame.size.height < controlsize.height)
        {
            CGRect btnframe = btn.frame;
            CGFloat orgY = (cell.frame.size.height - btn.frame.size.height)/2;
            
            btn.frame = CGRectMake(btnframe.origin.x, (orgY > 0 ? orgY : 0), btnframe.size.width, btnframe.size.height);
            controlsize.height = 2*btn.frame.origin.y+btn.frame.size.height;
        }
    }
    else if([strType compare:@"tztcombox"] == NSOrderedSame)
    {
        tztUIDroplistView* btn = (tztUIDroplistView*)[self viewWithTag:nTag];
        if(btn == nil)
        {
            btn = [[tztUIDroplistView alloc] initWithProperty:strProperty];
            btn.tag = nTag;
            btn.tztdelegate = self;
            [cell addSubview:btn];
            [btn release];
        }
        btn.hidden = cell.hidden;
        [self settztUIBaseViewControl:btn.tzttagcode withControl:btn];
        controlsize.width = [self setControlsFrame:btn orgx:orgx maxwidth:cell.frame.size.width maxheight:cell.frame.size.height];
        controlsize.height = 2*btn.frame.origin.y+btn.frame.size.height;
        if(cell.frame.size.height < controlsize.height)
        {
            CGRect btnframe = btn.frame;
            CGFloat orgY = (cell.frame.size.height - btn.frame.size.height)/2;
            
            btn.frame = CGRectMake(btnframe.origin.x, (orgY > 0 ? orgY : 0), btnframe.size.width, btnframe.size.height);
            controlsize.height = 2*btn.frame.origin.y+btn.frame.size.height;
        }
    }
    else if([strType compare:@"tztswitch"] == NSOrderedSame)
    {
        tztUISwitch* btn = (tztUISwitch*)[self viewWithTag:nTag];
        if(btn == nil)
        {
            btn = [[tztUISwitch alloc] initWithProperty:strProperty];
            btn.tztdelegate = self;
//            [btn addTarget:self action:@selector(onSwitch:) forControlEvents:UIControlEventValueChanged];
            btn.tag = nTag;
            [cell addSubview:btn];
            [btn release];
        }
        else if(bReload)
        {
            [btn setProperty:strProperty];
        }
        btn.hidden = cell.hidden;
        [self settztUIBaseViewControl:btn.tzttagcode withControl:btn];
        controlsize.width = [self setControlsFrame:btn orgx:orgx maxwidth:cell.frame.size.width maxheight:cell.frame.size.height];
        controlsize.height = 2*btn.frame.origin.y+btn.frame.size.height;
        if(cell.frame.size.height < controlsize.height)
        {
            CGRect btnframe = btn.frame;
            CGFloat orgY = (cell.frame.size.height - btn.frame.size.height)/2;
            
            btn.frame = CGRectMake(btnframe.origin.x, (orgY > 0 ? orgY : 0), btnframe.size.width, btnframe.size.height);
            controlsize.height = 2*btn.frame.origin.y+btn.frame.size.height;
        }
    }
    else if ([strType compare:@"tztline"] == NSOrderedSame)
    {
        
    }
    return controlsize;
}

//隐藏键盘
- (void)keyboardDidHide
{
    if (_tztdelegate && [_tztdelegate respondsToSelector:@selector(keyboardDidHide)]) 
	{
		[_tztdelegate keyboardDidHide];
	}
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self keyboardDidHide];
}

#pragma tztUIBaseViewTagDelegate
- (void)settztUIBaseView:(NSString*)tzttagcode withTag:(NSInteger)tag
{
    if(_tableControls == nil)
        _tableControls = NewObject(NSMutableDictionary);
    if(tzttagcode && [tzttagcode length] > 0)
        [_tableControls setObject:[NSNumber numberWithInteger:tag] forKey:tzttagcode];
}

- (void)removetztUIBaseView:(NSString*)tzttagcode
{
    if(_tableControls && tzttagcode && [tzttagcode length] > 0)
    {
        [_tableControls removeObjectForKey:tzttagcode];
    }
}

#pragma tztUIButtonDelegate
-(void)OnButtonClick:(id)sender
{
    [self keyboardDidHide];
    if (_tztdelegate && [_tztdelegate respondsToSelector:@selector(OnButtonClick:)]) 
    {
        [_tztdelegate OnButtonClick:sender];
    }
}

-(BOOL)OnCheckData:(id)sender//检测数据
{
    if(_tableControls)
    {
        NSEnumerator *enumerator = [_tableControls keyEnumerator];
        id key;
        while ((key = [enumerator nextObject]))
        {
            id View = [_tableControls objectForKey:key];
            if([View respondsToSelector:@selector(onCheckdata)])//检测数据
            {
                BOOL bCheck = [View onCheckdata];
                if(!bCheck)
                {
                    if ([View respondsToSelector:@selector(placeholder)] )
                    {
                        [self keyboardDidHide];
                        NSString* strTip = [View placeholder];
                        if(strTip && [strTip length] > 0)
                        {
                            [self showMessageBox:strTip nType_:0 nTag_:0];
                        }
                    }
                    return bCheck;
                }
            }
        }
    }
    return TRUE;
}

#pragma tztUIBaseViewCheckDelegate
- (void)tztUIBaseView:(UIView *)tztUIBaseView checked:(BOOL)checked
{
    if(_tztdelegate && [_tztdelegate respondsToSelector:@selector(tztUIBaseView:checked:)])
    {
        [_tztdelegate tztUIBaseView:tztUIBaseView checked:checked];
    }
}

#pragma tztUIBaseViewTextDelegate
- (void)tztUIBaseView:(UIView *)tztUIBaseView willChangeHeight:(CGFloat)height
{
    
}

- (void)tztUIBaseView:(UIView *)tztUIBaseView textchange:(NSString *)text
{
    if(_tztdelegate && [_tztdelegate respondsToSelector:@selector(tztUIBaseView:textchange:)])
    {
        [_tztdelegate tztUIBaseView:tztUIBaseView textchange:text];
    }
}

- (void)tztUIBaseView:(UIView *)tztUIBaseView textmaxlen:(NSString *)text
{
    
}

-(void)tztUIBaseView:(UIView *)tztUIBaseView focuseChanged:(NSString *)text
{
    if (_tztdelegate && [_tztdelegate respondsToSelector:@selector(tztUIBaseView:focuseChanged:)])
    {
        [_tztdelegate tztUIBaseView:tztUIBaseView focuseChanged:text];
    }
}

#pragma tztDroplistViewDelegate
//获取列表显示位置
- (CGPoint)tztDroplistView:(tztUIDroplistView*)droplistview point:(CGPoint)listpoint
{
    if (_tztdelegate && [_tztdelegate respondsToSelector:@selector(tztDroplistView:point:)]) 
	{
		return [_tztdelegate tztDroplistView:droplistview point:listpoint];
	}
    return listpoint;
}

//显示列表视图
- (BOOL)tztDroplistView:(tztUIDroplistView*)droplistview showlistview:(UITableView*)listview
{
//    [self doHiddenDroplist:droplistview];
    if (_tztdelegate && [_tztdelegate respondsToSelector:@selector(tztDroplistView:showlistview:)])
	{
        return[_tztdelegate tztDroplistView:droplistview showlistview:listview];
	}
    return FALSE;
}

//显示时间选择器
- (void)tztDroplistViewWithDataview:(tztUIDroplistView*)droplistview
{
//    [self doHiddenDroplist:droplistview];
    if (_tztdelegate && [_tztdelegate respondsToSelector:@selector(tztDroplistViewWithDataview:)])
	{
        [_tztdelegate tztDroplistViewWithDataview:droplistview];
	}
}

//zxl 20131022 开始显示数据前处理
- (void)tztDroplistViewBeginShowData:(tztUIDroplistView*)droplistview
{
    if (_tztdelegate && [_tztdelegate respondsToSelector:@selector(tztDroplistViewBeginShowData:)])
    {
        [_tztdelegate tztDroplistViewBeginShowData:droplistview];
    }
}


//刷新数据
- (void)tztDroplistViewGetData:(tztUIDroplistView*)droplistview
{
    if (_tztdelegate && [_tztdelegate respondsToSelector:@selector(tztDroplistViewGetData:)])
    {
        [_tztdelegate tztDroplistViewGetData:droplistview];
    }
    
}

//删除列表数据
- (BOOL)tztDroplistView:(tztUIDroplistView *)droplistview didDeleteIndex:(NSInteger)index
{
    if (_tztdelegate && [_tztdelegate respondsToSelector:@selector(tztDroplistView: didDeleteIndex:)])
    {
        return [_tztdelegate tztDroplistView:droplistview didDeleteIndex:index];
    }
    return TRUE;
}

//选中列表数据
- (void)tztDroplistView:(tztUIDroplistView *)droplistview didSelectIndex:(NSInteger)index
{
    if(_tztdelegate && [_tztdelegate respondsToSelector:@selector(tztDroplistView: didSelectIndex:)])
        [_tztdelegate tztDroplistView:droplistview didSelectIndex:index];
}

- (void)settztUIBaseViewControl:(NSString*)tzttagcode withControl:(UIView *)view
{
    if(_tableControls == nil)
        _tableControls = NewObject(NSMutableDictionary);
    if(tzttagcode && [tzttagcode length] > 0)
        [_tableControls setObject:view forKey:tzttagcode];
}

- (UIView *)gettztUIBaseViewWithTag:(NSString*)tzttagcode
{
    if(_tableControls == nil)
        return nil;
    if(tzttagcode && [tzttagcode length] > 0)
        return [_tableControls objectForKey:tzttagcode];
    return nil;
}

-(void)doHiddenDroplist:(UIView*)droplistview
{
    static BOOL bHideing = FALSE; //防止死循环
    if(!bHideing)
    {
        bHideing = TRUE;
    }
    else
    {
        return;
    }
    if(bHideing)
    {
        NSArray *ayView = [self subviews];
        for (int i = 0;i < [ayView count];i++)
        {
            UIView *   pView = [ayView objectAtIndex:i];
            if (pView && [pView isKindOfClass:[UIResponder class]]&& pView != droplistview)
            {
                [pView resignFirstResponder];
            }
            NSArray* pAyView = [pView subviews];
            for(int i = 0; i< [pAyView count]; i++)
            {
                UIView* pSubView = [pAyView objectAtIndex:i];
                if(pSubView && pSubView != droplistview)
                {
                    [tztUIVCBaseView OnCloseKeybord:pSubView];
                }
            }
        }
        bHideing = FALSE;
    }
}


-(void)doHiddenDroplistEx:(UIView*)droplistview
{
    NSArray *ayView = [self subviews];
    for (int i = 0;i < [ayView count];i++)
    {
        UIView *   pView = [ayView objectAtIndex:i];
        if (pView && [pView isKindOfClass:[UIResponder class]]&& pView != droplistview)
        {
            [pView resignFirstResponder];
        }
        [self CloseDropList:pView compare_:droplistview];
    }
}


-(void)CloseDropList:(UIView*)pView compare_:(UIView*)pViewCom
{
    NSArray* pAyView = [pView subviews];
    for(int i = 0; i< [pAyView count]; i++)
    {
        UIView* pSubView = [pAyView objectAtIndex:i];
        if(pSubView && [pSubView isKindOfClass:[tztUIDroplistView class]])
        {
            [((tztUIDroplistView*)pSubView) doHideListEx];
        }
    }
}

//隐藏时间选择器
- (void)tztDroplistViewWithDataviewHide:(tztUIDroplistView*)droplistview
{
    [self doHiddenDroplist:droplistview];//要非常小心 注意不要造成死循环
    if (_tztdelegate && [_tztdelegate respondsToSelector:@selector(tztDroplistViewWithDataviewHide:)]) 
	{
        [_tztdelegate tztDroplistViewWithDataviewHide:droplistview];
	}
}

//设置某行隐藏或者显示
-(void)setCellHidenFlag:(int)nLineNo bHidden_:(BOOL)bHidden
{
    
}

- (void)OnRefreshView
{
    [self onCreateTable:TRUE];
}
@end
