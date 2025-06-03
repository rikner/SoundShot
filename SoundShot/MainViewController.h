//
//  MainViewController.h
//  SoundShot
//
//  Created by Erik Werner on 02.06.25.
//

#import <Cocoa/Cocoa.h>
#import "MIDIReceiver.h"
#import "SamplePlayer.h"
#import "DeckView.h"

@interface MainViewController : NSViewController <MIDIReceiverDelegate, SamplePlayerDelegate, DeckViewDelegate>

@property (strong, nonatomic) MIDIReceiver *midiReceiver;
@property (strong, nonatomic) SamplePlayer *samplePlayer;
@property (strong, nonatomic) DeckView *deckView;

- (instancetype)initWithFrame:(NSRect)frame;

@end
