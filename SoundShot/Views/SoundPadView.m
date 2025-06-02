#import <Cocoa/Cocoa.h>
#import <QuartzCore/QuartzCore.h>

#import "SoundPadView.h"
#import "NSColor+AppColors.h"

@implementation SoundPadView

- (instancetype)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];

    self.playingBackgroundColor = [NSColor appVermilionColor];
    self.idleBackgroundColor = [NSColor appGunmetalColor];

    self.wantsLayer = YES;
    self.layer.backgroundColor = self.idleBackgroundColor.CGColor;
    
    self.layer.borderColor = [NSColor appLavenderWebColor].CGColor;
    self.layer.borderWidth = 2.0;
    
    return self;
}

- (void) animateBackgroundColorTo:(NSColor *)toColor {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"backgroundColor"];
    animation.duration = 0.15;
    animation.fromValue = (id)self.layer.backgroundColor;
    animation.toValue = toColor;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    self.layer.backgroundColor = toColor.CGColor;
    [self.layer addAnimation:animation forKey:@"backgroundColorAnimation"];
}

 - (void) setIsPlaying: (BOOL)isPlaying {
    if (isPlaying == TRUE) {
        [self animateBackgroundColorTo: self.playingBackgroundColor];
    } else {
        [self animateBackgroundColorTo: self.idleBackgroundColor];
    }
}

@end

