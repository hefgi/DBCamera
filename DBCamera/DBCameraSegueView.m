//
//  DBCameraSegueView.m
//  DBCamera
//
//  Created by iBo on 17/02/14.
//  Copyright (c) 2014 PSSD - Daniele Bogo. All rights reserved.
//

#import "DBCameraSegueView.h"
#import "DBCameraImageView.h"
#import "DBCameraMacros.h"

#ifndef DBCameraLocalizedStrings
#define DBCameraLocalizedStrings(key) \
NSLocalizedStringFromTable(key, @"DBCamera", nil)
#endif

#define buttonMargin 20.0f
//#define kCropStripeHeight (IS_RETINA_4 ? 154 : 110)
#define kCropStripeHeight (IS_RETINA_4 ? 62 : 18)
#define kBotBarHeight 60.0f
#define kNavBarHeight 64.0f




@interface DBCameraSegueView () {
    UIView *_topStripe, *_bottomStripe;
}
@end

@implementation DBCameraSegueView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUserInteractionEnabled:YES];
        
        _imageView = [[DBCameraImageView alloc] initWithFrame:(CGRect){ 0, 0, CGRectGetWidth([[UIScreen mainScreen] bounds]), CGRectGetHeight([[UIScreen mainScreen] bounds]) - (kCropStripeHeight * 2) }];
        [_imageView setBackgroundColor:[UIColor yellowColor]];
        [_imageView setAutoresizingMask:UIViewAutoresizingFlexibleHeight];
        [_imageView setContentMode:UIViewContentModeScaleAspectFit];
        [self addSubview:_imageView];
        
        _topStripe = [[UIView alloc] initWithFrame:(CGRect){ 0, 0, CGRectGetWidth(frame), kCropStripeHeight }];
        [_topStripe setBackgroundColor:[UIColor colorWithRed:0.121569F green:0.121569F blue:0.121569F alpha:1.0F]];
        [self addSubview:_topStripe];
                
        _bottomStripe = [[UIView alloc] initWithFrame:(CGRect){ 0, CGRectGetHeight(frame) - kCropStripeHeight - kNavBarHeight - kBotBarHeight, CGRectGetWidth(frame), kCropStripeHeight}];
        [_bottomStripe setBackgroundColor:[UIColor colorWithRed:0.121569F green:0.121569F blue:0.121569F alpha:1.0F]];
        [self addSubview:_bottomStripe];
    }
    return self;
}

- (void) buildButtonInterface
{
    [self addSubview:self.bottomContainerBar];
    
//    [self.retakeButton addTarget:self action:@selector(retakePhoto) forControlEvents:UIControlEventTouchUpInside];
//    [self addSubview:self.retakeButton];
    
    [self.useButton addTarget:self action:@selector(useImage) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomContainerBar addSubview:self.useButton];

    //Desactivate the crop button for now !
//    [self.cropButton addTarget:self action:@selector(cropQuad:) forControlEvents:UIControlEventTouchUpInside];
//    [self addSubview:self.cropButton];
}

- (UIView *) bottomContainerBar
{
    if ( !_bottomContainerBar ) {
        _bottomContainerBar = [[UIView alloc] initWithFrame:(CGRect){ 0, CGRectGetHeight(self.frame) - kBotBarHeight - kNavBarHeight, CGRectGetWidth([[UIScreen mainScreen] bounds]), kBotBarHeight}];
//        [_stripeView setBackgroundColor:RGBColor(0x000000, 1)];
        [_bottomContainerBar setBackgroundColor:[UIColor colorWithRed:0.235 green:0.769 blue:0.8 alpha:1.0]];
    }
    
    return _bottomContainerBar;
}

- (void) setCropMode:(BOOL)cropMode
{
    _cropMode = cropMode;
    [_topStripe setHidden:!_cropMode];
    [_bottomStripe setHidden:!_cropMode];
}

- (UIButton *) baseButton
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button setBackgroundColor:[UIColor clearColor]];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    return button;
}

- (UIButton *) retakeButton
{
    if ( !_retakeButton ) {
        _retakeButton = [self baseButton];
        [_retakeButton setTitle:DBCameraLocalizedStrings(@"button.retake") forState:UIControlStateNormal];
        [_retakeButton.titleLabel sizeToFit];
        [_retakeButton sizeToFit];
        [_retakeButton setFrame:(CGRect){ 0, 0, CGRectGetWidth(_retakeButton.frame) + buttonMargin, 60 }];
    }
    
    return _retakeButton;
}

- (UIButton *) useButton
{
    if ( !_useButton ) {
        _useButton = [self baseButton];
        [_useButton setTitle:DBCameraLocalizedStrings(@"button.use") forState:UIControlStateNormal];
        [_useButton.titleLabel setFont:[UIFont systemFontOfSize:18.0]];
        [_useButton setFrame:(CGRect){0, 0, CGRectGetWidth(self.bottomContainerBar.frame), kBotBarHeight}];
    }
    
    return _useButton;
}

- (UIButton *) cropButton
{
    if ( !_cropButton) {
        _cropButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cropButton setBackgroundColor:[UIColor clearColor]];
        [_cropButton setImage:[UIImage imageNamed:@"Crop"] forState:UIControlStateNormal];
        [_cropButton setImage:[UIImage imageNamed:@"CropSelected"] forState:UIControlStateSelected];
        [_cropButton setFrame:(CGRect){ CGRectGetMidX(self.bounds) - 15, 15, 30, 30 }];
    }
    
    return _cropButton;
}

#pragma mark - Methods

- (void) retakePhoto
{
    if ( [_delegate respondsToSelector:@selector(retakeImageFromCameraView:)] )
        [_delegate retakeImageFromCameraView:self];
}

- (void) useImage
{
    if ( [_delegate respondsToSelector:@selector(useImageFromCameraView:)] )
        [_delegate useImageFromCameraView:self];
}

- (void) cropQuad:(UIButton *)button
{
    [button setSelected:!button.isSelected];
    if ( [_delegate respondsToSelector:@selector(cameraView:cropQuadImageForState:)] )
        [_delegate cameraView:self cropQuadImageForState:button.isSelected];
}

@end
