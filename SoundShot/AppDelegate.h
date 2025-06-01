//
//  AppDelegate.h
//  SoundShot
//
//  Created by Erik Werner on 31.05.25.
//

#import <Cocoa/Cocoa.h>
#import "SoundPadView.h"
#import "MIDIReceiver.h"
#import "AudioPlayer.h"

@interface AppDelegate : NSObject <NSApplicationDelegate, MIDIReceiverDelegate>

@property (strong, nonatomic) NSWindow *window;
@property (strong, nonatomic) MIDIReceiver *midiReceiver;
@property (strong, nonatomic) AudioPlayer *audioPlayer;

@end


