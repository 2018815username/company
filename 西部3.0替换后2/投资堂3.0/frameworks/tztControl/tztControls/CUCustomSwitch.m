//
//  TZTUISwitch.m
//  UICatalog
//
//  Created by aish on 09-2-25.
//  Copyright 2009.. All rights reserved.
//

#import "CUCustomSwitch.h"
@interface CUCustomSwitch ()
- (void)setSwitchTextColor;
@end

@implementation CUCustomSwitch

@synthesize on;

@synthesize onText;
@synthesize offText;

@synthesize textColor;
@synthesize sliderTextColor;

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder])) {
        // Initialization code
        onText = @"ON";
        offText= @"OFF";
        on = FALSE;
        self.textColor = [UIColor whiteColor];
       self.sliderTextColor = [UIColor grayColor];
        [self InitFrame:self.bounds];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        // Initialization code
        onText = @"ON";
        offText= @"OFF";
        on = FALSE;
        self.textColor = [UIColor whiteColor];
        self.sliderTextColor = [UIColor grayColor];
        [self InitFrame:self.bounds];
    }
    return self;
}

- (void)dealloc
{
    NilObject(self.textColor);
    NilObject(self.sliderTextColor);
    [super dealloc];
}

- (void)InitFrame:(CGRect)frame
{
    CGRect rc = frame;
    
    rc.origin.x = 0;
    rc.origin.y = 0;
    
    if (imgViewBG == NULL)
    {
        imgViewBG = [[UIImageView alloc] initWithImage:[UIImage imageTztNamed:@"CUSwitch-A.png"]];
        [self addSubview:imgViewBG];
		[imgViewBG release];
    }
    imgViewBG.frame = rc;
    
	self.backgroundColor = [UIColor clearColor];	
    rc.size.width /= 2;
    
    if (!on)
    {
        rc.origin.x = 0;
    }
    else
    {
        rc.origin.x += rc.size.width;
    }
    
    if (imgSlider == NULL)
    {
        imgSlider = [[UIImageView alloc] initWithImage:[UIImage imageTztNamed:@"CUSwitch-B.png"]];
        [self addSubview:imgSlider];
		[imgSlider release];
    }
    imgSlider.frame = rc;
    
    
    rc.origin.x = 0;
    rc.origin.y = 0;
    
    if (lblOn == NULL)
    {
        lblOn = [[UILabel alloc] initWithFrame:rc];
        lblOn.backgroundColor = [UIColor clearColor];
        lblOn.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
        lblOn.textAlignment = NSTextAlignmentCenter;
        lblOn.font = [UIFont boldSystemFontOfSize: 13.0f];
        lblOn.text = onText;
        [self addSubview:lblOn];
		[lblOn release];
    }
    else
    {
        lblOn.frame = rc;
    }

    rc.origin.x += rc.size.width;
    
    if (lblOff == NULL)
    {
        lblOff = [[UILabel alloc] initWithFrame:rc];
        lblOff.backgroundColor = [UIColor clearColor];
        lblOff.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
        lblOff.textAlignment = NSTextAlignmentCenter;
        lblOff.font = [UIFont boldSystemFontOfSize: 13.0f];
        lblOff.text = offText;
        
        [self addSubview:lblOff];
		[lblOff release];
    }
    else
    {
        lblOff.frame = rc;
    }
    [self setSwitchTextColor];
	 
}

- (void)setSwitchTextColor
{
    if (on)
    {
        if(lblOff)
        {
            if (textColor)
            {
                lblOff.textColor = textColor;
            }
            else
            {
                lblOff.textColor = [UIColor whiteColor];
             
            }
        }
        
        if(lblOn)
        {
            if (sliderTextColor)
            {
                lblOn.textColor = sliderTextColor;
            }
            else
            {
                lblOn.textColor = [UIColor grayColor];
            }
        }
    }
    else
    {
        if(lblOff)
        {
            if (sliderTextColor)
            {
                lblOff.textColor = sliderTextColor;
            }
            else
            {
                lblOff.textColor = [UIColor grayColor];
            }
        }
        
        if(lblOn)
        {
            if (textColor)
            {
                lblOn.textColor = textColor;
            }
            else
            {
                lblOn.textColor = [UIColor whiteColor];
               
            }
        }
    }
}

- (void)setOn:(BOOL)onoff
{
    [self setOn:onoff animated:TRUE];
}

- (void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents
{
	[super addTarget:target action:action forControlEvents:controlEvents];
}

- (void)setOn:(BOOL)onoff animated:(BOOL)animated // does not send action
{
    on = onoff;
    [self setSwitchTextColor];
    CGRect frame = self.frame;
    
    frame.size.width /= 2;
    //frame.size.height /=2;
    if (onoff)
    {
        frame.origin.x = frame.size.width;
        frame.origin.y = 0;
    }
    else
    {
        frame.origin.x = 0;
        frame.origin.y = 0;
    }
    
    if (animated && TRUE)
    {
        [UIView beginAnimations:nil context:NULL];
        
        [UIView setAnimationDuration:0.3f];
        
        imgSlider.frame = frame;

        [UIView commitAnimations];
		[self sendActionsForControlEvents:UIControlEventValueChanged];
    }
    else
    {
        imgSlider.frame = frame;
    }

    return;
}

-(void) setOnText:(NSString *)text
{
    if (lblOn)
    {
        lblOn.text = text;
    }
}

-(void) setOffText:(NSString *)text
{
    if (lblOff)
    {
        lblOff.text = text;
    }
}

-(void) setTextColor:(UIColor *)color
{
    if(textColor)
    {
        [textColor release];
        textColor = nil;
    }
    if(color)
    {
        textColor = [color retain];
        [self setSwitchTextColor];
    }
}

-(void) setSliderTextColor:(UIColor *)color
{
    if(sliderTextColor)
    {
        [sliderTextColor release];
        sliderTextColor = nil;
    }
    
    if(color)
    {
        sliderTextColor = [color retain];
        [self setSwitchTextColor];
    }
}

- (void)drawRect:(CGRect)rect
{

}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self setOn:!on animated:YES];
}

@end
