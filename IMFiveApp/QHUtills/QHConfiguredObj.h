//
//  QHConfiguredObj.h
//  IMFiveApp
//
//  Created by chen on 14-8-30.
//  Copyright (c) 2014年 chen. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kTHEME_TAG @"selectTheme"
#define kTHEMEFOLD_TAG @"selectThemeFold"

@interface QHConfiguredObj : NSObject

@property (nonatomic, assign) int nThemeIndex;
@property (nonatomic, retain) NSString *themefold;

+ (QHConfiguredObj *)defaultConfigure;

@end
