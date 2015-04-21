//
//  TableViewCell.h
//  driverApp
//
//  Created by Nagraj Gopalakrishnan on 14/11/11.
//  Copyright 2011 Apppli. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TableViewCell : UITableViewCell {
	IBOutlet UILabel *timeLabel;
	IBOutlet UILabel *fromAddress;
	IBOutlet UILabel *toAddress;
	IBOutlet UILabel *fare;
	
}
@property(nonatomic, retain) IBOutlet UILabel *timeLabel;
@property(nonatomic, retain) IBOutlet UILabel *fromAddress;
@property(nonatomic, retain) IBOutlet UILabel *toAddress;
@property(nonatomic, retain) IBOutlet UILabel *fare;



@end
