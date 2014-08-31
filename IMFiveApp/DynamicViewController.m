//
//  DynamicViewController.m
//  IMApp
//
//  Created by chen on 14-7-21.
//  Copyright (c) 2014年 chen. All rights reserved.
//

#import "DynamicViewController.h"

@interface DynamicViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    UITableView *_tableV;
    NSMutableArray *_arData;
}

@end

@implementation DynamicViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self addObserver];
    
    [self createNavWithTitle:@"动态" createMenuItem:^UIView *(int nIndex)
    {
        return nil;
    }];
    
    _tableV = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.navView.frame), CGRectGetWidth(self.view.frame), self.view.height - self.navView.bottom - self.tabBarController.tabBar.height) style:UITableViewStyleGrouped];
    _tableV.dataSource = self;
    _tableV.delegate = self;
    [self.view addSubview:_tableV];
    
    [self initData];
}

- (void)initData
{
    __async_opt__, ^
    {
        _arData = [NSMutableArray new];
        
        NSArray *ar1 = @[@"好友动态"];
        NSArray *ar2 = @[@"游戏", @"福利", @"阅读"];
        NSArray *ar3 = @[@"文件/照片 助手", @"吃喝玩乐", @"扫一扫", @"热门活动", @"腾讯新闻"];
        NSArray *ar4 = @[@"附近的人", @"附近的群", @"兴趣部落"];
        
        [_arData addObject:ar1];
        [_arData addObject:ar2];
        [_arData addObject:ar3];
        [_arData addObject:ar4];
        
        __async_main__, ^
        {
            [_tableV reloadData];
        });
    });
}

#pragma mark - action

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_arData count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[_arData objectAtIndex:section] count];
}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    return [_arKey objectAtIndex:section];
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *reuseIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.textLabel.text = [[_arData objectAtIndex:[indexPath section]] objectAtIndex:indexPath.row];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 19;
    }
    return 18;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
