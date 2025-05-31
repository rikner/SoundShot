//
//  SamplerView.m
//  SoundShot
//
//  Created by Erik Werner on 31.05.25.
//

#import "SamplerView.h"
#import "AudioPlayerView.h"

@implementation SamplerView

- (instancetype) initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupAudioPlayerViews];
    }
    return self;
}

- (void)setupAudioPlayerViews {
    NSArray<NSString *> *soundFileNames = @[@"clap.mp3", @"flying_noise.mp3", @"game_over.mp3", @"hihat_closed.mp3", @"hihat_open.mp3", @"kick.mp3", @"snare.mp3"];

    CGFloat viewWidth = self.frame.size.width;
    NSUInteger numberOfPlayers = soundFileNames.count;
    if (numberOfPlayers == 0) {
        return;
    }

    CGFloat playerHeight = self.frame.size.height / numberOfPlayers;
    CGFloat currentY = 0;

    for (NSString *fileNameWithExtension in soundFileNames) {
        NSString *fileName = [fileNameWithExtension stringByDeletingPathExtension];
        NSString *fileExtension = [fileNameWithExtension pathExtension];
        
        NSURL *soundURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:fileName ofType:fileExtension]];

        if (soundURL) {
            NSRect playerFrame = NSMakeRect(0, currentY, viewWidth, playerHeight);
            AudioPlayerView *apv = [[AudioPlayerView alloc] initWithFrame:playerFrame soundURL:soundURL];
            [self addSubview:apv];
            currentY += playerHeight;
        } else {
            NSLog(@"Could not find sound file: %@", fileNameWithExtension);
        }
    }
}

@end
