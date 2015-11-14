//
//  tztMapView.h
//  tztMobileApp_yyz
//
//  Created by 张 小龙 on 13-6-5.
//
//

#import "TZTUIBaseView.h"
#import <MapKit/MapKit.h>
#import "MapAnnotation.h"
@interface tztMapView : TZTUIBaseView<MKMapViewDelegate>
{
    MKMapView *_mapView;
    MapAnnotation*  _DLocation;
    MapAnnotation*  _DMyLocation;
}
@property (nonatomic,retain)IBOutlet MKMapView *mapView;
@property (nonatomic,retain) MapAnnotation* DLocation;
@property (nonatomic,retain) MapAnnotation* DMyLocation;
@end
