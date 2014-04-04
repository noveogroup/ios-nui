//
//  NUIAnalyzer.m
//  NUILoader
//
//  Created by Ivan Masalov on 7/3/12.
//  Copyright (c) 2012 Noveo Group. All rights reserved.
//

#import "NUIAnalyzer.h"
#import <objc/message.h>
#import <Foundation/Foundation.h>
#import "NUIStatement+BinaryOperator.h"
#import "NUIError.h"
#import "NUIData.h"

static NSString *Punctuation = @";,";

@interface NUIAnalyzer ()
{
    NSCharacterSet *punctuation_;

    NUIData *data_;
    NSUInteger position_;
    NSMutableArray *imports_;
    NSMutableDictionary *constants_;
    NSMutableDictionary *styles_;
    NSMutableDictionary *states_;
}

@property (nonatomic, strong) NUIError *lastError;

@end

@implementation NUIAnalyzer

@synthesize imports = imports_;
@synthesize constants = constants_;
@synthesize styles = styles_;
@synthesize states = states_;
@synthesize mainAssignment = mainAssignment_;
@synthesize lastError = lastError_;

- (id)initWithData:(NUIData *)data
{
    self = [super init];
    if (self) {
        punctuation_ = [NSCharacterSet characterSetWithCharactersInString:Punctuation];

        data_ = data;
        imports_ = [[NSMutableArray alloc] init];
        constants_ = [[NSMutableDictionary alloc] init];
        styles_ = [[NSMutableDictionary alloc] init];
        states_ = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)setLastError:(NUIError *)lastError
{
    NSAssert(lastError == nil || lastError_ == nil, @"Last error already set.");
    lastError_ = lastError;
}

- (BOOL)loadImports
{
    self.lastError = nil;
    while (YES) {
        if (![self skipSpacesAndPunctuation:&position_]) {
            return YES;
        }
        NSUInteger startPos = position_;
        NUIStatement *identifier = [self loadIdentifier:&startPos];
        if (!identifier) {
            return YES;
        }
        if (![identifier.value isEqualToString:@"import"]) {
            return YES;
        }
        position_ = startPos;
        if (![self skipSpacesAndPunctuation:&position_]) {
            self.lastError = [NUIError errorWithData:data_ position:position_
                message:@"Unexpected end of file."];
            return NO;
        }
        NUIStatement *str = [self loadString:&position_];
        if (!str) {
            if (!lastError_) {
                self.lastError = [NUIError errorWithData:data_ position:position_
                    message:@"Expecting \"."];
            }
            return NO;
        }
        [imports_ addObject:str.value];
    }
}

- (BOOL)loadContentFromMainFile:(BOOL)mainFile
{
    self.lastError = nil;

    while (YES) {
        if (![self skipSpacesAndPunctuation:&position_]) {
            return YES;
        }
        NUIStatement *identifier = [self loadIdentifier:&position_];
        if (!identifier) {
            self.lastError = [NUIError errorWithData:data_ position:position_
                message:@"Expecting indentifier."];
            return NO;
        }
        if (![self skipSpacesAndPunctuation:&position_]) {
            self.lastError = [NUIError errorWithData:data_ position:position_
                message:@"Unexpected end of file."];
            return NO;
        }
        if ([identifier.value isEqualToString:@"const"]) {
            NUIStatement *op = [self loadBinaryOperator:@"="
                lvalueLoader:@selector(loadSimpleIdentifier:) rvalueLoader:@selector(loadRValue:)
                position:&position_];
            if (!op) {
                return NO;
            }
            [constants_ setObject:[op rvalue] forKey:[op lvalue].value];
            continue;
        } else if ([identifier.value isEqualToString:@"style"]) {
            NUIStatement *op = [self loadBinaryOperator:@"="
                lvalueLoader:@selector(loadSimpleIdentifier:) rvalueLoader:@selector(loadObject:)
                position:&position_];
            if (!op) {
                return NO;
            }
            [styles_ setObject:[op rvalue] forKey:[op lvalue].value];
            continue;
        } else if ([identifier.value isEqualToString:@"state"]) {
            NUIStatement *op = [self loadBinaryOperator:@"="
                lvalueLoader:@selector(loadSimpleIdentifier:) rvalueLoader:@selector(loadObject:)
                position:&position_];
            if (!op) {
                return NO;
            }
            [states_ setObject:[op rvalue] forKey:[op lvalue].value];
            continue;
        } else if (mainFile) {
            if ([identifier.value isEqualToString:@"binding"]) {
                /*Statement *st = nil;
                NSString *oper = @"{";
                if ([data_.data compare:oper options:0 range:(NSRange){position, oper.length}] == NSOrderedSame) {
                    st = [self loadDictionary];
                } else {
                    st = [self loadAssignment];
                }*/
                continue;
            } else {
                position_ = identifier.range.location;
                mainAssignment_ = [self loadAssignment:&position_];
                return mainAssignment_ != nil;
            }
        }
        self.lastError = [NUIError errorWithData:data_ position:position_
            message:@"Expecting self."];
        return NO;
    }
}

- (BOOL)skipSpaces:(NSUInteger *)position
{
    while (data_.data.length > position_) {
        unichar c = [data_.data characterAtIndex:*position];
        if (![[NSCharacterSet whitespaceAndNewlineCharacterSet] characterIsMember:c]) {
            break;
        }
        ++(*position);
    }
    return *position != data_.data.length;
}

- (BOOL)skipSpacesAndPunctuation:(NSUInteger *)position
{
    while (data_.data.length > position_) {
        unichar c = [data_.data characterAtIndex:*position];
        if (![[NSCharacterSet whitespaceAndNewlineCharacterSet] characterIsMember:c]
                && ![punctuation_ characterIsMember:c]) {
            break;
        }
        ++(*position);
    }
    return *position != data_.data.length;
}

- (NUIStatement *)loadSimpleIdentifier:(NSUInteger *)position
{
    static NSRegularExpression *simpleIdentifierRegEx = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        simpleIdentifierRegEx = [[NSRegularExpression alloc] initWithPattern:@"[A-Za-z_][A-Za-z0-9_]*"
            options:0 error:nil];
    });

    NSRange range = [simpleIdentifierRegEx rangeOfFirstMatchInString:data_.data
        options:NSMatchingAnchored range:(NSRange){*position, data_.data.length - *position}];
    if (!range.length) {
        return nil;
    }
    NUIStatement *statement = [[NUIStatement alloc] initWithData:data_
        type:NUIStatementType_SimpleIdentifier];
    statement.range = NSMakeRange(*position, range.length);
    statement.value = [data_.data substringWithRange:statement.range];
    *position += range.length;
    return statement;
}

- (NUIStatement *)loadIdentifier:(NSUInteger *)position
{
    static NSRegularExpression *identifierRegEx = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        identifierRegEx = [[NSRegularExpression alloc] initWithPattern:@"[A-Za-z_][A-Za-z0-9_]*(\\.[A-Za-z_][A-Za-z0-9_]*)*"
            options:0 error:nil];
    });

    NSRange range = [identifierRegEx rangeOfFirstMatchInString:data_.data options:NSMatchingAnchored
        range:(NSRange){*position, data_.data.length - *position}];
    if (!range.length) {
        return nil;
    }
    NUIStatement *statement = [[NUIStatement alloc] initWithData:data_
        type:NUIStatementType_Identifier];
    statement.range = NSMakeRange(*position, range.length);
    statement.value = [data_.data substringWithRange:statement.range];
    *position += range.length;
    return statement;
}

- (NUIStatement *)loadSystemIdentifier:(NSUInteger *)position
{
    static NSRegularExpression *systemIdentifierRegEx = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        systemIdentifierRegEx = [[NSRegularExpression alloc] initWithPattern:@":[A-Za-z_][A-Za-z0-9_]*"
            options:0 error:nil];
    });

    NSRange range = [systemIdentifierRegEx rangeOfFirstMatchInString:data_.data
        options:NSMatchingAnchored range:(NSRange){*position, data_.data.length - *position}];
    if (!range.length) {
        return nil;
    }
    NUIStatement *statement = [[NUIStatement alloc] initWithData:data_
        type:NUIStatementType_SystemIdentifier];
    statement.range = NSMakeRange(*position, range.length);
    statement.value = [data_.data substringWithRange:statement.range];
    *position += range.length;
    return statement;
}

- (NUIStatement *)loadString:(NSUInteger *)position
{
    NSUInteger pos = *position;
    if ([data_.data characterAtIndex:pos] != '\"') {
        return nil;
    }
    ++pos;
    NSString *op = @"\"";
    NSString *op2 = @"\\\"";
    while (YES) {
        NSRange r = [data_.data rangeOfString:op options:0 range:(NSRange){pos, data_.data.length -
            pos}];
        if (r.length == 0) {
            self.lastError = [NUIError errorWithData:data_ position:*position
                message:@"Can not find enclosing \"."];
            return nil;
        }

        if (NSOrderedSame != [data_.data compare:op2 options:0 range:(NSRange){r.location -
            op2.length + r.length, r.length}]) {
            pos = r.location + r.length;
            NUIStatement *statement = [[NUIStatement alloc] initWithData:data_
                type:NUIStatementType_String];
            statement.range = NSMakeRange(*position, pos - *position);
            statement.value = [data_.data substringWithRange:(NSRange){*position + op.length, pos -
                *position - 2 * op.length}];
            *position = pos;
            return statement;
        }
        pos = r.location + r.length;
    }
}

- (NUIStatement *)loadSystemProperties:(NSUInteger *)position
{
    NSUInteger pos = *position;
    NSMutableDictionary *properties = [NSMutableDictionary dictionary];
    while (YES) {
        if (![self skipSpacesAndPunctuation:&pos]) {
            self.lastError = [NUIError errorWithData:data_ position:pos
                message:@"Unexpected end of file."];
            return nil;
        }
        NUIStatement *identifier = [self loadSystemIdentifier:&pos];
        if (!identifier) {
            break;
        }
        if (![self skipSpacesAndPunctuation:&pos]) {
            self.lastError = [NUIError errorWithData:data_ position:pos
                message:@"Unexpected end of file."];
            return nil;
        }
        NSString *op = @"=";
        if ([data_.data compare:op options:0 range:(NSRange){pos, op.length}] != NSOrderedSame) {
            return nil;
        }
        pos += op.length;
        if (![self skipSpacesAndPunctuation:&pos]) {
            self.lastError = [NUIError errorWithData:data_ position:pos
                message:@"Unexpected end of file."];
            return nil;
        }
        id rvalue = [self loadRValue:&pos];
        if (!rvalue) {
            return nil;
        }
        [properties setObject:rvalue forKey:identifier.value];
        continue;
    }
    NUIStatement *statement = [[NUIStatement alloc] initWithData:data_ type:
        NUIStatementType_ObjectSystemProperties];
    statement.range = NSMakeRange(*position, pos - *position);
    statement.value = properties;
    *position = pos;
    return statement;
}

- (NUIStatement *)loadProperties:(NSUInteger *)position
{
    NSUInteger pos = *position;
    NSMutableArray *properties = [NSMutableArray array];
    while (YES) {
        if (![self skipSpacesAndPunctuation:&pos]) {
            break;
        }
        NUIStatement *assignment = [self loadAssignment:&pos];
        if (!assignment) {
            if (self.lastError) {
                return nil;
            }
            break;
        }
        [properties addObject:assignment];
    }
    NUIStatement *statement = [[NUIStatement alloc] initWithData:data_
        type:NUIStatementType_ObjectProperties];
    statement.range = NSMakeRange(*position, pos - *position);
    statement.value = properties;
    *position = pos;
    return statement;
}

- (NUIStatement *)loadObject:(NSUInteger *)position
{
    NSUInteger pos = *position;
    NSString *op = @"{";
    if ([data_.data compare:op options:0 range:(NSRange){pos, op.length}] != NSOrderedSame) {
        return nil;
    }
    pos += op.length;
    NUIStatement *systemProperties = [self loadSystemProperties:&pos];
    if (!systemProperties) {
        return nil;
    }
    NUIStatement *properties = [self loadProperties:&pos];
    if (!properties) {
        return nil;
    }
    op = @"}";
    if (![self skipSpacesAndPunctuation:&pos] ||
        [data_.data compare:op options:0 range:(NSRange){pos, op.length}] != NSOrderedSame) {
        self.lastError = [NUIError errorWithData:data_ position:pos
            message:@"Expecting }."];
        return nil;
    }
    pos += op.length;
    NUIStatement *statement = [[NUIStatement alloc] initWithData:data_
        type:NUIStatementType_Object];
    statement.range = NSMakeRange(*position, pos - *position);
    statement.value = [NSArray arrayWithObjects:systemProperties, properties, nil];
    *position = pos;
    return statement;
}

- (NUIStatement *)loadArray:(NSUInteger *)position
{
    NSUInteger pos = *position;
    NSString *op = @"[";
    if (![data_.data compare:op options:0 range:(NSRange){pos, op.length}] == NSOrderedSame) {
        return nil;
    }
    pos += op.length;
    op = @"]";
    NSMutableArray *array = [[NSMutableArray alloc] init];
    while (YES) {
        if (![self skipSpacesAndPunctuation:&pos]) {
            self.lastError = [NUIError errorWithData:data_ position:pos
                message:@"Expecting ]."];
            return nil;
        }
        if ([data_.data compare:op options:0 range:(NSRange){pos, op.length}] == NSOrderedSame) {
            pos += op.length;
            NUIStatement *statement = [[NUIStatement alloc] initWithData:data_
                type:NUIStatementType_Array];
            statement.range = NSMakeRange(*position, pos - *position);
            statement.value = array;
            *position = pos;
            return statement;
        }
        id rvalue = [self loadRValue:&pos];
        if (!rvalue) {
            return nil;
        }
        [array addObject:rvalue];
    }
}

- (NUIStatement *)loadAssignment:(NSUInteger *)position
{
    NSUInteger pos = *position;
    NUIStatement *lvalue = [self loadIdentifier:&pos];
    if (!lvalue) {
        return nil;
    }
    if ([lvalue.value isEqual:@"self"]) {
        self.lastError = [NUIError errorWithStatement:lvalue message:
            @"'self' can not be used as an identifier."];
    }

    if (![self skipSpaces:&pos]) {
        self.lastError = [NUIError errorWithData:data_ position:pos
            message:@"Unexpected end of file."];
        return nil;
    }
    NSString *op = @"=";
    if ([data_.data compare:op options:0 range:(NSRange){pos, op.length}] == NSOrderedSame) {
        pos += op.length;
        if (![self skipSpaces:&pos]) {
            self.lastError = [NUIError errorWithData:data_ position:pos
                message:@"Unexpected end of file."];
            return nil;
        }
        id rvalue = [self loadRValue:&pos];
        if (!rvalue) {
            return nil;
        }
        NUIStatement *statement = [[NUIStatement alloc] initWithData:data_ type:
            NUIStatementType_AssignmentOperator];
        statement.range = NSMakeRange(*position, pos - *position);
        statement.value = [NSArray arrayWithObjects:lvalue, rvalue, nil];

        *position = pos;
        return statement;
    } else {
        op = @"<=";
        if ([data_.data compare:op options:0 range:(NSRange){pos, op.length}] == NSOrderedSame) {
            pos += op.length;
            if (![self skipSpaces:&pos]) {
                self.lastError = [NUIError errorWithData:data_ position:pos
                    message:@"Unexpected end of file."];
                return nil;
            }
            id rvalue = [self loadObject:&pos];
            if (!rvalue) {
                return nil;
            }
            NUIStatement *statement = [[NUIStatement alloc] initWithData:data_ type:
                NUIStatementType_ModificationOperator];
            statement.range = NSMakeRange(*position, pos - *position);
            statement.value = [NSArray arrayWithObjects:lvalue, rvalue, nil];

            *position = pos;
            return statement;
        }
    }
    self.lastError = [NUIError errorWithData:data_ position:pos
        message:@"Expecting = or <= operator."];
    return nil;
}

- (NUIStatement *)loadBinaryOperator:(NSString *)op lvalueLoader:(SEL)lvalueLoader
    rvalueLoader:(SEL)rvalueLoader position:(NSUInteger *)position
{
    NSUInteger pos = *position;
    id lvalue = objc_msgSend(self, lvalueLoader, &pos);
    if (!lvalue) {
        return nil;
    }
    if (![self skipSpaces:&pos]) {
        self.lastError = [NUIError errorWithData:data_ position:pos
            message:@"Unexpected end of file."];
        return nil;
    }
    if ([data_.data compare:op options:0 range:(NSRange){pos, op.length}] != NSOrderedSame) {
        return nil;
    }
    pos += op.length;
    if (![self skipSpaces:&pos]) {
        self.lastError = [NUIError errorWithData:data_ position:pos
            message:@"Unexpected end of file."];
        return nil;
    }
    id rvalue = objc_msgSend(self, rvalueLoader, &pos);
    if (!rvalue) {
        if (!self.lastError) {
            self.lastError = [NUIError errorWithData:data_ position:pos
                message:@"Unexpected end of file."];
        }
        return nil;
    }

    NUIStatement *statement = [[NUIStatement alloc] init];
    statement.range = NSMakeRange(*position, pos - *position);
    statement.value = [NSArray arrayWithObjects:lvalue, rvalue, nil];

    *position = pos;
    return statement;
}

- (NUIStatement *)loadNumericOperator:(NSUInteger *)position lvalue:(id)lvalue
{
    static NSDictionary *numericOperators = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        numericOperators = @{
            @"|" : [NSNumber numberWithInt:NUIStatementType_BitwiseOrOperator]
        };
    });


    NSUInteger pos  = *position;
    for (NSString *value in numericOperators) {
        if ([data_.data compare:value options:0 range:(NSRange){pos, value.length}]
            == NSOrderedSame) {
            pos += value.length;
            if (![self skipSpaces:&pos]) {
                return nil;
            }
            id rvalue = [self loadExpression:&pos];
            if (!rvalue) {
                return nil;
            }
            NUIStatement *statement = [[NUIStatement alloc] initWithData:data_
                type:[numericOperators[value] intValue]];
            statement.range = NSMakeRange(*position, pos - *position);
            statement.value = [NSArray arrayWithObjects:lvalue, rvalue, nil];

            *position = pos;
            return statement;
        }
    }
    return nil;
}

- (id)loadExpression:(NSUInteger *)position
{
    NSUInteger pos = *position;
    id res = [self loadNumber:&pos];
    if (!res) {
        res = [self loadIdentifier:&pos];
    }
    if (res) {
        if ([self skipSpaces:&pos]) {
            NUIStatement *op = [self loadNumericOperator:&pos lvalue:res];
            if (op) {
                res = op;
            }
        }
        *position = pos;
    }
    return res;
} 

- (id)loadRValue:(NSUInteger *)position
{
    NSUInteger pos = *position;
    id res = [self loadString:&pos];
    if (!res) {
        res = [self loadObject:&pos];
        if (!res && self.lastError) {
            return nil;
        }
    }
    if (!res) {
        res = [self loadArray:&pos];
    }
    if (!res) {
        res = [self loadExpression:&pos];
    }
    if (res) {
        *position = pos;
    } else {
        if (!lastError_) {
            self.lastError = [NUIError errorWithData:data_ position:*position
                message:@"Expecting a string, an object, an array or an expression."];
        }
    }
    return res;
}

- (NUIStatement *)loadNumber:(NSUInteger *)position
{
    static NSRegularExpression *numberRegEx = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        numberRegEx = [[NSRegularExpression alloc] initWithPattern:@"[-+]?[0-9]+(.[0-9]+)?"
            options:0 error:nil];
    });

    NSRange range = [numberRegEx rangeOfFirstMatchInString:data_.data options:NSMatchingAnchored
        range:(NSRange){*position, data_.data.length - *position}];
    if (!range.length) {
        return nil;
    }
    NUIStatement *statement = [[NUIStatement alloc] initWithData:data_
        type:NUIStatementType_Number];
    statement.range = NSMakeRange(*position, range.length);
    NSString *str = [data_.data substringWithRange:(NSRange){*position, range.length}];
    statement.value = [NSNumber numberWithDouble:[str doubleValue]];

    *position += range.length;
    return statement;
}

@end
