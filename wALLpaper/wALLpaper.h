//
//  wALLpaper.h
//  wALLpaper
//
//  Created by Matthew Dahl on 3/3/13.
//  Copyright (c) 2013 Mintrus, LLC. All rights reserved.
//

#import <PreferencePanes/PreferencePanes.h>

@interface wALLpaper : NSPreferencePane
{
    IBOutlet NSImageView *_imageView;
    IBOutlet NSButton *_pickImageButton;
}

- (void)mainViewDidLoad;

- (IBAction)pickImageButtonPressed:(id)sender;
- (IBAction)logoPressed:(id)sender;

@end
