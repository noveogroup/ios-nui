//
//  NUIHorizontalCellLayout+NUILoading.m
//  NUIKit
//
//  Created by Ivan Masalov on 24/12/13.
//  Copyright (c) 2013 Noveo Group. All rights reserved.
//

#import "NUIHorizontalCellLayout+NUILoading.h"

#import "NUIGridLength.h"
#import "NUIStatement.h"
#import "NUIError.h"

@implementation NUIHorizontalCellLayout (NUILoading)

- (BOOL)loadNUICellsFromRValue:(NUIStatement *)value loader:(NUILoader *)loader
    error:(NUIError **)error
{
    if (value.statementType != NUIStatementType_String) {
        *error = [NUIError errorWithData:value.data position:value.range.location
            message:@"Expecting an string."];
        return NO;
    }
    NSArray *components = [value.value componentsSeparatedByString:@","];
    NSMutableArray *cells = [NSMutableArray arrayWithCapacity:components.count];
    for (NSString *str in components) {
        NUIGridLength *l = [[NUIGridLength alloc] initWithString:
            [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
        [cells addObject:l];
    }
    self.cells = cells;
    return YES;
}

@end
