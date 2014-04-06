//
//  DBCameraUseViewController.m
//  DBCamera
//
//  Created by iBo on 11/02/14.
//  Copyright (c) 2014 PSSD - Daniele Bogo. All rights reserved.
//

#import "DBCameraSegueViewController.h"
#import "DBCameraMacros.h"
#import "DBCameraSegueView.h"
#import "UIImage+Crop.h"
#import "DBNavigationViewController.h"
#import "DBCameraContainer.h"
#import "DBResultsViewController.h"

@interface DBCameraSegueViewController () <DBCameraSegueViewDelegate> {
    DBCameraSegueView *_containerView;
}

@end

@implementation DBCameraSegueViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_7_0
    [self setEdgesForExtendedLayout:UIRectEdgeNone];
#endif
    [self.view setUserInteractionEnabled:YES];
//    [self.view setBackgroundColor:[UIColor blackColor]];
    [self.view setBackgroundColor:[UIColor greenColor]];

    _containerView = [[DBCameraSegueView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
//    [_containerView setBackgroundColor:RGBColor(0x202020, 1)];
    [_containerView setBackgroundColor:[UIColor redColor]];
    [_containerView setAutoresizingMask:UIViewAutoresizingFlexibleHeight];
    [_containerView setDelegate:self];
    [_containerView buildButtonInterface];
    [self.view addSubview:_containerView];
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back-btn"]
                                                                   style:UIBarButtonItemStyleBordered
                                                                  target:self
                                                                  action:@selector(goBack:)];
    
    self.navigationItem.leftBarButtonItem = backButton;
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [_containerView.imageView setImage:self.capturedImage];
    
    CGFloat newHeight = [self getNewHeight];
//    CGFloat newY = ((CGRectGetHeight([[UIScreen mainScreen] bounds]) - 60) * .5) - (newHeight * .5);
    CGFloat newY = ((CGRectGetHeight([[UIScreen mainScreen] bounds])) * .5) - (newHeight * .5);

//    [_containerView.imageView setFrame:(CGRect){ _containerView.imageView.frame.origin.x, newY + 60.0f,
//                                                 CGRectGetWidth(_containerView.imageView.frame), newHeight }];
    [_containerView.imageView setFrame:(CGRect){ _containerView.imageView.frame.origin.x, 0,
        CGRectGetWidth(_containerView.imageView.frame), newHeight }];

    [_containerView.imageView setDefaultCenter:_containerView.imageView.center];
    
    NSLog(@"viewWillAppear SegueViewController");

    if ([(DBNavigationViewController *)[self navigationController] imageCount] == 0) {
        self.navigationItem.title = @"Photo 1";
    }
    else {
        self.navigationItem.title = @"Photo 2";
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
}

- (CGFloat) getNewHeight
{
    return ( CGRectGetWidth([[UIScreen mainScreen] bounds]) * self.capturedImage.size.height ) / self.capturedImage.size.width;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL) prefersStatusBarHidden
{
    return YES;
}

- (void) setCapturedImage:(UIImage *)capturedImage
{
    _capturedImage = capturedImage;
}

- (void)goBack:(id)sender {
    
    NSLog(@"goBack SegueViewController");
    
    self.navigationItem.title = @"";
    
    UIViewController * previousVC = [self.navigationController.viewControllers objectAtIndex:([self.navigationController.viewControllers count] - 2)];

    if ([(DBNavigationViewController *)[self navigationController] imageCount] == 0) {
        previousVC.navigationItem.title = @"Photo 1";
    }
    else {
        previousVC.navigationItem.title = @"Photo 2";
    }
    
    [self.navigationController popViewControllerAnimated:YES];

}

#pragma mark - DBCameraViewDelegate

- (void) retakeImageFromCameraView:(DBCameraSegueView *)cameraView
{
//    if ([(DBNavigationViewController *)[self navigationController] imageCount] == 1) {
//        [(DBNavigationViewController *)[self navigationController] setImageCount:0];
//    }
//    [self.navigationController popViewControllerAnimated:YES];
    
    [self goBack:nil];
}

- (void) useImageFromCameraView:(DBCameraSegueView *)cameraView
{
    
    if ([(DBNavigationViewController *)[self navigationController] imageCount] == 0) {
        
        NSLog(@"FIRST SHOT");
        
        UIImage * cropImage = [[UIImage screenshotFromView:self.view] croppedImage:(CGRect){ 0, IS_RETINA_4 ? 308 : 220, 640, 640 }];
        
        [(DBNavigationViewController *)self.navigationController setImage1:cropImage];
        [(DBNavigationViewController *)self.navigationController setMetaData1:self.capturedImageMetadata];
        
        [(DBNavigationViewController *)self.navigationController setImageCount:1];
        
        [self.navigationController pushViewController:[[DBCameraContainer alloc] initWithDelegate:self.delegate] animated:YES];
    }
    else {
        
        NSLog(@"SECOND SHOT");
        
        
        if ( [_delegate respondsToSelector:@selector(captureImagesDidFinish:)] ) {
            
//            UIImage * cropImage = [[UIImage screenshotFromView:self.view] croppedImage:(CGRect){ 0, IS_RETINA_4 ? 308 : 220, 640, 640 }];
            NSLog(@"frame height %f", self.view.frame.size.height);
            UIImage * cropImage = [[UIImage screenshotFromView:self.view] croppedImage:(CGRect){ 0, IS_RETINA_4 ? 184 : 96, 640, 640 }];
            
            [(DBNavigationViewController *)self.navigationController setImage2:cropImage];
            [(DBNavigationViewController *)self.navigationController setMetaData2:self.capturedImageMetadata];
            
            DBResultsViewController * resultVC = [[DBResultsViewController alloc] initWithNibName:@"DBResultsViewController" bundle:[NSBundle mainBundle]];
            [resultVC setDelegate:self.delegate];
            [self.navigationController pushViewController:resultVC animated:YES];

            
        }
    }

}

- (void) cameraView:(DBCameraSegueView *)cameraView cropQuadImageForState:(BOOL)state
{
    [cameraView setCropMode:state];
    [cameraView.imageView setGesturesEnabled:state];
    if ( state == NO )
        [cameraView.imageView resetPosition];
}

@end