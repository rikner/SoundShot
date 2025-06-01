//
//  DeckView.m
//  SoundShot
//
//  Created by Erik Werner on 31.05.25.
//

#import "SoundPadView.h"
#import "DeckView.h"

@implementation DeckView

- (instancetype) initWithFrame:(NSRect)frame numberOfPads:(NSUInteger) numberOfPads {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupAudioPlayerViews:numberOfPads];
    }
    return self;
}

- (void)setupAudioPlayerViews:(NSUInteger)numberOfPads {
    CGFloat viewWidth = self.frame.size.width;
    CGFloat playerHeight = self.frame.size.height / numberOfPads;
    CGFloat currentY = 0;

    for (int i = 0; i < numberOfPads; i++) {
        NSRect playerFrame = NSMakeRect(0, currentY, viewWidth, playerHeight);
        SoundPadView *apv = [[SoundPadView alloc] initWithFrame:playerFrame];
        [self addSubview:apv];
        currentY += playerHeight;
    }
}

@end
