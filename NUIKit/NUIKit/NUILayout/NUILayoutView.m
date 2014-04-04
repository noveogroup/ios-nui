//
//  NUILayoutView.m
//  NUILayout
//
//  Created by Ivan Masalov on 4/4/12.
//  Copyright (c) 2012 Noveo Group. All rights reserved.
//

#import "NUILayoutView.h"
#import "NUILayout.h"
#import "UIView+NUILayout.h"
#import "NUILayoutAnimation.h"

static int NeedsToUpdateSizeObserverContext;

@interface NUILayoutView ()
{
    BOOL firstLayouting_;
    BOOL deallocating_;
}

@property (nonatomic, strong) NSMutableSet *observingViews;

@end

@implementation NUILayoutView

@synthesize layout = layout_;
@synthesize layoutAnimation = layoutAnimation_;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        firstLayouting_ = YES;
        self.autoresizesSubviews = NO;
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        firstLayouting_ = YES;
        self.autoresizesSubviews = NO;
    }
    return self;
}

- (void)dealloc
{
    deallocating_ = YES;
    for (UIView *subview in self.subviews) {
        [subview removeObserver:self forKeyPath:@"needsToUpdateSize"];
    }
}

- (void)setLayout:(NUILayout *)layout
{
    if (layout == layout_) {
        return;
    }

    layout_.superview = nil;
    for (id<NUIView> subview in [layout_ subviews]) {
        [subview removeFromSuperview];
    }

    layout_ = layout;

    layout_.superview = self;
    for (id<NUIView> subview in [layout_ subviews]) {
        [subview addToView:self];
    }
}

- (NSMutableSet *)observingViews
{
    if (!_observingViews) {
        _observingViews = [[NSMutableSet alloc] init];
    }
    return _observingViews;
}

- (void)layoutSubviews
{
    void (^animation)() = ^{
        layout_.frame = self.bounds;
        for (UIView *view in self.subviews) {
            [view layoutIfNeeded];
        }
    };
    if (!firstLayouting_ && layoutAnimation_) {
        [UIView animateWithDuration:layoutAnimation_.duration delay:
            layoutAnimation_.delay options:layoutAnimation_.options
            animations:animation completion:nil];
    } else {
        animation();
    }
    firstLayouting_ = NO;
}

- (CGSize)preferredSizeThatFits:(CGSize)size
{
    if (!layout_) {
        return CGSizeZero;
    }
    return [layout_ preferredSizeThatFits:size];
}

#pragma mark - observers

- (void)didAddSubview:(UIView *)subview
{
    [super didAddSubview:subview];
    // If we add a view that already added than willRemoveSubview won't be
    // called, but didAddSubview will be called second time.
    NSString *key = [NSString stringWithFormat:@"%p", subview];
    if (![self.observingViews containsObject:key]) {
        [self.observingViews addObject:key];
        [subview addObserver:self forKeyPath:@"needsToUpdateSize"
            options:NSKeyValueObservingOptionNew
            context:&NeedsToUpdateSizeObserverContext];
    }
    self.needsToUpdateSize = YES;
    [self setNeedsLayout];
}

- (void)willRemoveSubview:(UIView *)subview
{
    [super willRemoveSubview:subview];

    if (!deallocating_) {
        [self.observingViews removeObject:[NSString stringWithFormat:@"%p",
            subview]];
        [subview removeObserver:self forKeyPath:@"needsToUpdateSize"];
        self.needsToUpdateSize = YES;
        [self setNeedsLayout];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object
    change:(NSDictionary *)change context:(void *)context
{
    if (context == &NeedsToUpdateSizeObserverContext) {
        id newValue = [change objectForKey:NSKeyValueChangeNewKey];
        if (newValue != [NSNull null] && [newValue boolValue]) {
            self.needsToUpdateSize = YES;
            [self setNeedsLayout];
        }
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change
            context:context];
    }
}

@end
