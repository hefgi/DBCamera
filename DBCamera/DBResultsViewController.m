//
//  DBResultsViewController.m
//  DBCamera
//
//  Created by FrancoisJulien ALCARAZ on 3/19/2014.
//  Copyright (c) 2014 PSSD - Daniele Bogo. All rights reserved.
//

#import "DBResultsViewController.h"
#import "DBNavigationViewController.h"
#import "UIImage+Crop.h"

@interface DBResultsViewController ()

@end

@implementation DBResultsViewController

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
//    [self.textView becomeFirstResponder];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.0];
    [UIView setAnimationDelay:0.0];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    
    [self.textView becomeFirstResponder];  // <---- Only edit this line
    
    [UIView commitAnimations];
    
//    [self.imageView1 setImage:[UIImage createRoundedRectImage:[(DBNavigationViewController *)[self navigationController] image1] size:self.imageView1.frame.size roundRadius:8]];
    
//    [self.imageView1 setImage:[(DBNavigationViewController *)[self navigationController] image1]];
    
//    [self.imageView2 setImage:[UIImage createRoundedRectImage:[(DBNavigationViewController *)[self navigationController] image2] size:self.imageView2.frame.size roundRadius:8]];
    
//    [self.imageView2 setImage:[(DBNavigationViewController *)[self navigationController] image2]];

    [self.toolBar setBarTintColor:[UIColor colorWithRed:0.235 green:0.769 blue:0.8 alpha:1.0]];
    
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    [self.imageView1 setImage:[(DBNavigationViewController *)[self navigationController] image1]];
    [self.imageView2 setImage:[(DBNavigationViewController *)[self navigationController] image2]];

    [self.imageView1.layer setCornerRadius:8.0];
    [self.imageView1.layer setMasksToBounds:YES];
    [self.imageView2.layer setCornerRadius:8.0];
    [self.imageView2.layer setMasksToBounds:YES];

//    [self.textView becomeFirstResponder];

}

- (IBAction)cancelButtonPressed:(id)sender {
    
//    if ( _delegate && [_delegate respondsToSelector:@selector(dismissCamera)] )
//        [_delegate dismissCamera];
//    else
//        [self dismissViewControllerAnimated:YES completion:nil];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)sendButtonPressed:(id)sender {
    
    if ( [_delegate respondsToSelector:@selector(captureImagesDidFinish:)] ) {

        
        [_delegate captureImagesDidFinish:[(DBNavigationViewController *)self.navigationController dataArray]];
        
    }
    
}
@end
