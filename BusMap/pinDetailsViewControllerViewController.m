//
//  pinDetailsViewControllerViewController.m
//  BusMap
//
//  Created by taliasegev on 8/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "pinDetailsViewControllerViewController.h"

@interface pinDetailsViewControllerViewController ()

@end

@implementation pinDetailsViewControllerViewController

@synthesize busStop, delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    uiTextFieldStopsTitle.text = busStop.title;
    uiLabelStopsSubtitle.text = busStop.subtitle;
    uiLabelLatitude.text = [[NSString alloc]initWithFormat:@"Latitude: %f",busStop.coordinate.latitude];
    uiLabelLongitude.text = [[NSString alloc]initWithFormat:@"Longitude: %f",busStop.coordinate.longitude];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(IBAction)dismissSelf:(id)sender{
    
    busStop.title = uiTextFieldStopsTitle.text;
    [delegate updateBusStop:busStop];
    
    [self dismissModalViewControllerAnimated:YES];
     
 
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
}

@end
