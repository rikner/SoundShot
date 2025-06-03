//
//  SamplePlayer.h
//  SoundShot
//
//  Created by Erik Werner on 31.05.25.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "SampleType.h"

NS_ASSUME_NONNULL_BEGIN


@class SamplePlayer;
@protocol SamplePlayerDelegate <NSObject>

@optional
- (void)samplePlayer:(SamplePlayer *)player didStartPlayingSample:(SampleType)sampleType;
- (void)samplePlayer:(SamplePlayer *)player didFinishPlayingSample:(SampleType)sampleType;

@end


@interface SamplePlayer : NSObject

@property (nonatomic, weak, nullable) id<SamplePlayerDelegate> delegate;
- (instancetype)init;
- (void)play:(SampleType)sampleType;

@end



NS_ASSUME_NONNULL_END
