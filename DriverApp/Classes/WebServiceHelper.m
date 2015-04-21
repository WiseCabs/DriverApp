//
//  WebServiceHelper.m
//  driverApp
//
//  Created by Nagraj Gopalakrishnan on 22/11/11.
//  Copyright 2011 Apppli. All rights reserved.
//

#import "WebServiceHelper.h"
#import "JSONParser.h"

@implementation WebServiceHelper

@synthesize objEntity,resultArray;



-(NSArray *) callWebService: (NSString *)webServiceURL pms:(NSDictionary *)params{
	NSMutableURLRequest *request = [self getWebServiceURL:webServiceURL pms:params];
	NSLog(@"Request is %@",request);
	NSLog(@"params is%@",params);
	NSError *error;
	NSURLResponse *response;
	NSData *urlData=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
	NSString *data=[[NSString alloc]initWithData:urlData encoding:NSUTF8StringEncoding];
	
   NSLog(@"data is %@",data);
    
    
    
    if([data length]>0)
	{
	  JSONParser *jsonParser = [[JSONParser alloc] init];
      jsonParser.objEntity = self.objEntity;
	//return array parsed by xml parser.
	  self.resultArray=[jsonParser getParsedEntities:data];
	  [jsonParser release];
	}
	[data release];
	return self.resultArray;
	
}

-(NSMutableURLRequest *) getWebServiceURL: (NSString *)webServiceURL pms:(NSDictionary *)params{
	 NSString *post=@"";
	 NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
	 [request setURL:[NSURL URLWithString:webServiceURL]];
	 [request setHTTPMethod:@"POST"];
		
	for (NSString *key in params)
	{
		
		NSString *value = [params objectForKey:key];
		post = [post stringByAppendingString:@"&"];
		post = [post stringByAppendingString:key];
		post = [post stringByAppendingString:@"="];
		post = [post stringByAppendingString:value];
	}

	NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
	NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];        //64-bit modification
		[request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded charset=utf-8" forHTTPHeaderField:@"Content-Type"];
	[request setHTTPBody:postData];
	return request;
}

-(void)dealloc{
	[objEntity release];
	[resultArray release];
	[super dealloc];
}
@end
