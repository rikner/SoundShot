//
//  SamplePlayer.m
//  SoundShot
//
//  Created by Erik Werner on 31.05.25.
//

#import "SamplePlayer.h"

@interface SamplePlayer ()


@property (nonatomic, strong) AVAudioEngine *engine;
@property (nonatomic, strong) AVAudioMixerNode *mainMixerNode;

@property (nonatomic, strong) NSMutableDictionary<NSNumber *, AVAudioPlayerNode *> *playerNodes;
@property (nonatomic, strong) NSMutableDictionary<NSNumber *, AVAudioPCMBuffer *> *soundBuffers;

@end


@implementation SamplePlayer

- (instancetype)init {
    self = [super init];
    if (self) {
        _engine = [[AVAudioEngine alloc] init];
        _mainMixerNode = [[AVAudioMixerNode alloc] init];
        _playerNodes = [NSMutableDictionary dictionary];
        _soundBuffers = [NSMutableDictionary dictionary];

        [self loadSoundFiles];
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
        SampleType sampleType = (SampleType)i;
        AVAudioPlayerNode *playerNode = [[AVAudioPlayerNode alloc] init];
        [self.engine attachNode:playerNode];
        
        AVAudioFormat *outputFormat = [self.mainMixerNode outputFormatForBus:0];
        [self.engine connect:playerNode to:self.mainMixerNode format:outputFormat];
        
        self.playerNodes[@(sampleType)] = playerNode;
    }
    
    [self.engine prepare];
}

- (void)loadSoundFiles {

    for (NSUInteger i = 0; i < SoundSampleTypeCount; i++) {
        SampleType sampleType = (SampleType)i;
        NSString *filenameWithExt = [SampleTypeUtils filenameForType:sampleType];

        if (!filenameWithExt) {
            NSLog(@"No filename defined for sample type %d", i);
            continue;
        }
        
        NSString *fileName = [filenameWithExt stringByDeletingPathExtension];
        NSString *fileExtension = [filenameWithExt pathExtension];

        NSURL *soundURL = [[NSBundle mainBundle] URLForResource:fileName withExtension:fileExtension];
        
        if (!soundURL) {
            return NSLog(@"Could not find sound file: %@ in Samples directory", filenameWithExt);
        }
        
        NSError *error = nil;

        AVAudioFile *audioFile = [[AVAudioFile alloc] initForReading:soundURL error:&error];
        if (error != nil) {
            return NSLog(@"Error creating AVAudioFile for %@: %@", filenameWithExt, error.localizedDescription);
        }

        AVAudioPCMBuffer *buffer = [[AVAudioPCMBuffer alloc] initWithPCMFormat:audioFile.processingFormat
                                                                 frameCapacity:(AVAudioFrameCount)audioFile.length];
        if ([audioFile readIntoBuffer:buffer error:&error]) {
            self.soundBuffers[@(sampleType)] = buffer;
            NSLog(@"Loaded buffer for %@", filenameWithExt);
        } else {
            NSLog(@"Error reading audio file %@ into buffer: %@", filenameWithExt, error.localizedDescription);
        }
    }
}

- (void)play:(SampleType)sampleType {
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
    

    if (self.delegate && [self.delegate respondsToSelector:@selector(samplePlayer:didStartPlayingSample:)]) {
        [self.delegate samplePlayer:self didStartPlayingSample:sampleType];
    }

    [playerNode scheduleBuffer:bufferToPlay
                        atTime:nil
                       options:AVAudioPlayerNodeBufferInterrupts
             completionHandler:^{
                    if (self.delegate && [self.delegate respondsToSelector:@selector(samplePlayer:didFinishPlayingSample:)]) {
                        [self.delegate samplePlayer:self didFinishPlayingSample:sampleType];
                    }
                }
    ];
    
    [playerNode play];
}

- (void)dealloc {
    if (self.engine.isRunning) {
        [self.engine stop];
    }
}

@end

