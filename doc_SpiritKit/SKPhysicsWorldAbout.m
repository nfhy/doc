//
//  SKPhysicsWorld.h
//  SpriteKit
//
//  Copyright (c) 2011 Apple Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SpriteKit/SKPhysicsContact.h>
#import <SpriteKit/SpriteKitBase.h>

@class SKPhysicsJoint;
@class SKFieldNode;

SK_EXPORT @protocol SKPhysicsContactDelegate1<NSObject>
@optional
- (void)didBeginContact:(SKPhysicsContact *)contact;
- (void)didEndContact:(SKPhysicsContact *)contact;
@end

SK_EXPORT @interface SKPhysicsWorldAbout : NSObject<NSCoding>

/**
 A global 2D vector specifying the field force acceleration due to gravity. The unit is meters per second so standard earth gravity would be { 0.0, +/-9.8 }.
 */
@property (nonatomic) CGVector gravity;

/**
 The default value is 1.0, which means the simulation runs at normal speed. A value other than the default changes the rate at which time passes in the physics simulation. For example, a speed value of 2.0 indicates that time in the physics simulation passes twice as fast as the scene’s simulation time. A value of 0.0 pauses the physics simulation.
 
根据实测，speed只会影响物理模拟的速度，不会影响action运行的速度。碰撞、受力移动都会加速或减速。
 */
@property (nonatomic) CGFloat speed;

@property (nonatomic, assign) id<SKPhysicsContactDelegate1> contactDelegate;

- (void)addJoint:(SKPhysicsJoint *)joint;
- (void)removeJoint:(SKPhysicsJoint *)joint;
- (void)removeAllJoints;

/**
 The sample is calculated as if a physics body is placed at that position in the scene. The body is assumed to have a mass of 1.0, with no charge or velocity. The body is affected by all field nodes.
 

 */
- (vector_float3)sampleFieldsAt:(vector_float3)position NS_AVAILABLE(10_10, 8_0);
/**
 返回所有符合的node中zPosition最大的，也就是在图像最上层的node
 */
- (SKPhysicsBody *)bodyAtPoint:(CGPoint)point;
- (SKPhysicsBody *)bodyInRect:(CGRect)rect;
/**
 The first physics body discovered that intersects the ray. This may be any body along the ray; it is not guaranteed to be the closest physics body. If no body intersects the ray, this method returns nil.
 */
- (SKPhysicsBody *)bodyAlongRayStart:(CGPoint)start end:(CGPoint)end;

- (void)enumerateBodiesAtPoint:(CGPoint)point usingBlock:(void (^)(SKPhysicsBody *body, BOOL *stop))block;
- (void)enumerateBodiesInRect:(CGRect)rect usingBlock:(void (^)(SKPhysicsBody *body, BOOL *stop))block;
- (void)enumerateBodiesAlongRayStart:(CGPoint)start end:(CGPoint)end
                          usingBlock:(void (^)(SKPhysicsBody *body, CGPoint point, CGVector normal, BOOL *stop))block;

@end
