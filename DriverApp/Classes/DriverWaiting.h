//
//  DriverWaiting.h
//  driverApp
//
//  Created by Nagraj on 08/11/12.
//
//

#import <Foundation/Foundation.h>

@interface DriverWaiting : NSObject
{
    NSString *driverName;
    NSString *driverID;
    NSString *driverWaitingTime;
    NSString *cabCapacity;
    NSInteger waitingMinutes;
}
 @property (nonatomic, readwrite)NSInteger waitingMinutes;
@property (nonatomic, retain) NSString *driverName;
@property (nonatomic,retain) NSString *driverID;
@property (nonatomic, retain) NSString *driverWaitingTime;
@property (nonatomic, retain) NSString *cabCapacity;

@end
