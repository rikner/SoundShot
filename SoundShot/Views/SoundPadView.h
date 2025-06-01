#import <Cocoa/Cocoa.h>

@interface SoundPadView : NSView

@property (nonatomic, strong) NSButton *playButton;
@property (nonatomic, strong) NSColor *playingBackgroundColor;
@property (nonatomic, strong) NSColor *idleBackgroundColor;

- (void)setIsPlaying: (BOOL)isPlaying;

@end
