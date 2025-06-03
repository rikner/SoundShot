//
//  AppDelegate.h
//  SoundShot
//
//  Created by Erik Werner on 31.05.25.
//

#import <Cocoa/Cocoa.h>
#import "MainViewController.h"

// TODO: remove MIDIReceiverDelegate, AudioPlayerDelegate and rather use a view controller implementing these
@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (strong, nonatomic) NSWindow *window;
@property (strong, nonatomic) MainViewController *mainViewController;

@end


