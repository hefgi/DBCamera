//
//  DBNavigationViewController.h
//  DBCamera
//
//  Created by FrancoisJulien ALCARAZ on 3/19/2014.
//  Copyright (c) 2014 PSSD - Daniele Bogo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DBNavigationViewController : UINavigationController

@property (nonatomic) int imageCount;

@property (nonatomic, strong) UIImage * image1;
@property (nonatomic, strong) UIImage * image2;

@property (nonatomic, strong) NSDictionary * metaData1;
@property (nonatomic, strong) NSDictionary * metaData2;

- (NSArray *)dataArray;

@end
