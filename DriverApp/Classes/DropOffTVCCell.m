//
//  DropOffTVCCell.m
//  driverApp
//
//  Created by Nagraj on 24/12/12.
//
//

#import "DropOffTVCCell.h"

@implementation DropOffTVCCell
@synthesize dropOffButton,toAddress;

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
	[dropOffButton release];
	[toAddress release];
    [super dealloc];
}

@end
