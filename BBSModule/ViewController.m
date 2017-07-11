//
//  ViewController.m
//  BBSModule
//
//  Created by Simon on 2017/6/26.
//  Copyright © 2017年 Simon. All rights reserved.
//

#import "ViewController.h"

#import "GDModuleHomeVC.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}
- (IBAction)click:(UIButton *)sender {
    GDModuleHomeVC *vc = [[UIStoryboard storyboardWithName:@"BBSPosts" bundle:nil] instantiateViewControllerWithIdentifier:@"GDModuleHome"];
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
