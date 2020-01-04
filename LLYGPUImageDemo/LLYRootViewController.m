//
//  LLYRootViewController.m
//  LLYGPUImageDemo
//
//  Created by lly on 2018/8/28.
//  Copyright © 2018年 lly. All rights reserved.
//

#import "LLYRootViewController.h"
#import "LLYShowImageViewController.h"
#import "LLYUseCameraViewController.h"
#import "LLYBeautifulFilterViewController.h"
#import "LLYTikTokViewController.h"
#import "LLYMovieWatermarkViewController.h"
#import "LLYViewWatermarkViewController.h"
#import "LLYVideoBlendViewController.h"

@interface LLYRootViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *mTableView;
@property (nonatomic, strong) NSMutableArray *dataSourceArray;

@end

@implementation LLYRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"LLYGPUImage";
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.mTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
    self.mTableView.estimatedRowHeight = 60;
    self.mTableView.rowHeight = UITableViewAutomaticDimension;
    
    self.dataSourceArray = [NSMutableArray arrayWithArray:@[@"显示带滤镜的图片",@"开启带滤镜的摄像头",@"自定义美颜滤镜",@"自定义抖音滤镜",@"视频水印",@"文字图片水印",@"视频叠加"]];
    [self.mTableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataSourceArray.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class])];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = self.dataSourceArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.row) {
        case 0:{
            LLYShowImageViewController *vc = [[LLYShowImageViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
            
        case 1:{
            LLYUseCameraViewController *vc = [[LLYUseCameraViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
            
        case 2:{
            LLYBeautifulFilterViewController *vc = [[LLYBeautifulFilterViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
            
        case 3:{
            LLYTikTokViewController *vc = [[LLYTikTokViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
            
        case 4:{
            LLYMovieWatermarkViewController *vc = [[LLYMovieWatermarkViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
            
        case 5:{
            LLYViewWatermarkViewController *vc = [[LLYViewWatermarkViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
            
        case 6:{
            LLYVideoBlendViewController *vc = [[LLYVideoBlendViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
            
        default:
            break;
    }
    
}

@end
