#import <Cocoa/Cocoa.h>

@interface SoundPadView : NSView

- (instancetype)initWithFrame:(NSRect)frame label:(NSString*)label;
- (void)setIsPlaying:(BOOL)isPlaying;

@end
