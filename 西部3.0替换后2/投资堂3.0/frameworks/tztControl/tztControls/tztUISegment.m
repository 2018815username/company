//
//  tztUISwitch.m
//  tztMobileApp_HTSC
//
//  Created by zztzt on 14-1-15.
//
//

#import "tztUISegment.h"

@implementation tztUISegment

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.textColor = [UIColor whiteColor];
        self.sliderTextColor = [UIColor whiteColor];
    }
    return self;
}


-(void)InitFrame:(CGRect)frame
{
    CGRect rc = frame;
    
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
    
    CGRect rcLblOn = rc;
    rc.size.width -= 6;
    if (lblOn == NULL)
    {
        lblOn = [[UILabel alloc] initWithFrame:rc];
        lblOn.backgroundColor = [UIColor clearColor];
        lblOn.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
        lblOn.contentMode = UIViewContentModeCenter;
        lblOn.textAlignment = NSTextAlignmentRight;
        lblOn.font = tztUIBaseViewTextBoldFont(22.0f);// [UIFont boldSystemFontOfSize: 13.0f];
        lblOn.text = onText;
        [self addSubview:lblOn];
		[lblOn release];
    }
    else
    {
        lblOn.frame = rc;
    }
    
    rc.origin.x += rc.size.width;
    
    UIImage *image = [UIImage imageTztNamed:@"tztTitleSepLine"];
    if (image && image.size.width > 0)
    {
        CGRect rcImageView = rcLblOn;
        rcImageView.origin.x += rcLblOn.size.width + 5;
        rcImageView.origin.y += (rc.size.height - image.size.height) / 2;
        rcImageView.size = image.size;
        
        UIImageView *imageView = (UIImageView*)[self viewWithTag:0x1234];
        if (imageView == NULL)
        {
            imageView = [[UIImageView alloc] initWithFrame:rcImageView];
            [imageView setImage:image];
            imageView.tag = 0x1234;
            [self addSubview:imageView];
            [imageView release];
        }
        else
        {
            imageView.frame = rcImageView;
        }
    }
    
    
    CGRect rcLblOff = rc;
    rcLblOff.origin.x += 25;
    rcLblOff.size.width -= 12;
//    rcLblOff.size.width -= 25;
    if (lblOff == NULL)
    {
        lblOff = [[UILabel alloc] initWithFrame:rcLblOff];
        lblOff.backgroundColor = [UIColor clearColor];
        lblOff.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
        lblOff.contentMode = UIViewContentModeCenter;
        lblOff.textAlignment = NSTextAlignmentLeft;
        lblOff.font = tztUIBaseViewTextBoldFont(18.0f);// [UIFont boldSystemFontOfSize: 13.0f];
        lblOff.text = offText;
        
        [self addSubview:lblOff];
		[lblOff release];
    }
    else
    {
        lblOff.frame = rcLblOff;
    }
    
    [self setTextColor];
}

-(void)setMiddleSeperator:(UIImage*)image
{
    CGRect rcLblOn = lblOn.frame;
    CGRect rc = rcLblOn;
    
    if (image == nil)
         image = [UIImage imageTztNamed:@"tztTitleSepLine"];
    if (image && image.size.width > 0)
    {
        CGSize sz = image.size;
        CGRect rcImageView = rcLblOn;
//        rcImageView.origin.x = self.bounds.size.width / 2 - 1;
        rcImageView.origin.x += rcLblOn.size.width + 12;
        if (image.size.height < lblOn.font.lineHeight)
        {
            rcImageView.origin.y += (rc.size.height - (lblOn.font.lineHeight)) / 2;
            sz = CGSizeMake(image.size.width, (lblOn.font.lineHeight));
        }
        else
            rcImageView.origin.y += (rc.size.height - image.size.height) / 2;
        rcImageView.size = sz;
        
        UIImageView *imageView = (UIImageView*)[self viewWithTag:0x1234];
        if (imageView == NULL)
        {
            imageView = [[UIImageView alloc] initWithFrame:rcImageView];
            [imageView setImage:image];
            imageView.tag = 0x1234;
            [self addSubview:imageView];
            [imageView release];
        }
        else
        {
            imageView.image = image;
            imageView.frame = rcImageView;
        }
    }
    
}

- (void)setTextColor
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
            lblOff.font = tztUIBaseViewTextFont(22.0f);
        }
        
        if(lblOn)
        {
            if (sliderTextColor)
            {
                lblOn.textColor = sliderTextColor;
            }
            else
            {
                lblOn.textColor = [UIColor lightTextColor];
            }
            lblOn.font = tztUIBaseViewTextFont(18.0f);
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
                lblOff.textColor = [UIColor lightTextColor];
            }
            lblOff.font = tztUIBaseViewTextFont(18.0f);
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
            lblOn.font = tztUIBaseViewTextFont(22.0f);
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
    [self setTextColor];
    [self sendActionsForControlEvents:UIControlEventValueChanged];
    return;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [[touches allObjects] objectAtIndex:0];
    CGPoint pt = [touch locationInView:self];
    
    if (CGRectContainsPoint(lblOn.frame, pt))//点的是on
    {
        if (!on)
            return;
        else
            [self setOn:!on];
    }
    else if (CGRectContainsPoint(lblOff.frame, pt))
    {
        if (on)
            return;
        else
            [self setOn:!on];
    }
}
@end

