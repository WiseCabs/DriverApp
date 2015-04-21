//
//  segmentControl.h
//  driverApp
//
//  Created by Nagraj Gopalakrishnan on 15/11/11.
//  Copyright 2011 Apppli. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ScheduleJourneyDetailss : UIViewController<UITableViewDataSource, UITableViewDelegate>
{
	UITableView *tableView;
	NSArray *travelarray;
	IBOutlet UISegmentedControl *segmentControl;
	
}

@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) NSArray *travelarray;
@property (nonatomic, retain) IBOutlet UISegmentedControl *segmentControl;

@end
