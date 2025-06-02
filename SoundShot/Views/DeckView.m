//
//  DeckView.m
//  SoundShot
//
//  Created by Erik Werner on 31.05.25.
//

#import "SoundPadView.h"
#import "DeckView.h"
#import "AudioPlayer.h"

@interface DeckView ()
@property (nonatomic, strong) NSMutableDictionary<NSNumber *, SoundPadView *> *padViews;
@end

@implementation DeckView

- (instancetype)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _padViews = [NSMutableDictionary dictionary];
        [self setupPadViews];
    }
    return self;
}

- (void)setupPadViews {
    CGFloat viewWidth = self.frame.size.width;
    CGFloat playerHeight = self.frame.size.height / SoundSampleTypeCount;
    CGFloat currentY = 0;
    
    for (int i = 0; i < SoundSampleTypeCount; ++i) {
        NSRect playerFrame = NSMakeRect(0, currentY, viewWidth, playerHeight);
        SoundPadView *spv = [[SoundPadView alloc] initWithFrame:playerFrame];
        [self addSubview:spv];
        currentY += playerHeight;
        self.padViews[@(i)] = spv;
    }
}

- (void)update:(SoundSampleType)sampleType isPlaying:(BOOL)isPlaying {
    [self.padViews[@(sampleType)] setIsPlaying:isPlaying];
}

@end
