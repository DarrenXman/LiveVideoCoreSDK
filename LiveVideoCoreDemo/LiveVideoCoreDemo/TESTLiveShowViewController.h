//
//  TESTLiveShowViewController.h
//  LiveVideoCoreDemo
//
//  Created by mac on 2017/2/28.
//  Copyright © 2017年 com.Alex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LiveVideoCoreSDK.h"
#import "ASValueTrackingSlider.h"


@interface TESTLiveShowViewController : UIViewController<LIVEVCSessionDelegate, ASValueTrackingSliderDataSource, ASValueTrackingSliderDelegate>

@property (atomic, copy) NSURL *RtmpUrl;
@property (atomic, assign) Boolean IsHorizontal;

- (void) LiveConnectionStatusChanged:(LIVE_VCSessionState) sessionState;

@end
