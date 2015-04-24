//
//  MIDIController.h
//  BLüCTRL
//
//  MIKMIDI Created by Andrew Madsen.  Michael Ricca on 4/16/15.
//  Copyright (c) 2015 KInetec Media. All rights reserved.
//


#import <MIKMIDI/MIKMIDI.h>
#import <UIKit/UIKit.h>
#import <CoreMIDI/CoreMIDI.h>
#import <CoreMotion/CoreMotion.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import <CoreAudioKit/CoreAudioKit.h>
#import <Foundation/Foundation.h>

@interface MIDIController : NSObject

+ (instancetype)sharedMIDIController;

- (void)sendPitch:(double)pitch roll:(double)roll yaw:(double)yaw;

@end
