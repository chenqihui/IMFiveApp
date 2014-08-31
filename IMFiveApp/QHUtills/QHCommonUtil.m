//
//  QHCommonUtil.m
//  NewsFourApp
//
//  Created by chen on 14/8/9.
//  Copyright (c) 2014年 chen. All rights reserved.
//

#import "QHCommonUtil.h"

//#import <zipzap/zipzap.h>
#import "ZipArchive.h"

@implementation QHCommonUtil

+ (UIImage *)getImageFromView:(UIView *)view
{
    UIGraphicsBeginImageContext(view.bounds.size);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

+ (UIColor *)getRandomColor
{
    return [UIColor colorWithRed:(float)(1+arc4random()%99)/100 green:(float)(1+arc4random()%99)/100 blue:(float)(1+arc4random()%99)/100 alpha:1];
}

/*0--1 : lerp( float percent, float x, float y ){ return x + ( percent * ( y - x ) ); };*/
+ (float)lerp:(float)percent min:(float)nMin max:(float)nMax
{
    float result = nMin;
    
    result = nMin + percent * (nMax - nMin);
    
    return result;
}

+ (void)unzipFileToDocument:(NSString *)fileName
{
    [QHCommonUtil moveFileToDocument:fileName type:@"zip"];
}

+ (void)moveFileToDocument:(NSString *)fileName type:(NSString *)fileType
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:fileName ofType:fileType];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath2 = [documentsDirectory stringByAppendingPathComponent:[fileName stringByAppendingPathExtension:fileType]];
    NSString *pathFold = [filePath2 stringByDeletingPathExtension];
    NSString *path = [filePath2 stringByDeletingLastPathComponent];
    
    NSFileManager *manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:pathFold])
    {
        //判断是否移动成功，这里文件不能是存在的
        NSError *thiserror = nil;
        if ([[NSFileManager defaultManager] copyItemAtPath:filePath toPath:filePath2 error:&thiserror] != YES)
        {
            NSLog(@"move fail...");
            NSLog(@"Unable to move file: %@", [thiserror localizedDescription]);
        }
        
        ZipArchive *archive = [[ZipArchive alloc] init];
        //1
        if ([archive UnzipOpenFile:filePath2])
        {
            // 2
            BOOL ret = [archive UnzipFileTo:path overWrite: YES];
            if (NO == ret)
            {
                NSLog(@"fail");
            }
            [archive UnzipCloseFile];
        }
        
        [manager removeItemAtPath:filePath2 error:nil];
    }else
    {
//        [manager removeItemAtPath:filePath2 error:nil];
    }
}

+ (UIImage *)imageNamed:(NSString *)name
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    UIImage *image = nil;
    if ([QHConfiguredObj defaultConfigure].themefold != nil && [QHConfiguredObj defaultConfigure].themefold.length > 0)
    {
        NSString *path = [[documentsDirectory stringByAppendingPathComponent:[QHConfiguredObj defaultConfigure].themefold] stringByAppendingPathComponent:name];
        image = [UIImage imageWithContentsOfFile:path];
    }
    if (image == nil)
    {
        image = [UIImage imageNamed:name];
    }
    
    return image;
}

@end
