//
//  Help.m
//  MementoBrowser
//
//  Created by CS Student on 6/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Help.h"

@interface Help ()

@end

@implementation Help
@synthesize picture, image;



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    image = [UIImage imageNamed:@"iPod help screen.png"];
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil image:(NSString *)name
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    self.image = [UIImage imageNamed:name];
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    [picture setImage:image];
}

- (void)viewDidUnload
{
    [self setPicture:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

@end
