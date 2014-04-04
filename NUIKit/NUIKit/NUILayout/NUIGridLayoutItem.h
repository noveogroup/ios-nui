//
//  NUIGridLayoutItem.h
//  NUILayout
//
//  Created by Ivan Masalov on 4/4/12.
//  Copyright (c) 2012 Noveo Group. All rights reserved.
//

#import "NUILayoutItem.h"

/*! A layout item used by \b NUIGridLayout. */
@interface NUIGridLayoutItem : NUILayoutItem

/*! A range of columns taken by view. Default value is [0, 1]. */
@property (nonatomic, unsafe_unretained) NSRange columnRange;
/*! A range of rows taken by view. Default value is [0, 1]. */
@property (nonatomic, unsafe_unretained) NSRange rowRange;
/*! A first column number taken by view. Default value is 0. */
@property (nonatomic, unsafe_unretained) NSUInteger column;
/*! A first row number taken by view. Default value is 0. */
@property (nonatomic, unsafe_unretained) NSUInteger row;

@end
