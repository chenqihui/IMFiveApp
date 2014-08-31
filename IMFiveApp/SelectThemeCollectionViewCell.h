//
//  SelectThemeCollectionViewCell.h
//  IMFiveApp
//
//  Created by chen on 14-8-30.
//  Copyright (c) 2014年 chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectThemeCollectionViewCell : UICollectionViewCell

- (void)setDataForView:(NSArray *)ar selected:(BOOL)bSelected;

- (void)setDataForView:(NSArray *)ar index:(NSIndexPath *)indexPath;

@end
