//
//  DeckView.h
//  SoundShot
//
//  Created by Erik Werner on 31.05.25.
//

#import <Cocoa/Cocoa.h>
#import "AudioPlayer.h"

@interface DeckView : NSView
- (void) update:(SoundSampleType)sampleType isPlaying:(BOOL) isPlaying;
@end
