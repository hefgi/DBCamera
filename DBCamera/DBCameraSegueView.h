//
//  DBCameraSegueView.h
//  DBCamera
//
//  Created by iBo on 17/02/14.
//  Copyright (c) 2014 PSSD - Daniele Bogo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBCameraImageView.h"

@protocol DBCameraSegueViewDelegate;

@interface DBCameraSegueView : UIView
@property (nonatomic, weak) id <DBCameraSegueViewDelegate> delegate;
@property (nonatomic, strong) DBCameraImageView *imageView;
@property (nonatomic, strong) UIView *bottomContainerBar;
@property (nonatomic, strong) UIButton *useButton;

- (void) buildButtonInterface;

@end

@protocol DBCameraSegueViewDelegate <NSObject>
@optional
- (void) retakeImageFromCameraView:(DBCameraSegueView *)cameraView;
- (void) useImageFromCameraView:(DBCameraSegueView *)cameraView;

@end