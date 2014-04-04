//
//  UIView+NUILoading.h
//  NUILoader
//
//  Created by Ivan Masalov on 7/12/12.
//  Copyright (c) 2012 Noveo Group. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NUILoader;
@class NUIStatement;
@class NUIError;

/*! A category to support loading of properties of \b UIView from NUI that can't be loaded
 *  automatically.
 */
@interface UIView (NUILoading)

/*! \b backgroundColor is not a real property, so adding declaration to allow atomatic loading. */
@property (nonatomic, copy) UIColor *backgroundColor;

/*! Allows to load \b autoresizingMask property using following values:
 *  * \b FlexibleLeftMargin for \b UIViewAutoresizingFlexibleLeftMargin.
 *  * \b FlexibleWidth for \b UIViewAutoresizingFlexibleWidth.
 *  * \b FlexibleRightMargin for \b UIViewAutoresizingFlexibleRightMargin.
 *  * \b FlexibleTopMargin for \b UIViewAutoresizingFlexibleTopMargin.
 *  * \b FlexibleHeight for \b UIViewAutoresizingFlexibleHeight.
 *  * \b FlexibleBottomMargin for \b UIViewAutoresizingFlexibleBottomMargin.
 */
+ (NSDictionary *)nuiConstantsForAutoresizingMask;
/*! Allows to load \b contentMode property using following values:
 *  * \b ScaleToFill for \b UIViewContentModeScaleToFill.
 *  * \b ScaleAspectFit for \b UIViewContentModeScaleAspectFit.
 *  * \b ScaleAspectFill for \b UIViewContentModeScaleAspectFill.
 *  * \b Redraw for \b UIViewContentModeRedraw.
 *  * \b Center for \b UIViewContentModeCenter.
 *  * \b Top for \b UIViewContentModeTop.
 *  * \b Bottom for \b UIViewContentModeBottom.
 *  * \b Left for \b UIViewContentModeLeft.
 *  * \b Right for \b UIViewContentModeRight.
 *  * \b TopLeft for \b UIViewContentModeTopLeft.
 *  * \b TopRight for \b UIViewContentModeTopRight.
 *  * \b BottomLeft for \b UIViewContentModeBottomLeft.
 *  * \b BottomRight for \b UIViewContentModeBottomRight.
 */
+ (NSDictionary *)nuiConstantsForContentMode;

/*! Allows to load subviews from NUI using \b subviews property which value should be an array. */
- (BOOL)loadNUISubviewsFromRValue:(NUIStatement *)array loader:(NUILoader *)loader
    error:(NUIError **)error;

@end
