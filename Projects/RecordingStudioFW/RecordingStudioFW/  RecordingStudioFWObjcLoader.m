//
//    RecordingStudioFWObjcLoader.m
//  RecordingStudioFW
//
//  Created by Charlie Cocchiaro on 2025-10-31.
//  Copyright © 2025 Charlie Cocchiaro. All rights reserved.
//
//  This source code and all associated materials are the confidential property of Charlie Cocchiaro.
//  Unauthorized copying, distribution, or disclosure of this file, via any medium, is strictly prohibited.
//

#import <Foundation/Foundation.h>
#import "RecordingStudioFWObjcLoader.h"
#import "RecordingStudioFW/RecordingStudioFW-Swift.h"

@implementation RecordingStudioFWObjcLoader

// https://developer.apple.com/documentation/objectivec/nsobject/1418815-load

+(void) load {
    if ([[RecordingStudioFWSwiftLoader alloc] init]) {
        NSLog(@"RecordingStudioFWObjcLoader.load() succeeded...");
    } else {
        NSLog(@"RecordingStudioFWObjcLoader.load() failed...");
    }
}

@end
