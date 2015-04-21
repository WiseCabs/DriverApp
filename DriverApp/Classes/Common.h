//
//  Common.h
//  driverApp
//
//  Created by Nagraj G on 24/11/11.
//  Copyright 2011 Apppli Consulting Pvt Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Common : NSObject {

}
+ (NSString*)webserviceURL;
+ (NSString*)loggeduserId;
+ (NSString*)loggedUserpassword;

+ (void)setWebServiceURL:(NSString*)newUrl;
+ (NSInteger)loggedInDriverID;
+ (void)setLoggedInDriver:(NSInteger)driverID;

+ (void)setUserId:(NSString*)UserId;
+ (void)setPassword:(NSString*)Password;

+ (void)showAlert:(NSString*) title message:(NSString*)msg;
+ (void)showNetwokAlert;
- (NSDictionary *)readPlist; 
- (void)writePlist:(NSDictionary *)keys; 
+ (NSString*)driverStatus;
+ (void)setdriverStatus:(NSString*)driverStatus;
+ (NSInteger)isNetworkExist;
+ (NSString *)currencySymbol;
+ (void)setdropCompleteStatus:(NSString*)dropCompleteStatus;
+ (NSString*)dropCompleteStatus;
+ (NSInteger)noOfPastJourneys ;
+ (void)setNoOfPastJourneys:(NSInteger)noOfPastJourneys;

+ (NSInteger)supplierID ;
+ (void)setSupplierID:(NSInteger)supplierID;

+ (void)setLoggedInDriverNo:(NSInteger)driverNo;
+ (NSInteger)loggedInDriverNo;

@end
