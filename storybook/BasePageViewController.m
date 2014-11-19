//
//  SampleViewController.m
//  storybook
//
//  Created by Kevin Casey on 11/17/14.
//  Copyright (c) 2014 ieor190. All rights reserved.
//

#import "BasePageViewController.h"
@import AVFoundation;

@interface BasePageViewController ()
@property (nonatomic, strong) AVSpeechSynthesizer *synthesizer;
@property (strong, nonatomic) UILabel *textLabel;
@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) NSMutableArray *textLabels;
@property (strong, nonatomic) NSMutableArray *imageViews;
@property (strong, nonatomic) NSMutableArray *utterances;
@property (nonatomic, assign) NSUInteger nextSpeechIndex;

@end

@implementation BasePageViewController

NSString *kFrame = @"frame";
NSString *kText = @"text";
NSString *kImageName = @"imageName";

- (id)init {
    self = [super init];
    
    if (self != nil)
    {
        // Further initialization if needed
    }
    return self;
}

- (id)initWithTextLabels:(NSArray *)textLabels andImageViews:(NSArray *) imageViews {
    _textLabels = [[NSMutableArray alloc] init];
    _imageViews = [[NSMutableArray alloc] init];
    _utterances = [[NSMutableArray alloc] init];

    if (self != nil)
    {
        for (int i = 0; i < [textLabels count]; i++) {
            
            NSDictionary *textDict = [textLabels objectAtIndex:i];
            UILabel *textLabel;
            NSArray *frameValue = [textDict objectForKey:kFrame];
            if (frameValue) {
                CGFloat x = [[frameValue objectAtIndex:0] floatValue];
                CGFloat y = [[frameValue objectAtIndex:1] floatValue];
                CGFloat width = [[frameValue objectAtIndex:2] floatValue];
                CGFloat height = [[frameValue objectAtIndex:3] floatValue];

                textLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, y, width, height)];
            } else {
                textLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 100, 300, 100)];
            }
            
            textLabel.text = [textDict objectForKey:kText];
            UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(labelTapped:)];
            tapGestureRecognizer.numberOfTapsRequired = 1;
            [textLabel addGestureRecognizer:tapGestureRecognizer];
            textLabel.userInteractionEnabled = YES;
            [_textLabels addObject:textLabel];
            
            AVSpeechUtterance *utterance = [[AVSpeechUtterance alloc] initWithString:textLabel.text];
            utterance.voice = [AVSpeechSynthesisVoice voiceWithLanguage:@"en-US"];
            //[utterance setValuesForKeysWithDictionary:utteranceProperties];
            [_utterances addObject:utterance];
        }
        
        for (int i = 0; i < [imageViews count]; i++) {
            NSDictionary *imageDict = [imageViews objectAtIndex:i];

            UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[imageDict objectForKey:kImageName]]];
            NSArray *frameValue = [imageDict objectForKey:kFrame];
            if (frameValue) {
                CGFloat x = [[frameValue objectAtIndex:0] floatValue];
                CGFloat y = [[frameValue objectAtIndex:1] floatValue];
                CGFloat width = [[frameValue objectAtIndex:2] floatValue];
                CGFloat height = [[frameValue objectAtIndex:3] floatValue];
                
                imageView.frame = CGRectMake(x, y, width, height);
            } else {
                imageView.frame = CGRectMake(300, 100, 400, 100);
            }

            [_imageViews addObject:imageView];
        }
        
        self.nextSpeechIndex = 0;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    [self.view addSubview:_textLabel];
    [self.view addSubview:_imageView];
    
    for (int i = 0; i < [_textLabels count]; i++) {
        [self.view addSubview:[_textLabels objectAtIndex:i]];
    }
    
    for (int i = 0; i < [_imageViews count]; i++) {
        [self.view addSubview:[_imageViews objectAtIndex:i]];
    }
    
    [self startSpeaking];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)labelTapped:(UIGestureRecognizer *) gestureRecognizer {
     UILabel *tappedLabel = (UILabel*) [gestureRecognizer.view hitTest:[gestureRecognizer locationInView:gestureRecognizer.view] withEvent:nil];
    
    AVSpeechUtterance *utterance = [[AVSpeechUtterance alloc] initWithString:[tappedLabel text]];
    utterance.voice = [AVSpeechSynthesisVoice voiceWithLanguage:@"en-US"];
    
    AVSpeechSynthesizer *speechSynthesizer = [[AVSpeechSynthesizer alloc] init];
    [speechSynthesizer speakUtterance:utterance];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Speech Management

- (void)speakNextUtterance
{
    if (self.nextSpeechIndex < [_utterances count]) {
        AVSpeechUtterance *utterance = [_utterances objectAtIndex:self.nextSpeechIndex];
        self.nextSpeechIndex += 1;
        
        [self.synthesizer speakUtterance:utterance];
    }
}


- (void)startSpeaking
{
    if (!self.synthesizer) {
        self.synthesizer = [[AVSpeechSynthesizer alloc] init];
        self.synthesizer.delegate = self;
    }
    
    [self speakNextUtterance];
}

- (void)speechSynthesizer:(AVSpeechSynthesizer*)synthesizer didFinishSpeechUtterance:(AVSpeechUtterance*)utterance
{
    NSUInteger indexOfUtterance = [_utterances indexOfObject:utterance];
    if (indexOfUtterance == NSNotFound) {
        return;
    }
    
    [self speakNextUtterance];
}

@end