//
//  SampleType.h
//  SoundShot
//
//  Created by Erik Werner on 03.06.25.
//

#import <Foundation/Foundation.h>

// Enum to identify the different sound samples
typedef NS_ENUM(NSInteger, SampleType) {
    SoundSampleTypeClap,
    SoundSampleTypeFlyingNoise,
    SoundSampleTypeGameOver,
    SoundSampleTypeHiHatClosed,
    SoundSampleTypeHiHatOpen,
    SoundSampleTypeKick,
    SoundSampleTypeSnare,
    SoundSampleTypeCount // Keep this last for count if needed
};


@interface SampleTypeUtils : NSObject

+ (NSString *)descriptionForType:(SampleType)type;

@end
