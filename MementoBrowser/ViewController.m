//
//  ViewController.m
//  Memento
//
//  Refactored by Heather Tweedy on 5/25/12 from code
//  Created by Steve Baber on 12/7/10.
//  Copyright (c) 2012 Harding University. All rights reserved.
//

#import "ViewController.h"
#import "TableViewController.h"

@interface ViewController ()

@end

@implementation ViewController
@synthesize previousButton;
@synthesize nextButton;
@synthesize URLtextField;
@synthesize btnActualDate;
@synthesize webView;
@synthesize activityIndicator;
@synthesize openPicker;
@synthesize nowButton;
@synthesize datePicker, dateFormatter, actualDate, oldDate, oldURL, lastMementoURL, lastMementoDate, firstMementoURL, firstMementoDate, currentMementoURL, currentMementoDate, timemap, mementoDate, mementoLink, timeGate, lastSender, currentMementoSubscript, visitedDates, subscripts, requestedDate, visitedPages, lastURL,forwardDates, forwardPages, forwardSubscripts;;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //Initialize bar buttons
    donebutton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemCancel target:self action:@selector(cancelButton)];
    nowButton.enabled = NO;
    nextButton.enabled = NO;
    
    //Initialize arrays
    visitedDates = [[NSMutableArray alloc] init];
    subscripts = [[NSMutableArray alloc] init];
    visitedPages = [[NSMutableArray alloc] init];
    forwardDates  = [[NSMutableArray alloc] init];
    forwardPages  = [[NSMutableArray alloc] init];
    forwardSubscripts  = [[NSMutableArray alloc] init];
    
    //Initialize dates for use in the Menu
    requestedDate = [[NSString alloc] init];
    requestedDate = @"";
    
    //Initialize webView
    webView.delegate = self;
    webView.scalesPageToFit = YES;
    [self stopAnimation];
    
    //Initialze urls to be used later
    requestedURLAddress = @defaultURL;    
    URLtextField.text = requestedURLAddress;
    oldURL = requestedURLAddress;
    
    //Set up string formatter for dates
    self.dateFormatter = [[NSDateFormatter alloc] init];
    [self.dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [self.dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    [self.dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    
    //Initialize date lable on navigation bar
    actualDate = [NSDate date];
    btnActualDate.text = [dateFormatter stringFromDate:actualDate];
    
    //Initialize timegate to access memento records
    timeGate = @UI_TimeGate;  // Initial timegate is default
    
    // Initialize parallel arrays to hold memento links and dates
    mementoLink = [[NSMutableArray alloc] init];
    mementoDate = [[NSMutableArray alloc] init];
    currentMementoSubscript = -1;	// Initialize the subscript that selects which memento to display

    firstMementoURL = nil;
    lastMementoURL = nil;
    
    //Display default page
    [self displayWebPage:URLtextField.text];
}

- (void)viewDidUnload
{
    [self setURLtextField:nil];
    [self setWebView:nil];
    [self setActivityIndicator:nil];
    [self setOpenPicker:nil];
    [self setBtnActualDate:nil];
    [self setNowButton:nil];
    [self setNextButton:nil];
    [self setPreviousButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    //Allow page to rotate
    return YES;
}

- (void)cancelButton {
    NSLog(@"cancelButton");
    self.navigationItem.rightBarButtonItem = nil;
    // if typing close keyboard and set text field to last url
    if ([URLtextField isEditing])
    {
        [URLtextField resignFirstResponder];
        URLtextField.text = oldURL;
    }
    [self stopAnimation];
    
    // if gathering information from timegate connection abort
    if (connectionInProgress)
    {
        //[gate abortConnection];
        [connectionInProgress cancel];	
    }
}


-(void)hideDatePicker {
    if ([openPicker.title isEqualToString:@"Go"])
    {
        //Removes DatePicker from View
        [datePicker removeFromSuperview];
        NSLog(@"hideDate");
        actualDate = datePicker.date;
        btnActualDate.text = [dateFormatter stringFromDate:actualDate];
        openPicker.title = @"Date";
        nowButton.title = @"Now";
        requestedDate  = btnActualDate.text;
        
        //Enable the correct buttons based on date
        if ([btnActualDate.text isEqualToString:[dateFormatter stringFromDate:[NSDate date]]])
        {
            nowButton.enabled = NO;
            nextButton.enabled = NO;
            previousButton.enabled = YES;
        }
        else {
            nextButton.enabled = YES;
            nowButton.enabled = YES;
        }
        
    }
}

- (IBAction)getDate:(id)sender {
    NSLog(@"getDate");
    lastSender = @"getDate";
    
    // If the keyboard is still visible, make it go away.
    if ([URLtextField isEditing]) {
        [URLtextField resignFirstResponder];
    }
    
    //Enable the proper buttons
    self.navigationItem.rightBarButtonItem = nil;
    nowButton.enabled = YES;
    nowButton.title = @"Cancel";
    oldDate = actualDate;
    
    //Initialize DatePicker
    if (self.datePicker.superview == nil || [openPicker.title isEqualToString:@"Date"]) {
        datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 20, 20, 20)];
        datePicker.datePickerMode = UIDatePickerModeDate;
        datePicker.timeZone = [NSTimeZone timeZoneWithName:@"GMT"];
        datePicker.hidden = NO;
        datePicker.date = actualDate;
        datePicker.maximumDate = [NSDate date]; // Don't allow future date to be selected
        [self.view addSubview:datePicker];
        CGSize pickerSize = [datePicker sizeThatFits:CGSizeZero];
        CGRect startRect = CGRectMake(0, 45, pickerSize.width, pickerSize.height);
        datePicker.frame = startRect;
        [datePicker addTarget:self action:@selector(hideDatePicker) forControlEvents:UIControlEventTouchUpOutside];
        openPicker.title =  @"Go";
        
    }
    
    //Close DatePicker and load Mementos for date chosen
    else if ([openPicker.title isEqualToString:@"Go"])
    {
        [self hideDatePicker];
        
        // If the user has selected a different date...
        if ( !([actualDate isEqualToDate:oldDate]) ){
            // Update the display to reflect the value of "actualDate"
            NSString *newDate = [[NSString alloc] initWithString:[dateFormatter stringFromDate:actualDate]];
            btnActualDate.text = newDate;
            
            // If mementos have previously been loaded, find the nearest one to selected date and display it!
            if ([mementoLink count] > 0) {
                [self mementoArraysDidLoad];
            }
            else {
                requestedURLAddress = URLtextField.text;
                [self getMemento: requestedURLAddress forDate:actualDate usingURI:timeGate];
                actualDate = datePicker.date;
                btnActualDate.text = [dateFormatter stringFromDate:actualDate];
            }
            
        }
    }
}

- (IBAction)setDateToToday:(id)sender {
    NSLog(@"setDateToToday");
    self.navigationItem.rightBarButtonItem = nil;
    
    //Sets date to today
    if ([nowButton.title isEqualToString:@"Now"])
    {
        if ([URLtextField isEditing]) {
            [URLtextField resignFirstResponder];
        }
        [self cancelWebPage];
        actualDate = [NSDate date];
        btnActualDate.text = [dateFormatter stringFromDate:actualDate];
        //displays current page for today's date
        NSLog(@"url %@", oldURL);
        currentMementoSubscript = -1;
        requestedDate = @"";
        [self displayWebPage:oldURL];
        nowButton.enabled = NO;
        nextButton.enabled = NO;
        previousButton.enabled = YES;
    }
    
    //Cancels the date picking
    if ([nowButton.title isEqualToString:@"Cancel"])
    {
        nowButton.title = @"Now";
        [self hideDatePicker];
        actualDate = oldDate;
        btnActualDate.text = [dateFormatter stringFromDate:actualDate];
        if ([btnActualDate.text isEqualToString:[dateFormatter stringFromDate:[NSDate date]]])
        {
            nowButton.enabled = NO;
            nextButton.enabled = NO;
        }
        else {
            nextButton.enabled = YES;
            nowButton.enabled = YES;
        }
    }
}

- (IBAction)editingDidBegin:(id)sender {
    //hides DatePicker while user is typing a url
    [self hideDatePicker];
    //add cancel button
    self.navigationItem.rightBarButtonItem = donebutton;
}

- (IBAction)menuButton:(id)sender {
    NSLog(@"menuButton");
    //Opens the Menu
    [self hideDatePicker];
    NSString *urlAddress = URLtextField.text;
    
    TableViewController *mementos = [[TableViewController alloc] initWithNibName:@"TableViewController" bundle:[NSBundle mainBundle]  NSMutableArray:mementoDate NSMutableArray:mementoLink NSString:urlAddress NSDate:actualDate NSString:timeGate iPadViewController:self];
    
    [self.navigationController pushViewController:mementos animated:YES];
    
    mementos = nil;
}

-(BOOL) webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    //If a link is clicked direct the browser to the correct page based on the date previously chosen
    if (navigationType == UIWebViewNavigationTypeLinkClicked)
    {
        currentMementoSubscript = -1;
        [mementoLink removeAllObjects];
        [mementoDate removeAllObjects];
        firstMementoURL = nil;
        lastMementoURL = nil;
        NSLog(@"Clicked Link");
        lastSender = @"clickedLink";
        URLtextField.text = request.URL.absoluteString;
        
        if (![[dateFormatter stringFromDate:actualDate] isEqualToString:[dateFormatter stringFromDate:[NSDate date]]])
        {
            nowButton.enabled = YES;
            nextButton.enabled = YES;
            lastSender = @"pastClickedLink";
            if ([[request.URL.absoluteString substringFromIndex:7] rangeOfString:@"http://" options:NSCaseInsensitiveSearch].location == NSNotFound)
            {
                //is an original url
                actualDate = [NSDate date];
                btnActualDate.text = [dateFormatter stringFromDate:actualDate];
                previousButton.enabled = YES;
                nextButton.enabled = NO;
                nowButton.enabled = NO;
                requestedDate = @"";
                oldURL = request.URL.absoluteString;
                URLtextField.text = request.URL.absoluteString;
            }
            else {
                int index = [[request.URL.absoluteString substringFromIndex:7] rangeOfString:@"http://" options:NSCaseInsensitiveSearch].location;
                oldURL = [[request.URL.absoluteString substringFromIndex:7] substringFromIndex:index];
                URLtextField.text = oldURL;
            }
            [self getMemento:URLtextField.text forDate:actualDate usingURI:timeGate];
            return NO;
        }
        else {
            nowButton.enabled = NO;
            nextButton.enabled = NO;
            
        }
        if (![lastSender isEqualToString:@"pastClickedLink"])
        {
            NSLog(@"Adding %@ to dates, %d to subscripts, %@ to addresses",btnActualDate.text, currentMementoSubscript, URLtextField.text);
            [visitedDates addObject:btnActualDate.text];
            [visitedPages addObject:URLtextField.text];
            [subscripts addObject:[NSNumber numberWithInt: currentMementoSubscript]];
            NSLog(@"counts are: %d, %d, %d", visitedDates.count, visitedPages.count, subscripts.count);
            [forwardDates removeAllObjects];
            [forwardPages removeAllObjects];
            [forwardSubscripts removeAllObjects];
        }
    }
    return YES;
} 

-(void)webViewDidStartLoad:(UIWebView *)webView {
    //Animates loading spiral
    [self startAnimation];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView {
    NSLog(@"webViewDidFinishLoad");
    NSLog(@"Last sender = %@", lastSender);
    if ([lastSender isEqualToString:@"previousMemento"]
        || [lastSender isEqualToString:@"nextMemento"] 
        || [lastSender isEqualToString:@"getDate"]
        || [lastSender isEqualToString:@"menu"]
        || [lastSender isEqualToString:@"reload"]
        || [lastSender isEqualToString:@"goBack"]
        || [lastSender isEqualToString:@"goForward"])
    {
        URLtextField.text = oldURL;
    }
    if ([lastSender isEqualToString:@"getURL"]) {
        
        if([URLtextField.text isEqualToString:[visitedPages objectAtIndex:(visitedPages.count-1)]])
        {
            NSLog(@"getURL got called twice");
        }
        else
        {
            NSLog(@"Adding %@ to dates, %d to subscripts, %@ to addresses",btnActualDate.text, currentMementoSubscript, URLtextField.text);
            
            [visitedDates addObject:btnActualDate.text];
            [visitedPages addObject:URLtextField.text];
            [subscripts addObject:[NSNumber numberWithInt: currentMementoSubscript]];
            NSLog(@"counts are: %d, %d, %d", visitedDates.count, visitedPages.count, subscripts.count);
            [forwardDates removeAllObjects];
            [forwardPages removeAllObjects];
            [forwardSubscripts removeAllObjects];
        }
        
        URLtextField.text = self.webView.request.URL.absoluteString;
        lastSender = @"display";
    }
    NSString *actualURL = [self.webView.request.URL.relativeString substringToIndex:(self.webView.request.URL.relativeString.length -1)];
    
    if ([actualURL isEqualToString:lastURL])
    {
        NSLog(@"Adding %@ to dates, %d to subscripts, %@ to addresses",btnActualDate.text, currentMementoSubscript, URLtextField.text);
        
        [visitedDates addObject:btnActualDate.text];
        [visitedPages addObject:URLtextField.text];
        [subscripts addObject:[NSNumber numberWithInt: currentMementoSubscript]];
        NSLog(@"counts are: %d, %d, %d", visitedDates.count, visitedPages.count, subscripts.count);
        [forwardDates removeAllObjects];
        [forwardPages removeAllObjects];
        [forwardSubscripts removeAllObjects];
        lastURL = nil;
    }
    else {
        lastURL = self.webView.request.URL.relativeString;
    }
    
    //Enable the correct buttons based on date
    if ([btnActualDate.text isEqualToString:[dateFormatter stringFromDate:[NSDate date]]])
    {
        nowButton.enabled = NO;
        nextButton.enabled = NO;
        previousButton.enabled = YES;
    }
    else {
        nextButton.enabled = YES;
        nowButton.enabled = YES;
    }
    
    lastURL = self.webView.request.URL.relativeString;
    
    [self stopAnimation];
}

-(void) startAnimation {
    [self.activityIndicator startAnimating];
    UIApplication *application = [UIApplication sharedApplication];
    application.networkActivityIndicatorVisible = YES;
}

-(void) stopAnimation {
    [self.activityIndicator stopAnimating];
    UIApplication *application = [UIApplication sharedApplication];
    application.networkActivityIndicatorVisible = NO;
}

- (IBAction)goForward:(id)sender {
    NSLog(@"goForward");
    lastSender = @"goForward";
    NSLog(@"forward count: %d", forwardDates.count);
    
    if (forwardDates.count > 0)
    {
        oldURL = [forwardPages objectAtIndex:(forwardPages.count-1)];
        URLtextField.text = oldURL;
        btnActualDate.text = [forwardDates objectAtIndex:(forwardDates.count-1)];
        currentMementoSubscript = [[forwardSubscripts objectAtIndex:(forwardSubscripts.count-1)] intValue];
        
        NSLog(@"Adding %@ to dates, %d to subscripts, %@ to addresses",btnActualDate.text, currentMementoSubscript, URLtextField.text);
        
        [visitedDates addObject:btnActualDate.text];
        [visitedPages addObject:URLtextField.text];
        [subscripts addObject:[NSNumber numberWithInt: currentMementoSubscript]];
        NSLog(@"counts are: %d, %d, %d", visitedDates.count, visitedPages.count, subscripts.count);
        
        NSLog(@"subscript: %d", [[forwardSubscripts objectAtIndex:(forwardSubscripts.count-1)] intValue]);
        [forwardSubscripts removeObjectAtIndex:(forwardSubscripts.count-1)];
        [forwardPages removeObjectAtIndex:(forwardPages.count-1)];
        [forwardDates removeObjectAtIndex:(forwardDates.count-1)];
    }
    
    [webView goForward];
}

- (IBAction)goBack:(id)sender {
    NSLog(@"goBack");
    lastSender = @"goBack";
    NSLog(@"back count : %d", visitedDates.count);
    //Steps back through pages visited as well as each memento of the pages
    [self hideDatePicker];
    if (visitedDates.count == 1)
    {
        oldURL = [visitedPages objectAtIndex:(visitedPages.count-1)];
        URLtextField.text = oldURL;
        btnActualDate.text = [visitedDates objectAtIndex:(visitedDates.count-1)];
        currentMementoSubscript = [[subscripts objectAtIndex:(subscripts.count-1)] intValue];
        NSLog(@"subscript: %d", [[subscripts objectAtIndex:(subscripts.count-1)] intValue]);
    }
    if (visitedDates.count >= 2)
    {
        [forwardDates addObject:[visitedDates objectAtIndex:visitedDates.count-1]];
        [visitedDates removeObjectAtIndex:(visitedDates.count-1)];
        [forwardPages addObject:[visitedPages objectAtIndex:visitedPages.count-1]];
        [visitedPages removeObjectAtIndex:(visitedPages.count-1)];
        [forwardSubscripts addObject:[subscripts objectAtIndex:subscripts.count-1]];
        [subscripts removeObjectAtIndex:(subscripts.count-1)];
        
        oldURL = [visitedPages objectAtIndex:(visitedPages.count-1)];
        URLtextField.text = oldURL;
        btnActualDate.text = [visitedDates objectAtIndex:(visitedDates.count-1)];
        currentMementoSubscript = [[subscripts objectAtIndex:(subscripts.count-1)] intValue];
        NSLog(@"subscript: %d", [[subscripts objectAtIndex:(subscripts.count-1)] intValue]);
    }
    if ([btnActualDate.text isEqualToString:[dateFormatter stringFromDate:[NSDate date]]])
    {
        NSLog(@"it's today");
        nowButton.enabled = NO;
        nextButton.enabled = NO;
        previousButton.enabled = YES;
    }
    else {
        NSLog(@"it's in the past");
        nowButton.enabled = YES;
        nextButton.enabled = YES;
        previousButton.enabled = YES;
        
        if (currentMementoSubscript == 0)
        {
            NSLog(@"and it's the first memento");
            previousButton.enabled = NO;
        }
    } 
    [webView goBack];
}

- (IBAction)reload:(id)sender {
    lastSender = @"reload";
    [webView reload];
}

-(void)displayWebPage:(NSString *) urlAddress {
    NSLog(@"displayWebPage - %@", urlAddress);
    NSLog(@"Last sender = %@", lastSender);
    if (![lastSender isEqualToString:@"getDate"])
    {
        [self hideDatePicker];
    }
    
    // If the keyboard is still visible, make it go away as well!
    if ([URLtextField isEditing]) {
        [URLtextField resignFirstResponder];
    }
    if (![lastSender isEqualToString:@"getURL"] && ![lastSender isEqualToString:@"display"] && ![lastSender isEqualToString:@"pastClickedLink"])
    {
        NSLog(@"Adding %@ to dates, %d to subscripts, %@ to addresses",btnActualDate.text, currentMementoSubscript, URLtextField.text);
        
        [visitedDates addObject:btnActualDate.text];
        [visitedPages addObject:URLtextField.text];
        [subscripts addObject:[NSNumber numberWithInt: currentMementoSubscript]];
        NSLog(@"counts are: %d, %d, %d", visitedDates.count, visitedPages.count, subscripts.count);
        [forwardDates removeAllObjects];
        [forwardPages removeAllObjects];
        [forwardSubscripts removeAllObjects];
    }
    //Makes sure we load the correct memento version of the requested page. (The one with rewritten page links
    if ([urlAddress rangeOfString:@"/memento/" options:NSCaseInsensitiveSearch].location == NSNotFound)
    {
        // sanitaize URI to remove extra timemap garbage pre-pending URI
        NSRange r = [urlAddress rangeOfString:@"http"];
        urlAddress = [urlAddress substringFromIndex:r.location];
        
        NSURL *url = [NSURL URLWithString:urlAddress];
        NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
        oldURL = URLtextField.text;
        [webView loadRequest:requestObj];
    }
    else {
        NSArray *temp = [urlAddress componentsSeparatedByString:@"/memento/"];
        NSString *newURL = [NSString stringWithFormat:@"%@%@", @"http://web.archive.org/web/", [temp objectAtIndex:1]];
        
        NSURL *url = [NSURL URLWithString:newURL];
        NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
        oldURL = URLtextField.text;
        [webView loadRequest:requestObj];
    }
}

-(void)cancelWebPage {
    [webView stopLoading];
    [self stopAnimation];
}

- (IBAction)getURL:(id)sender {
    NSLog(@"getURL");
    // properly formats url from text field
    self.navigationItem.rightBarButtonItem = nil;
    lastSender = @"getURL";
    [self hideDatePicker];
    
    if (URLtextField) {
        if ( !( [URLtextField.text hasPrefix:@"http://"] || [URLtextField.text hasPrefix:@"https://"]) ){
            NSString *urlAddress = [[NSString alloc] initWithFormat:@"http://%@",URLtextField.text];
            URLtextField.adjustsFontSizeToFitWidth = YES;
            URLtextField.text = urlAddress;
        }
        
        //Has the url actually changed?
        if ([URLtextField.text isEqualToString:@"http://"])
        {
            URLtextField.text = oldURL;
        }
        else if([URLtextField.text isEqualToString:oldURL])
        {
            ;
        }
        else {
            // Then we need to re-initialize the currentMementoSuscript and the parallel arrays
            currentMementoSubscript = -1;
            [mementoLink removeAllObjects];
            [mementoDate removeAllObjects];
            firstMementoURL = nil;
            lastMementoURL = nil;
            nowButton.enabled = NO;
            nextButton.enabled = NO;
            [self displayWebPage:URLtextField.text];
        }
    }
}

-(IBAction)firstMemento:(id)sender {	// "FirstMemento" button was pressed...
    //Loads the very first Memento
    actualDate = firstMementoDate;
    NSString *newDate = [[NSString alloc] initWithString:[dateFormatter stringFromDate:firstMementoDate]];
    btnActualDate.text = newDate;
    nowButton.enabled = YES;
    nextButton.enabled = YES;
    previousButton.enabled = NO;
    [self displayWebPage:firstMementoURL];
    currentMementoSubscript = 0;
}

-(IBAction)lastMemento:(id)sender {		// "LastMemento" button was pressed...
    //Loads the most recent Memento
    actualDate = lastMementoDate;
    NSString *newDate = [[NSString alloc] initWithString:[dateFormatter stringFromDate:lastMementoDate]];
    btnActualDate.text = newDate;
    nowButton.enabled = NO;
    nextButton.enabled = NO;
    previousButton.enabled = YES;
    [self displayWebPage:lastMementoURL];
    currentMementoSubscript = numMemento - 2;  // Recall that array element (n-1) is reserved for today's date and URL
}

-(IBAction)previousMemento:(id)sender {		// "PreviousMemento button was pressed...
    NSLog(@"previousMemento");
    [URLtextField resignFirstResponder];
    requestedDate = @"";
    lastSender = @"previousMemento";
    self.navigationItem.rightBarButtonItem = nil;
    if (currentMementoSubscript < 0) {
        NSString *urlAddress = URLtextField.text;
        requestedURLAddress = urlAddress;
        [self getMemento:urlAddress forDate:actualDate usingURI:timeGate];
        
    } else if (currentMementoSubscript > 0) {
        nowButton.enabled = YES;
        nextButton.enabled = YES;
        nowButton.title = @"Now";
        int previousSubscript = currentMementoSubscript - 1;
        actualDate = [mementoDate objectAtIndex:previousSubscript];
        NSString *newDate = [[NSString alloc] initWithString:[dateFormatter stringFromDate:actualDate]];
        btnActualDate.text = newDate;
        currentMementoSubscript = previousSubscript;
        [self displayWebPage:[mementoLink objectAtIndex:previousSubscript]];
    }
    if (currentMementoSubscript == 0) {
        previousButton.enabled  = NO;
        nextButton.enabled = YES;
        nowButton.enabled = YES;
    }
    NSLog(@"Current subscript %d", currentMementoSubscript);
}

-(IBAction)nextMemento:(id)sender {			// "NextMemento button was pressed...
    NSLog(@"nextMemento");
    [URLtextField resignFirstResponder];
    requestedDate = @"";
    lastSender = @"nextMemento";
    //URLtextField.text = oldURL;
    self.navigationItem.rightBarButtonItem = nil;
    if (currentMementoSubscript < 0) {
        NSString *urlAddress = URLtextField.text;
        requestedURLAddress = urlAddress;
        [self getMemento:urlAddress forDate:actualDate usingURI:timeGate];
        
    } else if (currentMementoSubscript == numMemento - 1) {
        [self displayWebPage:[mementoLink objectAtIndex:(numMemento - 1)]];		
        
    } else if (currentMementoSubscript == numMemento - 2) {
        [self setDateToToday:sender];
    } else if (currentMementoSubscript < numMemento - 2) {
        previousButton.enabled = YES;
        int nextSubscript = currentMementoSubscript + 1;
        actualDate = [mementoDate objectAtIndex:nextSubscript];
        NSString *newDate = [[NSString alloc] initWithString:[dateFormatter stringFromDate:actualDate]];
        btnActualDate.text = newDate;
        currentMementoSubscript = nextSubscript;
        [self displayWebPage:[mementoLink objectAtIndex:nextSubscript]];
    }
    NSLog(@"Current subscript %d", currentMementoSubscript); 
}

-(void)mementoArraysDidLoad {		// Successfully retrieved all mementos into the parallel arrays
    NSLog(@"mementoArraysDidLoad");
    
    //NSLog(@"numMemento = %d; currentMementoSubscript = %d",numMemento,currentMementoSubscript);
    if (currentMementoSubscript >= 0) {
        NSLog(@"   URL = %@ \n   Date = %@",[mementoLink objectAtIndex:currentMementoSubscript],[mementoDate objectAtIndex:currentMementoSubscript]);
    }
    
    numMemento = [mementoLink count];
    //NSLog(@"Size of mementoLink array = %d",numMemento);
    
    // Find closest memento to requested date and set currentMementoSubscript accordingly
    currentMementoSubscript = -1;
    if ( fabs([actualDate timeIntervalSinceNow]) < 86400.0 ) { // If requested date is within 24 hours of NOW, just use today's URL
        currentMementoSubscript = numMemento - 1;  // The last entry in the arrays corresponds to today's date and link (see above)
    } else {
        if ([mementoDate count] > 0) {
            NSTimeInterval requestedTimeInterval = [actualDate timeIntervalSinceReferenceDate];
            currentMementoSubscript = 0;
            double timeInterval = fabs( requestedTimeInterval - [[mementoDate objectAtIndex:0] timeIntervalSinceReferenceDate] );
            for (int i=0; i<[mementoLink count]; i++) {
                if ( fabs(requestedTimeInterval - [[mementoDate objectAtIndex:i] timeIntervalSinceReferenceDate]) < timeInterval  ) {
                    currentMementoSubscript = i;
                    timeInterval = fabs(requestedTimeInterval - [[mementoDate objectAtIndex:i] timeIntervalSinceReferenceDate]);
                }
            }
        }
    }
    
    if([lastSender isEqualToString:@"getDate"])
    {
        if (currentMementoSubscript >=0 && currentMementoSubscript < numMemento) {
            if (currentMementoSubscript == 0)
            {
                previousButton.enabled = NO;
            }else {
                previousButton.enabled = YES;
            }
            NSString *newDate = [[NSString alloc] 
                                 initWithString:[dateFormatter stringFromDate:[mementoDate objectAtIndex:currentMementoSubscript]]];
            oldDate = [mementoDate objectAtIndex:currentMementoSubscript];
            btnActualDate.text = newDate;
            [self displayWebPage:[mementoLink objectAtIndex:currentMementoSubscript]];		// Display the memento closest to requested date!
        }
    }    
    else if([lastSender isEqualToString:@"previousMemento"])
    {
        [self previousMemento:self];
    }
    else if([lastSender isEqualToString:@"nextMemento"])
    {
        [self nextMemento:self];
    }
    else if([lastSender isEqualToString:@"pastClickedLink"])
    {
        if (currentMementoSubscript >=0 && currentMementoSubscript < numMemento) {
            if (currentMementoSubscript == 0)
            {
                previousButton.enabled = NO;
            }else {
                previousButton.enabled = YES;
            }
            NSString *newDate = [[NSString alloc] 
                                 initWithString:[dateFormatter stringFromDate:[mementoDate objectAtIndex:currentMementoSubscript]]];
            oldDate = [mementoDate objectAtIndex:currentMementoSubscript];
            btnActualDate.text = newDate;
            NSLog(@"Adding %@ to dates, %d to subscripts, %@ to addresses",btnActualDate.text, currentMementoSubscript, URLtextField.text);
            
            [visitedDates addObject:btnActualDate.text];
            [visitedPages addObject:URLtextField.text];
            [subscripts addObject:[NSNumber numberWithInt: currentMementoSubscript]];
            NSLog(@"counts are: %d, %d, %d", visitedDates.count, visitedPages.count, subscripts.count);
            
            [self displayWebPage:[mementoLink objectAtIndex:currentMementoSubscript]];		// Display the memento closest to requested date!
        }
    }
    
}

-(void)getMemento:(NSString *)urlAddress forDate:(NSDate *) date usingURI:(NSString *) gateway {
    NSLog(@"getMemento - urlAdress=[%@] date=[%@] gateway=[%@]", urlAddress, date, gateway);
    // Initialize the main variables and arrays
    [self startAnimation];
    currentMementoSubscript = -1;
    [mementoLink removeAllObjects];
    [mementoDate removeAllObjects];
    firstMementoURL = nil;
    lastMementoURL = nil;
    
    NSString *gatewayURL;
    if (gateway) {
        if  ([urlAddress hasSuffix:@"/"])
        {
            urlAddress = [urlAddress substringToIndex:(urlAddress.length -1)];
        }
        gatewayURL = [[NSString alloc] initWithFormat:@"%@%@",gateway,urlAddress];
    } else {
        NSLog(@"Something is seriously wrong!  No gateway specified.");
        return;
    }
    
    NSURL *url = [NSURL URLWithString:gatewayURL];
    NSLog(@"Request to %@", url);
    
    NSMutableURLRequest *requestObj = [NSMutableURLRequest requestWithURL:url];
    url = nil;
    NSString *rfcDate = [self rfc1123String:date];
    [requestObj setValue:rfcDate forHTTPHeaderField:@"Accept-Datetime"];
    
    NSLog(@"Accept-Datetime: %@", rfcDate);
    
    // Send a synchronouse request to the timegate for the given urlAddress
    if (gate != nil) {
        gate = nil;
    }
    gate = [TimegateConnection alloc];
    [gate makeConnection:requestObj whenFinishedNotify:self];
}

-(void)timegateConnectionDidReceiveResponse:(NSHTTPURLResponse *)response{
    //NSLog(@"timegateConnectionFinished: withObject:%@",response);
    status = [response statusCode];
    //NSLog(@"status = %d",status);
    if (status == 404) {
        // throw an alert!  No resource found in archive for given URL.
        NSString *errorTitle = [NSString stringWithFormat:@"Status code: %d",status];
        NSString *errorMsg = @"Resource not in archive";
        alertWithMessage(errorTitle,errorMsg);
        [self setDateToToday:self];
        [self stopAnimation];
        return;
    } else if (status != 200 && status != 302) { //Changed from 405
        NSLog(@"Unexpected status #%d returned from gateway!",status);
        NSString *errorTitle = [NSString stringWithFormat:@"Status code: %d",status];
        NSString *errorMsg = @"Could not load Mementos";
        alertWithMessage(errorTitle,errorMsg);
        [self stopAnimation];
        return;
    }
    
    NSDictionary *httpHeaders = [response allHeaderFields];
    //NSLog(@"response = %@",response);
    //NSLog(@"httpHeaders: %@",httpHeaders);
    
    NSString *httpLocation = [httpHeaders valueForKey:@"Location"];
    if (httpLocation) {
        //NSLog(@"Location = %@",httpLocation);
        // Could add code here to capture the requested date's memento directly from the timegate server
        // This hasn't been done.  Instead we'll download the entire timemap and look for closest date ourself...
    }
    
    // Separate out the various LINK fields
    NSArray *httpLink = [[httpHeaders valueForKey:@"Link"] componentsSeparatedByString:@",<"];
    //NSLog(@"Number of links = %d",[httpLink count]);
    
    // Now, parse each LINK, especially looking for the URL associated with the needed timemap
    timemap = nil;
    NSArray *httpLinkField;
    for (int i=0; i<[httpLink count]; i++) {
        httpLinkField = [[httpLink objectAtIndex:i] componentsSeparatedByString:@";"];
        
        // remove leading and trailing whitespace as well as < and > characters from URL component of a LINK
        NSString *temp = [[httpLinkField objectAtIndex:0] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        NSString *urlLink = [temp stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
        temp = nil;
        
        // parse out the name of the REL component
        NSArray *relComponents = [[httpLinkField  objectAtIndex:1] componentsSeparatedByString:@"\""];
        NSString *relLink = [relComponents objectAtIndex:1];
        //NSLog(@"Link #%d: \n   urlLink = %@ \n   relLink = %@",i, urlLink, relLink);
        
        if ( [relLink rangeOfString:@"timemap"].location < NSNotFound) {   // THIS IS WHAT WE'RE LOOKING FOR!
            timemap = urlLink;
            NSLog(@"found timemap = %@",timemap);
        }
        
        // Just in case the timegate doesn't contain a timemap LINK, 
        //    we'll look for FIRST MEMENTO and LAST MEMENTO links that we might use
        NSString *urlDate = nil;
        if ([httpLinkField count] > 2) {
            NSArray *dateComponents = [[httpLinkField objectAtIndex:2] componentsSeparatedByString:@"\""];
            urlDate = [[NSString alloc] initWithString:[dateComponents objectAtIndex:1]];
        }		
        if ([relLink rangeOfString:@"first"].location < NSNotFound) {
            firstMementoURL  = urlLink;
            firstMementoDate = [self dateFromRFC1123:urlDate];
        } 
        if ([relLink rangeOfString:@"last"].location < NSNotFound) {
            lastMementoURL  = urlLink;
            lastMementoDate = [self dateFromRFC1123:urlDate];
        }
    }
    
    if (timemap) //if a timemap was found from links in header
    {
        NSURL *url = [NSURL URLWithString:timemap];
        NSMutableURLRequest *requestObj = [NSMutableURLRequest requestWithURL:url];
        //url = nil;
        //[requestObj setHTTPMethod:@"Get"];
        
        
        //The following code is needed for asynchronous connections:
        // Clear out any existing connection if there is one
        if (connectionInProgress) {
            [connectionInProgress cancel];
        }
        
        [self startAnimation];
        
        HTMLCode = [[NSMutableString alloc] init];
        
        // Create and initiate the asynchronous connection to the timemap server in order to download all of the mementos for given URL.
        // The connection will itself call the following methods:
        //       connection: didReceiveData
        //       connectionDidFinishLoading
        //       connection: didFailWithError
        connectionInProgress = [[NSURLConnection alloc] initWithRequest:requestObj delegate:self];
        
    } 
    
    else {
        NSLog(@"Alert thrown - No timemap found for orginal resource!");
        NSString *errorTitle = nil;
        NSString *errorMsg = @"No timemap found for original resource";
        alertWithMessage(errorTitle,errorMsg);
        previousButton.enabled = YES;
        nextButton.enabled = NO;
        nowButton.enabled = NO;
        [self setDateToToday:self];
        [self stopAnimation];
        return;
    }
}

-(void)timegateConnectionDidFinishLoading:(NSData *)data {
    // NSLog(@"timegateConnectionDidFinishLoading");
}

-(void)timegateConnectionDidFailWithError:(NSError *)error {
    // NSLog(@"timegateConnectionDidFailWIthError");
    NSString *errorTitle = @"Connection Error";
    NSString *errorMsg = @"Please try again in a bit.";
    alertWithMessage(errorTitle,errorMsg);
    
    [self stopAnimation];
}

// This method will be called several times as the data arrives from the timemap server
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    // NSLog(@"connectionDidRecieveData");
    NSString *temp = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    if (temp != nil)
    {
        [HTMLCode appendString:temp];
    }
}

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    //NSLog(@"didReceiveResponse: %@",response);
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection {
    //NSLog(@"DidFinishLoading");
    
    if (!HTMLCode) {
        NSLog(@"Alert thrown - No results returned from timemap query!");
        NSString *errorTitle = @"Problem with timemap - No results found";
        NSString *errorMsg   = nil;
        alertWithMessage(errorTitle, errorMsg);
        return;
    }
    NSArray *timemapLinks = [HTMLCode componentsSeparatedByString:@"\n"];	// Separate the text lines and store in this temp array
    NSLog(@"Timemap returned %d links.",[timemapLinks count]);
    
    // Now parse the entries in the temp array, timemapLinks, buidling the needed parallel arrays, mementoLink & mementoDate.
    NSArray *mementoField;	// Another scratch array
    for (int i=0; i<[timemapLinks count]; i++) {
        mementoField = [[timemapLinks objectAtIndex:i] componentsSeparatedByString:@";"];  // Split text line i into components by separating based on semicolons
        NSString *temp = [[mementoField objectAtIndex:0] // Trim off leading and trailing whitespace as well as '<' and '>' characters
                          stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        NSString *urlLink = [temp stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
        temp = nil;
        
        if ([mementoField count] > 1)
        {
            NSArray  *relComponents = [[mementoField  objectAtIndex:1] componentsSeparatedByString:@"\""]; // For the 'REL' link, extract the contents of the string
            if ([relComponents count] > 1)
            {
                NSString *relLink = [relComponents objectAtIndex:1];
                // For those entries that have a date field (number of components > 2), add the necessary info to the mementoLink and mementoDate arrays
                NSString *urlDate;
                if ( [mementoField count] > 2 ) {
                    NSArray *dateComponents = [[mementoField objectAtIndex:2] componentsSeparatedByString:@"\""];
                    urlDate = [[NSString alloc] initWithString:[dateComponents objectAtIndex:1]];
                    if ([relLink isEqual:@"first memento"]) {
                        [mementoLink addObject:urlLink];
                        [mementoDate addObject:[self dateFromRFC1123:urlDate]];
                        firstMementoURL  = urlLink;
                        firstMementoDate = [self dateFromRFC1123:urlDate];
                    } else if ([relLink isEqual:@"last memento"]) {
                        [mementoLink addObject:urlLink];
                        [mementoDate addObject:[self dateFromRFC1123:urlDate]];
                        lastMementoURL  = urlLink;
                        lastMementoDate = [self dateFromRFC1123:urlDate];
                    } else if ([relLink isEqual:@"memento"]) {
                        [mementoLink addObject:urlLink];
                        [mementoDate addObject:[self dateFromRFC1123:urlDate]];
                    }
                }
            }
        }
    }
    [mementoLink addObject:requestedURLAddress];	// Add current URL and today's date to the end of the memento arrays
    [mementoDate addObject:[NSDate date]];			// Later code assumes that this is the last entry in the parallel arrays!
    
    
    if ([mementoLink count] != [mementoDate count]) {
        NSLog(@"Something is terribly wrong!  Parallel arrays, mementoLink & mementoDate, are not the same size!");
        NSString *title = @"Internal Error";
        NSString *errorMsg = @"Memento array has been corrupted";
        alertWithMessage(title, errorMsg);
    } else {
        [self mementoArraysDidLoad];	// The arrays are ready!  Go display the web sites!
    }	 
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"Alert thrown - connection didFailWithError");
    alertWithError(error);
}

// Found the next two utility methods online.  They convert internal dates to RFC1123 format and vice versa
-(NSString *)rfc1123String:(NSDate *)date {
    static NSDateFormatter *df = nil;
    if (df == nil) {
        df = [[NSDateFormatter alloc] init];
        df.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
        df.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
        df.dateFormat = @"EEE',' dd MMM yyyy HH':'mm':'ss 'GMT'";
    }
    return [df stringFromDate:date];
}

-(NSDate*)dateFromRFC1123:(NSString*)value_
{
    if(value_ == nil)
        return nil;
    static NSDateFormatter *rfc1123 = nil;
    if(rfc1123 == nil)
    {
        rfc1123 = [[NSDateFormatter alloc] init];
        rfc1123.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
        rfc1123.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
        rfc1123.dateFormat = @"EEE',' dd MMM yyyy HH':'mm':'ss z";
    }
    NSDate *ret = [rfc1123 dateFromString:value_];
    if(ret != nil)
        return ret;
    
    static NSDateFormatter *rfc850 = nil;
    if(rfc850 == nil)
    {
        rfc850 = [[NSDateFormatter alloc] init];
        rfc850.locale = rfc1123.locale;
        rfc850.timeZone = rfc1123.timeZone;
        rfc850.dateFormat = @"EEEE',' dd'-'MMM'-'yy HH':'mm':'ss z";
    }
    ret = [rfc850 dateFromString:value_];
    if(ret != nil)
        return ret;
    
    static NSDateFormatter *asctime = nil;
    if(asctime == nil)
    {
        asctime = [[NSDateFormatter alloc] init];
        asctime.locale = rfc1123.locale;
        asctime.timeZone = rfc1123.timeZone;
        asctime.dateFormat = @"EEE MMM d HH':'mm':'ss yyyy";
    }
    return [asctime dateFromString:value_];
}

@end

