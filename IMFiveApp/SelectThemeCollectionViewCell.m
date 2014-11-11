//
//  SelectThemeCollectionViewCell.m
//  IMFiveApp
//
//  Created by chen on 14-8-30.
//  Copyright (c) 2014年 chen. All rights reserved.
//

#import "SelectThemeCollectionViewCell.h"

@implementation SelectThemeCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        [self initView];
    }
    return self;
}

- (void)initView
{
    self.contentView.frame = CGRectMake(5, 0, self.width, self.height);
    self.contentView.layer.borderWidth = 1;
    self.contentView.layer.cornerRadius = 6;
    self.contentView.layer.borderColor = [UIColor grayColor].CGColor;
    
    float w = self.height/5;
    float wIV = w*4;
    
    UIImageView *titleIV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.contentView.width, wIV)];
    [titleIV setBackgroundColor:[UIColor clearColor]];
    titleIV.tag = 11;
    [self.contentView addSubview:titleIV];
    
    UILabel *titleL = [[UILabel alloc] initWithFrame:CGRectMake(0, titleIV.bottom, self.contentView.width, self.contentView.height - titleIV.bottom)];
    titleL.tag = 12;
    [self.contentView addSubview:titleL];
    
    UIImage *i = [UIImage imageNamed:@"common_green_checkbox.png"];
    UIImageView *selectIV = [[UIImageView alloc] initWithFrame:CGRectMake(self.contentView.width - titleL.height - 5, titleL.top, titleL.height, titleL.height)];
    [selectIV setImage:i];
    selectIV.tag = 13;
    [self.contentView addSubview:selectIV];
}

- (void)setDataForView:(NSArray *)ar selected:(BOOL)bSelected
{
    UIImageView *titleIV = (UIImageView *)[self.contentView viewWithTag:11];
//    titleIV.contentMode = UIViewContentModeScaleAspectFit;
    [titleIV setImage:[UIImage imageNamed:[ar objectAtIndex:2]]];
    
    UILabel *titleL = (UILabel *)[self.contentView viewWithTag:12];
    [titleL setTextAlignment:NSTextAlignmentCenter];
    titleL.text = [ar objectAtIndex:0];
    
    UIImageView *selectIV = (UIImageView *)[self.contentView viewWithTag:13];
    [selectIV setHidden:!bSelected];
}

- (void)setDataForView:(NSArray *)ar index:(NSIndexPath *)indexPath
{
    if ([QHConfiguredObj defaultConfigure].nThemeIndex == indexPath.row)
        [self setDataForView:ar selected:YES];
    else
        [self setDataForView:ar selected:NO];
}

@end
