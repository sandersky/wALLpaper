//
//  wALLpaper.m
//  wALLpaper
//
//  Created by Matthew Dahl on 3/3/13.
//  Copyright (c) 2013 Mintrus, LLC. All rights reserved.
//

#import "wALLpaper.h"

@implementation wALLpaper

- (void)mainViewDidLoad
{
    [_pickImageButton setEnabled:YES];
    
    NSURL *wallpaperURL = [[NSWorkspace sharedWorkspace] desktopImageURLForScreen:[[NSScreen screens] objectAtIndex:0]];
    [_imageView setImage:[[NSImage alloc] initWithContentsOfURL:wallpaperURL]];
}

- (void)pickImageButtonPressed:(id)sender
{
    NSOpenPanel *panel = [NSOpenPanel openPanel];
    
    NSURL *wallpapersURL = [NSURL URLWithString:@"file://localhost/Library/Desktop Pictures/"];
    [panel setDirectoryURL:wallpapersURL];
    
    [panel setCanChooseFiles:YES];
    [panel setCanChooseDirectories:NO];
    [panel setAllowsMultipleSelection:NO];
    
    NSInteger clicked = [panel runModal];
    
    if (clicked == NSFileHandlingPanelOKButton)
    {
        if ([[panel URLs] count] > 0)
        {
            // Disable Button
            [_pickImageButton setEnabled:NO];
            
            // Get URL of Wallpaper Image User Selected
            NSURL *wallpaperURL = [[panel URLs] objectAtIndex:0];
            [_imageView setImage:[[NSImage alloc] initWithContentsOfURL:wallpaperURL]];
            NSString *wallpaperString = [wallpaperURL absoluteString];
            wallpaperString = [wallpaperString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            wallpaperString = [wallpaperString stringByReplacingOccurrencesOfString:@"file://localhost" withString:@""];
            
            NSString *command = [NSString stringWithFormat:@"defaults write com.apple.desktop Background '{default = {ImageFilePath = \"%@\"; }; }' && killall Dock", wallpaperString];
            [self runCommand:command];
            [_pickImageButton setEnabled:YES];
        }
    }
}

- (IBAction)logoPressed:(id)sender
{
    NSURL *url = [NSURL URLWithString:@"http://mintrus.com/"];
    [[NSWorkspace sharedWorkspace] openURL:url];
}

- (NSString *)runCommand:(NSString *)commandToRun
{
    NSTask *task;
    task = [[NSTask alloc] init];
    [task setLaunchPath: @"/bin/sh"];
    
    NSArray *arguments = [NSArray arrayWithObjects:
                          @"-c" ,
                          [NSString stringWithFormat:@"%@", commandToRun],
                          nil];
    NSLog(@"run command: %@",commandToRun);
    [task setArguments: arguments];
    
    NSPipe *pipe;
    pipe = [NSPipe pipe];
    [task setStandardOutput: pipe];
    
    NSFileHandle *file;
    file = [pipe fileHandleForReading];
    
    [task launch];
    
    NSData *data;
    data = [file readDataToEndOfFile];
    
    NSString *output;
    output = [[NSString alloc] initWithData: data encoding: NSUTF8StringEncoding];
    return output;
}

@end
