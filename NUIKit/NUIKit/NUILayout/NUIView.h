//
//  UIView+NUILayout.h
//  NUILayout
//
//  Created by Ivan Masalov on 8/20/12.
//  Copyright (c) 2012 Noveo Group. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NUILayoutView;
@class NUILayoutItem;

/*! This protocol is implemented by \b NUILayout and \b UIView so they can be treated equally by a
 *  containing layout.
 */
@protocol NUIView <NSObject>

/*! Layout objects monitor this option to update layout and set their \b needsToUpdateSize to \b YES
 *  so parent layout will update layout too.
 */
@property (nonatomic, unsafe_unretained) BOOL needsToUpdateSize;

/*! This property should be used directly. It set by \b NUILayoutItem objects to hide a view or to
 *  notify a layout object that its subviews should be hidden.
 */
@property (nonatomic, unsafe_unretained, getter=isHidden) BOOL hidden;

/*! If \b superview is \b NUILayoutView and its layout is set than returns a layout item from the
 *  layout that corresponds to this view. Otherwise returns \b nil.
 */
- (NUILayoutItem *)layoutItem;

/*! Returns all associated layout items. */
- (NSArray *)layoutItems;
/*! Adds weak reference to layout item. */
- (void)addLayoutItem:(NUILayoutItem *)layoutItem;
/*! Removes reference to layout item. */
- (void)removeLayoutItem:(NUILayoutItem *)layoutItem;

/*! An equivalent of \b sizeThatFits:, but instead of the current size it returns \b CGSizeZero by
 *  default.
 */
- (CGSize)preferredSizeThatFits:(CGSize)size;

/*! A containing view. */
- (UIView *)superview;
/*! Layout objects preform layouting in this method. \b frame property implementation is used for
 *  \b UIView objects.
 */
- (void)setFrame:(CGRect)frame;

/*! \b UIView implementation just uses \b addToView: method. \b NUILayout implementation calls this
 *  method for all subviews and sets \b superview property.
 */
- (void)addToView:(NUILayoutView *)view;
/*! \b UIView implementation just uses \b insertSubview:belowSubview: method. \b NUILayout
 *  implementation calls this method for all subviews and sets \b superview property.
 */
- (void)insertIntoView:(NUILayoutView *)view belowSubview:(UIView *)siblingSubview;
/*! \b UIView implementation just uses \b insertSubview:aboveSubview: method. \b NUILayout
 *  implementation calls this method for all subviews and sets \b superview property.
 */
- (void)insertIntoView:(NUILayoutView *)view aboveSubview:(UIView *)siblingSubview
    lastInsertedSubview:(UIView **)lastSubview;
/*! \b UIView already has this method. \b NUILayout implementation calls this method for all
 *  subviews and sets \b superview property to \b nil.
 */
- (void)removeFromSuperview;

@end