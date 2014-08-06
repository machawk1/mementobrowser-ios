//
//  YearMenu.m
//  MementoBrowser
//
//  Created by Heather Tweedy on 6/18/12.
//  Copyright (c) 2012 Harding University. All rights reserved.
//

#import "YearMenu.h"
#import "MementoMenu.h"
#import "ViewController.h"
#import "iPadViewController.h"

@interface YearMenu ()

@end

@implementation YearMenu
@synthesize selectedCellItem, myTableView, dates, links,dateFormatter, vc, years, ivc;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil NSMutableArray:(NSMutableArray *) datesArray NSMutableArray:(NSMutableArray *)linksArray ViewController:(ViewController *)view;
{
    self.dateFormatter = [[NSDateFormatter alloc] init];
	[self.dateFormatter setDateStyle:NSDateFormatterMediumStyle];
	[self.dateFormatter setTimeStyle:NSDateFormatterNoStyle];
	[self.dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    self.vc = [[ViewController alloc] init];
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    self.vc = view;
    self.dates = datesArray;
    self.links = linksArray;
    self.years = [[NSMutableArray alloc] init];
    
    for (NSDate *d in self.dates)
    {
        NSString *s = [dateFormatter stringFromDate:d];
        NSArray *temp;
        temp = [s componentsSeparatedByString:@", "];
        if (![years containsObject:[temp objectAtIndex:1]])
        {
            [years addObject:[temp objectAtIndex:1]];
        }
    }
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil NSMutableArray:(NSMutableArray *) datesArray NSMutableArray:(NSMutableArray *)linksArray iPadViewController:(iPadViewController *)view;
{
    self.dateFormatter = [[NSDateFormatter alloc] init];
	[self.dateFormatter setDateStyle:NSDateFormatterMediumStyle];
	[self.dateFormatter setTimeStyle:NSDateFormatterNoStyle];
	[self.dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    self.ivc = [[iPadViewController alloc] init];
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    self.ivc = view;
    self.dates = datesArray;
    self.links = linksArray;
    self.years = [[NSMutableArray alloc] init];
    
    for (NSDate *d in self.dates)
    {
        NSString *s = [dateFormatter stringFromDate:d];
        NSArray *temp;
        temp = [s componentsSeparatedByString:@", "];
        if (![years containsObject:[temp objectAtIndex:1]])
        {
            [years addObject:[temp objectAtIndex:1]];
        }
    }
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [years count];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:0 reuseIdentifier:CellIdentifier];
        
    }
    
    // Set up the cell...
    
    
    if (years.count != 0)
    {
        NSString *cellDetail = [years objectAtIndex:indexPath.row];
        cell.textLabel.text = cellDetail;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (ivc == nil)
    {
        MementoMenu *mementos = [[MementoMenu alloc] initWithNibName:@"MementoMenu" bundle:[NSBundle mainBundle] NSMutableArray:dates  NSMutableArray:links ViewController:vc NSString:[years objectAtIndex:indexPath.row]];
    
        [self.navigationController pushViewController:mementos animated:YES];
    
        mementos = nil;
    }
    else {
        MementoMenu *mementos = [[MementoMenu alloc] initWithNibName:@"MementoMenu" bundle:[NSBundle mainBundle] NSMutableArray:dates  NSMutableArray:links iPadViewController:ivc NSString:[years objectAtIndex:indexPath.row]];
        
        [self.navigationController pushViewController:mementos animated:YES];
        
        mementos = nil;
    }
    
}

-(void)loadView{
    
    myTableView = [[UITableView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame] style:UITableViewStylePlain];
    
    myTableView.delegate = self;
    
    myTableView.dataSource = self;
    
    myTableView.autoresizesSubviews = YES;
    
    self.navigationItem.title = @"Years";
    
    self.view = myTableView;
    
}

@end


