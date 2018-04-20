//
//  ViewController.m
//  JellyButton
//
//  Created by JT Ma on 20/04/2018.
//  Copyright © 2018 JT. All rights reserved.
//

#import "ViewController.h"
#import "JellyButton.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    JellyButton *btn = [[JellyButton alloc] initWithFrame:CGRectMake(50, 50, 100, 100)];
    btn.backgroundColor = [UIColor redColor];
    [self.view addSubview:btn];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
