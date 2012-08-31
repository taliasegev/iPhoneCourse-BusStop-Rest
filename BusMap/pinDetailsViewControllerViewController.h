//
//  pinDetailsViewControllerViewController.h
//  BusMap
//
//  Created by taliasegev on 8/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BusStop.h"

@protocol pinDetailsViewControllerViewControllerDelegate
@required


- (void)updateBusStop:(BusStop *)_busStop;

@end

@interface pinDetailsViewControllerViewController : UIViewController  <UITextFieldDelegate>

{
    
    IBOutlet UITextField *uiTextFieldStopsTitle;
    IBOutlet UILabel *uiLabelStopsSubtitle;
    IBOutlet UILabel *uiLabelLatitude;
    IBOutlet UILabel *uiLabelLongitude;
    
    BusStop *busStop;
    
    __weak id <pinDetailsViewControllerViewControllerDelegate> delegate;
}

@property (nonatomic, weak) id delegate;

@property (nonatomic, strong) BusStop* busStop;

-(IBAction)dismissSelf:(id)sender;

@end
