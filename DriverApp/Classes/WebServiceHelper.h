//
//  WebServiceHelper.h
//  driverApp
//
//  Created by Nagraj Gopalakrishnan on 22/11/11.
//  Copyright 2011 Apppli. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface WebServiceHelper : NSObject {
	
	NSObject *objEntity;
	NSArray *resultArray;
}

@property(nonatomic, retain) NSObject *objEntity;
@property(nonatomic, retain) NSArray *resultArray;
//-(WebServiceHelper *) initWebServerHelper;
-(NSArray *) callWebService: (NSString *)webServiceURL pms:(NSDictionary *)params;
-(NSMutableURLRequest *) getWebServiceURL: (NSString *)webServiceURL pms:(NSDictionary *)params;

@end
