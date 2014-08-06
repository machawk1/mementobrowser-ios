//
//  MementoMenu.m
//  MementoBrowser
//
//  Created by Heather Tweedy on 6/13/12.
//  Copyright (c) 2012 Harding University. All rights reserved.
//

#import "MementoMenu.h"
#import "ViewController.h"

@interface MementoMenu ()

@end

@implementation MementoMenu
@synthesize itemsList, selectedCellItem, myTableView, dates, links,dateFormatter, vc, year, ivc;

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
    subscripts = [[NSMutableArray alloc] init];
    if (self) {
        // Custom initialization
    }
    last = datesArray.count;
    int count = 0;
    for (NSDate *d in datesArray)
    {
        [subscripts addObject:[NSNumber numberWithInteger: count]];
        count++;
    }
    
    
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil NSMutableArray:(NSMutableArray *) datesArray NSMutableArray:(NSMutableArray *)linksArray ViewController:(ViewController *)view NSString:(NSString *)y;
{
    self.dateFormatter = [[NSDateFormatter alloc] init];
	[self.dateFormatter setDateStyle:NSDateFormatterMediumStyle];
	[self.dateFormatter setTimeStyle:NSDateFormatterNoStyle];
	[self.dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    self.vc = [[ViewController alloc] init];
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    self.vc = view;
    self.year = y;
    self.dates = [[NSMutableArray alloc] init];
    self.links = [[NSMutableArray alloc] init];
    subscripts = [[NSMutableArray alloc] init];
    last = datesArray.count;
    int count = 0;
    for (NSDate *d in datesArray)
    {
        NSString *s = [dateFormatter stringFromDate:d];
        if ([s hasSuffix:year])
        {
            [subscripts addObject:[NSNumber numberWithInteger: count]];
            [self.dates addObject: d];
            [self.links addObject:[linksArray objectAtIndex:count]];
        }
        count++;
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
    subscripts = [[NSMutableArray alloc] init];
    if (self) {
        // Custom initialization
    }
    last = datesArray.count;
    int count = 0;
    for (NSDate *d in datesArray)
    {
        [subscripts addObject:[NSNumber numberWithInteger: count]];
        count++;
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil NSMutableArray:(NSMutableArray *) datesArray NSMutableArray:(NSMutableArray *)linksArray iPadViewController:(iPadViewController *)view NSString:(NSString *)y;
{
    self.dateFormatter = [[NSDateFormatter alloc] init];
	[self.dateFormatter setDateStyle:NSDateFormatterMediumStyle];
	[self.dateFormatter setTimeStyle:NSDateFormatterNoStyle];
	[self.dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    self.ivc = [[iPadViewController alloc] init];
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    self.ivc = view;
    self.year = y;
    self.dates = [[NSMutableArray alloc] init];
    self.links = [[NSMutableArray alloc] init];
    subscripts = [[NSMutableArray alloc] init];
    last = datesArray.count;
    int count = 0;
    for (NSDate *d in datesArray)
    {
        NSString *s = [dateFormatter stringFromDate:d];
        if ([s hasSuffix:year])
        {
            [subscripts addObject:[NSNumber numberWithInteger: count]];
            [self.dates addObject: d];
            [self.links addObject:[linksArray objectAtIndex:count]];
        }
        count++;
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
    
    return [links count];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        
    }
    
    // Set up the cell...
    
    
    if (dates.count != 0)
    {
        NSString *cellDetail = [dateFormatter stringFromDate:[dates objectAtIndex:indexPath.row]];
        NSDate *date = [dates objectAtIndex:indexPath.row];
        NSArray *temp = [date.description componentsSeparatedByString:@" "];
        NSArray *time = [[temp objectAtIndex:1] componentsSeparatedByString:@":"];
        NSString *clockTime = [[NSString alloc]init];
        if([[time objectAtIndex:0] intValue] <= 12)
        {
            int i = [[time objectAtIndex:0] intValue];
            clockTime = [NSString stringWithFormat:@"%d",i];
            clockTime = [clockTime stringByAppendingString: @":"];
            clockTime = [clockTime stringByAppendingString:[time objectAtIndex:1]];
            clockTime = [clockTime stringByAppendingString: @" am"];
        }
        else {
            int i = [[time objectAtIndex:0] intValue];
            clockTime = [NSString stringWithFormat:@"%d",(i-12)];
            clockTime = [clockTime stringByAppendingString:@":"];
            clockTime = [clockTime stringByAppendingString:[time objectAtIndex:1]];
            clockTime = [clockTime stringByAppendingString:@" pm"];
        }
        cell.textLabel.text = cellDetail;
        cell.detailTextLabel.text = clockTime;
    }
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //Opens selected Memento in main page and updates the displayed date
    if (vc == nil)
    {
        ivc.lastSender = @"menu";
        ivc.actualDate = [dates objectAtIndex:indexPath.row];
        ivc.currentMementoSubscript = [[subscripts objectAtIndex:indexPath.row] intValue];
        //ivc.URLtextField.text = ivc.oldURL;
        ivc.btnActualDate.text = [dateFormatter stringFromDate:ivc.actualDate];
        if(ivc.currentMementoSubscript == 0)
        {
            ivc.previousButton.enabled = NO;
            ivc.nowButton.enabled = YES;
            ivc.nextButton.enabled = YES;
        } else if ([ivc.btnActualDate.text isEqualToString:[dateFormatter stringFromDate:[NSDate date]]])
        {
            ivc.nowButton.enabled = NO;
            ivc.nextButton.enabled = NO;
        }
        else {
            ivc.previousButton.enabled = YES;
            ivc.nextButton.enabled = YES;
            ivc.nowButton.enabled = YES;
        }
        [ivc displayWebPage:[links objectAtIndex:indexPath.row]];
        [self.navigationController popToViewController:ivc animated:YES];
        
    }else {
        vc.lastSender = @"menu";
        vc.actualDate = [dates objectAtIndex:indexPath.row];
        vc.currentMementoSubscript = [[subscripts objectAtIndex:indexPath.row] intValue];
        //vc.URLtextField.text = vc.oldURL;
        vc.btnActualDate.text = [dateFormatter stringFromDate:vc.actualDate];
        if(vc.currentMementoSubscript == 0)
        {
            vc.previousButton.enabled = NO;
            vc.nowButton.enabled = YES;
            vc.nextButton.enabled = YES;
        } else if ([vc.btnActualDate.text isEqualToString:[dateFormatter stringFromDate:[NSDate date]]])
        {
                vc.nowButton.enabled = NO;
                vc.nextButton.enabled = NO;
        }
        else {
            vc.previousButton.enabled = YES;
            vc.nextButton.enabled = YES;
            vc.nowButton.enabled = YES;
        }
        [vc displayWebPage:[links objectAtIndex:indexPath.row]];
        [self.navigationController popToViewController:vc animated:YES];
    }

       
}

-(void)loadView{
    
    myTableView = [[UITableView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame] style:UITableViewStylePlain];
    
    myTableView.delegate = self;
    
    myTableView.dataSource = self;
    
    myTableView.autoresizesSubviews = YES;
    
    self.navigationItem.title = @"Mementos";
    
    self.view = myTableView;
    
}

@end

