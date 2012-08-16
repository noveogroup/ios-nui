//
//  UIView+NUILoading.m
//  NUILoader
//
//  Created by Ivan Masalov on 7/12/12.
//  Copyright (c) 2012 eko team. All rights reserved.
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

- (BOOL)loadNUISubviewsFromRValue:(NUIStatement *)array loader:(NUILoader *)loader
    error:(NUIError **)error
{
    if (array.statementType != NUIStatementType_Array) {
        *error = [NUIError errorWithData:array.data position:array.range.location
            message:@"Subviews should be an array."];
        return NO;
    }
    for (NUIStatement *object in array.value) {
        if (object.statementType != NUIStatementType_Object) {
            *error = [NUIError errorWithData:object.data position:object.range.location
                message:@"Subview should be an object."];
            return NO;
        }
        UIView *subview = [loader loadObjectOfClass:[UIView class] fromNUIObject:object];
        if (subview) {
            [self addSubview:subview];
        } else {
            *error = loader.lastError;
            return NO;
        }
    }
    return YES;
}

@end