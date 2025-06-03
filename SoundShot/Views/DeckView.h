//
//  DeckView.h
//  SoundShot
//
//  Created by Erik Werner on 31.05.25.
//

#import <Cocoa/Cocoa.h>
#import "SamplePlayer.h"
#import "SoundPadView.h"

@protocol DeckViewDelegate;

@interface DeckView : NSView <SoundPadViewDelegate>

@property (nonatomic, weak) id<DeckViewDelegate> delegate;
- (void) update:(SampleType)sampleType isPlaying:(BOOL) isPlaying;

@end

@protocol DeckViewDelegate <NSObject>
- (void)deckView:(DeckView *)deckView didClickPadForSampleType:(SampleType)sampleType;
@end
