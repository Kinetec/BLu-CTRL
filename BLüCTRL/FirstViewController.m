//
//  FirstViewController.m
//  BLüCTRL
//
//  Created by MICHAEL RICCA on 4/14/15.
//  NYU ITP TISCH SCHOOL OF THE ARTS
//  Copyright (c) 2015 KInetec Media. All rights reserved.
//

#import "FirstViewController.h"
#import "MIDIController.h"
#import <MIKMIDI/MIKMIDI.h>
#import <UIKit/UIKit.h>
#import <CoreMIDI/CoreMIDI.h>
#import <CoreMotion/CoreMotion.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import <CoreAudioKit/CoreAudioKit.h>
#import <Foundation/Foundation.h>
@import CoreMotion;
@import CoreMIDI;
@import CoreBluetooth;
@import CoreAudioKit;
@import UIKit;
@import Foundation;




#define kRadToDeg   57.2957795

@interface FirstViewController ()
@property (weak, nonatomic) IBOutlet UILabel *rollLabel;
@property (weak, nonatomic) IBOutlet UILabel *pitchLabel;
@property (weak, nonatomic) IBOutlet UILabel *yawLabel;
@property (weak, nonatomic) IBOutlet UILabel *rotationXLabel;
@property (weak, nonatomic) IBOutlet UILabel *rotationYLabel;
@property (weak, nonatomic) IBOutlet UILabel *rotationZLabel;
@property (nonatomic, strong) CMMotionManager *motionManager;
@end

@implementation FirstViewController
bool pitchon = true;
bool rollon = true;
bool yawon = true;

- (CMMotionManager *)motionManager
{
    if (!_motionManager) {
        _motionManager = [CMMotionManager new];
        [_motionManager setDeviceMotionUpdateInterval:0.1];
    }
    return _motionManager;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveEvent:)
                                                 name:@"ToggleChanged"
                                               object:nil];
    
    
    
    [self.motionManager startDeviceMotionUpdatesToQueue:[NSOperationQueue currentQueue] withHandler:^(CMDeviceMotion *motion, NSError *error) {
        double pitch;
        double roll;
        double yaw;
        
        if (pitchon == true) {
            pitch = motion.attitude.roll * kRadToDeg;
        }
        else {
            pitch = -365;
        }
        if (rollon == true) {
            roll = motion.attitude.pitch * kRadToDeg;
        }
        else {
            roll = -365;
        }
        if (yawon == true) {
            yaw = motion.attitude.yaw * kRadToDeg;
        }
        else {
            yaw = -365;
        }
        
        self.pitchLabel.text = [NSString stringWithFormat:@"%.3gº", pitch];
        self.rollLabel.text = [NSString stringWithFormat:@"%.3gº", roll];
        self.yawLabel.text = [NSString stringWithFormat:@"%.3gº", yaw];
		[[MIDIController sharedMIDIController] sendPitch:pitch roll:roll yaw:yaw];
    }];
    
    
}

- (void)receiveEvent:(NSNotification *)notification {
    bool toggle1status = [[[notification userInfo] valueForKey:@"toggle1"]boolValue];
    bool toggle2status = [[[notification userInfo] valueForKey:@"toggle2"]boolValue];
    bool toggle3status = [[[notification userInfo] valueForKey:@"toggle3"]boolValue];

//    NSLog([NSString stringWithFormat:@"received, %i",toggle1status]);
    if (toggle1status == 0) {
        pitchon = false;
    }
    else
    {
        pitchon = true;
    }
    if (toggle2status == 0) {
        rollon = false;
    }
    else
    {
        rollon = true;
    }
    if (toggle3status == 0) {
        yawon = false;
    }
    else
    {
        yawon = true;
    }
}



//- (void)viewWillDisappear:(BOOL)animated
//{
//    [self.motionManager stopDeviceMotionUpdates];
//    self.motionManager = nil;
//    [super viewWillDisappear:animated];
//}

@end
