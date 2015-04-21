//
//  segmentControl.m
//  driverApp
//
//  Created by Nagraj Gopalakrishnan on 15/11/11.
//  Copyright 2011 Apppli. All rights reserved.
//

#import "segmentControl.h"
#import "JSON.h"
#import "TableViewCell.h"

@implementation segmentControl
//@synthesize tableView;
//@synthesize travelarray;

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


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	//UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(16, 26, 31, 31)];
	
	
	NSString *json=@"[{\"type\":\"scheduled\",\"Date\":\"01-01-01\",\"Time\":\"05:00\",\"To\":\"404,Edgware Road, London,\",\"From\":\"Burkimgham Palace\",\"NoOfpassengers\":\"5\",\"Fare\":\"40 Euro\"},{\"type\":\"scheduled\",\"Date\":\"01-01-01\",\"Time\":\"05:00\",\"To\":\"404,Edgware Road, London,\",\"From\":\"Burkimgham Palace\",\"NoOfpassengers\":\"5\",\"Fare\":\"40 Euro\"},{\"type\":\"scheduled\",\"Date\":\"01-01-01\",\"Time\":\"05:00\",\"To\":\"404,Edgware Road, London,\",\"From\":\"Burkimgham Palace\",\"NoOfpassengers\":\"5\",\"Fare\":\"40 Euro\"},{\"type\":\"scheduled\",\"Date\":\"01-01-01\",\"Time\":\"05:00\",\"To\":\"404,Edgware Road, London,\",\"From\":\"Burkimgham Palace\",\"NoOfpassengers\":\"5\",\"Fare\":\"40 Euro\"},{\"type\":\"scheduled\",\"Date\":\"01-01-01\",\"Time\":\"05:00\",\"To\":\"404,Edgware Road, London,\",\"From\":\"Burkimgham Palace\",\"NoOfpassengers\":\"5\",\"Fare\":\"40 Euro\"},{\"type\":\"scheduled\",\"Date\":\"01-01-01\",\"Time\":\"05:00\",\"To\":\"404,Edgware Road, London,\",\"From\":\"Burkimgham Palace\",\"NoOfpassengers\":\"5\",\"Fare\":\"40 Euro\"},{\"type\":\"scheduled\",\"Date\":\"01-01-01\",\"Time\":\"05:00\",\"To\":\"404,Edgware Road, London,\",\"From\":\"Burkimgham Palace\",\"NoOfpassengers\":\"5\",\"Fare\":\"40 Euro\"},{\"type\":\"scheduled\",\"Date\":\"01-01-01\",\"Time\":\"05:00\",\"To\":\"404,Edgware Road, London,\",\"From\":\"Burkimgham Palace\",\"NoOfpassengers\":\"5\",\"Fare\":\"40 Euro\"},{\"type\":\"scheduled\",\"Date\":\"01-01-01\",\"Time\":\"05:00\",\"To\":\"404,Edgware Road, London,\",\"From\":\"Burkimgham Palace\",\"NoOfpassengers\":\"5\",\"Fare\":\"40 Euro\"},{\"type\":\"scheduled\",\"Date\":\"01-01-01\",\"Time\":\"05:00\",\"To\":\"404,Edgware Road, London,\",\"From\":\"Burkimgham Palace\",\"NoOfpassengers\":\"5\",\"Fare\":\"40 Euro\"},{\"type\":\"scheduled\",\"Date\":\"01-01-01\",\"Time\":\"05:00\",\"To\":\"404,Edgware Road, London,\",\"From\":\"Burkimgham Palace\",\"NoOfpassengers\":\"5\",\"Fare\":\"40 Euro\"},{\"type\":\"scheduled\",\"Date\":\"01-01-01\",\"Time\":\"05:00\",\"To\":\"404,Edgware Road, London,\",\"From\":\"Burkimgham Palace\",\"NoOfpassengers\":\"5\",\"Fare\":\"40 Euro\"},{\"type\":\"scheduled\",\"Date\":\"01-01-01\",\"Time\":\"05:00\",\"To\":\"404,Edgware Road, London,\",\"From\":\"Burkimgham Palace\",\"NoOfpassengers\":\"5\",\"Fare\":\"40 Euro\"},{\"type\":\"scheduled\",\"Date\":\"01-01-01\",\"Time\":\"05:00\",\"To\":\"404,Edgware Road, London,\",\"From\":\"Burkimgham Palace\",\"NoOfpassengers\":\"5\",\"Fare\":\"40 Euro\"},{\"type\":\"scheduled\",\"Date\":\"01-01-01\",\"Time\":\"05:00\",\"To\":\"404,Edgware Road, London,\",\"From\":\"Burkimgham Palace\",\"NoOfpassengers\":\"5\",\"Fare\":\"40 Euro\"},{\"type\":\"scheduled\",\"Date\":\"01-01-01\",\"Time\":\"05:00\",\"To\":\"404,Edgware Road, London,\",\"From\":\"Burkimgham Palace\",\"NoOfpassengers\":\"5\",\"Fare\":\"40 Euro\"},{\"type\":\"scheduled\",\"Date\":\"02-02-02\",\"Time\":\"11:00\",\"To\":\"404,Burkingham palace\",\"From\":\"404,Edgware Road, London\",\"NoOfpassengers\":\"4\",\"Fare\":\"40 Euro\"},{\"type\":\"scheduled\",\"Date\":\"01-01-01\",\"Time\":\"05:00\",\"To\":\"404,Edgware Road, London\",\"From\":\"Burkimgham Palace\",\"NoOfpassengers\":\"5\",\"Fare\":\"40 Euro\"},{\"type\":\"scheduled\",\"Date\":\"02-02-02\",\"Time\":\"11:00\",\"To\":\"404,Burkingham palace\",\"From\":\"404,Edgware Road, London\",\"NoOfpassengers\":\"4\",\"Fare\":\"40 Euro\"},{\"type\":\"scheduled\",\"Date\":\"01-01-01\",\"Time\":\"05:00\",\"To\":\"404,Edgware Road, London\",\"From\":\"Burkimgham Palace\",\"NoOfpassengers\":\"5\",\"Fare\":\"40 Euro\"},{\"type\":\"scheduled\",\"Date\":\"02-02-02\",\"Time\":\"11:00\",\"To\":\"404,Burkingham palace\",\"From\":\"404,Edgware Road, London\",\"NoOfpassengers\":\"4\",\"Fare\":\"40 Euro\"}]";
	
	//self.title=@"Schedule ";
	
  //  travelarray = [[json JSONValue] retain];
	
    //tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
	
    //tableView.delegate = self;
	
    //tableView.dataSource = self;
	
   // [tableView reloadData];
	
	
	
    //self.view = tableView;
	
    //[tableView release];
   // [super viewDidLoad];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
	return 1;
	
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
	//return [travelarray count];
	
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
				//NSString* address = [[travelarray objectAtIndex:[indexPath row]] objectForKey:@"To"];
				//cell.Address.text=[NSString stringWithFormat:@"To: %@",address];									
				//cell.timeLabel.text=[NSString stringWithFormat:@"Time: %@",[[travelarray objectAtIndex:[indexPath row]] objectForKey:@"Time"]];
				//cell.noOfPasenger.text=[[travelarray objectAtIndex:[indexPath row]] objectForKey:@"NoOfpassengers"];
				//cell.noOfPasenger.text=[NSString stringWithFormat:@"Passengers: %@",[[travelarray objectAtIndex:[indexPath row]] objectForKey:@"NoOfpassengers"]];
				//cell.Address.text=[[travelarray objectAtIndex:[indexPath row]] objectForKey:@"To"];
				//cell.Address.text=[NSString stringWithFormat:@"To: %@",[[travelarray objectAtIndex:[indexPath row]] objectForKey:@"To"]];
				
				break;
			}
			
		}
		
	}
	
	return cell;
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
   // [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
   // [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    //[super dealloc];
}


@end
