//
//  MasterViewController.m
//  NUIDemo
//
//  Created by Ivan Masalov on 7/16/12.
//  Copyright (c) 2012 Noveo Group. All rights reserved.
//

#import "MasterViewController.h"

@interface MasterViewController ()

@property (nonatomic, retain) NSArray *vcs;


@end

@implementation MasterViewController

@synthesize vcs = vcs_;

- (id)init
{
    self = [super init];
    if (self) {
        self.title = NSLocalizedString(@"Master", @"Master");
        NSString *path = [[NSBundle mainBundle] pathForResource:@"ViewControllers" ofType:@"plist"];
        self.vcs = [[NSDictionary dictionaryWithContentsOfFile:path] objectForKey:@"vcs"];
    }
    return self;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return vcs_.count;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }

    cell.textLabel.text = [[vcs_ objectAtIndex:indexPath.row] objectForKey:@"title"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIViewController *vc
        = [[NSClassFromString([[vcs_ objectAtIndex:indexPath.row] objectForKey:@"class"]) alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
