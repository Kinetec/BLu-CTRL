//
//  SecondViewController.m
//  BLüCTRL
//
//  Created by MICHAEL RICCA on 4/14/15.
//  NYU ITP TISCH SCHOOL OF THE ARTS
//  Copyright (c) 2015 KInetec Media. All rights reserved.
//

#import "SecondViewController.h"
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

@interface SecondViewController ()

@property (weak, nonatomic) IBOutlet UISwitch *toggle2;
@property (weak, nonatomic) IBOutlet UISwitch *toggle3;
@property (weak, nonatomic) IBOutlet UISwitch *toggle1;

@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)doneAction:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)Test:(id)sender {
    CABTMIDILocalPeripheralViewController *viewController = [CABTMIDILocalPeripheralViewController new];
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:viewController];
    
    // this will present a view controller as a popover in iPad and modal VC on iPhone
    viewController.navigationItem.rightBarButtonItem =
    [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                  target:self
                                                  action:@selector(doneAction:)];
    
    navController.modalPresentationStyle = UIModalPresentationPopover;
    
    UIPopoverPresentationController *popC = navController.popoverPresentationController;
    popC.permittedArrowDirections = UIPopoverArrowDirectionAny;
    popC.sourceRect = [sender frame];
    
    UIButton *button = (UIButton *)sender;
    popC.sourceView = button.superview;
    
    [self presentViewController:navController animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)Toggle1:(id)sender {
    bool toggle1status;
    bool toggle2status;
    bool toggle3status;
    if(self.toggle1.on){
        toggle1status = true;
    }else{

        toggle1status = false;
    }
    if(self.toggle2.on){
        toggle2status = true;
    }else{
        
        toggle2status = false;
    }
    if(self.toggle3.on){
        toggle3status = true;
    }else{
        
        toggle3status = false;
    }
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:toggle1status],@"toggle1", [NSNumber numberWithBool:toggle2status],@"toggle2", [NSNumber numberWithBool:toggle3status],@"toggle3", nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ToggleChanged" object:nil userInfo:userInfo];
    
}

@end
