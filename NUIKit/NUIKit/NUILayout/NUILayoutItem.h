//
//  NUILayoutItem.h
//  NUILayout
//
//  Created by Ivan Masalov on 4/4/12.
//  Copyright (c) 2012 Noveo Group. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NUIView;

@class NUILayout;

typedef enum {
    NUIVerticalAlignment_Center,
    NUIVerticalAlignment_Top,
    NUIVerticalAlignment_Bottom,
    NUIVerticalAlignment_Stretch,
} NUIVerticalAlignment;

typedef enum {
    NUIHorizontalAlignment_Center,
    NUIHorizontalAlignment_Left,
    NUIHorizontalAlignment_Right,
    NUIHorizontalAlignment_Stretch,
} NUIHorizontalAlignment;

typedef enum {
    NUIVisibility_Visible,
    NUIVisibility_Hidden,
    NUIVisibility_Collapsed,
} NUIVisibility;

/*! A base class for layout item. Layout item defines layouting attributes of corresponding view. */
@interface NUILayoutItem : NSObject

@property (nonatomic, unsafe_unretained) NUILayout *layout;
@property (nonatomic, strong) id<NUIView> view;

@property (nonatomic, unsafe_unretained) UIEdgeInsets margin;
@property (nonatomic, unsafe_unretained) NUIVerticalAlignment verticalAlignment;
@property (nonatomic, unsafe_unretained) NUIHorizontalAlignment horizontalAlignment;

@property (nonatomic, unsafe_unretained) CGSize minSize;
@property (nonatomic, unsafe_unretained) CGSize maxSize;
@property (nonatomic, unsafe_unretained) CGSize fixedSize;

@property (nonatomic, unsafe_unretained) CGFloat minWidth;
@property (nonatomic, unsafe_unretained) CGFloat maxWidth;

@property (nonatomic, unsafe_unretained) CGFloat minHeight;
@property (nonatomic, unsafe_unretained) CGFloat maxHeight;

@property (nonatomic, unsafe_unretained) CGFloat fixedWidth;
@property (nonatomic, unsafe_unretained) BOOL isFixedWidthSet;

@property (nonatomic, unsafe_unretained) CGFloat fixedHeight;
@property (nonatomic, unsafe_unretained) BOOL isFixedHeightSet;

/*! Use it instead of view \b hidden property. */
@property (nonatomic, unsafe_unretained) NUIVisibility visibility;

/*! An object that should help to distinct one layout item from another when
 *  debugging. */
@property (nonatomic, strong) id tag;

/*! Constraining by min and max widths. */
- (CGFloat)constraintWidth:(CGFloat)width;
/*! Constraining by min and max heights. */
- (CGFloat)constraintHeight:(CGFloat)height;
/*! Constraining by min and max sizes. */
- (CGSize)constraintSize:(CGSize)size;

/*! Returns constrained size returned by \b preferredSizeThatFits:. Performs caching.*/
- (CGSize)sizeWithMarginThatFits:(CGSize)size;

/*! Sets view frame taking in respect view alignment. */
- (void)placeInRect:(CGRect)rect preferredSize:(CGSize)size;

@end
