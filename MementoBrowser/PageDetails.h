//
//  PageDetails.h
//  MementoBrowser
//
//  Created by CS Student on 6/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PageDetails : UIViewController
{
    NSString *URL1;
    NSString *URL2;
    NSString *date1;
    NSString *date2;
}

@property (retain, nonatomic) IBOutlet UITextField *originalURL;
@property (retain, nonatomic) IBOutlet UITextField *memento;
@property (retain, nonatomic) IBOutlet UILabel *displayedDate;
@property (retain, nonatomic) IBOutlet UILabel *requestedLabel;
@property (retain, nonatomic) IBOutlet UILabel *requestedDate;
@property (retain, nonatomic) IBOutlet UILabel *mementoLabel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil apiURL:(NSString *)api originalURL:(NSString *)original requestedDate:(NSString *)requested displayedDate:(NSString *)displayed;

@end
