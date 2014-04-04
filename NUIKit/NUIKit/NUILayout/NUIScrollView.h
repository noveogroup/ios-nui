//
//  NUIScrollView.h
//  NUILayout
//
//  Created by Ivan Masalov on 4/4/12.
//  Copyright (c) 2012 Noveo Group. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NUILayoutItem;

/*! A scroll view with only one subview, but with automatic \b contentSize calculation. If a
 *  scroller is disabled than the corresponding content size equals to the scroll view size.
 */
@interface NUIScrollView : UIScrollView

/*! Default value is \b NO. */
@property (nonatomic, unsafe_unretained) BOOL horizontalScrollerEnabled;
/*! Default value is \b YES. */
@property (nonatomic, unsafe_unretained) BOOL verticalScrollerEnabled;
/*! Default value is \b nil. */
@property (nonatomic, strong) IBOutlet UIView *contentView;
/*! By default vertical alignment is set to top. */
@property (nonatomic, strong, readonly) NUILayoutItem *contentLayoutItem;

@end
