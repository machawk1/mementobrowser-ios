//
//  Settings.m
//  MementoBrowser
//
//  Created by Heather Tweedy on 6/15/12.
//  Copyright (c) 2012 Harding University. All rights reserved.
//

#import "Settings.h"
#import "ViewController.h"
#import "iPadViewController.h"

@interface Settings ()

@end

@implementation Settings
@synthesize myTableView;
@synthesize timeGateField;
@synthesize vc, timeGates, ivc;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil ViewController:(ViewController *)view
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    self.vc = view;
    
    //Initialize standardUserDefaults if it isn't already initialized
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"timeGates"] != nil)
    {
    timeGates = [[NSUserDefaults standardUserDefaults] objectForKey:@"timeGates"];
    }
    else {
        //Make sure the default timegate is always there
        timeGates = [[NSMutableArray alloc] init];
        [timeGates addObject:@"http://mementoproxy.lanl.gov/aggr/timegate/"];
    }
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil iPadViewController:(iPadViewController *)view
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    self.ivc = view;
    //Initialize standardUserDefaults if it isn't already initialized
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"timeGates"] != nil)
    {
        timeGates = [[NSUserDefaults standardUserDefaults] objectForKey:@"timeGates"];
    }
    else {
        //Make sure the default timegate is always there
        timeGates = [[NSMutableArray alloc] init];
        [timeGates addObject:@"http://mementoproxy.lanl.gov/aggr/timegate/"];
    }
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appTermination) name:@"UIApplicationWillTerminateNotification" object:nil];
    self.navigationItem.title = @"Settings";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStyleBordered target:self action:@selector(edit)];

    //Displays the current timegate
    if (ivc == nil)
    {
        timeGateField.text = vc.timeGate;
    }
    else {
        timeGateField.text = ivc.timeGate;
    }
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [timeGates count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:0 reuseIdentifier:CellIdentifier];
        
    }
    
    // Set up the cell...
    

    NSString *cellValue = [timeGates objectAtIndex:(indexPath.row)];
    cell.textLabel.text = cellValue;

    cell.textLabel.adjustsFontSizeToFitWidth = YES;
    return cell;
    
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *) indexPath
{
    //Makes sure that the default timegate cannot be deleted
    if (indexPath.row == 0)
    {
        return NO;
    }
    else {
        return YES;
    }
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Allows the timegate list to be edited
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        [timeGates removeObjectAtIndex:indexPath.row];
        [[NSUserDefaults standardUserDefaults] setObject:timeGates forKey:@"timeGates"];
        [myTableView reloadData];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //Sets the current timegate to the timegate selected from the list
    if ([self.navigationItem.rightBarButtonItem.title isEqualToString:@"Edit"])
    {
        ivc.timeGate = [timeGates objectAtIndex:indexPath.row];
        vc.timeGate = [timeGates objectAtIndex:indexPath.row];
        timeGateField.text = [timeGates objectAtIndex:indexPath.row];
    }
}


- (void) appTermination:(id)sender
{
    //Saves timegate list upon app termination
    [[NSUserDefaults standardUserDefaults] setObject:timeGates forKey:@"timeGates"];
}

- (void)viewDidUnload
{
    [self setTimeGateField:nil];
    [self setMyTableView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void) edit
{
    //Enables proper buttons for editing
    if ([self.navigationItem.rightBarButtonItem.title isEqualToString:@"Edit"])
        {
            self.navigationItem.rightBarButtonItem.title = @"Done";
            [myTableView setEditing:YES animated:YES];
            [myTableView reloadData];
        }
    else {
        self.navigationItem.rightBarButtonItem.title = @"Edit";
        [myTableView setEditing:NO animated:NO];
        [myTableView reloadData];
    }
        
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (IBAction)newTimeGate:(id)sender {
    //Adds user input as a new timegate
    [timeGateField resignFirstResponder];
    if (ivc == nil)
    {
        vc.timeGate = timeGateField.text;
    }
    else {
        ivc.timeGate = timeGateField.text;
    }
    if (![timeGates containsObject:timeGateField.text])
    {
        [timeGates addObject:timeGateField.text];
    }
    [[NSUserDefaults standardUserDefaults] setObject:timeGates forKey:@"timeGates"];
    [myTableView reloadData];
}

- (IBAction)touchUpOutside:(id)sender {
    [timeGateField resignFirstResponder];
}

@end
