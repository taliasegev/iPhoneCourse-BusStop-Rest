//
//  BusMapViewController.m
//  BusMap
//
//  Created by taliasegev on 8/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BusMapViewController.h"
#import "BusStop.h"
#import "pinDetailsViewControllerViewController.h"

@interface BusMapViewController ()

@end

@implementation BusMapViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    
    [self updateStop:@"Yaaaa" subtitle:@"Rishon" latitude:32.08 longitude:34.7990 stopId:3];
    
    
    NSMutableArray *stopsServerArray = [self getBusStops];
    NSLog(@"%@",stopsServerArray);
    stops = [self parseBusStops:stopsServerArray];
    
    CLLocationCoordinate2D coordinate;
    
    coordinate = CLLocationCoordinate2DMake(32.08, 34.7805);
    [self updateMapCenter:coordinate];
    
    [self showStops];
    
//    CLLocationCoordinate2D coordinate;
//    
//    coordinate = CLLocationCoordinate2DMake(32.08, 34.7805);
//    
//    [self updateMapCenter:coordinate];
//    //[self addAnnotation:coordinate title:@"Rabin's square" subtitle:@"Tel Aviv"];
//
//    //coordinate = CLLocationCoordinate2DMake(32.0823, 34.781);
// //   BusStop *busStop = [[BusStop alloc]initWithCoordinate:coordinate title:@"gan hair stop" subtitle:@"tel aviv"];
//
//
//  //  [mainMapView addAnnotation:busStop];
//    
//    stops = [[NSMutableArray alloc]initWithCapacity:4];
//    
//    [stops addObject:[[BusStop alloc]initWithCoordinate:CLLocationCoordinate2DMake(32.08, 34.7805) title:@"Gan Hair stop" subtitle:@"Tel aviv"]];
//    
//    
//    [stops addObject:[[BusStop alloc]initWithCoordinate:CLLocationCoordinate2DMake(32.08, 34.7740) title:@"Dizingoff stop" subtitle:@"Tel aviv"]];
//    
//    
//    [stops addObject:[[BusStop alloc]initWithCoordinate:CLLocationCoordinate2DMake(32.084, 34.7744) title:@"Ben Gurion stop" subtitle:@"Tel aviv"]];
//    
//    
//    
//    [stops addObject:[[BusStop alloc]initWithCoordinate:CLLocationCoordinate2DMake(32.079, 34.7777) title:@"Frishman stop" subtitle:@"Tel aviv"]];
//    
    
//    [self showStops];
    

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

-(void)updateMapCenter:(CLLocationCoordinate2D)coordinate{
    
    MKCoordinateRegion region;
    
    region.center=coordinate;
    region.span=MKCoordinateSpanMake(0.005, 0.005);
    
    [mainMapView setRegion:region animated:TRUE];
}

-(void)addAnnotation:(CLLocationCoordinate2D)coordinate title:(NSString *)title subtitle:(NSString *)subtitle{
    
    MKPointAnnotation *pointAnnotation = [[MKPointAnnotation alloc]init];
    pointAnnotation.coordinate = coordinate;
    pointAnnotation.title = title;
    pointAnnotation.subtitle = subtitle;
    
    [mainMapView addAnnotation:pointAnnotation];
    
}

-(void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated{
    NSLog(@"lat: %f lon: %f",mapView.region.center.latitude, mapView.region.center.longitude);
    uiLabelCoordinates.text = [[NSString alloc]initWithFormat:@"lat: %f lon: %f",mapView.region.center.latitude, mapView.region.center.longitude];
}

-(IBAction)buttonPressed:(id)sender{
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(mainMapView.region.center.latitude, mainMapView.region.center.longitude);
    NSString *subtitle = [[NSString alloc]initWithFormat:@"lat: %f lon: %f",mainMapView.region.center.latitude, mainMapView.region.center.longitude];
    [self addAnnotation:coordinate title:@"bus stop" subtitle:subtitle];
    
    
    
}

-(void)showStops{
    NSLog(@"showStops::");
    for (BusStop *busStop in stops) {
        [mainMapView addAnnotation:busStop];
        NSLog(@"lat: %f lon: %f",busStop.coordinate.latitude, busStop.coordinate.longitude);
    }
}

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
    
    MKPinAnnotationView * pinView;
    static NSString* BusStopIdentifier = @"busStopAnnotationIdentifier";
    
    pinView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:BusStopIdentifier];
    
    if (pinView) {
        pinView.annotation = annotation;
    }
    else{
        
        pinView = [[MKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:BusStopIdentifier];
        pinView.pinColor = MKPinAnnotationColorGreen;
        pinView.animatesDrop = YES;
        pinView.canShowCallout = YES;
        
        UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        pinView.rightCalloutAccessoryView = rightButton;
    }
    return pinView;
    
}

-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control{
    
//    BusStop *busStop = (BusStop *)view.annotation;
//    
//    CLLocation *annotationLocation = [[CLLocation alloc]initWithLatitude:busStop.coordinate.latitude longitude:busStop.coordinate.longitude];
//    
//    CLLocation *yourLocation = [[CLLocation alloc]initWithLatitude:32.08 longitude:34.7804];
//    
//    CLLocationDistance distance = [yourLocation distanceFromLocation:annotationLocation];
//    
//    uiLabelCoordinates.text = [[NSString alloc]initWithFormat:@"this stop is %f km from your location",distance];
    
    pinDetailsViewControllerViewController *pinDetailsViewController  = [[pinDetailsViewControllerViewController alloc]initWithNibName:@"pinDetailsViewControllerViewController" bundle:nil];
    pinDetailsViewController.delegate = self;
    pinDetailsViewController.busStop = (BusStop *)view.annotation;
    
    [self presentModalViewController:pinDetailsViewController animated:YES];
    
    
    
}

-(NSMutableArray *)getBusStops{
    
    NSMutableArray *stopsArray;
    
    NSURL *urlStopsGet = [[NSURL alloc]initWithString:@"http://localhost/hopon/api/stops"];
    NSData *data = [[NSData alloc]initWithContentsOfURL:urlStopsGet];
    
    NSError *error;
    stopsArray = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
                  
    return stopsArray;
                 
    
}


-(NSMutableArray *)parseBusStops:(NSMutableArray *)stopsServerArray{
    
    NSMutableArray *stopsArray = [[NSMutableArray alloc]init];
    
    for(NSDictionary *stopDictionary in stopsServerArray){
        
        int stopId = [[stopDictionary objectForKey:@"id"] intValue];
        float latitude = [[stopDictionary objectForKey:@"latitude"] floatValue];
        float longitude = [[stopDictionary objectForKey:@"longitude"] floatValue];
        NSString *title = [stopDictionary objectForKey:@"title"];
        NSString *subtitle = [stopDictionary objectForKey:@"subtitle"];
        
        BusStop *busStop = [[BusStop alloc]
                            initWithCoordinate:CLLocationCoordinate2DMake(latitude, longitude) title:title subtitle:subtitle];
        busStop.stopId = stopId;
        
        [stopsArray addObject:busStop];
                           
    }
    
    return stopsArray;
    
}

-(void)updateStop:(NSString *)title
         subtitle:(NSString *)subtitle
         latitude:(float)latitude
        longitude:(float)longitude
           stopId:(int)stopId{

    NSString *jsonRequest = [[NSString alloc]initWithFormat:@"{\"title\":\"%@\",\"subtitle\":\"%@\",\"latitude\":%f,\"longitude\":%f}",title,subtitle,latitude,longitude];
    
    NSLog(@"Request %@",jsonRequest);
    
    NSString *urlStopsUpdatePath = [[NSString alloc]initWithFormat:@"http://localhost/hopon/api/stops/%d",stopId];
    
    NSURL *urlStopsUpdate = [[NSURL alloc]initWithString:urlStopsUpdatePath];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:urlStopsUpdate];
    
    NSData *requestData = [NSData dataWithBytes:[jsonRequest UTF8String] length:[jsonRequest length]];
    

    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NSString stringWithFormat:@"%d", [requestData length]] forHTTPHeaderField:@"Content-Length"];
    
    [request setHTTPBody:requestData];
    
    NSURLConnection *connection = [NSURLConnection connectionWithRequest:request delegate:self];
    [connection start];


}



- (void)updateBusStop:(BusStop *)_busStop {
    [self updateStop:_busStop.title subtitle:_busStop.subtitle latitude:_busStop.coordinate.latitude longitude:_busStop.coordinate.longitude stopId:_busStop.stopId];
}




-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    
    NSString *output = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"%@",output);
}



@end
