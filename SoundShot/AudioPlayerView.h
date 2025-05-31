#import <Cocoa/Cocoa.h>
#import <AVFoundation/AVFoundation.h>

@interface AudioPlayerView : NSView <AVAudioPlayerDelegate>

@property (nonatomic, strong) AVAudioPlayer *audioPlayer;
@property (nonatomic, strong) NSButton *playButton;
@property (nonatomic, strong) NSColor *playingBackgroundColor;
@property (nonatomic, strong) NSColor *idleBackgroundColor;

- (instancetype)initWithFrame:(NSRect)frame soundURL:(NSURL *)soundURL; // New initializer
- (void)toggleAudioPlayback;

@end
