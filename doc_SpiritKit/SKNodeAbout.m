/**
 @header
 
 
 Nodes are the base scene graph nodes used in the SpriteKit scene graph.
 
 
 @copyright 2011 Apple, Inc. All rights reserve.
 
 */

#import <SpriteKit/SpriteKitBase.h>

@class SKView, SKAction, SKScene, SKTexture, SKPhysicsBody, SKFieldNode, SKReachConstraints, SKConstraint, SKNode;

/**
 Blend modes that the SKNode uses to compose with the framebuffer to produce blended colors.
 */
typedef NS_ENUM(NSInteger, SKBlendMode1) {
    SKBlendModeAlpha1        = 0,    // Blends the source and destination colors by multiplying the source alpha value.
    SKBlendModeAdd1          = 1,    // Blends the source and destination colors by adding them up.
    SKBlendModeSubtract1     = 2,    // Blends the source and destination colors by subtracting the source from the destination.
    SKBlendModeMultiply1     = 3,    // Blends the source and destination colors by multiplying them.
    SKBlendModeMultiplyX21   = 4,    // Blends the source and destination colors by multiplying them and doubling the result.
    SKBlendModeScreen1       = 5,    // FIXME: Description needed
    SKBlendModeReplace1      = 6     // Replaces the destination with the source (ignores alpha).
} NS_ENUM_AVAILABLE(10_9, 7_0);

/**
 A SpriteKit scene graph node. These are the branch nodes that together with geometric leaf nodes make up the directed acyclic graph that is the SpriteKit scene graph tree.
 
 All nodes have one and exactly one parent unless they are the root node of a graph tree. Leaf nodes have no children and contain some sort of sharable data that guarantee the DAG condition.
 每个node最多有一个父节点，根node没有父节点。
 尽量为每个node设置name属性，在后续node查找、碰撞检测中都可以很方便的用到。
 */
#if TARGET_OS_IPHONE
SK_EXPORT @interface SKNodeAbout : UIResponder <NSCopying, NSCoding>
#else
SK_EXPORT @interface SKNodeAbout : NSResponder <NSCopying, NSCoding>
#endif

- (instancetype)init NS_DESIGNATED_INITIALIZER;

/**
 Support coding and decoding via NSKeyedArchiver.
 */
- (instancetype)initWithCoder:(NSCoder *)aDecoder NS_DESIGNATED_INITIALIZER;

+ (instancetype)node;

+ (instancetype)nodeWithFileNamed:(NSString*)filename;

/**
 The frame is the smallest rectangle that contains the node’s content, taking into account the node’s xScale, yScale, and zRotation properties. Not all nodes contain content of their own.
 根据实际测试，猜测SKNode类中隐藏了一个属性记录node的原始size，暂命名为originSize，frame中记录了node当前的size。
 每当setScale方法调用时，frame.size.width = originSize.width*scale,frame.size.height = originSize.height*scale,frame的起点随之变化（node.position不变的前提下）。
 每当xScale变化时，frame.size.width = originSize.width*xScale,frame的起点随之变化（node.position不变的前提下）。
 yScalse同理。
 因此，如果我连续两次调用方法 [self setScale:2.f],node的frame会变为原来的2倍而不是4倍，因为originSize是不变的。
 
 每当zRotation变化弧度z时，node会旋转相应的弧度，z>0时，逆时针旋转。旋转后的frame仍为与node坐标系xy轴分别平行的长方形。
 因此，对frame来说，node旋转只会改变frame的大小，frame并不关心node旋转了多少角度。
 
 综上，frame是一个能套住node中所有内容的最小长方形，这个长方形的边与node的父node坐标系的xy轴平行。frame只对node的父node坐标系负责，父node的frame发生变化时，子node的frame不变。也就是说，父node的发生伸缩或旋转时，子node的frame不会发生变化。

 */
@property (nonatomic, readonly) CGRect frame;

/**
 Calculates the bounding box including all child nodes in parents coordinate system.
 */
- (CGRect)calculateAccumulatedFrame;

/**
 The position of the node in the parent's coordinate system
 node初始化时，如果不显式的赋值，position默认为父node坐标系的原点。
 */
@property (nonatomic) CGPoint position;

/**
 The z-order of the node (used for ordering). Negative z is "into" the screen, Positive z is "out" of the screen. A greater zPosition will sort in front of a lesser zPosition.
 The default value is 0.0. The positive z axis is projected toward the viewer so that nodes with larger z values are closer to the viewer. When a node tree is rendered, the height of each node (in absolute coordinates) is calculated and then all nodes in the tree are rendered from smallest z value to largest z value. If multiple nodes share the same z position, those nodes are sorted so that parent nodes are drawn before their children, and siblings are rendered in the order that they appear in their parent’s children array. Hit-testing is processed in the opposite order.
 zPosition排序规则：
    1.父节点总是小于子节点。
    2.同一父节点的子节点，zPosition由大到小排序，zPositon相同时，按照子节点在父节点Array中的下标排序（即越晚插入，zPosition越大）。
 
 zPosition越大，node越晚被渲染，也就是说，zPosition大的node图像会覆盖zPosition小的node图像，子节点的图像总是会覆盖父节点的图像。
 根据实测，发生碰撞时，触发过程反过来，zPosition越小，越先触发didBeginContact方法。
 */
@property (nonatomic) CGFloat zPosition;

/**
 The Euler rotation about the z axis (in radians)
 */
@property (nonatomic) CGFloat zRotation;

/**
 The scaling in the X axis
 */
@property (nonatomic) CGFloat xScale;
/**
 The scaling in the Y axis
 */
@property (nonatomic) CGFloat yScale;

/**
 The speed multiplier applied to all actions run on this node. Inherited by its children.
 speed会改变action声明时设置的持续时间([SKAction moveTo: duration:])，同时action结束事件的触发事件也会提前或延后([self runAction: ompletion:])。
 */
@property (nonatomic) CGFloat speed;

/**
 Alpha of this node (multiplied by the output color to give the final result)
 */
@property (nonatomic) CGFloat alpha;

/**
 Controls whether or not the node's actions is updated or paused.
 父节点停止，子节点也会停止。
 根据实测，该属性在两个时间点前赋值无效，总是会变为YES，一是scene初始化完成时，二是node加入父node或scene时。
 在以上两个时间点之后的第一个update方法开始执行之后，对paused的修改将会生效。
 */
@property (nonatomic, getter = isPaused) BOOL paused;

/**
 Controls whether or not the node and its children are rendered.
 When hidden, a node and its descendants are not rendered. However, they still exist in the scene and continue to interact in other ways. For example, the node’s actions still run and the node can still be intersected with other nodes. The default value is NO.
 
hidden为YES时，node不会被渲染，但是node仍然可以触发碰撞事件，会被力场影响。可以理解为alpha为0的情况。
 猜测：hidden为YES与alpha为0的区别是，alpha为0时，仍然需要计算node的渲染。hidden为YES时，渲染不需要计算。
 */
@property (nonatomic, getter = isHidden) BOOL hidden;

/**
 Controls whether or not the node receives touch events
 */
@property (nonatomic, getter=isUserInteractionEnabled) BOOL userInteractionEnabled;

/**
 The parent of the node.
 
 If this is nil the node has not been added to another group and is thus the root node of its own graph.
 */
@property (nonatomic, readonly) SKNode *parent;


/**
 The children of this node.
 
 */
@property (nonatomic, readonly) NSArray *children;


/**
 The client assignable name.
 
 In general, this should be unique among peers in the scene graph.
 */
@property (nonatomic, copy) NSString *name;

/**
 The scene that the node is currently in.
 该属性父node与子node相同
 */
@property (nonatomic, readonly) SKScene* scene;

/**
 Physics body attached to the node, with synchronized scale, rotation, and position
 */
@property (nonatomic, retain) SKPhysicsBody *physicsBody;

/**
 An optional dictionary that can be used to store your own data in a node. Defaults to nil.
 */
@property (nonatomic, retain) NSMutableDictionary *userData;

/**
 Kinematic constraints, used in IK solving
 ######################################################################
 */
@property (nonatomic, copy) SKReachConstraints *reachConstraints;


/**
 Optional array of SKConstraints
 Constraints are evaluated each frame after actions and physics.
 The node's transform will be changed to satisfy the constraint.
 ######################################################################
 
 */
@property (nonatomic, copy) NSArray *constraints;

/**
 Sets both the x & y scale
 
 @param scale the uniform scale to set.
 */
- (void)setScale:(CGFloat)scale;

/**
 Adds a node as a child node of this node
 
 The added node must not have a parent.
 
 @param node the child node to add.
 
 error:Attemped to add a SKNode which already has a parent
 */
- (void)addChild:(SKNode *)node;

- (void)insertChild:(SKNode *)node atIndex:(NSInteger)index;

- (void)removeChildrenInArray:(NSArray *)nodes;
- (void)removeAllChildren;

- (void)removeFromParent;

/**
 当存在同名node时，在父node的children Array中，下标最小的将被返回
 */
- (SKNode *)childNodeWithName:(NSString *)name;
/**
 stop:A pointer to a Boolean variable. Your block can set this to YES to terminate the enumeration.
 当需要停止枚举时，在代码块中将stop置为YES
 */
- (void)enumerateChildNodesWithName:(NSString *)name usingBlock:(void (^)(SKNode *node, BOOL *stop))block;

/**
 * Simplified shorthand for enumerateChildNodesWithName that returns an array of the matching nodes.
 * This allows subscripting of the form:
 *      NSArray *childrenMatchingName = node[@"name"]
 *
 * or even complex like:
 *      NSArray *siblingsBeginningWithA = node[@"../a*"]
 *
 * @param name An Xpath style path that can include simple regular expressions for matching node names.
 * @see enumerateChildNodesWithName:usingBlock:
 */
- (NSArray *)objectForKeyedSubscript:(NSString *)name NS_AVAILABLE(10_10, 8_0);

/* Returns true if the specified parent is in this node's chain of parents */

- (BOOL)inParentHierarchy:(SKNode *)parent;
/**
 The new action is processed the next time the scene’s animation loop is processed.
 */
- (void)runAction:(SKAction *)action;
- (void)runAction:(SKAction *)action completion:(void (^)())block;
- (void)runAction:(SKAction *)action withKey:(NSString *)key;

- (BOOL)hasActions;
- (SKAction *)actionForKey:(NSString *)key;

- (void)removeActionForKey:(NSString *)key;
- (void)removeAllActions;

- (BOOL)containsPoint:(CGPoint)p;
/**
 A descendant in the subtree that intersects the point, or the receiver if no nodes intersect the point. If multiple descendants intersect the point, the deepest node in the tree is returned. If multiple nodes are at the same level, the intersecting node with the largest z position is returned.
 返回在该位置的所有node中，最上层的node，也就是zPosition最大的node
 */
- (SKNode *)nodeAtPoint:(CGPoint)p;
- (NSArray *)nodesAtPoint:(CGPoint)p;

- (CGPoint)convertPoint:(CGPoint)point fromNode:(SKNode *)node;
- (CGPoint)convertPoint:(CGPoint)point toNode:(SKNode *)node;

/* Returns true if the bounds of this node intersects with the transformed bounds of the other node, otherwise false
 The two nodes are considered to intersect if their frames intersect. The children of both nodes are ignored in this test.
 判断两个node的frame是否有重叠，他们的子node不被考虑在内
 */

- (BOOL)intersectsNode:(SKNode *)node;

/* Returns true if this node has equivalent content to the other object, otherwise false */

- (BOOL)isEqualToNode:(SKNode *)node;

@end


/**
 Provided for easy transformation of UITouches coordinates to SKNode coordinates should you choose to handle touch events natively.
 */
#if TARGET_OS_IPHONE
//Allow conversion of UITouch coordinates to scene-space
@interface UITouch (SKNodeTouches)
- (CGPoint)locationInNode:(SKNode *)node;
- (CGPoint)previousLocationInNode:(SKNode *)node;
@end
#else
@interface NSEvent (SKNodeEvent)
- (CGPoint)locationInNode:(SKNode *)node;
@end
#endif
