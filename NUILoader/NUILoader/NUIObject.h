//
//  NUIObject.h
//  NUILoader
//
//  Created by Ivan Masalov on 7/3/12.
//  Copyright (c) 2012 eko team. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NUIObject : NSObject

@property (nonatomic, copy) NSString *type;
@property (nonatomic, readonly) NSMutableDictionary *systemProperties;
@property (nonatomic, readonly) NSMutableArray *properties;

- (id)property:(NSString *)property ofClass:(Class)class;

@end
