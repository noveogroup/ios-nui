//
//  NUIHorizontalCellLayout.m
//  NUIKit
//
//  Created by Ivan Masalov on 15/12/13.
//  Copyright (c) 2013 Ivan Masalov. All rights reserved.
//

#import "NUIHorizontalCellLayout.h"
#import "NUIGridLength.h"
#import "NUICellLayoutItem.h"
#import "NUILayoutView.h"
#import "UIView+NUILayout.h"

#import "NUIMath.h"

static int observerContext;

@interface NUIHorizontalCellLayout ()
{
    NSUInteger cellCount_;
    BOOL isCellCountValid_;
}

@end

@implementation NUIHorizontalCellLayout

- (id)initWithCells:(NSArray *)cells
{
    self = [super init];
    if (self) {
        NSMutableArray *c = [NSMutableArray arrayWithCapacity:cells.count];
        for (NSString *str in cells) {
            NUIGridLength *cell= [[NUIGridLength alloc] initWithString:str];
            [c addObject:cell];
        }
        self.cells = c;
    }
    return self;
}

- (void)dealloc
{
    for (id<NUIView> subview in self.subviews) {
        NUICellLayoutItem *item = (NUICellLayoutItem *)
            [self layoutItemForSubview:subview];
        [item removeObserver:self forKeyPath:@"cellRange"];
    }
}

- (void)setCells:(NSArray *)cells
{
    if (_cells == cells) {
        return;
    }
    _cells = [cells copy];
    isCellCountValid_ = NO;
    self.superview.needsToUpdateSize = YES;
    [self.superview setNeedsLayout];

}

- (NUILayoutItem *)createLayoutItem
{
    NUICellLayoutItem *item = [[NUICellLayoutItem alloc] init];
    item.layout = self;
    return item;
}

- (NUICellLayoutItem *)addSubview:(id<NUIView>)view
{
    return [self addSubview:view cellRange:(NSRange){self.insertPosition, 1}];
}

- (NUICellLayoutItem *)addSubview:(id<NUIView>)view cell:(NSUInteger)cell
{
    return [self addSubview:view cellRange:(NSRange){cell, 1}];
}

- (NUICellLayoutItem *)addSubview:(id<NUIView>)view cellRange:(NSRange)cellRange
{
    NUICellLayoutItem *layoutItem = [[NUICellLayoutItem alloc] init];
    layoutItem.cellRange = cellRange;
    [self addSubview:view layoutItem:layoutItem];
    return layoutItem;
}

- (NUICellLayoutItem *)addSubview:(id<NUIView>)view cells:(NSUInteger)cells
{
    return [self addSubview:view cellRange:(NSRange){self.insertPosition, cells}];
}

- (void)addSubview:(id<NUIView>)view layoutItem:(NUICellLayoutItem *)layoutItem
{
    [super addSubview:view layoutItem:layoutItem];
    [self didAddLayoutItem:layoutItem];
}

- (void)insertSubview:(id<NUIView>)view belowSubview:(UIView *)siblingSubview
    layoutItem:(NUICellLayoutItem *)layoutItem
{
    [super insertSubview:view belowSubview:siblingSubview layoutItem:layoutItem];
    [self didAddLayoutItem:layoutItem];
}

- (void)insertSubview:(id<NUIView>)view aboveSubview:(UIView *)siblingSubview
    layoutItem:(NUICellLayoutItem *)layoutItem
{
    [super insertSubview:view aboveSubview:siblingSubview layoutItem:layoutItem];
    [self didAddLayoutItem:layoutItem];
}

- (void)removeSubview:(id<NUIView>)view
{
    isCellCountValid_ = NO;
    NUICellLayoutItem *item = (NUICellLayoutItem *)[self layoutItemForSubview:view];
    [item removeObserver:self forKeyPath:@"cellRange"];

    [super removeSubview:view];
}

- (NSUInteger)cellsCount
{
    if (!isCellCountValid_) {
        cellCount_ = self.cells.count;
        for (id<NUIView> subview in self.subviews) {
            NUICellLayoutItem *item = (NUICellLayoutItem *)
                [self layoutItemForSubview:subview];
            NSRange r = item.cellRange;
            cellCount_ = MAX(r.location + r.length, cellCount_);
        }
        isCellCountValid_ = YES;
    }
    return cellCount_;
}

- (CGSize)preferredSizeThatFits:(CGSize)size
{
    CGFloat *widths = NULL;
    NSUInteger cCells = 0;
    CGFloat height = 0;
    [self widths:&widths height:&height count:&cCells subviewSizes:nil
        forSize:size];
    
    CGFloat width = 0;
    for (NSUInteger i = 0; i < cCells; ++i) {
        if (widths[i] == CGFLOAT_MAX) {
            width = CGFLOAT_MAX;
            break;
        }
        width += widths[i];
    }
    free(widths);
    return CGSizeMake(width, height);
}

- (void)layoutInRect:(CGRect)rect
{
    NSMutableDictionary *subviewSizes = [NSMutableDictionary dictionary];
    CGFloat *widths = NULL;
    NSUInteger cCells = 0;
    [self widths:&widths height:NULL count:&cCells subviewSizes:subviewSizes
        forSize:rect.size];
    for (int i = 1; i < cCells; ++i) {
        widths[i] += widths[i - 1];
    }
    for (id<NUIView> subview in self.subviews) {
        NUICellLayoutItem *item = (NUICellLayoutItem *)
            [self layoutItemForSubview:subview];
        NSRange range = item.cellRange;

        CGFloat x = range.location > 0 ? widths[range.location - 1] : 0;
        NSUInteger index = range.location + range.length;
        CGFloat x2 = index > 0 ? widths[index - 1] : 0;

        NSString *key = [[NSString alloc] initWithFormat:@"%p", subview];
        CGSize sz = [[subviewSizes objectForKey:key] CGSizeValue];
        [item placeInRect:CGRectMake(rect.origin.x + x, rect.origin.y, x2 - x,
            rect.size.height) preferredSize:sz];
    }
    free(widths);
}

#pragma mark - Private methods

// Constraint with value of CGFLOAT_MAX is considered as an infinity.
- (void)widths:(CGFloat **)widths height:(CGFloat *)height count:
    (NSUInteger *)cellCount subviewSizes:(NSMutableDictionary *)subviewSizes
    forSize:(CGSize)size
{
    NSUInteger cCells = [self cellsCount];

    CGFloat *cellSizes = (CGFloat *)calloc(cCells, sizeof(CGFloat));
    for (NSUInteger i = 0; i < self.cells.count; ++i) {
        NUIGridLength *cell = self.cells[i];
        if (cell.type == NUIGridLengthType_Pixel) {
            cellSizes[i] = cell.value;
        }
    }
    // Sort auto-sized cells according to priorities. Cells created
    // automatically have priority 0.f
    NSMutableArray *autoCellIndexes = [[NSMutableArray alloc] init];
    for (NSUInteger i = 0; i < cCells; ++i) {
        NUIGridLengthType type = NUIGridLengthType_Auto;
        CGFloat value = 0.f;
        if (i < self.cells.count) {
            NUIGridLength *cell = self.cells[i];
            type = cell.type;
            value = cell.value;
        }
        if (type == NUIGridLengthType_Auto) {
            NSUInteger position = autoCellIndexes.count;
            for (; position > 0; --position) {
                int index = [autoCellIndexes[position - 1] intValue];
                CGFloat v = 0.f;
                if (index < self.cells.count) {
                    NUIGridLength *c = self.cells[index];
                    v = c.value;
                }
                if (v >= value) {
                    break;
                }
            }
            [autoCellIndexes insertObject:@(i) atIndex:position];
        }
    }
    // Calculate constraint width
    CGFloat constraint = size.width;
    if (constraint != CGFLOAT_MAX) {
        for (NSUInteger i = 0; i < self.cells.count; ++i) {
            constraint -= cellSizes[i];
        }
    }

    // Auto-sized cells
    NSMutableArray *subviews = [self.subviews mutableCopy];
    for (NSNumber *index in autoCellIndexes) {
        CGFloat maxCellSize = 0.f;
        for (int nSubview = 0; nSubview < subviews.count; ) {
            id<NUIView> subview = subviews[nSubview];
            NUICellLayoutItem *item = (NUICellLayoutItem *)
                [self layoutItemForSubview:subview];
            // Exclude stretchable subviews
            if (item.horizontalAlignment == NUIHorizontalAlignment_Stretch) {
                [subviews removeObjectAtIndex:nSubview];
                continue;
            }
            NSRange cellRange = item.cellRange;
            if (cellRange.location <= [index intValue] && cellRange.location +
                cellRange.length > [index intValue]) {
                // If view takes several auto-sized cells than the cell with
                // more priority will be resize to fit the view. So we skip this
                // view when calculating sizes of other cells.
                [subviews removeObjectAtIndex:nSubview];

                CGSize maxSize = (CGSize){constraint, size.height};
                if (maxSize.width != CGFLOAT_MAX) {
                    // Add fixed-sized cell sizes to max size
                    for (NSUInteger i = cellRange.location; i < cellRange.location +
                        cellRange.length; ++i) {
                        maxSize.width += cellSizes[i];
                    }
                }
                CGSize subviewSize = [item sizeWithMarginThatFits:maxSize];
                if (subviewSize.width != CGFLOAT_MAX) {
                    // Substract fixed-sized cell sizes to subview size
                    for (NSUInteger i = cellRange.location; i < cellRange.location +
                        cellRange.length; ++i) {
                        subviewSize.width -= cellSizes[i];
                    }
                }
                if (maxCellSize < subviewSize.width) {
                    maxCellSize = subviewSize.width;
                }
            } else {
                ++nSubview;
            }
        }
        cellSizes[[index intValue]] = maxCellSize;
        if (constraint != CGFLOAT_MAX) {
            constraint -= maxCellSize;
        }
    }
    // Stretchable cells
    if (size.width == CGFLOAT_MAX) {
        for (int i = 0; i < self.cells.count; ++i) {
            NUIGridLength *cell = self.cells[i];
            if (cell.type == NUIGridLengthType_Star) {
                cellSizes[i] = CGFLOAT_MAX;
            }
        }
    } else {
        constraint = size.width;
        for (int i = 0; i < cCells; ++i) {
            constraint -= cellSizes[i];
        }
        if (constraint > 0.f) {
            CGFloat stretchFactor = 0;
            for (NUIGridLength *cell in self.cells) {
                if (cell.type == NUIGridLengthType_Star) {
                    stretchFactor += cell.value;
                }
            }
            for (int i = 0; i < self.cells.count && stretchFactor > 0; ++i) {
                NUIGridLength *cell = self.cells[i];
                if (cell.type == NUIGridLengthType_Star) {
                    cellSizes[i] = nuiScaledFloorf(constraint * cell.value /
                        stretchFactor);
                    constraint -= cellSizes[i];
                    stretchFactor -= cell.value;
                }
            }
        }
    }
    // Calculate max height and subviews sizes.
    if (height || subviewSizes) {
        if (height) {
            *height = 0.f;
        }
        for (id<NUIView> subview in self.subviews) {
            NUICellLayoutItem *item = (NUICellLayoutItem *)
                [self layoutItemForSubview:subview];
            NSRange cellRange = item.cellRange;
            CGSize maxSize = (CGSize){0, size.height};
            for (NSUInteger i = cellRange.location; i < cellRange.location +
                cellRange.length; ++i) {
                maxSize.width += cellSizes[i];
            }
            CGSize subviewSize = [item sizeWithMarginThatFits:maxSize];
            if (height && *height < subviewSize.height) {
                *height = subviewSize.height;
            }
            if (subviewSizes) {
                subviewSizes[[NSString stringWithFormat:@"%p", subview]] =
                    [NSValue valueWithCGSize:subviewSize];
            }
        }
    }

    if (cellCount) {
        *cellCount = cCells;
    }
    if (widths) {
        *widths = cellSizes;
    } else {
        free(cellSizes);
    }
}

#pragma mark - observers

- (void)didAddLayoutItem:(NUICellLayoutItem *)layoutItem
{
    NSRange range = layoutItem.cellRange;
    self.insertPosition = range.location + range.length;
    isCellCountValid_ = NO;

    isCellCountValid_ = NO;
    [layoutItem addObserver:self forKeyPath:@"cellRange" options:0
        context:&observerContext];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object
    change:(NSDictionary *)change context:(void *)context
{
    if (context == &observerContext) {
        isCellCountValid_ = NO;
        self.needsToUpdateSize = YES;
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change
            context:context];
    }
}

@end
