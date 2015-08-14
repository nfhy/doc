//
//  TestScene.m
//  TestAnything
//
//  Created by 王露露 on 15/8/13.
//  Copyright (c) 2015年 王露露. All rights reserved.
//

#import "TestScene.h"

@interface TestScene()
@property SKLabelNode * sl;
@property BOOL b;
@property int counter;
@end

@implementation TestScene
- (instancetype)initWithSize:(CGSize)size{
    if (self = [super initWithSize:size]) {
        _b = YES;
        _counter = 0;
        _sl = [[SKLabelNode alloc] initWithFontNamed:@"Courier"];
        _sl.text = @"A";
        _sl.fontColor = [UIColor redColor];
        _sl.fontSize = 40;
        _sl.position = CGPointMake(0,0);
        [self addChild:_sl];
        self.backgroundColor = [UIColor yellowColor];
        self.anchorPoint = CGPointMake(0 ,0);
        self.scaleMode = SKSceneScaleModeAspectFit;
    }
    return self;
}

- (void)update:(NSTimeInterval)currentTime{
    /*_counter ++;
    if (_b) {
        
        if (_counter>=10) {
            NSLog(@"change 1");
            self.scaleMode = SKSceneScaleModeFill;
            _b = NO;
            _counter = 0;
        }
    }
    
    if (!_b) {
        if (_counter>=10) {
            NSLog(@"change 2");
            self.scaleMode = SKSceneScaleModeAspectFill;
            _b = YES;
            _counter = 0;
        }
    }*/
    _counter ++;
    if (_counter >= 100) {
        _counter = 0;
        NSLog(@"%f %f",self.anchorPoint.x,self.anchorPoint.y);
        self.anchorPoint = CGPointMake(self.anchorPoint.x+0.5, self.anchorPoint.y+0.5);
    }
}

@end
