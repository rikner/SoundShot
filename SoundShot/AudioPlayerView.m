#import <Cocoa/Cocoa.h>
#import <QuartzCore/QuartzCore.h>
#import <AVFoundation/AVFoundation.h>

#import "AudioPlayerView.h"
#import "NSColor+AppColors.h"

@implementation AudioPlayerView

- (instancetype)initWithFrame:(NSRect)frame soundURL:(NSURL *)soundURL {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupAudioPlayerWithURL:soundURL];
        [self setupPlayButton];
    }
    self.playingBackgroundColor = [NSColor appVermilionColor];
    self.idleBackgroundColor = [NSColor appGunmetalColor];

    self.wantsLayer = YES;
    self.layer.backgroundColor = self.idleBackgroundColor.CGColor;
    
    self.layer.borderColor = [NSColor appLavenderWebColor].CGColor;
    self.layer.borderWidth = 2.0;
    
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
    CGFloat height = 60;
    CGFloat width = 120;
    CGFloat x = self.frame.size.width / 2 - width / 2;
    CGFloat y = self.frame.size.height / 2 - height / 2;
    self.playButton = [[NSButton alloc] initWithFrame:NSMakeRect(x, y, width, height)];
    self.playButton.title = @"Play";
    self.playButton.target = self;
    self.playButton.action = @selector(toggleAudioPlayback);
    [self addSubview:self.playButton];
}

- (void)toggleAudioPlayback {
    if (self.audioPlayer.isPlaying) {
        [self.audioPlayer stop];
        self.playButton.title = @"Play";
        [self animateBackgroundColorTo:self.idleBackgroundColor];
    } else {
        [self.audioPlayer play];
        self.playButton.title = @"Stop";
        [self animateBackgroundColorTo:self.playingBackgroundColor];
    }
}

- (void) animateBackgroundColorTo:(NSColor *)toColor {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"backgroundColor"];
    animation.duration = 0.15;
    animation.fromValue = (id)self.layer.backgroundColor;
    animation.toValue = toColor;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    self.layer.backgroundColor = toColor.CGColor; // ensure that color stays after animation completes
    [self.layer addAnimation:animation forKey:@"backgroundColorAnimation"];
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    self.playButton.title = @"Play";
    [self animateBackgroundColorTo:self.idleBackgroundColor];
}

@end

