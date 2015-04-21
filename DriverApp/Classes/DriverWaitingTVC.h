//
//  DriverWaitingTVC.h
//  driverApp
//
//  Created by Nagraj on 08/11/12.
//
//

#import <UIKit/UIKit.h>

@interface DriverWaitingTVC : UITableViewCell
{
    IBOutlet UILabel *lblWaitingTime;
    IBOutlet UILabel *lblCabSeats;
    IBOutlet UILabel *lblDriverNo;
    IBOutlet UILabel *lblSNo;
}
@property(nonatomic,retain) IBOutlet UILabel *lblWaitingTime;
@property(nonatomic,retain) IBOutlet UILabel *lblCabSeats;
@property(nonatomic,retain) IBOutlet UILabel *lblDriverNo;
@property(nonatomic,retain) IBOutlet UILabel *lblSNo;
@end
