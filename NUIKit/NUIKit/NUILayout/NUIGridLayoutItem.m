//
//  NUIGridLayoutItem.m
//  NUILayout
//
//  Created by Ivan Masalov on 4/4/12.
//  Copyright (c) 2012 Noveo Group. All rights reserved.
//

#import "NUIGridLayoutItem.h"

#import "UIView+NUILayout.h"

@implementation NUIGridLayoutItem

@synthesize columnRange = columnRange_;
@synthesize rowRange = rowRange_;

- (id)init
{
    self = [super init];
    if (self) {
        columnRange_ = (NSRange){0, 1};
        rowRange_ = (NSRange){0, 1};
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone
{
    NUIGridLayoutItem *copy = [super copyWithZone:zone];
    if (copy) {
        copy.columnRange = columnRange_;
        copy.rowRange = rowRange_;
    }
    return copy;
}

- (void)setColumnRange:(NSRange)columnRange
{
    columnRange_ = columnRange;
    self.view.needsToUpdateSize = YES;
}

- (void)setRowRange:(NSRange)rowRange
{
    rowRange_ = rowRange;
    self.view.needsToUpdateSize = YES;
}

- (void)setColumn:(NSUInteger)column
{
    self.columnRange = (NSRange){column, self.columnRange.length};
}

- (NSUInteger)column
{
    return columnRange_.location;
}

- (void)setRow:(NSUInteger)row
{
    self.rowRange = (NSRange){row, self.rowRange.length};
}

- (NSUInteger)row
{
    return rowRange_.location;
}

@end
