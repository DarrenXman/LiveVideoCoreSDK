//
//  FiceTimeViewController.m
//  postssrj
//
//  Created by mac on 2017/6/3.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "FiceTimeViewController.h"
#import "FaceCamViewer.h"
#import "LiveShowViewController.h"
#import "ViewController.h"


@interface FiceTimeViewController ()

@property (nonatomic, strong) FaceCamViewer *viewer;

@end

@implementation FiceTimeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.camaraButton.layer.cornerRadius = 30.0f;
    self.camaraButton.clipsToBounds = YES;
    
    self.callButton.layer.cornerRadius = 30.0f;
    self.callButton.clipsToBounds = YES;
    
    self.voiceButton.layer.cornerRadius = 30.0f;
    self.voiceButton.clipsToBounds = YES;
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    FaceCamViewer *viewer = [[FaceCamViewer alloc] initWithDeviceType:IPHONE3x5];
    [viewer startFaceCam];
    _viewer = viewer;
    
    [self.view addSubview:viewer];

    [self.view bringSubviewToFront:_nameLabel];
    [self.view bringSubviewToFront:_faceTimeLabel];
    [self.view bringSubviewToFront:_camaraButton];
    [self.view bringSubviewToFront:_callButton];
    [self.view bringSubviewToFront:_voiceButton];
    
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    sleep(3);

    
//    LiveShowViewController *liveVC = [[LiveShowViewController alloc] init];
//    liveVC.RtmpUrl = [NSURL URLWithString:@"rtmp://ossrs.net/live/123456"];
//    liveVC.IsHorizontal = NO;
//    [self.navigationController pushViewController:liveVC animated:YES];
    
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ViewController *vc = [story instantiateViewControllerWithIdentifier:@"ViewController"];
    [self.navigationController pushViewController:vc animated:YES];

}

- (IBAction)switchButton:(id)sender {
    
    FaceCamViewer *viewer = [[FaceCamViewer alloc] initWithDeviceType:IPHONE3x5];
    viewer.cameraType = AVCaptureDevicePositionFront;
    if (_viewer.cameraType == AVCaptureDevicePositionBack) {
        
        viewer.cameraType = AVCaptureDevicePositionFront;
    }
    else if (_viewer.cameraType == AVCaptureDevicePositionFront){
        
        viewer.cameraType = AVCaptureDevicePositionBack;
    }
    _viewer = nil;
    

    [viewer startFaceCam];
    _viewer = viewer;
    
    [self.view addSubview:viewer];
    
    [self.view bringSubviewToFront:_nameLabel];
    [self.view bringSubviewToFront:_faceTimeLabel];
    [self.view bringSubviewToFront:_camaraButton];
    [self.view bringSubviewToFront:_callButton];
    [self.view bringSubviewToFront:_voiceButton];
    
}

- (IBAction)cancelButton:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)voiceButton:(id)sender {
    
    
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

@end
