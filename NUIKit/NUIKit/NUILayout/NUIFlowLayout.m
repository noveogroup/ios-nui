//
//  NUIFlowLayout.m
//  NUILayout
//
//  Created by Ivan Masalov on 4/4/12.
//  Copyright (c) 2012 Noveo Group. All rights reserved.
//

#import "NUIFlowLayout.h"

#import "NUILayoutItem.h"

@implementation NUIFlowLayout

- (void)layoutInRect:(CGRect)rect
{
    CGFloat y = 0;
    // firstView - first view in the line.
    for (NSUInteger firstView = 0; firstView < self.subviews.count;) {
        NSMutableArray *sizes = [[NSMutableArray alloc] init];
        NSUInteger nextFirstView = firstView;
        CGFloat lineWidth = 0;
        for (; nextFirstView < self.subviews.count; ++nextFirstView) {
            id<NUIView> view = self.subviews[nextFirstView];
            NUILayoutItem *item = [self layoutItemForSubview:view];
            CGSize itemSize = [item sizeWithMarginThatFits:(CGSize){rect.size.width - lineWidth,
                rect.size.height - y}];
            if (lineWidth + itemSize.width > rect.size.width) {
                // Prevent infinite loop when there is only one view on this line and its size is
                // bigger than line size.
                if (nextFirstView == firstView) {
                    [sizes addObject:[NSValue valueWithCGSize:itemSize]];
                    ++nextFirstView;
                }
                break;
            }
            [sizes addObject:[NSValue valueWithCGSize:itemSize]];
            lineWidth += itemSize.width;
        }
        CGFloat lineHeight = 0;
        for (NSValue *value in sizes) {
            if ([value CGSizeValue].height > lineHeight) {
                lineHeight = [value CGSizeValue].height;
            }
        }
        CGFloat x = 0;
        for (NSUInteger nView = firstView; nView < nextFirstView; ++nView) {
            id<NUIView> view = self.subviews[nView];
            NUILayoutItem *item = [self layoutItemForSubview:view];
            CGSize size = [sizes[nView - firstView] CGSizeValue];
            [item placeInRect:(CGRect) {rect.origin.x + x, rect.origin.y + y, size.width, lineHeight}
                preferredSize:size];
            x += size.width;
        }
        y += lineHeight;
        firstView = nextFirstView;
    }
}

- (CGSize)preferredSizeThatFits:(CGSize)size
{
    CGFloat width = 0;
    CGFloat height = 0;
    // firstView - first view in the line.
    for (NSUInteger firstView = 0; firstView < self.subviews.count;) {
        NSUInteger nextFirstView = firstView;
        CGFloat lineWidth = 0;
        CGFloat lineHeight = 0;
        for (; nextFirstView < self.subviews.count; ++nextFirstView) {
            id<NUIView> view = self.subviews[nextFirstView];
            NUILayoutItem *item = [self layoutItemForSubview:view];
            CGSize itemSize = [item sizeWithMarginThatFits:(CGSize){size.width - lineWidth,
                size.height - height}];

            if (lineWidth + itemSize.width > size.width) {
                // Prevent infinite loop when there is only one view on this line and its size is
                // bigger than line size.
                if (nextFirstView == firstView) {
                    ++nextFirstView;
                    lineWidth += itemSize.width;
                    if (lineHeight < itemSize.height) {
                        lineHeight = itemSize.height;
                    }
                }
                break;
            }
            lineWidth += itemSize.width;
            if (lineHeight < itemSize.height) {
                lineHeight = itemSize.height;
            }
        }
        if (width < lineWidth) {
            width = lineWidth;
        }
        height += lineHeight;
        firstView = nextFirstView;
    }
    return CGSizeMake(width, height);
}

@end
