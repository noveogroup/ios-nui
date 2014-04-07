//
//  StackLayoutViewController.m
//  NUIDemo
//
//  Created by Ivan Masalov on 4/4/14.
//  Copyright (c) 2012 Noveo Group. All rights reserved.
//

#import "StackLayoutViewController.h"

#import "NUIKit/NUILayouts.h"

@implementation StackLayoutViewController

- (UIRectEdge)edgesForExtendedLayout
{
    return UIRectEdgeNone;
}

- (void)loadView
{
    NUILayoutView *view = [[NUILayoutView alloc] init];
    view.backgroundColor = [UIColor whiteColor];
    NUIVerticalLayout *mainLayout = [[NUIVerticalLayout alloc] init];
    view.layout = mainLayout;

    NUIHorizontalLayout *contentLayout = [[NUIHorizontalLayout alloc] init];
    {
        NUILayoutItem *item= [mainLayout addSubview:contentLayout];
        item.horizontalAlignment = NUIHorizontalAlignment_Stretch;
    }

    {
        UIImageView *photoView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"photo.jpg"]];
        NUILayoutItem *item = [contentLayout addSubview:photoView];
        item.fixedSize = CGSizeMake(100, 100);
        item.margin = UIEdgeInsetsMake(10, 10, 10, 10);
    }

    NUIVerticalLayout *infoLayout = [[NUIVerticalLayout alloc] init];
    {
        NUILayoutItem *item = [contentLayout addSubview:infoLayout];
        item.horizontalAlignment = NUIHorizontalAlignment_Stretch;
    }

    {
        NUILabel *label  = [[NUILabel alloc] init];
        label.text = @"Name: Cat";
        label.backgroundColor = [UIColor greenColor];
        NUILayoutItem *item = [infoLayout addSubview:label];
        item.horizontalAlignment = NUIHorizontalAlignment_Stretch;
        item.margin = UIEdgeInsetsMake(10, 0, 10, 10);
    }

    {
        NUILabel *label  = [[NUILabel alloc] init];
        label.text = @"Age: 1 month";
        label.backgroundColor = [UIColor yellowColor];
        NUILayoutItem *item = [infoLayout addSubview:label];
        item.horizontalAlignment = NUIHorizontalAlignment_Stretch;
        item.margin = UIEdgeInsetsMake(10, 0, 10, 10);
    }

    {
        UIImageView *separator = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"separator"]];
        NUILayoutItem *item = [mainLayout addSubview:separator];
        item.margin = UIEdgeInsetsMake(30, 0, 0, 0);
        item.fixedSize = CGSizeMake(20, 20);
    }

    self.view = view;
}

@end
