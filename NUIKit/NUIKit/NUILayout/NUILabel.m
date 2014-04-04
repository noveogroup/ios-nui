//
//  NUILabel.m
//  NUILayout
//
//  Created by Ivan Masalov on 4/4/12.
//  Copyright (c) 2012 Noveo Group. All rights reserved.
//

#import "NUILabel.h"
#import "UIView+NUILayout.h"

@implementation NUILabel

- (void)setText:(NSString *)text
{
    [super setText:text];
    self.needsToUpdateSize = YES;
}

- (void)setAttributedText:(NSAttributedString *)attributedText
{
    [super setAttributedText:attributedText];
    self.needsToUpdateSize = YES;
}

- (void)setFont:(UIFont *)font
{
    [super setFont:font];
    self.needsToUpdateSize = YES;
}

- (void)setTextAlignment:(NSTextAlignment)textAlignment
{
    [super setTextAlignment:textAlignment];
    self.needsToUpdateSize = YES;
}

- (void)setLineBreakMode:(NSLineBreakMode)lineBreakMode
{
    [super setLineBreakMode:lineBreakMode];
    self.needsToUpdateSize = YES;
}

- (void)setNumberOfLines:(NSInteger)numberOfLines
{
    [super setNumberOfLines:numberOfLines];
    self.needsToUpdateSize = YES;
}

- (void)setAdjustsFontSizeToFitWidth:(BOOL)adjustsFontSizeToFitWidth
{
    [super setAdjustsFontSizeToFitWidth:adjustsFontSizeToFitWidth];
    self.needsToUpdateSize = YES;
}

- (void)setMinimumFontSize:(CGFloat)minimumFontSize
{
    [super setMinimumFontSize:minimumFontSize];
    self.needsToUpdateSize = YES;
}

- (void)setBaselineAdjustment:(UIBaselineAdjustment)baselineAdjustment
{
    [super setBaselineAdjustment:baselineAdjustment];
    self.needsToUpdateSize = YES;
}

- (CGSize)preferredSizeThatFits:(CGSize)size
{
    return [self sizeThatFits:size];
}

@end
