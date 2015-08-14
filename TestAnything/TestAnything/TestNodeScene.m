//
//  TestNodeScene.m
//  TestAnything
//
//  Created by 王露露 on 15/8/12.
//  Copyright (c) 2015年 王露露. All rights reserved.
//

#import "TestNodeScene.h"
#import "TestNode.h"

@implementation TestNodeScene
BOOL b = YES;
BOOL c = YES;
SKNode * n;
SKLabelNode * l;
SKLabelNode * l1;
SKLabelNode * l2;
- (instancetype)initWithSize:(CGSize)size{
    if (self = [super initWithSize:size]) {
        self.physicsWorld.contactDelegate = self;
        self.name = @"s";
        
        for (int i = 'a'; i <= 'j'; i++) {
            TestNode * t1 = [[TestNode alloc] initWithName:[NSString stringWithFormat:@"%c %d %d",(char)i,0,0]];
            for (int j=1; j<=10; j++) {
                TestNode * t2 = [[TestNode alloc] initWithName:[NSString stringWithFormat:@"%c %d %d",(char)i,j,0]];
                for (int k = 1; k <= 10; k++) {
                    TestNode * t3 = [[TestNode alloc] initWithName:[NSString stringWithFormat:@"%c %d %d",(char)i,j,k]];
                    [t2 addChild:t3];
                }
                [t1 addChild:t2];
            }
            [self addChild:t1];
        }
    
    for (SKNode * node in [[self childNodeWithName:@"a 1 1"] objectForKeyedSubscript:@"..a*"]) {
        NSLog(@"%@",node.name);
    }
        n = [SKNode node];
        n.position = CGPointMake(100, 100);
        l = [[SKLabelNode alloc] initWithFontNamed:@"Courier"];
        l.position = CGPointMake(0, 0);
        l.text = @"A";
        l.fontColor = [UIColor blackColor];
        l.fontSize = 40;
        l.name = @"l";
        l.zPosition = -100;
        l.speed = 1.f;
        SKPhysicsBody * body = [SKPhysicsBody bodyWithCircleOfRadius:20];
        l.physicsBody = body;
        l.physicsBody.affectedByGravity = NO;
        l.physicsBody.categoryBitMask = 1<<2;
        l.physicsBody.contactTestBitMask = 1<<1;
        l.physicsBody.collisionBitMask = 1<<1;
        [n addChild:l];
        l.paused = YES;
        [self addChild:n];
        l1 = [[SKLabelNode alloc] initWithFontNamed:@"Courier"];
        l1.position = CGPointMake(100, 100);
        l1.text = @"V";
        l1.fontColor = [UIColor redColor];
        l1.fontSize = 40;
        l1.name = @"l";
        l1.zPosition = 100;
        l1.speed = 2.f;
        SKPhysicsBody * body1 = [SKPhysicsBody bodyWithCircleOfRadius:20];
        l1.physicsBody = body1;
        l1.physicsBody.affectedByGravity = NO;
        l1.physicsBody.categoryBitMask = 1<<2;
        l1.physicsBody.contactTestBitMask = 1<<1;
        l1.physicsBody.collisionBitMask = 1<<1;
        [self addChild:l1];
        
        l2 = [[SKLabelNode alloc] initWithFontNamed:@"Courier"];
        l2.position = CGPointMake(100, 400);
        l2.text = @"O";
        l2.fontColor = [UIColor redColor];
        l2.fontSize = 40;
        l2.name = @"l2";
        SKPhysicsBody * body2 = [SKPhysicsBody bodyWithCircleOfRadius:20];
        l2.physicsBody = body2;
        l2.physicsBody.affectedByGravity = NO;
        l2.physicsBody.categoryBitMask = 1<<1;
        l2.physicsBody.contactTestBitMask = 1<<2;
        l2.physicsBody.collisionBitMask = 1<<2;
        l2.paused = YES;
        [self addChild:l2];

    }
    return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    for (UITouch * touch in touches) {
        CGPoint p = [touch locationInNode:self];
        SKAction * a1 = [SKAction moveTo:p duration:1.f];
        [l1 runAction:a1 completion:^{
            NSLog(@"%d",l1.paused);
        }];
        SKAction * a2 = [SKAction moveTo:[n convertPoint:p fromNode:self] duration:1.f];
        [l runAction:a2 completion:^(void){
            NSLog(@"l");
        }];
    }
}

- (void)didBeginContact:(SKPhysicsContact *)contact{
   NSLog(@"%@ %@",contact.bodyA.node.name,contact.bodyB.node.name);
}

- (void)update:(NSTimeInterval)currentTime{
    if (b) {
        //l.paused = YES;
        //SKNode * node = [self childNodeWithName:@"l"];
        //node.alpha = 0;
        NSLog(@"%f %f",l.position.x,l.position.y);
        SKConstraint * con = [SKConstraint positionX:[SKRange rangeWithLowerLimit:0 upperLimit:100]];
        l1.constraints = @[con];
        
        b = NO;
    }
    /*if (b) {
        l2 = [[SKLabelNode alloc] initWithFontNamed:@"Courier"];
        l2.position = CGPointMake(100, 400);
        l2.text = @"O";
        l2.fontColor = [UIColor redColor];
        l2.fontSize = 40;
        l2.name = @"l2";
        SKPhysicsBody * body2 = [SKPhysicsBody bodyWithCircleOfRadius:20];
        l2.physicsBody = body2;
        l2.physicsBody.affectedByGravity = YES;
        l2.physicsBody.categoryBitMask = 1<<1;
        l2.physicsBody.contactTestBitMask = 1<<2;
        l2.physicsBody.collisionBitMask = 1<<2;
        l2.alpha = 0;
        [self addChild:l2];
        //l2.paused = YES;
        b = NO;
    }*/
    //NSLog(@"%d",l.paused);
    //l.paused = YES;
    /*if (b||c) {
        if (b) {
            b = NO;
        }
        else if (c) {
            c = NO;
        }
    //CGRect f1  = l.frame;
    //NSLog(@"x %f,y %f,w %f,h %f",f1.origin.x,f1.origin.y,f1.size.width,f1.size.height);
    //    [l setScale:4.f];
        CGRect f1 = l.frame;
        //l.xScale = 2.f;
        NSLog(@"x %f,y %f,w %f,h %f,px %f,py %f",f1.origin.x,f1.origin.y,f1.size.width,f1.size.height,l.position.x,l.position.y);
        n.xScale = 2.f;
        n.zRotation = M_PI_4;
    }*/
}

@end
