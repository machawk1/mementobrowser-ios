//
//  TableViewController.h
//  MementoBrowser
//
//  Created by Heather Tweedy on 6/13/12.
//  Copyright (c) 2012 Harding University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"
#import "iPadViewController.h"

@interface TableViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    NSString *selectedCellItem;
    UITableView *myTableView;
    NSMutableArray *itemsList;
    NSMutableArray *dates;
    NSMutableArray *links;
    ViewController *vc;
    iPadViewController *ivc;
}

@property (nonatomic, retain) ViewController *vc;
@property (nonatomic, retain) iPadViewController *ivc;
@property (nonatomic, retain) NSString *selectedCellItem;
@property (nonatomic, retain) UITableView *myTableView;
@property (nonatomic, retain) NSMutableArray *itemsList;
@property (nonatomic, retain) NSMutableArray *dates;
@property (nonatomic, retain) NSMutableArray *links;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil NSMutableArray:(NSMutableArray *)mementoDate NSMutableArray:(NSMutableArray *)mementoLink NSString:(NSString *)urlAddress NSDate:(NSDate *)date NSString:(NSString *)timeGate ViewController:(ViewController *)it;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil NSMutableArray:(NSMutableArray *)mementoDate NSMutableArray:(NSMutableArray *)mementoLink NSString:(NSString *)urlAddress NSDate:(NSDate *)date NSString:(NSString *)timeGate iPadViewController:(iPadViewController *)it;

@end
