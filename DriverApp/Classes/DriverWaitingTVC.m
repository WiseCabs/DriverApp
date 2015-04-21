//
//  DriverWaitingTVC.m
//  driverApp
//
//  Created by Nagraj on 08/11/12.
//
//

#import "DriverWaitingTVC.h"

@implementation DriverWaitingTVC
@synthesize lblCabSeats,lblWaitingTime,lblDriverNo,lblSNo;



- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
   // [lblCabSeats release];
    //[lblWaitingTime release];
    //[lblDriverNo release];
   // [lblSNo release];
    
    [super dealloc];
}

@end

