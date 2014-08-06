//
//  TableViewController.m
//  MementoBrowser
//
//  Created by Heather Tweedy on 6/13/12.
//  Copyright (c) 2012 Harding University. All rights reserved.
//

#import "TableViewController.h"
#import "MementoMenu.h"
#import "About.h"
#import "ViewController.h"
#import "Settings.h"
#import "YearMenu.h"
#import "iPadViewController.h"
#import "Help.h"
#import "PageDetails.h"

@interface TableViewController ()

@end

@implementation TableViewController
@synthesize itemsList, selectedCellItem, myTableView, dates, links, vc, ivc;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil NSMutableArray:(NSMutableArray *)mementoDate NSMutableArray:(NSMutableArray *)mementoLink NSString:(NSString *)urlAddress NSDate:(NSDate *)date NSString:(NSString *)timeGate ViewController:(ViewController *)it
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (mementoDate.count == 0)
    {
        self.vc = it;
        [vc getMemento:urlAddress forDate:date usingURI:timeGate];
        self.dates = vc.mementoDate;
        self.links = vc.mementoLink;
    }else {
        self.vc = it;
        self.dates = mementoDate;
        self.links = mementoLink;
    }

    if (self) {
        // Custom initialization
    }
    return self;
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil NSMutableArray:(NSMutableArray *)mementoDate NSMutableArray:(NSMutableArray *)mementoLink NSString:(NSString *)urlAddress NSDate:(NSDate *)date NSString:(NSString *)timeGate iPadViewController:(iPadViewController *)it
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (mementoDate.count == 0)
    {
        self.ivc = it;
        [ivc getMemento:urlAddress forDate:date usingURI:timeGate];
        self.dates = ivc.mementoDate;
        self.links = ivc.mementoLink;
    }else {
        self.ivc = it;
        self.dates = mementoDate;
        self.links = mementoLink;
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
    
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:0 reuseIdentifier:CellIdentifier];
        
    }
    
    // Set up the cell...
    
    NSString *cellValue = [itemsList objectAtIndex:indexPath.row];
    
    cell.textLabel.text = cellValue;
    
    if (indexPath.row !=5)
    {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *selectedCell = [NSString stringWithFormat:@"%d", indexPath.row];
    
    if (indexPath.row == 0)
    {
        if (dates.count == 0)
        {
            ;
        }
        else if (dates.count < 30)
        {
            if (ivc == nil)
            {
                MementoMenu *mementos = [[MementoMenu alloc] initWithNibName:@"MementoMenu" bundle:[NSBundle mainBundle] NSMutableArray:dates  NSMutableArray:links ViewController:vc];
                mementos.selectedCellItem = selectedCell;
                [self.navigationController pushViewController:mementos animated:YES];
                
                mementos = nil;
            }
            else {
                MementoMenu *mementos = [[MementoMenu alloc] initWithNibName:@"MementoMenu" bundle:[NSBundle mainBundle] NSMutableArray:dates  NSMutableArray:links iPadViewController:ivc];
                mementos.selectedCellItem = selectedCell;
                [self.navigationController pushViewController:mementos animated:YES];
                
                mementos = nil;
            }

        }
        else {
            if (ivc == nil)
            {
            YearMenu *mementos = [[YearMenu alloc] initWithNibName:@"YearMenu" bundle:[NSBundle mainBundle] NSMutableArray:dates  NSMutableArray:links ViewController:vc];
            mementos.selectedCellItem = selectedCell;
            
            [self.navigationController pushViewController:mementos animated:YES];
            
            mementos = nil;
            }
            else {
                YearMenu *mementos = [[YearMenu alloc] initWithNibName:@"YearMenu" bundle:[NSBundle mainBundle] NSMutableArray:dates  NSMutableArray:links iPadViewController:ivc];
                mementos.selectedCellItem = selectedCell;
                
                [self.navigationController pushViewController:mementos animated:YES];
                
                mementos = nil;
            }
        }
    }
    if (indexPath.row == 1)
    {
        if (ivc == nil)
        {
            Help *help = [[Help alloc] initWithNibName:@"Help" bundle:[NSBundle mainBundle] image:@"iPod help screen.png"];
            [self.navigationController pushViewController:help animated:YES];
            
            help = nil;
        }
        else {
            Help *help = [[Help alloc] initWithNibName:@"Help" bundle:[NSBundle mainBundle] image:@"iPad help screen.png"];
            [self.navigationController pushViewController:help animated:YES];
            
            help = nil;
        }
    }
    if (indexPath.row == 2)
    {
        About *about = [[About alloc] initWithNibName:@"About" bundle:[NSBundle mainBundle]];
        //about.selectedCellItem = selectedCellItem;
        
        [self.navigationController pushViewController:about animated:YES];
        
        about = nil;
    }
    if (indexPath.row == 3)
    {
        if (ivc == nil)
        {
            Settings *settings = [[Settings alloc] initWithNibName:@"Settings" bundle:[NSBundle mainBundle] ViewController:vc];
        
            [self.navigationController pushViewController:settings animated:YES];
        
            settings = nil;
        }
        else {
            Settings *settings = [[Settings alloc] initWithNibName:@"Settings" bundle:[NSBundle mainBundle] iPadViewController:ivc];
            
            [self.navigationController pushViewController:settings animated:YES];
            
            settings = nil;
        }
    }
    if (indexPath.row == 4)
    {
        if (ivc == nil)
        {
            PageDetails *details = [[PageDetails alloc] initWithNibName:@"PageDetails" bundle:[NSBundle mainBundle] apiURL:vc.webView.request.URL.absoluteString originalURL:vc.URLtextField.text requestedDate:vc.requestedDate displayedDate:vc.btnActualDate.text];
            
            [self.navigationController pushViewController:details animated:YES];
            
            details = nil;
        }
        else {
            PageDetails *details = [[PageDetails alloc] initWithNibName:@"PageDetails" bundle:[NSBundle mainBundle] apiURL:ivc.webView.request.URL.absoluteString originalURL:ivc.URLtextField.text requestedDate:ivc.requestedDate displayedDate:ivc.btnActualDate.text];
            
            [self.navigationController pushViewController:details animated:YES];
            
            details = nil;
        }
    }
    
    if (indexPath.row == 5)
    {
        NSURL *url = [NSURL URLWithString:@"http://www.mementoweb.org/guide/quick-intro/"];
        [[UIApplication sharedApplication] openURL: url];
    }
        
    
}

-(void)loadView{
    
    myTableView = [[UITableView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame] style:UITableViewStylePlain];
    
    myTableView.delegate = self;
    
    myTableView.dataSource = self;
    
    myTableView.autoresizesSubviews = YES;
    
    itemsList = [[NSMutableArray alloc] init];
    
    [itemsList addObject:@"Mementos"];
    
    [itemsList addObject:@"Help"];
    
    [itemsList addObject:@"About"];
    
    [itemsList addObject:@"Settings"];
    
    [itemsList addObject:@"Page Details"];
    
    [itemsList addObject:@"Learn More"];
    
    self.navigationItem.title = @"Menu";
    
    self.view = myTableView;
    
}

@end
