//
//  DBResultsViewController.h
//  DBCamera
//
//  Created by FrancoisJulien ALCARAZ on 3/19/2014.
//  Copyright (c) 2014 PSSD - Daniele Bogo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBCameraDelegate.h"

@interface DBResultsViewController : UIViewController

- (IBAction)cancelButtonPressed:(id)sender;
- (IBAction)sendButtonPressed:(id)sender;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView1;
@property (weak, nonatomic) IBOutlet UIImageView *imageView2;
@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;

@property (nonatomic, weak) id <DBCameraViewControllerDelegate> delegate;

@end
