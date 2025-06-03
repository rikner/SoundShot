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
    
    // Draw background
    [_currentBackgroundColor set];
    NSRectFill(self.bounds);
    
    // Draw border
    [[NSColor appLavenderWebColor] set];
    NSFrameRect(NSInsetRect(self.bounds, 1.0, 1.0));
    
    // Draw the label if available
    if (_label && ![_label isEqualToString:@""]) {
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setAlignment:NSTextAlignmentCenter];
        
        NSDictionary *attributes = @{
            NSFontAttributeName: [NSFont systemFontOfSize:12],
            NSForegroundColorAttributeName: [NSColor appBlueMunsellColor],
            NSParagraphStyleAttributeName: paragraphStyle
        };
        
        // Calculate text position to center it
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
        
        // Directly update the background color
        _currentBackgroundColor = isPlaying ? self.playingBackgroundColor : self.idleBackgroundColor;
        
        // Schedule redraw
        [self setNeedsDisplay:YES];
        
        // You can add a simple animation using NSAnimationContext if desired
        [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
            context.duration = 0.1;
            [self.animator setAlphaValue:0.8];
            [self.animator setAlphaValue:1.0];
        }];
    }
}

@end
