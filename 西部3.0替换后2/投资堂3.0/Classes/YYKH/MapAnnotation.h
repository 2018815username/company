//
//  MapAnnotation.h
//  test
//
//  Created by dai shouwei on 10-9-28.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface MapAnnotation : NSObject <MKAnnotation>
{
    CLLocationCoordinate2D  _DLocation;
    NSString    * _Nstitle;
     NSString    * _NsSubtitle;
}
@property CLLocationCoordinate2D DLocation;
@property (nonatomic,retain)NSString *Nstitle;
@property (nonatomic,retain)NSString *NsSubtitle;
-(void)setAnnotation:(MapAnnotation *)annotation;
-(id)initWithCoordinate:(CLLocationCoordinate2D)coordinate;
@end
