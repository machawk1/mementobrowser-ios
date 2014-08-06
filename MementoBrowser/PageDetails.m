//
//  PageDetails.m
//  MementoBrowser
//
//  Created by CS Student on 6/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PageDetails.h"

@interface PageDetails ()

@end

@implementation PageDetails
@synthesize requestedLabel;
@synthesize requestedDate;
@synthesize mementoLabel;
@synthesize originalURL, memento, displayedDate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil apiURL:(NSString *)api originalURL:(NSString *)original requestedDate:(NSString *)requested displayedDate:(NSString *)displayed
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    URL1 = original;
    URL2 = api;
    date1 = requested;
    date2 = displayed;
    
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    originalURL.text = URL1;
    
    displayedDate.text = date2;
    if ([URL1 isEqualToString:URL2])
    {
        memento.hidden = YES;
        mementoLabel.hidden = YES;
    }
    else {
        memento.text = URL2;
    }
    
    //Only shows requested date fields if a date was requested
    if ([date1 isEqualToString:@""])
    {
        requestedDate.hidden = YES;
        requestedLabel.hidden = YES;
    }
    else {
        requestedDate.text = date1;
    }
}

- (void)viewDidUnload
{
    [self setOriginalURL:nil];
    [self setMemento:nil];
    [self setDisplayedDate:nil];
    [self setRequestedLabel:nil];
    [self setRequestedDate:nil];
    [self setDisplayedDate:nil];
    [self setMementoLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

@end
