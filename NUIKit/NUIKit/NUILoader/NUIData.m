//
//  NUIError.h
//  NUIKit
//
//  Created by Ivan Masalov on 8/10/12.
//  Copyright (c) 2012 Noveo Group. All rights reserved.
//

#import "NUIData.h"

@implementation NUIData

@synthesize fileName = fileName_;
@synthesize data = data_;

- (NUIPositionInLine)positionInLineFromPosition:(NSUInteger)position
{
    NUIPositionInLine result = {0, position};
    NSRange range = [data_ rangeOfString:@"\n" options:NSBackwardsSearch range:NSMakeRange(0,
        position)];
    if (range.length) {
        result.position = position - range.location - range.length;
        while (YES) {
            ++result.line;
            range = [data_ rangeOfString:@"\n" options:NSBackwardsSearch range:NSMakeRange(0,
                range.location)];
            if (!range.length) {
                break;
            }
        }
    }
    return result;
}

@end