//
//  AppDelegate.m
//  SoundShot
//
//  Created by Erik Werner on 31.05.25.
//

#import "AppDelegate.h"
#import "SamplerView.h"


@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    NSRect contentRect = NSMakeRect(0, 0, 800, 800);
    NSWindowStyleMask mask = NSWindowStyleMaskTitled | NSWindowStyleMaskClosable/* | NSWindowStyleMaskResizable*/;
    self.window = [[NSWindow alloc] initWithContentRect:contentRect
                                              styleMask:mask
                                                backing:NSBackingStoreBuffered
                                                  defer:NO];
    
    [self.window setTitle:@"SoundShot"];
    
    SamplerView *samplerView = [[SamplerView alloc] initWithFrame:contentRect];
    [self.window.contentView addSubview:samplerView];

    [self.window makeKeyAndOrderFront:nil];
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}


- (BOOL)applicationSupportsSecureRestorableState:(NSApplication *)app {
    return YES;
}


@end
