//
//  TESTLiveShowViewController.m
//  LiveVideoCoreDemo
//
//  Created by mac on 2017/2/28.
//  Copyright © 2017年 com.Alex. All rights reserved.
//

#import "TESTLiveShowViewController.h"
#import "XMNShareMenu.h"


@interface TESTLiveShowViewController ()

@end

@implementation TESTLiveShowViewController {
    
    UIView *_AllBackGroundView;
    UIButton *_ExitButton;
    UILabel *_RtmpStatusLabel;
    UIButton *_FilterButton;
    UIButton *_CameraChangeButton;
    XMNShareView *_FilterMenu;
    ASValueTrackingSlider *_MicSlider;
    
    Boolean _bCameraFrontFlag;
    
    UIView *_focusBox;
}
@synthesize RtmpUrl;


- (void)UIInit {
    
    double fScreenW = [UIScreen mainScreen].bounds.size.width;
    double fScreenH = [UIScreen mainScreen].bounds.size.height;
    if (self.IsHorizontal) {
        
        double fTmp = fScreenH;
        fScreenH = fScreenW;
        fScreenW = fTmp;
    }
    
    _AllBackGroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, fScreenW, fScreenH)];
    [self.view addSubview:_AllBackGroundView];
    
    float fExitButtonW = 40;
    float fExitButtonH = 20;
    float fExitButtonX = fScreenW - fExitButtonW - 10;
    float fExitButtonY = fScreenH - fExitButtonH - 10;
    
    _ExitButton = [[UIButton alloc] initWithFrame:CGRectMake(fExitButtonX, fExitButtonY, fExitButtonW, fExitButtonH)];
    _ExitButton.backgroundColor = [UIColor purpleColor];
    _ExitButton.layer.masksToBounds = YES;
    _ExitButton.layer.cornerRadius = 5;
    [_ExitButton setTitle:@"退出" forState:UIControlStateNormal];
    [_ExitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _ExitButton.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:10];
    [_ExitButton addTarget:self action:@selector(OnExitClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_ExitButton];
    
    float fRtmpStatusLabelW = 120;
    float fRtmpStatusLabelH = 20;
    float fRtmpStatusLabelX = 10;
    float fRtmpStatusLabelY = 30;
    _RtmpStatusLabel = [[UILabel alloc] initWithFrame:CGRectMake(fRtmpStatusLabelX, fRtmpStatusLabelY, fRtmpStatusLabelW, fRtmpStatusLabelH)];
    _RtmpStatusLabel.backgroundColor = [UIColor lightGrayColor];
    _RtmpStatusLabel.layer.masksToBounds = YES;
    _RtmpStatusLabel.layer.cornerRadius = 5;
    _RtmpStatusLabel.font = [UIFont systemFontOfSize:10];
    _RtmpStatusLabel.textColor = [UIColor whiteColor];
    _RtmpStatusLabel.text = @"RTMP状态：未连接";
    [self.view addSubview:_RtmpStatusLabel];
    
    float fFilterButtomW = 50;
    float fFilterButtomH = 30;
    float fFilterButtomX = fScreenW/2-fFilterButtomW-5;
    float fFilterButtomY = fScreenH - fFilterButtomH-10;
    
    _FilterButton = [[UIButton alloc] initWithFrame:CGRectMake(fFilterButtomX, fFilterButtomY, fFilterButtomW, fFilterButtomH)];
    _FilterButton.backgroundColor = [UIColor purpleColor];
    _FilterButton.layer.masksToBounds = YES;
    _FilterButton.layer.cornerRadius = 5;
    [_FilterButton setTitle:@"滤镜" forState:UIControlStateNormal];
    [_FilterButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _FilterButton.titleLabel.font = [UIFont systemFontOfSize:10];
    [_FilterButton addTarget:self action:@selector(OnFilterclicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_FilterButton];
    
    float fCameraChangeButtonW = fFilterButtomW;
    float fCameraChangeButtonH = fFilterButtomH;
    float fCameraChangeButtonX = fFilterButtomX;
    float fCameraChangeButtonY = fFilterButtomY;
    
    _CameraChangeButton = [[UIButton alloc] initWithFrame:CGRectMake(fCameraChangeButtonX, fCameraChangeButtonY, fCameraChangeButtonW, fCameraChangeButtonH)];
    _CameraChangeButton.backgroundColor = [UIColor purpleColor];
    _CameraChangeButton.layer.masksToBounds = YES;
    _CameraChangeButton.layer.cornerRadius = 5;
    [_CameraChangeButton setTitle:@"后置镜头" forState:UIControlStateNormal];
    [_CameraChangeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _CameraChangeButton.titleLabel.font = [UIFont systemFontOfSize:10];
    [_CameraChangeButton addTarget:self action:@selector(OnCameraChangeClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_CameraChangeButton];
    
    float fMicSliderX = 20;
    float fMicSliderY = fCameraChangeButtonY - fCameraChangeButtonH - 10;
    float fMicSliderW = fScreenW - fMicSliderX*2;
    float fMicSliderH = 30;
    _MicSlider = [[ASValueTrackingSlider alloc] initWithFrame:CGRectMake(fMicSliderX, fMicSliderY, fMicSliderW, fMicSliderH)];
    _MicSlider.maximumValue = 10.0;
    _MicSlider.popUpViewCornerRadius = 4;
    [_MicSlider setMaxFractionDigitsDisplayed:0];
    _MicSlider.popUpViewColor = [UIColor colorWithHue:0.55 saturation:0.8 brightness:0.9 alpha:0.7];
    _MicSlider.popUpViewWidthPaddingFactor = 1.7;
    _MicSlider.delegate = self;
    _MicSlider.dataSource = self;
    _MicSlider.value = 5;
    [self.view addSubview:_MicSlider];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dealSingleTap:)];
    [self.view addGestureRecognizer:singleTap];
    
    
    _focusBox = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 150, 150)];
    _focusBox.backgroundColor = [UIColor clearColor];
    _focusBox.layer.borderColor = [UIColor greenColor].CGColor;
    _focusBox.layer.borderWidth = 5.0f;
    _focusBox.hidden = YES;
    [self.view addSubview:_focusBox];
    
}


- (void)RtmpInit {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        CGSize videosize;
        
        if (self.IsHorizontal) {
            videosize = LIVE_VIEDO_SIZE_HORIZONTAL_D1;
        }else{
            videosize = LIVE_VIEDO_SIZE_D1;
        }
        
        [LiveVideoCoreSDK sharedinstance].delegate = self;
        [[LiveVideoCoreSDK sharedinstance] LiveInit:RtmpUrl Preview:_AllBackGroundView VideSize:videosize BitRate:LIVE_BITRATE_1Mbps FrameRate:LIVE_VIDEO_DEF_FRAMERATE highQuality:true];
        [[LiveVideoCoreSDK sharedinstance] connect];
        
        [LiveVideoCoreSDK sharedinstance].micGain = 5;
        
        [self.view addSubview:_MicSlider];
        [self.view addSubview:_ExitButton];
        [self.view addSubview:_RtmpStatusLabel];
        [self.view addSubview:_FilterButton];
        [self.view addSubview:_CameraChangeButton];
        
    });
    
}

- (void)OnExitClicked:(UIButton *)sender {
    
    [[LiveVideoCoreSDK sharedinstance] disconnect];
    [[LiveVideoCoreSDK sharedinstance] LiveRelease];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)OnFilterclicked:(UIButton *)sender {
    
    NSArray *shareAry = @[@{kXMNShareImage:@"original_Image",
                            kXMNShareHighlightImage:@"original_Image",
                            kXMNShareTitle:@"原始"},
                          @{kXMNShareImage:@"beauty_Image",
                            kXMNShareHighlightImage:@"beauty_Image",
                            kXMNShareTitle:@"美颜"},
                          @{kXMNShareImage:@"fugu_Image",
                            kXMNShareHighlightImage:@"fugu_Image",
                            kXMNShareTitle:@"复古"},
                          @{kXMNShareImage:@"black_Image",
                            kXMNShareHighlightImage:@"black_Image",
                            kXMNShareTitle:@"黑白"},
                          @{kXMNShareImage:@"original_Image",
                            kXMNShareHighlightImage:@"original_Image",
                            kXMNShareTitle:@"美颜0"},
                          @{kXMNShareImage:@"original_Image",
                            kXMNShareHighlightImage:@"original_Image",
                            kXMNShareTitle:@"美颜1"},
                          @{kXMNShareImage:@"original_Image",
                            kXMNShareHighlightImage:@"original_Image",
                            kXMNShareTitle:@"美颜2"},
                          @{kXMNShareImage:@"original_Image",
                            kXMNShareHighlightImage:@"original_Image",
                            kXMNShareTitle:@"美颜3"}
                          ];
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 36)];
    headerView.backgroundColor = [UIColor clearColor];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(16, 21, headerView.frame.size.width-32, 15)];
    label.textColor = [UIColor colorWithRed:94/255.0 green:94/255.0 blue:94/255.0 alpha:1.0];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:15];
    label.text = @"滤镜";
    [headerView addSubview:label];
    
    _FilterMenu = [[XMNShareView alloc] init];
    _FilterMenu.headerView = headerView;
    [_FilterMenu setSelectedBlock:^(NSUInteger tag, NSString *title) {
        
        switch (tag) {
            case 0:
                [[LiveVideoCoreSDK sharedinstance] setFilter:LIVE_FILTER_ORIGINAL];
                break;
            case 1:
                [[LiveVideoCoreSDK sharedinstance] setFilter:LIVE_FILTER_BEAUTY];
                break;
            case 2:
                [[LiveVideoCoreSDK sharedinstance] setFilter:LIVE_FILTER_ANTIQUE];
                break;
            case 3:
                [[LiveVideoCoreSDK sharedinstance] setFilter:LIVE_FILTER_BLACK];
                break;
            case 4:
                [[LiveVideoCoreSDK sharedinstance] setFilter:LIVE_FILTER_DEFINE0];
                break;
            case 5:
                [[LiveVideoCoreSDK sharedinstance] setFilter:LIVE_FILTER_DEFINE1];
                break;
            case 6:
                [[LiveVideoCoreSDK sharedinstance] setFilter:LIVE_FILTER_DEFINE2];
                break;
            case 7:
                [[LiveVideoCoreSDK sharedinstance] setFilter:LIVE_FILTER_DEFINE3];
                break;
            default:
                break;
        }
        
    }];
    
    [_FilterMenu setupShareViewWithItems:shareAry];
    
    [_FilterMenu showUseAnimated:YES];
    
}

- (void)OnCameraChangeClicked:(UIButton *)sender {
    
    _bCameraFrontFlag = !_bCameraFrontFlag;
    [[LiveVideoCoreSDK sharedinstance] setCameraFront:_bCameraFrontFlag];
    if (_bCameraFrontFlag) {
        
        [_CameraChangeButton setTitle:@"前置镜头" forState:UIControlStateNormal];
    }else {
        
        [_CameraChangeButton setTitle:@"后置镜头" forState:UIControlStateNormal];
    }
}

- (void)dealSingleTap:(UITapGestureRecognizer *)recoginzer {
    
    CGPoint point = [recoginzer locationInView:self.view];
    [[LiveVideoCoreSDK sharedinstance] focuxAtPoint:point];
    [self runBoxAnimationOnView:_focusBox point:point];
}

- (void)runBoxAnimationOnView:(UIView *)view point:(CGPoint)point {
    
    view.center = point;
    view.hidden = NO;
    [UIView animateWithDuration:0.2f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        view.layer.transform = CATransform3DMakeScale(0.5, 0.5, 1.0);
        
    } completion:^(BOOL finished) {
        
        double delayInSeconds = 0.5f;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            view.hidden = YES;
            view.transform = CGAffineTransformIdentity;
        });
        
    }];
    
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    
    if (self.IsHorizontal) {
        
        bool bRet = ((toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft) || (toInterfaceOrientation == UIInterfaceOrientationLandscapeRight));

        return bRet;
        
    }else {

        return false;
    }
}

-(UIInterfaceOrientationMask)supportedInterfaceOrientations {
    
    if (self.IsHorizontal) {
        
        return UIInterfaceOrientationLandscapeRight|UIInterfaceOrientationLandscapeLeft;
    }else {
        
        return UIInterfaceOrientationMaskPortrait;
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self UIInit];
    [self RtmpInit];
    
    _bCameraFrontFlag = false;

}

- (void)viewWillAppear:(BOOL)animated {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willResignActiveNotification) name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willDidBecomeActiveNotification) name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillEnterForegroundNotification) name:UIApplicationDidBecomeActiveNotification object:nil];
    
    [super viewWillAppear:animated];
}


- (void)appWillEnterForegroundNotification {
    
    if (![self hasPermissionOfCamera]) {
        
        return;
    }
    [self RtmpInit];
}

- (void)willResignActiveNotification {
    
    
}

- (void)willDidBecomeActiveNotification {
    
    if (![self hasPermissionOfCamera]) {
        return;
    }
    
    UIApplication *app = [UIApplication sharedApplication];
    
    UIBackgroundTaskIdentifier taskID;
    taskID = [app beginBackgroundTaskWithExpirationHandler:^{
        
        [app endBackgroundTask:taskID];
    }];
    
    if (taskID == UIBackgroundTaskInvalid) {
        
        return;
    }
    
    [[LiveVideoCoreSDK sharedinstance] disconnect];
    [[LiveVideoCoreSDK sharedinstance] LiveRelease];
    
    [app endBackgroundTask:taskID];
}

- (BOOL)hasPermissionOfCamera {
    
    NSString *mediaType = AVMediaTypeVideo;
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
    
    if (authStatus != AVAuthorizationStatusAuthorized) {
        return NO;
    }
    
    return YES;
}

- (void)viewDidAppear:(BOOL)animated {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillResignActiveNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

#pragma mark -rtmp status delegate:
-(void)LiveConnectionStatusChanged:(LIVE_VCSessionState)sessionState {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        switch (sessionState) {
            case LIVE_VCSessionStatePreviewStarted:
                _RtmpStatusLabel.text = @"RTMP状态：";
                break;
            case LIVE_VCSessionStateStarting:
                _RtmpStatusLabel.text = @"RTMP状态：";
                break;
            case LIVE_VCSessionStateStarted:
                _RtmpStatusLabel.text = @"RTMP状态：";
                break;
            case LIVE_VCSessionStateEnded:
                _RtmpStatusLabel.text = @"RTMP状态：";
                break;
            case LIVE_VCSessionStateError:
                _RtmpStatusLabel.text = @"RTMP状态：";
                break;
            default:
                break;
        }
    });
}


-(NSString *)slider:(ASValueTrackingSlider *)slider stringForValue:(float)value {
    
    if (slider == _MicSlider) {
        float fMicGain = value/10.0;
        [LiveVideoCoreSDK sharedinstance].micGain = fMicGain;
    }
    
    return nil;
}

-(void)sliderWillDisplayPopUpView:(ASValueTrackingSlider *)slider {
    
}

-(void)sliderWillHidePopUpView:(ASValueTrackingSlider *)slider {
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}


@end
