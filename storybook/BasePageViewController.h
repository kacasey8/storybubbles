//
//  SampleViewController.h
//  storybook
//
//  Created by Kevin Casey on 11/17/14.
//  Copyright (c) 2014 ieor190. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BasePageViewController : UIViewController

- (id)initWithTextLabels:(NSArray *)textLabels andImageViews:(NSArray *) imageViews;
- (void)labelTapped:(UILabel *) label;

extern NSString * kFrame;
extern NSString * kText;
extern NSString * kImageName;

@end