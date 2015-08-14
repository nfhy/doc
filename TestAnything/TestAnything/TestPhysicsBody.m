//
//  TestPhysicsBody.m
//  TestAnything
//
//  Created by 王露露 on 15/8/10.
//  Copyright (c) 2015年 王露露. All rights reserved.
//

#import "TestPhysicsBody.h"

@implementation TestPhysicsBody

- (instancetype)initWithBodyCenter:(CGPoint)center{
    if (self = [super init]) {
        SKLabelNode * label = [[SKLabelNode alloc] initWithFontNamed:@"Courier"];
        label.text = @"O";
        label.fontColor = [UIColor blackColor];
        label.fontSize = 40;
        label.position = CGPointMake(0.f, 0.f);
        [self addChild:label];
        SKPhysicsBody * body;
        if (center.x <= 0) {
            body = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(10, 10)];
        }
        else body = [SKPhysicsBody bodyWithCircleOfRadius:1 center:center];
        body.affectedByGravity = NO;
        body.mass = 0.1;
        body.categoryBitMask = 1<<1;
        body.contactTestBitMask = 1<<1;
        body.collisionBitMask = 1<<1;
        self.physicsBody = body;
    }
    return self;
}

@end
