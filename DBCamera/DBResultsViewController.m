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
    
    PFObject *wave = [PFObject objectWithClassName:@"Wave"];
    wave[@"text"] = self.textView.text;
    wave[@"user"] = [PFUser currentUser];
    
    NSData *imageData1 = UIImagePNGRepresentation([(DBNavigationViewController*)self.navigationController image1]);
    PFFile *imageFile1 = [PFFile fileWithName:@"image1.png" data:imageData1];
    
    PFObject *img1 = [PFObject objectWithClassName:@"Images"];
    img1[@"img"] = imageFile1;
    img1[@"order"] = @1;
//    img1[@"wave"] = wave;
    
    NSData *imageData2 = UIImagePNGRepresentation([(DBNavigationViewController*)self.navigationController image2]);
    PFFile *imageFile2 = [PFFile fileWithName:@"image2.png" data:imageData2];
    
    PFObject *img2 = [PFObject objectWithClassName:@"Images"];
    img2[@"img"] = imageFile2;
    img2[@"order"] = @2;
//    img2[@"wave"] = wave;
    
    wave[@"images"] = [NSArray arrayWithObjects:img1, img2, nil];
    
    [imageFile1 saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        
        if (succeeded) {
            NSLog(@"SUCCESS UPLOAD IMG 1");
            
            [imageFile2 saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                
                if (succeeded) {
                    NSLog(@"SUCCESS UPLOAD IMG 2");
                    
                    [wave saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                        if (succeeded) {
                            NSLog(@"Wave sent to backend : succeded");
                        }
                        else {
                            NSLog(@"Wave sent to backend : not succeded");
                        }

                        if (error) {
                            NSLog(@"Wave sent to backend ERROR : %@", [error description]);
                        }
                    }];
                    
                }
                else {
                    NSLog(@"NOT SUCCESS UPLOAD IMG 2");
                }
                if (error) {
                    NSLog(@"ERROR UPLOAD IMG 2 : %@", [error description]);
                }
                
            } progressBlock:^(int percentDone) {
                
            }];
            
        }
        else {
            NSLog(@"NOT SUCCESS UPLOAD IMG 1");
        }
        if (error) {
            NSLog(@"ERROR UPLOAD IMG 1 : %@", [error description]);
        }
        
    } progressBlock:^(int percentDone) {
        NSLog(@"percentDone IMG1 : %d", percentDone);

    }];


    if ( [_delegate respondsToSelector:@selector(captureImagesDidFinish:)] ) {

        [_delegate captureImagesDidFinish:[(DBNavigationViewController *)self.navigationController dataArray]];
        
    }
}
@end
