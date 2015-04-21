//
//  NextPickUpDetails.m
//  driverApp
//
//  Created by Nagraj Gopalakrishnan on 02/08/12.
//  Copyright 2012 Apppli. All rights reserved.
//

#import "NextPickUpDetails.h"
#import "DetailTableViewCell.h"
#import "Journey.h"
#import "Common.h"

@implementation NextPickUpDetails
@synthesize pickUpTableView,tableBackgroudImage,selectedJourney,pickUpsArray,journeyType;

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


- (void)viewDidLoad {
	pickUpButtonNo=0;
	dropOffButtonNo=2;
	pickUpTableView.separatorColor=[UIColor clearColor];
	self.navigationItem.title=@"Pick Up(s)";
	pickUpsArray= [[NSMutableArray alloc] init];

	if ([[selectedJourney SubJourney] count]==2) {
		[pickUpsArray addObject:[[selectedJourney SubJourney] objectAtIndex:1]];
		
	}else if ([[selectedJourney SubJourney] count]==3) {
		[pickUpsArray addObject:[[selectedJourney SubJourney] objectAtIndex:1]];
		[pickUpsArray addObject:[[selectedJourney SubJourney] objectAtIndex:2]];
	}
	
	
    [super viewDidLoad];
    
    self.navigationController.navigationBar.translucent = NO;

}




/*
- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//headerView.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"loginButtonBackgroundImage.png"]]; 
	UIView *headerView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 30)] autorelease];
	[headerView setBackgroundColor:[UIColor clearColor]];
	UILabel *label = [[[UILabel alloc] initWithFrame:CGRectMake(10, 3, tableView.bounds.size.width - 10, 18)] autorelease];
	label.textColor = [UIColor blueColor];
	label.font = [UIFont systemFontOfSize:22];
	label.backgroundColor = [UIColor clearColor];
	if(section==0)
		label.text=@"Second Pick up: ";
	//label.text=@"";
	else
		label.text=@"Third Pick up: ";
	//label.text=@"";
	[headerView addSubview:label];
	return headerView;
}*/



- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	NSString *headerTitle;
	if(section==0)
		headerTitle=@"Second Pick up: ";
	//label.text=@"";
	else
		headerTitle=@"Third Pick up: ";
	
	return headerTitle;
	
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
	return [pickUpsArray count];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
	
   // NSInteger pickUpCount=[[selectedJourney SubJourney] count]-1;
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
		DetailTableViewCell *cell = (DetailTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		
		if(cell==nil){
			NSArray *toplevelObjects=[[NSBundle mainBundle] loadNibNamed:@"DetailTableViewCell" owner:nil options:nil];
			
			
			for(id currentObject in toplevelObjects){
				
				if([currentObject isKindOfClass:[UITableViewCell class]]){
					cell=(DetailTableViewCell *) currentObject;
					
					Journey *jny=[pickUpsArray objectAtIndex:indexPath.section];
					selectedRow=indexPath.section;
					//=[pickUpArray objectAtIndex:indexPath.row];	
					//=[[selectedJourney SubJourney] objectAtIndex:indexPath.row+1];
					//cell.backgroundView = [ [[UIImageView alloc] initWithImage:[ [UIImage imageNamed:@"country-details.png"] stretchableImageWithLeftCapWidth:0.0 topCapHeight:5.0] ]autorelease];
					
					
					//cell.fromAddress1.text=[NSString stringWithFormat:@"%@,%@,%@",jny.FromHouseNumber,jny.FromStreetNumber,jny.FromLocalityName];
					//cell.fromAddress2.text=[NSString stringWithFormat:@"%@,%@",jny.FromLocationName,jny.FromPostalCode];
					
					
					cell.fromAddress.text=[NSString stringWithFormat:@"%@",jny.FromAddress];
					cell.toAddress.text=[NSString stringWithFormat:@"%@",jny.ToAddress];
					cell.customerName.text=[NSString stringWithFormat:@"%@",jny.customerName];
					
					[cell.customerMobile setTitle:[NSString stringWithFormat:@"%@",jny.customerMobile] forState: UIControlStateNormal];
					cell.customerMobile.tag=indexPath.section;
					[cell.customerMobile addTarget:self action:@selector(callpassengerAction:) forControlEvents:UIControlEventTouchUpInside];


					cell.additionalInfo.text=[NSString stringWithFormat:@"%@",jny.customerInfo];
					
					float Indfare=(float)[jny.JourneyFare intValue]/(float)selectedJourney.TotalNumberOfPassenger;
					
					
					cell.fare.text=[NSString stringWithFormat:@"%@%.2f",[Common currencySymbol], jny.NumberOfPassenger*Indfare];
					cell.selectionStyle = UITableViewCellSelectionStyleNone;
				
					//64-bit modification
					int pickUpButtonVal = [[NSString stringWithFormat:@"%ld%ld",(long)indexPath.row, (long)indexPath.section] intValue];
					cell.pickUpButton.tag = pickUpButtonVal;
					[cell.pickUpButton addTarget:self action:@selector(directionToPickUp:) forControlEvents:UIControlEventTouchUpInside];
					int dropOffButtonVal = [[NSString stringWithFormat:@"%ld%ld",(long)indexPath.row, (long)indexPath.section] intValue];
					cell.dropOffButton.tag = dropOffButtonVal;
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
				
			}
			
		}
	
	return cell;
	
	
}


-(IBAction)callpassengerAction:(UIButton*)button{
	
		//the label that was tapped
		Journey *jny=[pickUpsArray objectAtIndex:button.tag];
		NSString *mobile=[NSString stringWithFormat:@"tel://%@",jny.customerMobile];
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:mobile]];

}


-(IBAction)directionToPickUp:(UIButton*)button{
	
	
	Journey *jny=[pickUpsArray objectAtIndex:button.tag];
	NSString *fromAddress=@"";
	fromAddress=jny.FromAddress;
	NSString *urlString = [NSString stringWithFormat:@"http://maps.google.com/maps?saddr=Current Location&daddr=%@",fromAddress];
	//NSString *urlString = [NSString stringWithFormat:@"http://maps.google.com/maps?saddr=London City Airport&daddr=%@",fromAddress];
	
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] ]];
}

-(IBAction)directionToDropOff:(UIButton*)button{
	Journey *jny=[pickUpsArray objectAtIndex:selectedRow];
	NSString *toAddress=@"";
	toAddress=jny.ToAddress;
	NSString *urlString = [NSString stringWithFormat:@"http://maps.google.com/maps?saddr=Current Location&daddr=%@",toAddress];
	//NSString *urlString = [NSString stringWithFormat:@"http://maps.google.com/maps?saddr=London City Airport&daddr=%@",toAddress];
	
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] ]];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
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
	[pickUpTableView release];
	[pickUpsArray release];
	[tableBackgroudImage release];
	[selectedJourney release];
	[journeyType release];
    [super dealloc];
}


@end
