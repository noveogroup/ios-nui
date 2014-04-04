//
//  NUIGridLayout.m
//  NUILayout
//
//  Created by Ivan Masalov on 4/4/12.
//  Copyright (c) 2012 Noveo Group. All rights reserved.
//

#import "NUIGridLayout.h"

#import "NUIGridLength.h"
#import "NUIGridLayoutItem.h"
#import "NUILayoutView.h"

#import "UIView+NUILayout.h"

#import "NUIMath.h"

static int columnRangeObserverContext;
static int rowRangeObserverContext;

@interface NUIGridLayout ()
{
    NSUInteger columnsCount_;
    BOOL isColumnsCountValid_;
    NSUInteger rowsCount_;
    BOOL isRowsCountValid_;
}

- (void)calculateSubviewPosition:(id<NUIView>)subview columns:(NSUInteger)columns
    rows:(NSUInteger)rows;

- (void)widths:(CGFloat **)widths count:(NSUInteger *)columnsCount heights:(CGFloat **)heights
    count:(NSUInteger *)rowsCount subviewSizes:(NSMutableDictionary *)subviewSizes
    forSize:(CGSize)size;
- (NUIGridLayoutItem *)addLayoutItemForSubview:(id<NUIView>)view;

@end

@implementation NUIGridLayout

@synthesize columns = columns_;
@synthesize rows = rows_;
@synthesize insertionMethod = insertionMethod_;

- (id)initWithColumns:(NSArray *)columns rows:(NSArray *)rows
{
    self = [super init];
    if (self) {
        [self setColumns:columns rows:rows];
    }
    return self;
}

- (void)dealloc
{
    for (id<NUIView> subview in self.subviews) {
        NUIGridLayoutItem *item = (NUIGridLayoutItem *)[self layoutItemForSubview:subview];
        [item removeObserver:self forKeyPath:@"columnRange"];
        [item removeObserver:self forKeyPath:@"rowRange"];
    }
}

- (NUILayoutItem *)createLayoutItem
{
    NUIGridLayoutItem *item = [[NUIGridLayoutItem alloc] init];
    item.layout = self;
    return item;
}

- (void)setRows:(NSArray *)rows
{
    rows_ = [rows copy];
    isRowsCountValid_ = NO;
    self.superview.needsToUpdateSize = YES;
    [self.superview setNeedsLayout];
}

- (void)setColumns:(NSArray *)columns
{
    columns_ = [columns copy];
    isColumnsCountValid_ = NO;
    self.superview.needsToUpdateSize = YES;
    [self.superview setNeedsLayout];
}

- (void)setColumns:(NSArray *)columns rows:(NSArray *)rows
{
    NSMutableArray *c = [NSMutableArray arrayWithCapacity:columns.count];
    for (NSString *str in columns) {
        NUIGridLength *column = [[NUIGridLength alloc] initWithString:str];
        [c addObject:column];
    }
    self.columns = c;
    NSMutableArray *r = [NSMutableArray arrayWithCapacity:rows.count];
    for (NSString *str in rows) {
        NUIGridLength *row = [[NUIGridLength alloc] initWithString:str];
        [r addObject:row];
    }
    self.rows = r;
}

- (NUIGridLayoutItem *)addSubview:(id<NUIView>)view
{
    NUIGridLayoutItem *item = [self addLayoutItemForSubview:view];
    [self calculateSubviewPosition:view columns:1 rows:1];
    return item;
}

- (NUIGridLayoutItem *)addSubview:(id<NUIView>)view column:(NSUInteger)column row:(NSUInteger)row
{
    NUIGridLayoutItem *item = [self addLayoutItemForSubview:view];
    item.columnRange = (NSRange){column, 1};
    item.rowRange = (NSRange){row, 1};
    return item;
}

- (NUIGridLayoutItem *)addSubview:(id<NUIView>)view columnRange:(NSRange)columnRange
    rowRange:(NSRange)rowRange
{
    NUIGridLayoutItem *item = [self addLayoutItemForSubview:view];
    item.columnRange = columnRange;
    item.rowRange = rowRange;
    return item;
}

- (NUIGridLayoutItem *)addSubview:(id<NUIView>)view columns:(NSUInteger)columns
    rows:(NSUInteger)rows
{
    NUIGridLayoutItem *item = [self addLayoutItemForSubview:view];
    [self calculateSubviewPosition:view columns:columns rows:rows];
    return item;
}

- (void)removeSubview:(id<NUIView>)view
{
    isColumnsCountValid_ = NO;
    isRowsCountValid_ = NO;
    NUIGridLayoutItem *item = (NUIGridLayoutItem *)[self layoutItemForSubview:view];
    [item removeObserver:self forKeyPath:@"columnRange"];
    [item removeObserver:self forKeyPath:@"rowRange"];

    [super removeSubview:view];
}

- (NSUInteger)rowsCount
{
    if (!isRowsCountValid_) {
        rowsCount_ = rows_.count;
        for (id<NUIView> subview in self.subviews) {
            NUIGridLayoutItem *item = (NUIGridLayoutItem *)[self layoutItemForSubview:subview];
            NSRange r = item.rowRange;
            rowsCount_ = MAX(r.location + r.length, rowsCount_);
        }
        isRowsCountValid_ = YES;
    }
    return rowsCount_;
}

- (NSUInteger)columnsCount
{
    if (!isColumnsCountValid_) {
        columnsCount_ = columns_.count;
        for (id<NUIView> subview in self.subviews) {
            NUIGridLayoutItem *item = (NUIGridLayoutItem *)[self layoutItemForSubview:subview];
            NSRange r = item.columnRange;
            columnsCount_ = MAX(r.location + r.length, columnsCount_);
        }
        isColumnsCountValid_ = YES;
    }
    return columnsCount_;
}

- (void)addSubview:(id<NUIView>)view layoutItem:(NUIGridLayoutItem *)layoutItem
{
    [super addSubview:view layoutItem:layoutItem];
    [self didAddLayoutItem:layoutItem];
}

- (void)insertSubview:(id<NUIView>)view belowSubview:(UIView *)siblingSubview
    layoutItem:(NUIGridLayoutItem *)layoutItem
{
    [super insertSubview:view belowSubview:siblingSubview layoutItem:layoutItem];
    [self didAddLayoutItem:layoutItem];
}

- (void)insertSubview:(id<NUIView>)view aboveSubview:(UIView *)siblingSubview
    layoutItem:(NUIGridLayoutItem *)layoutItem
{
    [super insertSubview:view aboveSubview:siblingSubview layoutItem:layoutItem];
    [self didAddLayoutItem:layoutItem];
}

- (void)layoutInRect:(CGRect)rect
{
    NSUInteger cColumn = 0, cRow = 0;
    CGFloat *widths = NULL, *heights = NULL;
    NSMutableDictionary *subviewSizes = [NSMutableDictionary dictionary];
    [self widths:&widths count:&cColumn heights:&heights count:&cRow subviewSizes:subviewSizes
         forSize:rect.size];
    for (int i = 0; i < cColumn; ++i) {
        rect.size.width -= widths[i];
    }
    for (int i = 0; i < cRow; ++i) {
        rect.size.height -= heights[i];
    }
    CGFloat stretchFactor = 0;
    for (NSUInteger i = 0; i < columns_.count; ++i) {
        NUIGridLength *column = columns_[i];
        if (column.type == NUIGridLengthType_Star) {
            stretchFactor += column.value;
        }
    }
    for (NSUInteger i = 0; i < columns_.count && stretchFactor > 0; ++i) {
        NUIGridLength *column = columns_[i];
        if (column.type == NUIGridLengthType_Star) {
            widths[i] = nuiScaledFloorf(rect.size.width * column.value / stretchFactor);
            rect.size.width -= widths[i];
            stretchFactor -= column.value;
        }
    }
    stretchFactor = 0;
    for (NSUInteger i = 0; i < rows_.count; ++i) {
        NUIGridLength *row = rows_[i];
        if (row.type == NUIGridLengthType_Star) {
            stretchFactor += row.value;
        }
    }
    for (NSUInteger i = 0; i < rows_.count && stretchFactor > 0; ++i) {
        NUIGridLength *row = rows_[i];
        if (row.type == NUIGridLengthType_Star) {
            heights[i] = nuiScaledFloorf(rect.size.height * row.value / stretchFactor);
            rect.size.height -= heights[i];
            stretchFactor -= row.value;
        }
    }
    for (int i = 1; i < cColumn; ++i) {
        widths[i] += widths[i - 1];
    }
    for (int i = 1; i < cRow; ++i) {
        heights[i] += heights[i - 1];
    }
    for (id<NUIView> subview in self.subviews) {
        NUIGridLayoutItem *item = (NUIGridLayoutItem *)[self layoutItemForSubview:subview];
        NSRange range = item.columnRange;
        CGFloat x = range.location > 0 ? widths[range.location - 1] : 0;
        NSUInteger index = range.location + range.length;
        CGFloat x2 = index > 0 ? widths[index - 1] : 0;

        range = item.rowRange;
        CGFloat y = range.location > 0 ? heights[range.location - 1] : 0;
        index = range.location + range.length;
        CGFloat y2 = index > 0 ? heights[index - 1] : 0;
        NSString *key = [[NSString alloc] initWithFormat:@"%p", subview];
        CGSize sz = [[subviewSizes objectForKey:key] CGSizeValue];
        [item placeInRect:CGRectMake(rect.origin.x + x, rect.origin.y + y, x2 - x, y2 - y)
            preferredSize:sz];
    }
    free(widths);
    free(heights);
}

- (CGSize)preferredSizeThatFits:(CGSize)size
{
    NSUInteger cColumn = 0, cRow = 0;
    CGFloat *widths = NULL, *heights = NULL;
    [self widths:&widths count:&cColumn heights:&heights count:&cRow subviewSizes:nil forSize:size];

    CGFloat width = 0, height = 0;
    for (NSUInteger i = 0; i < cColumn; ++i) {
        width += widths[i];
    }
    for (NSUInteger i = 0; i < cRow; ++i) {
        height += heights[i];
    }
    free(widths);
    free(heights);
    return CGSizeMake(width, height);
}

- (void)calculateSubviewPosition:(id<NUIView>)subview columns:(NSUInteger)columns
    rows:(NSUInteger)rows
{
    NSUInteger column = 0, row = 0;
    switch (insertionMethod_) {
        case NUIGridLayoutInsertionMethod_LeftRightTopDown:{
            for (id<NUIView> view in self.subviews) {
                NUIGridLayoutItem *item = (NUIGridLayoutItem *)[self layoutItemForSubview:view];
                NSRange r = item.rowRange;
                row = MAX(r.location + r.length, row);
            }
            if (row > 0) {
                --row;
            }
            for (id<NUIView> view in self.subviews) {
                NUIGridLayoutItem *item = (NUIGridLayoutItem *)[self layoutItemForSubview:view];
                NSRange range = item.rowRange;
                if (row >= range.location && row < range.location + range.length) {
                    range = item.columnRange;
                    if (column < range.location + range.length) {
                        column = range.location + range.length;
                        if (column >= columns_.count) {
                            column = 0;
                            ++row;
                            break;
                        }
                    }
                }
            }
            break;
        }
        case NUIGridLayoutInsertionMethod_TopDownLeftRight:{
            for (id<NUIView> view in self.subviews) {
                NUIGridLayoutItem *item = (NUIGridLayoutItem *)[self layoutItemForSubview:view];
                NSRange r = item.columnRange;
                column = MAX(r.location + r.length, column);
            }
            if (column > 0) {
                --column;
            }
            for (id<NUIView> view in self.subviews) {
                NUIGridLayoutItem *item = (NUIGridLayoutItem *)[self layoutItemForSubview:view];
                NSRange range = item.columnRange;
                if (column >= range.location && column < range.location + range.length) {
                    range = item.rowRange;
                    if (row < range.location + range.length) {
                        row = range.location + range.length;
                        if (row >= rows_.count) {
                            row = 0;
                            ++column;
                            break;
                        }
                    }
                }
            }
            break;
        }
        default:
            break;
    }
    NUIGridLayoutItem *item = (NUIGridLayoutItem *)[self layoutItemForSubview:subview];
    item.columnRange = (NSRange){column, columns};
    item.rowRange = (NSRange){row, rows};
}

- (void)widths:(CGFloat **)widths count:(NSUInteger *)columnsCount heights:(CGFloat **)heights
    count:(NSUInteger *)rowsCount subviewSizes:(NSMutableDictionary *)subviewSizes
    forSize:(CGSize)size
{
    // Fill min sizes
    NSUInteger cColumns = [self columnsCount];
    CGFloat *minWidth = (CGFloat *)calloc(cColumns, sizeof(CGFloat));
    for (NSUInteger i = 0; i < columns_.count; ++i) {
        NUIGridLength *column = columns_[i];
        if (column.type == NUIGridLengthType_Pixel) {
            minWidth[i] = column.value;
        }
    }

    NSUInteger cRows = [self rowsCount];
    CGFloat *minHeight = (CGFloat *)calloc(cRows, sizeof(CGFloat));
    for (NSUInteger i = 0; i < rows_.count; ++i) {
        NUIGridLength *row = rows_[i];
        if (row.type == NUIGridLengthType_Pixel) {
            minHeight[i] = row.value;
        }
    }

    // Calculate constraint size - min size
    CGSize constraintSize = size;
    if (constraintSize.width != CGFLOAT_MAX) {
        for (NSUInteger i = 0; i < columns_.count; ++i) {
            constraintSize.width -= minWidth[i];
        }
    }
    if (constraintSize.height != CGFLOAT_MAX) {
        for (NSUInteger i = 0; i < rows_.count; ++i) {
            constraintSize.height -= minHeight[i];
        }
    }

    if (!subviewSizes) {
        subviewSizes = [NSMutableDictionary dictionary];
    }
    for (NSUInteger nColumn = 0; nColumn < cColumns; ++nColumn) {
        for (NSUInteger nRow = 0; nRow < cRows; ++nRow) {
            for (id<NUIView> subview in self.subviews) {
                NUIGridLayoutItem *item = (NUIGridLayoutItem *)[self layoutItemForSubview:subview];
                NSRange rRange = item.rowRange;
                NSRange cRange = item.columnRange;

                if (rRange.location <= nRow && rRange.location + rRange.length > nRow &&
                    cRange.location <= nColumn && cRange.location + cRange.length > nColumn) {
                    NSString *key = [[NSString alloc] initWithFormat:@"%p", subview];
                    NSValue *value = [subviewSizes objectForKey:key];
                    CGSize subviewSize;
                    // Calculate subview size
                    if (!value) {
                        CGSize maxSize = constraintSize;
                        if (maxSize.width != CGFLOAT_MAX) {
                            for (NSUInteger i = cRange.location; i < cRange.location + cRange.length;
                                ++i) {
                                maxSize.width += minWidth[i];
                            }
                        }
                        if (maxSize.height != CGFLOAT_MAX) {
                            for (NSUInteger i = rRange.location; i < rRange.location + rRange.length;
                                ++i) {
                                maxSize.height += minHeight[i];
                            }
                        }
                        subviewSize = [item sizeWithMarginThatFits:maxSize];
                        [subviewSizes setObject:[NSValue valueWithCGSize:subviewSize] forKey:key];
                    } else {
                        subviewSize = [value CGSizeValue];
                    }
                    // Update min size
                    NUIGridLengthType lengthType = NUIGridLengthType_Auto;
                    if (nColumn < columns_.count) {
                        lengthType = ((NUIGridLength *)columns_[nColumn]).type;
                    }
                    if (lengthType == NUIGridLengthType_Auto) {
                        for (NSUInteger i = cRange.location; i < cRange.location + cRange.length; ++i) {
                            if (i != nColumn) {
                                subviewSize.width -= minWidth[i];
                            }
                        }
                        if (minWidth[nColumn] < subviewSize.width) {
                            if (constraintSize.width != CGFLOAT_MAX) {
                                constraintSize.width += subviewSize.width - minWidth[nColumn];
                            }
                            minWidth[nColumn] = subviewSize.width;
                        }
                    }
                    lengthType = NUIGridLengthType_Auto;
                    if (nRow < rows_.count) {
                        lengthType = ((NUIGridLength *)rows_[nRow]).type;
                    }
                    if (lengthType == NUIGridLengthType_Auto) {
                        for (NSUInteger i = rRange.location; i < rRange.location + rRange.length; ++i) {
                            if (i != nRow) {
                                subviewSize.height -= minHeight[i];
                            }
                        }
                        if (minHeight[nRow] < subviewSize.height) {
                            if (constraintSize.height != CGFLOAT_MAX) {
                                constraintSize.height += subviewSize.height - minHeight[nRow];
                            }
                            minHeight[nRow] = subviewSize.height;
                        }
                    }
                }
            }
        }
    }

    if (widths) {
        *widths = minWidth;
    } else {
        free(minWidth);
    }
    if (columnsCount) {
        *columnsCount = cColumns;
    }
    if (heights) {
        *heights = minHeight;
    } else {
        free(minHeight);
    }
    if (rowsCount) {
        *rowsCount = cRows;
    }
}

- (NUIGridLayoutItem *)addLayoutItemForSubview:(id<NUIView>)view
{
    NUIGridLayoutItem *layoutItem = [[NUIGridLayoutItem alloc] init];
    [self addSubview:view layoutItem:layoutItem];
    return layoutItem;
}

#pragma mark - observers

- (void)didAddLayoutItem:(NUIGridLayoutItem *)layoutItem
{
    isColumnsCountValid_ = NO;
    isRowsCountValid_ = NO;
    [layoutItem addObserver:self forKeyPath:@"columnRange" options:0
        context:&columnRangeObserverContext];
    [layoutItem addObserver:self forKeyPath:@"rowRange" options:0 context:&rowRangeObserverContext];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change
    context:(void *)context
{
    if (context == &columnRangeObserverContext) {
        isColumnsCountValid_ = NO;
    } else if (context == &rowRangeObserverContext) {
        isRowsCountValid_ = NO;
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

@end
