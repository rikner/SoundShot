//
//  AudioPlayer.h
//  SoundShot
//
//  Created by Erik Werner on 31.05.25.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

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

// TODO: rename to SamplePlayer
@class AudioPlayer; // Forward declaration

@protocol AudioPlayerDelegate <NSObject>
@optional
- (void)audioPlayer:(AudioPlayer *)player didStartPlayingSample:(SoundSampleType)sampleType;
- (void)audioPlayer:(AudioPlayer *)player didFinishPlayingSample:(SoundSampleType)sampleType;
@end

@interface AudioPlayer : NSObject

@property (nonatomic, weak, nullable) id<AudioPlayerDelegate> delegate;
- (instancetype)init;
- (void)playSample:(SoundSampleType)sampleType;

@end

NS_ASSUME_NONNULL_END
