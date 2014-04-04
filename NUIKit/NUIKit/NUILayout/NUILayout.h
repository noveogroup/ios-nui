//
//  NUILayout.h
//  NUILayout
//
//  Created by Ivan Masalov on 4/4/12.
//  Copyright (c) 2012 Noveo Group. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NUIView.h"

@class NUILayoutView;
@class NUILayoutItem;

/*! Base class for layouts. Each layout has subviews and corresponding layout items.
 *  Adding/removing subview should cause adding/removing subview to current view.
 *  Override \b layoutInRect: to implement layouting.
 */
@interface NUILayout : NSObject <NUIView>

/*! A view where \b subviews are placed. \b superview.layout is not necessary equals to the current
 *  object.
 */
@property (nonatomic, unsafe_unretained) NUILayoutView *superview;
@property (nonatomic, unsafe_unretained, getter=isHidden) BOOL hidden;
@property (nonatomic, unsafe_unretained) BOOL needsToUpdateSize;

/*! An object that should help to distinct one layout from another when
 *  debugging. */
@property (nonatomic, strong) id tag;

/*! Adds view, layout item pair to layout. */
- (void)addSubview:(id<NUIView>)view layoutItem:(NUILayoutItem *)layoutItem;
/*! Inserts view, layout item pair to layout below \b siblingSubview. */
- (void)insertSubview:(id<NUIView>)view belowSubview:(UIView *)siblingSubview
    layoutItem:(NUILayoutItem *)layoutItem;
/*! Inserts view, layout item pair to layout above \b siblingSubview. */
- (void)insertSubview:(id<NUIView>)view aboveSubview:(UIView *)siblingSubview
    layoutItem:(NUILayoutItem *)layoutItem;
/*! Removes view from layout. */
- (void)removeSubview:(id<NUIView>)view;

/*! An array of NUIView objects. */
- (NSArray *)subviews;

/*! Creates layout item (\b NUILayoutItem by default). Override if custom layout items are needed.
 */
- (NUILayoutItem *)createLayoutItem;
/*! Returns layout item that corresponds to \b subview. */
- (NUILayoutItem *)layoutItemForSubview:(id<NUIView>)subview;
/*! Returns layout item that corresponds to \b subview. If \b recursively is set to \b YES than
 * preforms search in sublayouts too.
 */
- (NUILayoutItem *)layoutItemForSubview:(id<NUIView>)subview recursively:(BOOL)recursively;
/*! Override to perform layouting. */
- (void)layoutInRect:(CGRect)rect;

@end
