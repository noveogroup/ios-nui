//
//  NUILayoutConfig.m
//  NUIKit
//
//  Created by Ivan Masalov on 08/12/13.
//  Copyright (c) 2013 Noveo Group. All rights reserved.
//

#import "NUIMath.h"

#import <math.h>

float nuiRoundingScale = 1.f;

float nuiScaledFloorf(float value)
{
    return floorf(value * nuiRoundingScale) / nuiRoundingScale;
}

float nuiScaledCeilf(float value)
{
    return ceilf(value * nuiRoundingScale) / nuiRoundingScale;
}

float nuiScaledTruncf(float value)
{
    return truncf(value * nuiRoundingScale) / nuiRoundingScale;
}
