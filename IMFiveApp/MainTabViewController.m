//
//  HomePageViewController.m
//  IMApp
//
//  Created by chen on 14/7/20.
//  Copyright (c) 2014年 chen. All rights reserved.
//

#import "MainTabViewController.h"

#import "MessagesViewController.h"
#import "ContactsViewController.h"
#import "DynamicViewController.h"
//#import "MineViewController.h"

@interface MainTabViewController ()
{
    UITabBarController *_tabC;
}

@end

@implementation MainTabViewController

static MainTabViewController *main;

+ (MainTabViewController *)getMain
{
    return main;
}

- (id)init
{
    self = [super init];
    
    main = self;
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self addObserver];
    
    _tabC = [[UITabBarController alloc] init];
    [_tabC.tabBar setBackgroundColor:[UIColor clearColor]];
    [_tabC.view setFrame:self.view.frame];
    [self.view addSubview:_tabC.view];
    
    MessagesViewController *f = [[MessagesViewController alloc] init];
    ContactsViewController *contactsVC = [[ContactsViewController alloc] init];
    DynamicViewController *t = [[DynamicViewController alloc] init];
    
//    MineViewController *ff = [[MineViewController alloc] init];
//    UITabBarItem *ffItem = [[UITabBarItem alloc]initWithTitle:@"svip" image:nil tag:1];
//    [ffItem setImage:[UIImage imageNamed:@"tab_me_svip_nor.png"]];
//    [ffItem setSelectedImage:[UIImage imageNamed:@"tab_me_svip_press.png"]];
//    ff.tabBarItem = ffItem;
    
    _tabC.viewControllers = @[f, contactsVC, t];
    
    [self reloadImage];
//    [[UITabBarItem appearance] setTitleTextAttributes:
//        [NSDictionary dictionaryWithObjectsAndKeys:RGBA(96, 164, 222, 1), UITextAttributeTextColor, nil]
//                                             forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:
        [NSDictionary dictionaryWithObjectsAndKeys:RGBA(96, 164, 222, 1), UITextAttributeTextColor, nil]
                                             forState:UIControlStateSelected];
//    [_tabC.tabBar setTintColor:RGBA(96, 164, 222, 1)];
    
    [_tabC setSelectedIndex:1];
}

- (void)reloadImage
{
    [super reloadImage];
    
    NSString *imageName = nil;
    if (isIos7 >= 7 && __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_6_1 && [QHConfiguredObj defaultConfigure].nThemeIndex != 0)
    {
        imageName = @"tabbar_bg_ios7.png";
    }else
    {
        imageName = @"tabbar_bg.png";
    }
    [_tabC.tabBar setBackgroundImage:[QHCommonUtil imageNamed:imageName]];
    
    NSArray *ar = _tabC.viewControllers;
    NSMutableArray *arD = [NSMutableArray new];
    [ar enumerateObjectsUsingBlock:^(UIViewController *viewController, NSUInteger idx, BOOL *stop)
    {
//        UITabBarItem *item = viewController.tabBarItem;
        UITabBarItem *item = nil;
        switch (idx)
        {
            case 0:
            {
                item = [[UITabBarItem alloc] initWithTitle:@"消息" image:[[QHCommonUtil imageNamed:@"tab_recent_nor.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[QHCommonUtil imageNamed:@"tab_recent_press.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
                break;
            }
            case 1:
            {
                item = [[UITabBarItem alloc] initWithTitle:@"联系人" image:nil tag:1];
                [item setImage:[[QHCommonUtil imageNamed:@"tab_buddy_nor.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
                [item setSelectedImage:[[QHCommonUtil imageNamed:@"tab_buddy_press.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
                break;
            }
            case 2:
            {
                item = [[UITabBarItem alloc]initWithTitle:@"动态" image:nil tag:1];
                [item setImage:[[QHCommonUtil imageNamed:@"tab_qworld_nor.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
                [item setSelectedImage:[[QHCommonUtil imageNamed:@"tab_qworld_press.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
                break;
            }
        }
        viewController.tabBarItem = item;
        [arD addObject:viewController];
    }];
    _tabC.viewControllers = arD;
}

@end
