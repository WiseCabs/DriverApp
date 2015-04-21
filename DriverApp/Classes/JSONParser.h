//
//  JSONParser.h
//  driverApp
//
//  Created by Nagraj G on 23/11/11.
//  Copyright 2011 Apppli Consulting Pvt Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface JSONParser : NSObject {
	NSObject *objEntity;
	NSMutableArray *resultArray;
	NSNumberFormatter* fmtr ;
}
@property(nonatomic, retain) NSObject *objEntity;
@property(nonatomic, retain) NSMutableArray *resultArray;
@property(nonatomic, retain)  NSNumberFormatter* fmtr ;
//- (JSONParser *) initJSONParser;
- (NSArray *)getParsedEntities:(NSString *)jsonData;
-(void)getAllocatedJournies:(NSArray*)allocateJourneyArray;
@end
