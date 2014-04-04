//
//  NUIGridLayout+NUILoading.m
//  NUILayoutLoading
//
//  Created by Ivan Masalov on 7/12/12.
//  Copyright (c) 2012 Noveo Group. All rights reserved.
//

#import "NUIGridLayout+NUILoading.h"
#import "NUIGridLength.h"
#import "NUIStatement.h"
#import "NUIError.h"

@implementation NUIGridLayout (NUILoading)

- (BOOL)loadNUIColumnsFromRValue:(NUIStatement *)value loader:(NUILoader *)loader
    error:(NUIError **)error
{
    if (value.statementType != NUIStatementType_String) {
        *error = [NUIError errorWithData:value.data position:value.range.location
            message:@"Expecting an string."];
        return NO;
    }
    NSArray *components = [value.value componentsSeparatedByString:@","];
    NSMutableArray *columns = [NSMutableArray arrayWithCapacity:components.count];
    for (NSString *str in components) {
        NUIGridLength *l = [[NUIGridLength alloc] initWithString:
            [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
        [columns addObject:l];
    }
    self.columns = columns;
    return YES;
}

- (BOOL)loadNUIRowsFromRValue:(NUIStatement *)value loader:(NUILoader *)loader
    error:(NUIError **)error
{
    if (value.statementType != NUIStatementType_String) {
        *error = [NUIError errorWithData:value.data position:value.range.location
            message:@"Expecting an string."];
        return NO;
    }
    NSArray *components = [value.value componentsSeparatedByString:@","];
    NSMutableArray *rows = [NSMutableArray arrayWithCapacity:components.count];
    for (NSString *str in components) {
        NUIGridLength *l = [[NUIGridLength alloc] initWithString:
            [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
        [rows addObject:l];
    }
    self.rows = rows;
    return YES;
}

@end
