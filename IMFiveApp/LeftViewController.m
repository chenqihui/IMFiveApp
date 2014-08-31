//
//  LeftViewController.m
//  WYApp
//
//  Created by chen on 14-7-17.
//  Copyright (c) 2014年 chen. All rights reserved.
//

#import "LeftViewController.h"

#import "SliderViewController.h"
#import "SelectThemeViewController.h"

@interface LeftViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    NSArray *_arData;
    NSDictionary *_dicData;
    UITableView *_tableView;
}

@end

@implementation LeftViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self addObserver];
    
    _arData = @[@[@"开通会员", @"vip_shadow.png"],
                @[@"QQ钱包", @"sidebar_purse.png"],
                @[@"网上营业厅", @"sidebar_business.png"],
                @[@"个性装饰", @"sidebar_decoration.png"],
                @[@"我的收藏", @"sidebar_favorit.png"],
                @[@"我的相册", @"sidebar_album.png"],
                @[@"我的文件", @"sidebar_file.png"]];
    
    [self.view setBackgroundColor:[UIColor clearColor]];
    
    float hHeight = 90;
    UIImageView *imageBgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height/4 + 10)];
    imageBgV.tag = 18;
    [self.view addSubview:imageBgV];
    
    hHeight = imageBgV.bottom - 80;
    UIImageView *imageBgV2 = [[UIImageView alloc] initWithFrame:CGRectMake(0, hHeight, self.view.width, self.view.height - hHeight)];
    imageBgV2.tag = 19;
    [imageBgV2 setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:imageBgV2];
    
    _contentView = [[UIView alloc] initWithFrame:self.view.bounds];
    _contentView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_contentView];
    NSLog(@"%f", _contentView.layer.anchorPoint.x);
    
    UIImageView *headerIV = [[UIImageView alloc] initWithFrame:CGRectMake(25, 60, 70, 70)];
    headerIV.layer.cornerRadius = headerIV.width/2;
    headerIV.tag = 20;
    [_contentView addSubview:headerIV];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, imageBgV.bottom + 10, self.view.width, self.view.height - imageBgV.bottom - 80) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [_tableView setBackgroundColor:[UIColor clearColor]];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_contentView addSubview:_tableView];
    
    [self reloadImage];
}

- (void)backAction:(UIButton *)btn
{
    [[SliderViewController sharedSliderController] closeSideBar];
}

- (void)toNewViewbtn:(UIButton *)btn
{
    [[SliderViewController sharedSliderController] closeSideBarWithAnimate:YES complete:^(BOOL finished)
    {
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_arData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *reuseIdetify = @"left";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdetify];;
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdetify];
        [cell setBackgroundColor:[UIColor clearColor]];
        [cell.textLabel setTextColor:[UIColor whiteColor]];
        [cell setSelectionStyle:UITableViewCellSelectionStyleBlue];
    }
    
    NSArray *ar = [_arData objectAtIndex:indexPath.row];
    cell.imageView.image = [QHCommonUtil imageNamed:[ar objectAtIndex:1]];
    cell.textLabel.text = [ar objectAtIndex:0];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 47;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.row)
    {
        case 3:
        {
            SelectThemeViewController *themeVC = [[SelectThemeViewController alloc] init];
            [[SliderViewController sharedSliderController] closeSideBarWithAnimate:YES complete:^(BOOL finished)
             {
                 [[SliderViewController sharedSliderController].navigationController pushViewController:themeVC animated:YES];
             }];
            break;
        }
        default:
            [self backAction:nil];
            break;
    }
}

#pragma mark - super

- (void)reloadImage
{
    [super reloadImage];
    
    UIImageView *imageBgV = (UIImageView *)[self.view viewWithTag:18];
    UIImage *image = [QHCommonUtil imageNamed:@"sidebar_bg.jpg"];
    [imageBgV setImage:image];
    
    UIImageView *imageBgV2 = (UIImageView *)[self.view viewWithTag:19];
    UIImage *image2 = [QHCommonUtil imageNamed:@"sidebar_bg_mask.png"];
    [imageBgV2 setImage:[image2 resizableImageWithCapInsets:UIEdgeInsetsMake(image2.size.height - 1, 0, 1, 0)]];

    UIImageView *headerIV = (UIImageView *)[self.view viewWithTag:20];
    UIImage *headerI = [QHCommonUtil imageNamed:@"chat_bottom_smile_nor.png"];
    [headerIV setImage:headerI];
    
    [_tableView reloadData];
}

- (void)reloadImage:(NSNotificationCenter *)notif
{
    [self reloadImage];
}

@end
