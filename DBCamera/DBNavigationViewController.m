//
//  DBNavigationViewController.m
//  DBCamera
//
//  Created by FrancoisJulien ALCARAZ on 3/19/2014.
//  Copyright (c) 2014 PSSD - Daniele Bogo. All rights reserved.
//

#import "DBNavigationViewController.h"

@interface DBNavigationViewController ()

@end

@implementation DBNavigationViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self.navigationBar setTintColor:[UIColor whiteColor]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL) prefersStatusBarHidden
{
    return NO;
}

- (NSArray *)dataArray {
    
    NSArray * array = [NSArray arrayWithObjects:[NSArray arrayWithObjects:[self image1], [self metaData1], nil],[NSArray arrayWithObjects:[self image2], [self metaData2], nil], nil];
    
    return array;
    
}

@end
