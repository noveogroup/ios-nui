//
//  CellLayoutViewController.m
//  NUIDemo
//
//  Created by Ivan Masalov on 4/4/14.
//  Copyright (c) 2012 Noveo Group. All rights reserved.
//

#import "CellLayoutViewController.h"

#import "NUIKit/NUILayouts.h"

@implementation CellLayoutViewController

- (UIRectEdge)edgesForExtendedLayout
{
    return UIRectEdgeNone;
}

- (void)loadView
{
    NUILayoutView *view = [[NUILayoutView alloc] init];
    view.backgroundColor = [UIColor whiteColor];
    NUIVerticalCellLayout *mainLayout = [[NUIVerticalCellLayout alloc] initWithCells:@[@"10", @"1*",
        @"auto", @"1*", @"10"]];
    mainLayout.insertPosition = 1;
    view.layout = mainLayout;

    {
        UIImageView *separator = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"separator"]];
        NUICellLayoutItem *item = [mainLayout addSubview:separator];
        item.fixedSize = CGSizeMake(20, 20);
    }

    NUIHorizontalCellLayout *subLayout = [[NUIHorizontalCellLayout alloc] init];
    NUIGridLength *length1 = [[NUIGridLength alloc] initWithString:@"1*"];
    NUIGridLength *length2 = [[NUIGridLength alloc] initWithValue:1 type:NUIGridLengthType_Auto];
    NUIGridLength *length3 = [[NUIGridLength alloc] initWithValue:1 type:NUIGridLengthType_Star];
    subLayout.cells = @[length1, length2, length3];
    {
        NUICellLayoutItem *item= [mainLayout addSubview:subLayout];
        item.horizontalAlignment = NUIHorizontalAlignment_Stretch;
    }

    {
        NUILabel *label  = [[NUILabel alloc] init];
        label.text = @"Team #1";
        label.backgroundColor = [UIColor greenColor];
        NUICellLayoutItem *item = [subLayout addSubview:label];
        item.horizontalAlignment = NUIHorizontalAlignment_Right;
        item.cellRange = NSMakeRange(0, 1);
    }

    {
        NUILabel *label  = [[NUILabel alloc] init];
        label.text = @"Team #2";
        label.backgroundColor = [UIColor greenColor];
        NUICellLayoutItem *item = [subLayout addSubview:label];
        item.horizontalAlignment = NUIHorizontalAlignment_Left;
        item.cellRange = NSMakeRange(2, 1);
    }

    {
        NUILabel *label  = [[NUILabel alloc] init];
        label.text = @"vs";
        label.backgroundColor = [UIColor yellowColor];
        NUICellLayoutItem *item = [subLayout addSubview:label];
        item.horizontalAlignment = NUIHorizontalAlignment_Center;
        item.margin = UIEdgeInsetsMake(10, 25, 10, 25);
        item.cellRange = NSMakeRange(1, 1);
    }

    {
        UIImageView *separator = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"separator"]];
        NUICellLayoutItem *item = [mainLayout addSubview:separator];
        item.fixedSize = CGSizeMake(20, 20);
    }

    self.view = view;
}

@end
