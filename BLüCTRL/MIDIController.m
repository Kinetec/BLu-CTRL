//
//  MIDIController.m
//  BLüCTRL
//
//  MIKMIDI Created by Andrew Madsen.  Michael Ricca on 4/16/15.
//  Copyright (c) 2015 KInetec Media. All rights reserved.
//

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

@interface MIDIController ()

@property (nonatomic, strong) MIKMIDIDevice *MIDIDevice;

@end

@implementation MIDIController

+ (instancetype)sharedMIDIController
{
	static MIDIController *sharedMIDIController = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		sharedMIDIController = [[self alloc] init];
	});
	return sharedMIDIController;
}

- (instancetype)init
{
	self = [super init];
	if (self) {
		[self registerForNotifications];
		[self deviceWasAdded:nil]; // Go through existing devices too
	}
	return self;
}

- (void)dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)registerForNotifications
{
	NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
	[nc addObserver:self selector:@selector(deviceWasAdded:) name:MIKMIDIDeviceWasAddedNotification object:nil];
}

- (void)deviceWasAdded:(NSNotification *)notification
{
	MIKMIDIDeviceManager *manager = [MIKMIDIDeviceManager sharedDeviceManager];
	for (MIKMIDIDevice *device in manager.availableDevices) {
		if (![device.name isEqualToString:@"Network"] &&
			![device.name isEqualToString:@"Bluetooth"]) {
			self.MIDIDevice = device;
			break;
		}
	}
}

- (void)sendPitch:(double)pitch roll:(double)roll yaw:(double)yaw
{
	if (!self.MIDIDevice) return;
    
    //MIKMIDIControlChangeCommand *pitchCommand = [[MIKMIDIControlChangeCommand alloc] init];
    
	MIKMutableMIDIControlChangeCommand *pitchCommand = [[MIKMutableMIDIControlChangeCommand alloc] init];
	pitchCommand.channel = 10; // Or whatever channel you need
	pitchCommand.controllerNumber = 1;
	pitchCommand.controllerValue = (pitch + 180.0) * 127.0 / 360.0;
    sleep(0.1);
	
	MIKMutableMIDIControlChangeCommand *rollCommand = [[MIKMutableMIDIControlChangeCommand alloc] init];
	rollCommand.channel = 10; // Or whatever channel you need
	rollCommand.controllerNumber = 2;
	rollCommand.controllerValue = (roll + 180.0) * 127.0 / 360.0;
    sleep(0.1);
	
	MIKMutableMIDIControlChangeCommand *yawCommand = [[MIKMutableMIDIControlChangeCommand alloc] init];
	yawCommand.channel = 10; // Or whatever channel you need
	yawCommand.controllerNumber = 3;
	yawCommand.controllerValue = (yaw + 180.0) * 127.0 / 360.0;
    sleep(0.1);
	
	// Now send them to a destination
	MIKMIDIDestinationEndpoint *destination = [[self.MIDIDevice.entities valueForKeyPath:@"@unionOfArrays.destinations"] firstObject];
	if (destination) {
		NSError *error = nil;
		MIKMIDIDeviceManager *manager = [MIKMIDIDeviceManager sharedDeviceManager];
		if (![manager sendCommands:@[pitchCommand, rollCommand, yawCommand] toEndpoint:destination error:&error]) {
			NSLog(@"Unable to send pitch/roll/yaw commands to endpoint %@: %@", destination, error);
		}
	}
}

@end
