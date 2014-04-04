//
//  NUILayoutView.m
//  NUILayout
//
//  Created by Ivan Masalov on 4/4/12.
//  Copyright (c) 2012 Noveo Group. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NUILayout;
@class NUILayoutAnimation;

/*! A view with a layout. Sets \b autoresizesSubviews to \b NO and monitors \b needsToUpdateSize
 *  property of subviews. Do not add subviews via UIView methods, use layout methods.
 */
@interface NUILayoutView : UIView

/*! Changing this property causes removing subviews from old layout and adding from new one. */
@property (nonatomic, retain) IBOutlet NUILayout *layout;

/*! If not \b nil subviews layouting will be animated. */
@property (nonatomic, retain) IBOutlet NUILayoutAnimation *layoutAnimation;

@end
