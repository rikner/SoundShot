//
//  MainViewController.m
//  SoundShot
//
//  Created by Erik Werner on 02.06.25.
//

#import "MainViewController.h"
#import <dispatch/dispatch.h>

@implementation MainViewController

- (instancetype)initWithFrame:(NSRect)frame {
    self = [super init];
    if (self) {
        self.view = [[NSView alloc] initWithFrame:frame];
        
        self.deckView = [[DeckView alloc] initWithFrame:frame];
        [self.view addSubview:self.deckView];
        
        self.samplePlayer = [[SamplePlayer alloc] init];
        self.samplePlayer.delegate = self;
        
        self.midiReceiver = [[MIDIReceiver alloc] init];
        self.midiReceiver.delegate = self;
        [self.midiReceiver startListening];
    }
    return self;
}

#pragma mark - SamplePlayerDelegate methods

- (void)samplePlayer:(SamplePlayer *)player didStartPlayingSample:(SampleType)sampleType {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.deckView update:sampleType isPlaying:YES];
    });
}

- (void)samplePlayer:(SamplePlayer *)player didFinishPlayingSample:(SampleType)sampleType {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.deckView update:sampleType isPlaying:NO];
    });
}

#pragma mark - MIDIReceiverDelegate methods

- (void)midiReceiver:(MIDIReceiver *)receiver didReceiveNoteOn:(Byte)note velocity:(Byte)velocity channel:(Byte)channel {
    if (note < 36 || note > 71) {
        return;
    }

    int noteInOctave = note % 12;
    SampleType sampleToPlay = -1;

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

@end
