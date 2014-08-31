//
//  RectViewForMessage.m
//  IMApp
//
//  Created by chen on 14/7/27.
//  Copyright (c) 2014年 chen. All rights reserved.
//

#import "RectViewForMessage.h"

@interface RectViewForMessage ()
{
    int _nSumOfLine;
    NSArray *_arData;
    BOOL _bSpera;
    NSString *_bgName;
}

@end

@implementation RectViewForMessage

- (id)initWithFrame:(CGRect)frame
{
    return [self initWithFrame:frame sumOfLine:0];
}

- (id)initWithFrame:(CGRect)frame sumOfLine:(int)nSumLine
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _nSumOfLine = nSumLine + 1;
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame ar:(NSArray *)arData showSpera:(BOOL)bSpera bg:(NSString *)bgName
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _arData = arData;
        _nSumOfLine = [_arData count];
        _bSpera = bSpera;
        _bgName = bgName;
        [self createLabel];
    }
    return self;
}

- (void)createLabel
{
    [self setBackgroundColor:[UIColor whiteColor]];
    
    UIImage *imageBg = [QHCommonUtil imageNamed:_bgName];
//    imageBg = [imageBg resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    UIImageView *imageIVBg = [[UIImageView alloc] initWithFrame:self.bounds];
    imageIVBg.tag = 32;
    [imageIVBg setImage:imageBg];
    [self addSubview:imageIVBg];
    
    float nW = self.width/_nSumOfLine;
    float nH = self.height/6;
    float nIR = MIN(nW, nH * 3);
    
    [_arData enumerateObjectsUsingBlock:^(NSArray *obj, NSUInteger idx, BOOL *stop)
    {
        UIImage *image = [QHCommonUtil imageNamed:[obj objectAtIndex:1]];
        UIImageView *imageIV = [[UIImageView alloc] initWithFrame:CGRectMake(idx * nW + (nW - nIR)/2, nH, nIR, nIR)];
        [imageIV setImage:image];
        imageIV.tag = idx + 33;
        [self addSubview:imageIV];
        
        UILabel *t = [[UILabel alloc] initWithFrame:CGRectMake(idx * nW, imageIV.bottom, nW - 1, nH*2)];
        [t setTextAlignment:NSTextAlignmentCenter];
        [t setFont:[UIFont systemFontOfSize:13]];
        [t setText:[obj objectAtIndex:0]];
        [self addSubview:t];
    }];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
*/
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    if (_bSpera)
    {
        float nW = self.width/_nSumOfLine;
        float nH = self.height;
        for (int i = 1; i < _nSumOfLine; i++)
        {
            CGContextRef context = UIGraphicsGetCurrentContext();
            CGContextSetStrokeColorWithColor(context, [UIColor grayColor].CGColor);
            CGContextSetLineWidth(context, 0.5);
            
            CGPoint *point = (CGPoint *) malloc(sizeof(CGPoint) * 2);
            point[0] = CGPointMake(i * nW, 0);
            point[1] = CGPointMake(i * nW, nH);
            CGContextBeginPath(context);
            CGContextAddLines(context, point, 2);
            CGContextClosePath(context);
            CGContextStrokePath(context);
            free(point);
        }
    }
}

- (void)reloadMenuImage
{
    if (_bgName != nil)
    {
        UIImage *imageBg = [QHCommonUtil imageNamed:_bgName];
        UIImageView *imageIV = (UIImageView *)[self viewWithTag:32];
        [imageIV setImage:imageBg];
    }
    
    [_arData enumerateObjectsUsingBlock:^(NSArray *obj, NSUInteger idx, BOOL *stop)
     {
         UIImage *image = [QHCommonUtil imageNamed:[obj objectAtIndex:1]];
         UIImageView *imageIV = (UIImageView *)[self viewWithTag:(idx + 33)];
         [imageIV setImage:image];
     }];
}

#pragma mark - UIResponder

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint touchLocatin = [touch locationInView:self];
    float nW = self.width/_nSumOfLine;
    int index = touchLocatin.x/nW;
    if ([_delegate respondsToSelector:@selector(press:index:)])
    {
        [_delegate press:self index:index];
    }
}

@end
