//
//  NUIHorizontalLayout.m
//  NUILayout
//
//  Created by Ivan Masalov on 4/4/12.
//  Copyright (c) 2012 Noveo Group. All rights reserved.
//

#import "NUIHorizontalLayout.h"
#import "NUILayoutItem.h"

#import "NUIMath.h"

@implementation NUIHorizontalLayout

- (void)layoutInRect:(CGRect)rect
{
    CGSize *sizes = (CGSize *)malloc(sizeof(CGSize) * self.subviews.count);
    __block CGFloat x = 0;
    __block CGFloat restSize = rect.size.width;
    __block int cStretchable = 0;
    __block CGSize constraintSize = rect.size;
    // Get preferred sizes and count of stretchable elements
    [self.subviews enumerateObjectsUsingBlock:^(id<NUIView> subview, NSUInteger idx, BOOL *stop) {
        NUILayoutItem *item = [self layoutItemForSubview:subview];
        sizes[idx] = [item sizeWithMarginThatFits:constraintSize];
        restSize -= sizes[idx].width;
        if (item.horizontalAlignment == NUIHorizontalAlignment_Stretch) {
            ++cStretchable;
        }
        if (constraintSize.width < sizes[idx].width) {
            constraintSize.width = 0;
        } else {
            constraintSize.width -= sizes[idx].width;
        }
    }];
    // layout elements
    [self.subviews enumerateObjectsUsingBlock:^(id<NUIView> subview, NSUInteger idx, BOOL *stop) {
        NUILayoutItem *item = [self layoutItemForSubview:subview];
        if (item.horizontalAlignment == NUIHorizontalAlignment_Stretch) {
            CGFloat additionalSize = nuiScaledFloorf(restSize / cStretchable);
            sizes[idx].width += additionalSize;
            restSize -= additionalSize;
            --cStretchable;
        }
        [item placeInRect:CGRectMake(rect.origin.x + x, rect.origin.y, sizes[idx].width,
            rect.size.height) preferredSize:sizes[idx]];
        x += sizes[idx].width;
    }];
    free(sizes);
}



- (CGSize)preferredSizeThatFits:(CGSize)size
{
    CGFloat width = 0, height = 0;
    for (id<NUIView> subview in self.subviews) {
        NUILayoutItem *item = [self layoutItemForSubview:subview];
        CGSize sz = [item sizeWithMarginThatFits:size];
        width += sz.width;
        if (size.width < sz.width) {
            size.width = 0;
        } else {
            size.width -= sz.width;
        }
        if (height < sz.height) {
            height = sz.height;
        }
    }
    return CGSizeMake(width, height);
}

@end
