//
//  RectViewForMessage.h
//  IMApp
//
//  Created by chen on 14/7/27.
//  Copyright (c) 2014年 chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RectViewForMessage;

@protocol RectViewForMessageDelegate <NSObject>

@optional

- (void)press:(RectViewForMessage *)rectView index:(int)nIndex;

@end

@interface RectViewForMessage : UIView

@property (nonatomic, weak) id<RectViewForMessageDelegate> delegate;

- (id)initWithFrame:(CGRect)frame sumOfLine:(int)nSumLine;

- (id)initWithFrame:(CGRect)frame ar:(NSArray *)arData showSpera:(BOOL)bSpera bg:(NSString *)bgName;

- (void)reloadMenuImage;

@end
