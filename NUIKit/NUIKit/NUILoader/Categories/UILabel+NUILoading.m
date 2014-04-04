//
//  UILabel+NUILoading.m
//  NUILoader
//
//  Created by Ivan Masalov on 7/12/12.
//  Copyright (c) 2012 Noveo Group. All rights reserved.
//

#import "UILabel+NUILoading.h"

@implementation UILabel (NUILoading)

- (void)setLocalizedText:(NSString *)text
{
    self.text = NSLocalizedString(text, nil);
}

+ (NSDictionary *)nuiConstantsForTextAlignment
{
    static NSDictionary *textAlignmentConstants = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        textAlignmentConstants = [[NSDictionary alloc] initWithObjectsAndKeys:
            [NSNumber numberWithInt:NSTextAlignmentLeft], @"Left",
            [NSNumber numberWithInt:NSTextAlignmentCenter], @"Center",
            [NSNumber numberWithInt:NSTextAlignmentRight], @"Right",
            nil];
    });
    return textAlignmentConstants;
}

+ (NSDictionary *)nuiConstantsForLineBreakMode
{
    static NSDictionary *lineBreakModeConstants = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        lineBreakModeConstants = [[NSDictionary alloc] initWithObjectsAndKeys:
            [NSNumber numberWithInt:NSLineBreakByWordWrapping], @"WordWrap",
            [NSNumber numberWithInt:NSLineBreakByCharWrapping], @"CharacterWrap",
            [NSNumber numberWithInt:NSLineBreakByClipping], @"Clip",
            [NSNumber numberWithInt:NSLineBreakByTruncatingHead], @"HeadTruncation",
            [NSNumber numberWithInt:NSLineBreakByTruncatingTail], @"TailTruncation",
            [NSNumber numberWithInt:NSLineBreakByTruncatingMiddle], @"MiddleTruncation",
            nil];
    });

    return lineBreakModeConstants;
}

+ (NSDictionary *)nuiConstantsForBaselineAdjustment
{
    static NSDictionary *baselineAdjustmentConstants = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        baselineAdjustmentConstants = [[NSDictionary alloc] initWithObjectsAndKeys:
            [NSNumber numberWithInt:UIBaselineAdjustmentNone], @"None",
            [NSNumber numberWithInt:UIBaselineAdjustmentAlignBaselines], @"AlignBaselines",
            [NSNumber numberWithInt:UIBaselineAdjustmentAlignCenters], @"AlignCenters",
            nil];
    });
    return baselineAdjustmentConstants;
}

@end
