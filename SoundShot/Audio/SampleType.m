//
//  SampleType.m
//  SoundShot
//
//  Created by Erik Werner on 03.06.25.
//

#import "SampleType.h"

@implementation SampleTypeUtils

+ (NSString *)descriptionForType:(SampleType)type {
    switch (type) {
        case SoundSampleTypeKick:
            return @"Kick";
        case SoundSampleTypeSnare:
            return @"Snare";
        case SoundSampleTypeHiHatOpen:
            return @"Hi-Hat open";
        case SoundSampleTypeHiHatClosed:
            return @"Hi-Hat closed";
        case SoundSampleTypeClap:
            return @"Clap";
        case SoundSampleTypeFlyingNoise:
            return @"Flying Noise";
        case SoundSampleTypeGameOver:
            return @"Game Over";
        default:
            return @"Unknown";
    }
}

@end
