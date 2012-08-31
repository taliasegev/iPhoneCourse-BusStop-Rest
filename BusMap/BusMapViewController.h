//
//  BusMapViewController.h
//  BusMap
//
//  Created by taliasegev on 8/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/Mapkit.h>

@class BusStop;

@interface BusMapViewController : UIViewController <MKMapViewDelegate>{
    
    IBOutlet MKMapView *mainMapView;
    IBOutlet UILabel *uiLabelCoordinates;
    
    NSMutableArray *stops;
}


-(void)updateMapCenter:(CLLocationCoordinate2D)coordinate;

-(void)updateStop:(NSString *)title
         subtitle:(NSString *)subtitle
         latitude:(float)latitude
        longitude:(float)longitude
           stopId:(int)stopId;

-(IBAction)buttonPressed:(id)sender;
- (void)updateBusStop:(BusStop *)_busStop;


@end
