//
//  Settings.h
//  MementoBrowser
//
//  Created by Heather Tweedy on 6/15/12.
//  Copyright (c) 2012 Harding University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"
#import "iPadViewController.h"

@interface Settings : UIViewController<UITableViewDataSource, UITableViewDelegate>
{
    ViewController *vc;
    iPadViewController *ivc;
    NSMutableArray *timeGates;
    UITableView *myTableView;
}

@property (retain, nonatomic) IBOutlet UITableView *myTableView;
@property (nonatomic, retain) NSMutableArray *timeGates;
- (IBAction)touchUpOutside:(id)sender;
- (IBAction)newTimeGate:(id)sender;
@property (retain, nonatomic) IBOutlet UITextField *timeGateField;
@property (nonatomic, retain) ViewController *vc;
@property (nonatomic, retain) iPadViewController *ivc;

-(void) edit;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil ViewController:(ViewController *) view;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil iPadViewController:(iPadViewController *) view;
@end