//
//  TimegateConnection.m
//  Memento
//
//  Refactored by Heather Tweedy on 5/25/12 from code
//  Created by Steve Baber on 1/5/11.
//  Copyright (c) 2012 Harding University. All rights reserved.
//

#import "TimegateConnection.h"


@implementation TimegateConnection

@synthesize httpResponse, request, connection, mytarget;

// This method kicks off the asynchronous request to the gateway.
-(void)makeConnection:(NSMutableURLRequest *)req whenFinishedNotify:(id)target{
//NSLog(@"makeConnection:%@",req);
	mytarget = target;
	assert( [req isKindOfClass:[NSURLRequest class]] );
	status = 0;
	if (connection != nil) {
		connection = nil;
	}
	
	if (result != nil) {
		result = nil;
	}
	result = [[NSMutableString alloc] init];
	
	if (error != nil) {
        error = nil;
	}

	// Create and initiate the asyncronous connection to a server
	// The connection will itself call the following methods:
	//		connection: didReceiveData
	//      connection: didReceiveResponse
	//		connectionDidFinishLoading
	//		connection: didFailWithError
	connection = [[NSURLConnection alloc] initWithRequest:req delegate:self];
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	// This method might be called several times as the data arrives from the server
	NSString *temp = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
	if (temp != nil)
    {
        [result appendString:temp];
    }
}

// This is primarily what we're interested in from the memento gateway:
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)resp {
//NSLog(@"connection:didReceiveResponse:%@",resp);
	httpResponse = (NSHTTPURLResponse *)resp;
	status = [httpResponse statusCode];
	[mytarget performSelector:@selector(timegateConnectionDidReceiveResponse:) withObject:httpResponse];
}

-(NSURLRequest *)connection: (NSURLConnection *)connection willSendRequest:(NSURLRequest *)request redirectResponse:(NSURLResponse *)response
{
    //NSLog(@"connection:willSendRequest");
    if (response != nil)
    {
        httpResponse = (NSHTTPURLResponse *)response;
        [mytarget performSelector:@selector(timegateConnectionDidReceiveResponse:) withObject:httpResponse];
        return nil;
    }
    else {
        return self.connection.originalRequest;
    }
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection {
//NSLog(@"connectionDidFinishLoading");
	[mytarget performSelector:@selector(timegateConnectionDidFinishLoading:) withObject:result];
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)err {
//NSLog(@"connection:didFailWIthError");
	[mytarget performSelector:@selector(timegateConnectionDidFailWithError:) withObject:err];
}

-(void)connection:(NSURLConnection *)connection 
didCancelAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
//NSLog(@"connection:didCancelAuthenticationChallenge");
}

-(void)connection:(NSURLConnection *)connection
didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
//NSLog(@"connection:didReceiveAuthenticationChallenge");
}


// This method is called to terminate an active connection
-(void)abortConnection {
//NSLog(@"abortConnection");
	[connection cancel];
}
@end
