//
//  SelectThemeViewController.m
//  IMFiveApp
//
//  Created by chen on 14-8-29.
//  Copyright (c) 2014年 chen. All rights reserved.
//

#import "SelectThemeViewController.h"

#import "SelectThemeCollectionViewCell.h"

@interface SelectThemeViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>
{
    UICollectionView *_collectionV;
    NSArray *_arData;
    
    int nSelectIndex;
}

@end

@implementation SelectThemeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self addObserver];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    [self createNavWithTitle:@"猪蹄商场" createMenuItem:^UIView *(int nIndex)
     {
         if (nIndex == 1)
         {
             UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
             [btn setFrame:CGRectMake(10, (self.navView.height - 40)/2, 60, 40)];
             [btn addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
             
             UILabel *btnL = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, btn.width - 15, btn.height)];
             [btnL setText:@"返回"];
             [btnL setTextColor:[UIColor whiteColor]];
             [btn addSubview:btnL];
             
             return btn;
         }
         return nil;
     }];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake(self.view.width/2 - 5, 90);
    flowLayout.minimumInteritemSpacing = 0;//列距
    _collectionV = [[UICollectionView alloc] initWithFrame:CGRectMake(0, self.navView.bottom + 10, self.view.width, self.view.height - self.navView.bottom - 10) collectionViewLayout:flowLayout];
    [_collectionV registerClass:[SelectThemeCollectionViewCell class] forCellWithReuseIdentifier:@"colletionCell"];
    _collectionV.backgroundColor = [UIColor clearColor];
    _collectionV.dataSource = self;
    _collectionV.delegate = self;
    [self.view addSubview:_collectionV];
    
    [self initData];
    [_collectionV reloadData];
}

- (void)initData
{
    _arData = @[@[@"默认", @"", @"theme_icon.png"],
                @[@"海洋", @"com.skin.1110", @"theme_icon_sea.png"],
                @[@"外星人", @"com.skin.1114", @"theme_icon_universe.png"],
                @[@"小黄鸭", @"com.skin.1108", @"theme_icon_yellowduck.png"],
                @[@"企鹅", @"com.skin.1098", @"theme_icon_penguin.png"]];
}

#pragma mark - action

- (void)backAction:(UIButton *)btn
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [_arData count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *reuseIdetify = @"colletionCell";
    SelectThemeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdetify forIndexPath:indexPath];
    
    [cell setDataForView:[_arData objectAtIndex:indexPath.row] index:indexPath];
    
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    NSArray *ar = [_arData objectAtIndex:indexPath.row];
    [QHConfiguredObj defaultConfigure].nThemeIndex = indexPath.row;
    [QHConfiguredObj defaultConfigure].themefold = [ar objectAtIndex:1];
    [_collectionV reloadData];
    
    if ([ar objectAtIndex:1] != nil && ((NSString *)[ar objectAtIndex:1]).length > 0)
        [QHCommonUtil unzipFileToDocument:[ar objectAtIndex:1]];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:RELOADIMAGE object:nil];
}

- (void)reloadImage:(NSNotificationCenter *)notif
{
    [super reloadImage:notif];
}

@end
