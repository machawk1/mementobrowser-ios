//
//  TimegateConnection.h
//  Memento
//
//  Refactored by Heather Tweedy on 5/25/12 from code
//  Created by Steve Baber on 1/5/11.
//  Copyright (c) 2012 Harding University. All rights reserved.
//

// Currently, this class is used by Memento to send a request to the gateway and return the HTTP response containing the TIMEMAP link.

#import <UIKit/UIKit.h>
#import "Constants.h"


@interface TimegateConnection : NSObject {
	
	int					status;
	NSURLConnection		*connection;
	NSMutableURLRequest *request;
	NSMutableString     *result;
	NSHTTPURLResponse   *httpResponse;
	NSError				*error;
	NSObject			*mytarget;
	
}

@property (nonatomic,retain) NSHTTPURLResponse *httpResponse;
@property (nonatomic,retain) NSMutableURLRequest *request;
@property (nonatomic,retain) NSURLConnection *connection;
@property (nonatomic,retain) NSObject *mytarget;

-(void)makeConnection:(NSURLRequest *)request whenFinishedNotify:(id)target;
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data;
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response;
-(void)connectionDidFinishLoading:(NSURLConnection *)connection;
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error;
-(void)connection:(NSURLConnection *)connection 
didCancelAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge;
-(void)connection:(NSURLConnection *)connection
didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge;
-(void)abortConnection;
@end
