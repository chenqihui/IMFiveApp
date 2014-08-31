//
//  ContactsViewController.m
//  IMApp
//
//  Created by chen on 14/7/20.
//  Copyright (c) 2014年 chen. All rights reserved.
//

#import "ContactsViewController.h"

#import "MainTabViewController.h"

#import "RectViewForMessage.h"

@interface ContactsViewController ()<UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate,UISearchDisplayDelegate>
{
    UISegmentedControl *_selectTypeSegment;
    UITableView *_tableV;
    
    NSMutableArray *_arData;
    NSArray *_arKey;
    NSMutableDictionary *_dicData;
    NSMutableDictionary *_dicShowRow;
    
    UIView *_tableHeaderV;
    UISearchBar *_searchB;
    UISearchDisplayController *_searchDisplayC;
    
    NSArray *_arMenuData;
    RectViewForMessage *_menuV;
}

@end

@implementation ContactsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self addObserver];
    
    [self createNavWithTitle:@"联系人" createMenuItem:^UIView *(int nIndex)
    {
        if (nIndex == 1)
        {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//            UIImage *i = [UIImage imageNamed:@"group_right_btn.png"];
//            [btn setImage:i forState:UIControlStateNormal];
//            [btn setFrame:CGRectMake(self.navView.width - i.size.width - 10, (self.navView.height - i.size.height)/2, i.size.width, i.size.height)];
            [btn setFrame:CGRectMake(self.navView.width - 60, (self.navView.height - 40)/2, 60, 40)];
            [btn setTitle:@"添加" forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            
            return btn;
        }
        return nil;
    }];
    
//    _selectTypeSegment = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"分组", @"全部", nil]];
//    [_selectTypeSegment setFrame:CGRectMake((CGRectGetWidth(self.view.frame) - 120)/2, 8, 120, 28)];
//    [_selectTypeSegment setSelectedSegmentIndex:0];
//    [self.navView addSubview:_selectTypeSegment];
    
    _searchB = [[UISearchBar alloc] initWithFrame:CGRectMake(0, self.navView.bottom, self.view.width, 44)];
    [_searchB setPlaceholder:@"搜索"];
    [_searchB setSearchBarStyle:UISearchBarStyleDefault];
    
    _searchDisplayC = [[UISearchDisplayController alloc] initWithSearchBar:_searchB contentsController:self];
    _searchDisplayC.active = NO;
    _searchDisplayC.delegate = self;
    _searchDisplayC.searchResultsDataSource =self;
    _searchDisplayC.searchResultsDelegate =self;
    [self.view addSubview:_searchDisplayC.searchBar];
    
    _tableHeaderV = [[UIView alloc] initWithFrame:CGRectMake(0, _searchB.bottom, self.view.width, 106)];
    [_tableHeaderV setBackgroundColor:[UIColor whiteColor]];

    UIView *titleV = [[UIView alloc] initWithFrame:CGRectMake(0, _tableHeaderV.height - 25, self.view.width, 25)];
    [titleV setBackgroundColor:RGBA(235, 235, 235, 1)];
    UILabel *titleL = [[UILabel alloc] initWithFrame:titleV.bounds];
    [titleL setBackgroundColor:[UIColor clearColor]];
    [titleL setText:@"  好友分组"];
    [titleL setFont:[UIFont systemFontOfSize:13]];
    [titleV addSubview:titleL];
    [_tableHeaderV addSubview:titleV];
    
    _arMenuData = @[@[@"人脉圈", @"mulchat_header_icon_circle.png"],
                    @[@"通讯录", @"buddy_header_icon_addressBook.png"],
                    @[@"群组", @"buddy_header_icon_group.png"],
                    @[@"生活服务", @"buddy_header_icon_public.png"]];
    _menuV = [[RectViewForMessage alloc] initWithFrame:CGRectMake(0, 0, _tableHeaderV.width, _tableHeaderV.height - titleV.height) ar:_arMenuData showSpera:NO bg:@"buddy_header_nor.png"];
    [_tableHeaderV addSubview:_menuV];
    
    _tableV = [[UITableView alloc] initWithFrame:CGRectMake(0, _searchB.bottom, self.view.width, self.view.height - _searchB.bottom - self.tabBarController.tabBar.height) style:UITableViewStylePlain];
    _tableV.dataSource = self;
    _tableV.delegate = self;
    [_tableV setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:_tableV];
    
    _tableV.tableHeaderView = _tableHeaderV;
    
    [self initData];
}

- (void)initData
{
    __async_opt__, ^
    {
        _arKey = @[@"我的设备", @"朋友", @"兄弟", @"家人", @"同学", @"同事", @"长辈", @"兼职", @"陌生人", @"黑名单"];
        _dicData = [NSMutableDictionary new];
        _dicShowRow = [NSMutableDictionary new];
        
        [_arKey enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop)
         {
             NSMutableArray *ar = [NSMutableArray new];
//             srand((unsigned)time(0));  //不加这句每次产生的随机数不变
             int c = rand() % 10 + 1;
//             int c = arc4random() % 10 + 1;
             for (int i = 1; i < c; i++)
             {
                 [ar addObject:[NSString stringWithFormat:@"%d", i]];
             }
             [_dicData setObject:ar forKey:obj];
             [_dicShowRow setObject:[NSNumber numberWithBool:NO] forKey:obj];
        }];
        
        __async_main__, ^
        {
            [_tableV reloadData];
        });
    });
}

#pragma mark - action

- (void)showRow:(UIButton *)btn
{
    NSString *key = [_arKey objectAtIndex:(btn.tag - 1)];
    BOOL b = [[_dicShowRow objectForKey:key] boolValue];
    [_dicShowRow setObject:[NSNumber numberWithBool:!b] forKey:key];
    [_tableV reloadSections:[NSIndexSet indexSetWithIndex:(btn.tag - 1)] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == _searchDisplayC.searchResultsTableView)
    {
        return 0;
    }
    return [_arKey count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == _searchDisplayC.searchResultsTableView)
    {
        return 0;
    }
    NSString *key = [_arKey objectAtIndex:section];
    BOOL bShowRow = [[_dicShowRow objectForKey:key] boolValue];
    if (bShowRow)
    {
        return [[_dicData objectForKey:[_arKey objectAtIndex:section]] count];
    }
    return 0;
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
        int w = tableView.width/6;
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
        
        UIImage *i = [UIImage imageNamed:@"aio_face_manage_cover_default.png"];
        UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(10, (50 - w + 15)/2, w - 15, w - 15)];
        iv.layer.masksToBounds = YES;
        iv.layer.cornerRadius = 6.0;
        iv.layer.borderWidth = 1.0;
        iv.layer.borderColor = [[UIColor whiteColor] CGColor];
        [iv setImage:i];
        iv.tag = 1;
        [cell.contentView addSubview:iv];
        
        UILabel *nameL = [[UILabel alloc] initWithFrame:CGRectMake(w + 5, 0, w*4 - 5, 30)];
        [nameL setBackgroundColor:[UIColor clearColor]];
        [nameL setTextAlignment:NSTextAlignmentNatural];
        [nameL setFont:[UIFont systemFontOfSize:18]];
        nameL.tag = 2;
        [cell.contentView addSubview:nameL];
        
        UILabel *stateL = [[UILabel alloc] initWithFrame:CGRectMake(w + 5, 25, w*4 - 5, 20)];
        [stateL setBackgroundColor:[UIColor clearColor]];
        [stateL setFont:[UIFont systemFontOfSize:12]];
        [stateL setTextColor:[UIColor grayColor]];
        stateL.tag = 3;
        [stateL setText:@"[离线]这家伙很吊，什么也没有留下"];
        [cell.contentView addSubview:stateL];
    }
    NSString *key = [_arKey objectAtIndex:[indexPath section]];
    BOOL bShowRow = [[_dicShowRow objectForKey:key] boolValue];
    if (bShowRow)
        ((UILabel *)[cell.contentView viewWithTag:2]).text = [[_dicData objectForKey:key] objectAtIndex:indexPath.row];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    int w = tableView.width/7;
    UIView *headV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.width, 44)];
    [headV setBackgroundColor:[UIColor whiteColor]];
    
    NSString *key = [_arKey objectAtIndex:section];
    BOOL bShowRow = [[_dicShowRow objectForKey:key] boolValue];
    
    UIImage *i = [QHCommonUtil imageNamed:@"buddy_header_arrow.png"];
    UIImageView *arrowIV = [[UIImageView alloc] initWithFrame:CGRectMake((w - i.size.width)/2, (44 - i.size.height)/2, i.size.width, i.size.height)];
    [arrowIV setImage:i];
    [headV addSubview:arrowIV];
    if (bShowRow)
        arrowIV.transform = CGAffineTransformMakeRotation(M_PI_2);
    
    UILabel *titleL = [[UILabel alloc] initWithFrame:CGRectMake(w, 2, w * 4, 40)];
    [titleL setText:[_arKey objectAtIndex:section]];
    [titleL setFont:[UIFont systemFontOfSize:16]];
    [titleL setUserInteractionEnabled:NO];
    [headV addSubview:titleL];
    
    UIView *lineHV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.width, 0.5)];
    [lineHV setBackgroundColor:[UIColor grayColor]];
    [headV addSubview:lineHV];
    
    if (bShowRow)
    {
        UIView *lineBV = [[UIView alloc] initWithFrame:CGRectMake(0, 44 - 0.5, tableView.width, 0.5)];
        [lineBV setBackgroundColor:[UIColor grayColor]];
        [headV addSubview:lineBV];
    }
    
    UILabel *sumL = [[UILabel alloc] initWithFrame:CGRectMake(w * 5, 2, w * 2 - 5, 40)];
    [sumL setTextColor:[UIColor grayColor]];
    [sumL setText:[NSString stringWithFormat:@"%d/%d", 0, [[_dicData objectForKey:[_arKey objectAtIndex:section]] count]]];
    [sumL setTextAlignment:NSTextAlignmentRight];
    [sumL setFont:[UIFont systemFontOfSize:14]];
    [sumL setUserInteractionEnabled:NO];
    [headV addSubview:sumL];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setFrame:headV.bounds];
    btn.tag = section + 1;
    [headV addSubview:btn];
    [btn addTarget:self action:@selector(showRow:) forControlEvents:UIControlEventTouchUpInside];
    
    return headV;
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

- (void)reloadImage
{
    [super reloadImage];
    
    [_menuV reloadMenuImage];
    [_tableV reloadData];
}

@end
