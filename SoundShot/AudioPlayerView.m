#import <Cocoa/Cocoa.h>
#import <AVFoundation/AVFoundation.h>
#import "AudioPlayerView.h"

@implementation AudioPlayerView

- (instancetype)initWithFrame:(NSRect)frame soundURL:(NSURL *)soundURL {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupAudioPlayerWithURL:soundURL];
        [self setupPlayButton];
    }
    return self;
}

- (void)setupAudioPlayerWithURL:(NSURL *)soundURL {
    NSError *error;
    if (soundURL) {
        self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:soundURL error:&error];
        self.audioPlayer.delegate = self; // Set delegate
        if (error) {
            NSLog(@"Error loading audio: %@ from URL: %@", error.localizedDescription, soundURL);
        }
    } else {
        NSLog(@"Error: soundURL is nil.");
    }
}
- (void)setupPlayButton {
    self.playButton = [[NSButton alloc] initWithFrame:NSMakeRect(0, 0, 100, 40)];
    self.playButton.title = @"Play";
    self.playButton.target = self;
    self.playButton.action = @selector(toggleAudioPlayback);
    [self addSubview:self.playButton];
}

- (void)toggleAudioPlayback {
    if (self.audioPlayer.isPlaying) {
        [self.audioPlayer stop];
        self.playButton.title = @"Play";
    } else {
        [self.audioPlayer play];
        self.playButton.title = @"Stop";
    }
}

// Delegate method to reset button when audio finishes
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    self.playButton.title = @"Play";
}

@end

