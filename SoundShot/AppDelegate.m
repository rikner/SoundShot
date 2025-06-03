//
//  AppDelegate.m
//  SoundShot
//
//  Created by Erik Werner on 31.05.25.
//  Updated by Erik Werner on 02.06.25.
//

#import "AppDelegate.h"
#import "MainViewController.h"

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    NSRect contentRect = NSMakeRect(0, 0, 800, 800);
    NSWindowStyleMask mask = NSWindowStyleMaskTitled | NSWindowStyleMaskClosable/* | NSWindowStyleMaskResizable*/;
    self.window = [[NSWindow alloc] initWithContentRect:contentRect
                                              styleMask:mask
                                                backing:NSBackingStoreBuffered
                                                  defer:NO];
    
    [self.window setTitle:@"SoundShot"];
    
    // Initialize the main view controller with the window's content rect
    self.mainViewController = [[MainViewController alloc] initWithFrame:contentRect];
    
    // Set the window's content view to the view controller's view
    [self.window setContentView:self.mainViewController.view];
    
    [self.window makeKeyAndOrderFront:nil];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
    [self.mainViewController.midiReceiver stopListening];
}

- (BOOL)applicationSupportsSecureRestorableState:(NSApplication *)app {
    return YES;
}

@end
