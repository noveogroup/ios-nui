//
//  NUIViewController.m
//  NUILayout
//
//  Created by Ivan Masalov on 6/8/12.
//  Copyright (c) 2012 Noveo Group. All rights reserved.
//

#import "NUIViewController.h"
#import "NUIKit/NUILoader.h"

@interface NUIViewController ()

@property (nonatomic, retain) NUILoader *loader;
@property (nonatomic, retain) UILabel *label;
@property (nonatomic, retain) UILabel *label2;

@end

@implementation NUIViewController

@synthesize loader = loader_;
@synthesize label2 = label2_;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.loader = [[NUILoader alloc] initWithRootObject:self];
    [loader_ loadFromFile:@"nui.nui"];
    label2_.backgroundColor = [UIColor blueColor];
    label2_.backgroundColor = [UIColor redColor];
}

- (void)buttonTapped2:(UIButton *)b
{
    if (b.selected) {
        [loader_ loadState:@"shown2"];
    } else {
        [loader_ loadState:@"hidden2"];
    }
}

- (void)buttonTapped:(UIButton *)b
{
    if (b.selected) {
        [loader_ loadState:@"shown"];
    } else {
        [loader_ loadState:@"hidden"];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end
