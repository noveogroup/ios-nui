//
//  NUICellLayoutItem.h
//  NUIKit
//
//  Created by Ivan Masalov on 15/12/13.
//  Copyright (c) 2013 Noveo Group. All rights reserved.
//

#import "NUILayoutItem.h"

/*! Layout item used by NUIHorizontalCellLayout and NUIVerticalCellLayout. */
@interface NUICellLayoutItem : NUILayoutItem

/*! A range of cells taken by view. Default value is [0, 1]. */
@property (nonatomic, unsafe_unretained) NSRange cellRange;

@end
