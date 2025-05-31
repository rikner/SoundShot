//
//  AudioPlayer.h
//  SoundShot
//
//  Created by Erik Werner on 31.05.25.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h> // Ensure AVFoundation is imported

NS_ASSUME_NONNULL_BEGIN

// Enum to identify the different sound samples
typedef NS_ENUM(NSInteger, SoundSampleType) {
    SoundSampleTypeClap,
    SoundSampleTypeFlyingNoise,
    SoundSampleTypeGameOver,
    SoundSampleTypeHiHatClosed,
    SoundSampleTypeHiHatOpen,
    SoundSampleTypeKick,
    SoundSampleTypeSnare,
    SoundSampleTypeCount // Keep this last for count if needed
};

@interface AudioPlayer : NSObject

- (instancetype)init;

/// Plays the specified sound sample
/// @param sampleType The type of sound sample to play.
- (void)playSample:(SoundSampleType)sampleType;

@end

NS_ASSUME_NONNULL_END
