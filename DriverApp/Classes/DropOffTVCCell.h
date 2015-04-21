//
//  DropOffTVCCell.h
//  driverApp
//
//  Created by Nagraj on 24/12/12.
//
//

#import <UIKit/UIKit.h>

@interface DropOffTVCCell : UITableViewCell
{
    IBOutlet UIButton *dropOffButton;
    IBOutlet UILabel *toAddress;
}
@property(nonatomic,retain) IBOutlet UIButton *dropOffButton;
@property(nonatomic,retain) IBOutlet UILabel *toAddress;


@end
