//
//  tztMapView.m
//  tztMobileApp_yyz
//
//  Created by 张 小龙 on 13-6-5.
//
//

#import "tztMapView.h"
#import <CoreLocation/CoreLocation.h>
#import "MapAnnotation.h"
@implementation tztMapView
@synthesize mapView = _mapView;
@synthesize DLocation = _DLocation;
@synthesize DMyLocation = _DMyLocation;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _DLocation = NewObject(MapAnnotation);
        _DMyLocation = NewObject(MapAnnotation);
    }
    return self;
}
-(void)dealloc
{
    [super dealloc];
    DelObject(_DMyLocation);
    DelObject(_DLocation);
}
-(void)setFrame:(CGRect)frame
{
    if (CGRectIsEmpty(frame) || CGRectIsNull(frame))
        return;
    [super setFrame:frame];
    CGRect rcFrame = self.bounds;
    rcFrame.origin = CGPointMake(0, 0);
    if (_mapView == NULL)
    {
        _mapView = [[MKMapView alloc] init];
        _mapView.frame = rcFrame;
        _mapView.delegate = self;
        _mapView.mapType = MKMapTypeStandard;
        _mapView.showsUserLocation = YES;
        [self addSubview:_mapView];
        [_mapView release];
        
        _mapView.region = MKCoordinateRegionMakeWithDistance(_DLocation.DLocation,2000, 2000);;
        
        NSMutableArray * pAy = NewObjectAutoD(NSMutableArray);
        [pAy addObject:_DLocation];
        [_mapView addAnnotations:pAy];
        
    }else
       _mapView.frame = rcFrame;
    

}
-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    NSString *annotationViewId=@"QuanFangPinID";
    MKPinAnnotationView *annotationView = nil;
    MapAnnotation * annotationtemp = (MapAnnotation *)annotation;
    annotationView = (MKPinAnnotationView *)
    [mapView dequeueReusableAnnotationViewWithIdentifier:annotationViewId];
    if (_DLocation.DLocation.latitude == annotationtemp.coordinate.latitude && _DLocation.DLocation.longitude == annotationtemp.coordinate.longitude)
    {
        if (annotationView==nil)
        {
            annotationView = [[[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:annotationViewId] autorelease];
            annotationView.canShowCallout = NO;
        }
    }else
    {
        if (annotationView==nil)
        {
            annotationView = [[[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:annotationViewId] autorelease];
            annotationView.canShowCallout = NO;
            annotationView.pinColor = MKPinAnnotationColorGreen;
        }
    }

    return annotationView;
}
@end
