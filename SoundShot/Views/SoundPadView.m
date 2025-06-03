#import <Cocoa/Cocoa.h>
#import "SoundPadView.h"
#import "NSColor+AppColors.h"

@interface SoundPadView ()
@property (nonatomic, strong) NSColor *playingBackgroundColor;
@property (nonatomic, strong) NSColor *idleBackgroundColor;
@end

@implementation SoundPadView {
    NSString *_label;
    BOOL _isPlaying;
    NSColor *_currentBackgroundColor;
}

- (instancetype)initWithFrame:(NSRect)frame label:(NSString*)label {
    self = [super initWithFrame:frame];
    if (self) {
        self.playingBackgroundColor = [NSColor appVermilionColor];
        self.idleBackgroundColor = [NSColor appGunmetalColor];
        _label = label;
        _isPlaying = NO;
        _currentBackgroundColor = self.idleBackgroundColor;
    }
    return self;
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    [_currentBackgroundColor set];
    NSRectFill(self.bounds);
    
    [[NSColor appLavenderWebColor] set];
    NSFrameRect(NSInsetRect(self.bounds, 1.0, 1.0));
    
    if (_label && ![_label isEqualToString:@""]) {
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setAlignment:NSTextAlignmentCenter];
        
        NSDictionary *attributes = @{
            NSFontAttributeName: [NSFont monospacedSystemFontOfSize:12 weight:NSFontWeightBold],
            NSForegroundColorAttributeName: [NSColor appLavenderWebColor],
            NSParagraphStyleAttributeName: paragraphStyle
        };
        
        NSSize textSize = [_label sizeWithAttributes:attributes];
        NSPoint textPoint = NSMakePoint(
            (self.bounds.size.width - textSize.width) / 2,
            (self.bounds.size.height - textSize.height) / 2
        );
        
        [_label drawAtPoint:textPoint withAttributes:attributes];
    }
}

- (void)setIsPlaying:(BOOL)isPlaying {
    if (_isPlaying != isPlaying) {
        _isPlaying = isPlaying;
        
        _currentBackgroundColor = isPlaying ? self.playingBackgroundColor : self.idleBackgroundColor;
        
        [self setNeedsDisplay:YES];
        
        [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
            context.duration = 0.1;
            [self.animator setAlphaValue:0.8];
            [self.animator setAlphaValue:1.0];
        }];
    }
}

- (void)mouseDown:(NSEvent *)event {
    // Visual feedback when clicked
    _currentBackgroundColor = [NSColor appVermilionColor];
    [self setNeedsDisplay:YES];
    
    // Notify delegate
    if ([self.delegate respondsToSelector:@selector(soundPadViewWasClicked:)]) {
        [self.delegate soundPadViewWasClicked:self];
    }
}

- (void)mouseUp:(NSEvent *)event {
    // Reset color if not currently playing
    if (!_isPlaying) {
        _currentBackgroundColor = self.idleBackgroundColor;
        [self setNeedsDisplay:YES];
    }
}

@end
