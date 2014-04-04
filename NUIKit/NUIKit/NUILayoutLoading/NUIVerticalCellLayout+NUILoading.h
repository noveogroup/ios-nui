//
//  NUIVerticalCellLayout+NUILoading.h
//  NUIKit
//
//  Created by Ivan Masalov on 24/12/13.
//  Copyright (c) 2013 Noveo Group. All rights reserved.
//

#import "NUIVerticalCellLayout.h"

@class NUIStatement;
@class NUILoader;
@class NUIError;

/*! A category to support loading of properties of \b NUIGridLayout from NUI that can't be loaded
 *  automatically.
 */
@interface NUIVerticalCellLayout (NUILoading)

/*! Allows to load cells from a string containing values that can be used to initialize
 *  \b NUIGridLength (i.e., auto, 44, 56*)
 */
- (BOOL)loadNUICellsFromRValue:(NUIStatement *)value loader:(NUILoader *)loader
    error:(NUIError **)error;

@end
