//
//  UIView+NUILayout.m
//  NUILayout
//
//  Created by Ivan Masalov on 4/4/12.
//  Copyright (c) 2012 Noveo Group. All rights reserved.
//

#import "UIView+NUILayout.h"
#import <objc/runtime.h>
#import "NUILayoutView.h"
#import "NUILayout.h"
#import "NUILayoutItem.h"

static int NeedsToUpdateSizeKey;
static int LayoutItemsKey;

@implementation UIView (NUILayout)

@dynamic hidden;

- (void)setNeedsToUpdateSize:(BOOL)needsToUpdateSize
{
    NSNumber *value = [NSNumber numberWithBool:needsToUpdateSize];
    objc_setAssociatedObject(self, &NeedsToUpdateSizeKey, value,
        OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)needsToUpdateSize
{
    NSNumber *value = objc_getAssociatedObject(self, &NeedsToUpdateSizeKey);
    return [value boolValue];
}

- (NUILayoutItem *)layoutItem
{
    if ([self.superview isKindOfClass:[NUILayoutView class]]) {
        return  [[(NUILayoutView *)self.superview layout] layoutItemForSubview:self
            recursively:YES];
    }
    return nil;
}

- (NSArray *)layoutItems
{
    NSMutableArray *items = objc_getAssociatedObject(self, &LayoutItemsKey);
    NSMutableArray *result = [[NSMutableArray alloc] initWithCapacity:
        items.count];
    for (NSValue *value in items) {
        [result addObject:[value nonretainedObjectValue]];
    }
    return result;
}

- (void)addLayoutItem:(NUILayoutItem *)layoutItem
{
    NSMutableArray *items = objc_getAssociatedObject(self, &LayoutItemsKey);
    if (!items) {
        items = [[NSMutableArray alloc] init];
        objc_setAssociatedObject(self, &LayoutItemsKey, items,
            OBJC_ASSOCIATION_RETAIN_NONATOMIC);

    }
    [items addObject:[NSValue valueWithNonretainedObject:layoutItem]];
}

- (void)removeLayoutItem:(NUILayoutItem *)layoutItem
{
    NSMutableArray *items = objc_getAssociatedObject(self, &LayoutItemsKey);
    [items enumerateObjectsUsingBlock:^(NSValue *obj, NSUInteger idx, BOOL *stop) {
        if (layoutItem == [obj nonretainedObjectValue]) {
            [items removeObjectAtIndex:idx];
            *stop = YES;
        }
    }];
}

- (CGSize)preferredSizeThatFits:(CGSize)size
{
    return CGSizeZero;
}

- (CGFloat)preferredHeightForWidth:(CGFloat)width
{
    return [self preferredSizeThatFits:(CGSize){width, CGFLOAT_MAX}].height;
}

- (CGFloat)preferredWidthForHeight:(CGFloat)height
{
    return [self preferredSizeThatFits:(CGSize){CGFLOAT_MAX, height}].width;
}

- (void)layoutLayerIfNeeded
{
}

- (void)addToView:(NUILayoutView *)view
{
    [view addSubview:self];
}

- (void)insertIntoView:(NUILayoutView *)view belowSubview:(UIView *)siblingSubview
{
    [view insertSubview:self belowSubview:siblingSubview];
}

- (void)insertIntoView:(NUILayoutView *)view aboveSubview:(UIView *)siblingSubview
    lastInsertedSubview:(UIView **)lastSubview
{
    [view insertSubview:self aboveSubview:siblingSubview];
    if (lastSubview) {
        *lastSubview = self;
    }
}

@end
