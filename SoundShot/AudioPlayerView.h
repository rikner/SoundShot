#import <Cocoa/Cocoa.h>
#import <AVFoundation/AVFoundation.h>

@interface AudioPlayerView : NSView <AVAudioPlayerDelegate>

@property (nonatomic, strong) AVAudioPlayer *audioPlayer;
@property (nonatomic, strong) NSButton *playButton;

- (instancetype)initWithFrame:(NSRect)frame soundURL:(NSURL *)soundURL; // New initializer
- (void)toggleAudioPlayback;

@end
