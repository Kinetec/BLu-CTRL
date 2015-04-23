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
    
    [self.motionManager startDeviceMotionUpdatesToQueue:[NSOperationQueue currentQueue] withHandler:^(CMDeviceMotion *motion, NSError *error) {
		double pitch = motion.attitude.roll * kRadToDeg;
		double roll = motion.attitude.pitch * kRadToDeg;
		double yaw = motion.attitude.yaw * kRadToDeg;
        self.pitchLabel.text = [NSString stringWithFormat:@"%.3gº", pitch];
        self.rollLabel.text = [NSString stringWithFormat:@"%.3gº", roll];
        self.yawLabel.text = [NSString stringWithFormat:@"%.3gº", yaw];
		[[MIDIController sharedMIDIController] sendPitch:pitch roll:roll yaw:yaw];
    }];
    
    [self.motionManager startGyroUpdatesToQueue:[NSOperationQueue currentQueue] withHandler:^(CMGyroData *gyroData, NSError *error) {
        self.rotationXLabel.text = [NSString stringWithFormat:@"%fdouble", gyroData.rotationRate.x];
        self.rotationYLabel.text = [NSString stringWithFormat:@"%fdouble", gyroData.rotationRate.y];
        self.rotationZLabel.text = [NSString stringWithFormat:@"%fdouble", gyroData.rotationRate.z];
    }];
}

//- (void)viewWillDisappear:(BOOL)animated
//{
//    [self.motionManager stopDeviceMotionUpdates];
//    self.motionManager = nil;
//    [super viewWillDisappear:animated];
//}

@end
