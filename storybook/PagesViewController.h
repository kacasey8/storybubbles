//
//  PagesViewController.h
//  storybook
//
//  Created by Kevin Casey on 11/17/14.
//  Copyright (c) 2014 ieor190. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PagesViewController : UIPageViewController <UIPageViewControllerDataSource>

@property (nonatomic, strong) NSString *title;

@end
