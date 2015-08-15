//
//  GameScene.m
//  TestAnything
//
//  Created by 王露露 on 15/8/10.
//  Copyright (c) 2015年 王露露. All rights reserved.
//

#import "GameScene.h"
#import "TestPhysicsBody.h"

@interface GameScene()
@property(strong, nonatomic) NSMutableArray * arr;
@property(assign, nonatomic) BOOL b;
@property(assign, nonatomic) BOOL c;
@property(assign, nonatomic) int count;
@end

@implementation GameScene

- (instancetype)initWithSize:(CGSize)size{
    if (self = [super initWithSize:size]) {
        _b = true;
        _c = true;
        _count = 1;
        _arr = [NSMutableArray arrayWithCapacity:2];
        self.backgroundColor = [UIColor whiteColor];
        CGPoint p1 = CGPointMake(0, 50);
        CGPoint p2 = CGPointMake(size.width, 20);
        SKNode * n = [[SKNode alloc] init];
        n.position = p1;
        SKPhysicsBody * body = [SKPhysicsBody bodyWithEdgeFromPoint:p1 toPoint:p2];
        body.friction = 1.0;
        body.restitution = 1.0;
        n.physicsBody = body;
        n.name = @"line";
        [self addChild:n];
        TestPhysicsBody * t = [[TestPhysicsBody alloc] initWithBodyCenter:CGPointMake(-1, -1)];
        t.physicsBody.affectedByGravity = YES;
        t.physicsBody.friction = 0.f;
        t.physicsBody.mass = 0.1;
        t.physicsBody.restitution = 0.f;
        t.position = CGPointMake(size.width/2, size.height-100);
        t.physicsBody.resting = NO;
        t.physicsBody.linearDamping = 0.f;
        t.physicsBody.angularDamping = 0.f;
        t.physicsBody.allowsRotation = YES;
        t.physicsBody.usesPreciseCollisionDetection = YES;
        t.speed = 2.0;
        t.name = @"t";
        [_arr addObject:t];
        TestPhysicsBody * t1 = [[TestPhysicsBody alloc] initWithBodyCenter:CGPointMake(-1, -1)];
        t1.physicsBody.affectedByGravity = YES;
        t1.physicsBody.resting = YES;
        t1.physicsBody.mass = 0.1;
        t1.physicsBody.restitution = 0.f;
        t1.position = CGPointMake(size.width/2, size.height/2);
        t1.physicsBody.usesPreciseCollisionDetection = YES;
        t1.name = @"t1";
        t1.speed = 0.5;
        [_arr addObject:t1];

        TestPhysicsBody * t2 = [[TestPhysicsBody alloc] initWithBodyCenter:CGPointMake(-1, -1)];
        t2.physicsBody.affectedByGravity = NO;
        t2.physicsBody.resting = YES;
        t2.physicsBody.mass = 0.1;
        t2.physicsBody.restitution = 0.f;
        t2.position = CGPointMake(size.width/4, size.height/3);
        t2.physicsBody.usesPreciseCollisionDetection = YES;
        /*
        SKPhysicsBody * body1 = t1.physicsBody;
        t1.physicsBody = nil;
        t2.physicsBody = body1;
        */
        [self addChild:t];
        [self addChild:t1];
        //[self addChild:t2];
    }
    return self;
}

-(void)didMoveToView:(SKView *)view {
    /* Setup your scene here */
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
}

-(void)update:(CFTimeInterval)currentTime {
    /*for (id t in _arr  ) {
        TestPhysicsBody * t1 = t;
        NSLog(@"%d",[t1.physicsBody isResting]);
        t1.physicsBody.affectedByGravity = [t1.physicsBody isResting];
        NSLog(@"%f %f %f",t1.physicsBody.mass, t1.physicsBody.density, t1.physicsBody.area);
        //NSLog(@"%f %f",t1.frame.size.width,t1.frame.size.height);
        t1.physicsBody.mass += 1.f;
        
    }*/
    /*if (_b) {
        TestPhysicsBody * t = _arr[0];
        t.physicsBody.affectedByGravity = NO;
        CGPoint p = t.position;
        CGSize s = t.frame.size;
        [t.physicsBody applyForce:CGVectorMake(100, 0)];
        _b = NO;
    }*/
    /*for (id t in _arr) {
        TestPhysicsBody * t1 = t;
        CGVector v;
        _count ++;
        if (_count%10 >= 1) {
            continue;
        }
        if (_b) {
            if (_c) {
                v = CGVectorMake(100, 0);
                _c = false;
            }else{
                v = CGVectorMake(0, -100);
                _b = false;
                _c = true;
            }
        }else{
            if (_c) {
                v = CGVectorMake(-100, 0);
                _c = false;
            }else{
                v = CGVectorMake(0, 100);
                _c = true;
                _b = true;
            }
        }
        t1.physicsBody.velocity = v;
        NSLog(@"%f %f",v.dx,v.dy);
        t1.physicsBody.angularVelocity = 100.f;
     
    }*/
    NSArray * arr1;
    SKPhysicsBody * b;
    for (id t in _arr) {
        TestPhysicsBody * t1 = t;
        arr1 = t1.physicsBody.allContactedBodies;
        if ([arr1 count]>=1) {
            b = arr1[0];
            NSLog(@"%@",b.node.name);
        }
    }
    
}

- (void)didBeginContact:(SKPhysicsContact *)contact{
    NSLog(@"contact");
}

@end
