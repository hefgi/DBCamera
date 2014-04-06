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
    
    UIBarButtonItem *sendButton = [[UIBarButtonItem alloc] initWithTitle:@"Send"
                                                                   style:UIBarButtonItemStyleBordered
                                                                  target:self
                                                                  action:@selector(sendButtonPressed:)];
    
    self.navigationItem.rightBarButtonItem = sendButton;
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back-btn"]
                                                                   style:UIBarButtonItemStyleBordered
                                                                  target:self
                                                                  action:@selector(goBack:)];
    
    self.navigationItem.leftBarButtonItem = backButton;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.0];
    [UIView setAnimationDelay:0.0];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    
    [self.textView becomeFirstResponder];  // <---- Only edit this line
    
    [UIView commitAnimations];

    self.navigationItem.title = @"Description";

}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    [self.imageView1 setImage:[(DBNavigationViewController *)[self navigationController] image1]];
    [self.imageView2 setImage:[(DBNavigationViewController *)[self navigationController] image2]];

    [self.imageView1.layer setCornerRadius:8.0];
    [self.imageView1.layer setMasksToBounds:YES];
    [self.imageView2.layer setCornerRadius:8.0];
    [self.imageView2.layer setMasksToBounds:YES];

    if (!HUD) {
        HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
        [self.navigationController.view addSubview:HUD];
        HUD.animationType = MBProgressHUDAnimationFade;
        HUD.delegate = self;
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    }
    
    HUD.mode = MBProgressHUDModeDeterminate;
    HUD.labelText = @"Upload...";

}

- (void)goBack:(id)sender {
    
    NSLog(@"goBack DBResultsViewController");
    
    self.navigationItem.title = @"";
    
    UIViewController * previousVC = [self.navigationController.viewControllers objectAtIndex:([self.navigationController.viewControllers count] - 2)];
    
    previousVC.navigationItem.title = @"Photo 2";
    
    [self.navigationController popViewControllerAnimated:YES];
    
}


- (IBAction)sendButtonPressed:(id)sender {
    
    PFObject *wave = [PFObject objectWithClassName:@"Wave"];
    wave[@"text"] = self.textView.text;
    wave[@"user"] = [PFUser currentUser];
    
    NSData *imageData1 = UIImageJPEGRepresentation([(DBNavigationViewController*)self.navigationController image1], 0.8f);
    PFFile *imageFile1 = [PFFile fileWithName:@"image1.jpg" data:imageData1];
    
    PFObject *img1 = [PFObject objectWithClassName:@"Images"];
    img1[@"img"] = imageFile1;
    img1[@"order"] = @1;
//    img1[@"wave"] = wave;
    
    NSData *imageData2 = UIImageJPEGRepresentation([(DBNavigationViewController*)self.navigationController image2], 0.8f);
    PFFile *imageFile2 = [PFFile fileWithName:@"image2.jpg" data:imageData2];
    
    PFObject *img2 = [PFObject objectWithClassName:@"Images"];
    img2[@"img"] = imageFile2;
    img2[@"order"] = @2;
    wave[@"images"] = [NSArray arrayWithObjects:img1, img2, nil];
    
    [HUD show:YES];
    
    [imageFile1 saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        
        if (succeeded) {
            NSLog(@"SUCCESS UPLOAD IMG 1");
            
            [imageFile2 saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                
                if (succeeded) {
                    NSLog(@"SUCCESS UPLOAD IMG 2");
                    
                    [wave saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                        if (succeeded) {
                            NSLog(@"Wave sent to backend : succeded");
                            
                            [HUD hide:YES];
                            
                            [self uploadCompleted];
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
                HUD.progress = 0.5 + ((percentDone/2) /100);

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
        
        HUD.progress = (percentDone / 2)/100;

    }];
}

- (void)uploadCompleted {

    if ( [_delegate respondsToSelector:@selector(captureImagesDidFinish:)] ) {

        [_delegate captureImagesDidFinish:[(DBNavigationViewController *)self.navigationController dataArray]];
        
    }
}

#pragma mark -
#pragma mark MBProgressHUDDelegate methods

- (void)hudWasHidden:(MBProgressHUD *)hud {
	// Remove HUD from screen when the HUD was hidded
	[HUD removeFromSuperview];
	HUD = nil;
}

@end
