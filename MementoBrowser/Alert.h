/*
 
 File: Alert.h
 Abstract: Utility functions that display alerts.
 
 */

#import <UIKit/UIKit.h>


void alertWithError(NSError *error);
void alertWithMessage(NSString *title, NSString *message);
void alertWithMessageAndDelegate(NSString *message, id delegate);
