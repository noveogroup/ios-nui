//
//  NUIGridLength.h
//  NUILayout
//
//  Created by Ivan Masalov on 4/4/12.
//  Copyright (c) 2012 eko team. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    /*! Size is calculated automatically depending on content size. */
    NUIGridLengthType_Auto = 0,
    /*! Size is fixed. */
    NUIGridLengthType_Pixel,
    /*! Size is calculated automatically depending on leftover size. \b value is used as a
     *  proportionfactor. */
    NUIGridLengthType_Star,
} NUIGridLengthType;

/*! Used by \b NUIGridLayout to define columns and rows. */
@interface NUIGridLength : NSObject

@property (nonatomic, assign) CGFloat value;
@property (nonatomic, assign) NUIGridLengthType type;

/*! Initializes an object with NUIGridLengthType_Pixel type. */
- (id)initWithPixelValue:(CGFloat)value;
- (id)initWithValue:(CGFloat)value type:(NUIGridLengthType)type;
/*! Allows to simplify creation of arrays of \b NUIGridLength. The following value are acceptable:
 *  * \b auto for NUIGridLengthType_Auto
 *  * \b <number> for NUIGridLengthType_Pixel
 *  * \b <number>* for NUIGridLengthType_Star
 */
- (id)initWithString:(NSString *)string;

@end