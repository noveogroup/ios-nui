//
//  UIButton+NUILayout.m
//  NUILayout
//
//  Created by Ivan Masalov on 8/22/12.
//  Copyright (c) 2012 Noveo Group. All rights reserved.
//

#import "UIButton+NUILayout.h"

@implementation UIButton (NUILayout)

- (CGSize)preferredSizeThatFits:(CGSize)size
{
    size.width -= self.contentEdgeInsets.left + self.contentEdgeInsets.right;
    size.height -= self.contentEdgeInsets.top + self.contentEdgeInsets.bottom;
    CGSize imageSz = CGSizeZero;
    if (self.currentImage) {
        self.imageView.image = self.currentImage;
        CGSize sz = CGSizeMake(size.width - self.imageEdgeInsets.left - self.imageEdgeInsets.right,
            size.height - self.imageEdgeInsets.top - self.imageEdgeInsets.bottom);
        imageSz = [self.imageView sizeThatFits:sz];
        imageSz.width += self.imageEdgeInsets.left + self.imageEdgeInsets.right;
        imageSz.height += self.imageEdgeInsets.top + self.imageEdgeInsets.bottom;
        size.width -= imageSz.width;
    }
    CGSize titleSz = CGSizeZero;
    if (self.currentTitle) {
        CGSize sz = CGSizeMake(size.width - self.titleEdgeInsets.left - self.titleEdgeInsets.right,
            size.height - self.titleEdgeInsets.top - self.titleEdgeInsets.bottom);
        if (self.titleLabel.numberOfLines == 1) {
            titleSz = [self.currentTitle sizeWithFont:self.titleLabel.font constrainedToSize:(CGSize){CGFLOAT_MAX, sz.height}
                lineBreakMode:self.titleLabel.lineBreakMode];
        } else {
            titleSz = [self.currentTitle sizeWithFont:self.titleLabel.font constrainedToSize:sz
                lineBreakMode:self.titleLabel.lineBreakMode];
        }
        titleSz.width += self.titleEdgeInsets.left + self.titleEdgeInsets.right;
        titleSz.height += self.titleEdgeInsets.top + self.titleEdgeInsets.bottom;
    }
    size = CGSizeMake(titleSz.width + imageSz.width, MAX(titleSz.height, imageSz.height));
    size.width += self.contentEdgeInsets.left + self.contentEdgeInsets.right;
    size.height += self.contentEdgeInsets.top + self.contentEdgeInsets.bottom;
    return size;
}

@end
