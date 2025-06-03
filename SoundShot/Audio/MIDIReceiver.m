//
//  MIDIReceiver.m
//  SoundShot
//
//  Created by Erik Werner on 31.05.25.
//

#import "MIDIReceiver.h"

@interface MIDIReceiver () {
MIDIClientRef midiClient;
MIDIPortRef inputPort;
NSMutableSet<NSNumber *> *connectedSources;
}
@end

@implementation MIDIReceiver

- (instancetype)init {
    self = [super init];
    if (self) {
        self->connectedSources = [NSMutableSet new];

        OSStatus clientStatus = MIDIClientCreate(CFSTR("SoundShot MIDI Client"), 
                                                MIDINotificationCallback, 
                                                (__bridge void *)self, 
                                                &midiClient);
        if (clientStatus != noErr) {
            NSLog(@"Error creating MIDI client: %d", clientStatus);
            return nil;
        }

        OSStatus portStatus = MIDIInputPortCreate(midiClient, 
                                                 CFSTR("SoundShot Input Port"), 
                                                 MIDIInputCallback, 
                                                 (__bridge void *)self, 
                                                 &inputPort);
        if (portStatus != noErr) {
            NSLog(@"Error creating MIDI input port: %d", portStatus);
            MIDIClientDispose(midiClient);
            return nil;
        }
    }
    return self;
}

- (void)startListening {
    [self connectToNewSources];
}

- (void)stopListening {
    ItemCount sourceCount = MIDIGetNumberOfSources();
    for (ItemCount i = 0; i < sourceCount; ++i) {
        MIDIEndpointRef source = MIDIGetSource(i);
        if (source != 0) {
            // Disconnect the source from our input port
            OSStatus portDisconnectStatus = MIDIPortDisconnectSource(inputPort, source);
            if (portDisconnectStatus != noErr) {
                 CFStringRef endpointName = NULL;
                MIDIObjectGetStringProperty(source, kMIDIPropertyName, &endpointName);
                NSLog(@"Error disconnecting from MIDI source %@: %d", (__bridge NSString *)endpointName, portDisconnectStatus);
                if (endpointName) CFRelease(endpointName);
            }
        }
    }

    [connectedSources removeAllObjects];
    // Note: MIDIClientDispose and MIDIPortDispose should be called in dealloc
}

- (NSArray<NSString *> *)availableMIDISources {
    NSMutableArray<NSString *> *sourceNames = [NSMutableArray array];
    ItemCount sourceCount = MIDIGetNumberOfSources();
    for (ItemCount i = 0; i < sourceCount; ++i) {
        MIDIEndpointRef source = MIDIGetSource(i);
        if (source != 0) {
            CFStringRef endpointName = NULL;
            OSStatus nameStatus = MIDIObjectGetStringProperty(source, kMIDIPropertyName, &endpointName);
            if (nameStatus == noErr && endpointName != NULL) {
                [sourceNames addObject:(__bridge NSString *)endpointName];
                CFRelease(endpointName);
            } else {
                [sourceNames addObject:[NSString stringWithFormat:@"Unknown Source %lu", i]];
            }
        }
    }
    return [sourceNames copy];
}

- (void)connectToNewSources {
    ItemCount sourceCount = MIDIGetNumberOfSources();
    
    for (ItemCount i = 0; i < sourceCount; ++i) {
        MIDIEndpointRef source = MIDIGetSource(i);
        if (source != 0) {
            // Get a unique ID for this source to track connections
            MIDIUniqueID uniqueID = 0;
            OSStatus idStatus = MIDIObjectGetIntegerProperty(source, kMIDIPropertyUniqueID, &uniqueID);
            if (idStatus != noErr) {
                uniqueID = (MIDIUniqueID)i;
            }
            
            if (![connectedSources containsObject:@(uniqueID)]) {
                OSStatus portConnectStatus = MIDIPortConnectSource(inputPort, source, NULL);
                if (portConnectStatus == noErr) {
                    [connectedSources addObject:@(uniqueID)];
                    
                    CFStringRef endpointName = NULL;
                    MIDIObjectGetStringProperty(source, kMIDIPropertyName, &endpointName);
                    NSLog(@"Connected to new MIDI source: %@", (__bridge NSString *)endpointName);
                    
                    // Notify delegate about new device if needed
                    if ([self.delegate respondsToSelector:@selector(midiReceiver:didConnectToSource:)]) {
                        [self.delegate midiReceiver:self didConnectToSource:(__bridge NSString *)endpointName];
                    }
                    
                    if (endpointName) CFRelease(endpointName);
                } else {
                    NSLog(@"Error connecting to MIDI source %lu: %d", i, portConnectStatus);
                }
            }
        }
    }
}

- (void)dealloc {
    NSLog(@"Deallocating MIDIReceiver");
    [self stopListening]; // Ensure sources are disconnected

    if (inputPort != 0) {
        MIDIPortDispose(inputPort);
        inputPort = 0;
    }
    if (midiClient != 0) {
        MIDIClientDispose(midiClient);
        midiClient = 0;
    }
}


// MIDI Input Callback Function (C function)
static void MIDIInputCallback(const MIDIPacketList *packetList, void *readProcRefCon, void *srcConnRefCon) {
    MIDIReceiver *receiver = (__bridge MIDIReceiver *)readProcRefCon;
    if (!receiver || !receiver.delegate) {
        return;
    }

    const MIDIPacket *packet = &packetList->packet[0];
    for (UInt32 i = 0; i < packetList->numPackets; ++i) {
        // this example processes messages assuming they are 3 bytes long.
        // Real-world MIDI parsing should handle running status and messages of varying lengths.
        
        for (int j = 0; j < packet->length; ) {
            Byte statusByte = packet->data[j];
            Byte command = statusByte & 0xF0;   // MIDI command (Note On, Note Off, CC, etc.)
            Byte channel = statusByte & 0x0F;
            // Ensure there are enough bytes for a typical 3-byte message
            if (j + 2 < packet->length) {
                Byte data1 = packet->data[j+1];
                Byte data2 = packet->data[j+2];

                switch (command) {
                    case 0x90: // Note On
                        if (data2 > 0) { // Velocity > 0 means Note On
                            if ([receiver.delegate respondsToSelector:@selector(midiReceiver:didReceiveNoteOn:velocity:channel:)]) {
                                [receiver.delegate midiReceiver:receiver didReceiveNoteOn:data1 velocity:data2 channel:channel];
                            }
                        } else { // Velocity == 0 means Note Off
                            if ([receiver.delegate respondsToSelector:@selector(midiReceiver:didReceiveNoteOff:velocity:channel:)]) {
                                [receiver.delegate midiReceiver:receiver didReceiveNoteOff:data1 velocity:data2 channel:channel];
                            }
                        }
                        j += 3; // advance by 3 bytes
                        break;
                    case 0x80: // Note Off
                        if ([receiver.delegate respondsToSelector:@selector(midiReceiver:didReceiveNoteOff:velocity:channel:)]) {
                            [receiver.delegate midiReceiver:receiver didReceiveNoteOff:data1 velocity:data2 channel:channel];
                        }
                        j += 3;
                        break;
                    case 0xB0: // Control Change (CC)
                        if ([receiver.delegate respondsToSelector:@selector(midiReceiver:didReceiveControlChange:value:channel:)]) {
                            [receiver.delegate midiReceiver:receiver didReceiveControlChange:data1 value:data2 channel:channel];
                        }
                        j += 3;
                        break;
                    // case 0xE0: // Pitch Bend
                    // case 0xC0: // Program Change
                    default:
                        // A more robust parser would determine the correct length for each status byte.
                        NSLog(@"Unhandled MIDI Command: 0x%02X", command);
                        j++; 
                        break;
                }
            } else {
                j = packet->length;
            }
        }
        packet = MIDIPacketNext(packet);
    }
}


static void MIDINotificationCallback(const MIDINotification *message, void *refCon) {
    MIDIReceiver *receiver = (__bridge MIDIReceiver *)refCon;
    
    switch(message->messageID) {
        case kMIDIMsgObjectAdded:
            if (((MIDIObjectAddRemoveNotification *)message)->childType == kMIDIObjectType_Source) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [receiver connectToNewSources];
                });
            }
            break;
            
        case kMIDIMsgObjectRemoved:
            break;
            
        default:
            break;
    }
}


@end
