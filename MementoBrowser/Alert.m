/*
 
 File: Alert.m
 Abstract: Utility functions that display alerts.
 
 */

#import "Alert.h"


void alertWithError(NSError *error)
{
	NSString *title = [NSString stringWithFormat:@"%@", [error localizedFailureReason]];
    NSString *message = [NSString stringWithFormat:@"%@", [error localizedDescription]];
	//NSString *suggestion = [NSString stringWithFormat:@"%@", [error localizedRecoverySuggestion]];
	NSString *domain = [NSString stringWithFormat:@"%@",[error domain]];
	NSInteger code = [error code];
	if ( !([domain isEqualToString:NSURLErrorDomain] && code == NSURLErrorCancelled) ){  // Ignore these errors
		// otherwise, post an alert
		if ([title isEqualToString:@"NULL"]) {
			alertWithMessage(title, message);
		} else {
			alertWithMessage(nil, message);
		}
	}					
}


void alertWithMessage(NSString *title, NSString *message)
{
	/* open an alert with an OK button */
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
													message:message
												   delegate:nil 
										  cancelButtonTitle:@"OK" 
										  otherButtonTitles: nil];
	[alert show];
}


void alertWithMessageAndDelegate(NSString *message, id delegate)
{
	/* open an alert with OK and Cancel buttons */
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"URLCache" 
													message:message
												   delegate:delegate
										  cancelButtonTitle:@"Cancel" 
										  otherButtonTitles: @"OK", nil];
	[alert show];
}
