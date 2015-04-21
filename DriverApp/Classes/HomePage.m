//
//  HomePage.m
//  driverApp
//
//  Created by Nagraj Gopalakrishnan on 15/11/11.
//  Copyright 2011 Apppli. All rights reserved.
//

#import "HomePage.h"
#import "TableViewCell.h"
#import "JSON.h"
#import "ScheduleJourneydetail.h"
#import "WebServiceHelper.h"
#import "AllocatedJourney.h"
#import "Common.h"

@implementation HomePage
@synthesize scheduledJourneyCount,completedJourneyCount,userID;
@synthesize maintableView,updatetimer,flag;

- (void)viewWillAppear:(BOOL)animated {
	if(flag)
	{
		flag=NO;
	}else {
		[self performSelector:@selector(updatejourney) withObject:nil afterDelay:0];
		
	}
	
	[super viewWillAppear:TRUE];
}

- (void)viewDidLoad {
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Logout" style:UIBarButtonItemStylePlain target:self action:@selector(showLogoutPage:)  ] autorelease];
	
	[super viewDidLoad];
	flag=YES;
	updatetimer = [NSTimer scheduledTimerWithTimeInterval: 60.0 target: self selector:@selector(onTick:) userInfo: nil repeats:YES];
	NSLog(@"update time object called");
	self.navigationItem.hidesBackButton = YES;
	self.title=@"Wise Cabs";
    
    self.navigationController.navigationBar.translucent = NO;

}

-(void)getJourneyCount{
	if([Common isNetworkExist])
	{
	WebServiceHelper *servicehelper=[[WebServiceHelper alloc] init];
	NSObject *obj=[[[NSObject alloc]init] autorelease];
	servicehelper.objEntity=obj;
	Common *cmn=[[Common alloc]init];
		NSArray *sdkeys = [NSArray arrayWithObjects:@"username", @"password",nil];
		NSArray *sdobjects = [NSArray arrayWithObjects:[Common loggeduserId],[Common loggedUserpassword], nil];
		NSDictionary *sdparams = [NSDictionary dictionaryWithObjects:sdobjects forKeys:sdkeys];	
	NSArray *result=[servicehelper callWebService:[NSString stringWithFormat:@"%@driverauth",[Common webserviceURL]] pms:sdparams];
	
	NSDictionary *authUser=[result objectAtIndex:0];
	self.scheduledJourneyCount=[authUser objectForKey:@"ScheduledJourneyCount"];
	self.completedJourneyCount=[authUser objectForKey:@"CompletedJourneyCount"]; 
		NSLog(@"get journey timer updated");
	[cmn release];
	[servicehelper release];
	[self.maintableView reloadData];

	}else {
		[Common showNetwokAlert];
	}

}
-(void)updatejourney{
	[self showUpdate:@"Loading" detailtext:@"Checking Journey" ];
	NSLog(@"updatejourney timer updated");
	[updatetimer invalidate];
	updatetimer=nil;	
	updatetimer = [NSTimer scheduledTimerWithTimeInterval: 60.0 target: self selector:@selector(onTick:) userInfo: nil repeats:YES];

}	
-(void)onTick:(NSTimer*) tm
{
	//[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
	[self showUpdate:@"Loading" detailtext:@"Checking Journey" ];
		NSLog(@"update journeyfunction timer updated");
	//[self getJourneyCount];
	
	//[self.tableView reloadData];
	//[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}
-(void)showUpdate:(NSString*)lable detailtext:(NSString*)detailsText
{
	HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
	[self.navigationController.view addSubview:HUD];
	
	HUD.delegate = self;
	HUD.labelText = lable;
	HUD.detailsLabelText = detailsText;
	HUD.square = YES;
	
	[HUD showWhileExecuting:@selector(getJourneyCount) onTarget:self withObject:nil animated:YES];
}


-(IBAction)showLogoutPage:(id)sender {
	
	NSLog(@"User is logged in");
	UIAlertView *logoutAlert = [[UIAlertView alloc] initWithTitle:@"Are you sure?" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
	[logoutAlert addButtonWithTitle:@"Yes"];
	[logoutAlert addButtonWithTitle:@"No"];
	logoutAlert.cancelButtonIndex = 1;
	[logoutAlert show];
	[logoutAlert release];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if (buttonIndex==0) {
		if ([Common isNetworkExist]>0)
		{
			
		[Common setUserId:nil];
		[Common setPassword:nil];
		NSLog(@"User id is(after logging out):- %@",[Common loggeduserId]);
		NSLog(@"User password is(after logging out):- %@",[Common loggedUserpassword]);
		[self.navigationController popToRootViewControllerAnimated:YES];
	}
	else {
		[Common showNetwokAlert];
	}
	}
}
 
/*
 - (void)viewDidAppear:(BOOL)animated {
 [super viewDidAppear:animated];
 }
 */
/*
 - (void)viewWillDisappear:(BOOL)animated {
 [super viewWillDisappear:animated];
 }
 */
/*
 - (void)viewDidDisappear:(BOOL)animated {
 [super viewDidDisappear:animated];
 }
 */
/*
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations.
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 */


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 2;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *CellIdentifier = @"Cell";
    self.maintableView=tableView;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		UIImage *myImage = [UIImage imageNamed:@"loginButtonBackgroundImage.png"];
		UIImageView *imgView = [[UIImageView alloc] initWithImage:myImage];
		UIImageView *imgView1 = [[UIImageView alloc] initWithImage:myImage];
		
		[cell setBackgroundView:imgView];
		[cell setSelectedBackgroundView:imgView1];
		//[myImage release];
		[imgView release];
		[imgView1 release];
			
    }
	 ;
	if(indexPath.row==0)
	{
		cell.textLabel.text=[NSString stringWithFormat:@"Scheduled Travels (%@)",scheduledJourneyCount ];
	}else {
		cell.textLabel.text=[NSString stringWithFormat:@"Completed Travels (%@)",completedJourneyCount ];
		
	}
    return cell;
}


/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */


/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source.
 [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }   
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
 }   
 }
 */


/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */


/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	// Navigation logic may go here. Create and push another view controller.
	if ([Common isNetworkExist]>0)
		
	{
		ScheduleJourneydetail *scheduledJourneydetail = [[ScheduleJourneydetail alloc] init];
		WebServiceHelper *servicehelper=[[WebServiceHelper alloc] init];
		AllocatedJourney *jny=[[AllocatedJourney alloc]init];
		servicehelper.objEntity=jny;
		
		NSArray *sdkeys = [NSArray arrayWithObjects:@"uid", nil];
		NSArray *sdobjects = [NSArray arrayWithObjects:[NSString stringWithFormat:@"%ld",(long)[Common loggedInDriverID]], nil];  //64-bit modification
		NSDictionary *sdparams = [NSDictionary dictionaryWithObjects:sdobjects forKeys:sdkeys];
		NSString *journeyURL=@"";
		if(indexPath.row==0)
		{
			journeyURL= [NSString stringWithFormat:@"%@driverscheduled",[Common webserviceURL]];
			//scheduledJourneydetail.isScheduled=YES;
		}else {
			journeyURL=[NSString stringWithFormat:@"%@drivercompleted",[Common webserviceURL]];
			//scheduledJourneydetail.isScheduled=NO;
		}
		
		NSArray *allJourney=[servicehelper callWebService:journeyURL pms:sdparams];
		
		scheduledJourneydetail.travelarray=allJourney;//[[json JSONValue] retain];

		[jny release];
		[allJourney release];
		
		[servicehelper release];
		self.navigationItem.backBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil] autorelease];
		[self.navigationController pushViewController:scheduledJourneydetail animated:YES];
		[scheduledJourneydetail release];
		[maintableView deselectRowAtIndexPath:indexPath animated:YES];
	}
	
	else {
		[Common showNetwokAlert];
	}
	
	
  }

- (void)viewWillDisappear:(BOOL)animated
{
	[updatetimer invalidate];
	updatetimer=nil;
}

#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
	[updatetimer invalidate];
	updatetimer=nil;
}


@end

