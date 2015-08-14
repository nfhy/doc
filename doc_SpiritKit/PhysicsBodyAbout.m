//
//  PhysicsBodyAbout.h
//  SpriteKit
//
//  Copyright (c) 2011 Apple Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKitBase.h>

@class SKPhysicsBody;
@class SKNode;
@class SKTexture;

/**
 A SpriteKit physics body. These are the physical representations of your nodes. These specify the area and mass and any collision masking needed.
 
 All bodies have zero, one or more shapes that define its area. A body with no shapes is ethereal and does not collide with other bodies.
 An SKPhysicsBody object is used to add physics simulation to a node. When a scene processes a new frame, it performs physics calculations on physics bodies attached to nodes in the scene. These calculations include gravity, friction, and collisions with other bodies. You can also apply your own forces and impulses to a body. After the scene completes these calculations, it updates the positions and orientations of the node objects.
 每一帧，场景都会进行物理计算，计算完毕后对物体施加力。
 To add physics to a node, create and configure an SKPhysicsBody object and then assign it to the physicsBody property of the SKNode object. A physics body must be associated with a node object before you apply forces or impulses to it.
 
 Sprite Kit supports two kinds of physics bodies, volume-based bodies and edge-based bodies. When you create a physics body, its kind, size, and shape are determined by the constructor method you call. An edge-based body does not have mass or volume and is unaffected by forces or impulses in the system. Edge-based bodies are used to represent volume-less boundaries or hollow spaces in your physics simulation. In contrast, volume-based bodies are used to represent objects with mass and volume. The dynamic property controls whether a volume-based body is affected by gravity, friction, collisions with other objects, and forces or impulses you directly apply to the object.
 SKPhysicsBody对象有两类，一类没有质量和速度，不会受力或碰撞的影响，一般作为边界线、地面；一类有质量和速度，会受重力、摩擦力、碰撞或者人为施加的力的影响。
 The SKPhysicsBody class defines the physical characteristics for the body when it is simulated by the scene. For volume-based bodies, the most important property is the mass property. A volume-based body is assumed to have a uniform density. You can either set the mass property directly, or you can set the body’s density property and let the physics body calculate its own mass. All values in Sprite Kit are specified using the International System of Units (SI units). The actual forces and mass values are not important so long as your game uses consistent values.
 SKPhysicsBody对象有密度的概念，它的密度是均匀的，所以可以直接设置mass属性、也可以设置density属性间接算出对象的mass属性。
 When you design a game that uses physics, you define the different categories of physics objects that appear in the scene. You define up to 32 different categories of physics bodies, and a body can be assigned to as many of these categories as you want. In addition to declaring its own categories, a physics body also declares which categories of bodies it interacts with. See Working with Collisions and Contacts. You use a similar mechanism to declare which physics field nodes (SKFieldNode) can affect the physics body.
 SKPhysicsBody对象可以设定32种类别掩码。
 For a volume-based body, you can dynamically control how the body is affected by forces or collisions. See Defining How Forces Affect a Physics Body.
 
 */
SK_EXPORT @interface PhysicsBodyAbout : NSObject <NSCopying, NSCoding>

/**
 Creates a circle of radius r centered at the node's origin.
 @param r the radius in points
 如果不显式的指定对象的圆心，则圆心在Node坐标系中的原点(0,0)
 */
+ (SKPhysicsBody *)bodyWithCircleOfRadius:(CGFloat)r;

/**
 Creates a circle of radius r centered at a point in the node's coordinate space.
 @param r the radius in points
 */
+ (SKPhysicsBody *)bodyWithCircleOfRadius:(CGFloat)r center:(CGPoint)center;

/**
 Creates a rectangle of the specified size centered at the node's origin.
 @param s the size in points
 */
+ (SKPhysicsBody *)bodyWithRectangleOfSize:(CGSize)s;

/**
 Creates a rectangle of the specified size centered at a point in the node's coordinate space.
 @param s the size in points
 */
+ (SKPhysicsBody *)bodyWithRectangleOfSize:(CGSize)s center:(CGPoint)center;

/**
 The path must represent a convex or concave polygon with counter clockwise winding and no self intersection. Positions are relative to the node's origin.
 路径必须为凸或凹多边形，逆时针画出，边线没有交叉。
 @param path the path to use
 */
+ (SKPhysicsBody *)bodyWithPolygonFromPath:(CGPathRef)path;

/**
 Creates an edge from p1 to p2. Edges have no volume and are intended to be used to create static environments. Edges can collide with bodies of volume, but not with each other.
 @param p1 start point
 @param p2 end point
 */
+ (SKPhysicsBody *)bodyWithEdgeFromPoint:(CGPoint)p1 toPoint:(CGPoint)p2;

/**
 Creates an edge chain from a path. The path must have no self intersection. Edges have no volume and are intended to be used to create static environments. Edges can collide with bodies of volume, but not with each other.
 @param path the path to use
 */
+ (SKPhysicsBody *)bodyWithEdgeChainFromPath:(CGPathRef)path;

/**
 Creates an edge loop from a path. A loop is automatically created by joining the last point to the first. The path must have no self intersection. Edges have no volume and are intended to be used to create static environments. Edges can collide with body's of volume, but not with each other.
 @param path the path to use
 */
+ (SKPhysicsBody *)bodyWithEdgeLoopFromPath:(CGPathRef)path;

/**
 Creates an edge loop from a CGRect. Edges have no volume and are intended to be used to create static environments. Edges can collide with body's of volume, but not with each other.
 @param rect the CGRect to use
 */
+ (SKPhysicsBody *)bodyWithEdgeLoopFromRect:(CGRect)rect;

/**
 Creates a body from the alpha values in the supplied texture.
 @param texture the texture to be interpreted
 @param size of the generated physics body
 */
+ (SKPhysicsBody *)bodyWithTexture:(SKTexture*)texture size:(CGSize)size NS_AVAILABLE(10_10, 8_0);

/**
 Creates a body from the alpha values in the supplied texture.
 @param texture the texture to be interpreted
 @param alphaThreshold the alpha value above which a pixel is interpreted as opaque
 @param size of the generated physics body
 ########################################################################
 SKTexture 没有了解，暂留
 */
+ (SKPhysicsBody *)bodyWithTexture:(SKTexture*)texture alphaThreshold:(float)alphaThreshold size:(CGSize)size NS_AVAILABLE(10_10, 8_0);


/**
 Creates an compound body that is the union of the bodies used to create it.
 The shapes of the physics bodies passed into this method are used to create a new physics body whose covered area is the union of the areas of its children. These areas do not need to be contiguous. If there is space between two parts, other bodies may be able to pass between these parts. However, the physics body is treated as a single connected body, meaning that a force or impulse applied to the body affects all of the pieces as if they are held together with an indestructible frame.
 将多个对象组合为一个对象，新对象的形状覆盖所有子对象，各个子对象间可以不接触，其他对象可以穿过子对象间的空隙。但当该对象受力、碰撞时，所有子对象被当做一个对象来处理。
 
 The properties on the children, such as mass or friction, are ignored. Only the shapes of the child bodies are used.
 */
+ (SKPhysicsBody *)bodyWithBodies:(NSArray *)bodies;

@property (nonatomic, getter = isDynamic) BOOL dynamic;
/**
 The default value is NO. If two bodies in a collision do not perform precise collision detection, and one passes completely through the other in a single frame, no collision is detected. If this property is set to YES on either body, the simulation performs a more precise and more expensive calculation to detect these collisions. This property should be set to YES on small, fast moving bodies.
 当两个物体的该属性为NO时，如果碰撞时，一个物体可以在一帧内完全穿过另一个物体，那么碰撞将不会被检测到。（这就是为什么在初始化body时，如果把body的半径设为1，两个物体将无法发生碰撞）
 */
@property (nonatomic) BOOL usesPreciseCollisionDetection;


/**
 是否会旋转，导致物体旋转的那一部分力将失效
 */
@property (nonatomic) BOOL allowsRotation;


/**
 物体是否被固定在父Node中，被固定的物体仍可以旋转
 */
@property (nonatomic) BOOL pinned NS_AVAILABLE(10_10, 8_0);


/**
 If the physics simulation has determined that this body is at rest it may set the resting property to YES. Resting bodies do not participate
 in the simulation until some collision with a non-resting  object, or an impulse is applied, that unrests it. If all bodies in the world are resting
 then the simulation as a whole is "at rest".
 当系统检测到物体处于静止状态时,会自动将该属性置为YES.Resting状态的对象不参与物理模拟计算。当物体再次受力、碰撞时，属性变为NO，再次参与物理运算。（个人理解不需要人为设置，交给系统自动处理。这是系统节省运算资源的一种方式。）
 */
@property (nonatomic, getter = isResting) BOOL resting;

/**
 Determines the 'roughness' for the surface of the physics body (0.0 - 1.0). Defaults to 0.2
 摩擦粗糙程度
 */
@property (nonatomic) CGFloat friction;

/**
 Specifies the charge on the body. Charge determines the degree to which a body is affected by
 electric and magnetic fields. Note that this is a unitless quantity, it is up to the developer to
 set charge and field strength appropriately. Defaults to 0.0
 ##############################################################################
 对象的电荷，与SKFieldNode相关，保留
 */
@property (nonatomic) CGFloat charge NS_AVAILABLE(10_10, 8_0);

/**
 Determines the 'bounciness' of the physics body (0.0 - 1.0). Defaults to 0.2
 弹性
 */
@property (nonatomic) CGFloat restitution;

/**
 Optionally reduce the body's linear velocity each frame to simulate fluid/air friction. Value should be zero or greater. Defaults to 0.1.
 Used in conjunction with per frame impulses, an object can be made to move at a constant speed. For example, if an object 64 points in size
 and default density and a linearDamping of 25 will slide across the screen in a few seconds if an impulse of magnitude 10 is applied every update.
 取值范围（0-1）线性运动时受到的摩擦力（一个小球从高处落到平板上，反弹的高度越来越低）
 */
@property (nonatomic, assign) CGFloat linearDamping;

/**
 Optionally reduce the body's angular velocity each frame to simulate rotational friction. (0.0 - 1.0). Defaults to 0.1
 旋转时受到的摩擦力（一个不受重力的小球在空中旋转，越转越慢）
 */
@property (nonatomic, assign) CGFloat angularDamping;

/**
 The density of the body.
 @discussion
 The unit is arbitrary, as long as the relative densities are consistent throughout the application. Note that density and mass are inherently related (they are directly proportional), so changing one also changes the other. Both are provided so either can be used depending on what is more relevant to your usage.
 质量和密度是相关联的，改变一个值会同时改变另一个值
 */
@property (nonatomic) CGFloat density;

/**
 The mass of the body.
 @discussion
 The unit is arbitrary, as long as the relative masses are consistent throughout the application. Note that density and mass are inherently related (they are directly proportional), so changing one also changes the other. Both are provided so either can be used depending on what is more relevant to your usage.
 */
@property (nonatomic) CGFloat mass;

/**
 The area of the body.
 @discussion
 The unit is arbitrary, as long as the relative areas are consistent throughout the application.
 body初始化时被确定，之后将不能再次修改。质量mass、密度dentity和面积area三者相关联，面积不变，质量和密度可变，质量=密度*面积。
 */
@property (nonatomic, readonly) CGFloat area;

/**
 Bodies are affected by field forces such as gravity if this property is set and the field's category mask is set appropriately. The default value is YES.
 @discussion
 If this is set a force is applied to the object based on the mass. Set the field force vector in the scene to modify the strength of the force.
 当物体在力场中时，该属性决定物体是否会受场力的影响。
 ######################################################################################
 该属性是否回影响SKFieldNode中的受力。SKFieldNode中的力场是均匀立场还是有心力场仍不确定
 */
@property (nonatomic, assign) BOOL affectedByGravity;

/**
 Defines what logical 'categories' of fields this body responds to. Defaults to all bits set (all categories).
 Can be forced off via affectedByGravity.
 场力类别掩码，判断是否被场力影响，可以被affectedByGravity关闭
 */
@property (nonatomic, assign) uint32_t fieldBitMask NS_AVAILABLE(10_10, 8_0);

/**
 Defines what logical 'categories' this body belongs to. Defaults to all bits set (all categories).
 */
@property (nonatomic, assign) uint32_t categoryBitMask;

/**
 Defines what logical 'categories' of bodies this body responds to collisions with. Defaults to all bits set (all categories).
 */
@property (nonatomic, assign) uint32_t collisionBitMask;

/**
 Defines what logical 'categories' of bodies this body generates intersection notifications with. Defaults to all bits cleared (no categories).
 */
@property (nonatomic, assign) uint32_t contactTestBitMask;

/**
 ################################################################################################
 SKPhysicsJoint
 */
@property (nonatomic, readonly) NSArray *joints;

/**
 The representedObject this physicsBody is currently bound to, or nil if it is not.
 body对象同一时间只能与一个node对象关联，当关联多个对象时，系统报错。
 可以先解除body与node1的关联，再与node2关联。
 physicsBody的位置与node在scence中的位置无关，它处于node的坐标系中，与node相对静止，所以node移动、或者node由node1变为node2，body也会改变到node2所在位置。
 但是，物理运算后的移动，是先算出body的位置，然后移动node。
 When a node has a physics body, the physics simulation automatically computes a new position for the physics body and then moves and rotates the node to match that position.
 */
@property (nonatomic, readonly, weak) SKNode *node;

/**
 两个速度都可以改变，物体运动也会根据速度变化而变化。
 */
@property (nonatomic) CGVector velocity;
@property (nonatomic) CGFloat angularVelocity;
/**
 没有point参数时，力施加于重心，只会影响物体的移动，不会影响物体的旋转。有point参数时，可能影响物体的移动和旋转。
 */
- (void)applyForce:(CGVector)force;
- (void)applyForce:(CGVector)force atPoint:(CGPoint)point;
/**
 只会影响物体的旋转
 */
- (void)applyTorque:(CGFloat)torque;
/**
 模拟物体撞击，与施加力效果相似，最终都会影响物体的速度或角速度。
 */
- (void)applyImpulse:(CGVector)impulse;
- (void)applyImpulse:(CGVector)impulse atPoint:(CGPoint)point;

- (void)applyAngularImpulse:(CGFloat)impulse;

/* Returns an array of all SKPhysicsBodies currently in contact with this one */
- (NSArray *)allContactedBodies;

@end

