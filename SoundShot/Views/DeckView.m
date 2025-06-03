//
//  DeckView.m
//  SoundShot
//
//  Created by Erik Werner on 31.05.25.
//

#import "SoundPadView.h"
#import "DeckView.h"
#import "SamplePlayer.h"

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
    if (SoundSampleTypeCount == 0) {
        return;
    }

    NSUInteger numberOfColumns = 3;
    NSUInteger numberOfRows = (SoundSampleTypeCount + numberOfColumns - 1) / numberOfColumns;

    CGFloat totalWidth = self.frame.size.width;
    CGFloat totalHeight = self.frame.size.height;

    // gap between pads
    CGFloat gap = 8.0;
    CGFloat cellWidth = totalWidth / numberOfColumns;
    CGFloat cellHeight = totalHeight / numberOfRows;
    CGFloat padWidth = cellWidth - gap;
    CGFloat padHeight = cellHeight - gap;

    for (int i = 0; i < SoundSampleTypeCount; ++i) {
        NSUInteger column = i % numberOfColumns;
        NSUInteger row = i / numberOfColumns;

        // top-left corner of the cell
        CGFloat cellX = column * cellWidth;
        CGFloat cellY = totalHeight - ((row + 1) * cellHeight);

        // inset the padFrame within its cell
        CGFloat currentX = cellX + (gap / 2.0);
        CGFloat currentY = cellY + (gap / 2.0);
        
        CGFloat actualPadWidth = MAX(0, padWidth);
        CGFloat actualPadHeight = MAX(0, padHeight);

        NSRect padFrame = NSMakeRect(currentX, currentY, actualPadWidth, actualPadHeight);
        
        NSString *label = [SampleTypeUtils descriptionForType:i];
        SoundPadView *spv = [[SoundPadView alloc] initWithFrame:padFrame label:label];
        
        [self addSubview:spv];
        self.padViews[@(i)] = spv;
    }
}

- (void)update:(SampleType)sampleType isPlaying:(BOOL)isPlaying {
    [self.padViews[@(sampleType)] setIsPlaying:isPlaying];
}

@end
