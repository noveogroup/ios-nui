//
//  NUICellLayoutItem.m
//  NUIKit
//
//  Created by Ivan Masalov on 15/12/13.
//  Copyright (c) 2013 Noveo Group. All rights reserved.
//

#import "NUICellLayoutItem.h"

#import "UIView+NUILayout.h"

@implementation NUICellLayoutItem

@synthesize cellRange = cellRange_;

- (id)init
{
    self = [super init];
    if (self) {
        cellRange_ = (NSRange){0, 1};
    }
    return self;
}

- (void)setCellRange:(NSRange)cellRange
{
    cellRange_ = cellRange;
    self.view.needsToUpdateSize = YES;
}

@end
