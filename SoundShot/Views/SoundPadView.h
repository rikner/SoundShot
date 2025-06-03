#import <Cocoa/Cocoa.h>

@class SoundPadView;
@protocol SoundPadViewDelegate <NSObject>
- (void)soundPadViewWasClicked:(SoundPadView *)soundPadView;
@end


@interface SoundPadView : NSView
@property (nonatomic, weak) id<SoundPadViewDelegate> delegate;
- (instancetype)initWithFrame:(NSRect)frame label:(NSString*)label;
- (void)setIsPlaying:(BOOL)isPlaying;

@end
