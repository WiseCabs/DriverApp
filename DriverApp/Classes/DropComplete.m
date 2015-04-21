//
//  DropComplete.m
//  driverApp
//
//  Created by Nagraj Gopalakrishnan on 23/11/11.
//  Copyright 2011 Apppli. All rights reserved.
//

#import "DropComplete.h"
#import "WebServiceHelper.h"
#import "Common.h"
#import "ScheduleJourneydetail.h"

@implementation DropComplete
@synthesize totalFareCollected;
@synthesize totalpassengers,totalPassenger,totalfare;
@synthesize allocatedJourneyID,userId,supplierId;

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/
- (void)viewWillAppear:(BOOL)animtated {

		
	// Register the observer for the keyboardWillShow event
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardDidShowNotification object:nil];
	
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	self.title=@"Drop Complete";
	
	[totalpassengers setBorderStyle:UITextBorderStyleRoundedRect];
	[totalpassengers setPlaceholder:@"Total Passengers Boarded"];
	//[PhoneNo setDelegate:self];
	[totalpassengers setEnablesReturnKeyAutomatically: TRUE];
	[totalpassengers setReturnKeyType:UIReturnKeyDone];
	[totalpassengers setAdjustsFontSizeToFitWidth:YES];
	
	
	[totalFareCollected setBorderStyle:UITextBorderStyleRoundedRect];
	[totalFareCollected setPlaceholder:@"Total Fare Collected"];
	//[Password setDelegate:self];
	[totalFareCollected setEnablesReturnKeyAutomatically: TRUE];
	[totalFareCollected setReturnKeyType:UIReturnKeyDone];
	[totalFareCollected setAdjustsFontSizeToFitWidth:YES];
    [super viewDidLoad];
    
    self.navigationController.navigationBar.translucent = NO;

}
- (void)keyboardWillShow:(NSNotification *)notification {
	// locate keyboard view	
	UIWindow *tempWindow = [[[UIApplication sharedApplication] windows] objectAtIndex:1];
	UIView *keyboard;
	for (int i = 0; i < [tempWindow.subviews count]; i++) {
		keyboard = [tempWindow.subviews objectAtIndex:i];
		// keyboard view found; add the custom button to it
		if ([[keyboard description] hasPrefix:@"<UIPeripheralHostView"] == YES) {
			self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(dismissKeyboard:)  ] autorelease];
			
		}
	}
}


- (IBAction)dismissKeyboard:(id)sender
{
	[self.totalpassengers resignFirstResponder];
	[self.totalFareCollected resignFirstResponder];
	self.navigationItem.rightBarButtonItem = nil;
}
-(IBAction) DropDone:(id)sender
{
	if ([Common isNetworkExist]>0)
	{
		NSString *passengersToBeSent=@"";
		NSString *fareToBeSent=@"";
		if ( ([totalpassengers.text length] > 0 )){
			passengersToBeSent=[NSString stringWithFormat:@"%@",totalpassengers.text];
		}
		else {
			passengersToBeSent=[NSString stringWithFormat:@"%@",totalPassenger];
		}
		
		if ( ([totalFareCollected.text length] > 0 )){
			fareToBeSent=[NSString stringWithFormat:@"%@",totalFareCollected.text];
		}
		else {
			fareToBeSent=[NSString stringWithFormat:@"%@",totalfare];
		}
		
		
	WebServiceHelper *servicehelper=[[WebServiceHelper alloc] init];
	servicehelper.objEntity=[[NSObject alloc]init];
	
	NSArray *sdkeys = [NSArray arrayWithObjects:@"uid",@"type",@"aj_id",@"fare",@"no_of_passenger",@"destination",@"suppID", nil];
	NSArray *sdobjects = [NSArray arrayWithObjects:[NSString stringWithFormat:@"%ld",(long)userId],@"dropCompleted",[NSString stringWithFormat:@"%ld",(long)allocatedJourneyID],fareToBeSent,passengersToBeSent,@"",[NSString stringWithFormat:@"%ld",(long)supplierId], nil];          //64-bit modification
        
	NSDictionary *sdparams = [NSDictionary dictionaryWithObjects:sdobjects forKeys:sdkeys];
	NSString *URL=[NSString stringWithFormat:@"%@driveroptions",[Common webserviceURL]];
	NSArray *allJourney=[servicehelper callWebService:URL pms:sdparams];
			
			[servicehelper release];
	if ([allJourney count]>0) {
		if([[[allJourney objectAtIndex:0] objectForKey:@"success"] boolValue])
		{ 
			[Common setdropCompleteStatus:@"Yes"];
			NSArray *controllers=[self.navigationController viewControllers];
			[self.navigationController popToViewController:[controllers objectAtIndex:[controllers count]-3] animated:YES];
		}else {
		}

		
	}
	}
		
		
		
	else {
		[Common showNetwokAlert];
	}
	
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewWillDisappear:(BOOL)animtated {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[totalPassenger release];
	[totalfare release];
	[totalFareCollected release];
	[totalpassengers release];
    [super dealloc];
}


@end
