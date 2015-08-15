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
@property NSTimeInterval t;
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

- (void)didEvaluateActions{
    [_sl removeActionForKey:@"action"];
    SKAction * action = [SKAction customActionWithDuration:0.1 actionBlock:^(SKNode *node, CGFloat elapsedTime) {
        ((SKLabelNode *)node).text = @"A";
    }];
    [_sl runAction:action withKey:@"action"];
    NSLog(@"%f %@",_t,_sl.text);
    
    
}

- (void)update:(NSTimeInterval)currentTime{
    _t = currentTime;
    NSLog(@"%f",_t);
    if (_b) {
        SKAction * action = [SKAction customActionWithDuration:0.1 actionBlock:^(SKNode *node, CGFloat elapsedTime) {
            ((SKLabelNode *)node).text = [NSString stringWithFormat:@"%f",_t];
        }];
        [_sl runAction:action withKey:@"action"];
        _b = NO;
    }
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
    /*_counter ++;
    if (_counter >= 100) {
        _counter = 0;
        NSLog(@"%f %f",self.anchorPoint.x,self.anchorPoint.y);
        NSLog(@"%f %f",_sl.position.x,_sl.position.y);
        CGPoint p = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2);
        CGPoint p1 = [self convertPointToView:CGPointMake(0, 0)];
        NSLog(@"%f %f",p1.x,p1.y);
        NSLog(@"end------");
        self.anchorPoint = CGPointMake(self.anchorPoint.x+0.1, self.anchorPoint.y+0.2);
    }*/
}

@end
