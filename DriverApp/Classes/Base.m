//
//  Base.m
//  driverApp
//
//  Created by Nagraj on 08/11/12.
//
//

#import "Base.h"

@implementation Base

@synthesize baseName,baseID;


- (void)dealloc {
[baseName release];
[baseID release];
[super dealloc];
}

@end
