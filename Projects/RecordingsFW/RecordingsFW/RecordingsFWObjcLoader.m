//
//  RecordingsFWObjcLoader.m
//  RecordingsFW
//
//  Created by Charlie Cocchiaro on 2025-10-31.
//  Copyright © 2025 Charlie Cocchiaro. All rights reserved.
//
//  This source code and all associated materials are the confidential property of Charlie Cocchiaro.
//  Unauthorized copying, distribution, or disclosure of this file, via any medium, is strictly prohibited.
//

#import <Foundation/Foundation.h>
#import "RecordingsFWObjcLoader.h"
#import "RecordingsFW/RecordingsFW-Swift.h"

@implementation RecordingsFWObjcLoader

// https://developer.apple.com/documentation/objectivec/nsobject/1418815-load

+(void) load {
    if ([[RecordingsFWSwiftLoader alloc] init]) {
        NSLog(@"RecordingsFWObjcLoader.load() succeeded...");
    } else {
        NSLog(@"RecordingsFWObjcLoader.load() failed...");
    }
}

@end
