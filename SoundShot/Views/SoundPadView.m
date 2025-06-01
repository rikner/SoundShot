#import <Cocoa/Cocoa.h>
#import <QuartzCore/QuartzCore.h>

#import "SoundPadView.h"
#import "NSColor+AppColors.h"

@implementation SoundPadView

- (instancetype)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
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


- (void)setupPlayButton {
    CGFloat height = 60;
    CGFloat width = 120;
    CGFloat x = self.frame.size.width / 2 - width / 2;
    CGFloat y = self.frame.size.height / 2 - height / 2;
    self.playButton = [[NSButton alloc] initWithFrame:NSMakeRect(x, y, width, height)];
    self.playButton.title = @"Play";
    self.playButton.target = self;
//    self.playButton.action = @selector(toggleAudioPlayback);
//    [self addSubview:self.playButton];
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

 - (void) setIsPlaying: (BOOL)isPlaying {
    if (isPlaying == TRUE) {
        self.playButton.title = @"Stop";
        [self animateBackgroundColorTo: self.playingBackgroundColor];
    } else {
        self.playButton.title = @"Play";
        [self animateBackgroundColorTo: self.idleBackgroundColor];
    }
}

@end

