//
//  NUIError.h
//  NUIKit
//
//  Created by Ivan Masalov on 8/10/12.
//  Copyright (c) 2012 Noveo Group. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef struct NUIPositionInLine {
    NSUInteger line;
    NSUInteger position;
} NUIPositionInLine;

@interface NUIData : NSObject

@property (nonatomic, copy) NSString *fileName;
@property (nonatomic, copy) NSString *data;

- (NUIPositionInLine)positionInLineFromPosition:(NSUInteger)position;

@end