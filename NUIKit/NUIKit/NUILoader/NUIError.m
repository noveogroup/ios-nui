//
//  NUIError.m
//  NUIKit
//
//  Created by Ivan Masalov on 8/9/12.
//  Copyright (c) 2012 Noveo Group. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NUIError.h"
#import "NUIData.h"
#import "NUIStatement.h"

@implementation NUIError

@synthesize data = data_;
@synthesize position = position_;
@synthesize message = message_;

- (id)initWithData:(NUIData *)data position:(NSUInteger)position message:(NSString *)message
{
    self = [super init];
    if (self) {
        self.data = data;
        self.position = position;
        self.message = message;
    }
    return self;
}

- (id)initWithStatement:(NUIStatement *)statement message:(NSString *)message
{
    return [self initWithData:statement.data position:statement.range.location message:message];
}

+ (id)errorWithData:(NUIData *)data position:(NSUInteger)position message:(NSString *)message
{
    return [[NUIError alloc] initWithData:data position:position message:message];
}

+ (id)errorWithStatement:(NUIStatement *)statement message:(NSString *)message
{
    return [[NUIError alloc] initWithStatement:statement message:message];
}

@end
