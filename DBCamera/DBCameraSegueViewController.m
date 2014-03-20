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
    [self.view setBackgroundColor:[UIColor blackColor]];
    
    _containerView = [[DBCameraSegueView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [_containerView setBackgroundColor:RGBColor(0x202020, 1)];
    [_containerView setAutoresizingMask:UIViewAutoresizingFlexibleHeight];
    [_containerView setDelegate:self];
    [_containerView buildButtonInterface];
    [self.view addSubview:_containerView];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [_containerView.imageView setImage:self.capturedImage];
    
    CGFloat newHeight = [self getNewHeight];
    CGFloat newY = ((CGRectGetHeight([[UIScreen mainScreen] bounds]) - 60) * .5) - (newHeight * .5);
    [_containerView.imageView setFrame:(CGRect){ _containerView.imageView.frame.origin.x, newY + 60.0f,
                                                 CGRectGetWidth(_containerView.imageView.frame), newHeight }];
    [_containerView.imageView setDefaultCenter:_containerView.imageView.center];
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

#pragma mark - DBCameraViewDelegate

- (void) retakeImageFromCameraView:(DBCameraSegueView *)cameraView
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) useImageFromCameraView:(DBCameraSegueView *)cameraView
{
    
    if ([(DBNavigationViewController *)[self navigationController] imageCount] == 0) {
        
        NSLog(@"FIRST SHOT");
        
        
        [(DBNavigationViewController *)self.navigationController setImage1:self.capturedImage];
        [(DBNavigationViewController *)self.navigationController setMetaData1:self.capturedImageMetadata];
        
        [(DBNavigationViewController *)self.navigationController setImageCount:1];
        
        [self.navigationController pushViewController:[[DBCameraContainer alloc] initWithDelegate:self.delegate] animated:YES];
    }
    else {
        
        NSLog(@"SECOND SHOT");
        
        
        if ( [_delegate respondsToSelector:@selector(captureImagesDidFinish:)] ) {
            
            [(DBNavigationViewController *)self.navigationController setImage2:self.capturedImage];
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