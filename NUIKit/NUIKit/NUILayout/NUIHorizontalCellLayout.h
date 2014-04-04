//
//  NUIHorizontalCellLayout.h
//  NUIKit
//
//  Created by Ivan Masalov on 15/12/13.
//  Copyright (c) 2013 Ivan Masalov. All rights reserved.
//

#import "NUILayout.h"

@class NUICellLayoutItem;

/*!
 *  Layouts subviews in a row. A subview can take several columns. Columns sizes
 *  calculated in the following order:
 *  * Fixed-sized columns size is fixed.
 *  * Auto-sized columns size is calculated using remaining space as constraint.
 *    Columns with bigger priority processed first, so they are constrained
 *    with bigger area.
 *  * Remaining space is divided between stretchable columns according to the
 *    factors.
 *  If there are not enough columns they are added automatically with
 *  \b NUIGridLengthType_Auto type and 0.0f priority.
 */
@interface NUIHorizontalCellLayout : NUILayout

/*! An array of \b NUIGridLength. */
@property (nonatomic, copy) NSArray *cells;
/*! Used as a position for inserted view if position is not specified explicitly.
 *  Updated after inserting a view to the cell after the view.
 */
@property (nonatomic, unsafe_unretained) NSUInteger insertPosition;

/*! Allows to simplify configuring of cells. \b cells are arrays of strings that
 *  used to create \b NUIGridLength with \b initWithString: method. */
- (id)initWithCells:(NSArray *)cells;

/*! Places \b view in a cell at \b insertPosition. */
- (NUICellLayoutItem *)addSubview:(id<NUIView>)view;
/*! Places \b view in specified cell. */
- (NUICellLayoutItem *)addSubview:(id<NUIView>)view cell:(NSUInteger)cell;
/*! Places \b view in specified cells. */
- (NUICellLayoutItem *)addSubview:(id<NUIView>)view cellRange:(NSRange)range;
/*! Places \b view in several cells starting with \b insertPosition. */
- (NUICellLayoutItem *)addSubview:(id<NUIView>)view cells:(NSUInteger)cells;
/*! Removes \b view from layout. */
- (void)removeSubview:(id<NUIView>)view;

/*! Number of cells including added automatically. */
- (NSUInteger)cellsCount;

@end
