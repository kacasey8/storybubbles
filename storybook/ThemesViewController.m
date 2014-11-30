//
//  BubbleThemesViewController.m
//  storybook
//
//  Created by Kevin Casey on 11/21/14.
//  Copyright (c) 2014 ieor190. All rights reserved.
//

#import "ThemesViewController.h"

@interface ThemesViewController ()

@property (strong, nonatomic) NSTimer *myTimer;
@property (strong, nonatomic) NSMutableArray *items;

@end

@implementation ThemesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat SCREEN_WIDTH = screenRect.size.width;
    CGFloat SCREEN_HEIGHT = screenRect.size.height;
    
    /*UIImageView *title = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH * .15, 50, SCREEN_WIDTH*0.7, SCREEN_HEIGHT*0.2)];
    title.image = [UIImage imageNamed:@"homebanner"];*/
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH * .15, 75, SCREEN_WIDTH*0.7, SCREEN_HEIGHT*0.2)];
    titleLabel.text = @"storybubbles";
    titleLabel.font = [UIFont fontWithName:@"FredokaOne-Regular" size:100];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor whiteColor];
    
    //self.titleLabel.textColor = [UIColor whiteColor];
    
    CGFloat radius = SCREEN_WIDTH/6.0;
    CGFloat x = SCREEN_WIDTH/2.0 - radius;
    CGFloat y = SCREEN_HEIGHT - radius + 50;
    
    
    UIImageView *circle = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, radius*2, radius*2)];
    circle.backgroundColor = [UIColor whiteColor];
    circle.layer.cornerRadius = radius;
    
    radius = SCREEN_WIDTH/1.9;
    x = SCREEN_WIDTH/2.0 - radius;
    y = SCREEN_HEIGHT - radius;
    
    UIImageView *bigCircle = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, radius*2, radius*2)];
    bigCircle.backgroundColor = [UIColor whiteColor];
    bigCircle.alpha = 0.6;
    bigCircle.layer.cornerRadius = radius;
    
    
    radius = SCREEN_WIDTH/20;
    x = SCREEN_WIDTH - radius*2 - 30;
    y = 30;
    UIImageView *profile = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, radius*2, radius*2)];
    profile.image = [UIImage imageNamed:@"profile ken"];

    [self.view addSubview:titleLabel];
    //[self.view addSubview:title];
    [self.view addSubview:circle];
    [self.view addSubview:bigCircle];
    [self.view sendSubviewToBack:bigCircle];
    [self.view addSubview:profile];

    
    self.view.backgroundColor = [Helper colorWithHexString:@"00C7FF"];
    [Animations spawnBubblesInView:self.view];
    
    
    //configure carousel
    _carousel.type = iCarouselTypeWheel;
    _carousel.backgroundColor = [UIColor clearColor];
}

- (void)awakeFromNib
{
    //set up data
    //your carousel should always be driven by an array of
    //data of some kind - don't store data in your item views
    //or the recycling mechanism will destroy your data once
    //your item views move off-screen
    
    NSDictionary *theme1 = @{
                             kText: @"Space",
                             kImageName: @"spacecircle"
                             };
    NSDictionary *theme2 = @{
                             kText: @"Forest",
                             kImageName: @"forestcircle"
                             };
    NSDictionary *theme3 = @{
                             kText: @"Desert",
                             kImageName: @"desertcircle"
                             };
    
    NSArray *themes = @[theme1, theme2, theme3, theme1, theme2, theme3];
    
    _items = [[NSMutableArray alloc] initWithArray:themes];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark iCarousel methods

- (NSUInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    //return the total number of items in the carousel
    return [_items count];
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSUInteger)index reusingView:(UIView *)view
{
    
    //create new view if no view is available for recycling
    if (view == nil)
    {
        //don't do anything specific to the index within
        //this `if (view == nil) {...}` statement because the view will be
        //recycled and used with other index values later
            
        // Configure the cell
        NSDictionary *data = [_items objectAtIndex:index];
        
        view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 300.0f, 300.0f)];
        ((UIImageView *)view).image = [UIImage imageNamed:[data objectForKey:kImageName]];
        [view.layer setBorderColor: [[UIColor whiteColor] CGColor]];
        [view.layer setBorderWidth: 15.0];
        view.layer.cornerRadius = 150.0;
        
        if (index == self.carousel.currentItemIndex) {
        
            POPSpringAnimation *scaleUp = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
            scaleUp.fromValue  = [NSValue valueWithCGSize:CGSizeMake(1.0f, 1.0f)];
            scaleUp.toValue = [NSValue valueWithCGSize:CGSizeMake(1.2f, 1.2f)];
            scaleUp.springBounciness = 20.0f;
            scaleUp.springSpeed = 20.0f;
        
            [view.layer pop_addAnimation:scaleUp forKey:@"first"];
        }

    }
    return view;
}

- (void)carousel:(__unused iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index
{
    [self performSegueWithIdentifier:@"selected_theme" sender:self.parentViewController];
}

- (void)carouselCurrentItemIndexDidChange:(__unused iCarousel *)carousel
{
    [_items objectAtIndex:self.carousel.currentItemIndex];
    [self.carousel reloadData];
}

- (CGFloat)carousel:(__unused iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value
{
    //customize carousel display
    switch (option)
    {
        case iCarouselOptionWrap:
        {
            return YES;
        }
        case iCarouselOptionSpacing:
        {
            //add a bit of spacing between the item views
            return value * 1.0f;
        }
        case iCarouselOptionFadeMax:
        {
            return value;
        }
        case iCarouselOptionShowBackfaces:
        case iCarouselOptionRadius:
        {
            return value * 1.2f;
        }
        case iCarouselOptionAngle:
        case iCarouselOptionArc:
        case iCarouselOptionTilt:
        case iCarouselOptionCount:
        case iCarouselOptionFadeMin:
        case iCarouselOptionFadeRange:
        case iCarouselOptionOffsetMultiplier:
        case iCarouselOptionVisibleItems:
        {
            return value;
        }
    }
}

@end
