//
//  SampleType.h
//  SoundShot
//
//  Created by Erik Werner on 03.06.25.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, SampleType) {
    SoundSampleTypeKick,
    SoundSampleTypeClap,
    SoundSampleTypeSnare,
    SoundSampleTypeHiHatClosed,
    SoundSampleTypeHiHatOpen,
    SoundSampleTypeFlyingNoise,
    SoundSampleTypeGameOver,
    SoundSampleTypeCount
};

@interface SampleTypeUtils : NSObject

+ (NSString *)descriptionForType:(SampleType)type;
+ (NSString *)filenameForType:(SampleType)type;

@end
