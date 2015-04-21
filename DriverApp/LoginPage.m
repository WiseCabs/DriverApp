//
//  LoginPage.m
//  driverApp
//
//  Created by Nagraj Gopalakrishnan on 22/11/11.
//  Copyright 2011 Apppli. All rights reserved.
//

#import "LoginPage.h"
#import "HomePage.h"
#import "WebServiceHelper.h"
#import "Common.h"


@implementation LoginPage
@synthesize LogIn;
@synthesize Forgotpassword;
@synthesize PhoneNo;
@synthesize Password,RememberMe;

@synthesize PhoneNoPlist;
@synthesize PasswordPlist;
@synthesize UserIdPlist;

// The designated initializer.  Override if you create the controller programmatically and want to perform Customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(@synthesize)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	self.title=@"Login";
	
	//setting temporary redirection to Journey Details
	
	//[ PhoneNo setKeyboardType:UIKeyboardTypeNumbersAndPunctuation ];
	
	[PhoneNo setBorderStyle:UITextBorderStyleRoundedRect];
	[PhoneNo setPlaceholder:@"Username"];
	//[PhoneNo setDelegate:self];
	[PhoneNo setEnablesReturnKeyAutomatically: TRUE];
	[PhoneNo setReturnKeyType:UIReturnKeyDone];
	[PhoneNo setAdjustsFontSizeToFitWidth:YES];
	
	
	[Password setBorderStyle:UITextBorderStyleRoundedRect];
	[Password setPlaceholder:@"Password"];
	//[Password setDelegate:self];
	[Password setEnablesReturnKeyAutomatically: TRUE];
	[Password setReturnKeyType:UIReturnKeyDone];
	[Password setAdjustsFontSizeToFitWidth:YES];
	
	
    [super viewDidLoad];
}

- (IBAction)dismissKeyboard:(id)sender
{
	
	//[[self.view findFirstResponder] resignFirstResponder];
	[self.PhoneNo resignFirstResponder];
	//[self.view resignFirstResponder];
	[self.Password resignFirstResponder];
	self.navigationItem.leftBarButtonItem = nil;
	self.navigationItem.rightBarButtonItem = nil;
}






- (IBAction) cancelEdit:(id)sender
{
	if (self.PhoneNo.isFirstResponder) {
		[PhoneNo setText:@""];
		[self.PhoneNo resignFirstResponder];
	}
	else {
		[Password setText:@""];
		[self.Password resignFirstResponder];
	}
	self.navigationItem.leftBarButtonItem = nil;
	self.navigationItem.rightBarButtonItem = nil;
	
}
- (void)viewWillAppear:(BOOL)animtated {
	
	// Register the observer for the keyboardWillShow event
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardDidShowNotification object:nil];
	
}

- (void)viewWillDisappear:(BOOL)animtated {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)keyboardWillShow:(NSNotification *)notification {
	 // locate keyboard view
	
	UIWindow *tempWindow = [[[UIApplication sharedApplication] windows] objectAtIndex:1];
	UIView *keyboard;
	for (int i = 0; i < [tempWindow.subviews count]; i++) {
		keyboard = [tempWindow.subviews objectAtIndex:i];
		// keyboard view found; add the Custom button to it
		if ([[keyboard description] hasPrefix:@"<UIPeripheralHostView"] == YES) {
			self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(dismissKeyboard:)  ] autorelease];
			
			//self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancelEdit:)] autorelease];
			self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancelEdit:)] autorelease];
		}
	}
}

-(BOOL)textFieldShouldReturn:(UITextField *)theTextField {
	// Set the FirstResponder of the UITextField on the layout
	[self.view resignFirstResponder];
	
	return YES;
}
 
-(IBAction)textFieldReturn:(id)sender
{
	[sender resignFirstResponder];
	self.navigationItem.leftBarButtonItem = nil;
	self.navigationItem.rightBarButtonItem = nil;
} 

- (void)myTask {
    // Do something usefull in here instead of sleeping ...
 //  sleep(3);
}

- (IBAction)loginIn:(id)sender{
	
	//Log In Actions need to be coded here
 if ([Common isNetworkExist]>0)
	{
		
   if ( ([PhoneNo.text length] > 0 ) || ([Password.text length] > 0 ) ) {
		 
		WebServiceHelper *servicehelper=[[WebServiceHelper alloc] init];
		NSObject *obj=[[[NSObject alloc]init] autorelease];
		servicehelper.objEntity=obj;
		
		NSArray *sdkeys = [NSArray arrayWithObjects:@"username", @"password",nil];
		NSArray *sdobjects = [NSArray arrayWithObjects:PhoneNo.text,Password.text, nil];
		NSDictionary *sdparams = [NSDictionary dictionaryWithObjects:sdobjects forKeys:sdkeys];
		
		NSArray *result=[servicehelper callWebService:[NSString stringWithFormat:@"%@driverauth",[Common webserviceURL]] pms:sdparams];
		
		NSDictionary *authUser=[result objectAtIndex:0];
		
		if([[authUser objectForKey:@"success"] boolValue])
		{
			
			//Redirecting to home Page
			// set the variables to the values in the text fields
			
			if(RememberMe.on)
			{
				Common *cmn=[[Common alloc]init];
				self.PhoneNoPlist = PhoneNo.text;
				self.PasswordPlist =Password.text;
				self.UserIdPlist =[authUser objectForKey:@"UserId"] ;
				NSDictionary *plistDict = [NSDictionary dictionaryWithObjects: [NSArray arrayWithObjects: PhoneNoPlist, PasswordPlist,UserIdPlist, nil] forKeys:[NSArray arrayWithObjects: @"username", @"password",@"UserId", nil]];	
				[cmn writePlist:plistDict];

			}
			[Common setLoggedInDriver:[[authUser objectForKey:@"UserId"]intValue]];
			[Common setUserId:PhoneNo.text];
			[Common setPassword:Password.text];
			
			HomePage *homePage=[[HomePage alloc] init];
			homePage.scheduledJourneyCount=[authUser objectForKey:@"ScheduledJourneyCount"] ;
			homePage.completedJourneyCount=[authUser objectForKey:@"CompletedJourneyCount"]; 
			homePage.userID=[[authUser objectForKey:@"UserId"] intValue];	
			[self.navigationController pushViewController:homePage animated:YES];
			[homePage autorelease];
		}
		else {
			[Common showAlert:@"Login Failed" message:@"Enter correct credentials"];
		}
			
		[servicehelper release];
		}
 else {			
		[Common showAlert:@"Credential Required" message:@"Enter correct credentials"];			
 }
	}else {
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

- (void)viewDidUnload {
	
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	
    [super dealloc];
}


@end
