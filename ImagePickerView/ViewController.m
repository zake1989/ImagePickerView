//
//  ViewController.m
//  ImagePickerView
//
//  Created by Stephen on 7/17/15.
//  Copyright (c) 2015 Zake. All rights reserved.
//

#import "ViewController.h"
#import "ImagePickerView.h"

@interface ViewController ()

@property ImagePickerView* picker;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc] init];
    self.picker = [[ImagePickerView alloc]initWithFrame:self.view.frame collectionViewLayout:layout];
    [self.view addSubview:self.picker];
}

- (void)viewWillAppear:(BOOL)animated {
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
