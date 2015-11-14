//
//  SevenSwitch
//
//  Created by Benjamin Vogelzang on 6/10/13.
//  Copyright (c) 2013 Ben Vogelzang. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

#import "TZTSevenSwitch.h"
#import <QuartzCore/QuartzCore.h>

@interface TZTSevenSwitch ()  {
    UIView *background;
    UIView *knob;
    UIImageView *onImageView;
    UIImageView *offImageView;
    double startTime;
    BOOL isAnimating;
}

- (void)showOn:(BOOL)animated;
- (void)showOff:(BOOL)animated;
- (void)setup;

@property(nonatomic,retain)UIView   *background;
@property(nonatomic,retain)UIView   *knob;
@property(nonatomic,retain)UIImageView *onImageView;
@property(nonatomic,retain)UIImageView *offImageView;
@end


@implementation TZTSevenSwitch

@synthesize inactiveColor, activeColor, onColor, borderColor, knobColor, shadowColor,background,knob,onImageView,offImageView;
@synthesize onImage, offImage;
@synthesize isRounded;
@synthesize on;
@synthesize tztDelegate = _tztDelegate;


#pragma mark init Methods

- (id)init {
    self = [super initWithFrame:CGRectMake(0, 0, 50, 30)];
    if (self) {
        [self setup];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    // use the default values if CGRectZero frame is set
    CGRect initialFrame;
    if (CGRectIsEmpty(frame)) {
        initialFrame = CGRectMake(0, 0, 50, 30);
    }
    else {
        initialFrame = frame;
    }
    self = [super initWithFrame:initialFrame];
    if (self) {
        [self setup];
    }
    return self;
}


/**
 *	Setup the individual elements of the switch and set default values
 */
- (void)setup {
    
    // default values
    self.on = NO;
    self.isRounded = YES;
    self.inactiveColor = [UIColor clearColor];
    self.activeColor = [UIColor colorWithRed:0.89f green:0.89f blue:0.89f alpha:1.00f];
    self.onColor = [UIColor colorWithRed:0.30f green:0.85f blue:0.39f alpha:1.00f];
    self.borderColor = [UIColor colorWithRed:0.89f green:0.89f blue:0.91f alpha:1.00f];
    self.knobColor = [UIColor whiteColor];
    self.shadowColor = [UIColor grayColor];
    
    // background
    background = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    background.backgroundColor = [UIColor clearColor];
    background.layer.cornerRadius = self.frame.size.height * 0.5;
    background.layer.borderColor = self.borderColor.CGColor;
    background.layer.borderWidth = 1.0;
    background.userInteractionEnabled = NO;
    [self addSubview:background];
    [background release];
    
    // images
    onImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width - self.frame.size.height, self.frame.size.height)];
    onImageView.alpha = 0;
    onImageView.contentMode = UIViewContentModeCenter;
    [self addSubview:onImageView];
    [onImageView release];
    
    offImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.height, 0, self.frame.size.width - self.frame.size.height, self.frame.size.height)];
    offImageView.alpha = 1.0;
    offImageView.contentMode = UIViewContentModeCenter;
    [self addSubview:offImageView];
    [offImage release];
    
    // knob
    knob = [[UIView alloc] initWithFrame:CGRectMake(1, 1, self.frame.size.height - 2, self.frame.size.height - 2)];
    knob.backgroundColor = self.knobColor;
    knob.layer.cornerRadius = (self.frame.size.height * 0.5) - 1;
    knob.layer.shadowColor = self.shadowColor.CGColor;
    knob.layer.shadowRadius = 2.0;
    knob.layer.shadowOpacity = 0.5;
    knob.layer.shadowOffset = CGSizeMake(0, 3);
    knob.layer.masksToBounds = NO;
    knob.userInteractionEnabled = NO;
    [self addSubview:knob];
    [knob release];
    
    isAnimating = NO;
}


#pragma mark Touch Tracking

- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    [super beginTrackingWithTouch:touch withEvent:event];

    // start timer to detect tap later in endTrackingWithTouch:withEvent:
    startTime = [[NSDate date] timeIntervalSince1970];

    // make the knob larger and animate to the correct color
    CGFloat activeKnobWidth = self.bounds.size.height - 2 + 5;
    isAnimating = YES;
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseOut|UIViewAnimationOptionBeginFromCurrentState animations:^{
        if (self.on) {
            self.knob.frame = CGRectMake(self.bounds.size.width - (activeKnobWidth + 1), self.knob.frame.origin.y, activeKnobWidth, self.knob.frame.size.height);
            self.background.backgroundColor = self.onColor;
        }
        else {
            self.knob.frame = CGRectMake(self.knob.frame.origin.x, self.knob.frame.origin.y, activeKnobWidth, self.knob.frame.size.height);
            self.background.backgroundColor = self.activeColor;
        }
    } completion:^(BOOL finished) {
        isAnimating = NO;
    }];

    return YES;
}

- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    [super continueTrackingWithTouch:touch withEvent:event];

    // Get touch location
    CGPoint lastPoint = [touch locationInView:self];

    // update the switch to the correct visuals depending on if
    // they moved their touch to the right or left side of the switch
    if (lastPoint.x > self.bounds.size.width * 0.5)
        [self showOn:YES];
    else
        [self showOff:YES];

    return YES;
}

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    [super endTrackingWithTouch:touch withEvent:event];

    // capture time to see if this was a tap action
    double endTime = [[NSDate date] timeIntervalSince1970];
    double difference = endTime - startTime;
    BOOL previousValue = self.on;
    
    // determine if the user tapped the switch or has held it for longer
    if (difference <= 0.2) {
        CGFloat normalKnobWidth = self.bounds.size.height - 2;
        self.knob.frame = CGRectMake(self.knob.frame.origin.x, self.knob.frame.origin.y, normalKnobWidth, self.knob.frame.size.height);
        [self setOn:!self.on animated:YES];
    }
    else {
        // Get touch location
        CGPoint lastPoint = [touch locationInView:self];
        
        // update the switch to the correct value depending on if
        // their touch finished on the right or left side of the switch
        if (lastPoint.x > self.bounds.size.width * 0.5)
            [self setOn:YES animated:YES];
        else
            [self setOn:NO animated:YES];
    }
    
    if (previousValue != self.on)
        [self sendActionsForControlEvents:UIControlEventValueChanged];
}

- (void)cancelTrackingWithEvent:(UIEvent *)event {
    [super cancelTrackingWithEvent:event];

    // just animate back to the original value
    if (self.on)
        [self showOn:YES];
    else
        [self showOff:YES];
}


- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (!isAnimating) {
        CGRect frame = self.frame;
        
        // background
        self.background.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        self.background.layer.cornerRadius = self.isRounded ? frame.size.height * 0.5 : 2;
        
        // images
        self.onImageView.frame = CGRectMake(0, 0, frame.size.width - frame.size.height, frame.size.height);
        self.offImageView.frame = CGRectMake(frame.size.height, 0, frame.size.width - frame.size.height, frame.size.height);
        
        // knob
        CGFloat normalKnobWidth = frame.size.height - 2;
        if (self.on)
            self.knob.frame = CGRectMake(frame.size.width - (normalKnobWidth + 1), 1, frame.size.height - 2, normalKnobWidth);
        else
            self.knob.frame = CGRectMake(1, 1, normalKnobWidth, normalKnobWidth);
            
        self.knob.layer.cornerRadius = self.isRounded ? (frame.size.height * 0.5) - 1 : 2;
    }
}


#pragma mark Setters

/*
 *	Sets the background color when the switch is off. 
 *  Defaults to clear color.
 */
- (void)setInactiveColor:(UIColor *)color {
    [inactiveColor release];
    inactiveColor = [color retain];
    if (!self.on && !self.isTracking)
        self.background.backgroundColor = color;
}

/*
 *	Sets the background color that shows when the switch is on. 
 *  Defaults to green.
 */
- (void)setOnColor:(UIColor *)color {
    [onColor release];
    onColor = [color retain];
    if (self.on && !self.isTracking) {
        self.background.backgroundColor = color;
        self.background.layer.borderColor = color.CGColor;
    }
}

/*
 *	Sets the border color that shows when the switch is off. Defaults to light gray.
 */
- (void)setBorderColor:(UIColor *)color {
    [borderColor release];
    borderColor = [color retain];
    if (!self.on)
        self.background.layer.borderColor = color.CGColor;
}

/*
 *	Sets the knob color. Defaults to white.
 */
- (void)setKnobColor:(UIColor *)color {
    [knobColor release];
    knobColor = [color retain];
    self.knob.backgroundColor = color;
}

/*
 *	Sets the shadow color of the knob. Defaults to gray.
 */
- (void)setShadowColor:(UIColor *)color {
    [shadowColor release];
    shadowColor = [color retain];
    self.knob.layer.shadowColor = color.CGColor;
}


/*
 *	Sets the image that shows when the switch is on.
 *  The image is centered in the area not covered by the knob.
 *  Make sure to size your images appropriately.
 */
- (void)setOnImage:(UIImage *)image {
    onImage = image;
    self.onImageView.image = image;
}

/*
 *	Sets the image that shows when the switch is off.
 *  The image is centered in the area not covered by the knob.
 *  Make sure to size your images appropriately.
 */
- (void)setOffImage:(UIImage *)image {
    offImage = image;
    self.offImageView.image = image;
}


/*
 *	Sets whether or not the switch edges are rounded. 
 *  Set to NO to get a stylish square switch.
 *  Defaults to YES.
 */
- (void)setIsRounded:(BOOL)rounded {
    isRounded = rounded;
    
    if (rounded) {
        self.background.layer.cornerRadius = self.frame.size.height * 0.5;
        self.knob.layer.cornerRadius = (self.frame.size.height * 0.5) - 1;
    }
    else {
        self.background.layer.cornerRadius = 2;
        self.knob.layer.cornerRadius = 2;
    }
}


/*
 * Set (without animation) whether the switch is on or off
 */
- (void)setOn:(BOOL)isOn {
    [self setOn:isOn animated:NO];
}


/*
 * Set the state of the switch to on or off, optionally animating the transition.
 */
- (void)setOn:(BOOL)isOn animated:(BOOL)animated {
    on = isOn;
    
    if (isOn) {
        [self showOn:animated];
    }
    else {
        [self showOff:animated];
    }
    
    if (self.tztDelegate && [self.tztDelegate respondsToSelector:@selector(tztSevenSwitchChanged:status_:)])
    {
        [self.tztDelegate tztSevenSwitchChanged:self status_:on];
    }
}


#pragma mark Getters

/*
 *	Detects whether the switch is on or off
 *
 *	@return	BOOL YES if switch is on. NO if switch is off
 */
- (BOOL)isOn {
    return self.on;
}


#pragma mark State Changes


/*
 * update the looks of the switch to be in the on position
 * optionally make it animated
 */
- (void)showOn:(BOOL)animated {
    CGFloat normalKnobWidth = self.bounds.size.height - 2;
    CGFloat activeKnobWidth = normalKnobWidth + 5;
    if (animated) {
        isAnimating = YES;
        [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseOut|UIViewAnimationOptionBeginFromCurrentState animations:^{
            if (self.tracking)
                self.knob.frame = CGRectMake(self.bounds.size.width - (activeKnobWidth + 1), self.knob.frame.origin.y, activeKnobWidth, self.knob.frame.size.height);
            else
                self.knob.frame = CGRectMake(self.bounds.size.width - (normalKnobWidth + 1), self.knob.frame.origin.y, normalKnobWidth, self.knob.frame.size.height);
            self.background.backgroundColor = self.onColor;
            self.background.layer.borderColor = self.onColor.CGColor;
            self.onImageView.alpha = 1.0;
            self.offImageView.alpha = 0;
        } completion:^(BOOL finished) {
            isAnimating = NO;
        }];
    }
    else {
        if (self.tracking)
            self.knob.frame = CGRectMake(self.bounds.size.width - (activeKnobWidth + 1), self.knob.frame.origin.y, activeKnobWidth, self.knob.frame.size.height);
        else
            self.knob.frame = CGRectMake(self.bounds.size.width - (normalKnobWidth + 1), self.knob.frame.origin.y, normalKnobWidth, self.knob.frame.size.height);
        self.background.backgroundColor = self.onColor;
        self.background.layer.borderColor = self.onColor.CGColor;
        self.onImageView.alpha = 1.0;
        self.offImageView.alpha = 0;
    }
}


/*
 * update the looks of the switch to be in the off position
 * optionally make it animated
 */
- (void)showOff:(BOOL)animated {
    CGFloat normalKnobWidth = self.bounds.size.height - 2;
    CGFloat activeKnobWidth = normalKnobWidth + 5;
    if (animated) {
        isAnimating = YES;
        [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseOut|UIViewAnimationOptionBeginFromCurrentState animations:^{
            if (self.tracking) {
                self.knob.frame = CGRectMake(1, self.knob.frame.origin.y, activeKnobWidth, self.knob.frame.size.height);
                self.background.backgroundColor = self.activeColor;
            }
            else {
                self.knob.frame = CGRectMake(1, self.knob.frame.origin.y, normalKnobWidth, self.knob.frame.size.height);
                self.background.backgroundColor = self.inactiveColor;
            }
            self.background.layer.borderColor = self.borderColor.CGColor;
            self.onImageView.alpha = 0;
            self.offImageView.alpha = 1.0;
        } completion:^(BOOL finished) {
            isAnimating = NO;
        }];
    }
    else {
        if (self.tracking) {
            self.knob.frame = CGRectMake(1, self.knob.frame.origin.y, activeKnobWidth, self.knob.frame.size.height);
            self.background.backgroundColor = self.activeColor;
        }
        else {
            self.knob.frame = CGRectMake(1, self.knob.frame.origin.y, normalKnobWidth, self.knob.frame.size.height);
            self.background.backgroundColor = self.inactiveColor;
        }
        self.background.layer.borderColor = self.borderColor.CGColor;
        self.onImageView.alpha = 0;
        self.offImageView.alpha = 1.0;
    }
}

@end
