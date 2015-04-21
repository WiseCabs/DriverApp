//
//  DriverWaitingDetails.m
//  driverApp
//
//  Created by Nagraj on 07/11/12.
//
//

#import "DriverWaitingDetails.h"
#import "WebServiceHelper.h"
#import "Common.h"
#import "MBProgressHUD.h"
#import "Base.h"
#import "AllocatedJourney.h"
#import "DriverWaiting.h"
#import "DriverWaitingTVC.h"
#import "ALToastView.h"
#import <AudioToolbox/AudioToolbox.h>

@interface DriverWaitingDetails ()


@end

@implementation DriverWaitingDetails
@synthesize basePicker,baseLabel,customBarItem,driverTableView,baseArray,driverArray,travelarray,newJnyAlert,dropRejectedAlert,journey,updatetimer,timerCalled,updatingJnys;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


-(void)viewWillAppear:(BOOL)animated{
    timerCalled=false;
    updatingJnys =true;
   [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardDidShowNotification object:nil];
    if(updatetimer==nil){
    updatetimer = [NSTimer scheduledTimerWithTimeInterval: 60.0 target: self selector:@selector(onTick:) userInfo: nil repeats:YES];
    }
    
  
}

-(void)getBases{
    WebServiceHelper *servicehelper=[[WebServiceHelper alloc] init];
    
    Base *base=[[Base alloc]init];
    servicehelper.objEntity=base;   
    NSArray *sdkeys = [NSArray arrayWithObjects:@"suppID",nil];
    NSString *suppID=[NSString stringWithFormat:@"%ld",(long)[Common supplierID]];  //64-bit modification
    NSArray *sdobjects = [NSArray arrayWithObjects:suppID, nil];
    NSDictionary *sdparams = [NSDictionary dictionaryWithObjects:sdobjects forKeys:sdkeys];
    
   baseArray=[servicehelper callWebService:[NSString stringWithFormat:@"%@supplierzones",[Common webserviceURL]] pms:sdparams];
    if([baseArray count]>0){
        Base *base = [baseArray objectAtIndex:0];
        baseLabel.text=[NSString stringWithFormat:@"%@",base.baseName];
         [NSThread detachNewThreadSelector:@selector(getBasesDrivers) toTarget: self withObject: nil];
       // [driverTableView reloadData];
       // self.baseLabel.inputView=nil;
        //baseLabel.enabled = NO;
    }
    else{
        [basePicker reloadAllComponents];
    }
    
}



-(void)showUpdate:(NSString*)lable detailtext:(NSString*)detailsText
{
	if ([Common isNetworkExist] ) {
        HUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.navigationController.view addSubview:HUD];
        
        HUD.delegate = self;
        HUD.labelText = lable;
        HUD.detailsLabelText = detailsText;
        HUD.square = YES;
        //internetAlertShown=NO;
        //updatingJnys=true;
        [HUD showWhileExecuting:@selector(getJourney) onTarget:self withObject:nil animated:YES];
	}
	else {
        
        //if(!internetAlertShown){
           // internetAlertShown=YES;
            [self showConnectionAlert];
        //}
		//[Common showConnectionAlert];
	}
    
	//[self.mainTableView reloadData];
}



-(void)showConnectionAlert{
	//if (!alertShown) {
        //alertShown=YES;
		UIAlertView *networkAlert = [[UIAlertView alloc] initWithTitle:@"No Internet Available" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
		[networkAlert addButtonWithTitle:@"Ok"];
		networkAlert.cancelButtonIndex = 0;
		[networkAlert show];
		
		//isNetworkAlertShowing=YES;
		
}

-(void)onTick:(NSTimer*) tm
{
    timerCalled=true;
    [self showUpdate:@"Updating" detailtext:@"Updating Journey"];
      
	
}



-(void)getJourney{
    
        
        [self getDrivers];
    if (updatingJnys) {
        updatingJnys=false;
        NSLog(@"Update timer got called in DriverWaiting");
   /* }
    else{
        NSLog(@"Update timer got called in DriverWaiting called first time");
    }*/
    
    //BOOL isSucess=NO;
    WebServiceHelper *servicehelper=[[WebServiceHelper alloc] init];

		AllocatedJourney *jny1=[[AllocatedJourney alloc]init];
		servicehelper.objEntity=jny1;
		NSArray *sdkeys = [NSArray arrayWithObjects:@"uid", nil];
		NSArray *sdobjects = [NSArray arrayWithObjects:[NSString stringWithFormat:@"%ld",(long)[Common loggedInDriverID]], nil];//64-bit modification
		NSDictionary *sdparams = [NSDictionary dictionaryWithObjects:sdobjects forKeys:sdkeys];
		NSString *journeyURL=@"";
		
			journeyURL= [NSString stringWithFormat:@"%@driverscheduled",[Common webserviceURL]];
		
		self.travelarray=nil;
		[self.travelarray release];
        self.travelarray=[[NSMutableArray alloc] init];
		self.travelarray=[servicehelper callWebService:journeyURL pms:sdparams];
   // self.travelarray=[servicehelper callWebService:journeyURL pms:sdparams];
    NSArray *tempArray=[servicehelper callWebService:journeyURL pms:sdparams];

        //int j=0;
        
		travelarray=[[NSMutableArray alloc] init];
    NSLog(@"no of past journeys in DriverwaitinDetails %ld",(long)[Common noOfPastJourneys]);
    NSLog(@"no of travelarray in DriverwaitinDetails %lu",(unsigned long)[tempArray count]);
		
		if ([Common noOfPastJourneys] < [tempArray count]) {
				
				
				NSString* path = [[NSBundle mainBundle] pathForResource:@"beep" ofType:@"caf"];
				NSURL * afUrl = [NSURL fileURLWithPath:path];
				UInt32 soundID;
				AudioServicesCreateSystemSoundID((CFURLRef)afUrl,&soundID);
				AudioServicesPlaySystemSound (soundID);
				//NSInteger noOfNewJourneys=[tempArray
            
            for (int i=1; i<=[tempArray count]; i++) {
                journey=nil;
                //journey =[[[AllocatedJourney] alloc] init];
                journey=[tempArray objectAtIndex:i-1];
                if (([journey.JourneyStatus isEqualToString:@"unAcknowledged"])) {
                    
                    newJnyAlert = [[UIAlertView alloc] initWithTitle:@"New Journey" message:@"A new journey has been assigned to you." delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
                    [newJnyAlert addButtonWithTitle:@"Accept "];
                    [newJnyAlert addButtonWithTitle:@"Reject"];
                    newJnyAlert.cancelButtonIndex = 1;
                    //newJourneyNo=newJourneyNo+1;
                    [self.newJnyAlert performSelector:@selector(show) onThread:[NSThread mainThread] withObject:nil waitUntilDone:NO];

                }
                
            }
			
        }
        else{
            updatingJnys=true;
        }
        //updatingJnys=true;
	
    }
   // updatingJnys=true;
}




-(void)backAction:(id)sender
{
   [self dismissModalViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    
    [self.navigationController.view setNeedsLayout];
	//self.view.frame = CGRectMake(160, 0, 320, [[UIScreen mainScreen] bounds].size.height);
	//CGRect newFrame = appDelegate.maintabBarController.view.frame;
	//newFrame.size.height += appDelegate.maintabBarController.tabBar.frame.size.height;
	//[appDelegate.maintabBarController.view setFrame:CGRectMake(newFrame.origin.x, newFrame.origin.y, newFrame.size.width, newFrame.size.height)];
    
    
    
    [NSThread detachNewThreadSelector:@selector(showProgress) toTarget: self withObject: nil];

    UIImage *buttonImage = [UIImage imageNamed:@"back-button.png"];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];    
    [button setImage:buttonImage forState:UIControlStateNormal];
    button.frame = CGRectMake(0, 0, 44.0,32.0);
    [button addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    customBarItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = customBarItem;
    
    
    baseArray=[[NSArray alloc] init];
    driverArray=[[NSArray alloc] init];
    self.navigationItem.title=@"Driver Waiting Table";
    baseLabel.userInteractionEnabled = YES;
     basePicker=[[UIPickerView alloc] initWithFrame:CGRectMake(0,100,320, 500)];
    basePicker.delegate = self;
    basePicker.dataSource = self;
    [basePicker selectRow:0 inComponent:0 animated:YES];
	
    [basePicker setShowsSelectionIndicator:YES];
   
    baseLabel.inputView=basePicker;
   
    

    [super viewDidLoad];
    
    self.navigationController.navigationBar.translucent = NO;

    
    // Do any additional setup after loading the view from its nib.
}

-(void) JourneyAction: (NSString *)actType {
	WebServiceHelper *servicehelper=[[WebServiceHelper alloc] init];
	servicehelper.objEntity=[[[NSObject alloc]init] autorelease];
	
    
	//AllocatedJourney *jny=[newJourneysArray objectAtIndex:0];
    
    
	
	NSArray *sdkeys = [NSArray arrayWithObjects:@"uid",@"type",@"aj_id",@"suppID",@"destination", nil];
    //64-bit modification
	NSArray *sdobjects = [NSArray arrayWithObjects:[NSString stringWithFormat:@"%ld",(long)[Common loggedInDriverID]],actType,[NSString stringWithFormat:@"%ld",(long)journey.AllocatedJourneyID],[NSString stringWithFormat:@"%ld",(long)journey.suppID],@"", nil];
	

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
        //64-bit modification   int -> NSInteger
        NSInteger noOfPastJourneys=[Common noOfPastJourneys];
		if ([actType isEqualToString:@"acknowledgeJourney"] || [actType isEqualToString:@"onBoard"] ) {
			//journeyAcknowledged=YES;
            [Common setNoOfPastJourneys:noOfPastJourneys+1];
            [self dismissModalViewControllerAnimated:YES];
			//[ALToastView toastInView:self.view withText:@"Thanks for acknowledging journey."];
			
		}
		else if ([actType isEqualToString:@"rejectJourney"]) {
           
		}
        NSLog(@"noOfpast Journey %ld",(long)[Common noOfPastJourneys]);
       
       
        
	}
}



- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView==newJnyAlert) {
		if (buttonIndex==0) {
            
         if(![journey.baseName isEqualToString:@""])
                [self JourneyAction:@"onBoard"];            
         else
            [self JourneyAction:@"acknowledgeJourney"];
       
    }
        
        if (buttonIndex==1) {
            dropRejectedAlert = [[UIAlertView alloc] initWithTitle:@"You are about to discard the Journey. Do you want to proceed?" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
            [dropRejectedAlert addButtonWithTitle:@"Yes"];
            [dropRejectedAlert addButtonWithTitle:@"No"];
            dropRejectedAlert.cancelButtonIndex = 1;
            [dropRejectedAlert show];
           
        }
        updatingJnys=true;
    }

    if (alertView==dropRejectedAlert) {
        if (buttonIndex==0) {
			[self JourneyAction:@"rejectJourney"];
            updatingJnys=true;
    }
    else{
        updatingJnys=true;
    }
    }
    
}



-(void)getBasesDrivers{
    NSAutoreleasePool *pool=[[NSAutoreleasePool alloc] init];
	
	if ([Common isNetworkExist]) {
        HUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.navigationController.view addSubview:HUD];
        
        HUD.delegate = self;
        HUD.labelText = @"Updating";
        HUD.detailsLabelText = @"Getting Driver details..";
        HUD.square = YES;
        
        [HUD showWhileExecuting:@selector(getDrivers) onTarget:self withObject:nil animated:YES];
    }
    else{
        [Common showNetwokAlert];
    }
    [pool release];
    
}

-(void)getDrivers{
        WebServiceHelper *servicehelper=[[WebServiceHelper alloc] init];
        
        DriverWaiting *driver=[[DriverWaiting alloc]init];
        servicehelper.objEntity=driver;
        NSArray *sdkeys = [NSArray arrayWithObjects:@"suppID",@"zoneName",nil];
        NSString *suppID=[NSString stringWithFormat:@"%ld",(long)[Common supplierID]];  //64-bit modification
        NSArray *sdobjects = [NSArray arrayWithObjects:suppID,baseLabel.text, nil];
        NSDictionary *sdparams = [NSDictionary dictionaryWithObjects:sdobjects forKeys:sdkeys];
        NSString *url=[NSString stringWithFormat:@"%@driversinzone",[Common webserviceURL]];
        NSArray  *tempArray=[servicehelper callWebService:url pms:sdparams];
    NSArray  *Array=[[NSArray alloc] init];
    
    self.driverArray=Array;
    NSSortDescriptor *firstDescriptor = [[[NSSortDescriptor alloc] initWithKey:@"waitingMinutes"  ascending:NO] autorelease];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:firstDescriptor, nil];
    if ([tempArray count]>0) {
        self.driverArray= [tempArray sortedArrayUsingDescriptors:sortDescriptors];
        
    }

     [self performSelectorOnMainThread:@selector(updateDriversTableView) withObject:nil waitUntilDone:NO];
        
    }

-(void)updateDriversTableView{
    [self.driverTableView reloadData];
}


-(void)showProgress{
	NSAutoreleasePool *pool=[[NSAutoreleasePool alloc] init];
	
		if ([Common isNetworkExist]) {
        HUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.navigationController.view addSubview:HUD];
        
        HUD.delegate = self;
        HUD.labelText = @"Updating";
        HUD.detailsLabelText = @"Getting bases..";
        HUD.square = YES;
        
        [HUD showWhileExecuting:@selector(getBases) onTarget:self withObject:nil animated:YES];
	}
	else {
		UIAlertView *networkAlert = [[UIAlertView alloc] initWithTitle:@"No Internet Available" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
		[networkAlert addButtonWithTitle:@"Ok"];
		networkAlert.cancelButtonIndex = 0;
		[networkAlert show];
		//[Common showConnectionAlert];
	}
	[pool release];
}



- (void)keyboardWillShow:(NSNotification *)notification {
	// locate keyboard view
   
        [basePicker selectRow:0 inComponent:0 animated:YES];
	UIWindow *tempWindow = [[[UIApplication sharedApplication] windows] objectAtIndex:1];
	UIView *keyboard;
	for (int i = 0; i < [tempWindow.subviews count]; i++) {
		keyboard = [tempWindow.subviews objectAtIndex:i];
		// keyboard view found; add the Custom button to it
		if ([[keyboard description] hasPrefix:@"<UIPeripheralHostView"] == YES) {
            Base *base = [baseArray objectAtIndex:0];
            baseLabel.text=[NSString stringWithFormat:@"%@",base.baseName];
            self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(dismissKeyboard:)  ] autorelease];
			
			self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancelEdit:)] autorelease];
		}
	}
}

- (IBAction) cancelEdit:(id)sender
{
		[baseLabel setText:@""];
		[self.baseLabel resignFirstResponder];

	self.navigationItem.leftBarButtonItem = nil;
	self.navigationItem.rightBarButtonItem = nil;
    self.navigationItem.leftBarButtonItem = customBarItem;
    [self.driverTableView reloadData];
	
}

- (IBAction)dismissKeyboard:(id)sender
{
	if([self.baseLabel isFirstResponder]){
	[self.baseLabel resignFirstResponder];
	self.navigationItem.leftBarButtonItem = nil;
	self.navigationItem.rightBarButtonItem = nil;
        self.navigationItem.leftBarButtonItem = customBarItem;
        if (![self.baseLabel.text isEqualToString:@""]) {
            [NSThread detachNewThreadSelector:@selector(getBasesDrivers) toTarget: self withObject: nil];

        }
    }
}


- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [baseArray count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
  
    Base *base = [baseArray objectAtIndex:row];
    return base.baseName;
}

- (void) pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    Base *base = [baseArray objectAtIndex:row];   
    baseLabel.text=[NSString stringWithFormat:@"%@",base.baseName];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
	return 1;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.baseLabel.text.length==0) {
        return 0;
    }
    else{
	return [driverArray count];
    }
}





- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {	
	
    static NSString *CellIdentifier = @"Cell";
    DriverWaitingTVC *cell = (DriverWaitingTVC *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell==nil){
        NSArray *toplevelObjects=[[NSBundle mainBundle] loadNibNamed:@"DriverWaitingTVC" owner:nil options:nil];
        
        
        for(id currentObject in toplevelObjects){
            
            if([currentObject isKindOfClass:[UITableViewCell class]]){
                cell=(DriverWaitingTVC *) currentObject;
                
                DriverWaiting *driver=[driverArray objectAtIndex:indexPath.row];
                cell.lblCabSeats.text=[NSString stringWithFormat:@"Capacity: %@ Seats",driver.cabCapacity];
                cell.lblWaitingTime.text=[NSString stringWithFormat:@"%@",driver.driverWaitingTime];
                cell.lblDriverNo.text=[NSString stringWithFormat:@"Driver No: %@",driver.driverID];
                cell.lblSNo.text=[NSString stringWithFormat:@"%ld.",(long)(indexPath.row+1)];   //64-bit modification
                NSInteger currentDriverID=[Common loggedInDriverNo];
               
                
                if (currentDriverID ==[driver.driverID intValue]) {
                    cell.backgroundView = [ [[UIImageView alloc] initWithImage:[ [UIImage imageNamed:@"tableViewCellBackground.png"] stretchableImageWithLeftCapWidth:0.0 topCapHeight:5.0] ]autorelease];
                }
                else{
                cell.backgroundView = [ [[UIImageView alloc] initWithImage:[ [UIImage imageNamed:@"tableViewCellBackground_unselected.png"] stretchableImageWithLeftCapWidth:0.0 topCapHeight:5.0] ]autorelease];
                }
                }
                
            }
            
        }
        return cell;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillDisappear:(BOOL)animtated {
	self.navigationItem.leftBarButtonItem = nil;
	self.navigationItem.rightBarButtonItem = nil;
	[HUD hide:YES];
	[[NSNotificationCenter defaultCenter] removeObserver:self];
    if(updatetimer!=nil){
		[updatetimer invalidate];
		updatetimer=nil;
    }
    
}
    
    - (void)dealloc {
        [dropRejectedAlert release];
        [travelarray release];
        [newJnyAlert release];
        [journey release];
        [updatetimer release];
        [super dealloc];
    }
    
    
    @end
