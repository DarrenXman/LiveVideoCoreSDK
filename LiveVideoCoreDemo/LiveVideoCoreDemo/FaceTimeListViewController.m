//
//  ViewController.m
//  postssrj
//
//  Created by mac on 2017/6/3.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "FaceTimeListViewController.h"
#import "FiceTimeViewController.h"
#import "FaceCamViewer.h"
#import "LiveShowViewController.h"


@interface FaceTimeListViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) FaceCamViewer *viewer;

@end

@implementation FaceTimeListViewController

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.tableView.alpha = 0.75;
    self.tableView.backgroundColor = [UIColor blackColor];

    FaceCamViewer *viewer = [[FaceCamViewer alloc] initWithDeviceType:IPHONE3x5];
    [viewer startFaceCam];
    _viewer = viewer;
    [self.bgView insertSubview:viewer belowSubview:self.tableView];
    
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    [_viewer removeFromSuperview];
    _viewer = nil;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"FaceTimeList";

    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 44;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 10;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellID"];
    
    cell.textLabel.text = [NSString stringWithFormat:@"the %ld people", (long)indexPath.row];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.detailTextLabel.text = @"ssrj";
    cell.detailTextLabel.textColor = [UIColor whiteColor];
    cell.backgroundColor = [UIColor blackColor];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LiveShowViewController *liveVC = [story instantiateViewControllerWithIdentifier:@"LiveShowViewController"];

    liveVC.RtmpUrl = [NSURL URLWithString:@"rtmp://ossrs.net/live/123456"];
    liveVC.IsHorizontal = NO;
    
    [self presentViewController:liveVC animated:YES completion:nil];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}


@end
