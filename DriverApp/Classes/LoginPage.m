
//
//  Created by Nagraj Gopalakrishnan on 22/11/11.
//  Copyright 2011 Apppli. All rights reserved.
//

#import "LoginPage.h"
#import "ALToastView.h"
#import "WebServiceHelper.h"
#import "Common.h"
#import "ScheduleJourneydetail.h"
#import "driverAppAppDelegate.h"

/*
@implementation UINavigationBar (CustomImage)
- (void)drawRect:(CGRect)rect {
    UIImage *image = [UIImage imageNamed: @"i_phone_loginorange_03.jpg"];
    [image drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
}*/

//@end

@implementation LoginPage
@synthesize LogIn,authUserResult;
@synthesize Forgotpassword;
@synthesize PhoneNo,expiryMessage;
@synthesize Password,RememberMe,docExpired;

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
- (void)viewWillAppear:(BOOL)animated {
	
	
	//[self.PhoneNo becomeFirstResponder];
	driverAppAppDelegate *appDelegate = (id)[[UIApplication sharedApplication] delegate];
	appDelegate.maintabBarController.tabBar.hidden=YES;
	[self.navigationController.view setNeedsLayout];
	self.view.frame = CGRectMake(160, 0, 320, 480);
	self.title=@"Scheduled Jobs";
	self.navigationItem.title = @"Login";
	CGRect newFrame = appDelegate.maintabBarController.view.frame;
	newFrame.size.height += appDelegate.maintabBarController.tabBar.frame.size.height;
	[appDelegate.maintabBarController.view setFrame:CGRectMake(newFrame.origin.x, newFrame.origin.y, newFrame.size.width, newFrame.size.height)];
	
	
	
	self.navigationItem.hidesBackButton = YES;
	Common *cmn=[[[Common alloc]init] autorelease];
	NSDictionary *keys=[cmn readPlist];
	NSInteger userID=[[keys objectForKey:@"UserId"]intValue];
	
	if(userID>0)
	{
		
		[Common setLoggedInDriver:userID];
		[Common setUserId:[keys objectForKey:@"username"]];
		[Common setPassword:[keys objectForKey:@"password"]];
	}
	// Register the observer for the keyboardWillShow event
	RememberMe.on = YES;
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardDidShowNotification object:nil];
	if([Common loggeduserId]!=nil  && [Common loggedUserpassword]!=nil){
		PhoneNo.text= [Common loggeduserId];
		Password.text=[Common loggedUserpassword];
	}
	else {
		PhoneNo.text=@"";
		Password.text=@"";
	}

}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	docExpired=NO;
	//[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(makeFirstResponder:) name:@"checkIfDateChanged" object:nil];
	
	[PhoneNo setPlaceholder:@"Username"];
	[Password setPlaceholder:@"Password"];
    [super viewDidLoad];
    
    self.navigationController.navigationBar.translucent = NO;

}

- (void)makeFirstResponder:(NSNotification *)notification {
	[self.PhoneNo becomeFirstResponder];
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



- (void)keyboardWillShow:(NSNotification *)notification {
	// locate keyboard view
	
	UIWindow *tempWindow = [[[UIApplication sharedApplication] windows] objectAtIndex:1];
	UIView *keyboard;
	for (int i = 0; i < [tempWindow.subviews count]; i++) {
		keyboard = [tempWindow.subviews objectAtIndex:i];
		// keyboard view found; add the Custom button to it
		if ([[keyboard description] hasPrefix:@"<UIPeripheralHostView"] == YES) {
			 //self.navigationController.navigationItem.rightBarButtonItem.tintColor = UIColorFromRGB(0x008A35);
			//self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:0.16f green:0.36f blue:0.46 alpha:0.8];
			self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(dismissKeyboard:)  ] autorelease];
			//self.navigationItem.rightBarButtonItem. = [UIColor colorWithRed:0.16f green:0.36f blue:0.46 alpha:0.8];
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
	if (self.PhoneNo.isFirstResponder) {
		[Password becomeFirstResponder];
	}
	else {
		[sender resignFirstResponder];
		self.navigationItem.leftBarButtonItem = nil;
		self.navigationItem.rightBarButtonItem = nil;
	}
	
	
} 


- (void)myTask {
    // Do something usefull in here instead of sleeping ...
	//  sleep(3);
}

- (IBAction)loginIn:(id)sender{
	if ([Common isNetworkExist]>0)
	{
		
		if ( ([PhoneNo.text length] > 0 ) && ([Password.text length] > 0 ) ) {
	[NSThread detachNewThreadSelector:@selector(authenticateUser) toTarget: self withObject: nil];	
		}
		else {
			
			[Common showAlert:@"Credential Required" message:@"Enter correct credentials"];			
		}
	}else {
		[Common showNetwokAlert];
	}
    

	
}

-(void)showProgress{
	NSAutoreleasePool *pool=[[NSAutoreleasePool alloc] init];
	
	/*Activity Indiactor  when login button was pressed
	UIActivityIndicatorView *actIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
	actIndicator.frame = CGRectMake(160, 0, 35, 35);
	 actIndicator.tag = 123456;
	[actIndicator startAnimating];
	[LogIn addSubview:actIndicator];
	[actIndicator release];*/
	
	MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
	hud.labelText=@"Authenticating..";
	//hud.detailsLabelText=@"Updating";
	hud.square=YES;
	[pool release];
}




-(void)authenticateUser{
    docExpired=NO;
	NSAutoreleasePool *authenticateActionPool=[[NSAutoreleasePool alloc] init];
	BOOL isSuccess=NO;
	
			
			[NSThread detachNewThreadSelector:@selector(showProgress) toTarget: self withObject: nil];
			WebServiceHelper *servicehelper=[[WebServiceHelper alloc] init];
			NSObject *obj=[[[NSObject alloc]init] autorelease];
			servicehelper.objEntity=obj;
			
			NSArray *sdkeys = [NSArray arrayWithObjects:@"username", @"password",nil];
			NSArray *sdobjects = [NSArray arrayWithObjects:PhoneNo.text,Password.text, nil];
			NSDictionary *sdparams = [NSDictionary dictionaryWithObjects:sdobjects forKeys:sdkeys];
			
			self.authUserResult=[servicehelper callWebService:[NSString stringWithFormat:@"%@driverauth",[Common webserviceURL]] pms:sdparams];
			
			NSDictionary *authenticatedUser=[authUserResult objectAtIndex:0];
			
			if([[authenticatedUser objectForKey:@"success"] boolValue])
			{
				
				//Redirecting to home Page
				// set the variables to the values in the text fields
				
				if(RememberMe.on)
				{
					Common *cmn=[[Common alloc]init];
					self.PhoneNoPlist = PhoneNo.text;
					self.PasswordPlist =Password.text;
					self.UserIdPlist =[authenticatedUser objectForKey:@"UserId"] ;
					NSDictionary *plistDict = [NSDictionary dictionaryWithObjects: [NSArray arrayWithObjects: PhoneNoPlist, PasswordPlist,UserIdPlist, nil] forKeys:[NSArray arrayWithObjects: @"username", @"password",@"UserId", nil]];	
					[cmn writePlist:plistDict];
					[cmn release];
					
				}
				else {
					Common *cmn=[[Common alloc]init];
					self.PhoneNoPlist = @"";
					self.PasswordPlist =@"";
					self.UserIdPlist =@"";
					NSDictionary *plistDict = [NSDictionary dictionaryWithObjects: [NSArray arrayWithObjects: PhoneNoPlist, PasswordPlist,UserIdPlist, nil] forKeys:[NSArray arrayWithObjects: @"username", @"password",@"UserId", nil]];	
					[cmn writePlist:plistDict];
					[cmn release];
				}
				
				[Common setLoggedInDriver:[[authenticatedUser objectForKey:@"UserId"]
                                           intValue]];
                [Common setLoggedInDriverNo:[[authenticatedUser objectForKey:@"Driver_Number"]
                                           intValue]];
                [Common setSupplierID:[[authenticatedUser objectForKey:@"SuppId"]
                                           intValue]];
                [Common setdropCompleteStatus:@""];
				NSString *driverStatus=[authenticatedUser objectForKey:@"AvailableStatus"] ;
				
                
              
				[Common setdriverStatus:driverStatus];
				[Common setUserId:PhoneNo.text];
				[Common setPassword:Password.text];
				[MBProgressHUD hideHUDForView:self.view animated:YES];
				//[Common setLoggedInUser:user];
				isSuccess=YES;

				
			}
			else {
				isSuccess=NO;
				[MBProgressHUD hideHUDForView:self.view animated:YES];
                [self performSelectorOnMainThread:@selector(showLoginFailed) withObject:nil waitUntilDone:NO];
				
			}
			
			[servicehelper release];
			
	[authenticateActionPool release];
	if (isSuccess) {
        
       self.expiryMessage=@"";
        NSInteger expiryNo=0;
        NSInteger driverPCO=[[authenticatedUser objectForKey:@"Driver_PCO"] intValue];
        NSInteger cabPCO=[[authenticatedUser objectForKey:@"Cab_PCO"] intValue];
        NSInteger cabMOT=[[authenticatedUser objectForKey:@"Cab_MOT"] intValue];
        NSInteger cabINS=[[authenticatedUser objectForKey:@"Cab_INS"] intValue];
        if (driverPCO>2 && cabPCO>2 && cabMOT>2  && cabINS>2 ) {
            docExpired=NO;
        }
        else{
           
            if(driverPCO==-1){
                expiryNo=expiryNo+1;
                docExpired=YES;
                //64-bit modification
                self.expiryMessage=[NSString stringWithFormat:@"%@%ld. Driver PCO has expired.\n",self.expiryMessage,(long)expiryNo];
            }
            else if (driverPCO>=0 && driverPCO<3){
                expiryNo=expiryNo+1;
                //64-bit modification
                self.expiryMessage=[NSString stringWithFormat:@"%@%ld. Driver PCO is going to expire in %ld days.\n",self.expiryMessage,(long)expiryNo,(long)(driverPCO+1)];
            }
            ////
            if(cabPCO==-1){
                docExpired=YES;
                expiryNo=expiryNo+1;
                //64-bit modification
                self.expiryMessage=[NSString stringWithFormat:@"%@%ld. Vehicle PCO has expired.\n",self.expiryMessage,(long)expiryNo];
            }
            else if (cabPCO>=0 && cabPCO<3){
                expiryNo=expiryNo+1;
                //64-bit modification
                self.expiryMessage=[NSString stringWithFormat:@"%@%ld. Vehicle PCO is going to expire in %ld days.\n",self.expiryMessage,(long)expiryNo,(long)(cabPCO+1)];
            }
            ////
            if(cabMOT==-1){
                expiryNo=expiryNo+1;
                docExpired=YES;
                //64-bit modification
                self.expiryMessage=[NSString stringWithFormat:@"%@%ld. Vehicle MOT has expired.\n",self.expiryMessage,(long)expiryNo];
            }
            else if (cabMOT>=0 && cabMOT<3){
                expiryNo=expiryNo+1;
                //64-bit modification
                self.expiryMessage=[NSString stringWithFormat:@"%@%ld. Vehicle MOT is going to expire in %ld days.\n",self.expiryMessage,(long)expiryNo,(long)(cabMOT+1)];
            }
            ////
            if(cabINS==-1){
                expiryNo=expiryNo+1;
                docExpired=YES;
                //64-bit modification
                self.expiryMessage=[NSString stringWithFormat:@"%@%ld. Vehicle Insurance has expired.\n",self.expiryMessage,(long)expiryNo];
            }
            else if (cabINS>=0 && cabINS<3){
                expiryNo=expiryNo+1;
                //64-bit modification
                self.expiryMessage=[NSString stringWithFormat:@"%@%ld. Vehicle Insurance is going to expire in %ld days.",self.expiryMessage,(long)expiryNo,(long)(cabINS+1)];
            }
            
           
        }
        if(![self.expiryMessage isEqualToString:@""]){
            if (docExpired) {
                self.expiryMessage=[NSString stringWithFormat:@"%@ \nAs one or more document has expired, you can't be logged in. Please renew your documents to use WiseDriver again.",self.expiryMessage];
            }
            else{
                self.expiryMessage=[NSString stringWithFormat:@"%@ \nPlease renew these documents before it expires.",self.expiryMessage];
            }
            
            [self performSelectorOnMainThread:@selector(showExpirationAlert) withObject:nil waitUntilDone:NO];
          

        }
        else{
            if (!docExpired) {
                [self performSelectorOnMainThread:@selector(pushToScheduledJourney) withObject:nil waitUntilDone:NO];
                
            }
        }
	}
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (!docExpired) {
        [self performSelectorOnMainThread:@selector(pushToScheduledJourney) withObject:nil waitUntilDone:NO];
        
    }
}
-(void)showLoginFailed{
    [Common showAlert:@"Login Failed" message:@"Enter correct credentials"];
}

-(void)showExpirationAlert{
    UIAlertView *expirationAlert = [[UIAlertView alloc] initWithTitle:@"Document Expiration Alert" message:self.expiryMessage delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
    [expirationAlert addButtonWithTitle:@"OK"];
   
    NSArray *subviewArray = expirationAlert.subviews;
    for(int x = 0; x < [subviewArray count]; x++){
        
        if([[[subviewArray objectAtIndex:x] class] isSubclassOfClass:[UILabel class]]) {
            UILabel *label = [subviewArray objectAtIndex:x];
            label.textAlignment = UITextAlignmentLeft;
        }
    }
    [expirationAlert show];
    //[Common showAlert:@"Document Expiration Alert" message:self.expiryMessage];
}

-(void)pushToScheduledJourney{
	ScheduleJourneydetail *scheduledJourneydetail=[[ScheduleJourneydetail alloc] init];
	scheduledJourneydetail.tabName=@"Scheduled Jobs";
	[UIApplication sharedApplication].idleTimerDisabled = YES;
	[self.navigationController pushViewController:scheduledJourneydetail animated:YES];
	//[scheduledJourneydetail release];
}



/*
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations.
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 */

- (void)viewWillDisappear:(BOOL)animtated {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	driverAppAppDelegate *appDelegate = (id)[[UIApplication sharedApplication] delegate];
	appDelegate.maintabBarController.tabBar.hidden=NO;
	//[self.navigationController.view setNeedsLayout];
	//self.view.frame = CGRectMake(160, 0, 320, 480);
	CGRect newFrame = appDelegate.maintabBarController.view.frame;
	newFrame.size.height -= appDelegate.maintabBarController.tabBar.frame.size.height;
	[appDelegate.maintabBarController.view setFrame:CGRectMake(newFrame.origin.x, newFrame.origin.y, newFrame.size.width, newFrame.size.height)];
}

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
	[LogIn release];
	[Forgotpassword release];
	[PhoneNo release];
	[Password release];
	[RememberMe release];
	[authUserResult release];
	[PhoneNoPlist release];
	[PasswordPlist release];
	[UserIdPlist release];
    //[expiryMessage release];
    [super dealloc];
}


@end
