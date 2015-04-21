//
//  DetailTableViewCell.h
//  driverApp
//
//  Created by Nagraj Gopalakrishnan on 17/11/11.
//  Copyright 2011 Apppli. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface DetailTableViewCell : UITableViewCell {
	IBOutlet UILabel *fromAddress;
	IBOutlet UILabel *toAddress;
	IBOutlet UILabel *fare;
	IBOutlet UIButton *pickUpButton;
	IBOutlet UIButton *dropOffButton;
	IBOutlet UILabel *customerName;
	IBOutlet UIButton *customerMobile;
	IBOutlet UILabel *additionalInfo;
}
@property(nonatomic,retain) IBOutlet UIButton *pickUpButton;
@property(nonatomic,retain) IBOutlet UIButton *dropOffButton;
@property(nonatomic,retain) IBOutlet UILabel *fromAddress;
@property(nonatomic,retain) IBOutlet UILabel *toAddress;
@property(nonatomic,retain) IBOutlet UILabel *fare;

@property(nonatomic,retain) IBOutlet UILabel *customerName;
@property(nonatomic,retain) IBOutlet UIButton *customerMobile;
@property(nonatomic,retain) IBOutlet UILabel *additionalInfo;

@end
