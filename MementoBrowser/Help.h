//
//  Help.h
//  MementoBrowser
//
//  Created by CS Student on 6/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Help : UIViewController
{
    UIImage *image;
}
@property UIImage *image;
@property (weak, nonatomic) IBOutlet UIImageView *picture;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil image:(NSString *)name;

@end
