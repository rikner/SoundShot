//
//  SamplePlayer.h
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

@class SamplePlayer;
@protocol SamplePlayerDelegate <NSObject>
@optional
- (void)samplePlayer:(SamplePlayer *)player didStartPlayingSample:(SoundSampleType)sampleType;
- (void)samplePlayer:(SamplePlayer *)player didFinishPlayingSample:(SoundSampleType)sampleType;
@end

@interface SamplePlayer : NSObject

@property (nonatomic, weak, nullable) id<SamplePlayerDelegate> delegate;
- (instancetype)init;
- (void)play:(SoundSampleType)sampleType;

@end




NS_ASSUME_NONNULL_END
