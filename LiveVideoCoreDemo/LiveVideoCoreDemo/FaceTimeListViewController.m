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

@end

@implementation FaceTimeListViewController

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    FaceCamViewer *viewer = [[FaceCamViewer alloc] initWithDeviceType:IPHONE3x5];
    [viewer startFaceCam];
    
    [self.bgView insertSubview:viewer belowSubview:self.tableView];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"FaceTimeList";

    self.tableView.alpha = 0.75;
    self.tableView.backgroundColor = [UIColor blackColor];
    
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
    
//    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    FiceTimeViewController *faceVC = [story instantiateViewControllerWithIdentifier:@"FiceTimeViewController"];
//    [self.navigationController pushViewController:faceVC animated:YES];
    
    LiveShowViewController *liveVC = [[LiveShowViewController alloc] init];
    liveVC.RtmpUrl = [NSURL URLWithString:@"rtmp://ossrs.net/live/123456"];
    liveVC.IsHorizontal = NO;
    [self presentViewController:liveVC animated:YES completion:nil];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}


@end
