//
//  AppDelegate.h
//  SoundShot
//
//  Created by Erik Werner on 31.05.25.
//

#import <Cocoa/Cocoa.h>
#import "SoundPadView.h"
#import "MIDIReceiver.h"
#import "AudioPlayer.h"
#import "DeckView.h"

// TODO: remove MIDIReceiverDelegate, AudioPlayerDelegate and rather use a view controller implementing these
@interface AppDelegate : NSObject <NSApplicationDelegate, MIDIReceiverDelegate, AudioPlayerDelegate>

@property (strong, nonatomic) NSWindow *window;
@property (strong, nonatomic) MIDIReceiver *midiReceiver;
@property (strong, nonatomic) AudioPlayer *audioPlayer;
@property (strong, nonatomic) DeckView *deckView;

@end


