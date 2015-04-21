//
//  DriverWaiting.m
//  driverApp
//
//  Created by Nagraj on 08/11/12.
//
//

#import "DriverWaiting.h"

@implementation DriverWaiting
@synthesize driverID,driverWaitingTime,driverName,cabCapacity,waitingMinutes;


- (void)dealloc {
    [driverName release];
    [driverID release];
    [driverWaitingTime release];
    [cabCapacity release];
    [super dealloc];
}

@end
