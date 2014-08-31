//
//  MessagesViewController.m
//  IMApp
//
//  Created by chen on 14-7-21.
//  Copyright (c) 2014年 chen. All rights reserved.
//

#import "MessagesViewController.h"

#import "MainTabViewController.h"
#import "RectViewForMessage.h"

@interface MessagesViewController ()<UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate,UISearchDisplayDelegate, RectViewForMessageDelegate>
{
    UISearchBar *_searchB;
    UITableView *_tableV;
    NSMutableArray *_arData;
    UISegmentedControl *_selectTypeSegment;
    UISearchDisplayController *_searchDisplayC;
    
    UIView *_maskV;
    RectViewForMessage *_menuV;
    NSArray *_arMenu;
}

@end

@implementation MessagesViewController

- (void)viewDidDisappear:(BOOL)animated
{
    UIButton *btn = (UIButton *)self.rightV;
    if (btn.selected)
    {
        [btn setUserInteractionEnabled:NO];
        [btn setSelected:!btn.selected];
        [self showMenuWithBool:btn.selected complete:^()
         {
             [btn setUserInteractionEnabled:YES];
         }];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self addObserver];
    
    [self createNavWithTitle:@"消息" createMenuItem:^UIView *(int nIndex)
     {
         if (nIndex == 1)
         {
             UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
             UIImage *i = [QHCommonUtil imageNamed:@"menu_icon_bulb.png"];
             [btn setImage:i forState:UIControlStateNormal];
             [btn setFrame:CGRectMake(self.navView.width - i.size.width - 10, (self.navView.height - i.size.height)/2, i.size.width, i.size.height)];
             [btn setImage:[QHCommonUtil imageNamed:@"menu_icon_bulb_pressed.png"] forState:UIControlStateSelected];
             btn.tag = 989;
             [btn addTarget:self action:@selector(showMenu:) forControlEvents:UIControlEventTouchUpInside];
             
             return btn;
         }
         return nil;
     }];
    _searchB = [[UISearchBar alloc] initWithFrame:CGRectMake(0, self.navView.bottom, self.view.width, 44)];
//    [_searchB setShowsCancelButton:YES animated:YES];
    [_searchB setPlaceholder:@"搜索"];
    [_searchB setSearchBarStyle:UISearchBarStyleDefault];
//    [self.view addSubview:_searchB];
    
//    _selectTypeSegment = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"消息", @"通话", nil]];
//    [_selectTypeSegment setFrame:CGRectMake((CGRectGetWidth(self.view.frame) - 120)/2, 8, 120, 28)];
//    [_selectTypeSegment setSelectedSegmentIndex:0];
//    [self.navView addSubview:_selectTypeSegment];
    
    _tableV = [[UITableView alloc] initWithFrame:CGRectMake(0, _searchB.bottom, CGRectGetWidth(self.view.frame), self.view.height - _searchB.bottom - self.tabBarController.tabBar.height) style:UITableViewStylePlain];
    _tableV.dataSource = self;
    _tableV.delegate = self;
    [self.view addSubview:_tableV];
    
    _searchDisplayC = [[UISearchDisplayController alloc] initWithSearchBar:_searchB contentsController:self];
//    [searchDisplayC setActive:YES animated:YES];
    _searchDisplayC.active = NO;
    _searchDisplayC.delegate = self;
    _searchDisplayC.searchResultsDataSource =self;
    _searchDisplayC.searchResultsDelegate =self;
    [self.view addSubview:_searchDisplayC.searchBar];
    
    _maskV = [[UIView alloc] initWithFrame:CGRectMake(0, self.navView.bottom, self.view.width, self.view.height - self.navView.bottom - self.tabBarController.tabBar.height)];
    [_maskV setClipsToBounds:YES];
    [self.view addSubview:_maskV];
    [_maskV setHidden:YES];
    
    UIView *bg = [[UIView alloc] initWithFrame:_maskV.bounds];
    [bg setBackgroundColor:[UIColor blackColor]];
    [bg setAlpha:0.5];
    [_maskV addSubview:bg];
    
    UITapGestureRecognizer *tSM = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showMenuByTap:)];
    [bg addGestureRecognizer:tSM];
    
    _arMenu = @[@[@"建讨论组", @"menu_icon_createDiscuss.png"],
                @[@"多人通话", @"menu_icon_groupaudio.png"],
                @[@"共享照片", @"menu_icon_camera.png"],
                @[@"扫一扫", @"menu_icon_QR.png"]];
    
    _menuV = [[RectViewForMessage alloc] initWithFrame:CGRectMake(0, -75, self.view.width, 75) ar:_arMenu showSpera:NO bg:@"menu_bg_pressed.png"];
    _menuV.delegate = self;
    [_maskV addSubview:_menuV];
    
    [self initData];
}

- (void)initData
{
    __async_opt__, ^
    {
        _arData = [NSMutableArray new];
        
        [_arData addObject:@"好友A"];
        [_arData addObject:@"陌生人C"];
        [_arData addObject:@"我的电脑"];
        [_arData addObject:@"群B"];
        
        __async_main__, ^
        {
            [_tableV reloadData];
        });
    });
}

- (void)showMenuWithBool:(BOOL)bShow complete:(void(^)())complete
{
    if (bShow)
    {
        [_maskV setHidden:NO];
        [UIView animateWithDuration:0.3 animations:^
         {
             _menuV.top = 0;
         } completion:^(BOOL finished)
         {
             complete();
         }];
    }else
    {
        [UIView animateWithDuration:0.3 animations:^
         {
             _menuV.top = -_menuV.height;
         } completion:^(BOOL finished)
         {
             [_maskV setHidden:YES];
             complete();
         }];
    }
}

#pragma mark - action

- (void)showMenu:(UIButton *)btn
{
    [btn setUserInteractionEnabled:NO];
    [btn setSelected:!btn.selected];
    
    [self showMenuWithBool:btn.selected complete:^()
    {
        [btn setUserInteractionEnabled:YES];
    }];
}

- (void)showMenuByTap:(UITapGestureRecognizer *)tap
{
    UIButton *btn = (UIButton *)self.rightV;
    [btn setUserInteractionEnabled:NO];
    [btn setSelected:!btn.selected];
    [self showMenuWithBool:btn.selected complete:^()
     {
         [btn setUserInteractionEnabled:YES];
     }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == _searchDisplayC.searchResultsTableView)
    {
        return 0;
    }
    return [_arData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *reuseIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = [_arData objectAtIndex:indexPath.row];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 62;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UISearchDisplayDelegate

- (void) searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller
{
    [UIView animateWithDuration:0.2 animations:^
     {
         self.navView.top -= 64;
         _searchB.top -= 44;
         _tableV.top -= 44;
     }completion:^(BOOL finished)
    {
        [self.navView setHidden:YES];
        _tableV.height += 44;
     }];
    
    controller.searchBar.showsCancelButton = YES;
    for(UIView *subView in [[controller.searchBar.subviews objectAtIndex:0] subviews])
    {
        if([subView isKindOfClass:UIButton.class])
        {
            [(UIButton*)subView setTitle:@"取消" forState:UIControlStateNormal];
        }
    }
}

- (void) searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller
{
    [self.navView setHidden:NO];
    [UIView animateWithDuration:0.2 animations:^
    {
         self.navView.top += 64;
        _searchB.top += 44;
        _tableV.top += 44;
    }completion:^(BOOL finished)
    {
        _tableV.height -= 44;
    }];
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    
    [self filteredListContentForSearchText:searchString scope:[[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
//    [self filterContentForSearchText:searchString];
//
//    if ([filteredListPinYin count] == 0) {

        UITableView *tableView1 = self.searchDisplayController.searchResultsTableView;

        for( UIView *subview in tableView1.subviews )
        {
            if( [subview class] == [UILabel class] )
            {
                UILabel *lbl = (UILabel*)subview; // sv changed to subview.
                lbl.text = @"没有结果";

            }
        }
//    }
    return YES;
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption
{
    [self filteredListContentForSearchText:[self.searchDisplayController.searchBar text] scope:[[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:searchOption]];

    return YES;
}

#pragma mark Content Filtering

- (void)filteredListContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    //    if(nil==m_filteredListContent)
    //        m_filteredListContent=[NSMutableArray new];
    //    [m_filteredListContent removeAllObjects];
    //
    //    for(NSString* str in groups)
    //    {
    //        NSArray * contactSection = [contactTitles objectForKey:str];
    //        for (NSMutableDictionary *eObj in contactSection)
    //        {
    //            if ([[[eObj objectForKey:@"name"] uppercaseString] rangeOfString:[searchText uppercaseString]].length>0)
    //            {
    //                [m_filteredListContent addObject:eObj];
    //            }
    //        }
    //    }
}

#pragma mark - RectViewForMessageDelegate

- (void)press:(RectViewForMessage *)rectView index:(int)nIndex
{
}

- (void)reloadImage
{
    [super reloadImage];
    
    UIButton *btn = (UIButton *)[self.view viewWithTag:989];
    UIImage *i = [QHCommonUtil imageNamed:@"menu_icon_bulb.png"];
    [btn setImage:i forState:UIControlStateNormal];
    [btn setImage:[QHCommonUtil imageNamed:@"menu_icon_bulb_pressed.png"] forState:UIControlStateSelected];
    
    [_menuV reloadMenuImage];
}

@end
