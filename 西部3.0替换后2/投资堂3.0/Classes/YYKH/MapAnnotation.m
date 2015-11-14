//
//  MapAnnotation.m
//  test
//
//  Created by dai shouwei on 10-9-28.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MapAnnotation.h"


@implementation MapAnnotation
@synthesize DLocation = _DLocation;
@synthesize NsSubtitle = _NsSubtitle;
@synthesize Nstitle = _Nstitle;

-(id)initWithCoordinate:(CLLocationCoordinate2D)coordinate
{
     if (self = [super init])
     {
             _DLocation = coordinate;
     }
       return self;
}

-(void)setCoordinate:(CLLocationCoordinate2D)newCoordinate
{
   _DLocation = newCoordinate;
}
-(void)setAnnotation:(MapAnnotation *)annotation
{
    _DLocation.latitude = annotation.DLocation.latitude;
    _DLocation.longitude = annotation.DLocation.longitude;
    _Nstitle = [NSString stringWithFormat:@"%@",annotation.NsSubtitle];
    _NsSubtitle = [NSString stringWithFormat:@"%@",annotation.NsSubtitle];
}
- (CLLocationCoordinate2D)coordinate
{
	CLLocationCoordinate2D coordinate;
	coordinate.latitude =_DLocation.latitude;
	coordinate.longitude = _DLocation.longitude;
	return coordinate;
}

- (NSString *)title
{
	return @"";
}

- (NSString *)subtitle
{
	return @"";
}

@end
