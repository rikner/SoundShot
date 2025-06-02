//
//  AudioPlayer.m
//  SoundShot
//
//  Created by Erik Werner on 31.05.25.
//

#import "AudioPlayer.h"

@interface AudioPlayer ()

@property (nonatomic, strong) AVAudioEngine *engine;
@property (nonatomic, strong) AVAudioMixerNode *mainMixerNode;

@property (nonatomic, strong) NSMutableDictionary<NSNumber *, AVAudioPlayerNode *> *playerNodes;
@property (nonatomic, strong) NSMutableDictionary<NSNumber *, AVAudioPCMBuffer *> *soundBuffers;

@end


@implementation AudioPlayer

- (instancetype)init {
    self = [super init];
    if (self) {
        _engine = [[AVAudioEngine alloc] init];
        _mainMixerNode = [[AVAudioMixerNode alloc] init];
        _playerNodes = [NSMutableDictionary dictionary];
        _soundBuffers = [NSMutableDictionary dictionary];

        [self loadSoundFiles]; // load buffers first
        [self setupAudioEngine];

        NSError *error = nil;
        if (![self.engine startAndReturnError:&error]) {
            NSLog(@"Error starting AVAudioEngine: %@", error.localizedDescription);
            return nil;
        }
    }
    return self;
}

- (void)setupAudioEngine {
    [self.engine attachNode:self.mainMixerNode];
    [self.engine connect:self.mainMixerNode to:self.engine.mainMixerNode format:nil];

    // Create a dedicated player node for each sound type
    for (int i = 0; i < SoundSampleTypeCount; ++i) {
        SoundSampleType sampleType = (SoundSampleType)i;
        AVAudioPlayerNode *playerNode = [[AVAudioPlayerNode alloc] init];
        [self.engine attachNode:playerNode];
        
        AVAudioFormat *outputFormat = [self.mainMixerNode outputFormatForBus:0];
        [self.engine connect:playerNode to:self.mainMixerNode format:outputFormat];
        
        self.playerNodes[@(sampleType)] = playerNode;
    }
    
    [self.engine prepare];
}

- (void)loadSoundFiles {
    NSArray<NSString *> *fileNames = @[
        @"clap.mp3",
        @"flying_noise.mp3",
        @"game_over.mp3",
        @"hihat_closed.mp3",
        @"hihat_open.mp3",
        @"kick.mp3",
        @"snare.mp3"
    ];

    NSArray<NSNumber *> *soundTypes = @[
        @(SoundSampleTypeClap),
        @(SoundSampleTypeFlyingNoise),
        @(SoundSampleTypeGameOver),
        @(SoundSampleTypeHiHatClosed),
        @(SoundSampleTypeHiHatOpen),
        @(SoundSampleTypeKick),
        @(SoundSampleTypeSnare)
    ];

    if (fileNames.count != soundTypes.count) {
        NSLog(@"Error: Mismatch between fileNames and soundTypes count.");
        return;
    }

    for (NSUInteger i = 0; i < fileNames.count; i++) {
        NSString *fileNameWithExtension = fileNames[i];
        SoundSampleType sampleType = [soundTypes[i] integerValue];
        
        NSString *fileName = [fileNameWithExtension stringByDeletingPathExtension];
        NSString *fileExtension = [fileNameWithExtension pathExtension];

        NSURL *soundURL = [[NSBundle mainBundle] URLForResource:fileName withExtension:fileExtension];
        
        if (soundURL) {
            NSError *error = nil;
            AVAudioFile *audioFile = [[AVAudioFile alloc] initForReading:soundURL error:&error];
            if (audioFile) {
                AVAudioPCMBuffer *buffer = [[AVAudioPCMBuffer alloc] initWithPCMFormat:audioFile.processingFormat
                                                                         frameCapacity:(AVAudioFrameCount)audioFile.length];
                if ([audioFile readIntoBuffer:buffer error:&error]) {
                    self.soundBuffers[@(sampleType)] = buffer;
                    NSLog(@"Loaded buffer for %@", fileNameWithExtension);
                } else {
                    NSLog(@"Error reading audio file %@ into buffer: %@", fileNameWithExtension, error.localizedDescription);
                }
            } else {
                NSLog(@"Error creating AVAudioFile for %@: %@", fileNameWithExtension, error.localizedDescription);
            }
        } else {
            NSLog(@"Could not find sound file: %@ in Samples directory", fileNameWithExtension);
        }
    }
}

- (void)playSample:(SoundSampleType)sampleType {
    AVAudioPCMBuffer *bufferToPlay = self.soundBuffers[@(sampleType)];
    if (!bufferToPlay) {
        NSLog(@"AudioPlayer: Sound buffer not found for type %ld", (long)sampleType);
        return;
    }

    AVAudioPlayerNode *playerNode = self.playerNodes[@(sampleType)];
    if (!playerNode) {
        NSLog(@"AudioPlayer: Player node not found for type %ld.", (long)sampleType);
        return;
    }

    [playerNode stop]; 
    

    if (self.delegate && [self.delegate respondsToSelector:@selector(audioPlayer:didStartPlayingSample:)]) {
        [self.delegate audioPlayer:self didStartPlayingSample:sampleType];
    }

    [playerNode scheduleBuffer:bufferToPlay
                        atTime:nil
                       options:AVAudioPlayerNodeBufferInterrupts
             completionHandler:^{
                    if (self.delegate && [self.delegate respondsToSelector:@selector(audioPlayer:didFinishPlayingSample:)]) {
                        [self.delegate audioPlayer:self didFinishPlayingSample:sampleType];
                    }
                }
    ];
    
    [playerNode play];
}

- (void) finishedPlaying {
    
}

- (void)dealloc {
    if (self.engine.isRunning) {
        [self.engine stop];
    }
}

@end
