//
//  YearMenu.h
//  MementoBrowser
//
//  Created by Heather Tweedy on 6/18/12.
//  Copyright (c) 2012 Harding University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"
#import "iPadViewController.h"

@interface YearMenu : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    NSString *selectedCellItem;
    UITableView *myTableView;
    NSMutableArray *years;
    NSMutableArray *dates;
    NSMutableArray *links;
    ViewController *vc;
    iPadViewController *ivc;
}
@property (nonatomic, retain) ViewController *vc;
@property (nonatomic, retain) iPadViewController *ivc;
@property (nonatomic, retain) NSDateFormatter *dateFormatter;
@property (nonatomic, retain) NSMutableArray *years;
@property(nonatomic, retain) NSMutableArray *dates;
@property(nonatomic, retain) NSMutableArray *links;
@property (nonatomic, retain) NSString *selectedCellItem;
@property (nonatomic, retain) UITableView *myTableView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil NSMutableArray:(NSMutableArray *) datesArray NSMutableArray:(NSMutableArray *)linksArray ViewController:(ViewController *)view;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil NSMutableArray:(NSMutableArray *) datesArray NSMutableArray:(NSMutableArray *)linksArray iPadViewController:(iPadViewController *)view;

@end
