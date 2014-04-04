//
//  UIView+NUILoading.m
//  NUILoader
//
//  Created by Ivan Masalov on 7/12/12.
//  Copyright (c) 2012 Noveo Group. All rights reserved.
//

#import "UIView+NUILoading.h"
#import "NUILoader.h"
#import "NUIStatement+Object.h"
#import "NUIError.h"

@implementation UIView (NUILoading)

@dynamic backgroundColor;

+ (NSDictionary *)nuiConstantsForAutoresizingMask
{
    static NSDictionary *autoresizingMaskConstants = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        autoresizingMaskConstants = [[NSDictionary alloc] initWithObjectsAndKeys:
            [NSNumber numberWithInt:UIViewAutoresizingFlexibleLeftMargin], @"FlexibleLeftMargin",
            [NSNumber numberWithInt:UIViewAutoresizingFlexibleWidth], @"FlexibleWidth",
            [NSNumber numberWithInt:UIViewAutoresizingFlexibleRightMargin], @"FlexibleRightMargin",
            [NSNumber numberWithInt:UIViewAutoresizingFlexibleTopMargin], @"FlexibleTopMargin",
            [NSNumber numberWithInt:UIViewAutoresizingFlexibleHeight], @"FlexibleHeight",
            [NSNumber numberWithInt:UIViewAutoresizingFlexibleBottomMargin], @"FlexibleBottomMargin",
            nil];
    });
    return autoresizingMaskConstants;
}

+ (NSDictionary *)nuiConstantsForContentMode
{
    static NSDictionary *contentModeConstants = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        contentModeConstants = [[NSDictionary alloc] initWithObjectsAndKeys:
            [NSNumber numberWithInt:UIViewContentModeScaleToFill], @"ScaleToFill",
            [NSNumber numberWithInt:UIViewContentModeScaleAspectFit], @"ScaleAspectFit",
            [NSNumber numberWithInt:UIViewContentModeScaleAspectFill], @"ScaleAspectFill",
            [NSNumber numberWithInt:UIViewContentModeRedraw], @"Redraw",
            [NSNumber numberWithInt:UIViewContentModeCenter], @"Center",
            [NSNumber numberWithInt:UIViewContentModeTop], @"Top",
            [NSNumber numberWithInt:UIViewContentModeBottom], @"Bottom",
            [NSNumber numberWithInt:UIViewContentModeLeft], @"Left",
            [NSNumber numberWithInt:UIViewContentModeRight], @"Right",
            [NSNumber numberWithInt:UIViewContentModeTopLeft], @"TopLeft",
            [NSNumber numberWithInt:UIViewContentModeTopRight], @"TopRight",
            [NSNumber numberWithInt:UIViewContentModeBottomLeft], @"BottomLeft",
            [NSNumber numberWithInt:UIViewContentModeBottomRight], @"BottomRight",
            nil];
    });
    return contentModeConstants;
}

- (BOOL)loadNUISubviewsFromRValue:(NUIStatement *)array loader:(NUILoader *)loader
    error:(NUIError **)error
{
    if (array.statementType != NUIStatementType_Array) {
        *error = [NUIError errorWithData:array.data position:array.range.location
            message:@"Subviews should be an array."];
        return NO;
    }
    for (NUIStatement *object in array.value) {
        if (object.statementType == NUIStatementType_Object) {
            UIView *subview = [loader loadObjectOfClass:[UIView class] fromNUIObject:object];
            if (subview) {
                [self addSubview:subview];
            } else {
                *error = loader.lastError;
                return NO;
            }
        } else if (object.statementType == NUIStatementType_Identifier) {
            UIView *subview = [loader globalObjectForKey:object.value];
            if (subview) {
                [self addSubview:subview];
            } else {
                *error = loader.lastError;
                return NO;
            }
        } else {
            *error = [NUIError errorWithData:object.data position:object.range.location
                message:@"Subview should be an object or identifier."];
            return NO;
        }
    }
    return YES;
}

@end
