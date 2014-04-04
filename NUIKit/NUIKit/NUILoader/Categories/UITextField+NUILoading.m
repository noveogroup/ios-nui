//
//  UITextField+NUILoading.m
//  NUILoader
//
//  Created by Ivan Masalov on 7/12/12.
//  Copyright (c) 2012 Noveo Group. All rights reserved.
//

#import "UITextField+NUILoading.h"

@implementation UITextField (NUILoading)

+ (NSDictionary *)nuiConstantsForAutocapitalizationType
{
    static NSDictionary *autocapitalizationTypeConstants = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        autocapitalizationTypeConstants = [[NSDictionary alloc] initWithObjectsAndKeys:
            [NSNumber numberWithInt:UITextAutocapitalizationTypeNone], @"None",
            [NSNumber numberWithInt:UITextAutocapitalizationTypeSentences], @"Sentences",
            [NSNumber numberWithInt:UITextAutocapitalizationTypeWords], @"Words",
            [NSNumber numberWithInt:UITextAutocapitalizationTypeAllCharacters], @"AllCharacters",
            nil];
    });
    return autocapitalizationTypeConstants;
}

+ (NSDictionary *)nuiConstantsForAutocorrectionType
{
    static NSDictionary *autocorrectionTypeConstants = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        autocorrectionTypeConstants = [[NSDictionary alloc] initWithObjectsAndKeys:
            [NSNumber numberWithInt:UITextAutocorrectionTypeNo], @"No",
            [NSNumber numberWithInt:UITextAutocorrectionTypeYes], @"Yes",
            [NSNumber numberWithInt:UITextAutocorrectionTypeDefault], @"Default",
            nil];
    });
    return autocorrectionTypeConstants;
}

+ (NSDictionary *)nuiConstantsForBorderStyle
{
    static NSDictionary *borderStyleConstants = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        borderStyleConstants = [[NSDictionary alloc] initWithObjectsAndKeys:
           [NSNumber numberWithInt:UITextBorderStyleNone], @"None",
           [NSNumber numberWithInt:UITextBorderStyleLine], @"Line",
           [NSNumber numberWithInt:UITextBorderStyleBezel], @"Bezel",
           [NSNumber numberWithInt:UITextBorderStyleRoundedRect], @"RoundedRect",
           nil];
    });
    return borderStyleConstants;
}

+ (NSDictionary *)nuiConstantsForClearButtonMode
{
    static NSDictionary *clearButtonModeConstants = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        clearButtonModeConstants = [[NSDictionary alloc] initWithObjectsAndKeys:
            [NSNumber numberWithInt:UITextFieldViewModeNever], @"Never",
            [NSNumber numberWithInt:UITextFieldViewModeWhileEditing], @"WhileEditing",
            [NSNumber numberWithInt:UITextFieldViewModeUnlessEditing], @"UnlessEditing",
            [NSNumber numberWithInt:UITextFieldViewModeAlways], @"Always",
            nil];
    });
    return clearButtonModeConstants;
}

+ (NSDictionary *)nuiConstantsForKeyboardType
{
    static NSDictionary *keyboardTypeConstants = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        keyboardTypeConstants = [[NSDictionary alloc] initWithObjectsAndKeys:
            [NSNumber numberWithInt:UIKeyboardTypeDefault], @"Default",
            [NSNumber numberWithInt:UIKeyboardTypeASCIICapable], @"ASCIICapable",
            [NSNumber numberWithInt:UIKeyboardTypeNumbersAndPunctuation], @"NumbersAndPunctuation",
            [NSNumber numberWithInt:UIKeyboardTypeURL], @"URL",
            [NSNumber numberWithInt:UIKeyboardTypeNumberPad], @"NumberPad",
            [NSNumber numberWithInt:UIKeyboardTypePhonePad], @"PhonePad",
            [NSNumber numberWithInt:UIKeyboardTypeNamePhonePad], @"NamePhonePad",
            [NSNumber numberWithInt:UIKeyboardTypeEmailAddress], @"EmailAddress",
#if __IPHONE_4_1 <= __IPHONE_OS_VERSION_MAX_ALLOWED
            [NSNumber numberWithInt:UIKeyboardTypeDecimalPad], @"DecimalPad",
#endif
#if __IPHONE_5_0 <= __IPHONE_OS_VERSION_MAX_ALLOWED
            [NSNumber numberWithInt:UIKeyboardTypeTwitter], @"Twitter",
#endif
            nil];
    });
    return keyboardTypeConstants;
}

- (void)setLocalizedText:(NSString *)text
{
    self.text = NSLocalizedString(text, nil);
}

- (void)setLocalizedPlaceholder:(NSString *)placeholder
{
    self.placeholder = NSLocalizedString(placeholder, nil);
}

@end