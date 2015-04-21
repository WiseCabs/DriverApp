//
//  JSONParser.m
//  driverApp
//
//  Created by Nagraj G on 23/11/11.
//  Copyright 2011 Apppli Consulting Pvt Ltd. All rights reserved.
//

#import "JSONParser.h"
#import "JSON.h"
#import "AllocatedJourney.h"
#import "Journey.h"
#import "Common.h"
#import "Base.h"
#import "DriverWaiting.h"

@implementation JSONParser

@synthesize  objEntity,resultArray,fmtr;

/*- (JSONParser *) initJSONParser{
	[super init];`
	self.objEntity = [[NSObject alloc] init];
	return self;
}*/

- (NSArray *)getParsedEntities:(NSString *)jsonData
{
    
	NSMutableArray *jsonresultArray=[jsonData JSONValue];
	//if(resultArray!=nil){
	//	[resultArray release];
	//	resultArray=nil;
	//}
    
	if([self.objEntity isKindOfClass:[AllocatedJourney class]])
	{
        [self getAllocatedJournies:jsonresultArray];
        
	}
    
   else if([self.objEntity isKindOfClass:[Base class]]){
        [self getBases:jsonresultArray];
    }
    
    else if([self.objEntity isKindOfClass:[DriverWaiting class]]){
        [self getAllocatedDriverWaitingDetails:jsonresultArray];
    }
    else
	{
		
        
		self.resultArray=jsonresultArray;
        
	}
    return [self resultArray];
}

///////////////////////Get base details of Supplier///////////////////////////////
-(void)getBases:(NSArray*)allocateBasesArray{
    NSMutableArray *test=[[NSMutableArray alloc]init];
	self.resultArray=test;
	[test release];
	test=nil;
    for(id currentObject in allocateBasesArray){
      //  AllocatedJourney * allocatedJourney=[[AllocatedJourney alloc] init];
        if ([[currentObject objectForKey:@"success"] isEqualToString:@"true"]) {
                Base *base=[[Base alloc]init];
                base.baseName=[currentObject objectForKey:@"Zone_Name"];
                [resultArray addObject:base];
                //base.baseID=[bs objectForKey:@""];
       
    }
    }
}


//////////////////////////Get Driver Waiting details from selected Base//////////////

    -(void)getAllocatedDriverWaitingDetails:(NSArray*)allocateDriversArray{
        NSMutableArray *test=[[NSMutableArray alloc]init];
        self.resultArray=test;
        [test release];
        test=nil;
        
        for(id currentObject in allocateDriversArray){
            if ([[currentObject objectForKey:@"success"] isEqualToString:@"true"]) {
                    DriverWaiting *driverWaiting=[[DriverWaiting alloc]init];
                    driverWaiting.driverID=[currentObject objectForKey:@"Driver_Number"];
                
                NSString *driverName=@"";
                
                if ((NSString *)[NSNull null]!=[currentObject objectForKey:@"First_Name"] && [[[currentObject objectForKey:@"First_Name"] stringByReplacingOccurrencesOfString:@" " withString:@"" ] length]>0) {
                    driverName  =[NSString stringWithFormat:@"%@",[currentObject objectForKey:@"First_Name"]];
                                  }

                
                if ((NSString *)[NSNull null]!=[currentObject objectForKey:@"Last_Name"] && [[[currentObject objectForKey:@"Last_Name"] stringByReplacingOccurrencesOfString:@" " withString:@"" ] length]>0) {
                    driverName  =[NSString stringWithFormat:@"%@ %@",driverName,[currentObject objectForKey:@"Last_Name"]];
                }
                
                    driverWaiting.driverName=driverName;
                     driverWaiting.driverWaitingTime=[currentObject objectForKey:@"Waiting_Time"];
                
                NSArray *arrayWithTwoStrings = [driverWaiting.driverWaitingTime componentsSeparatedByString:@":"];
                
                NSInteger abc=([[arrayWithTwoStrings objectAtIndex:0] intValue]*60)+[[arrayWithTwoStrings objectAtIndex:1] intValue];
                
                driverWaiting.waitingMinutes=abc;
                driverWaiting.cabCapacity=[currentObject objectForKey:@"Capacity"];
                    [resultArray addObject:driverWaiting];
        
        }
        }
    }

-(void)getAllocatedJournies:(NSArray*)allocateJourneyArray
{
    NSMutableArray *test=[[NSMutableArray alloc]init];
	self.resultArray=test;
	[test release];
	test=nil;
	 for(id currentObject in allocateJourneyArray){
		 AllocatedJourney * allocatedJourney=[[AllocatedJourney alloc] init];
		 if ([[currentObject objectForKey:@"sucess"] isEqualToString:@"true"]) {
			 
		 
		 allocatedJourney.AllocatedJourneyID=[[currentObject objectForKey:@"AJ_ID"] intValue];
			 
			 NSString *dateString=[currentObject objectForKey:@"Date"];
			 NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init]; 
			 [dateFormat setDateFormat:@"dd/MM/yyyy"];
			 NSDate *date = [dateFormat dateFromString:dateString];
             
             NSString *timeString=[currentObject objectForKey:@"Time"];
			 NSDateFormatter *timeFormat = [[NSDateFormatter alloc] init];
			 [timeFormat setDateFormat:@"h:mm a"];
			 NSDate *time = [timeFormat dateFromString:timeString];
			 
             [dateFormat release];
             [timeFormat release];
             
			 NSString *address1=@"";
			  NSString *address2=@"";
			 if ((NSString *)[NSNull null]!=[currentObject objectForKey:@"From_House_No"] && [[[currentObject objectForKey:@"From_House_No"] stringByReplacingOccurrencesOfString:@" " withString:@"" ] length]>0) {
				 //[address1 stringByAppendingString:[NSString stringWithFormat:@"%@,",jny.FromHouseNumber]];
				 address1=[NSString stringWithFormat:@"%@,",[currentObject objectForKey:@"From_House_No"]];
				 
			 }
			 if ((NSString *)[NSNull null]!=[currentObject objectForKey:@"From_Street_Name"] && [[[currentObject objectForKey:@"From_Street_Name"] stringByReplacingOccurrencesOfString:@" " withString:@"" ] length]>0) {
				 //[address1 stringByAppendingString:[NSString stringWithFormat:@"%@,",jny.FromStreetNumber]];
				 address1=[NSString stringWithFormat:@"%@ %@",address1,[currentObject objectForKey:@"From_Street_Name"]];
			 }	
			 if ((NSString *)[NSNull null]!=[currentObject objectForKey:@"Start_Locality"] && [[[currentObject objectForKey:@"Start_Locality"] stringByReplacingOccurrencesOfString:@" " withString:@"" ] length]>0) {
				 //[address1 stringByAppendingString:[NSString stringWithFormat:@"%@,",jny.FromLocalityName]];
				 address1=[NSString stringWithFormat:@"%@",[currentObject objectForKey:@"Start_Locality"]];
			 }
			 if ((NSString *)[NSNull null]!=[currentObject objectForKey:@"Start_Location"] && [[[currentObject objectForKey:@"Start_Location"] stringByReplacingOccurrencesOfString:@" " withString:@"" ] length]>0)
			 {
				 
				 //if (![[currentObject objectForKey:@"Start_Location"] isEqualToString:@"0"]) {
					 address2=[NSString stringWithFormat:@"%@",[currentObject objectForKey:@"Start_Location"]];
				// }
				 
				 
                 
                 /*if ((NSString *)[NSNull null]!=[currentObject objectForKey:@"End_Location"] && [[[currentObject objectForKey:@"End_Location"] stringByReplacingOccurrencesOfString:@" " withString:@"" ] length]>0)
				 {*/

                 
                 
                 
				 if((NSString *)[NSNull null]!=[currentObject objectForKey:@"From_Post_Code"]&& [[[currentObject objectForKey:@"From_Post_Code"] stringByReplacingOccurrencesOfString:@" " withString:@"" ] length]>0){
					 address2=[NSString stringWithFormat:@"%@, %@",address2,[currentObject objectForKey:@"From_Post_Code"]];
				 }
				 
				 
				 
			 }else  if((NSString *)[NSNull null]!=[currentObject objectForKey:@"From_Post_Code"] && [[[currentObject objectForKey:@"From_Post_Code"] stringByReplacingOccurrencesOfString:@" " withString:@"" ] length]>0){
				 address2=[NSString stringWithFormat:@"%@",[currentObject objectForKey:@"From_Post_Code"]];
			 }
			 
			 
			 if (address2.length>0) {
				 allocatedJourney.FromAddress=[NSString stringWithFormat:@"%@ %@",address2,address1];
			 }else {
				 allocatedJourney.FromAddress=address1;
			 }
			 
			 
			 
		  /*allocatedJourney.FromLocalityName=[currentObject objectForKey:@"Start_Locality"];
		  allocatedJourney.FromLocationName=[currentObject objectForKey:@"Start_Location"];
		 allocatedJourney.FromHouseNumber=[currentObject objectForKey:@"From_House_No"];
		 allocatedJourney.FromStreetNumber=[currentObject objectForKey:@"From_Street_Name"];
		 allocatedJourney.FromPostalCode=[currentObject objectForKey:@"From_Post_Code"];*/
			 
			 
			 
			 NSString *address=@"";
			 if ((NSString *)[NSNull null]!=[currentObject objectForKey:@"To_House_No"] && [[[currentObject objectForKey:@"To_House_No"] stringByReplacingOccurrencesOfString:@" " withString:@"" ] length]>0) {
				 address=[NSString stringWithFormat:@"%@,",[currentObject objectForKey:@"To_House_No"]];
				 
				 //[address stringByAppendingString:[NSString stringWithFormat:@"%@,",jny.ToHouseNumber]];
			 }
			 if ((NSString *)[NSNull null]!=[currentObject objectForKey:@"To_Street_Name"] && [[[currentObject objectForKey:@"To_Street_Name"] stringByReplacingOccurrencesOfString:@" " withString:@"" ] length]>0) {
				 address=[NSString stringWithFormat:@"%@ %@,",address,[currentObject objectForKey:@"To_Street_Name"]];
				 
				 //[address stringByAppendingString:[NSString stringWithFormat:@"%@,",jny.ToStreetNumber]];
			 }	
			 if ((NSString *)[NSNull null]!=[currentObject objectForKey:@"End_Locality"] && [[[currentObject objectForKey:@"End_Locality"] stringByReplacingOccurrencesOfString:@" " withString:@"" ] length]>0) {
				 address=[NSString stringWithFormat:@"%@",[currentObject objectForKey:@"End_Locality"]];
				 
				 //[address stringByAppendingString:[NSString stringWithFormat:@"%@,",jny.ToLocalityName]];
			 }		
			 NSString *toaddress2=@"";
			 if ((NSString *)[NSNull null]!=[currentObject objectForKey:@"End_Location"] && [[[currentObject objectForKey:@"End_Location"] stringByReplacingOccurrencesOfString:@" " withString:@"" ] length]>0)
				 {
					// if (![[currentObject objectForKey:@"End_Location"] isEqualToString:@"0"]) {
					 toaddress2=[NSString stringWithFormat:@"%@",[currentObject objectForKey:@"End_Location"]];
					// }
					 if((NSString *)[NSNull null]!=[currentObject objectForKey:@"To_Post_Code"]  && [[[currentObject objectForKey:@"To_Post_Code"] stringByReplacingOccurrencesOfString:@" " withString:@"" ] length]>0){
						 toaddress2=[NSString stringWithFormat:@"%@, %@",toaddress2,[currentObject objectForKey:@"To_Post_Code"]];
						 
					 }
			 }else  if((NSString *)[NSNull null]!=[currentObject objectForKey:@"To_Post_Code"] && [[[currentObject objectForKey:@"To_Post_Code"] stringByReplacingOccurrencesOfString:@" " withString:@"" ] length]>0){
				 toaddress2=[NSString stringWithFormat:@"%@",[currentObject objectForKey:@"To_Post_Code"]];
			 }
			 
			 if (toaddress2.length>0) {
				 allocatedJourney.ToAddress=[NSString stringWithFormat:@"%@ %@",toaddress2,address];
				 //cell.toAddress2.text=toaddress2;
			 }else {
				 allocatedJourney.ToAddress=address;
				 //cell.toAddress2.text=@"";
			 }	 
			 
		 
		/* allocatedJourney.ToLocalityName=[currentObject objectForKey:@"End_Locality"];
		 allocatedJourney.ToLocationName=[currentObject objectForKey:@"End_Location"];
		 allocatedJourney.ToHouseNumber=[currentObject objectForKey:@"To_House_No"];
		 allocatedJourney.ToStreetNumber=[currentObject objectForKey:@"To_Street_Name"];
		 allocatedJourney.ToPostalCode=[currentObject objectForKey:@"To_Post_Code"];*/
	
		 allocatedJourney.NumberOfUsers=[[currentObject objectForKey:@"No_of_User"] intValue];
		 allocatedJourney.TotalNumberOfPassenger=[[currentObject objectForKey:@"No_of_Passenger"] intValue];
		 allocatedJourney.JourneyFare=[[currentObject objectForKey:@"Fare"] intValue];
             
             
             if ((NSString *)[NSNull null]!=[currentObject objectForKey:@"Is_Telephonic_Journey"] && [[[currentObject objectForKey:@"Is_Telephonic_Journey"] stringByReplacingOccurrencesOfString:@" " withString:@"" ] length]>0) {
                    allocatedJourney.IsTelephonicJourney=[[currentObject objectForKey:@"Is_Telephonic_Journey"] boolValue];				 
			 }

             
		 
		 allocatedJourney.suppID=[[currentObject objectForKey:@"Supplier_ID"] intValue];
        //[Common setSupplierID:allocatedJourney.suppID];
		 allocatedJourney.jnyDate= date;
             allocatedJourney.jnyTime= time;
		 allocatedJourney.JourneyDate=[currentObject objectForKey:@"Date"];
		 allocatedJourney.JourneyTime=[currentObject objectForKey:@"Time"];
		 allocatedJourney.hiddenJny=[currentObject objectForKey:@"Protected"];
			 
		 NSString *driverStatus=[currentObject objectForKey:@"Available_Status"];
		[Common setdriverStatus:driverStatus];

			 
		 if ([[currentObject objectForKey:@"Confirmation_Status"] intValue]==9) {
			 allocatedJourney.JourneyStatus=@"Acknowledged";
		 }
		 else if ([[currentObject objectForKey:@"Confirmation_Status"] intValue]==13) {
			 allocatedJourney.JourneyStatus=@"On Route";
		 }
		 else if ([[currentObject objectForKey:@"Confirmation_Status"] intValue]==12) {
			 allocatedJourney.JourneyStatus=@"On Board";
		 }
			 else {
				 allocatedJourney.JourneyStatus=@"unAcknowledged";
			 }

		 NSLocale* london = [[NSLocale alloc] initWithLocaleIdentifier:@"en_GB"];
		NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
		 [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
		 [formatter setLocale:london];
		[london release];
		 london=nil;
		 
		 allocatedJourney.Currency=[formatter currencySymbol];
			 [formatter release];
		 
		 if([[currentObject objectForKey:@"AJ_Shared_Dedicated_Status"] isEqualToString:@"D"])
			{
				allocatedJourney.JourneyType=@"Dedicated";
			}
			else
			{
				allocatedJourney.JourneyType=@"Shared";
			}
		// allocatedJourney.JourneyType=[currentObject objectForKey:@"AJ_Shared_Dedicated_Status"];

		 
		 NSArray *subJr=[currentObject objectForKey:@"PickUpDetails"];
		 NSMutableArray *pickUps=[[NSMutableArray alloc]init];
		 for (id pickup in subJr) {
			 Journey *journey=[[Journey alloc]init];
			 journey.JourneyID=[[pickup objectForKey:@"JO_ID"] intValue];
			 journey.isMultiDestination=[[pickup objectForKey:@"Is_Multi_Dest"]boolValue];
             if (journey.isMultiDestination) {
                 NSArray *multiJny=[pickup objectForKey:@"Multi_Destinations"];
                  NSMutableArray *destinations=[[NSMutableArray alloc]init];
                 for (id dest in multiJny) {
                     NSString *destinationName=[dest objectForKey:@"drop_detail"];
                     [destinations addObject:destinationName];
                 }
                 NSLog(@"[jny.multiDestAddresses count] is %lu",(unsigned long)[destinations count]);
                  //[journey.multiDestAddresses addObject:destinations];
                 journey.multiDestAddresses= destinations;
             }
             
             NSLog(@"[jny.multiDestAddresses count] is %lu",(unsigned long)[journey.multiDestAddresses count]);
			 
			 NSString *address1=@"";
			 NSString *address3=@"";
			 if ((NSString *)[NSNull null]!=[pickup objectForKey:@"JO_Start_House_No"] && [[[pickup objectForKey:@"JO_Start_House_No"] stringByReplacingOccurrencesOfString:@" " withString:@"" ] length]>0) {
				 //[address1 stringByAppendingString:[NSString stringWithFormat:@"%@,",jny.FromHouseNumber]];
				 address1=[NSString stringWithFormat:@"%@,",[pickup objectForKey:@"JO_Start_House_No"]];
				 
			 }
			 if ((NSString *)[NSNull null]!=[pickup objectForKey:@"JO_Start_Street_Name"] && [[[pickup objectForKey:@"JO_Start_Street_Name"] stringByReplacingOccurrencesOfString:@" " withString:@"" ] length]>0) {
				 //[address1 stringByAppendingString:[NSString stringWithFormat:@"%@,",jny.FromStreetNumber]];
				 address1=[NSString stringWithFormat:@"%@ %@,",address1,[pickup objectForKey:@"JO_Start_Street_Name"]];
			 }	
			 if ((NSString *)[NSNull null]!=[pickup objectForKey:@"JO_Start_Locality"] && [[[pickup objectForKey:@"JO_Start_Locality"] stringByReplacingOccurrencesOfString:@" " withString:@"" ] length]>0) {
				 //[address1 stringByAppendingString:[NSString stringWithFormat:@"%@,",jny.FromLocalityName]];
				 address1=[NSString stringWithFormat:@"%@ %@",address1,[pickup objectForKey:@"JO_Start_Locality"]];
			 }
			 if ((NSString *)[NSNull null]!=[pickup objectForKey:@"JO_Start_Location"] && [[[pickup objectForKey:@"JO_Start_Location"] stringByReplacingOccurrencesOfString:@" " withString:@"" ] length]>0)
			 {
				 
					// if (![[pickup objectForKey:@"JO_Start_Location"] isEqualToString:@"0"]) {
						 address3=[NSString stringWithFormat:@"%@",[pickup objectForKey:@"JO_Start_Location"]];
					 //}
				 
				 if((NSString *)[NSNull null]!=[pickup objectForKey:@"JO_Start_Post_Code"]  && [[[pickup objectForKey:@"JO_Start_Post_Code"] stringByReplacingOccurrencesOfString:@" " withString:@"" ] length]>0){
					 address3=[NSString stringWithFormat:@"%@, %@",address3,[pickup objectForKey:@"JO_Start_Post_Code"]];
					
				 }
			 }else  if((NSString *)[NSNull null]!=[pickup objectForKey:@"JO_Start_Post_Code"]  && [[[pickup objectForKey:@"JO_Start_Post_Code"] stringByReplacingOccurrencesOfString:@" " withString:@"" ] length]>0) {
				 address3=[NSString stringWithFormat:@"%@",[pickup objectForKey:@"JO_Start_Post_Code"]];
			 }
			 
			 
			 if (address3.length>0) {
				 journey.FromAddress=[NSString stringWithFormat:@"%@ %@",address3, address1];
			 }else {
				 journey.FromAddress=address1;
			 }
			 /*journey.FromLocalityName=[pickup objectForKey:@"JO_Start_Locality"];		
			 journey.FromLocationName=[pickup objectForKey:@"JO_Start_Location"];
			 journey.FromHouseNumber=[pickup objectForKey:@"JO_Start_House_No"];
			 journey.FromStreetNumber=[pickup objectForKey:@"JO_Start_Street_Name"];
			 journey.FromPostalCode=[pickup objectForKey:@"JO_Start_Post_Code"];*/
			 
			 
			 NSString *address=@"";
			 if ((NSString *)[NSNull null]!=[pickup objectForKey:@"JO_End_House_No"] && [[[pickup objectForKey:@"JO_End_House_No"] stringByReplacingOccurrencesOfString:@" " withString:@"" ] length]>0) {
				 address=[NSString stringWithFormat:@"%@,",[pickup objectForKey:@"JO_End_House_No"]];
				 
				 //[address stringByAppendingString:[NSString stringWithFormat:@"%@,",jny.ToHouseNumber]];
			 }
			 if ((NSString *)[NSNull null]!=[pickup objectForKey:@"JO_End_Street_Name"] && [[[pickup objectForKey:@"JO_End_Street_Name"] stringByReplacingOccurrencesOfString:@" " withString:@"" ] length]>0) {
				 address=[NSString stringWithFormat:@"%@ %@,",address,[pickup objectForKey:@"JO_End_Street_Name"]];
				 
				 //[address stringByAppendingString:[NSString stringWithFormat:@"%@,",jny.ToStreetNumber]];
			 }	
			 if ((NSString *)[NSNull null]!=[pickup objectForKey:@"JO_End_Locality"] && [[[pickup objectForKey:@"JO_End_Locality"] stringByReplacingOccurrencesOfString:@" " withString:@"" ] length]>0) {
				 address=[NSString stringWithFormat:@"%@ %@",address,[pickup objectForKey:@"JO_End_Locality"]];
				 
				 //[address stringByAppendingString:[NSString stringWithFormat:@"%@,",jny.ToLocalityName]];
			 }		
			 NSString *toaddress2=@"";
				 if ((NSString *)[NSNull null]!=[pickup objectForKey:@"JO_End_Location"] && [[[pickup objectForKey:@"JO_End_Location"] stringByReplacingOccurrencesOfString:@" " withString:@"" ] length]>0) 
				 {
					 //if (![[pickup objectForKey:@"JO_End_Location"] isEqualToString:@"0"]) {
						 toaddress2=[NSString stringWithFormat:@"%@",[pickup objectForKey:@"JO_End_Location"]];
					// }
					 if((NSString *)[NSNull null]!=[pickup objectForKey:@"JO_End_Post_Code"]   && [[[pickup objectForKey:@"JO_End_Post_Code"] stringByReplacingOccurrencesOfString:@" " withString:@"" ] length]>0){
						 toaddress2=[NSString stringWithFormat:@"%@, %@",toaddress2,[pickup objectForKey:@"JO_End_Post_Code"]];
					
					 }
				 }else  if((NSString *)[NSNull null]!=[pickup objectForKey:@"JO_End_Post_Code"]   && [[[pickup objectForKey:@"JO_End_Post_Code"] stringByReplacingOccurrencesOfString:@" " withString:@"" ] length]>0){
				 toaddress2=[NSString stringWithFormat:@"%@",[pickup objectForKey:@"JO_End_Post_Code"]];
				 }
					 
			 if (toaddress2.length>0) {
				 journey.ToAddress=[NSString stringWithFormat:@"%@ %@",toaddress2,address];
				 //cell.toAddress2.text=toaddress2;
			 }else {
				 journey.ToAddress=address;
				 //cell.toAddress2.text=@"";
			 }
             
             
             //////////////////////////////Checking Journey has hotSpot Address////////////////////////////////
             if((NSString *)[NSNull null]!=[pickup objectForKey:@"PlaceFrom"]   && [[[pickup objectForKey:@"PlaceFrom"] stringByReplacingOccurrencesOfString:@" " withString:@"" ] length]>0){
                 journey.FromAddress=[NSString stringWithFormat:@"%@, %@",[pickup objectForKey:@"PlaceFrom"],journey.FromAddress];
                 
             }
             if((NSString *)[NSNull null]!=[pickup objectForKey:@"PlaceTo"]   && [[[pickup objectForKey:@"PlaceTo"] stringByReplacingOccurrencesOfString:@" " withString:@"" ] length]>0){
                 journey.ToAddress=[NSString stringWithFormat:@"%@, %@",[pickup objectForKey:@"PlaceTo"],journey.ToAddress];
             }
             
             
             
             
			 journey.baseName=[pickup objectForKey:@"isBase"];
             allocatedJourney.baseName=[pickup objectForKey:@"isBase"];
			 journey.NumberOfPassenger=[[pickup objectForKey:@"JO_No_of_Travellers"] intValue];
			 journey.JourneyFare=[currentObject objectForKey:@"Fare"];
			
			 NSString *customerName=[NSString stringWithFormat:@"%@",[pickup objectForKey:@"Name"]];
			 journey.customerName=[customerName uppercaseString];
			 journey.customerMobile=[pickup objectForKey:@"Contact"];			
			
			 journey.customerInfo=[pickup objectForKey:@"Additional_Info"];
			 journey.NumberOfBags=[[pickup objectForKey:@"JO_No_of_Bags"] intValue];
			 journey.JourneyTime=[pickup objectForKey:@"JO_Time_of_Travel"];
			 
			 journey.Currency=[fmtr currencySymbol];
			 journey.hiddenJny=@"Yes";
			 //journey.Gender=[[pickup objectForKey:@"JO_Gender_of_Traveller"] uppercaseString];
			 [pickUps addObject:journey];
			 [journey release];
			 journey=nil;
			 
			 //[fmtr release];
			// fmtr=nil;
		 }
		  allocatedJourney.SubJourney=pickUps;
		 
		 [self.resultArray addObject:allocatedJourney];
		 [pickUps release];
		 pickUps=nil;
		 }
         else{
             NSString *driverStatus=[currentObject objectForKey:@"Available_Status"];
             [Common setdriverStatus:driverStatus];
         }
		 [allocatedJourney release];
		 allocatedJourney=nil;

		

		 
	 }
}

-(void)dealloc{
	[resultArray release];
	[objEntity release];
	[fmtr release];
	[super	dealloc];
}

@end
