//
//  NUILayout+NUILoading.m
//  NUILayoutLoading
//
//  Created by Ivan Masalov on 7/12/12.
//  Copyright (c) 2012 Noveo Group. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NUILayout+NUILoading.h"
#import "NUILayoutItem.h"
#import "NUILoader.h"
#import "NUIStatement+Object.h"
#import "NUIError.h"

@implementation NUILayout (NUILoading)

- (BOOL)loadNUILayoutItemsFromRValue:(NUIStatement *)array loader:(NUILoader *)loader
    error:(NUIError **)error
{
    if (array.statementType != NUIStatementType_Array) {
        *error = [NUIError errorWithData:array.data position:array.range.location
            message:@"Layout items should be an array."];
        return NO;
    }
    for (NUIStatement *object in array.value) {
        if (object.statementType != NUIStatementType_Object) {
            *error = [NUIError errorWithData:object.data position:object.range.location
                message:@"Layout item should be an object."];
            return NO;
        }
        NUILayoutItem *item = [self createLayoutItem];
        if ([loader loadObject:item fromNUIObject:object]) {
            [self addSubview:item.view layoutItem:item];
        } else {
            *error = loader.lastError;
            return NO;
        }
    }
    return YES;
}

@end
