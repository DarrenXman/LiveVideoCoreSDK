//
//  LiveShowViewController.m
//  LiveVideoCoreDemo
//
//  Created by Alex.Shi on 16/3/2.
//  Copyright © 2016年 com.Alex. All rights reserved.
//

#import "LiveShowViewController.h"
#import "XMNShareMenu.h"

#import "TYVideoPlayerController.h"
#import <MediaPlayer/MediaPlayer.h>


@interface LiveShowViewController ()<UIGestureRecognizerDelegate,TYVideoPlayerControllerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *faceTimeLabel;

@property (weak, nonatomic) IBOutlet UIButton *ExitButton;

@property (weak, nonatomic) IBOutlet UIButton *CameraChangeButton;

@property (weak, nonatomic) IBOutlet UIButton *FilterButton;

@property (weak, nonatomic) IBOutlet UIView *videoView;

@property (weak, nonatomic) TYVideoPlayerController *playerController;

@end


@implementation LiveShowViewController
{
    UIView* _AllBackGroudView;
    UILabel*  _RtmpStatusLabel;
    
    XMNShareView* _FilterMenu;
    ASValueTrackingSlider* _MicSlider;
    Boolean _bCameraFrontFlag;
    UIView *_focusBox;
    CGRect  _videoFrame;
    
}
@synthesize RtmpUrl;

-(void) UIInit{
    
    _ExitButton.layer.cornerRadius = 30.0;
    _ExitButton.clipsToBounds = YES;
    _FilterButton.layer.cornerRadius = 30.0;
    _FilterButton.clipsToBounds = YES;
    _CameraChangeButton.layer.cornerRadius = 30.0;
    _CameraChangeButton.clipsToBounds = YES;
    
    double fScreenW = [UIScreen mainScreen].bounds.size.width;
    double fScreenH = [UIScreen mainScreen].bounds.size.height;
    if (self.IsHorizontal) {
        double fTmp = fScreenH;
        fScreenH = fScreenW;
        fScreenW = fTmp;
    }
    
    _AllBackGroudView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, fScreenW, fScreenH)];
    [self.view addSubview:_AllBackGroudView];
    
    float fRtmpStatusLabelW = 120;
    float fRtmpStatusLabelH = 20;
    float fRtmpStatusLabelX = 10;
    float fRtmpStatusLabelY = 30;
    _RtmpStatusLabel = [[UILabel alloc] initWithFrame:CGRectMake(fRtmpStatusLabelX, fRtmpStatusLabelY, fRtmpStatusLabelW, fRtmpStatusLabelH)];
    _RtmpStatusLabel.backgroundColor = [UIColor lightGrayColor];
    _RtmpStatusLabel.layer.masksToBounds = YES;
    _RtmpStatusLabel.layer.cornerRadius  = 5;
    _RtmpStatusLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:10];
    [_RtmpStatusLabel setTextColor:[UIColor whiteColor]];
    _RtmpStatusLabel.text = @"网络状态: 未连接";
    [self.view addSubview:_RtmpStatusLabel];
    
    float fMicSliderX = 20;
    float fMicSliderW = fScreenW - fMicSliderX*2;
    float fMicSliderH = 30;
    _MicSlider = [[ASValueTrackingSlider alloc] initWithFrame:CGRectMake(fMicSliderX, fScreenH - 130, fMicSliderW, fMicSliderH)];
    _MicSlider.maximumValue = 10.0;
    _MicSlider.popUpViewCornerRadius = 4;
    [_MicSlider setMaxFractionDigitsDisplayed:0];
    _MicSlider.popUpViewColor = [UIColor colorWithHue:0.55 saturation:0.8 brightness:0.9 alpha:0.7];
    _MicSlider.font = [UIFont fontWithName:@"GillSans-Bold" size:18];
    _MicSlider.textColor = [UIColor colorWithHue:0.55 saturation:1.0 brightness:0.5 alpha:1];
    _MicSlider.popUpViewWidthPaddingFactor = 1.7;
    _MicSlider.delegate = self;
    _MicSlider.dataSource = self;
    _MicSlider.value = 5;
    [self.view addSubview:_MicSlider];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dealSingleTap:)];
    [self.view addGestureRecognizer:singleTap];
    
    _focusBox = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 150, 150)];
    _focusBox.backgroundColor = [UIColor clearColor];
    _focusBox.layer.borderColor = [UIColor greenColor].CGColor;
    _focusBox.layer.borderWidth = 5.0f;
    _focusBox.hidden = YES;
    [self.view addSubview:_focusBox];
    
    [self.view addSubview:_nameLabel];
    [self.view addSubview:_faceTimeLabel];
    
    
    UITapGestureRecognizer *videoViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(videoViewTap:)];
    videoViewTap.delegate = self;
    [_videoView addGestureRecognizer:videoViewTap];
    _videoView.tag = 100;
    _videoFrame = _videoView.frame;
    _videoView.userInteractionEnabled = YES;
    _videoView.backgroundColor = [UIColor clearColor];
    
    [self addVideoPlayerController];
    
    [self.view addSubview:_videoView];
}

- (void)addVideoPlayerController
{
    TYVideoPlayerController *playerController = [[TYVideoPlayerController alloc]init];
    [playerController.view setFrame:CGRectMake(0, 0, _videoFrame.size.width, _videoFrame.size.height)];
    //playerController.shouldAutoplayVideo = NO;
    playerController.delegate = self;
    [self addChildViewController:playerController];
    [_videoView addSubview:playerController.view];
    _playerController = playerController;
    
//    直播
    NSURL *streamURL = [NSURL URLWithString:@"http://live.hkstv.hk.lxdns.com/live/hks/playlist.m3u8"];

//    点播
//    NSURL *streamURL = [NSURL URLWithString:@"http://baobab.wdjcdn.com/1442142801331138639111.mp4"];
    
    [_playerController loadVideoWithStreamURL:streamURL];

}


-(void) videoViewTap:(UITapGestureRecognizer *)tap {
    
    if (tap.view.tag == 100) {
        tap.view.tag = 111;
        
        [UIView animateWithDuration:.5 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
           
            [_videoView setFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
            
            [_playerController.view setFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];

            
            //隐藏屏幕上的所有控件
            _nameLabel.alpha = 0.0;
            _faceTimeLabel.alpha = 0.0;
            _MicSlider.alpha = 0.0;
            _CameraChangeButton.alpha = 0.0;
            _FilterButton.alpha = 0.0;
            _ExitButton.alpha = 0.0;
            
        } completion:^(BOOL finished) {
            
            
        }];
        
    }
    else if (tap.view.tag == 111) {
       
        [_videoView setFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];

        [_playerController.view setFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];

        tap.view.tag = 100;
        
        [UIView animateWithDuration:.5 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            
            [_videoView setFrame:_videoFrame];
            [_playerController.view setFrame:CGRectMake(0, 0, _videoFrame.size.width, _videoFrame.size.height)];
            //显示屏幕上的所有控件
            
            _nameLabel.alpha = 1.0;
            _faceTimeLabel.alpha = 1.0;
            _MicSlider.alpha = 1.0;
            _CameraChangeButton.alpha = 1.0;
            _FilterButton.alpha = 1.0;
            _ExitButton.alpha = 1.0;
            
        } completion:^(BOOL finished) {
            
        }];
    }
    
    NSLog(@"videoViewTap");
}
-(void) RtmpInit{
    dispatch_async(dispatch_get_main_queue(), ^{
        CGSize videosize;
        
        if (self.IsHorizontal) {
            videosize = LIVE_VIEDO_SIZE_HORIZONTAL_D1;
        }else{
            videosize = LIVE_VIEDO_SIZE_D1;
        }
        [[LiveVideoCoreSDK sharedinstance] LiveInit:RtmpUrl Preview:_AllBackGroudView VideSize:videosize BitRate:LIVE_BITRATE_300Kbps FrameRate:LIVE_VIDEO_DEF_FRAMERATE highQuality:true];
        [LiveVideoCoreSDK sharedinstance].delegate = self;
        [[LiveVideoCoreSDK sharedinstance] connect];
        NSLog(@"Rtmp[%@] is connecting", self.RtmpUrl);
        
        [LiveVideoCoreSDK sharedinstance].micGain = 5;

        [self.view addSubview:_MicSlider];
        [self.view addSubview:_ExitButton];
        [self.view addSubview:_RtmpStatusLabel];
        [self.view addSubview:_FilterButton];
        [self.view addSubview:_CameraChangeButton];
    });
}

- (IBAction)OnCameraChangeClicked:(id)sender {
    
    _bCameraFrontFlag = !_bCameraFrontFlag;
    [[LiveVideoCoreSDK sharedinstance] setCameraFront:_bCameraFrontFlag];
    if (_bCameraFrontFlag) {
        [_CameraChangeButton setTitle:@"前置镜头" forState:UIControlStateNormal];
    }else{
        [_CameraChangeButton setTitle:@"后置镜头" forState:UIControlStateNormal];
    }
}

-(IBAction)OnFilterClicked:(id)sender{
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
                            kXMNShareHighlightImage:@"fugu_Image",
                            kXMNShareTitle:@"黑白"},
                          ];
    //自定义头部
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 36)];
    headerView.backgroundColor = [UIColor clearColor];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(16, 21, headerView.frame.size.width-32, 15)];
    label.textColor = [UIColor colorWithRed:94/255.0 green:94/255.0 blue:94/255.0 alpha:1.0];;
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:15];
    label.text = @"滤镜:";
    [headerView addSubview:label];
    
    _FilterMenu = [[XMNShareView alloc] init];
    //设置头部View 如果不设置则不显示头部
    _FilterMenu.headerView = headerView;
    [_FilterMenu setSelectedBlock:^(NSUInteger tag, NSString *title) {
        NSLog(@"\ntag :%lu  \ntitle :%@",(unsigned long)tag,title);

        switch(tag) {
            case 0://原图像
                NSLog(@"设置无滤镜...");
                [[LiveVideoCoreSDK sharedinstance] setFilter:LIVE_FILTER_ORIGINAL];
                break;
            case 1://美颜
                NSLog(@"设置美艳滤镜...");
                [[LiveVideoCoreSDK sharedinstance] setFilter:LIVE_FILTER_BEAUTY];
                break;
            case 2://复古
                NSLog(@"设置复古滤镜...");
                [[LiveVideoCoreSDK sharedinstance] setFilter:LIVE_FILTER_ANTIQUE];
                break;
            case 3://黑白
                NSLog(@"设置黑白滤镜...");
                [[LiveVideoCoreSDK sharedinstance] setFilter:LIVE_FILTER_BLACK];
                break;
            default:
                break;
        }
    }];
    
    //计算高度 根据第一行显示的数量和总数,可以确定显示一行还是两行,最多显示2行
    [_FilterMenu setupShareViewWithItems:shareAry];
    
    [_FilterMenu showUseAnimated:YES];
}

-(IBAction) OnExitClicked:(id)sender{
    NSLog(@"Rtmp[%@] is ended", self.RtmpUrl);
    [[LiveVideoCoreSDK sharedinstance] disconnect];
    [[LiveVideoCoreSDK sharedinstance] LiveRelease];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    if(self.IsHorizontal){
        bool bRet = ((toInterfaceOrientation == UIInterfaceOrientationLandscapeRight) || (toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft));
        return bRet;
    }else{
        return false;
    }
}
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    if(self.IsHorizontal){
        return UIInterfaceOrientationMaskLandscapeRight|UIInterfaceOrientationMaskLandscapeLeft;
    }else{
        return UIInterfaceOrientationMaskPortrait;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self UIInit];
    
    [self RtmpInit];
    
    _bCameraFrontFlag = false;
}
- (void) viewWillAppear:(BOOL)animated{
    NSLog(@"CameraViewController: viewWillAppear");
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(WillResignActiveNotification) name:UIApplicationWillResignActiveNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(WillDidBecomeActiveNotification) name:UIApplicationDidBecomeActiveNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillEnterForegroundNotification) name:UIApplicationDidBecomeActiveNotification object:nil];
    
    [super viewDidAppear:YES];
}

- (void) appWillEnterForegroundNotification{
    NSLog(@"trigger event when will enter foreground.");
    if (![self hasPermissionOfCamera]) {
        return;
    }
    [self RtmpInit];

}
- (void)WillDidBecomeActiveNotification{
    NSLog(@"CameraViewController: WillDidBecomeActiveNotification");

}

- (void)WillResignActiveNotification{
    NSLog(@"LiveShowViewController: WillResignActiveNotification");
    
    if (![self hasPermissionOfCamera]) {
        return;
    }
    //得到当前应用程序的UIApplication对象
    UIApplication *app = [UIApplication sharedApplication];
    
    //一个后台任务标识符
    UIBackgroundTaskIdentifier taskID = 0;
    taskID = [app beginBackgroundTaskWithExpirationHandler:^{
        //如果系统觉得我们还是运行了太久，将执行这个程序块，并停止运行应用程序
        [app endBackgroundTask:taskID];
    }];
    //UIBackgroundTaskInvalid表示系统没有为我们提供额外的时候
    if (taskID == UIBackgroundTaskInvalid) {
        NSLog(@"Failed to start background task!");
        return;
    }
    
    //[[SCCaptureManager sharedManager] disconnect];
    [[LiveVideoCoreSDK sharedinstance] disconnect];
    [[LiveVideoCoreSDK sharedinstance] LiveRelease];
    
    //告诉系统我们完成了
    [app endBackgroundTask:taskID];
}
- (BOOL)hasPermissionOfCamera
{
    NSString *mediaType = AVMediaTypeVideo;
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
    if(authStatus != AVAuthorizationStatusAuthorized){
        
        NSLog(@"相机权限受限");
        return NO;
    }
    return YES;
}
-(void) viewDidDisappear:(BOOL)animated{
    NSLog(@"CameraViewController: viewDidDisappear");
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillResignActiveNotification object:nil];//删除去激活界面的回调
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];//删除激活界面的回调
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

//rtmp status delegate:
- (void) LiveConnectionStatusChanged: (LIVE_VCSessionState) sessionState{
    
    _RtmpStatusLabel.alpha = 0.1;
    [UIView animateWithDuration:1.0 animations:^{
       
        _RtmpStatusLabel.alpha = 1.0;
        
    } completion:^(BOOL finished) {
        
        
    }];
    _RtmpStatusLabel.hidden = NO;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        switch (sessionState) {
            case LIVE_VCSessionStatePreviewStarted:
                
            {
                
                _RtmpStatusLabel.text = @"网络状态: 预览未连接";

                [UIView animateWithDuration:1.0 animations:^{
                    
                    _RtmpStatusLabel.alpha = 0.0;
                    
                } completion:^(BOOL finished) {
                    
                }];
                
            }
                
                break;
            case LIVE_VCSessionStateStarting:
                
            {
                _RtmpStatusLabel.text = @"网络状态: 连接中...";
                
                [UIView animateWithDuration:1.0 animations:^{
                    
                    _RtmpStatusLabel.alpha = 0.0;
                    
                } completion:^(BOOL finished) {
                    
                }];
            }
                break;
            case LIVE_VCSessionStateStarted:
                
            {
                _RtmpStatusLabel.text = @"网络状态: 已连接";
                
                [UIView animateWithDuration:1.0 animations:^{
                    
                    _RtmpStatusLabel.alpha = 0.0;
                    
                } completion:^(BOOL finished) {
                    
                }];
            }
                break;
            case LIVE_VCSessionStateEnded:
            
            {
                _RtmpStatusLabel.text = @"网络状态: 未连接";
                
                [UIView animateWithDuration:1.0 animations:^{
                    
                    _RtmpStatusLabel.alpha = 0.0;
                    
                } completion:^(BOOL finished) {
                    
                }];
            }
                break;
            case LIVE_VCSessionStateError:
            
            {
                _RtmpStatusLabel.text = @"网络状态: 错误";
             
                [UIView animateWithDuration:1.0 animations:^{
                    
                    _RtmpStatusLabel.alpha = 0.0;
                    
                } completion:^(BOOL finished) {
                    
                }];
            }
                break;
            default:
                break;
        }
    });
}

- (NSString *)slider:(ASValueTrackingSlider *)slider stringForValue:(float)value{
    if (slider == _MicSlider) {
        float fMicGain = value/10.0;
        NSLog(@"mic slider:%0.2f, %0.2f", value, fMicGain);
        [LiveVideoCoreSDK sharedinstance].micGain = fMicGain;
    }
    
    return nil;
}

- (void)sliderWillDisplayPopUpView:(ASValueTrackingSlider *)slider{
    NSLog(@"sliderWillDisplayPopUpView...");
    return;
}

- (void)sliderWillHidePopUpView:(ASValueTrackingSlider *)slider{
    NSLog(@"sliderWillHidePopUpView...");
}

- (void)dealSingleTap:(UITapGestureRecognizer *)tap
{
    CGPoint point = [tap locationInView:self.view];
    [[LiveVideoCoreSDK sharedinstance] focuxAtPoint:point];
    [self runBoxAnimationOnView:_focusBox point:point];
}
//对焦的动画效果
- (void)runBoxAnimationOnView:(UIView *)view point:(CGPoint)point {
    view.center = point;
    view.hidden = NO;
    [UIView animateWithDuration:0.2f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         view.layer.transform = CATransform3DMakeScale(0.5, 0.5, 1.0);
                     }
                     completion:^(BOOL complete) {
                         double delayInSeconds = 0.5f;
                         dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
                         dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                             view.hidden = YES;
                             view.transform = CGAffineTransformIdentity;
                         });
                     }];
}
@end
