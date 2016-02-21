//
//  ViewController.m
//  彩票转盘
//
//  Created by 王志盼 on 16/2/15.
//  Copyright © 2016年 王志盼. All rights reserved.
//

#import "ViewController.h"
#import "ZYWheelView.h"
@interface ViewController ()
@property (nonatomic, weak) ZYWheelView *wheelView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self setupWheelView];
}

- (void)setupWheelView
{
    ZYWheelView *wheelView = [ZYWheelView wheelView];
    
    wheelView.center = CGPointMake(self.view.frame.size.width * 0.5, self.view.frame.size.height * 0.5);
    [self.view addSubview:wheelView];
    self.wheelView = wheelView;
    
}

@end
