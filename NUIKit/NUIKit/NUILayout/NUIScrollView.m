//
//  NUIScrollView.m
//  NUILayout
//
//  Created by Ivan Masalov on 4/4/12.
//  Copyright (c) 2012 Noveo Group. All rights reserved.
//

#import "NUIScrollView.h"
#import "NUILayoutItem.h"
#import "UIView+NUILayout.h"

@implementation NUIScrollView

@synthesize horizontalScrollerEnabled = horizontalScrollerEnabled_;
@synthesize verticalScrollerEnabled = verticalScrollerEnabled_;
@synthesize contentView = contentView_;
@synthesize contentLayoutItem = contentLayoutItem_;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        verticalScrollerEnabled_ = YES;
        contentLayoutItem_ = [[NUILayoutItem alloc] init];
        contentLayoutItem_.verticalAlignment = NUIVerticalAlignment_Top;
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        verticalScrollerEnabled_ = YES;
        contentLayoutItem_ = [[NUILayoutItem alloc] init];
        contentLayoutItem_.verticalAlignment = NUIVerticalAlignment_Top;
    }
    return self;
}

- (void)dealloc
{
    [contentView_ removeObserver:self forKeyPath:@"needsToUpdateSize"];
}

- (void)setFrame:(CGRect)frame
{
    // For some reason when setting scroll view size to a bigger value with
    // animation (enough to cause contentOffset change) animation becomes
    // incorrect: only center is animated not bounds.
    CGSize sz = [self preferredSizeThatFits:frame.size];
    UIEdgeInsets contentInset = self.contentInset;
    sz.width += contentInset.left + contentInset.right;
    sz.height += contentInset.top + contentInset.bottom;
    sz.width = MAX(sz.width, frame.size.width);
    sz.height = MAX(sz.height, frame.size.height);
    // contentOffset = bounds.origin, but we can animate bounds.origin as we
    // want.
    CGPoint contentOffset = self.bounds.origin;
    if (contentOffset.x + frame.size.width > sz.width) {
        contentOffset.x = sz.width - frame.size.width;
    }
    if (contentOffset.y + frame.size.height > sz.height) {
        contentOffset.y = sz.height - frame.size.height;
    }
    [self setCenter:(CGPoint){frame.origin.x + frame.size.width / 2,
        frame.origin.y + frame.size.height / 2}];
    [super setBounds:(CGRect){contentOffset, frame.size}];
}

- (void)setHorizontalScrollerEnabled:(BOOL)horizontalScrollerEnabled
{
    if (horizontalScrollerEnabled_ != horizontalScrollerEnabled) {
        horizontalScrollerEnabled_ = horizontalScrollerEnabled;
        [self setNeedsLayout];
    }
}

- (void)setVerticalScrollerEnabled:(BOOL)verticalScrollerEnabled
{
    if (verticalScrollerEnabled_ != verticalScrollerEnabled) {
        verticalScrollerEnabled_ = verticalScrollerEnabled;
        [self setNeedsLayout];
    }
}

- (void)setContentView:(UIView *)contentView
{
    if (contentView_ == contentView) {
        return;
    }
    if (contentView_) {
        [contentView_ removeFromSuperview];
        [contentView_ removeObserver:self forKeyPath:@"needsToUpdateSize"];
    }
    contentView_ = contentView;
    [contentView_ addObserver:self
                   forKeyPath:@"needsToUpdateSize"
                      options:NSKeyValueObservingOptionNew
                      context:NULL];
    [self addSubview:contentView_];
    contentLayoutItem_.view = contentView;
    [self setNeedsLayout];
}

- (void)layoutSubviews
{
    CGSize constraintSize = CGSizeMake(0, 0);
    if (!horizontalScrollerEnabled_) {
        constraintSize.width = self.bounds.size.width;
    }
    if (!verticalScrollerEnabled_) {
        constraintSize.height = self.bounds.size.height;
    }
    CGSize maxSize = self.bounds.size;
    CGSize size = [contentLayoutItem_ sizeWithMarginThatFits:constraintSize];
    if (maxSize.width < size.width && horizontalScrollerEnabled_) {
        maxSize.width = size.width;
    }
    if (maxSize.height < size.height && verticalScrollerEnabled_) {
        maxSize.height = size.height;
    }
    self.contentSize = maxSize;

    [contentLayoutItem_ placeInRect:CGRectMake(0, 0, maxSize.width, maxSize.height)
                      preferredSize:size];
}

#pragma mark - observers

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    if ([keyPath isEqualToString:@"needsToUpdateSize"]) {
        id newValue = [change objectForKey:NSKeyValueChangeNewKey];
        if (newValue != [NSNull null] && [newValue boolValue]) {
            [self setNeedsLayout];
        }
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (CGSize)preferredSizeThatFits:(CGSize)size
{
    return [contentLayoutItem_ sizeWithMarginThatFits:size];
}

@end
