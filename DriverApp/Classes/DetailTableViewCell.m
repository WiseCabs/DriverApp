//
//  DetailTableViewCell.m
//  driverApp
//
//  Created by Nagraj Gopalakrishnan on 17/11/11.
//  Copyright 2011 Apppli. All rights reserved.
//

#import "DetailTableViewCell.h"

@implementation DetailTableViewCell
@synthesize pickUpButton,fromAddress;
@synthesize dropOffButton,toAddress;
@synthesize fare,customerName,customerMobile,additionalInfo;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code.
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state.
}


- (void)dealloc {
	[fare release];
	[customerName release];
	[customerMobile release];
	[additionalInfo release];
	[pickUpButton release];
	[dropOffButton release];
	[fromAddress release];
	[toAddress release];
    [super dealloc];
}


@end
