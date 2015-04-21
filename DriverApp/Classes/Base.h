//
//  Base.h
//  driverApp
//
//  Created by Nagraj on 08/11/12.
//
//

#import <Foundation/Foundation.h>

@interface Base : NSObject
{
    NSString *baseName;
    NSString *baseID;
}
@property (nonatomic, retain) NSString *baseName;
@property (nonatomic,retain) NSString *baseID;
@end
