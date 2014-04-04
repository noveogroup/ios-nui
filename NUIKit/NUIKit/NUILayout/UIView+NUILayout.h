//
//  UIView+NUILayout.h
//  NUILayout
//
//  Created by Ivan Masalov on 4/4/12.
//  Copyright (c) 2012 Noveo Group. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NUIView.h"

@interface UIView (NUILayout) <NUIView>

// Layout objects monitor this option to update layout and set their needsToUpdateSize to YES
// so parent layout will update layout too
@property (nonatomic, unsafe_unretained) BOOL needsToUpdateSize;

// If superView is NUILayoutView and its layout is set than returns a layout item from the layout
// that corresponds to this view. Otherwise returns nil.
- (NUILayoutItem *)layoutItem;

// sizeThatFits: returns current size by default, it is not good behaviour
// preferredSizeThatFits: by default returns min size 
- (CGSize)preferredSizeThatFits:(CGSize)size;

// calls preferredSizeThatFits: with CGFLOAT_MAX as second parameter of size
- (CGFloat)preferredHeightForWidth:(CGFloat)width;
- (CGFloat)preferredWidthForHeight:(CGFloat)height;

@end
