//
//  TableViewCell.m
//  driverApp
//
//  Created by Nagraj Gopalakrishnan on 14/11/11.
//  Copyright 2011 Apppli. All rights reserved.
//

#import "TableViewCell.h"


@implementation TableViewCell
@synthesize timeLabel;
@synthesize fromAddress,toAddress;
@synthesize fare;


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
	[timeLabel release];
	[fromAddress release];
	[toAddress release];
	[fare release];
    [super dealloc];
}


@end
