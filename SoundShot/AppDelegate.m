//
//  AppDelegate.m
//  SoundShot
//
//  Created by Erik Werner on 31.05.25.
//

#import "AppDelegate.h"
#import "DeckView.h"
#import "MIDIReceiver.h"
#import <dispatch/dispatch.h>

@interface AppDelegate ()
@property (strong, nonatomic) DeckView *deckView;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    NSRect contentRect = NSMakeRect(0, 0, 800, 800);
    NSWindowStyleMask mask = NSWindowStyleMaskTitled | NSWindowStyleMaskClosable/* | NSWindowStyleMaskResizable*/;
    self.window = [[NSWindow alloc] initWithContentRect:contentRect
                                              styleMask:mask
                                                backing:NSBackingStoreBuffered
                                                  defer:NO];
    
    [self.window setTitle:@"SoundShot"];
    
    self.deckView = [[DeckView alloc] initWithFrame:contentRect];
    [self.window.contentView addSubview:self.deckView];

    self.samplePlayer = [[SamplePlayer alloc] init];
    self.samplePlayer.delegate = self;
    
    self.midiReceiver = [[MIDIReceiver alloc] init];
    self.midiReceiver.delegate = self;
    [self.midiReceiver startListening];

    [self.window makeKeyAndOrderFront:nil];
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

- (void)samplePlayer:(SamplePlayer *)player didStartPlayingSample:(SoundSampleType)sampleType {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.deckView update:sampleType isPlaying: YES];
    });
}

- (void)samplePlayer:(SamplePlayer *)player didFinishPlayingSample:(SoundSampleType)sampleType {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.deckView update:sampleType isPlaying: NO];
    });
}

- (void)midiReceiver:(MIDIReceiver *)receiver didReceiveNoteOn:(Byte)note velocity:(Byte)velocity channel:(Byte)channel {
    if (note < 36 || note > 71) {
        return;
    }

int noteInOctave = note % 12;
    SoundSampleType sampleToPlay = -1;

    switch (noteInOctave) {
        case 0:  // C
            sampleToPlay = SoundSampleTypeKick;
            break;
        case 2:  // D
            sampleToPlay = SoundSampleTypeClap;
            break;
        case 4:  // E
            sampleToPlay = SoundSampleTypeSnare;
            break;
        case 5:  // F
            sampleToPlay = SoundSampleTypeHiHatClosed;
            break;
        case 7:  // G
            sampleToPlay = SoundSampleTypeHiHatOpen;
            break;
        case 9:  // A
            sampleToPlay = SoundSampleTypeFlyingNoise;
            break;
        case 11: // B
            sampleToPlay = SoundSampleTypeGameOver;
            break;
        default:
            return;
    }

    if (sampleToPlay >= 0 && sampleToPlay < SoundSampleTypeCount) {
        [self.samplePlayer play:sampleToPlay];
    }
}


- (BOOL)applicationSupportsSecureRestorableState:(NSApplication *)app {
    return YES;
}


@end
