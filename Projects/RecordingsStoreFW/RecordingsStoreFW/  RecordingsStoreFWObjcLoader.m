//
//    RecordingsStoreFWObjcLoader.m
//  RecordingsStoreFW
//
//  Created by Charlie Cocchiaro on 2025-10-31.
//  Copyright © 2025 Charlie Cocchiaro. All rights reserved.
//
//  This source code and all associated materials are the confidential property of Charlie Cocchiaro.
//  Unauthorized copying, distribution, or disclosure of this file, via any medium, is strictly prohibited.
//

#import <Foundation/Foundation.h>
#import "RecordingsStoreFWObjcLoader.h"
#import "RecordingsStoreFW/RecordingsStoreFW-Swift.h"

@implementation RecordingsStoreFWObjcLoader

// https://developer.apple.com/documentation/objectivec/nsobject/1418815-load

+(void) load {
    if ([[RecordingsStoreFWSwiftLoader alloc] init]) {
        NSLog(@"RecordingsStoreFWObjcLoader.load() succeeded...");
    } else {
        NSLog(@"RecordingsStoreFWObjcLoader.load() failed...");
    }
}

@end
