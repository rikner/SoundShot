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

+ (NSString *)filenameForType:(SampleType)type {
    switch (type) {
        case SoundSampleTypeKick: return @"kick.mp3";
        case SoundSampleTypeClap: return @"clap.mp3";
        case SoundSampleTypeSnare: return @"snare.mp3";
        case SoundSampleTypeHiHatClosed: return @"hihat_closed.mp3";
        case SoundSampleTypeHiHatOpen: return @"hihat_open.mp3";
        case SoundSampleTypeFlyingNoise: return @"flying_noise.mp3";
        case SoundSampleTypeGameOver: return @"game_over.mp3";
        default: return nil;
    }
}

@end
