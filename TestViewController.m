//
//  TestViewController.m
//  IMFiveApp
//
//  Created by roshan on 14-11-10.
//  Copyright (c) 2014年 chen. All rights reserved.
//

#import "TestViewController.h"

@interface TestViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property (strong, nonatomic) UIImagePickerController *imagePicker;

@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(140, 200, 50, 40)];
    button.backgroundColor = [UIColor lightGrayColor];
    [button setTitle:@"相册" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(btnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    _imagePicker = [[UIImagePickerController alloc] init];
    _imagePicker.delegate = self;
    _imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    _imagePicker.allowsEditing = YES;
}

- (void)btnClicked
{
    NSLog(@"_imagePicker.delegate = %@",_imagePicker.delegate);
    [self.view.window.rootViewController  presentViewController:_imagePicker animated:YES completion:^{
        NSLog(@"_imagePicker.delegate2 = %@",_imagePicker.delegate);
    }];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSLog(@"选中");
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    NSLog(@"取消");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
