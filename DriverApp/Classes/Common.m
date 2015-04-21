//
//  Common.m
//  driverApp
//
//  Created by Nagraj G on 24/11/11.
//  Copyright 2011 Apppli Consulting Pvt Ltd. All rights reserved.
//

#import "Common.h"
#import "Reachability.h"
#import <SystemConfiguration/SystemConfiguration.h>
#include <netinet/in.h>

static NSString* url;
static NSInteger driverid;
static NSInteger noOfPastJnys;
static NSString *uid;
static NSString *pwd;
static NSString* driveStatus;
static NSString* dropStatus;
static NSInteger suppID;
static NSInteger driverno;
@implementation Common


+ (NSString*)webserviceURL {
    return url;
}

+ (void)setWebServiceURL:(NSString*)newUrl{
	if (url != newUrl) {
        [url release];
        url = [newUrl copy];
    }
	
}
+ (NSString*)loggeduserId
{ 
	return uid;
}

+ (NSString*)loggedUserpassword
{
	return pwd;
}

+(void)setUserId:(NSString*)userId
{
	if (uid != userId) {
        [uid release];
        uid = [userId copy];
    }
	
}
+ (void)setPassword:(NSString*)password
{
	if (pwd != password) {
        [pwd release];
        pwd = [password copy];
    }
	
}


+ (NSInteger)loggedInDriverID {
    return driverid;
}

+ (void)setLoggedInDriver:(NSInteger)driverID{
	if (driverid != driverID) {
        driverid = driverID;
		
    }
	
}

+ (NSInteger)loggedInDriverNo {
    return driverno;
}

+ (void)setLoggedInDriverNo:(NSInteger)driverNo{
	if (driverno != driverNo) {
        driverno = driverNo;
		
    }
	
}


+ (NSInteger)noOfPastJourneys {
    return noOfPastJnys;
}

+ (void)setNoOfPastJourneys:(NSInteger)noOfPastJourneys{
	if (noOfPastJnys != noOfPastJourneys) {
        noOfPastJnys = noOfPastJourneys;
		
    }
	
}


+ (NSInteger)supplierID {
    return suppID;
}

+ (void)setSupplierID:(NSInteger)supplierID{
	if (suppID != supplierID) {
        suppID = supplierID;
		
    }
	
}



+ (NSString*)driverStatus {
    return driveStatus;
}

+ (void)setdriverStatus:(NSString*)driverStatus{
	if (driveStatus != driverStatus) {
        [driveStatus release];
        driveStatus = [driverStatus copy];
    }
	
}

+ (NSString*)dropCompleteStatus{
    return dropStatus;
}

+ (void)setdropCompleteStatus:(NSString*)dropCompleteStatus{
	if (dropStatus != dropCompleteStatus) {
        [dropStatus release];
        dropStatus = [dropCompleteStatus copy];
    }
	
}



+ (void)showNetwokAlert
{
	[self showAlert:@"Network Error" message:@"No Internet Available" ];
}

+ (NSInteger)isNetworkExist
{
	Reachability *r = [Reachability reachabilityWithHostName:@"www.google.com"];
	NetworkStatus internetStatus = [r currentReachabilityStatus];
	if ((internetStatus != ReachableViaWiFi) && (internetStatus != ReachableViaWWAN))
	{
		return 0;
	}else {
		return 1;
	}

}

+ (void)showAlert:(NSString*)title message:(NSString*)msg
{
	UIAlertView *InternetConnectionAlert = [[UIAlertView alloc] initWithTitle:title message:msg delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
	[InternetConnectionAlert show];
	//[InternetConnectionAlert release];
}


-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (buttonIndex==0) {
	}
	else {
	}


}

+ (NSString *)currencySymbol
{
	NSLocale* london = [[NSLocale alloc] initWithLocaleIdentifier:@"en_GB"];
	NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
	[formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
	[formatter setLocale:london];
	[london release];
	london=nil;
	
	NSString *currencySymbol=[formatter currencySymbol];
	[formatter release];
	return currencySymbol;
}

- (NSDictionary *)readPlist{
	
	//reading data from plist
	NSArray *paths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
	// get documents path
	NSString *documentsPath = [paths objectAtIndex:0];
	// get the path to our Data/plist file
	NSString *plistPath = [documentsPath stringByAppendingPathComponent:@"Custom.plist"];
	
	// check to see if Data.plist exists in documents
	if (![[NSFileManager defaultManager] fileExistsAtPath:plistPath]) 
	{
		// if not in documents, get property list from main bundle
		plistPath = [[NSBundle mainBundle] pathForResource:@"Custom" ofType:@"plist"];
	}
	
	// read property list into memory as an NSData object
	NSData *plistXML = [[NSFileManager defaultManager] contentsAtPath:plistPath];
	
	NSString *errorDesc = nil;
	NSPropertyListFormat format;
	// convert static property liost into dictionary object
	NSDictionary *temp = (NSDictionary *)[NSPropertyListSerialization propertyListFromData:plistXML mutabilityOption:NSPropertyListMutableContainersAndLeaves format:&format errorDescription:&errorDesc];

	for (id key in temp) {
		
		
    }
	if (!temp) 
	{
	}	
	return temp;
}


- (void)writePlist:(NSDictionary *)keys {
	//Saving Data to Custom.plist
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
	// get documents path
	NSString *documentsPath = [paths objectAtIndex:0];
	// get the path to our Data/plist file
	NSString *plistPath = [documentsPath stringByAppendingPathComponent:@"Custom.plist"];
	
	NSString *error = nil;
	// create NSData from dictionary
	NSData *plistData = [NSPropertyListSerialization dataFromPropertyList:keys format:NSPropertyListXMLFormat_v1_0 errorDescription:&error];
	
	// check is plistData exists
	if(plistData) 
	{
		// write plistData to our Data.plist file
		[plistData writeToFile:plistPath atomically:YES];
	}
	else 
	{
		[error release];
	}
	
}
@end
