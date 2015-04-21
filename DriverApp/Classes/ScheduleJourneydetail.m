//
//  ScheduleJourneydetail.m
//  driverApp
//
//  Created by Nagraj Gopalakrishnan on 16/11/11.
//  Copyright 2011 Apppli. All rights reserved.
//
#import "ScheduleJourneydetail.h"
//#import "JSON.h"
#import "TableViewCell.h"
#import "ScheduleTravelDetails.h"
#import "AllocatedJourney.h"
#import "Journey.h"
#import "Common.h"
#import "WebServiceHelper.h"
#import "MBProgressHUD.h"
#import "driverAppAppDelegate.h" 
#import "LoginPage.h"
#import "CoreLocation.h"
#import "ALToastView.h"
#import "DriverWaitingDetails.h"
#import <AudioToolbox/AudioToolbox.h>

@implementation ScheduleJourneydetail
@synthesize mainTableView,alertShown,internetAlertShown,expirationAlert,dateChanged,expiryMessage,docExpired;
@synthesize travelarray,logoutAlert,newJnyAlert,newJourneysArray,newJourneyNo;
@synthesize segmentControl,jnyDict,latitude,longitude,button,isLoggedIn,acknowledgeJourneyActionSheet,dropRejectedAlert,reloadTableView;
@synthesize todayTravelDetails,tomorrowDate,todayDate,groupedArray,toAddress,selectJourney,nonProtected;
@synthesize tomorrowTravelDetails,updatetimer,flag,tabName,cameFromLoginPage,isScheduled,uniqueArray,networkAlert,isRefreshingScheduled,isRefreshingCompleted;

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

- (void)viewWillAppear:(BOOL)animated {
    updatetimer = [NSTimer scheduledTimerWithTimeInterval: 60.0 target: self selector:@selector(onTick:) userInfo: nil repeats:YES];
    
	newJourneyNo=0;
	reloadTableView=NO;
    internetAlertShown=NO;
    dateChanged=NO;
	alertShown=NO;
	self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Logout" style:UIBarButtonItemStylePlain target:self action:@selector(showLogoutPage:)  ] autorelease];
	
	if([self tabName]==@"Scheduled Jobs")
	{
		if (!isRefreshingScheduled) {
			if (!alertShown) {
				[self performSelector:@selector(updatejourney) withObject:nil afterDelay:0];
			}
		}
		self.isScheduled=YES;
		self.title=@"Scheduled Jobs";	
		NSDateFormatter *dateFormat = [[[NSDateFormatter alloc] init] autorelease];
		[dateFormat setDateFormat:@"dd/MM/yyyy"];
		NSDate *now = [[[NSDate alloc] init]autorelease];	
		self.todayDate= [dateFormat stringFromDate:now];
		NSDate *fulltomorrowDate = [now dateByAddingTimeInterval:24*60*60];
		self.tomorrowDate=[dateFormat stringFromDate:fulltomorrowDate];
		//[dateFormat release];
		[segmentControl setHidden:NO];
		[segmentControl addTarget: self action: @selector(onSegmentedControlChanged:) forControlEvents: UIControlEventValueChanged];
		//
		
	}else
	{
		if (!isRefreshingCompleted) {
		[self performSelector:@selector(updatejourney) withObject:nil afterDelay:0];
		}
		self.title=@"Completed Jobs";
		[segmentControl setHidden:YES];
		[mainTableView setFrame:CGRectMake(0.0, 0.0,self.view.frame.size.width, self.view.frame.size.height)];
	}
   
	[super viewWillAppear:TRUE];
}

- (void)checkDate:(NSNotification *)notification {
    dateChanged=YES;
    
    if ([self tabName]==@"Scheduled Jobs" ) {
	NSDateFormatter *dateFormat = [[[NSDateFormatter alloc] init] autorelease];
	[dateFormat setDateFormat:@"dd/MM/yyyy"];
	NSDate *now = [[[NSDate alloc] init]autorelease];
	self.todayDate= [dateFormat stringFromDate:now];
	NSDate *fulltomorrowDate = [now dateByAddingTimeInterval:24*60*60];
	self.tomorrowDate=[dateFormat stringFromDate:fulltomorrowDate];
    if (!alertShown) {
        if ([Common isNetworkExist]) {
            [self performSelector:@selector(updatejourney) withObject:nil afterDelay:0];

        }
        else{
            //internetAlertShown=YES;
            //alertShown=YES;
            [self showConnectionAlert];
        }
    }
	
	if([CLLocationManager locationServicesEnabled] &&
	   [CLLocationManager authorizationStatus] != kCLAuthorizationStatusDenied)	{
        if ([locationController.locationManager respondsToSelector:@selector
             (requestWhenInUseAuthorization)]) {
            [locationController.locationManager requestWhenInUseAuthorization];
        }
        [locationController.locationManager startUpdatingLocation];
    }
	else {
		[locationController.locationManager stopUpdatingLocation];
	}
	}
}
- (void)viewDidLoad {
    dateChanged=NO;
    isLoggedIn=YES;
    cameFromLoginPage=YES;
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
	//isNetworkAlertShowing=NO;
	isRefreshingCompleted=NO;
	isRefreshingScheduled=NO;
	//[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataUpdated:) name:@"DataUpdatedNotification" object:nil];
	if ([self tabName]==@"Scheduled Jobs" ) {
		firstTime=YES;
	}
	
	locationController = [[CoreLocation alloc] init];
    locationController.delegate = self;
	locationController.locationManager.distanceFilter=400;
	
	
	self.navigationItem.hidesBackButton = YES;
	self.isScheduled=NO;
	if([self tabName]==@"Scheduled Jobs")
	{
	segmentControl.selectedSegmentIndex=0;
	}
	
	//driverTimer = [NSTimer scheduledTimerWithTimeInterval: 60.0 target: self selector:@selector(sendDriverlocation:) userInfo: nil repeats:YES];
 
	driverAppAppDelegate *appDelegate = (driverAppAppDelegate *)[[UIApplication sharedApplication] delegate];
	appDelegate.maintabBarController.tabBar.hidden=NO;
	self.navigationItem.hidesBackButton = YES;
	//if (self.cameFromLoginPage) {
	NSMutableArray *allControllers = [[NSMutableArray alloc] initWithArray:self.navigationController.viewControllers];
	for (id controller in allControllers) {
		if ([controller isKindOfClass:[LoginPage class]]){
			[allControllers removeObject:controller];
			break;
		}		
	}
	[self.navigationController setViewControllers:allControllers animated:NO];
	[allControllers release];
	
	
	//Getting today's date and formatting it according to required json dateformat
	[segmentControl setFrame:CGRectMake(8.0, 0.0, 300.0, 37.0)];
	
	flag=YES;
	//if ( [[Common driverStatus] isEqualToString:@"On Route to Base Location"]) {
		button=  [UIButton buttonWithType:UIButtonTypeCustom];
		[button setImage:[UIImage imageNamed:@"ActionSheetIcon2.png"] forState:UIControlStateNormal];
		[button addTarget:self action:@selector(showActionSheet:) forControlEvents:UIControlEventTouchUpInside];
		[button setFrame:CGRectMake(0, 0, 32, 32)];
		self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:button] autorelease];
	//}
    
    
	///////////////////////////////////////////////////NSThread and NSNotification///////////////////////////////////////////
	//[NSThread detachNewThreadSelector:@selector(updateLocation) toTarget:self withObject:nil];
   // [self performSelector:@selector(updateLocation) withObject:nil afterDelay:10.0];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stopUpdatingService:) name:@"stopUpdating" object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkDate:) name:@"checkIfDateChanged" object:nil];
    
    if ([locationController.locationManager respondsToSelector:@selector
         (requestWhenInUseAuthorization)]) {
        [locationController.locationManager requestWhenInUseAuthorization];
    }
    [locationController.locationManager startUpdatingLocation];
	
	[super viewDidLoad];
    
    self.navigationController.navigationBar.translucent = NO;

}

-(void)stopUpdatingService:(NSNotification *) notification{
	[locationController.locationManager stopUpdatingLocation];
}

-(void)sendLocation{
    WebServiceHelper *servicehelper=[[WebServiceHelper alloc] init];
    servicehelper.objEntity=[[[NSObject alloc]init] autorelease];
   
  
    
    NSArray *sdkeys = [NSArray arrayWithObjects:@"driverID",@"lon",@"lat",@"suppID",@"type", nil];
    NSArray *sdobjects = [NSArray arrayWithObjects:[NSString stringWithFormat:@"%ld",(long)[Common loggedInDriverID]],self.longitude,self.latitude, [NSString stringWithFormat:@"%ld",(long)[Common supplierID]],[Common dropCompleteStatus],nil];
    NSDictionary *sdparams = [NSDictionary dictionaryWithObjects:sdobjects forKeys:sdkeys];
    NSString *toastString=[NSString stringWithFormat:@"lat-%@,lon-%@",self.latitude,self.longitude];
    //dropCancelURL= dropCancelUrl+"driveravailable?"+"driverID="+userID+"&status="+"offLine";
    NSArray *resultArray=[servicehelper callWebService:[NSString stringWithFormat:@"%@driverlocation",[Common webserviceURL]] pms:sdparams];
    NSDictionary *sucessDictionary = [resultArray objectAtIndex:0];
    NSString *sucessString=[sucessDictionary objectForKey:@"success"];
    NSString *driverStatus=[sucessDictionary objectForKey:@"Distance"];
    if ([sucessString isEqualToString:@"true"]) {
        
        if (![driverStatus isEqualToString:@""]) {
            [Common setdriverStatus:@"At Base"];
        }
    
        
    }
    else{
    }
}

-(void)sendDriverlocation:(NSTimer*) tm{
/*	if (self.latitude == (id)[NSNull null] || self.latitude.length == 0 ){
		NSLog(@"lat and long are null");
	}
	else
	{
	//NSLog(@"latitude is %@",latitude);
	//NSLog(@"longitude is %@",longitude);
	if ([Common isNetworkExist]) {
		WebServiceHelper *servicehelper=[[WebServiceHelper alloc] init];
		servicehelper.objEntity=[[[NSObject alloc]init] autorelease];
		
		NSArray *sdkeys = [NSArray arrayWithObjects:@"driverID",@"lon",@"lat", nil];
		NSArray *sdobjects = [NSArray arrayWithObjects:[NSString stringWithFormat:@"%d",[Common loggedInDriverID]],self.longitude,self.latitude, nil];
		NSDictionary *sdparams = [NSDictionary dictionaryWithObjects:sdobjects forKeys:sdkeys];
        NSString *toastString=[NSString stringWithFormat:@"lat-%@,lon-%@",self.latitude,self.longitude];
        NSLog(@"Updated location co-ordinates are:- %@",toastString);
		//dropCancelURL= dropCancelUrl+"driveravailable?"+"driverID="+userID+"&status="+"offLine";	
		NSArray *resultArray=[servicehelper callWebService:[NSString stringWithFormat:@"%@driverlocation",[Common webserviceURL]] pms:sdparams];
		NSDictionary *sucessDictionary = [resultArray objectAtIndex:0];
		NSString *sucessString=[sucessDictionary objectForKey:@"success"];
			NSLog(@"sucessString is %@",sucessString);
		if ([sucessString isEqualToString:@"true"]) {
			NSLog(@"Driver location sucessfully updated");
		}
        else{
            NSLog(@"Something went wrong in updaing driver location");
        }
		//[servicehelper release];
	}
		else{
			[self showConnectionAlert];
			// [ Common showAlert:@"Network Error" message:@"Location is not updated"];
		 }
	}*/

}

-(void)viewDidAppear:(BOOL)animated{
	
}

-(void)awakeFromNib{
}

-(void)updateLocation{
    
    	
	

	
	//[locationController.locationManager startMonitoringSignificantLocationChanges];
}

- (void)locationUpdate:(CLLocation *)location {
	
	self.latitude=[NSString stringWithFormat:@"%f", location.coordinate.latitude];
	self.longitude=[NSString stringWithFormat:@"%f", location.coordinate.longitude];    
    //////////////////////////////////////////////////////////////Sending Driver Location/////////////////////////////////////////////
    if (self.latitude == (id)[NSNull null] || self.latitude.length == 0 ){
	}
	else
	{
       
        if ([Common isNetworkExist] &&(!alertShown)) {
            //if driver has not been started or is at Base Location
            if( ![[Common driverStatus] isEqualToString:@"At Base"]){
            internetAlertShown=NO;
            [NSThread detachNewThreadSelector:@selector(sendLocation) toTarget:self withObject:nil];
            }
            //[servicehelper release];
        }
		else{
            //No Internet available
            if(!internetAlertShown){
                internetAlertShown=YES;
			[self showConnectionAlert];
            }
			// [ Common showAlert:@"Network Error" message:@"Location is not updated"];
        }
	}

	//[latitude retain];
	//[longitude retain];
}

- (void)locationError:(NSError *)error {
	//NSString *errorString=[NSString stringWithFormat:@"%@",[error description]];
	//[ALToastView toastInView:self.view withText:errorString];
}

-(IBAction)showActionSheet:(id)sender {
	UIActionSheet *availabilityActionSheet = [[UIActionSheet alloc] initWithTitle:@"Take Action" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil, nil];
	
		[availabilityActionSheet addButtonWithTitle:@"Base Waiting Table"];
        [availabilityActionSheet addButtonWithTitle:@"Cancel"];
        availabilityActionSheet.cancelButtonIndex = 1;
	
		
	[availabilityActionSheet showFromTabBar:self.tabBarController.tabBar];
	
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	//WebServiceHelper *servicehelper=[[WebServiceHelper alloc] init];
	
	if (actionSheet==acknowledgeJourneyActionSheet){
		
		if(buttonIndex == 0){
			[self takeAction:@"acknowledgeJourney"];
            [Common setdropCompleteStatus:@"journeyacknowledged"];
			}
		else if(buttonIndex == 1){
			dropRejectedAlert = [[UIAlertView alloc] initWithTitle:@"You are about to discard the Journey. Do you want to proceed?" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
			[dropRejectedAlert addButtonWithTitle:@"Yes"];
			[dropRejectedAlert addButtonWithTitle:@"No"];
			dropRejectedAlert.cancelButtonIndex = 1;
			[dropRejectedAlert show];
			alertShown=YES;
            
			//[dropRejectedAlert release];
		}
    }
	else {
			if ([Common isNetworkExist]>0)
			{
                if(buttonIndex == 0){
                    DriverWaitingDetails *driverWaitingDetails=[[DriverWaitingDetails alloc]init];
                    UINavigationController* navController = [[UINavigationController alloc] initWithRootViewController:driverWaitingDetails];
                    
                    float rd = 4.00/255.00;
                    float gr = 152.00/255.00;
                    float bl = 229.00/255.00;
                    navController.navigationBar.tintColor =[UIColor colorWithRed:rd green:gr blue:bl alpha:1.0];

                    [self.navigationController presentModalViewController:navController animated:YES];
                    [navController release];
                    [driverWaitingDetails release];
            }
                 }
			else {
				[self showConnectionAlert];
				//[Common showConnectionAlert];
			}
			
           
      
            
           
            
            
            //[self.navigationController presentModalViewController:driverWaitingDetails animated:YES];
            
    }
		
	
}

-(void) JourneyAction: (NSString *)actionType {
	WebServiceHelper *servicehelper=[[WebServiceHelper alloc] init];
	servicehelper.objEntity=[[[NSObject alloc]init] autorelease];
	
	   
	AllocatedJourney *jny=[newJourneysArray objectAtIndex:0];
    
    if(![jny.baseName isEqualToString:@""] && [actionType isEqualToString:@"acknowledgeJourney"]){
        actionType=@"onBoard";
    }
	
	NSArray *sdkeys = [NSArray arrayWithObjects:@"uid",@"type",@"aj_id",@"suppID",@"destination", nil];
	NSArray *sdobjects = [NSArray arrayWithObjects:[NSString stringWithFormat:@"%ld",(long)[Common loggedInDriverID]],actionType,[NSString stringWithFormat:@"%ld",(long)jny.AllocatedJourneyID],[NSString stringWithFormat:@"%ld",(long)jny.suppID],@"", nil];
	
	//NSArray *sdobjects = [NSArray arrayWithObjects:[NSString stringWithFormat:@"%d",[Common loggedInDriverID]],actionType,[NSString stringWithFormat:@"%d",selectedJourney.AllocatedJourneyID],[NSString stringWithFormat:@"%d",selectedJourney.suppID],destination, nil];
	NSDictionary *sdparams = [NSDictionary dictionaryWithObjects:sdobjects forKeys:sdkeys];
	NSString *URL=[NSString stringWithFormat:@"%@driveroptions",[Common webserviceURL]];
	
	NSArray *resultArray=[servicehelper callWebService:URL pms:sdparams];
	//[servicehelper release];
	NSDictionary *sucessDictionary = [resultArray objectAtIndex:0];
	NSString *sucessString=[sucessDictionary objectForKey:@"success"];
	
	/////////////    Reloading tableView      /////////////////////	
	//if(reloadTableView){
	//	[self.mainTableView reloadData];
	//}
	
	/////////////    Checking success, is true      /////////////////////
 	if ([sucessString isEqualToString:@"true"]) {	
		if ([actionType isEqualToString:@"acknowledgeJourney"] || [actionType isEqualToString:@"onBoard"]) {
			journeyAcknowledged=YES;
            int noOfpastJourney=[Common noOfPastJourneys];
            [Common setNoOfPastJourneys:noOfpastJourney+1];
			[ALToastView toastInView:self.view withText:@"Thanks for acknowledging journey."];
			
		}
		else if ([actionType isEqualToString:@"rejectJourney"]) {
			//[self.navigationController popViewControllerAnimated:YES];
		}
        
        
        [self performSelector:@selector(updatejourney) withObject:nil afterDelay:0];

	}
}

-(void) takeAction: (NSString *)actionType {
	WebServiceHelper *servicehelper=[[WebServiceHelper alloc] init];
	servicehelper.objEntity=[[[NSObject alloc]init] autorelease];
	
	if(![selectJourney.baseName isEqualToString:@""] && [actionType isEqualToString:@"acknowledgeJourney"]){
        actionType=@"onBoard";
    }

	NSArray *sdkeys = [NSArray arrayWithObjects:@"uid",@"type",@"aj_id",@"suppID",@"destination", nil];
	NSArray *sdobjects = [NSArray arrayWithObjects:[NSString stringWithFormat:@"%ld",(long)[Common loggedInDriverID]],actionType,[NSString stringWithFormat:@"%ld",(long)selectJourney.AllocatedJourneyID],[NSString stringWithFormat:@"%ld",(long)selectJourney.suppID],@"", nil];
	
	//NSArray *sdobjects = [NSArray arrayWithObjects:[NSString stringWithFormat:@"%d",[Common loggedInDriverID]],actionType,[NSString stringWithFormat:@"%d",selectedJourney.AllocatedJourneyID],[NSString stringWithFormat:@"%d",selectedJourney.suppID],destination, nil];
	NSDictionary *sdparams = [NSDictionary dictionaryWithObjects:sdobjects forKeys:sdkeys];
	NSString *URL=[NSString stringWithFormat:@"%@driveroptions",[Common webserviceURL]];
	
	NSArray *resultArray=[servicehelper callWebService:URL pms:sdparams];
	[servicehelper release];
	NSDictionary *sucessDictionary = [resultArray objectAtIndex:0];
	NSString *sucessString=[sucessDictionary objectForKey:@"success"];
	
	
/////////////    Reloading tableView      /////////////////////	
	if(reloadTableView){
	[self.mainTableView reloadData];
	}
	
/////////////    Checking success, is true      /////////////////////
 	if ([sucessString isEqualToString:@"true"]) {
        int noOfpastJourney=[Common noOfPastJourneys];

		if ([actionType isEqualToString:@"acknowledgeJourney"] || [actionType isEqualToString:@"onBoard"] ) {
			journeyAcknowledged=YES;
            [Common setNoOfPastJourneys:noOfpastJourney+1];
			[ALToastView toastInView:self.view withText:@"Thanks for acknowledging journey."];
					}
		else if ([actionType isEqualToString:@"rejectJourney"]) {
            //[Common setNoOfPastJourneys:noOfpastJourney-1];
			
		}
		[self performSelector:@selector(updatejourney) withObject:nil afterDelay:0];

	}
}

-(void) updateStatus: (NSString *)actionType {
	WebServiceHelper *servicehelper=[[WebServiceHelper alloc] init];
	servicehelper.objEntity=[[[NSObject alloc]init] autorelease];	NSArray *sdkeys = [NSArray arrayWithObjects:@"driverID",@"status", nil];
	NSArray *sdobjects = [NSArray arrayWithObjects:[NSString stringWithFormat:@"%ld",(long)[Common loggedInDriverID]],actionType, nil];
	NSDictionary *sdparams = [NSDictionary dictionaryWithObjects:sdobjects forKeys:sdkeys];
	//dropCancelURL= dropCancelUrl+"driveravailable?"+"driverID="+userID+"&status="+"offLine";	
	NSArray *resultArray=[servicehelper callWebService:[NSString stringWithFormat:@"%@driveravailable",[Common webserviceURL]] pms:sdparams];
	NSDictionary *sucessDictionary = [resultArray objectAtIndex:0];
	NSString *sucessString=[sucessDictionary objectForKey:@"success"];
	if ([sucessString isEqualToString:@"true"]) {
		[Common setdropCompleteStatus:@"No"];
		[Common setdriverStatus:@"At Base"];
		//if ([actionType isEqualToString:@"offLine"]) {
			[ALToastView toastInView:self.view withText:@"You are at base. "];
			
			//
		//}
		//else {
		//	[Common setdriverStatus:@"At Base"];
			//[ALToastView toastInView:self.view withText:@"You are Online. "];
			
		//}
	}
	

	[servicehelper release];}


-(BOOL)getExpiryDetails{
     WebServiceHelper *servicehelper=[[WebServiceHelper alloc] init];
     docExpired=NO;
    NSArray *sdkeys = [NSArray arrayWithObjects:@"id", nil];
    NSArray *sdobjects = [NSArray arrayWithObjects:[NSString stringWithFormat:@"%ld",(long)[Common loggedInDriverID]], nil];
    NSDictionary *sdparams = [NSDictionary dictionaryWithObjects:sdobjects forKeys:sdkeys];
    NSString *expirationURL=@"";
    expirationURL= [NSString stringWithFormat:@"%@expiredetail",[Common webserviceURL]];
    NSArray *tempArray=[servicehelper callWebService:expirationURL pms:sdparams];
    NSDictionary *expirationDict=[tempArray objectAtIndex:0];
    
    if([[expirationDict objectForKey:@"success"] boolValue])
    {
        expiryMessage=@"";
        NSInteger expiryNo=0;
        NSInteger driverPCO=[[expirationDict objectForKey:@"Driver_PCO"] intValue];
        NSInteger cabPCO=[[expirationDict objectForKey:@"Cab_PCO"] intValue];
        NSInteger cabMOT=[[expirationDict objectForKey:@"Cab_MOT"] intValue];
        NSInteger cabINS=[[expirationDict objectForKey:@"Cab_INS"] intValue];
        if (driverPCO>2 && cabPCO>2 && cabMOT>2  && cabINS>2 ) {
        }
        else{
            //driverPCO=21;
           // cabMOT=21;
           // cabINS=11;
           // cabPCO=10;
            if(driverPCO==-1){
                expiryNo=expiryNo+1;
                docExpired=YES;
                self.expiryMessage=[NSString stringWithFormat:@"%@%ld. Driver PCO has expired.\n",self.expiryMessage,(long)expiryNo];
            }
            else if (driverPCO>0 && driverPCO<3){
                expiryNo=expiryNo+1;
                self.expiryMessage=[NSString stringWithFormat:@"%@%ld. Driver PCO is going to expire in %ld days.\n",self.expiryMessage,(long)expiryNo,(driverPCO+1)];
            }
            ////
            if(cabPCO==-1){
                docExpired=YES;
                expiryNo=expiryNo+1;
                self.expiryMessage=[NSString stringWithFormat:@"%@%ld. Vehicle PCO has expired.\n",self.expiryMessage,(long)expiryNo];
            }
            else if (cabPCO>0 && cabPCO<3){
                expiryNo=expiryNo+1;
                self.expiryMessage=[NSString stringWithFormat:@"%@%ld. Vehicle PCO is going to expire in %ld days.\n",self.expiryMessage,(long)expiryNo,(cabPCO+1)];
            }
            ////
            if(cabMOT==-1){
                expiryNo=expiryNo+1;
                docExpired=YES;
                self.expiryMessage=[NSString stringWithFormat:@"%@%ld. Vehicle MOT has expired.\n",self.expiryMessage,(long)expiryNo];
            }
            else if (cabMOT>0 && cabMOT<3){
                expiryNo=expiryNo+1;
                self.expiryMessage=[NSString stringWithFormat:@"%@%ld. Vehicle MOT is going to expire in %ld days.\n",self.expiryMessage,(long)expiryNo,(cabMOT+1)];
            }
            ////
            if(cabINS==-1){
                expiryNo=expiryNo+1;
                docExpired=YES;
                self.expiryMessage=[NSString stringWithFormat:@"%@%ld. Vehicle Insurance has expired.\n",self.expiryMessage,(long)expiryNo];
            }
            else if (cabINS>0 && cabINS<3){
                expiryNo=expiryNo+1;
                self.expiryMessage=[NSString stringWithFormat:@"%@%ld. Vehicle Insurance is going to expire in %ld days.",self.expiryMessage,(long)expiryNo,(cabINS+1)];
            }
            
            
        }
    }
    /////////////////////////////////////Setting Final expiry Message///////////////////////////////
    if(![self.expiryMessage isEqualToString:@""]){
        
        if (docExpired) {
            self.expiryMessage=[NSString stringWithFormat:@"%@ \nAs one or more document has expired, you will be logged out. Renew your documents to use WiseDriver again.",self.expiryMessage];
        }
        else{
            self.expiryMessage=[NSString stringWithFormat:@"%@ \nPlease renew these documents before it expires.",self.expiryMessage];
        }
    
        
    }
    
        
    return docExpired;
}


////////////////////Showing Expiration Alert //////////////////////////
-(void)showExpirationAlert{
    expirationAlert = [[UIAlertView alloc] initWithTitle:@"Document Expiration Alert" message:self.expiryMessage delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
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

-(void)getJourney{
    BOOL isSucess=NO;
    WebServiceHelper *servicehelper=[[WebServiceHelper alloc] init];
    
    if ((dateChanged) && [[self tabName] isEqualToString:@"Scheduled Jobs"] &&(!cameFromLoginPage)) {
        docExpired=NO;
        NSArray *sdkeys = [NSArray arrayWithObjects:@"id", nil];
        NSArray *sdobjects = [NSArray arrayWithObjects:[NSString stringWithFormat:@"%ld",(long)[Common loggedInDriverID]], nil];
        NSDictionary *sdparams = [NSDictionary dictionaryWithObjects:sdobjects forKeys:sdkeys];
        NSString *expirationURL=@"";
        expirationURL= [NSString stringWithFormat:@"%@expiredetail",[Common webserviceURL]];
        NSArray *tempArray=[servicehelper callWebService:expirationURL pms:sdparams];
        NSDictionary *expirationDict=[tempArray objectAtIndex:0];
        
        if([[expirationDict objectForKey:@"success"] boolValue])
        {
            dateChanged=NO;
            expiryMessage=@"";
            NSInteger expiryNo=0;
            NSInteger driverPCO=[[expirationDict objectForKey:@"Driver_PCO"] intValue];
            NSInteger cabPCO=[[expirationDict objectForKey:@"Cab_PCO"] intValue];
            NSInteger cabMOT=[[expirationDict objectForKey:@"Cab_MOT"] intValue];
            NSInteger cabINS=[[expirationDict objectForKey:@"Cab_INS"] intValue];
            if (driverPCO>3 && cabPCO>3 && cabMOT>3  && cabINS>3 ) {
            }
            else{
                //driverPCO=21;
                // cabMOT=21;
                // cabINS=11;
                // cabPCO=10;
                if(driverPCO==-1){
                    expiryNo=expiryNo+1;
                    docExpired=YES;
                    self.expiryMessage=[NSString stringWithFormat:@"%@%ld. Driver_PCO has expired.\n",self.expiryMessage,(long)expiryNo];
                }
                else if (driverPCO>=0 && driverPCO<3){
                    expiryNo=expiryNo+1;
                    self.expiryMessage=[NSString stringWithFormat:@"%@%ld. Driver_PCO is going to expire in %ld days.\n",self.expiryMessage,(long)expiryNo,(long)(driverPCO+1)];
                }
                ////
                if(cabPCO==-1){
                    docExpired=YES;
                    expiryNo=expiryNo+1;
                    self.expiryMessage=[NSString stringWithFormat:@"%@%ld. Cab_PCO has expired.\n",self.expiryMessage,(long)expiryNo];
                }
                else if (cabPCO>=0 && cabPCO<3){
                    expiryNo=expiryNo+1;
                    self.expiryMessage=[NSString stringWithFormat:@"%@%ld. Cab_PCO is going to expire in %ld days.\n",self.expiryMessage,(long)expiryNo,(long)(cabPCO+1)];
                }
                ////
                if(cabMOT==-1){
                    expiryNo=expiryNo+1;
                    docExpired=YES;
                    self.expiryMessage=[NSString stringWithFormat:@"%@%ld. Cab_MOT has expired.\n",self.expiryMessage,(long)expiryNo];
                }
                else if (cabMOT>=0 && cabMOT<3){
                    expiryNo=expiryNo+1;
                    self.expiryMessage=[NSString stringWithFormat:@"%@%ld. Cab_MOT is going to expire in %ld days.\n",self.expiryMessage,(long)expiryNo,(long)(cabMOT+1)];
                }
                ////
                if(cabINS==-1){
                    expiryNo=expiryNo+1;
                    docExpired=YES;
                    self.expiryMessage=[NSString stringWithFormat:@"%@%ld. Cab_INS has expired.\n",self.expiryMessage,(long)expiryNo];
                }
                else if (cabINS>=0 && cabINS<3){
                    expiryNo=expiryNo+1;
                    self.expiryMessage=[NSString stringWithFormat:@"%@%ld. Cab_INS is going to expire in %ld days.",self.expiryMessage,(long)expiryNo,(long)(cabINS+1)];
                }
                
                
            }
        }
        /////////////////////////////////////Setting Final expiry Message///////////////////////////////
        if(![self.expiryMessage isEqualToString:@""]){
            
            if (docExpired) {
                self.expiryMessage=[NSString stringWithFormat:@"%@ \nAs one or more document has expired, you will be logged out. Renew your documents to use WiseDriver again.",self.expiryMessage];
            }
            else{
                self.expiryMessage=[NSString stringWithFormat:@"%@ \nPlease renew these documents before it expires.",self.expiryMessage];
                [self performSelectorOnMainThread:@selector(showExpirationAlert) withObject:nil waitUntilDone:NO];
            }
            
            
        }
        
        isSucess=docExpired;
    }
    
        
        
   
    if (!isSucess) {
    
    
    
	if([self tabName]==@"Scheduled Jobs"){
		isRefreshingScheduled=YES;
	}
	else {
		isRefreshingCompleted=YES;
	}

		
		self.cameFromLoginPage=NO;
		AllocatedJourney *jny=[[AllocatedJourney alloc]init];
		servicehelper.objEntity=jny;
		NSArray *sdkeys = [NSArray arrayWithObjects:@"uid", nil];
		NSArray *sdobjects = [NSArray arrayWithObjects:[NSString stringWithFormat:@"%ld",(long)[Common loggedInDriverID]], nil];
		NSDictionary *sdparams = [NSDictionary dictionaryWithObjects:sdobjects forKeys:sdkeys];
		NSString *journeyURL=@"";
		
		if([self tabName]==@"Scheduled Jobs")
		{
			journeyURL= [NSString stringWithFormat:@"%@driverscheduled",[Common webserviceURL]];
		}else {
			journeyURL=[NSString stringWithFormat:@"%@drivercompleted",[Common webserviceURL]];
		}
		//
		self.travelarray=nil;
		[self.travelarray release];
		NSArray *tempArray=[servicehelper callWebService:journeyURL pms:sdparams];
		
	int j=0;
				
		travelarray=[[NSMutableArray alloc] init];
		todayTravelDetails=[[NSMutableArray alloc] init];
		tomorrowTravelDetails=[[NSMutableArray alloc] init];
		newJourneysArray=[[NSMutableArray alloc] init];
		
		
	
	

////////////////////////////////.....checking if new jny is allocated to Driver........./////////////////
        NSLog(@"No Of Past Journey %ld",(long)[Common noOfPastJourneys]);
		if ([Common noOfPastJourneys] < [tempArray count] && [self tabName]==@"Scheduled Jobs" ) {
			if (!firstTime) {
				
				
				NSString* path = [[NSBundle mainBundle] pathForResource:@"beep" ofType:@"caf"];
				NSURL * afUrl = [NSURL fileURLWithPath:path];
				UInt32 soundID;
				AudioServicesCreateSystemSoundID((CFURLRef)afUrl,&soundID);
				AudioServicesPlaySystemSound (soundID);
				//NSInteger noOfNewJourneys=[tempArray
			}
			else {
                
			}

			
			
		}
	if([self tabName]==@"Scheduled Jobs" ) {
		
	}
		if  ([self tabName]==@"Completed Jobs") {
			NSSortDescriptor *dateDescriptor = [[[NSSortDescriptor alloc] initWithKey:@"jnyDate"  ascending:NO] autorelease];
            NSSortDescriptor *timeDescriptor = [[[NSSortDescriptor alloc] initWithKey:@"jnyTime"  ascending:YES] autorelease];
            
			NSArray *sortDescriptors = [NSArray arrayWithObjects:dateDescriptor,timeDescriptor, nil];
			if ([tempArray count]>0) {
				self.travelarray= [tempArray sortedArrayUsingDescriptors:sortDescriptors];
				
			}
			
		}
		else {
			NSSortDescriptor *dateDescriptor = [[[NSSortDescriptor alloc] initWithKey:@"jnyDate"  ascending:YES] autorelease];
            NSSortDescriptor *timeDescriptor = [[[NSSortDescriptor alloc] initWithKey:@"jnyTime"  ascending:YES] autorelease];
            
			NSArray *sortDescriptors = [NSArray arrayWithObjects:timeDescriptor,dateDescriptor, nil];
			if ([tempArray count]>0) {
				self.travelarray= [tempArray sortedArrayUsingDescriptors:sortDescriptors];
				
			}
			
		}

				
		
		
		firstTime=NO;
		
		
		
		groupedArray=nil;
		if ([self.travelarray count]!=0) {
			self.todayTravelDetails=[self.travelarray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(JourneyDate == %@)", todayDate]];
			
			
			self.jnyDict= [[[NSMutableDictionary alloc] init] autorelease];
			NSString *date;
			self.uniqueArray= [NSMutableArray array];
			NSMutableSet * mutableSet = [NSMutableSet set];
			for (AllocatedJourney * jny in travelarray) {
				date=jny.JourneyDate;
				[jnyDict setObject:jny forKey:date];
				
				if ([mutableSet containsObject:date] == NO) {
					[self.uniqueArray addObject:jny];
					[mutableSet addObject:date];
				}
			}
			
			NSArray *allArray;
			self.groupedArray=[[[NSMutableArray alloc] init] autorelease];
			for ( int i=0; i<=[uniqueArray count]-1; i++) {
				allArray=[NSString stringWithFormat:@"allArray%i",i];
				AllocatedJourney *jny=[uniqueArray objectAtIndex:i];
				NSString *jnyDate=jny.JourneyDate;
				allArray=[self.travelarray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(JourneyDate == %@)", jnyDate]];
				[self.groupedArray addObject:allArray];
			}
			
			
			
			
			//Tommorow'S Travel Details
			self.tomorrowTravelDetails=[self.travelarray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(JourneyDate == %@)", tomorrowDate]];
			//[self.todayTravelDetails retain];
			//[self.tomorrowTravelDetails retain];
			//[self.travelarray retain];
			[jny release];
			//[allJourney release];
			[servicehelper release];
			
		}
		else {
			self.todayTravelDetails=nil;
			self.tomorrowTravelDetails=nil;
		}

		
		
		
	if([self tabName]==@"Scheduled Jobs"){
		isRefreshingScheduled=NO;
        //int numberOfJourneys=0;
        for (int i=1; i<=[self.travelarray count]; i++) {
            j=j+1;
           // numberOfJourneys=+1;
            [Common setNoOfPastJourneys:i];
            
            AllocatedJourney *journey=[self.travelarray objectAtIndex:i-1];
            if (([journey.hiddenJny isEqualToString:@"Yes"]) && ([journey.JourneyStatus isEqualToString:@"unAcknowledged"])) {
                
                [newJourneysArray addObject:journey];
                
            }
            
        }
	}
	else {
		isRefreshingCompleted=NO;
	}
	//newJourneysArray=nil;
	
	
	
	
/////////////////////Checking new jnys and adding it to new NSMutableArray////////////////////////	
	
	
	if ([newJourneysArray count]>0) {
       // dispatch_async(dispatch_get_main_queue(), ^{
            newJnyAlert = [[UIAlertView alloc] initWithTitle:@"New Journey" message:@"A new journey has been assigned to you." delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
            [newJnyAlert addButtonWithTitle:@"Accept "];
            [newJnyAlert addButtonWithTitle:@"Reject"];
            [Common setNoOfPastJourneys:[Common noOfPastJourneys]-1];
            newJnyAlert.cancelButtonIndex = 1;
            newJourneyNo=newJourneyNo+1;
            [self.newJnyAlert performSelector:@selector(show) onThread:[NSThread mainThread] withObject:nil waitUntilDone:NO];
           // [newJnyAlert show];
            alertShown=YES;
       // });
			
	}
	else {
		[self.mainTableView reloadData];
	}
	
	}
    else{
        [self performSelectorOnMainThread:@selector(showExpirationAlert) withObject:nil waitUntilDone:NO];

    }
    NSLog(@"no of past journey in newJourneysArray is %ld",(long)[Common noOfPastJourneys]);
    
    [self locationUpdate:[locationController.locationManager location]];
}


-(void)showUpdate:(NSString*)lable detailtext:(NSString*)detailsText
{
	if ([Common isNetworkExist] ) {
	HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
	[self.navigationController.view addSubview:HUD];
	
	HUD.delegate = self;
	HUD.labelText = lable;
	HUD.detailsLabelText = detailsText;
	HUD.square = YES;
	internetAlertShown=NO;
	[HUD showWhileExecuting:@selector(getJourney) onTarget:self withObject:nil animated:YES];
	}
	else {
    
        if(!internetAlertShown){
            internetAlertShown=YES;
		[self showConnectionAlert];
        }
		//[Common showConnectionAlert];
	}

	//[self.mainTableView reloadData];
}

-(IBAction)showLogoutPage:(id)sender {
	
	logoutAlert = [[UIAlertView alloc] initWithTitle:@"Are you sure?" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
	[logoutAlert addButtonWithTitle:@"Yes"];
	[logoutAlert addButtonWithTitle:@"No"];
	logoutAlert.cancelButtonIndex = 1;
	[logoutAlert show];
	alertShown=YES;
	//[logoutAlert release];
}




- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView==expirationAlert) {
    if (docExpired) {
        
        if ([Common isNetworkExist]>0)
        {
            
            [Common setUserId:nil];
            [Common setPassword:nil];
            //[self.navigationController popToRootViewControllerAnimated:YES];
            driverAppAppDelegate *appDelegate = (driverAppAppDelegate *)[[UIApplication sharedApplication] delegate];
            [self.tabBarController.view removeFromSuperview];
            [UIApplication sharedApplication].idleTimerDisabled = NO;
            [appDelegate loadTabBarController];
            isLoggedIn=NO;
            alertShown=NO;
            /*if(driverTimer!=nil){
             [driverTimer invalidate];
             driverTimer=nil;
             }*/
            [[NSNotificationCenter defaultCenter] removeObserver:self];
            
            //isNetworkAlertShowing=YES;
            [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
            [locationController.locationManager stopUpdatingLocation];
            //NSUInteger viewControllerCount = self.navigationController.viewControllers.count;
        }
        else {
            [self showConnectionAlert];
            //[Common showConnectionAlert];
        }

    }
    }
	//alertShown=NO;
    if (alertView==networkAlert) {
        if (buttonIndex==0) {
        alertShown=NO;
        }
    }
	if (alertView==logoutAlert) {
		if (buttonIndex==0) {
			if ([Common isNetworkExist]>0)
			{
				
				[Common setUserId:nil];
				[Common setPassword:nil];
				//[self.navigationController popToRootViewControllerAnimated:YES];
				driverAppAppDelegate *appDelegate = (driverAppAppDelegate *)[[UIApplication sharedApplication] delegate];
				[self.tabBarController.view removeFromSuperview];
                [UIApplication sharedApplication].idleTimerDisabled = NO;
				[appDelegate loadTabBarController];
				isLoggedIn=NO;
                alertShown=NO;
				/*if(driverTimer!=nil){
					[driverTimer invalidate];
					driverTimer=nil;
				}*/
                [[NSNotificationCenter defaultCenter] removeObserver:self];
				
				//isNetworkAlertShowing=YES;
                [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
				[locationController.locationManager stopUpdatingLocation];
				//NSUInteger viewControllerCount = self.navigationController.viewControllers.count;
			}
			else {
				[self showConnectionAlert];
				//[Common showConnectionAlert];
			}
		}
	
	}
	
	if (alertView==networkAlert) {
		if (buttonIndex==0) {
			alertShown=NO;
			//isNetworkAlertShowing=NO;
		}
	}
	
	if (alertView==dropRejectedAlert) {
        alertShown=NO;
		if (buttonIndex==0) {
            if([nonProtected isEqualToString:@"Yes"]){
                [self takeAction:@"rejectJourney"];
            }
            else{
                [self JourneyAction:@"rejectJourney"];
            }
			
            
			//[self.navigationController popViewControllerAnimated:YES];
		}
        else{
            [self performSelector:@selector(updatejourney) withObject:nil afterDelay:0];
        }
	}
		
	if (alertView==newJnyAlert) {
		//AllocatedJourney *jny=[newJourneysArray objectAtIndex:newJourneyNo];
		if (buttonIndex==0) {
			newJourneyNo=newJourneyNo+1;
			[self JourneyAction:@"acknowledgeJourney"];
            alertShown=NO;
			/*if ((newJourneyNo+1) <= [newJourneysArray count]) {
				newJnyAlert = [[UIAlertView alloc] initWithTitle:@"New Journey" message:@"A new journey has been assigned to you." delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
				[newJnyAlert addButtonWithTitle:@"Accept"];
				[newJnyAlert addButtonWithTitle:@"Reject"];
				newJnyAlert.cancelButtonIndex = 1;
				[newJnyAlert show];
				
				alertShown=YES;	
			}
			else {
				[self.mainTableView reloadData];
			}*/

		}
			if (buttonIndex==1) {
				dropRejectedAlert = [[UIAlertView alloc] initWithTitle:@"You are about to discard the Journey. Do you want to proceed?" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
				[dropRejectedAlert addButtonWithTitle:@"Yes"];
				[dropRejectedAlert addButtonWithTitle:@"No"];
				dropRejectedAlert.cancelButtonIndex = 1;
				[dropRejectedAlert show];
				alertShown=YES;
				//[dropRejectedAlert release];
				//[self takeAction:@"rejectJourney"];
				//[self.navigationController popViewControllerAnimated:YES];
			}
	}
    
    //alertShown=NO;
	
}
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.

-(void)updatejourney{
	if(isLoggedIn){
		[self showUpdate:@"Updating" detailtext:@"Updating Journey"];
	
		
       
	}
}	

-(void)referenceTime
{
}

-(void)onTick:(NSTimer*) tm
{
     if (!docExpired) {
	if (!alertShown) {
		[self showUpdate:@"Updating" detailtext:@"Updating Journey"];
	}
     }
	
}
- (void) onSegmentedControlChanged:(UISegmentedControl *) sender {
    
	[self.mainTableView reloadData];
	
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
	if (segmentControl.selectedSegmentIndex == 2 || ([self tabName]==@"Completed Jobs") ){
		
		if ([uniqueArray count]==0) {
			return 1;
		}
		else {
			return [uniqueArray count];
		}

	}
	else {
		return 1;
	}

	
	
	
}



- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	NSString *headerTitle;
	if (segmentControl.selectedSegmentIndex == 0){
		headerTitle=todayDate;
		
	}
	else if (segmentControl.selectedSegmentIndex == 1){
		headerTitle=tomorrowDate;
	}
	else {
		if ([travelarray count]==0) {
			headerTitle=@"  ";
		}
		else {
			AllocatedJourney *journey=[uniqueArray objectAtIndex:section];
			headerTitle=journey.JourneyDate;
		}

		
		
	}
	return headerTitle;
		
}



-(void)showConnectionAlert{
	if (!alertShown) {
        alertShown=YES;
		networkAlert = [[UIAlertView alloc] initWithTitle:@"No Internet Available" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
		[networkAlert addButtonWithTitle:@"Ok"];
		networkAlert.cancelButtonIndex = 1;
		[networkAlert show];
		
		//isNetworkAlertShowing=YES;
	}
	else {
	}

	
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
	//return([travelarray count]);
	if ([self tabName]==@"Scheduled Jobs") {
		
		if (segmentControl.selectedSegmentIndex == 0)
		{
			return ([todayTravelDetails count]);
			
		}
		if (segmentControl.selectedSegmentIndex == 1)
		{
			return ([tomorrowTravelDetails count]);
		}
		if (segmentControl.selectedSegmentIndex == 2)
		{
			return [[groupedArray objectAtIndex:section] count];
		}
	}
	
	return [[groupedArray objectAtIndex:section] count];
}


// Customize the appearance of table view cells.

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	static NSString *CellIdentifier = @"Cell";	
	TableViewCell *cell = (TableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
	if(cell==nil){
		NSArray *toplevelObjects=[[NSBundle mainBundle] loadNibNamed:@"TableViewCell" owner:nil options:nil];
		
		
		for(id currentObject in toplevelObjects){
			
			if([currentObject isKindOfClass:[UITableViewCell class]]){
				cell=(TableViewCell *) currentObject;
				
				AllocatedJourney *journey=nil;	
				if (isScheduled) {
					
					if (segmentControl.selectedSegmentIndex == 0)
					{
						journey=[todayTravelDetails objectAtIndex:[indexPath row]];
					}
					
					else if (segmentControl.selectedSegmentIndex == 1)
					{
						journey=[tomorrowTravelDetails objectAtIndex:[indexPath row]];
					}
					
					else if (segmentControl.selectedSegmentIndex == 2)
					{
						NSArray *jny=[groupedArray objectAtIndex:indexPath.section];
						journey=[jny objectAtIndex:indexPath.row];						
						//journey=[travelarray objectAtIndex:[indexPath row]];
					}
				}	
				else 
				{
					NSArray *jny=[groupedArray objectAtIndex:indexPath.section];
					journey=[jny objectAtIndex:indexPath.row];						
					//journey=[travelarray objectAtIndex:[indexPath row]];
				}
				if(journey !=nil)
				{
					/*if (([journey.hiddenJny isEqualToString:@"Yes"]) && ([journey.JourneyStatus isEqualToString:@"unAcknowledged"])   &&  ([self tabName]==@"Scheduled Jobs")) {
						newJnyAlert = [[UIAlertView alloc] initWithTitle:@"New Journey" message:@"A new journey has been assigned to you." delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
						[newJnyAlert addButtonWithTitle:@"Accept"];
						[newJnyAlert addButtonWithTitle:@"Reject"];
						newJnyAlert.cancelButtonIndex = 1;
						[newJnyAlert show];
					}*/
					
					
					NSString *CapitalTime=[journey.JourneyTime uppercaseString];
					cell.timeLabel.text=[NSString stringWithFormat:@"%@",CapitalTime];
					cell.fromAddress.text=[NSString stringWithFormat:@"%@",journey.FromAddress];	
					
					
					
						cell.toAddress.text=journey.ToAddress;
					
					
					NSInteger fareValue = journey.JourneyFare;
					cell.fare.text=[NSString stringWithFormat:@"%@ %ld", journey.Currency,(long)fareValue];
					cell.accessoryType=UITableViewCellAccessoryDetailDisclosureButton;
					//[cell setAccessoryAction:@selector(referenceTime)];
					//[cell setTarget:self];
					
					//[address release];
				}
				
				if (journey.IsTelephonicJourney) {
					UIImage *myImage = [UIImage imageNamed:@"telephonic.png"];
					UIImageView *imgView = [[UIImageView alloc] initWithImage:myImage];
					
					[cell setBackgroundView:imgView];				
					[imgView release];
				}
				else {
					UIImage *myImage = [UIImage imageNamed:@"tableViewCellBackground.png"];
					UIImageView *imgView = [[UIImageView alloc] initWithImage:myImage];
					
					[cell setBackgroundView:imgView];				
					[imgView release];
				}
				
				
				
					
				break;
			
            }
			
		}
		
	}
	
	return cell;
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
	
	if ([Common isNetworkExist]>0)
	{
				
		
		ScheduleTravelDetails *scheduleTravelDetails = [[ScheduleTravelDetails alloc] init];
	    scheduleTravelDetails.isScheduled=self.isScheduled;
		self.navigationItem.backBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil] autorelease];
		if (isScheduled) {
			if (segmentControl.selectedSegmentIndex == 0)
			{
				scheduleTravelDetails.selectedJourney=[todayTravelDetails objectAtIndex:indexPath.row];
			}
			if (segmentControl.selectedSegmentIndex == 1)
			{
				scheduleTravelDetails.selectedJourney=[tomorrowTravelDetails objectAtIndex:indexPath.row];
			}
			if (segmentControl.selectedSegmentIndex == 2 || ([self tabName]==@"Completed Jobs"))
			{
				NSArray *jny=[groupedArray objectAtIndex:indexPath.section];
				scheduleTravelDetails.selectedJourney=[jny objectAtIndex:indexPath.row];
			}
		}
		else {
			NSArray *jny=[groupedArray objectAtIndex:indexPath.section];
			scheduleTravelDetails.selectedJourney=[jny objectAtIndex:indexPath.row];		
			}
		selectJourney=scheduleTravelDetails.selectedJourney;
		if (([scheduleTravelDetails.selectedJourney.JourneyStatus isEqualToString:@"unAcknowledged"]) &&  ([self tabName]==@"Scheduled Jobs") ) {
			acknowledgeJourneyActionSheet = [[UIActionSheet alloc] initWithTitle:@"Take Action" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil, nil];
			[acknowledgeJourneyActionSheet addButtonWithTitle:@"Accept Journey"];
			[acknowledgeJourneyActionSheet addButtonWithTitle:@"Reject Journey"];
			[acknowledgeJourneyActionSheet addButtonWithTitle:@"Cancel"];
            nonProtected=@"Yes";
			acknowledgeJourneyActionSheet.cancelButtonIndex = 2;
			[acknowledgeJourneyActionSheet showFromTabBar:self.tabBarController.tabBar];
			
		}
		else {
			//journeyAcknowledged=NO;
			if([self tabName]==@"Scheduled Jobs")
				scheduleTravelDetails.journeyType=@"Scheduled Jobs";
			else {
				scheduleTravelDetails.journeyType=@"Completed Jobs";
			}
			scheduleTravelDetails.destination=scheduleTravelDetails.selectedJourney.ToAddress;
			scheduleTravelDetails.originAddress=scheduleTravelDetails.selectedJourney.FromAddress;
			scheduleTravelDetails.totalPassenger=[NSString stringWithFormat:@"%li", (long)scheduleTravelDetails.selectedJourney.TotalNumberOfPassenger];
			scheduleTravelDetails.totalFare=[NSString stringWithFormat:@"%li", (long)scheduleTravelDetails.selectedJourney.JourneyFare];
			[self.navigationController pushViewController:scheduleTravelDetails animated:YES];
			[tableView deselectRowAtIndexPath:indexPath animated:YES];
			[scheduleTravelDetails autorelease];
		}
		
	}else {
		[self showConnectionAlert];
		//[Common showConnectionAlert];
	}
	
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	if ([Common isNetworkExist]>0)
	{
		
		
		ScheduleTravelDetails *scheduleTravelDetails = [[ScheduleTravelDetails alloc] init];
	    scheduleTravelDetails.isScheduled=self.isScheduled;
		self.navigationItem.backBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil] autorelease];
		if (isScheduled) {
			if (segmentControl.selectedSegmentIndex == 0)
			{
				scheduleTravelDetails.selectedJourney=[todayTravelDetails objectAtIndex:indexPath.row];
			}
			if (segmentControl.selectedSegmentIndex == 1)
			{
				scheduleTravelDetails.selectedJourney=[tomorrowTravelDetails objectAtIndex:indexPath.row];
			}
			if (segmentControl.selectedSegmentIndex == 2 || ([self tabName]==@"Completed Jobs"))
			{
				NSArray *jny=[groupedArray objectAtIndex:indexPath.section];
				scheduleTravelDetails.selectedJourney=[jny objectAtIndex:indexPath.row];
			}
		}
		else {
			NSArray *jny=[groupedArray objectAtIndex:indexPath.section];
			scheduleTravelDetails.selectedJourney=[jny objectAtIndex:indexPath.row];		
		}
		selectJourney=scheduleTravelDetails.selectedJourney;
		if (([scheduleTravelDetails.selectedJourney.JourneyStatus isEqualToString:@"unAcknowledged"]) &&  ([self tabName]==@"Scheduled Jobs") ) {
			acknowledgeJourneyActionSheet = [[UIActionSheet alloc] initWithTitle:@"Take Action" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil, nil];
			[acknowledgeJourneyActionSheet addButtonWithTitle:@"Acknowledge Journey"];
			[acknowledgeJourneyActionSheet addButtonWithTitle:@"Reject Journey"];
			[acknowledgeJourneyActionSheet addButtonWithTitle:@"Cancel"];
            nonProtected=@"Yes";
			acknowledgeJourneyActionSheet.cancelButtonIndex = 2;
			[acknowledgeJourneyActionSheet showFromTabBar:self.tabBarController.tabBar];
			
		}
		else {
			//journeyAcknowledged=NO;
			if([self tabName]==@"Scheduled Jobs")
				scheduleTravelDetails.journeyType=@"Scheduled Jobs";
			else {
				scheduleTravelDetails.journeyType=@"Completed Jobs";
			}
			scheduleTravelDetails.destination=scheduleTravelDetails.selectedJourney.ToAddress;
			scheduleTravelDetails.originAddress=scheduleTravelDetails.selectedJourney.FromAddress;
			scheduleTravelDetails.totalPassenger=[NSString stringWithFormat:@"%li", (long)scheduleTravelDetails.selectedJourney.TotalNumberOfPassenger];
			scheduleTravelDetails.totalFare=[NSString stringWithFormat:@"%li", (long)scheduleTravelDetails.selectedJourney.JourneyFare];
			[self.navigationController pushViewController:scheduleTravelDetails animated:YES];
			[tableView deselectRowAtIndexPath:indexPath animated:YES];
			[scheduleTravelDetails autorelease];
		}
		
	}else {
		[self showConnectionAlert];
		//[Common showConnectionAlert];
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

- (void)viewWillDisappear:(BOOL)animated
{ 
	if(updatetimer!=nil){
		[updatetimer invalidate];
		updatetimer=nil;
    }
	[HUD hide:YES];
	//self.navigationItem.rightBarButtonItem=nil;
	self.navigationItem.leftBarButtonItem=nil;
    
}


- (void)dealloc {
	[travelarray release];
	[toAddress release];
	[tabName release];
	[tomorrowTravelDetails release];
	[segmentControl release];
	[uniqueArray release];
	[todayDate release];
	[tomorrowDate release];
	[jnyDict release];
	[logoutAlert release];
	[groupedArray release];
	[longitude release];
	[latitude release];
	[selectJourney release];
	[acknowledgeJourneyActionSheet release];
	[dropRejectedAlert release];
	//[newJnyAlert release];
	[networkAlert release];
	//[newJourneysArray release];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
	
	
    [super dealloc];
}


@end
