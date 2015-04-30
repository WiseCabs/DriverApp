//
//  ScheduleTravelDetails.m
//  driverApp
//
//  Created by Nagraj Gopalakrishnan on 17/11/11.
//  Copyright 2011 Apppli. All rights reserved.
//

#import "ScheduleTravelDetails.h"
#import "DetailTableViewCell.h"
#import "Journey.h"
#import "DropComplete.h"
#import "Common.h"
#import "WebServiceHelper.h"
#import "NextPickUpDetails.h"
#import "ALToastView.h"
#import "DropOffTVCCell.h"

@implementation ScheduleTravelDetails
@synthesize date,journeyAcknowledgedActionSheet,alreadyOnRouteActionSheet,alreadyOnBoardActionSheet;
@synthesize time,journeyImage;
@synthesize onRoute,onBoard,journeyAcknowledged,totalPassenger,totalFare,jnyStatusLbl,mapButton;
@synthesize toAddress,journeyType,scrollView,phoneNo;
@synthesize selectedJourney,otherPickUpsTableView,fromAddress,destination,originAddress;
@synthesize mainTableView,isScheduled,tableBackgroudImage,Totalfare,dropCancelledAlert,dropRejectedAlert;
@synthesize pickUpButton,lblAddress,fare,customerName,customerMobile,additionalInfo,lblDropOffNos;

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
-(void)viewWillAppear:(BOOL)animated{
	self.toAddress=@"";
	
	//[toAddress retain];
    [self.view addSubview:mainTableView];
	}

- (void)viewDidLoad {
	[scrollView setContentSize:scrollView.frame.size];
	
	
	self.totalPassenger=[NSString stringWithFormat:@"%ld",(long)selectedJourney.TotalNumberOfPassenger];    //64-bit modification
	self.totalFare=[NSString stringWithFormat:@"%ld",(long)selectedJourney.JourneyFare];    //64-bit modification
	//[totalPassenger retain];
	//[totalFare retain];
	//NSInteger fareValue = [selectedJourney.JourneyFare intValue];
	//[NSString stringWithFormat:@" %d",fareValue]
	self.title=@"Jobs Details";
	if ([[selectedJourney SubJourney] count]==1) {
		otherPickUpsTableView.hidden=YES;
		scrollView.contentSize= CGSizeMake(320, 370);
	}
	else {
		scrollView.contentSize= CGSizeMake(320, 450);
	}

	mainTableView.separatorColor=[UIColor clearColor];
	otherPickUpsTableView.separatorColor=[UIColor clearColor];

	if(isScheduled)
	{
	  UIButton *button =  [UIButton buttonWithType:UIButtonTypeCustom];
	  [button setImage:[UIImage imageNamed:@"ActionSheetIcon2.png"] forState:UIControlStateNormal];
	  [button addTarget:self action:@selector(showActionSheet:) forControlEvents:UIControlEventTouchUpInside];
	  [button setFrame:CGRectMake(0, 0, 32, 32)];
	  self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:button] autorelease];
		//[button release];
	}
	if ( [selectedJourney.JourneyStatus isEqualToString:@"Acknowledged"] ) {
		journeyAcknowledged=YES;
        if ([[self journeyType] isEqualToString:@"Scheduled Jobs"]) {
            if ([selectedJourney.baseName isEqualToString:@""]) {
                jnyStatusLbl.text=[NSString stringWithFormat:@"On Route"];
                journeyImage.image=[UIImage imageNamed:@"onRoute.png"];
            }
            else{
                jnyStatusLbl.text=[NSString stringWithFormat:@"Drop Complete"];
                journeyImage.image=[UIImage imageNamed:@"dropComplete.png"];
            }
             
        }
        else{
            jnyStatusLbl.hidden=YES;
        }
       
	}
    if ([[self journeyType] isEqualToString:@"Completed Jobs"]) {
        jnyStatusLbl.hidden=YES;
        journeyImage.hidden=YES;
        /*date.font=[UIFont fontWithName:@"Helvetica-Bold" size:24];
        time.font=[UIFont fontWithName:@"Helvetica-Bold" size:25];
        self.mainTableView.frame=CGRectMake( 2, 40, 316, 448 );
        self.date.frame=CGRectMake( 7, 10, 190, 27 );
        self.time.frame=CGRectMake( 212, 10, 102, 27 );*/
    }
    if ([selectedJourney.JourneyStatus isEqualToString:@"On Route"] ) {
        jnyStatusLbl.text=[NSString stringWithFormat:@"At Customer"];
        journeyImage.image=[UIImage imageNamed:@"dropComplete.png"];
    }
    if ([selectedJourney.JourneyStatus isEqualToString:@"At Customer"] ) {
        jnyStatusLbl.text=[NSString stringWithFormat:@"Passenger on Board"];
        journeyImage.image=[UIImage imageNamed:@"POB.png"];
    }
    if ([selectedJourney.JourneyStatus isEqualToString:@"On Board"] ) {
        jnyStatusLbl.text=[NSString stringWithFormat:@"Drop Complete"];
        journeyImage.image=[UIImage imageNamed:@"dropComplete.png"];
    }
    
	jnyStatusLbl.userInteractionEnabled=YES;
    
	//////////////Adding tap gesture to UILabel for Scheduled Job details page////////////////////////
     if ([[self journeyType] isEqualToString:@"Scheduled Jobs"]) {
	UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showJourneyAction)];
    [jnyStatusLbl addGestureRecognizer:tap];
     }
	
    Journey *jny=[[selectedJourney SubJourney] objectAtIndex:0];
	NSDateFormatter* formatter = [[[NSDateFormatter alloc] init] autorelease];
	[formatter setDateFormat:@"dd/MM/yyyy"];
	NSString *dateString=[NSString stringWithFormat:@"%@",selectedJourney.JourneyDate];
	
	NSDate* convertedDate = [formatter dateFromString:dateString];
	NSDateFormatter* dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
	[dateFormatter setDateFormat:@"EEE, d MMMM"];
	NSString *formatedString=[dateFormatter stringFromDate:convertedDate];
	
	date.text=[NSString stringWithFormat:@"%@",formatedString];
	NSString *CapitalTime=[selectedJourney.JourneyTime uppercaseString];
	time.text=[NSString stringWithFormat:@"%@",CapitalTime];
	
	//float fareValue = [selectedJourney.JourneyFare intValue];
	//=[NSString stringWithFormat:@"%@ %@", selectedJourney.Currency,selectedJourney.JourneyFare];

    
    
    
    
    lblAddress.text=[NSString stringWithFormat:@"%@",jny.FromAddress];
    customerName.text=[NSString stringWithFormat:@"%@",jny.customerName];
    [customerMobile setTitle:[NSString stringWithFormat:@"%@",jny.customerMobile] forState: UIControlStateNormal];
    additionalInfo.text=[NSString stringWithFormat:@"%@",jny.customerInfo];
    
    self.phoneNo=jny.customerMobile;
    self.fromAddress=lblAddress.text;
    
    
    int Indfare=(int)[jny.JourneyFare intValue]/(int)selectedJourney.TotalNumberOfPassenger;
    
    fare.text=[NSString stringWithFormat:@"%@ %ld",[Common currencySymbol],(long)(jny.NumberOfPassenger*Indfare)];  //64-bit modification
    //pickUpButton.tag = indexPath.row;
    [pickUpButton addTarget:self action:@selector(directionToPickUp:) forControlEvents:UIControlEventTouchUpInside];
       [customerMobile addTarget:self action:@selector(callpassengerAction:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    
    
    [self.mainTableView setDelegate:self];
    
    [self.mainTableView setDataSource:self];
    
    
    
	[super viewDidLoad];
    
    self.navigationController.navigationBar.translucent = NO;

}

-(void)showJourneyAction{
    NSString *jnyStatusText=jnyStatusLbl.text;
     /*if([jnyStatusText isEqualToString:@"On Route"]){
        if ([selectedJourney.baseName isEqualToString:@""]) {
            journeyAcknowledgedActionSheet = [[UIActionSheet alloc] initWithTitle:@"Take Action" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil, nil];
            [journeyAcknowledgedActionSheet addButtonWithTitle:@"On Route"];
            [journeyAcknowledgedActionSheet addButtonWithTitle:@"Cancel"];
            journeyAcknowledgedActionSheet.cancelButtonIndex = 1;
            [journeyAcknowledgedActionSheet showFromTabBar:self.tabBarController.tabBar];
        }
        else{
            alreadyOnBoardActionSheet = [[UIActionSheet alloc] initWithTitle:@"Take Action" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil, nil];
            [alreadyOnBoardActionSheet addButtonWithTitle:@"Drop Complete"];
            [alreadyOnBoardActionSheet addButtonWithTitle:@"Cancel"];
            alreadyOnBoardActionSheet.cancelButtonIndex = 1;
            [alreadyOnBoardActionSheet showFromTabBar:self.tabBarController.tabBar];
        }
        
    }*/
    if([jnyStatusText isEqualToString:@"On Route"]){
       /* journeyAcknowledgedActionSheet = [[UIActionSheet alloc] initWithTitle:@"Take Action" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil, nil];
        [journeyAcknowledgedActionSheet addButtonWithTitle:@"On Route"];
        [journeyAcknowledgedActionSheet addButtonWithTitle:@"Cancel"];
        journeyAcknowledgedActionSheet.cancelButtonIndex = 1;
        [journeyAcknowledgedActionSheet showFromTabBar:self.tabBarController.tabBar];*/

        [self takeAction:@"onRoute"];
        //	[Common showAlert:@"" message:@"Journey status updated to: On Board"];
        [ALToastView toastInView:self.view withText:@"Journey status updated to: On Route"];
        [Common setdropCompleteStatus:@""];
        self.onBoard=YES;
        jnyStatusLbl.text=[NSString stringWithFormat:@"At Customer"];
        journeyImage.image=[UIImage imageNamed:@"dropComplete.png"];
        
        
    }
    
    else if([jnyStatusText isEqualToString:@"At Customer"]){
        /* alreadyOnRouteActionSheet = [[UIActionSheet alloc] initWithTitle:@"Take Action" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil, nil];
         [alreadyOnRouteActionSheet addButtonWithTitle:@"Passenger on Board"];
         [alreadyOnRouteActionSheet addButtonWithTitle:@"Cancel"];
         alreadyOnRouteActionSheet.cancelButtonIndex = 1;
         [alreadyOnRouteActionSheet showFromTabBar:self.tabBarController.tabBar];*/
        
        [self takeAction:@"atCustomer"];
        self.onBoard=YES;
        // [Common showAlert:@"" message:@"Journey status updated to: On Board"];
        [ALToastView toastInView:self.view withText:@"Journey status updated to: At Customer"];
        [Common setdropCompleteStatus:@""];
        jnyStatusLbl.text=[NSString stringWithFormat:@"Passenger on Board"];
        journeyImage.image=[UIImage imageNamed:@"POB.png"];
        
        
    }
    else if([jnyStatusText isEqualToString:@"Passenger on Board"]){
       /* alreadyOnRouteActionSheet = [[UIActionSheet alloc] initWithTitle:@"Take Action" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil, nil];
		[alreadyOnRouteActionSheet addButtonWithTitle:@"Passenger on Board"];
		[alreadyOnRouteActionSheet addButtonWithTitle:@"Cancel"];
		alreadyOnRouteActionSheet.cancelButtonIndex = 1;
		[alreadyOnRouteActionSheet showFromTabBar:self.tabBarController.tabBar];*/
        
        [self takeAction:@"onBoard"];
        self.onBoard=YES;
        // [Common showAlert:@"" message:@"Journey status updated to: On Board"];
        [ALToastView toastInView:self.view withText:@"Journey status updated to: On Board"];
        [Common setdropCompleteStatus:@""];
        jnyStatusLbl.text=[NSString stringWithFormat:@"Drop Complete"];
        journeyImage.image=[UIImage imageNamed:@"dropComplete.png"];
        
       
    }
    else if([jnyStatusText isEqualToString:@"Drop Complete"]){
        alreadyOnBoardActionSheet = [[UIActionSheet alloc] initWithTitle:@"Take Action" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil, nil];
		[alreadyOnBoardActionSheet addButtonWithTitle:@"Drop Complete"];
		[alreadyOnBoardActionSheet addButtonWithTitle:@"Cancel"];
		alreadyOnBoardActionSheet.cancelButtonIndex = 1;
		[alreadyOnBoardActionSheet showFromTabBar:self.tabBarController.tabBar];
    }
}

-(IBAction)showActionSheet:(id)sender {
	
//Journey has been acknowledged by Driver
	
	UIActionSheet *dropCancelActionSheet = [[UIActionSheet alloc] initWithTitle:@"Take Action" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil, nil];
	
	[dropCancelActionSheet addButtonWithTitle:@"Drop Cancel"];
	[dropCancelActionSheet addButtonWithTitle:@"Cancel"];
	dropCancelActionSheet.cancelButtonIndex = 1;
	[dropCancelActionSheet showFromTabBar:self.tabBarController.tabBar];
	
		
}

-(void) takeAction: (NSString *)actionType {
	WebServiceHelper *servicehelper=[[WebServiceHelper alloc] init];
	servicehelper.objEntity=[[[NSObject alloc]init] autorelease];
	if ([[Common driverStatus] isEqualToString:@"At Base"]) {
		//[Common setdropCompleteStatus:@"showButton"];
	}
	NSArray *sdkeys;
	NSArray *sdobjects;
	 if([actionType isEqualToString:@"onRoute"]){
         sdkeys = [NSArray arrayWithObjects:@"uid",@"type",@"aj_id",@"suppID",@"destination", nil];
         //64-bit modification
		 sdobjects = [NSArray arrayWithObjects:[NSString stringWithFormat:@"%ld",(long)[Common loggedInDriverID]],actionType,[NSString stringWithFormat:@"%ld",(long)selectedJourney.AllocatedJourneyID],[NSString stringWithFormat:@"%ld",(long)selectedJourney.suppID],originAddress, nil];

	 }
     else if([actionType isEqualToString:@"dropComplete"]){
         sdkeys = [NSArray arrayWithObjects:@"uid",@"type",@"aj_id",@"fare",@"no_of_passenger",@"destination",@"suppID", nil];
        
         //64-bit modification
         sdobjects = [NSArray arrayWithObjects:[NSString stringWithFormat:@"%ld",(long)[Common loggedInDriverID]],@"dropCompleted",[NSString stringWithFormat:@"%ld",(long)selectedJourney.AllocatedJourneyID],self.totalFare,self.totalPassenger,@"",[NSString stringWithFormat:@"%ld",(long)selectedJourney.suppID], nil];
     }
	else if([actionType isEqualToString:@"onBoard"]){
        sdkeys = [NSArray arrayWithObjects:@"uid",@"type",@"aj_id",@"suppID",@"destination", nil];
        //64-bit modification
		sdobjects = [NSArray arrayWithObjects:[NSString stringWithFormat:@"%ld",(long)[Common loggedInDriverID]],actionType,[NSString stringWithFormat:@"%ld",(long)selectedJourney.AllocatedJourneyID],[NSString stringWithFormat:@"%ld",(long)selectedJourney.suppID],destination, nil];

	}
    else if([actionType isEqualToString:@"atCustomer"]){
        sdkeys = [NSArray arrayWithObjects:@"uid",@"type",@"aj_id",@"suppID",@"destination", nil];
        //64-bit modification
        sdobjects = [NSArray arrayWithObjects:[NSString stringWithFormat:@"%ld",(long)[Common loggedInDriverID]],actionType,[NSString stringWithFormat:@"%ld",(long)selectedJourney.AllocatedJourneyID],[NSString stringWithFormat:@"%ld",(long)selectedJourney.suppID],destination, nil];
        
    }
	else {
        sdkeys = [NSArray arrayWithObjects:@"uid",@"type",@"aj_id",@"suppID",@"destination", nil];
        //64-bit modification
		sdobjects = [NSArray arrayWithObjects:[NSString stringWithFormat:@"%ld",(long)[Common loggedInDriverID]],actionType,[NSString stringWithFormat:@"%ld",(long)selectedJourney.AllocatedJourneyID],[NSString stringWithFormat:@"%ld",(long)selectedJourney.suppID],@"", nil];

	}

	//NSArray *sdobjects = [NSArray arrayWithObjects:[NSString stringWithFormat:@"%d",[Common loggedInDriverID]],actionType,[NSString stringWithFormat:@"%d",selectedJourney.AllocatedJourneyID],[NSString stringWithFormat:@"%d",selectedJourney.suppID],destination, nil];
	NSDictionary *sdparams = [NSDictionary dictionaryWithObjects:sdobjects forKeys:sdkeys];
	NSString *URL=[NSString stringWithFormat:@"%@driveroptions",[Common webserviceURL]];
	
	NSArray *resultArray=[servicehelper callWebService:URL pms:sdparams];
	//[servicehelper release];
	NSDictionary *sucessDictionary = [resultArray objectAtIndex:0];
	NSString *sucessString=[sucessDictionary objectForKey:@"success"];
	if ([sucessString isEqualToString:@"true"]) {	
	
        if([actionType isEqualToString:@"dropComplete"]){
               // [Common setdropCompleteStatus:@"Yes"];
                NSArray *controllers=[self.navigationController viewControllers];
                [self.navigationController popToViewController:[controllers objectAtIndex:[controllers count]-2] animated:YES];
            }
    else if([actionType isEqualToString:@"dropCancelled"]){
        //64-bit modification   int -> NSInteger
        NSInteger noOfPastJourneys=[Common noOfPastJourneys];
        [Common setNoOfPastJourneys:noOfPastJourneys-1];
            }
	}

}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	//Drop cancelled by User
	if (alertView==dropCancelledAlert) {
		if (buttonIndex==0) {
			[self takeAction:@"dropCancelled"];
			[self.navigationController popViewControllerAnimated:YES];
			//NSArray *controllers=[self.navigationController viewControllers];			
			//[self.navigationController popToViewController:[controllers objectAtIndex:[controllers count]-1] animated:YES];
		}
	}
	
	//Journey rejected by Driver
	else if (alertView==dropRejectedAlert) {
		if (buttonIndex==0) {
		[self takeAction:@"rejectJourney"];
			[self.navigationController popViewControllerAnimated:YES];
        }
    }
    else{
        if (buttonIndex==0) {
            CGFloat sysVers = [UIDevice currentDevice].systemVersion.floatValue;
            NSString* hostName = (sysVers < 6.0) ? @"maps.google.com" : @"maps.apple.com";
             NSString* urlString=@"";
            if ([mapButton isEqualToString:@"directionToDropOff"]) {
                urlString = [NSString stringWithFormat: @"http://%@/maps?saddr=Current+Location&daddr=%@",hostName,self.toAddress];
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] ]];

            }
            else{
               urlString = [NSString stringWithFormat: @"http://%@/maps?saddr=Current+Location&daddr=%@",hostName,self.fromAddress];
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] ]];

            }
        }
        if (buttonIndex==1) {
          

            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms://itunes.apple.com/us/app/google-maps/id585027354?mt=8"]];

      
        }
    }
    
}


-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	//WebServiceHelper *servicehelper=[[WebServiceHelper alloc] init];
 if ([Common isNetworkExist]>0)
  {	

//ActionSheet is journeyAcknowledgedActionSheet	  
	  if (actionSheet==journeyAcknowledgedActionSheet) {
		  
		  if (buttonIndex == 0) 
		  {
             
                  [self takeAction:@"onRoute"];
                  //	[Common showAlert:@"" message:@"Journey status updated to: On Board"];
                  [ALToastView toastInView:self.view withText:@"Journey status updated to: On Route"];
              [Common setdropCompleteStatus:@""];
                  self.onBoard=YES;
                  jnyStatusLbl.text=[NSString stringWithFormat:@"Passenger on Board"];
              journeyImage.image=[UIImage imageNamed:@"POB.png"];
            }
		
			
			  
		 		  
  }
  
 
//ActionSheet:- alreadyOnRouteActionSheet
    else  if (actionSheet==alreadyOnRouteActionSheet) {
         if (buttonIndex == 0){
         [self takeAction:@"onBoard"];
         self.onBoard=YES;
         // [Common showAlert:@"" message:@"Journey status updated to: On Board"];
		 [ALToastView toastInView:self.view withText:@"Journey status updated to: On Board"];
             [Common setdropCompleteStatus:@""];
         jnyStatusLbl.text=[NSString stringWithFormat:@"Drop Complete"];
             journeyImage.image=[UIImage imageNamed:@"dropComplete.png"];
	 }
	 
    }
 //ActionSheet:- alreadyOnBoardActionSheet
	else if (actionSheet==alreadyOnBoardActionSheet) {
		if (buttonIndex == 0){
            [self takeAction:@"dropComplete"];
            [Common setdropCompleteStatus:@"dropCompleted"];
           // jnyStatusLbl.text=[NSString stringWithFormat:@""];
		
	}
    }
    else{
        if (buttonIndex==0) {
            dropCancelledAlert = [[UIAlertView alloc] initWithTitle:@"Has passenger cancelled the journey?" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
            [dropCancelledAlert addButtonWithTitle:@"Yes"];
            [dropCancelledAlert addButtonWithTitle:@"No"];
            dropCancelledAlert.cancelButtonIndex = 1;
            [dropCancelledAlert show];
            [dropCancelledAlert release];
        }
       
    }
 
  }
 
 else {
	  [Common showNetwokAlert];
  }
	  
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    
    Journey *jny=[[selectedJourney SubJourney] objectAtIndex:0];
    if (jny.isMultiDestination) {
        //64-bit modification
        NSLog(@"[jny.multiDestAddresses tableView count] is %lu",(unsigned long)[jny.multiDestAddresses count]);
        lblDropOffNos.text=[NSString stringWithFormat:@"Drop-off To(%lu):",(unsigned long)[jny.multiDestAddresses count]];
        return [jny.multiDestAddresses count];
        
    }
    lblDropOffNos.text=[NSString stringWithFormat:@"Drop-off To(1):"];
	return 1;
    

}


// Customize the appearance of table view cells.
/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
    
    return cell;
}
 */



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	 
    static NSString *CellIdentifier = @"Cell";
    DropOffTVCCell *cell = (DropOffTVCCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell==nil){
        NSArray *toplevelObjects=[[NSBundle mainBundle] loadNibNamed:@"DropOffTVC" owner:nil options:nil];
        
        
        for(id currentObject in toplevelObjects){
            
            if([currentObject isKindOfClass:[UITableViewCell class]]){
                cell=(DropOffTVCCell *) currentObject;
				
                
                /*UITapGestureRecognizer *callingGecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(callpassengerAction:)];
                 [cell.customerMobile addGestureRecognizer:callingGecognizer];
                 */
                
                Journey *jny=[[selectedJourney SubJourney] objectAtIndex:0];
                if (jny.isMultiDestination) {
                NSString *toAddressString=[jny.multiDestAddresses objectAtIndex:indexPath.row];
                //cell.backgroundView = [ [[UIImageView alloc] initWithImage:[ [UIImage imageNamed:@"country-details.png"] stretchableImageWithLeftCapWidth:0.0 topCapHeight:5.0] ]autorelease];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.toAddress.text=[NSString stringWithFormat:@"%@",toAddressString];                self.toAddress=cell.toAddress.text;
                cell.dropOffButton.tag = indexPath.row;
                [cell.dropOffButton addTarget:self action:@selector(directionToDropOff:) forControlEvents:UIControlEventTouchUpInside];
               
                
                if([self.journeyType isEqualToString:@"Scheduled Travels"]){
                }
                else {
                    
                    
                    //[cell.pickUpButton setHidden:YES];
                    //[cell.dropOffButton setHidden:YES];
                    //cell.fromAddress.frame=CGRectMake( 8, 38, 301, 59 );
                    //cell.toAddress.frame=CGRectMake( 8, 128, 301, 59 );
                }
                
                }
                else{
                    cell.toAddress.text=[NSString stringWithFormat:@"%@",jny.ToAddress];
                    self.toAddress=cell.toAddress.text;
                    cell.dropOffButton.tag = indexPath.row;
                    [cell.dropOffButton addTarget:self action:@selector(directionToDropOff:) forControlEvents:UIControlEventTouchUpInside];
                }

            }
            
        }
        
    }
    
    return cell;
}

-(void)showMapAlert{
   UIAlertView *mapsAlert = [[UIAlertView alloc] initWithTitle:@"" message:@"Install Google Maps on your iOS device to get accurate direction for current journey." delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
    [mapsAlert addButtonWithTitle:@"Not now,Use Apple Maps"];
    [mapsAlert addButtonWithTitle:@"Install Google Maps"];
    [mapsAlert addButtonWithTitle:@"Cancel"];
    mapsAlert.cancelButtonIndex = 2;
    [mapsAlert show];
}

-(IBAction)callpassengerAction:(UIButton*)button{
	//if( [recognizer state] == UIGestureRecognizerStateEnded ) {
		// the label that was tapped
		//UILabel* label = (UILabel*)[recognizer view];
	NSString *mobile=[NSString stringWithFormat:@"tel://%@",self.phoneNo];
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:mobile]];
	//}
}



	
-(IBAction)directionToDropOff:(id) sender{
    mapButton=@"directionToDropOff";
    
    Journey *jny=[[selectedJourney SubJourney] objectAtIndex:0];
    NSString *toAddressString=[jny.multiDestAddresses objectAtIndex:[sender tag]];
    
    
    //CGFloat sysVers = [UIDevice currentDevice].systemVersion.floatValue;
   // NSString* hostName = (sysVers < 6.0) ? @"maps.google.com" : @"maps.apple.com";
    
    NSString* urlString = [NSString stringWithFormat: @"comgooglemaps://?saddr=Current Location&daddr=%@&directionsmode=driving",toAddressString];
    NSLog(@"directionToDropOff address is %@",urlString);
    if ([[UIApplication sharedApplication] canOpenURL: [NSURL URLWithString: [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] ]]){
        [[UIApplication sharedApplication] openURL: [NSURL URLWithString: [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] ]];
    }
    else{
        [self showMapAlert];
        //[Common showAlert:@"Install Google Maps" message:@"Please install Google Maps on your iOS device to get accurate direction for current journey."];
    }
        
   
   // comgooglemaps://?center=40.765819,-73.975866&zoom=14&views=traffic }
   
    
    
	// NSString *urlString = [NSString stringWithFormat:@"http://maps.google.com/maps?saddr=Current Location&daddr=%@",self.toAddress];
	//NSString *urlString = [NSString stringWithFormat:@"http://maps.google.com/maps?saddr=London City Airport&daddr=%@",toAddress];
	
	//[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] ]];
	
}

-(IBAction)directionToPickUp:(UIButton*) button{
    
  
    NSString* urlString = [NSString stringWithFormat: @"comgooglemaps://?saddr=Current Location&daddr=%@&directionsmode=driving",self.fromAddress];
    mapButton=@"directionToPickUp";
    if ([[UIApplication sharedApplication] canOpenURL: [NSURL URLWithString: [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] ]]){
        [[UIApplication sharedApplication] openURL: [NSURL URLWithString: [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] ]];
    }
    else{
        [self showMapAlert];
        //[Common showAlert:@"Install Google Maps" message:@"Please install Google Maps on your iOS device to get accurate direction for current journey."];
    }

	
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
	{
		if(tableView==self.otherPickUpsTableView) {
			
		NextPickUpDetails *nextPickUpDetails=[[NextPickUpDetails alloc] init];
		self.navigationItem.backBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil] autorelease];
		nextPickUpDetails.selectedJourney=self.selectedJourney;
		nextPickUpDetails.journeyType=self.journeyType;
		[self.navigationController pushViewController:nextPickUpDetails animated:YES];
		[nextPickUpDetails release];
		[tableView deselectRowAtIndexPath:indexPath animated:YES];

		}
		else {
			[tableView deselectRowAtIndexPath:indexPath animated:YES];
		}

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
    [pickUpButton release];
    [lblAddress release];
    [fare release];
    [customerName release];
    [customerMobile release];
    [additionalInfo release];
    [lblDropOffNos release];
    
    
	[otherPickUpsTableView release];
	[date release];
	[time release];
	[selectedJourney release];
	[mainTableView release];
	[tableBackgroudImage release],
	[originAddress release];
	[phoneNo release];
	[totalPassenger release];
	[totalFare release];
	[jnyStatusLbl release];
    [journeyImage release];
	[mapButton release];
    [super dealloc];
}


@end
