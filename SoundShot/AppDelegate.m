//
//  AppDelegate.m
//  SoundShot
//
//  Created by Erik Werner on 31.05.25.
//

#import "AppDelegate.h"
#import "MainViewController.h"

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    NSRect contentRect = NSMakeRect(0, 0, 800, 800);
    NSWindowStyleMask mask = NSWindowStyleMaskTitled | NSWindowStyleMaskClosable/* | NSWindowStyleMaskResizable*/;
    
    self.mainViewController = [[MainViewController alloc] initWithFrame:contentRect];

    self.window = [[NSWindow alloc] initWithContentRect:contentRect
                                              styleMask:mask
                                                backing:NSBackingStoreBuffered
                                                  defer:NO];
    
    [self.window setTitle:@"SoundShot"];
    [self.window setContentView:self.mainViewController.view];
    [self.window makeKeyAndOrderFront:nil];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    [self.mainViewController.midiReceiver stopListening];
}

- (BOOL)applicationSupportsSecureRestorableState:(NSApplication *)app {
    return YES;
}

@end
