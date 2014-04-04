//
//  UIImage+NUILoading.h
//  NUILoader
//
//  Created by Ivan Masalov on 7/12/12.
//  Copyright (c) 2012 Noveo Group. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NUIStatement;
@class NUIError;
@class NUILoader;

/*! A category to support loading of \b UIImage objects from NUI. */
@interface UIImage (NUILoading)

/*! Allows to load \b UIImage from NUI. The following properties are can be used:
 *  * \b file - a string with a image name from resources.
 *  * \b leftCapWidth - an optional numeric property. If set
 *    \b stretchableImageWithLeftCapWidth:topCapHeight: will be used.
 *  * \b topCapHeight - an optional numeric property. If set
 *    \b stretchableImageWithLeftCapWidth:topCapHeight: will be used.
 */
+ (id)loadFromNUIObject:(NUIStatement *)nuiObject loader:(NUILoader *)loader
    error:(NUIError **)error;

@end
