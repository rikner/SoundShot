//
//  MIDIReceiver.h
//  SoundShot
//
//  Created by Erik Werner on 31.05.25.
//

#import <Foundation/Foundation.h>
#import <CoreMIDI/CoreMIDI.h>

NS_ASSUME_NONNULL_BEGIN

@class MIDIReceiver;

@protocol MIDIReceiverDelegate <NSObject>
@optional
- (void)midiReceiver:(MIDIReceiver *)receiver didReceiveNoteOn:(Byte)note velocity:(Byte)velocity channel:(Byte)channel;
- (void)midiReceiver:(MIDIReceiver *)receiver didReceiveNoteOff:(Byte)note velocity:(Byte)velocity channel:(Byte)channel;
- (void)midiReceiver:(MIDIReceiver *)receiver didReceiveControlChange:(Byte)controller value:(Byte)value channel:(Byte)channel;
@end

@interface MIDIReceiver : NSObject

@property (nonatomic, weak, nullable) id<MIDIReceiverDelegate> delegate;

- (void)startListening;
- (void)stopListening;
- (NSArray<NSString *> *)availableMIDISources;

@end

NS_ASSUME_NONNULL_END

