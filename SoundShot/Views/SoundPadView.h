#import <Cocoa/Cocoa.h>

@interface SoundPadView : NSView

// TODO: no need to be public; should probably be static as well
@property (nonatomic, strong) NSColor *playingBackgroundColor;
@property (nonatomic, strong) NSColor *idleBackgroundColor;

- (void)setIsPlaying: (BOOL)isPlaying;

@end
