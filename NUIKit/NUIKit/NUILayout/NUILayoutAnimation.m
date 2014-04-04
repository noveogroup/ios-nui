//
//  NUILayoutAnimation.m
//  NUILayout
//
//  Created by Ivan Masalov on 4/4/12.
//  Copyright (c) 2012 Noveo Group. All rights reserved.
//

#import "NUILayoutAnimation.h"

@implementation NUILayoutAnimation

@synthesize duration = duration_;
@synthesize delay = delay_;
@synthesize options = options_;

- (id)init
{
    self = [super init];
    if (self) {
        duration_ = 0.2;
        options_ = UIViewAnimationOptionCurveEaseInOut;
    }
    return self;
}

@end
