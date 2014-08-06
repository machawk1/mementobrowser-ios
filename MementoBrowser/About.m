//
//  About.m
//  MementoBrowser
//
//  Created by Heather Tweedy on 6/13/12.
//  Copyright (c) 2012 Harding University. All rights reserved.
//

#import "About.h"

@interface About ()

@end

@implementation About


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"About";
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (IBAction)moreInfo:(id)sender {
    //Opens web page in Safari
    NSURL *url = [NSURL URLWithString:@"http://code.google.com/p/memento-browser/wiki/HelpiOS"];
    [[UIApplication sharedApplication] openURL: url];
}
@end
