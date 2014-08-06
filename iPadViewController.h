//
//  iPadViewController.h
//  Memento
//
//  Refactored by Heather Tweedy on 5/25/12 from code
//  Created by Steve Baber on 12/7/10.
//  Copyright (c) 2012 Harding University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"
#import "TimegateConnection.h"
#import "Alert.h"

@interface iPadViewController : UIViewController <UIWebViewDelegate>
{
	NSMutableArray *mementoLink;
	NSMutableArray *mementoDate;
	int currentMementoSubscript;
	int numMemento;
    NSString *requestedURLAddress;
    TimegateConnection *gate;
    NSString *timeGate;
    int status;
    NSURLConnection *connectionInProgress;
	NSMutableString *HTMLCode;
    UIBarButtonItem *donebutton;
    NSMutableArray *visitedDates;
    NSMutableArray  *subscripts;
    NSMutableArray  *visitedPages;
    NSMutableArray *forwardDates;
    NSMutableArray  *forwardSubscripts;
    NSMutableArray  *forwardPages;
}
@property (nonatomic, retain) NSString *lastURL;
@property (nonatomic, retain) NSString *requestedDate;
@property (nonatomic,retain) NSMutableArray *visitedDates;
@property (nonatomic,retain) NSMutableArray *visitedPages;
@property (nonatomic, retain) NSMutableArray *subscripts;
@property (nonatomic,retain) NSMutableArray *forwardDates;
@property (nonatomic,retain) NSMutableArray *forwardPages;
@property (nonatomic, retain) NSMutableArray *forwardSubscripts;
@property (retain, nonatomic) IBOutlet UIBarButtonItem *previousButton;
@property (retain, nonatomic) IBOutlet UIBarButtonItem *nextButton;
@property (retain, nonatomic) IBOutlet UITextField *URLtextField;
@property (retain, nonatomic) IBOutlet UILabel *btnActualDate;
@property (retain, nonatomic) IBOutlet UIWebView *webView;
@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (retain, nonatomic) IBOutlet UIBarButtonItem *openPicker;
@property (retain, nonatomic) IBOutlet UIBarButtonItem *nowButton;
@property (nonatomic, retain) NSString *timeGate;
@property (nonatomic, retain) NSDateFormatter *dateFormatter;
@property (nonatomic, retain) UIDatePicker *datePicker;
@property (nonatomic, retain) UIPopoverController *popover;
@property (nonatomic, retain) NSDate *actualDate;
@property (nonatomic, retain) NSDate *oldDate;
@property (nonatomic, retain) NSString *oldURL;
@property (retain, nonatomic) NSString *lastSender;
@property (nonatomic, retain) NSMutableArray *mementoLink;
@property (nonatomic, retain) NSMutableArray *mementoDate;
@property (nonatomic,retain) NSString *timemap;
@property (nonatomic,retain) NSString *firstMementoURL;
@property (nonatomic,retain) NSDate   *firstMementoDate;
@property (nonatomic,retain) NSString *currentMementoURL;
@property (nonatomic,retain) NSDate   *currentMementoDate;
@property (nonatomic,retain) NSString *lastMementoURL;
@property (nonatomic,retain) NSDate   *lastMementoDate;
@property int currentMementoSubscript;

- (IBAction)getDate:(id)sender;
- (IBAction)setDateToToday:(id)sender;
- (IBAction)editingDidBegin:(id)sender;
- (IBAction)getURL:(id)sender;
- (IBAction)menuButton:(id)sender;

- (IBAction)nextMemento:(id)sender;
- (IBAction)previousMemento:(id)sender;
- (IBAction)lastMemento:(id)sender;
- (IBAction)firstMemento:(id)sender;
- (IBAction)goBack:(id)sender;
- (IBAction)reload:(id)sender;
- (IBAction)goForward:(id)sender;


-(NSDate*)dateFromRFC1123:(NSString*)value_;
-(NSString *)rfc1123String:(NSDate *)date;
-(void)cancelButton;
-(void)hideDatePicker;
-(void)startAnimation;
-(void)stopAnimation;
-(void)displayWebPage:(NSString *)urlAddress;
-(void)cancelWebPage;
-(void)getMemento:(NSString *)urlAddress forDate:(NSDate *)date usingURI:(NSString *) gateway;
-(void)mementoArraysDidLoad;

@end
